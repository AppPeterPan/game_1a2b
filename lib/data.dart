import 'package:game_1a2b/game_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  static final SPUtil _spu = SPUtil._privConstructor();

  factory SPUtil() => _spu;

  SPUtil._privConstructor();

  final String _keyBest = 'best';
  final String _keyHistory = 'history';
  final String _keyRated = 'rated';

  Future<bool> checkRated() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(_keyRated) ?? false;
  }

  Future<void> rated() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool(_keyRated, true);
  }

  Future<void> updateNewVersion() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = sp.getInt(_keyBest);
    if (data is int) {
      await sp.setInt('${_keyBest}N4', data);
      await sp.remove(_keyBest);
    }
  }

  Future<int?> getBsetScore({required String tag}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (tag == '4') {
      await updateNewVersion();
    }

    return sp.getInt('${_keyBest}N$tag');
  }

  Future<List<Map<String, dynamic>>> getBsetScores(
      {required List<String> tagList}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (tagList.contains('4')) {
      await updateNewVersion();
    }
    List<Map<String, dynamic>> datas = [];
    for (int i = 0; i < tagList.length; i++) {
      datas.add(
          {'nl': tagList[i], 'br': sp.getInt('${_keyBest}N${tagList[i]}')});
    }
    return datas;
  }

  Future<void> resetBestScore({required List<String> tagList}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    for (int i = 0; i < tagList.length; i++) {
      await sp.remove('${_keyBest}N${tagList[i]}');
    }
  }

  Future<int> setBestScore({required String tag, required int score}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (tag == '4') {
      await updateNewVersion();
    }
    var data = sp.getInt('${_keyBest}N$tag');
    if (data is int && score > data) {
      return data;
    } else {
      await sp.setInt('${_keyBest}N$tag', score);
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
