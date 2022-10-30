import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/cubit/machine_guess_cubit.dart';
import 'package:game_1a2b/cubit/user_guess_cubit.dart';
import 'package:game_1a2b/keyboard/ab_keyboard.dart';
import 'package:game_1a2b/keyboard/num_keyboard.dart';

class MachineGuessPage extends StatelessWidget {
  const MachineGuessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MachineGuessCubit(),
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
              title: const Text('Machine Guess'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Expanded(child: MachineGuessGame()),
                ABKeyboard()
              ],
            )),
      ),
    );
  }
}

class MachineGuessGame extends StatelessWidget {
  const MachineGuessGame({super.key});

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
                  title: const Text('Oops! Something went wrong!'),
                  content: const Text(
                      'You may have answered incorrectly in the process, preventing the machine from guessing the answer correctly.'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Close and retry"))
                  ],
                );
              }).then((value) => Navigator.of(context).pop());
        } else if (state.guessRecord[state.guessRecord.length - 1].a == 4) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Machine guessed!'),
                  content: Text('It spend ${state.guessRecord.length} times.'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("OK"))
                  ],
                );
              }).then((value) => Navigator.of(context).pop());
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
