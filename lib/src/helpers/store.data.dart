import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static String orderId = 'order_id';
  static String paymentMethod = 'cash';

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  Future<void> writeOrderId(String value, String key) async {
    await storage.write(key: key, value: value);
  }

  Future<String> readOrderId(String key) async {
    return await storage.read(key: key);
  }



   Future<void> cash(String value, String key) async {
    await storage.write(key: key, value: value);
  }

    Future<String> readCash(String key) async {
    return await storage.read(key: key);
  }





}
