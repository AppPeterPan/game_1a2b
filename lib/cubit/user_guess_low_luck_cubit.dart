import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/guess.dart';

part 'user_guess_low_luck_state.dart';

class UserGuessLowLuckCubit extends Cubit<UserGuessLowLuckState> {
  UserGuessLowLuckCubit({required this.numLength})
      : super(UserGuessLowLuckState(
            answer: '', answerList: [], guessRecord: [])) {
    start();
  }

  final int numLength;

  void start() {
    List<String> answerList = [];
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
        answerList.add(number);
      }
    }
    emit(UserGuessLowLuckState(
        answer: '', answerList: answerList, guessRecord: []));
  }

  void guess(String num) {
    final Map<int, LowLuckB> numLengthB = {
      3: LowLuckB(firstB: 1, secondB: 0, lessNum: 2, differentB: 1),
      4: LowLuckB(firstB: 1, secondB: 1, lessNum: 1, differentB: 2),
      5: LowLuckB(firstB: 2, secondB: 2, lessNum: 1, differentB: 3),
    };

    final int times = state.guessRecord.length;
    List<String> answerList = state.answerList;
    String ansString = state.answer;
    List<GuessData> guessRecord = state.guessRecord;
    int a = 0;
    int b = 0;
    if (times <= 1) {
      final List<String> newAnswerList = [];
      switch (times) {
        case 0:
          b = numLengthB[numLength]!.firstB;
          break;
        case 1:
          String firstNum = guessRecord[0].guessNum;
          for (int i = 0; i < numLength; i++) {
            firstNum = firstNum.replaceAll(num[i], '');
          }
          if (firstNum.length == numLength) {
            b = numLengthB[numLength]!.differentB;
          } else if (firstNum.length >= numLengthB[numLength]!.lessNum) {
            b = numLengthB[numLength]!.secondB;
          } else {
            b = numLengthB[numLength]!.firstB;
          }
          break;
      }
      for (int i = 0; i < answerList.length; i++) {
        int ta = 0; //for test
        int tb = 0; //for test
        for (int i1 = 0; i1 < numLength; i1++) {
          for (int i2 = 0; i2 < numLength; i2++) {
            if (answerList[i][i1] == num[i2]) {
              if (i1 == i2) {
                ta++;
              } else {
                tb++;
              }
            }
          }
        }
        if (a == ta && b == tb) {
          newAnswerList.add(answerList[i]);
        }
      }
      answerList = newAnswerList;
      if (times == 1) {
        ansString = answerList[Random().nextInt(answerList.length)];
      }
    } else {
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
    }
    guessRecord.add(GuessData(guessNum: num, a: a, b: b));
    emit(UserGuessLowLuckState(
        answer: ansString, answerList: answerList, guessRecord: guessRecord));
  }
}

class LowLuckB {
  final int firstB;
  final int secondB;
  final int lessNum;
  final int differentB;
  LowLuckB(
      {required this.firstB,
      required this.secondB,
      required this.lessNum,
      required this.differentB});
}
