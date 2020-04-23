# Kubernetes uses QoS

Kubernetes uses QoS classes to make decisions about scheduling and evicting Pods.

# For a Pod to be given a QoS class of Guaranteed:

- Every Container in the Pod must have a memory limit and a memory request (or only limit), and they must be the same.
- Every Container in the Pod must have a CPU limit and a CPU request (or only limit), and they must be the same.<br>
Both conditions should be fulfilled. If we will have only cpu or memory value QoS will have Burstable class!

```
    resources:
      limits:
        cpu: "0.3"
        memory: "200Mi"
      requests:
        cpu: "0.3"
        memory: "200Mi"
```

OR

```
    resources:
      limits:
        cpu: 0.3
        memory: 200Mi
```

# A Pod is given a QoS class of Burstable if:

The Pod does not meet the criteria for QoS class Guaranteed. At least one Container in the Pod has a memory or CPU request.

# For a Pod to be given a QoS class of BestEffort:

The Containers in the Pod must not have any memory or CPU limits or requests. <br>Also they can be defined explicitly with zero-value
```
    resources:
      limits:
        cpu: 0
        memory: 0
```
<br><br>
# NameSpace QoS

Absolutelly the same rules we have for NameSpace QoS.<br>

QoS-for-namespace-Burstable.yml
```
apiVersion: v1
kind: LimitRange
metadata:
  name: qos-for-namespace-burstable 
spec:
  limits:
  - defaultRequest:
      cpu: "0.1"
    type: Container
```

`The value "defaultRequest" uses only for NameSpace abstraction.`


QoS-for-namespace-Guaranteed.yml
```
apiVersion: v1
kind: LimitRange
metadata:
  name: qos-for-namespace
spec:
  limits:
  - default:
      cpu: 100m
      memory: 256Mi
    defaultRequest:
      cpu: 100m
      memory: 256Mi
    type: Container
```