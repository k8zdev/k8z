# CHANGELOG

## v1.1.0
1. fix: timeout config not persist saved.
2. fix: current cluster is null will panic.
3. add: slide pane to delete cluster.
4. add: action buttons to resource detail page, include scale replicas of workload sets and route to yaml info page to export resource.
5. add: details page for helm releases, endpoints, ingresses, services, configmaps, secrets, service accounts, crds, namespaces, nodes, pvcs, pvs, storage class, daemon sets, deployments, pods, stateful sets.


## v1.0.0
1. Implement add clusters from kubeconfig file.
2. Show cpu/memory etc metrics of current cluster at home page.
3. Implement resource list pages:
   - Nodes
   - Events
   - Namespaces
   - CRDs
   - ConfigMaps
   - Secrets
   - ServiceAccounts(SAs)
   - StorageClass
   - Persistent Volumes (PVs)
   - Persistent Volume Claims (PVCs)

4. Implement workload list pages:
   - Pods
   - DaemonSets
   - Deployments
   - StatefulSets
   - Endpoints
   - Ingresses
   - Services