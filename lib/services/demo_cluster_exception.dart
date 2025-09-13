/// 演示集群相关异常
class DemoClusterException implements Exception {
  final String message;
  final DemoClusterErrorType type;
  
  const DemoClusterException(this.message, this.type);
  
  @override
  String toString() => 'DemoClusterException: $message';
}

/// 演示集群错误类型
enum DemoClusterErrorType {
  networkError,
  decryptionError,
  validationError,
  configurationError,
}