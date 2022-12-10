part of 'user_guess_cubit.dart';

@immutable
abstract class UserGuessState {}

class UserGuessInitState extends UserGuessState {
  final String answer;
  UserGuessInitState({required this.answer});
}

class UserGuessGameState extends UserGuessState {
  final String answer;
  final List<GuessData> guessRecord;
  UserGuessGameState({
    required this.answer,
    required this.guessRecord,
  });
}

class UserGuessFinishState extends UserGuessState {
  final String answer;
  final List<GuessData> guessRecord;
  UserGuessFinishState({
    required this.answer,
    required this.guessRecord,
  });
}
