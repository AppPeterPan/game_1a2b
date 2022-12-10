import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/cubit/user_guess_low_luck_cubit.dart';
import 'package:game_1a2b/game_record.dart';
import 'package:game_1a2b/guess.dart';
import 'package:game_1a2b/l10n.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/keyboard/num_keyboard.dart';
import 'package:share_plus/share_plus.dart';

class UserGuessLowerLuckPage extends StatelessWidget {
  const UserGuessLowerLuckPage({super.key, required this.numLength});

  final int numLength;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserGuessLowerLuckCubit(numLength: numLength),
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
              title: Text('User Guess Lower Luck'),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: const _QuitBtn(),
            body: OrientationBuilder(builder: (context, orientation) {
              final numKeyboard = NumKeyboard(
                numLength: numLength,
                numKeyboardGameType: NumKeyboardGameType.userGuessLowLuck,
              );
              final userGuessGame = _UserGuessGame(
                numLength: numLength,
              );
              switch (orientation) {
                case Orientation.portrait:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: userGuessGame),
                      numKeyboard
                    ],
                  );
                case Orientation.landscape:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: numKeyboard),
                      Expanded(child: userGuessGame)
                    ],
                  );
              }
            })),
      ),
    );
  }
}

class _QuitBtn extends StatelessWidget {
  const _QuitBtn();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserGuessLowerLuckCubit, UserGuessLowerLuckState>(
      builder: (context, state) {
        if (state is UserGuessLowerLuckGameWithAnsState &&
            state.guessRecord.length >= 5) {
          return FloatingActionButton(
            onPressed: () {
              final String answer = state.answer;
              if (answer.isNotEmpty) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(AppLocalizations.of(context)!.quitTitle),
                        content:
                            Text(AppLocalizations.of(context)!.quitContent),
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
                              child:
                                  Text(AppLocalizations.of(context)!.cancelBtn))
                        ],
                      );
                    }).then((value) {
                  if (value) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                AppLocalizations.of(context)!.youQuitTitle),
                            content: Text(AppLocalizations.of(context)!
                                .youQuitContent(answer)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(AppLocalizations.of(context)!
                                      .closeAndRetryBtn))
                            ],
                          );
                        }).then((value) => Navigator.of(context).pop());
                  }
                });
              }
            },
            tooltip: AppLocalizations.of(context)!.quitBtn,
            child: const Icon(Icons.close),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _UserGuessGame extends StatelessWidget {
  const _UserGuessGame({required this.numLength});
  final int numLength;

  @override
  Widget build(BuildContext context) {
    final ScrollController _listController = ScrollController();
    return BlocConsumer<UserGuessLowerLuckCubit, UserGuessLowerLuckState>(
      listener: (context, state) {
        Future.delayed(const Duration(milliseconds: 100)).then((value) =>
            _listController.animateTo(_listController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutQuart));
        if (state is UserGuessLowerLuckFinishState) {
          SPUtil().addHistory(GameRecord(
              dateTime: DateTime.now(),
              gameMode: 2,
              times: state.guessRecord.length,
              numLength: numLength));
          SPUtil()
              .setBestScore(
                  tag: '${numLength}l', score: state.guessRecord.length)
              .then((bestRecord) {
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
          });
        }
      },
      builder: (context, state) {
        if (state is UserGuessLowerLuckInitState) {
          return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: Text(
                AppLocalizations.of(context)!.completePreparation,
                style: const TextStyle(fontSize: 25),
              ));
        } else {
          List<GuessData> guessRecord = [];
          if (state is UserGuessLowerLuckGameWithoutAnsState) {
            UserGuessLowerLuckGameWithoutAnsState gameWithoutAnsState = state;
            guessRecord = gameWithoutAnsState.guessRecord;
          } else if (state is UserGuessLowerLuckGameWithAnsState) {
            UserGuessLowerLuckGameWithAnsState gameWithAnsState = state;
            guessRecord = gameWithAnsState.guessRecord;
          } else if (state is UserGuessLowerLuckFinishState) {
            UserGuessLowerLuckFinishState finishState = state;
            guessRecord = finishState.guessRecord;
          }
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _listController,
              itemCount: guessRecord.length,
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
