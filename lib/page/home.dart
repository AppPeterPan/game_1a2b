import 'package:flutter/material.dart';
import 'package:game_1a2b/l10n.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/page/machine_guess.dart';
import 'package:game_1a2b/page/user_guess.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> appBarActions = [
      PopupMenuButton(
        itemBuilder: (context) => <PopupMenuEntry>[
          PopupMenuItem(
            child: Text(AppLocalizations.of(context)!.bestRecordTitle),
            value: 0,
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            child: Text(AppLocalizations.of(context)!.licenseTitle),
            value: 1,
          )
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        offset: const Offset(0, 50),
        onSelected: (val) {
          switch (val) {
            case 0:
              SharedPreferencesUtil().getBsetScore().then(
                (bestRecord) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              AppLocalizations.of(context)!.bestRecordTitle),
                          content: Text(bestRecord == null
                              ? AppLocalizations.of(context)!
                                  .bestRecordWithoutContent
                              : AppLocalizations.of(context)!
                                  .bestRecordWithContent(
                                      bestRecord.toString())),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(
                                  AppLocalizations.of(context)!.resetBtn,
                                  style: const TextStyle(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(
                                    AppLocalizations.of(context)!.closeBtn))
                          ],
                        );
                      }).then((value) {
                    if (value == true) {
                      SharedPreferencesUtil().resetBestScore();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.bestRecordCleared),
                        action: SnackBarAction(
                          label: AppLocalizations.of(context)!.undoBtn,
                          onPressed: () =>
                              SharedPreferencesUtil().setBestScore(bestRecord),
                        ),
                        duration: const Duration(milliseconds: 1500),
                      ));
                    }
                  });
                },
              );
              break;
            case 1:
              showLicensePage(
                  context: context,
                  applicationName: '1A2B',
                  applicationLegalese: '©2022 YCY Program');
              break;
          }
        },
      )
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE5EAEA),
      appBar: AppBar(
        title: const Text('Game 1A2B'),
        actions: appBarActions,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            MenuItem(
                icon: Icons.person,
                title: AppLocalizations.of(context)!.userGuessTitle,
                actionIcon: Icons.play_arrow,
                action: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UserGuessPage()));
                }),
            MenuItem(
                icon: Icons.devices,
                title: AppLocalizations.of(context)!.machineGuessTitle,
                actionIcon: Icons.play_arrow,
                action: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MachineGuessPage()));
                }),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.actionIcon,
      required this.action});
  final IconData icon;
  final String title;
  final IconData actionIcon;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 60,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 25, color: Colors.grey.shade900),
              ),
            ),
            IconButton(
              onPressed: action,
              icon: Icon(actionIcon),
              iconSize: 35,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
