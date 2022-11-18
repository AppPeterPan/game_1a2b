import 'package:flutter_bloc/flutter_bloc.dart';

part 'num_keyboard_state.dart';

class NumKeyboardCubit extends Cubit<NumKeyboardState> {
  NumKeyboardCubit({required this.numLength})
      : super(NumKeyboardState(inputNum: ''));
  final int numLength;

  void input(int num) {
    final inputNum = super.state.inputNum;
    if (inputNum.length < numLength && !inputNum.contains('$num')) {
      emit(NumKeyboardState(inputNum: '$inputNum$num'));
    }
  }

  void clear() {
    emit(NumKeyboardState(inputNum: ''));
  }

  void backspace() {
    final inputNum = super.state.inputNum;
    if (inputNum.isNotEmpty) {
      emit(NumKeyboardState(
          inputNum: inputNum.substring(0, inputNum.length - 1)));
    }
  }
}
