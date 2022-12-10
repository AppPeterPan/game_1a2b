import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/guess.dart';

part 'user_guess_state.dart';

class UserGuessCubit extends Cubit<UserGuessState> {
  UserGuessCubit({required this.numLength})
      : super(
            UserGuessInitState(answer: '1234567890'.substring(0, numLength))) {
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

    emit(UserGuessInitState(answer: ansString));
  }

  void guess(String num) {
    String ansString;
    List<GuessData> guessRecord = [];
    if (state is UserGuessInitState) {
      UserGuessInitState initState = state as UserGuessInitState;
      ansString = initState.answer;
    } else if (state is UserGuessGameState) {
      UserGuessGameState gameState = state as UserGuessGameState;
      ansString = gameState.answer;
      guessRecord = gameState.guessRecord;
    } else {
      return;
    }
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
    if (guessRecord.last.a == numLength) {
      emit(UserGuessFinishState(answer: ansString, guessRecord: guessRecord));
    } else {
      emit(UserGuessGameState(answer: ansString, guessRecord: guessRecord));
    }
  }
}
