import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/cubit/history_cubit.dart';
import 'package:game_1a2b/game_record.dart';
import 'package:game_1a2b/l10n.dart';
import 'package:game_1a2b/cubit/user_guess_cubit.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/keyboard/num_keyboard.dart';
import 'package:share_plus/share_plus.dart';

class UserGuessPage extends StatelessWidget {
  const UserGuessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserGuessCubit(),
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
              title: Text(AppLocalizations.of(context)!.userGuessTitle),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: const QuitBtn(),
            body: OrientationBuilder(builder: (context, orientation) {
              switch (orientation) {
                case Orientation.portrait:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Expanded(child: _UserGuessGame()),
                      NumKeyboard()
                    ],
                  );
                case Orientation.landscape:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Expanded(child: NumKeyboard()),
                      Expanded(child: _UserGuessGame())
                    ],
                  );
              }
            })),
      ),
    );
  }
}

class QuitBtn extends StatelessWidget {
  const QuitBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final String answer =
            BlocProvider.of<UserGuessCubit>(context).state.answer;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.quitTitle),
                content: Text(AppLocalizations.of(context)!.quitContent),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        AppLocalizations.of(context)!.quitBtn,
                        style: const TextStyle(color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(AppLocalizations.of(context)!.cancelBtn))
                ],
              );
            }).then((value) {
          if (value) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.youQuitTitle),
                    content: Text(
                        AppLocalizations.of(context)!.youQuitContent(answer)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                              AppLocalizations.of(context)!.closeAndRetryBtn))
                    ],
                  );
                }).then((value) => Navigator.of(context).pop());
          }
        });
      },
      tooltip: AppLocalizations.of(context)!.quitBtn,
      child: const Icon(Icons.close),
    );
  }
}

class _UserGuessGame extends StatelessWidget {
  const _UserGuessGame();

  @override
  Widget build(BuildContext context) {
    final ScrollController _listController = ScrollController();
    return BlocConsumer<UserGuessCubit, UserGuessState>(
      listener: (context, state) {
        Future.delayed(const Duration(milliseconds: 100)).then((value) =>
            _listController.animateTo(_listController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutQuart));
        if (state.guessRecord[state.guessRecord.length - 1].a == 4) {
          BlocProvider.of<HistoryCubit>(context).addRecord(GameRecord(
              dateTime: DateTime.now(),
              gameMode: 0,
              times: state.guessRecord.length));
          SharedPreferencesUtil()
              .setBestScore(state.guessRecord.length)
              .then(((bestRecord) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.userGuessedTitle),
                    content: Text(bestRecord == state.guessRecord.length
                        ? AppLocalizations.of(context)!.userGuessedContentBroke(
                            state.answer, state.guessRecord.length.toString())
                        : AppLocalizations.of(context)!
                            .userGuessedContentNotBroke(
                                state.answer,
                                state.guessRecord.length.toString(),
                                bestRecord.toString())),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    actions: [
                      TextButton(
                          onPressed: () => Share.share(
                              AppLocalizations.of(context)!.shareScoreContent(
                                  state.guessRecord.length.toString()),
                              subject: AppLocalizations.of(context)!
                                  .shareScoreTitle),
                          child: Text(AppLocalizations.of(context)!.shareBtn)),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(AppLocalizations.of(context)!.okBtn))
                    ],
                  );
                }).then((value) {
              Navigator.of(context).pop();
            });
          }));
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
