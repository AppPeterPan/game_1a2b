import 'package:game_1a2b/game_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  static final SPUtil _spu = SPUtil._privConstructor();

  factory SPUtil() => _spu;

  SPUtil._privConstructor();

  final String _keyBest = 'best';
  final String _keyHistory = 'history';

  Future<void> updateNewVersion() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = sp.getInt(_keyBest);
    if (data is int) {
      await sp.setInt('${_keyBest}N4', data);
      await sp.remove(_keyBest);
    }
  }

  Future<List<Map<String, int?>>> getBsetScores(
      {required List<int> numLengthList}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (numLengthList.contains(4)) {
      await updateNewVersion();
    }
    List<Map<String, int?>> datas = [];
    for (int i = 0; i < numLengthList.length; i++) {
      datas.add({
        'nl': numLengthList[i],
        'br': sp.getInt('${_keyBest}N${numLengthList[i]}')
      });
    }
    return datas;
  }

  Future<void> resetBestScore({required List<int> numLengthList}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    for (int i = 0; i < numLengthList.length; i++) {
      await sp.remove('${_keyBest}N${numLengthList[i]}');
    }
  }

  Future<int> setBestScore({required int numLength, required int score}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (numLength == 4) {
      await updateNewVersion();
    }
    var data = sp.getInt('${_keyBest}N$numLength');
    if (data is int && score > data) {
      return data;
    } else {
      await sp.setInt('${_keyBest}N$numLength', score);
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
