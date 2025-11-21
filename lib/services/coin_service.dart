import 'package:shared_preferences/shared_preferences.dart';

class CoinService {
  CoinService._();

  static const _coinsKey = 'coin_service_current_coins';

  static Future<void> initializeNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_coinsKey)) {
      await prefs.setInt(_coinsKey, 0);
    }
  }

  static Future<int> getCurrentCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinsKey) ?? 0;
  }

  static Future<bool> addCoins(int coins) async {
    if (coins <= 0) return false;
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_coinsKey) ?? 0;
    return prefs.setInt(_coinsKey, current + coins);
  }

  static Future<bool> setCoins(int coins) async {
    if (coins < 0) return false;
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_coinsKey, coins);
  }
}

