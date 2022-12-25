import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/cubit/ab_keyboard_cubit.dart';
import 'package:game_1a2b/cubit/machine_guess_cubit.dart';

class ABKeyboard extends StatelessWidget {
  const ABKeyboard({super.key, required this.numLength});
  final int numLength;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle textButtonStyle = TextButton.styleFrom(
        foregroundColor: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ));
    return BlocProvider(
      create: (context) => ABKeyboardCubit(numLength: numLength),
      child: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _KeyboardInputContent(
              numLength: numLength,
            ),
            _KeyboardARow(
                numLength: numLength, textButtonStyle: textButtonStyle),
            _KeyboardBRow(
                numLength: numLength, textButtonStyle: textButtonStyle)
          ],
        ),
      ),
    );
  }
}

class _KeyboardInputContent extends StatelessWidget {
  const _KeyboardInputContent({required this.numLength});
  final int numLength;

  @override
  Widget build(BuildContext context) {
    final centent = BlocBuilder<MachineGuessCubit, MachineGuessState>(
      builder: (mgContext, mgState) {
        return BlocBuilder<ABKeyboardCubit, ABKeyboardState>(
            builder: (context, state) {
          String question = '';
          if (mgState is MachineGuessInitState) {
            MachineGuessInitState initState = mgState;
            question = initState.question;
          } else if (mgState is MachineGuessGameState) {
            MachineGuessGameState gameState = mgState;
            question = gameState.question;
          }
          final a = state.a;
          final b = state.b;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$question ${a >= 0 ? a : '?'}A${b >= 0 ? b : '?'}B',
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                icon: const Icon(
                  Icons.done,
                  color: Colors.green,
                ),
                iconSize: 35,
                onPressed: (() {
                  if (a >= 0 && b >= 0) {
                    BlocProvider.of<MachineGuessCubit>(context).answer(a, b);
                    BlocProvider.of<ABKeyboardCubit>(context).clear();
                  }
                }),
              )
            ],
          );
        });
      },
    );
    if (kIsWeb) {
      return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent) {
            if (event.isKeyPressed(LogicalKeyboardKey.digit0) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad0)) {
              keyboardInput(context, 0);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit1) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad1)) {
              keyboardInput(context, 1);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit2) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad2)) {
              keyboardInput(context, 2);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit3) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad3)) {
              keyboardInput(context, 3);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit4) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad4)) {
              keyboardInput(context, 4);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit5) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad5)) {
              keyboardInput(context, 5);
            } else if (event.isKeyPressed(LogicalKeyboardKey.enter) ||
                event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
              final int a = BlocProvider.of<ABKeyboardCubit>(context).state.a;
              final int b = BlocProvider.of<ABKeyboardCubit>(context).state.b;
              if (a > -1 && b > -1) {
                BlocProvider.of<MachineGuessCubit>(context).answer(a, b);
                BlocProvider.of<ABKeyboardCubit>(context).clear();
              }
            } else if (event.isKeyPressed(LogicalKeyboardKey.delete) ||
                event.isKeyPressed(LogicalKeyboardKey.backspace)) {
              if (BlocProvider.of<ABKeyboardCubit>(context).state.b > -1) {
                BlocProvider.of<ABKeyboardCubit>(context).inputB(-1);
              } else if (BlocProvider.of<ABKeyboardCubit>(context).state.a >
                  -1) {
                BlocProvider.of<ABKeyboardCubit>(context).inputA(-1);
              }
            }
          }
        },
        child: centent,
      );
    } else {
      return centent;
    }
  }

  void keyboardInput(BuildContext context, int inputNum) {
    if (BlocProvider.of<ABKeyboardCubit>(context).state.a == -1) {
      if (inputNum <= numLength) {
        BlocProvider.of<ABKeyboardCubit>(context).inputA(inputNum);
      }
    } else if (BlocProvider.of<ABKeyboardCubit>(context).state.b == -1) {
      if (inputNum + BlocProvider.of<ABKeyboardCubit>(context).state.a <=
              numLength &&
          (inputNum != 1 ||
              BlocProvider.of<ABKeyboardCubit>(context).state.a + 1 <
                  numLength)) {
        BlocProvider.of<ABKeyboardCubit>(context).inputB(inputNum);
      }
    }
  }
}

class _KeyboardARow extends StatelessWidget {
  const _KeyboardARow({required this.numLength, required this.textButtonStyle});
  final int numLength;
  final ButtonStyle textButtonStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'A: ',
          style: TextStyle(fontSize: 25),
        ),
        for (int i = 0; i <= numLength; i++)
          SizedBox(
              width: 50,
              height: 60,
              child: TextButton(
                  onPressed: () {
                    BlocProvider.of<ABKeyboardCubit>(context).inputA(i);
                  },
                  style: textButtonStyle,
                  child: Text('$i', style: const TextStyle(fontSize: 25))))
      ],
    );
  }
}

class _KeyboardBRow extends StatelessWidget {
  const _KeyboardBRow({required this.numLength, required this.textButtonStyle});
  final int numLength;
  final ButtonStyle textButtonStyle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ABKeyboardCubit, ABKeyboardState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'B: ',
              style: TextStyle(fontSize: 25),
            ),
            for (int i = 0; i <= numLength; i++)
              SizedBox(
                  width: 50,
                  height: 60,
                  child: TextButton(
                      onPressed: state.a + i > numLength ||
                              (state.a == numLength - 1 && i == 1)
                          ? null
                          : () {
                              BlocProvider.of<ABKeyboardCubit>(context)
                                  .inputB(i);
                            },
                      style: textButtonStyle,
                      child: Text('$i', style: const TextStyle(fontSize: 25))))
          ],
        );
      },
    );
  }
}
