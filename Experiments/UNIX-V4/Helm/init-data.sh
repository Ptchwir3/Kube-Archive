#!/bin/bash
# Initialize Unix V4 data volume
# Run this once before deploying

set -e

NAMESPACE="unix-v4"
PVC_NAME="unix-v4-data"
DISK_URL="http://squoze.net/UNIX/v4/disk.rk"

echo "=== Unix V4 Data Volume Initialization ==="

# Create namespace if it doesn't exist
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# Apply just the PVC first
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ${PVC_NAME}
  namespace: ${NAMESPACE}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
EOF

# Wait for PVC to be bound (if using dynamic provisioning)
echo "Waiting for PVC to be ready..."
kubectl wait --for=jsonpath='{.status.phase}'=Bound pvc/${PVC_NAME} -n ${NAMESPACE} --timeout=60s || true

# Run a temporary pod to download the disk image
echo "Downloading disk.rk to PVC..."
kubectl run unix-v4-init --rm -i --restart=Never \
  --namespace=${NAMESPACE} \
  --image=curlimages/curl:latest \
  --overrides='{
    "spec": {
      "containers": [{
        "name": "unix-v4-init",
        "image": "curlimages/curl:latest",
        "command": ["sh", "-c", "cd /data && curl -L -O '"${DISK_URL}"' && ls -la /data"],
        "volumeMounts": [{
          "name": "data",
          "mountPath": "/data"
        }]
      }],
      "volumes": [{
        "name": "data",
        "persistentVolumeClaim": {
          "claimName": "'"${PVC_NAME}"'"
        }
      }]
    }
  }'

echo ""
echo "=== Initialization complete ==="
echo "Now run: kubectl apply -f unix-v4-deployment.yaml"
echo "Then connect: kubectl exec -it deploy/unix-v4 -n unix-v4 -- telnet localhost 5555"
