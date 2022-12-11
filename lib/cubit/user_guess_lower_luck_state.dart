part of 'user_guess_lower_luck_cubit.dart';

@immutable
abstract class UserGuessLowerLuckState {}

class UserGuessLowerLuckInitState extends UserGuessLowerLuckState {
  final List<String> answerList;
  UserGuessLowerLuckInitState({required this.answerList});
}

class UserGuessLowerLuckGameWithoutAnsState extends UserGuessLowerLuckState {
  final List<String> answerList;
  final List<GuessData> guessRecord;
  UserGuessLowerLuckGameWithoutAnsState({
    required this.answerList,
    required this.guessRecord,
  });
}

class UserGuessLowerLuckGameWithAnsState extends UserGuessLowerLuckState {
  final String answer;
  final List<GuessData> guessRecord;
  UserGuessLowerLuckGameWithAnsState({
    required this.answer,
    required this.guessRecord,
  });
}

class UserGuessLowerLuckFinishState extends UserGuessLowerLuckState {
  final String answer;
  final List<GuessData> guessRecord;
  UserGuessLowerLuckFinishState({
    required this.answer,
    required this.guessRecord,
  });
}
