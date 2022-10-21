import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/cubit/human_guess_cubit.dart';
import 'package:game_1a2b/cubit/page_cubit.dart';
import 'package:game_1a2b/page/human_guess.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/page/robot_guess.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PageCubit>(create: (context) => PageCubit()),
        BlocProvider<HumanGuessCubit>(create: (context) => HumanGuessCubit())
      ],
      child: const MaterialApp(
        home: AppView(),
        color: Colors.blue,
        title: '1A2B Game',
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final humanGuessPage = HumanGuessPage(GlobalKey<HumanGuessPageState>());
    final robotGuessPage = RobotGuessPage(GlobalKey<RobotGuessPageState>());
    final pageList = <Widget>[humanGuessPage, robotGuessPage];

    return BlocBuilder<PageCubit, PageState>(builder: ((context, state) {
      return Scaffold(
        // appBar: AppBar(
        //   title: const Text('1A2B'),
        //   actions: [
        //     PopupMenuButton(
        //       itemBuilder: (context) => <PopupMenuEntry>[
        //         const PopupMenuItem(
        //           child: Text('Restart'),
        //           value: 0,
        //         ),
        //         const PopupMenuDivider(),
        //         const PopupMenuItem(
        //           child: Text('Best Record'),
        //           value: 1,
        //         ),
        //       ],
        //       shape:
        //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //       offset: const Offset(0, 50),
        //       onSelected: (val) {
        //         switch (val) {
        //           case 0:
        //             showDialog(
        //                 context: context,
        //                 builder: (BuildContext context) {
        //                   return AlertDialog(
        //                     title: const Text('Restart the Game'),
        //                     content: const Text(
        //                         'Restarting will replace the answer and delete the guess record.'),
        //                     actions: [
        //                       TextButton(
        //                           onPressed: () =>
        //                               Navigator.of(context).pop(true),
        //                           child: const Text(
        //                             'Restart',
        //                             style: TextStyle(color: Colors.red),
        //                           )),
        //                       TextButton(
        //                           onPressed: () =>
        //                               Navigator.of(context).pop(false),
        //                           child: const Text('Cancel'))
        //                     ],
        //                   );
        //                 }).then((value) {
        //               if (value) {
        //                 body.restart();
        //               }
        //             });
        //             break;
        //           case 1:
        //             SharedPreferencesUtil().getBsetScore().then(
        //               (bestScore) {
        //                 showDialog(
        //                     context: context,
        //                     builder: (BuildContext context) {
        //                       return AlertDialog(
        //                         title: const Text('Best Record'),
        //                         content: Text(bestScore == null
        //                             ? 'No best record yet!'
        //                             : 'Your best record is: ' +
        //                                 bestScore.toString() +
        //                                 '.'),
        //                         actions: [
        //                           TextButton(
        //                               onPressed: () =>
        //                                   Navigator.of(context).pop(true),
        //                               child: const Text(
        //                                 'Reset',
        //                                 style: TextStyle(color: Colors.red),
        //                               )),
        //                           TextButton(
        //                               onPressed: () =>
        //                                   Navigator.of(context).pop(false),
        //                               child: const Text('Close'))
        //                         ],
        //                       );
        //                     }).then((value) {
        //                   if (value) {
        //                     SharedPreferencesUtil().resetBestScore();
        //                     body.showSnackBar('Best record cleared!');
        //                   }
        //                 });
        //               },
        //             );
        //             break;
        //         }
        //       },
        //     )
        //   ],
        // ),
        body: pageList[state.pageIdx],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Human Guess',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.computer),
              label: 'Robot Guess',
            ),
          ],
          currentIndex: state.pageIdx,
          selectedItemColor: Colors.blue.shade600,
          backgroundColor: Colors.blueGrey.shade200,
          onTap: (value) => BlocProvider.of<PageCubit>(context).toPage(value),
        ),
      );
    }));
  }
}
