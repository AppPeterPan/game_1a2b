import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/guess.dart';

part 'human_guess_state.dart';

class HumanGuessCubit extends Cubit<HumanGuessState> {
  HumanGuessCubit()
      : super(HumanGuessState(gameStart: false, answer: '1234', guess: [])) {
    setAnswer();
  }

  void setAnswer() {
    String ansString = '';
    List numList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    for (int i = 9; i > 5; i--) {
      int ranNum = Random().nextInt(i);
      ansString = ansString + numList[ranNum].toString();
      numList.removeAt(ranNum);
    }
    emit(HumanGuessState(
        gameStart: super.state.gameStart,
        answer: ansString,
        guess: super.state.guess));
  }
}
