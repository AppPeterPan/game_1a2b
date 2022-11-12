import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/cubit/ab_keyboard_cubit.dart';
import 'package:game_1a2b/cubit/machine_guess_cubit.dart';

class ABKeyboard extends StatelessWidget {
  const ABKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle textButtonStyle = TextButton.styleFrom(
        foregroundColor: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ));
    return BlocProvider(
      create: (context) => ABKeyboardCubit(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const _KeyboardInputContent(),
            _KeyboardARow(textButtonStyle: textButtonStyle),
            _KeyboardBRow(textButtonStyle: textButtonStyle)
          ],
        ),
      ),
    );
  }
}

class _KeyboardInputContent extends StatelessWidget {
  const _KeyboardInputContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MachineGuessCubit, MachineGuessState>(
      builder: (mgContext, mgState) {
        return BlocBuilder<ABKeyboardCubit, ABKeyboardState>(
            builder: (context, state) {
          final question = mgState.question;
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
  }
}

class _KeyboardARow extends StatelessWidget {
  const _KeyboardARow({required this.textButtonStyle});
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
        for (int i = 0; i <= 4; i++)
          SizedBox(
              width: 60,
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
  const _KeyboardBRow({required this.textButtonStyle});
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
            for (int i = 0; i <= 4; i++)
              SizedBox(
                  width: 60,
                  height: 60,
                  child: TextButton(
                      onPressed: state.a + i > 4 || (state.a == 3 && i == 1)
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
