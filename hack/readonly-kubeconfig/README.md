# Read-Only Kubernetes User Setup

This guide explains how to create a read-only kubeconfig for Kubernetes clusters. Read-only users can view resources (get/list/watch) but cannot modify them.

## Overview

### RBAC Permissions

Read-only permissions include the following verbs:
- `get` - Retrieve a single resource
- `list` - List resources
- `watch` - Watch for resource changes

### Security Considerations

**Important**: ServiceAccount Secret tokens are long-lived and do not expire. For production environments:
- Implement regular token rotation
- Enable Kubernetes audit logging
- Follow the principle of least privilege
- Consider using time-limited tokens via `kubectl create token` for temporary access

## Directory Structure

```
readonly-kubeconfig/
├── README.md                          # This file
├── rbac/                              # RBAC and ServiceAccount manifests
│   ├── namespace-readonly.yaml        # Namespace-level read-only access
│   ├── cluster-readonly.yaml          # Cluster-level read-only access
│   └── token-secret.yaml              # Token Secret configuration
└── examples/
    └── kubeconfig-readonly.yaml       # Example kubeconfig template
```

## Quick Start

### Step 1: Apply RBAC Manifests

```bash
# For namespace-level access (default namespace)
kubectl apply -f rbac/namespace-readonly.yaml

# For cluster-level access (all namespaces)
kubectl apply -f rbac/cluster-readonly.yaml
```

### Step 2: Create Token Secret

```bash
kubectl apply -f rbac/token-secret.yaml
```

### Step 3: Retrieve Token

```bash
# Get the token from the secret
TOKEN=$(kubectl get secret readonly-user-token -o jsonpath='{.data.token}' | base64 -d)
echo $TOKEN
```

### Step 4: Generate Kubeconfig Manually

```bash
# Get cluster information
CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')
SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CLUSTER_CA=$(kubectl config view --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')

# Create kubeconfig file
cat > readonly-config.yaml <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${CLUSTER_CA}
    server: ${SERVER}
  name: ${CLUSTER_NAME}
users:
- name: readonly-user
  user:
    token: ${TOKEN}
contexts:
- context:
    cluster: ${CLUSTER_NAME}
    user: readonly-user
  name: readonly-context
current-context: readonly-context
EOF
```

### Step 5: Verify Permissions

```bash
# Test with the new kubeconfig
kubectl --kubeconfig=readonly-config.yaml get pods

# Verify write permission is denied
kubectl --kubeconfig=readonly-config.yaml delete pod test

# Check current permissions
kubectl --kubeconfig=readonly-config.yaml auth can-i get pods
kubectl --kubeconfig=readonly-config.yaml auth can-i delete pods
```

## RBAC Manifests

### Namespace-Level Read-Only Access

The `namespace-readonly.yaml` creates:
- ServiceAccount: `readonly-user`
- Role: `readonly-role` (limited to a specific namespace)
- RoleBinding: `readonly-binding`

### Cluster-Level Read-Only Access

The `cluster-readonly.yaml` creates:
- ServiceAccount: `readonly-user`
- ClusterRole: `cluster-readonly` (access to all namespaces)
- ClusterRoleBinding: `cluster-readonly-binding`

## Token Rotation

For security, rotate ServiceAccount tokens periodically:

```bash
# Delete the old token secret
kubectl delete secret readonly-user-token

# Create a new secret
kubectl apply -f rbac/token-secret.yaml

# Wait for token generation (5-10 seconds), then retrieve
TOKEN=$(kubectl get secret readonly-user-token -o jsonpath='{.data.token}' | base64 -d)

# Update kubeconfig with new token
sed -i '' "s/token: .*/token: ${TOKEN}/" readonly-config.yaml
```

## Encrypting Kubeconfig

### Project-Specific Encryption (XOR)

The k8z project uses a simple XOR-based encryption in `tools/encrypt_demo_config.dart`:

```dart
import 'dart:convert';

/// Simple XOR encryption tool
String encryptWithKey(String data, String key) {
  final keyBytes = utf8.encode(key);
  final dataBytes = utf8.encode(data);

  final encryptedBytes = <int>[];
  for (int i = 0; i < dataBytes.length; i++) {
    encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
  }

  return base64.encode(encryptedBytes);
}

/// Decryption (same algorithm)
String decryptWithKey(String encryptedData, String key) {
  final encryptedBytes = base64.decode(encryptedData);
  final keyBytes = utf8.encode(key);

  final decryptedBytes = <int>[];
  for (int i = 0; i < encryptedBytes.length; i++) {
    decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
  }

  return utf8.decode(decryptedBytes);
}
```

**Usage:**
```dart
void main() async {
  const key = 'your-secret-key-here';

  // Read kubeconfig
  final kubeconfigContent = await File('readonly-config.yaml').readAsString();

  // Encrypt
  final encryptedContent = encryptWithKey(kubeconfigContent, key);
  await File('readonly-config.yaml.encrypted').writeAsString(encryptedContent);

  // Decrypt
  final encrypted = await File('readonly-config.yaml.encrypted').readAsString();
  final decrypted = decryptWithKey(encrypted, key);
}
```

**Note:** XOR encryption is simple and easy to implement, but is not cryptographically secure for production use. For enhanced security, consider using AES-based encryption.

### Command Line Encryption (Optional)

For additional encryption options:

#### Using OpenSSL

```bash
# Encrypt with AES-256-CBC
openssl enc -aes-256-cbc -salt -pbkdf2 -in readonly-config.yaml -out readonly-config.yaml.enc

# Decrypt
openssl enc -d -aes-256-cbc -pbkdf2 -in readonly-config.yaml.enc -out readonly-config.yaml
```

#### Using GPG

```bash
# Encrypt with GPG
gpg --encrypt --recipient user@example.com --output readonly-config.yaml.gpg readonly-config.yaml

# Decrypt
gpg --decrypt readonly-config.yaml.gpg > readonly-config.yaml
```

## Customization

### Adding More Resources

Edit the Role or ClusterRole rules in the YAML files:

```yaml
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "secrets", "namespaces", "events"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets", "daemonsets"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["batch"]
  resources: ["jobs", "cronjobs"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses", "networkpolicies"]
  verbs: ["get", "list", "watch"]
```

### Restricting Resource Access

Specify specific resource names with `resourceNames`:

```yaml
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  resourceNames: ["allowed-config"]
  verbs: ["get", "list", "watch"]
```

## Troubleshooting

### Forbidden Error

If you get `Forbidden (403)` errors:
1. Check RoleBinding/ClusterRoleBinding is correctly created
2. Verify the ServiceAccount name matches
3. Ensure namespace is correct for namespace-level access

### Token Not Found

If token retrieval fails:
```bash
# List secrets for the ServiceAccount
kubectl get secrets | grep readonly-user

# Describe the secret to check annotations
kubectl describe secret readonly-user-token
```

### Permission Verification

Use `kubectl auth can-i` to debug permissions:
```bash
kubectl --kubeconfig=readonly-config.yaml auth can-i --list
```

## Security Best Practices

1. **Minimize Privileges**: Only grant access to necessary resources
2. **Regular Rotation**: Rotate tokens every 60-90 days
3. **Audit Logging**: Enable Kubernetes audit logs
4. **Encrypt Kubeconfigs**: Store encrypted kubeconfigs
5. **Network Policies**: Restrict API server access
6. **Use Strong Encryption**: Prefer AES/XOR with strong keys for sensitive data

## References

- [Kubernetes RBAC Documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Kubernetes ServiceAccount Documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
- [Authenticating with ServiceAccount Tokens](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#manually-create-a-long-lived-api-token-for-a-serviceaccount)
