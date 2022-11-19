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
              SPUtil().getBsetScores(numLengthList: [3, 4, 5]).then(
                (bestRecords) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              AppLocalizations.of(context)!.bestRecordTitle),
                          content: RichText(
                            text: TextSpan(children: <TextSpan>[
                              for (int i = 0; i < bestRecords.length; i++)
                                TextSpan(
                                    text:
                                        '${AppLocalizations.of(context)!.xNumbers(bestRecords[i]['nl'].toString())}: ${bestRecords[i]['br'] is int ? AppLocalizations.of(context)!.bestRecordWithContent(bestRecords[i]['br'].toString()) : AppLocalizations.of(context)!.bestRecordWithoutContent}${i < bestRecords.length - 1 ? '\n' : ''}')
                            ]),
                          ),
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
                      SPUtil().resetBestScore(numLengthList: [3, 4, 5]);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.bestRecordCleared),
                        action: SnackBarAction(
                          label: AppLocalizations.of(context)!.undoBtn,
                          onPressed: () {
                            for (int i = 0; i < bestRecords.length; i++) {
                              SPUtil().setBestScore(
                                  numLength: bestRecords[i]['nl']!,
                                  score: bestRecords[i]['br']!);
                            }
                          },
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
        multiAction: [
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('3'),
            action: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const UserGuessPage(
                      numLength: 3,
                    ))),
          ),
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('4'),
            action: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const UserGuessPage(
                      numLength: 4,
                    ))),
          ),
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('5'),
            action: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const UserGuessPage(
                      numLength: 5,
                    ))),
          )
        ],
      ),
      MenuData(
        title: AppLocalizations.of(context)!.machineGuessTitle,
        subtitle: AppLocalizations.of(context)!.machineGuessSubtitle,
        icon: Icons.devices,
        multiAction: [
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('3'),
            action: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const MachineGuessPage(
                      numLength: 3,
                    ))),
          ),
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('4'),
            action: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const MachineGuessPage(
                      numLength: 4,
                    ))),
          ),
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('5'),
            action: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const MachineGuessPage(
                      numLength: 5,
                    ))),
          )
        ],
      ),
      MenuData(
        title: AppLocalizations.of(context)!.gameRecordTitle,
        subtitle: AppLocalizations.of(context)!.gameRecordSubtitle,
        icon: Icons.history,
        action: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const HistoryPage())),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE5EAEA),
      appBar: AppBar(
        title: const Text('Game 1A2B'),
        actions: appBarActions,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          for (int idx = 0; idx < menuDataList.length; idx++)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
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
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
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
                                      if (menuDataList[idx].multiAction
                                          is List<MenuDataAction>)
                                        for (int i = 0;
                                            i <
                                                menuDataList[idx]
                                                        .multiAction!
                                                        .length *
                                                    2;
                                            i++)
                                          i % 2 == 0
                                              ? const Divider()
                                              : ListTile(
                                                  title: Text(
                                                    menuDataList[idx]
                                                        .multiAction![
                                                            ((i - 1) / 2)
                                                                .round()]
                                                        .title,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  onTap: menuDataList[idx]
                                                      .multiAction![
                                                          ((i - 1) / 2).round()]
                                                      .action,
                                                )
                                    ]))
                              ]),
                        ),
                      ))),
            )
        ],
      ),
    );
  }
}

class MenuData {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? action;
  final List<MenuDataAction>? multiAction;
  MenuData(
      {required this.title,
      required this.subtitle,
      required this.icon,
      this.action,
      this.multiAction});
}

class MenuDataAction {
  final String title;
  final VoidCallback? action;
  MenuDataAction({required this.title, this.action});
}
