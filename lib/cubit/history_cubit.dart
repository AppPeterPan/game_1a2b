import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/game_record.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryState(gameRecordList: [])) {
    loadData();
  }

  void loadData() {
    SharedPreferencesUtil().getHistory().then((historyData) {
      List<GameRecord> gameRecordList = [];
      if (historyData is List<String>) {
        try {
          gameRecordList = [
            for (int i = 0; i < historyData.length; i++)
              GameRecord.fromJson(historyData[i])
          ];
        } catch (e) {
          return;
        }
      }
      emit(HistoryState(gameRecordList: gameRecordList));
    });
  }

  void addRecord(GameRecord gameRecord) {
    List<GameRecord> gameRecordList = super.state.gameRecordList;
    gameRecordList.add(gameRecord);
    List<String> historyData = [
      for (int i = 0; i < gameRecordList.length; i++) gameRecordList[i].toJson()
    ];
    SharedPreferencesUtil().setHistory(historyData);
    loadData();
  }

  void deleteAllRecord() {
    SharedPreferencesUtil().resetHistory();
    loadData();
  }
}
