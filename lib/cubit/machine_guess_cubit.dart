import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/guess.dart';

part 'machine_guess_state.dart';

class MachineGuessCubit extends Cubit<MachineGuessState> {
  MachineGuessCubit()
      : super(MachineGuessState(
            question: '1234', guessRecord: [], numberList: [])) {
    start();
  }

  void start() {
    List<String> numberList = [];
    for (int i = 0; i < 10000 - 1; i++) {
      bool repeat = false;
      String number = '$i';
      while (number.length < 4) {
        number = '0$number';
      }
      for (int i1 = 0; i1 < 4 - 1; i1++) {
        for (int i2 = i1 + 1; i2 < 4; i2++) {
          if (number[i1] == number[i2]) {
            repeat = true;
          }
        }
      }
      if (!repeat) {
        numberList.add(number);
      }
    }
    final String question = numberList[Random().nextInt(numberList.length)];

    emit(MachineGuessState(
        question: question, guessRecord: [], numberList: numberList));
  }

  void answer(int a, int b) {
    final String question = state.question;
    final List<String> numberList = state.numberList;
    List<GuessData> guessRecord = state.guessRecord;
    final List<String> newNumList = [];
    for (int i = 0; i < numberList.length; i++) {
      int ta = 0; //for test
      int tb = 0; //for test
      for (int i1 = 0; i1 < 4; i1++) {
        for (int i2 = 0; i2 < 4; i2++) {
          if (numberList[i][i1] == question[i2]) {
            if (i1 == i2) {
              ta++;
            } else {
              tb++;
            }
          }
        }
      }
      if (a == ta && b == tb) {
        newNumList.add(numberList[i]);
      }
    }
    guessRecord.add(GuessData(guessNum: question, a: a, b: b));
    final String newQuestion = newNumList.isNotEmpty
        ? newNumList[Random().nextInt(newNumList.length)]
        : 'stww';
    emit(MachineGuessState(
        question: newQuestion,
        guessRecord: guessRecord,
        numberList: newNumList));
  }
}
