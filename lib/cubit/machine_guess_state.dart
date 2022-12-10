part of 'machine_guess_cubit.dart';

@immutable
abstract class MachineGuessState {}

class MachineGuessInitState extends MachineGuessState {
  final String question;
  final List<String> numberList;
  MachineGuessInitState({required this.question, required this.numberList});
}

class MachineGuessGameState extends MachineGuessState {
  final String question;
  final List<GuessData> guessRecord;
  final List<String> numberList;
  MachineGuessGameState(
      {required this.question,
      required this.guessRecord,
      required this.numberList});
}

class MachineGuessFinishState extends MachineGuessState {
  final List<GuessData> guessRecord;
  MachineGuessFinishState({required this.guessRecord});
}

class MachineGuessErrorState extends MachineGuessState {
  final List<GuessData> guessRecord;
  MachineGuessErrorState({required this.guessRecord});
}
