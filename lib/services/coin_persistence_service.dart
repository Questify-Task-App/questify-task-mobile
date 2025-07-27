// lib/services/coin_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class CoinPersistenceService {
  static const String _key = 'coins';
  
  Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  Future<void> addCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final currentCoins = await getCoins();
    await prefs.setInt(_key, currentCoins + amount);
  }
}