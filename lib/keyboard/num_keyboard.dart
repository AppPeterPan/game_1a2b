import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/cubit/num_keyboard_cubit.dart';
import 'package:game_1a2b/cubit/user_guess_cubit.dart';

class NumKeyboard extends StatelessWidget {
  const NumKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle textButtonStyle = TextButton.styleFrom(
        foregroundColor: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ));
    return BlocProvider(
      create: (context) => NumKeyboardCubit(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const _KeyboardInputContent(),
            for (int i = 0; i < 3; i++)
              _KeyboardNumRow(
                textButtonStyle: textButtonStyle,
                startNum: i * 3 + 1,
              ),
            _KeyboardActionRow(textButtonStyle: textButtonStyle)
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
    return BlocBuilder<NumKeyboardCubit, NumKeyboardState>(
        builder: (context, state) {
      final inputNum = state.inputNum;
      if (inputNum.isNotEmpty) {
        return Text(
          inputNum,
          style: const TextStyle(fontSize: 25),
        );
      } else {
        return const Text(
          '4 unique numbers',
          style: TextStyle(color: Colors.grey, fontSize: 25),
        );
      }
    });
  }
}

class _KeyboardNumRow extends StatelessWidget {
  const _KeyboardNumRow(
      {required this.textButtonStyle, required this.startNum});
  final ButtonStyle textButtonStyle;
  final int startNum;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = startNum; i < startNum + 3; i++)
          SizedBox(
              width: 75,
              height: 60,
              child: TextButton(
                  onPressed: () {
                    BlocProvider.of<NumKeyboardCubit>(context).input(i);
                  },
                  style: textButtonStyle,
                  child: Text('$i', style: const TextStyle(fontSize: 25))))
      ],
    );
  }
}

class _KeyboardActionRow extends StatelessWidget {
  const _KeyboardActionRow({required this.textButtonStyle});
  final ButtonStyle textButtonStyle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            width: 75,
            height: 60,
            child: IconButton(
              icon: const Icon(
                Icons.done,
                color: Colors.green,
              ),
              iconSize: 35,
              onPressed: (() {
                String num =
                    BlocProvider.of<NumKeyboardCubit>(context).state.inputNum;
                if (num.length == 4) {
                  BlocProvider.of<NumKeyboardCubit>(context).clear();
                  BlocProvider.of<UserGuessCubit>(context).guess(num);
                }
              }),
            )),
        SizedBox(
            width: 75,
            height: 60,
            child: TextButton(
                onPressed: () {
                  BlocProvider.of<NumKeyboardCubit>(context).input(0);
                },
                style: textButtonStyle,
                child: const Text(
                  '0',
                  style: TextStyle(fontSize: 25),
                ))),
        SizedBox(
            width: 75,
            height: 60,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_backspace,
                color: Colors.red,
              ),
              iconSize: 35,
              onPressed: (() {
                BlocProvider.of<NumKeyboardCubit>(context).backspace();
              }),
            )),
      ],
    );
  }
}
