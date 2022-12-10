import 'package:flutter_bloc/flutter_bloc.dart';

part 'num_keyboard_state.dart';

class NumKeyboardCubit extends Cubit<NumKeyboardState> {
  NumKeyboardCubit({required this.numLength})
      : super(NumKeyboardState(inputNum: '', disabledNum: []));
  final int numLength;

  void input(int num) {
    final inputNum = state.inputNum;
    final disabledNum = state.disabledNum;
    if (inputNum.length < numLength &&
        !inputNum.contains('$num') &&
        !disabledNum.contains(num)) {
      emit(NumKeyboardState(
          inputNum: '$inputNum$num', disabledNum: disabledNum));
    }
  }

  void clear() {
    final disabledNum = state.disabledNum;
    emit(NumKeyboardState(inputNum: '', disabledNum: disabledNum));
  }

  void backspace() {
    final inputNum = state.inputNum;
    final disabledNum = state.disabledNum;
    if (inputNum.isNotEmpty) {
      emit(NumKeyboardState(
          inputNum: inputNum.substring(0, inputNum.length - 1),
          disabledNum: disabledNum));
    }
  }

  void toggleDisabledNum(int num) {
    final inputNum = state.inputNum;
    List<int> disabledNum = state.disabledNum;
    if (disabledNum.contains(num)) {
      disabledNum.remove(num);
    } else {
      disabledNum.add(num);
    }
    if (inputNum.length < numLength && !inputNum.contains('$num')) {
      emit(NumKeyboardState(inputNum: inputNum, disabledNum: disabledNum));
    }
  }
}
