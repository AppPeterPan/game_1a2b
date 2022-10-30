part of 'machine_guess_cubit.dart';

class MachineGuessState {
  String question;
  List<GuessData> guessRecord;
  List<String>numberList;
  MachineGuessState({
    required this.question,
    required this.guessRecord,
    required this.numberList
  });
}
