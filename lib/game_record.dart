import 'dart:convert';

class GameRecord {
  final DateTime dateTime;
  final int gameMode;
  final int times;
  GameRecord(
      {required this.dateTime, required this.gameMode, required this.times});

  GameRecord.fromJson(String json)
      : dateTime =
            DateTime.fromMillisecondsSinceEpoch(jsonDecode(json)['dateTime']),
        gameMode = jsonDecode(json)['gameMode'],
        times = jsonDecode(json)['times'];

  String toJson() => jsonEncode({
        'dateTime': dateTime.millisecondsSinceEpoch,
        'gameMode': gameMode,
        'times': times
      });
}
