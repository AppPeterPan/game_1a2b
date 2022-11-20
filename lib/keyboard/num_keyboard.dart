import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/l10n.dart';
import 'package:game_1a2b/cubit/num_keyboard_cubit.dart';
import 'package:game_1a2b/cubit/user_guess_cubit.dart';

class NumKeyboard extends StatelessWidget {
  const NumKeyboard({super.key, required this.numLength});
  final int numLength;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle textButtonStyle = TextButton.styleFrom(
        foregroundColor: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ));
    return BlocProvider(
      create: (context) => NumKeyboardCubit(numLength: numLength),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _KeyboardInputContent(
              numLength: numLength,
            ),
            for (int i = 0; i < 3; i++)
              _KeyboardNumRow(
                textButtonStyle: textButtonStyle,
                startNum: i * 3 + 1,
              ),
            _KeyboardActionRow(
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
    final content = BlocBuilder<NumKeyboardCubit, NumKeyboardState>(
        builder: (context, state) {
      final inputNum = state.inputNum;
      if (inputNum.isNotEmpty) {
        return Text(
          inputNum,
          style: const TextStyle(fontSize: 25),
        );
      } else {
        return Text(
          AppLocalizations.of(context)!.inputNumberHint(numLength.toString()),
          style: const TextStyle(color: Colors.grey, fontSize: 25),
        );
      }
    });
    if (kIsWeb) {
      return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent) {
            if (event.isKeyPressed(LogicalKeyboardKey.digit0) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad0)) {
              BlocProvider.of<NumKeyboardCubit>(context).input(0);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit1) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad1)) {
              BlocProvider.of<NumKeyboardCubit>(context).input(1);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit2) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad2)) {
              BlocProvider.of<NumKeyboardCubit>(context).input(2);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit3) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad3)) {
              BlocProvider.of<NumKeyboardCubit>(context).input(3);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit4) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad4)) {
              BlocProvider.of<NumKeyboardCubit>(context).input(4);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit5) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad5)) {
              BlocProvider.of<NumKeyboardCubit>(context).input(5);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit6) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad6)) {
              BlocProvider.of<NumKeyboardCubit>(context).input(6);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit7) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad7)) {
              BlocProvider.of<NumKeyboardCubit>(context).input(7);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit8) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad8)) {
              BlocProvider.of<NumKeyboardCubit>(context).input(8);
            } else if (event.isKeyPressed(LogicalKeyboardKey.digit9) ||
                event.isKeyPressed(LogicalKeyboardKey.numpad9)) {
              BlocProvider.of<NumKeyboardCubit>(context).input(9);
            } else if (event.isKeyPressed(LogicalKeyboardKey.enter) ||
                event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
              String num =
                  BlocProvider.of<NumKeyboardCubit>(context).state.inputNum;
              if (num.length == numLength) {
                BlocProvider.of<NumKeyboardCubit>(context).clear();
                BlocProvider.of<UserGuessCubit>(context).guess(num);
              }
            } else if (event.isKeyPressed(LogicalKeyboardKey.delete) ||
                event.isKeyPressed(LogicalKeyboardKey.backspace)) {
              BlocProvider.of<NumKeyboardCubit>(context).backspace();
            }
          }
        },
        child: content,
      );
    } else {
      return content;
    }
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
  const _KeyboardActionRow(
      {required this.numLength, required this.textButtonStyle});
  final int numLength;
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
                if (num.length == numLength) {
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
