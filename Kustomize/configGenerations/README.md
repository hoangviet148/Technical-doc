## ConfigMap generation and rolling updates

Kustomize provides two ways of adding ConfigMap in one `kustomization`, either by declaring ConfigMap as a [resource] or declaring ConfigMap from a ConfigMapGenerator.

## Review

Changing the data held by a live ConfigMap in a cluster is considered bad practice. Deployments have no means to know that the ConfigMaps they refer to have changed, so such updates have no effect.

The recommended way to change a deployment's
configuration is to

1.  create a new ConfigMap with a new name,
1.  patch the _deployment_, modifying the name value of
    the appropriate `configMapKeyRef` field.

## How this works with kustomize
The ConfigMap name is prefixed by staging-, per the namePrefix field in $OVERLAYS/staging/kustomization.yaml.

The ConfigMap name is suffixed by -v1, per the nameSuffix field in $OVERLAYS/staging/kustomization.yaml.

The suffix to the ConfigMap name is generated from a hash of the maps content - in this case the name suffix is 5276h4th55