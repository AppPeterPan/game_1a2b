import 'package:flutter/material.dart';
import 'package:game_1a2b/l10n.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/page/history.dart';
import 'package:game_1a2b/page/machine_guess.dart';
import 'package:game_1a2b/page/user_guess.dart';

enum HomePagePopupItem { bestRecord, license }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> appBarActions = [
      PopupMenuButton(
        itemBuilder: (context) => <PopupMenuEntry>[
          PopupMenuItem<HomePagePopupItem>(
            child: Text(AppLocalizations.of(context)!.bestRecordTitle),
            value: HomePagePopupItem.bestRecord,
          ),
          const PopupMenuDivider(),
          PopupMenuItem<HomePagePopupItem>(
            child: Text(AppLocalizations.of(context)!.licenseTitle),
            value: HomePagePopupItem.license,
          )
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        offset: const Offset(0, 50),
        onSelected: (val) {
          switch (val) {
            case HomePagePopupItem.bestRecord:
              SharedPreferencesUtil().getBsetScore().then(
                (bestRecord) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              AppLocalizations.of(context)!.bestRecordTitle),
                          content: Text(bestRecord is int
                              ? AppLocalizations.of(context)!
                                  .bestRecordWithContent(bestRecord.toString())
                              : AppLocalizations.of(context)!
                                  .bestRecordWithoutContent),
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
                        duration: const Duration(milliseconds: 2500),
                      ));
                    }
                  });
                },
              );
              break;
            case HomePagePopupItem.license:
              showLicensePage(
                  context: context,
                  applicationName: '1A2B',
                  applicationLegalese: '©2022 YCY Program');
              break;
          }
        },
      )
    ];

    final List<MenuData> menuDataList = [
      MenuData(
          title: AppLocalizations.of(context)!.userGuessTitle,
          subtitle: AppLocalizations.of(context)!.userGuessSubtitle,
          icon: Icons.person,
          action: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const UserGuessPage()))),
      MenuData(
          title: AppLocalizations.of(context)!.machineGuessTitle,
          subtitle: AppLocalizations.of(context)!.machineGuessSubtitle,
          icon: Icons.devices,
          action: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MachineGuessPage()))),
      MenuData(
          title: AppLocalizations.of(context)!.gameRecordTitle,
          subtitle: AppLocalizations.of(context)!.gameRecordSubtitle,
          icon: Icons.history,
          action: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const HistoryPage()))),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE5EAEA),
      appBar: AppBar(
        title: const Text('Game 1A2B'),
        actions: appBarActions,
      ),
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: menuDataList.length,
          itemBuilder: (context, idx) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: InkWell(
                        onTap: menuDataList[idx].action,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Row(children: <Widget>[
                            Icon(
                              menuDataList[idx].icon,
                              size: 60,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(
                                    menuDataList[idx].title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    menuDataList[idx].subtitle,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ]))
                          ]),
                        ),
                      ))),
            );
          }),
    );
  }
}

class MenuData {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback action;
  MenuData(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.action});
}
