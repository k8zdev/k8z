import 'dart:convert';
import 'package:crypto/crypto.dart';

/// 加密服务，用于处理演示集群配置的解密
class EncryptionService {
  /// 使用AES对称密钥解密数据
  static Future<String> decryptWithKey(
    String encryptedData,
    String key,
  ) async {
    try {
      // 对于演示目的，我们使用简单的XOR解密
      // 在生产环境中应该使用真正的AES加密
      final keyBytes = utf8.encode(key);
      final encryptedBytes = base64.decode(encryptedData);
      
      final decryptedBytes = <int>[];
      for (int i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      return utf8.decode(decryptedBytes);
    } catch (e) {
      throw EncryptionException(
        '解密失败: ${e.toString()}',
        EncryptionErrorType.decryptionError,
      );
    }
  }

  /// 验证数据完整性
  static Future<bool> verifyIntegrity(
    String data,
    String expectedHash,
  ) async {
    try {
      final dataBytes = utf8.encode(data);
      final actualHash = sha256.convert(dataBytes).toString();
      return actualHash == expectedHash;
    } catch (e) {
      throw EncryptionException(
        '完整性验证失败: ${e.toString()}',
        EncryptionErrorType.validationError,
      );
    }
  }
}

/// 加密相关异常
class EncryptionException implements Exception {
  final String message;
  final EncryptionErrorType type;

  const EncryptionException(this.message, this.type);

  @override
  String toString() => 'EncryptionException: $message';
}

/// 加密错误类型
enum EncryptionErrorType {
  decryptionError,
  validationError,
  keyParsingError,
}