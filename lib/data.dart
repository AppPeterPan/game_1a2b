import 'package:game_1a2b/game_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  static final SPUtil _spu = SPUtil._privConstructor();

  factory SPUtil() => _spu;

  SPUtil._privConstructor();

  final String _keyBest = 'best';
  final String _keyHistory = 'history';

  Future<int?> getBsetScore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getInt(_keyBest);
  }

  Future<void> resetBestScore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove(_keyBest);
  }

  Future<int> setBestScore(score) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = sp.getInt(_keyBest);
    if (data is int && score > data) {
      return data;
    } else {
      sp.setInt(_keyBest, score);
      return score;
    }
  }

  Future<List<GameRecord>> getHistory() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = sp.getStringList(_keyHistory);
    if (data is List<String>) {
      return [
        for (int i = 0; i < data.length; i++) GameRecord.fromJson(data[i])
      ];
    } else {
      return [];
    }
  }

  Future<void> resetHistory() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove(_keyHistory);
  }

  Future<void> addHistory(GameRecord gameRecord) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> data = sp.getStringList(_keyHistory) ?? [];
    data.add(gameRecord.toJson());
    await sp.setStringList(_keyHistory, data);
  }
}
