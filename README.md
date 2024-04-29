# devbox
Self-contained development utilities. Includes tmux, nvim, git &amp; more 👨‍💻

## Usage

To start an ephemeral Docker image locally:
```console
docker run -it --rm ghcr.io/brenodt/devbox:main
```

## Example K8S Pod definition

Here's an example pod definition using this container:
```yaml
# pod-helper.yaml
#
# This is a helper pod to debug and work locally from within the cluster,
# with access to their volume mounts and secrets.
#
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: live-helper
  name: live-helper
  namespace: default
spec:
  containers:
    - command:
        - tail
        - -f
        - /dev/null
      image: ghcr.io/brenodt/devbox:main
      imagePullPolicy: Always
      name: live-helper
      envFrom:
        - secretRef:
            # Connecting to an Opaque secret
            name: shared-cronjob-config
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
        limits:
          cpu: 150m
          memory: 256Mi
      volumeMounts:
        # Connecting to volumes from the cluster
        - name: dump-volume
          mountPath: /dump

  volumes:
    - name: dump-volume
      persistentVolumeClaim:
        claimName: cronjob-dumps-pvc

```

To apply and connect, run:
```console
kubectl apply -f pod-helper.yaml
kubectl exec pod-helper -it -- /bin/bash
```

