import 'package:flutter_bloc/flutter_bloc.dart';

part 'ab_keyboard_state.dart';

class ABKeyboardCubit extends Cubit<ABKeyboardState> {
  ABKeyboardCubit() : super(ABKeyboardState(a: -1, b: -1));

  void inputA(int x) {
    int b = super.state.b;
    if (x + b > 4 || (x == 3 && b == 1)) {
      b = 0;
    }
    emit(ABKeyboardState(a: x, b: b));
  }

  void inputB(int x) {
    int a = super.state.a;
    emit(ABKeyboardState(a: a, b: x));
  }

  void clear() {
    emit(ABKeyboardState(a: -1, b: -1));
  }
}
