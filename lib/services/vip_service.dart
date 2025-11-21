import 'package:shared_preferences/shared_preferences.dart';

class VipService {
  VipService._();

  static const String _vipActiveKey = 'vip_is_active';
  static const String _vipPurchaseDateKey = 'vip_purchase_date';
  static const String _vipProductIdKey = 'vip_product_id';
  static const String _vipDurationDaysKey = 'vip_duration_days';

  static Future<void> activateVip({
    required String productId,
    required String purchaseDate,
    int durationDays = 7,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vipActiveKey, true);
    await prefs.setString(_vipPurchaseDateKey, purchaseDate);
    await prefs.setString(_vipProductIdKey, productId);
    await prefs.setInt(_vipDurationDaysKey, durationDays);
  }

  static Future<void> deactivateVip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vipActiveKey, false);
    await prefs.remove(_vipPurchaseDateKey);
    await prefs.remove(_vipProductIdKey);
    await prefs.remove(_vipDurationDaysKey);
  }

  static Future<bool> isVipActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vipActiveKey) ?? false;
  }

  static Future<bool> isVipExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final purchaseDateStr = prefs.getString(_vipPurchaseDateKey);
    final durationDays = prefs.getInt(_vipDurationDaysKey) ?? 7;

    if (purchaseDateStr == null) return true;

    try {
      final purchaseDate = DateTime.parse(purchaseDateStr);
      final expiryDate = purchaseDate.add(Duration(days: durationDays));
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }

  static Future<int> getVipRemainingDays() async {
    final prefs = await SharedPreferences.getInstance();
    final purchaseDateStr = prefs.getString(_vipPurchaseDateKey);
    final durationDays = prefs.getInt(_vipDurationDaysKey) ?? 7;

    if (purchaseDateStr == null) return 0;

    try {
      final purchaseDate = DateTime.parse(purchaseDateStr);
      final expiryDate = purchaseDate.add(Duration(days: durationDays));
      final now = DateTime.now();
      if (now.isAfter(expiryDate)) return 0;
      return expiryDate.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }

  static Future<String?> getVipPurchaseDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_vipPurchaseDateKey);
  }

  static Future<String?> getVipProductId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_vipProductIdKey);
  }
}

