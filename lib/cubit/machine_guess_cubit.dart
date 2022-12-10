import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/guess.dart';

part 'machine_guess_state.dart';

class MachineGuessCubit extends Cubit<MachineGuessState> {
  MachineGuessCubit({required this.numLength})
      : super(MachineGuessInitState(
          question: '1234567890'.substring(0, numLength),
          numberList: const [],
        )) {
    start();
  }

  final int numLength;

  void start() {
    List<String> numberList = [];
    for (int i = 0; i < pow(10, numLength) - 1; i++) {
      bool repeat = false;
      String number = '$i';
      while (number.length < numLength) {
        number = '0$number';
      }
      for (int i1 = 0; i1 < numLength - 1; i1++) {
        for (int i2 = i1 + 1; i2 < numLength; i2++) {
          if (number[i1] == number[i2]) {
            repeat = true;
          }
        }
      }
      if (!repeat) {
        numberList.add(number);
      }
    }
    emit(MachineGuessInitState(
        question: numberList[Random().nextInt(numberList.length)],
        numberList: numberList));
  }

  void answer(int a, int b) {
    String question;
    List<String> numberList;
    List<GuessData> guessRecord = [];
    if (state is MachineGuessInitState) {
      MachineGuessInitState initState = state as MachineGuessInitState;
      question = initState.question;
      numberList = initState.numberList;
    } else if (state is MachineGuessGameState) {
      MachineGuessGameState gameState = state as MachineGuessGameState;
      question = gameState.question;
      numberList = gameState.numberList;
      guessRecord = gameState.guessRecord;
    } else {
      return;
    }
    final List<String> newNumList = [];
    for (int i = 0; i < numberList.length; i++) {
      int ta = 0; //for test
      int tb = 0; //for test
      for (int i1 = 0; i1 < numLength; i1++) {
        for (int i2 = 0; i2 < numLength; i2++) {
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
    if (newNumList.isEmpty) {
      emit(MachineGuessErrorState(guessRecord: guessRecord));
    } else if (guessRecord.last.a == numLength) {
      emit(MachineGuessFinishState(guessRecord: guessRecord));
    } else {
      emit(MachineGuessGameState(
          question: newNumList[Random().nextInt(newNumList.length)],
          guessRecord: guessRecord,
          numberList: newNumList));
    }
  }
}
