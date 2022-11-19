import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/game_record.dart';
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
          backgroundColor: const Color(0xFFE5EAEA),
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
        if (state.question == 'stww') {
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
        } else if (state.guessRecord[state.guessRecord.length - 1].a ==
            numLength) {
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
              }).then((value) => Navigator.of(context).pop());
        }
      },
      builder: (context, state) {
        if (state.guessRecord.isEmpty) {
          return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: Text(
                AppLocalizations.of(context)!.completePreparation,
                style: const TextStyle(fontSize: 25),
              ));
        } else {
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _listController,
              itemCount: state.guessRecord.length,
              itemBuilder: (context, idx) {
                return Card(
                  color: Colors.grey,
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
                                text: '${state.guessRecord[idx].guessNum} ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '${state.guessRecord[idx].a}A',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 100, 205, 253))),
                            TextSpan(
                                text: '${state.guessRecord[idx].b}B',
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
