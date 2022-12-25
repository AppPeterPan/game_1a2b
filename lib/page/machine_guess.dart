import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/game_record.dart';
import 'package:game_1a2b/guess.dart';
import 'package:game_1a2b/l10n.dart';
import 'package:game_1a2b/cubit/machine_guess_cubit.dart';
import 'package:game_1a2b/keyboard/ab_keyboard.dart';

class MachineGuessPage extends StatelessWidget {
  const MachineGuessPage({super.key, required this.numLength});
  final int numLength;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MachineGuessCubit(numLength: numLength),
      child: WillPopScope(
        onWillPop: () async {
          bool exit = false;
          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(AppLocalizations.of(context)!.exitTitle),
                    content: Text(AppLocalizations.of(context)!.exitContent),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    actions: <Widget>[
                      TextButton(
                          onPressed: (() {
                            exit = true;
                            Navigator.of(context).pop();
                          }),
                          child: Text(
                            AppLocalizations.of(context)!.exitBtn,
                            style: const TextStyle(color: Colors.red),
                          )),
                      TextButton(
                          onPressed: (() {
                            exit = false;
                            Navigator.of(context).pop();
                          }),
                          child: Text(
                            AppLocalizations.of(context)!.continueBtn,
                          ))
                    ],
                  ));
          return exit;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.machineGuessTitle),
          ),
          body: OrientationBuilder(builder: (context, orientation) {
            final abKeyboard = ABKeyboard(
              numLength: numLength,
            );
            final machineGuessGame = _MachineGuessGame(
              numLength: numLength,
            );
            switch (orientation) {
              case Orientation.portrait:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: machineGuessGame),
                    abKeyboard
                  ],
                );
              case Orientation.landscape:
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: abKeyboard),
                      Expanded(child: machineGuessGame)
                    ]);
            }
          }),
        ),
      ),
    );
  }
}

class _MachineGuessGame extends StatelessWidget {
  const _MachineGuessGame({required this.numLength});
  final int numLength;

  @override
  Widget build(BuildContext context) {
    final ScrollController _listController = ScrollController();
    return BlocConsumer<MachineGuessCubit, MachineGuessState>(
      listener: (context, state) {
        Future.delayed(const Duration(milliseconds: 100)).then((value) =>
            _listController.animateTo(_listController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutQuart));
        if (state is MachineGuessErrorState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                      AppLocalizations.of(context)!.machineGuessErrorTitle),
                  content: Text(
                      AppLocalizations.of(context)!.machineGuessErrorContent),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                            AppLocalizations.of(context)!.closeAndRetryBtn))
                  ],
                );
              }).then((value) => Navigator.of(context).pop());
        } else if (state is MachineGuessFinishState) {
          SPUtil().addHistory(GameRecord(
              dateTime: DateTime.now(),
              gameMode: 1,
              times: state.guessRecord.length,
              numLength: numLength));
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title:
                      Text(AppLocalizations.of(context)!.machineGuessedTitle),
                  content: Text(AppLocalizations.of(context)!
                      .machineGuessedContent(
                          state.guessRecord.length.toString())),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(AppLocalizations.of(context)!.okBtn))
                  ],
                );
              }).then((value) => Navigator.of(context).pop(true));
        }
      },
      builder: (context, state) {
        if (state is MachineGuessInitState) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  AppLocalizations.of(context)!.completePreparation,
                  textStyle: const TextStyle(
                    fontSize: 25,
                  ),
                  speed: const Duration(milliseconds: 50),
                ),
              ],
              isRepeatingAnimation: false,
              pause: const Duration(milliseconds: 2000),
              displayFullTextOnTap: true,
            ),
          );
        } else {
          List<GuessData> guessRecord = [];
          if (state is MachineGuessGameState) {
            MachineGuessGameState gameState = state;
            guessRecord = gameState.guessRecord;
          } else if (state is MachineGuessFinishState) {
            MachineGuessFinishState finishState = state;
            guessRecord = finishState.guessRecord;
          } else if (state is MachineGuessErrorState) {
            MachineGuessErrorState errorState = state;
            guessRecord = errorState.guessRecord;
          }
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _listController,
              itemCount: guessRecord.length,
              itemBuilder: (context, idx) {
                return Card(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey
                      : Colors.grey.shade700,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: '',
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(
                                text: '${idx + 1}. ',
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic)),
                            TextSpan(
                                text: '${guessRecord[idx].guessNum} ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '${guessRecord[idx].a}A',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 100, 205, 253))),
                            TextSpan(
                                text: '${guessRecord[idx].b}B',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 253, 239, 113))),
                          ],
                        ),
                      )),
                );
              });
        }
      },
    );
  }
}
