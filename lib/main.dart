import 'package:flutter/material.dart';
import 'package:game_1a2b/body.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var body = AppBody(GlobalKey<AppBodyState>());

    return Scaffold(
      appBar: AppBar(
        title: const Text('1A2B'),
        actions: [
          IconButton(
              tooltip: 'Restart the game',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Restart the game'),
                        content: const Text(
                            'Restarting will replace the answer and delete the guess record.'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                "Restart",
                                style: TextStyle(color: Colors.red),
                              )),
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"))
                        ],
                      );
                    }).then((value) {
                  if (value) {
                    body.restart();
                  }
                });
              },
              icon: const Icon(Icons.restart_alt))
        ],
      ),
      body: body,
    );
  }
}