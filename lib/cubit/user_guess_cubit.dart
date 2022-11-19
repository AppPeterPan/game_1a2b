import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/guess.dart';

part 'user_guess_state.dart';

class UserGuessCubit extends Cubit<UserGuessState> {
  UserGuessCubit({required this.numLength})
      : super(UserGuessState(
            answer: '1234567890'.substring(0, numLength), guessRecord: [])) {
    start();
  }

  final int numLength;

  void start() {
    String ansString = '';
    List numList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    for (int i = 9; i > 9 - numLength; i--) {
      int ranNum = Random().nextInt(i);
      ansString = ansString + numList[ranNum].toString();
      numList.removeAt(ranNum);
    }

    emit(UserGuessState(answer: ansString, guessRecord: []));
  }

  void guess(String num) {
    final String ansString = state.answer;
    List<GuessData> guessRecord = state.guessRecord;
    int a = 0;
    int b = 0;
    for (int i1 = 0; i1 < numLength; i1++) {
      for (int i2 = 0; i2 < numLength; i2++) {
        if (num[i1] == ansString[i2]) {
          if (i1 == i2) {
            a++;
          } else {
            b++;
          }
        }
      }
    }
    guessRecord.add(GuessData(guessNum: num, a: a, b: b));
    emit(UserGuessState(answer: ansString, guessRecord: guessRecord));
  }
}
