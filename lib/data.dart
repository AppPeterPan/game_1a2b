import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static final SharedPreferencesUtil _spu =
      SharedPreferencesUtil._privConstructor();

  factory SharedPreferencesUtil() => _spu;

  SharedPreferencesUtil._privConstructor();

  final String _keyBest = 'best';
  final String _keyHistory = 'history';

  Future<int?> getBsetScore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getInt(_keyBest);
  }

  void resetBestScore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(_keyBest);
  }

  Future<int> setBestScore(score) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var bestScore = sp.getInt(_keyBest);
    if (bestScore is int && score > bestScore) {
      return bestScore;
    } else {
      sp.setInt(_keyBest, score);
      return score;
    }
  }

  Future<List<String>?> getHistory() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getStringList(_keyHistory);
  }

  void resetHistory() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(_keyHistory);
  }

  void setHistory(List<String> history) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList(_keyHistory, history);
  }
}
