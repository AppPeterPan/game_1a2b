import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    title: const Text('Exit'),
                    content: const Text(
                        'Exit will end the game, are you sure you want to exit?'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    actions: <Widget>[
                      TextButton(
                          onPressed: (() {
                            exit = true;
                            Navigator.of(context).pop();
                          }),
                          child: const Text(
                            'Exit',
                            style: TextStyle(color: Colors.red),
                          )),
                      TextButton(
                          onPressed: (() {
                            exit = false;
                            Navigator.of(context).pop();
                          }),
                          child: const Text(
                            'Continue',
                          ))
                    ],
                  ));
          return exit;
        },
        child: Scaffold(
            backgroundColor: const Color(0xE5EAEAFF),
            appBar: AppBar(
              title: const Text('User Guess'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Expanded(child: UserGuessGame()),
                NumKeyboard()
              ],
            )),
      ),
    );
  }
}

class UserGuessGame extends StatelessWidget {
  const UserGuessGame({super.key});

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
          SharedPreferencesUtil()
              .setBestScore(state.guessRecord.length)
              .then(((bestScore) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('You got it!'),
                    content: Text(
                        'The answer is ${state.answer},\nYou spend ${state.guessRecord.length} times.\n' +
                            (bestScore == state.guessRecord.length
                                ? 'You broke the record!'
                                : 'Your best record is: ' +
                                    bestScore.toString() +
                                    '.')),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Share")),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("OK"))
                    ],
                  );
                }).then((value) {
              if (value) {
                Share.share(
                        'I play 1A2B games,\nIt took me ${state.guessRecord.length} guesses to guess the answer!'
                        '\nIf you also want to play you can go to https://sites.google.com/view/ycyprogram/1a2b',
                        subject: 'Fun 1A2B Game')
                    .then((value) {
                  Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
              }
            });
          }));
        }
      },
      builder: (context, state) {
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
                        style:
                            const TextStyle(fontSize: 25, color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${idx + 1}. ',
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic)),
                          TextSpan(
                              text: '${state.guessRecord[idx].guess} ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
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
      },
    );
  }
}
