# CHANGELOG

## v1.3.0
1. add more Actions type for details page: logs and terminal, show creation time on the detail page.
2. add logs, terminal action button to pod detail to show logs and terminal modal.
3. implement modal widget to confirm delete resource, and real delete resource when confirmed.
4. add container id and image id to pod sections.
5. implement delete pod feature for pods list slidable pane.
6. implement pull down to refresh deployments list, network resources list, DS、STS、Pods, applications, config and storage resources list.

## v1.2.0
1. Iterative upgrade resource details page:
	1. Add resourceVersion, selfLink, uid, finalizers tiles.
	2. Hidden labels, annotations tiles on detail page if null.
	3. Implements rendering of data in configmap, highlights data content, and adds the function of copying to clipboard.
	4. Implement secret data item tiles, decode and display base64 format, and support copying field keys, encrypted data and decoded data to the clipboard.
	5. Implement pod spec tiles, including: init container, container, DNS policy, host network, host name, image pull secret.
	6. Displays a list of image pull secret names in a modal.
	7. Use a modal box to display the image pulling strategy, image, command, parameter, environment variable, port, readiness probe, startup probe, and survival probe of the pod spec initial container and each container in the container.

2. Bug fixes and improvements:
	1. When automatically matching the system language, the language code cannot be obtained correctly.
	2. Refactor the current cluster provider.

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