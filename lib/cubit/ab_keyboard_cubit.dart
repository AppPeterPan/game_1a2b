import 'package:flutter_bloc/flutter_bloc.dart';

part 'ab_keyboard_state.dart';

class ABKeyboardCubit extends Cubit<ABKeyboardState> {
  ABKeyboardCubit({required this.numLength})
      : super(ABKeyboardState(a: -1, b: -1));
  final int numLength;

  void inputA(int x) {
    int b =state.b;
    if (x + b > numLength || (x == numLength - 1 && b == 1)) {
      b = 0;
    }
    emit(ABKeyboardState(a: x, b: b));
  }

  void inputB(int x) {
    int a = state.a;
    emit(ABKeyboardState(a: a, b: x));
  }

  void clear() {
    emit(ABKeyboardState(a: -1, b: -1));
  }
}
