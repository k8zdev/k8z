import 'dart:convert';
import 'dart:io';

import 'package:k8zdev/common/ops.dart';

/// 简单的XOR加密工具
String encryptWithKey(String data, String key) {
  final keyBytes = utf8.encode(key);
  final dataBytes = utf8.encode(data);
  
  final encryptedBytes = <int>[];
  for (int i = 0; i < dataBytes.length; i++) {
    encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
  }
  
  return base64.encode(encryptedBytes);
}

void main() async {
  const key = 'k8zdev-demo-key-2024';
  
  // 读取演示配置文件
  final configFile = File('tmp/k8z-demo.config');
  if (!await configFile.exists()) {
    talker.log('错误: 找不到演示配置文件 tmp/k8z-demo.config');
    exit(1);
  }
  
  final configContent = await configFile.readAsString();
  
  // 加密配置
  final encryptedContent = encryptWithKey(configContent, key);
  
  // 保存加密后的文件
  final encryptedFile = File('tmp/k8z-demo.config.encrypted');
  await encryptedFile.writeAsString(encryptedContent);
  
  talker.log('演示配置已加密并保存到: ${encryptedFile.path}');
  talker.log('加密内容长度: ${encryptedContent.length} 字符');
  talker.log('请将此文件上传到: https://static.k8z.dev/k8z-demo/kubeconfig');
}