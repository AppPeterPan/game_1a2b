import 'package:flutter/material.dart';
import 'package:game_1a2b/body.dart';
import 'package:game_1a2b/data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppView(),
      color: Colors.blue,
      title: '1A2B Game',
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
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
              const PopupMenuItem(
                child: Text('Restart'),
                value: 0,
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                child: Text('Best Record'),
                value: 1,
              ),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            offset: const Offset(0, 50),
            onSelected: (val) {
              switch (val) {
                case 0:
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Restart the Game'),
                          content: const Text(
                              'Restarting will replace the answer and delete the guess record.'),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text(
                                  'Restart',
                                  style: TextStyle(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'))
                          ],
                        );
                      }).then((value) {
                    if (value) {
                      body.restart();
                    }
                  });
                  break;
                case 1:
                  SharedPreferencesUtil().getBsetScore().then(
                    (bestScore) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Best Record'),
                              content: Text(bestScore == null
                                  ? 'No best record yet!'
                                  : 'Your best record is: ' +
                                      bestScore.toString() +
                                      '.'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text(
                                      'Reset',
                                      style: TextStyle(color: Colors.red),
                                    )),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Close'))
                              ],
                            );
                          }).then((value) {
                        if (value) {
                          SharedPreferencesUtil().resetBestScore();
                          body.showSnackBar('Best record cleared!');
                        }
                      });
                    },
                  );
                  break;
              }
            },
          )
        ],
      ),
      body: body,
    );
  }
}
