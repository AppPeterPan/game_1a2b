import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static final SharedPreferencesUtil _spu =
      SharedPreferencesUtil._privConstructor();

  factory SharedPreferencesUtil() => _spu;

  SharedPreferencesUtil._privConstructor();

  Future getBsetScore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getInt('best');
  }

  void resetBestScore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('best');
  }

  Future setBestScore(score) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var bestScore = sp.getInt('best');
    if (bestScore == null || score < bestScore) {
      sp.setInt('best', score);
      return score;
    } else {
      return bestScore;
    }
  }
}