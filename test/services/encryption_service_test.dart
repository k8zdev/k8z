import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/encryption_service.dart';
import 'dart:convert';

void main() {
  group('EncryptionService', () {
    test('should encrypt and decrypt data correctly', () async {
      const key = 'k8zdev-demo-key-2024';
      const originalData = 'Hello, World!';
      
      // Encrypt (simulate what the tool does)
      final keyBytes = utf8.encode(key);
      final dataBytes = utf8.encode(originalData);
      
      final encryptedBytes = <int>[];
      for (int i = 0; i < dataBytes.length; i++) {
        encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      final encryptedData = base64.encode(encryptedBytes);
      
      // Decrypt using service
      final decryptedData = await EncryptionService.decryptWithKey(
        encryptedData,
        key,
      );
      
      expect(decryptedData, equals(originalData));
    });
    
    test('should verify data integrity', () async {
      const data = 'test data';
      const expectedHash = 'e27d8d9c8d8b8c8d8e8f8a8b8c8d8e8f8a8b8c8d8e8f8a8b8c8d8e8f8a8b8c8d';
      
      // This will fail because we're using a dummy hash, but tests the method
      final result = await EncryptionService.verifyIntegrity(data, expectedHash);
      expect(result, isFalse);
    });
  });
}