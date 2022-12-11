import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:game_1a2b/l10n.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/page/history.dart';
import 'package:game_1a2b/page/machine_guess.dart';
import 'package:game_1a2b/page/user_guess.dart';
import 'package:game_1a2b/page/user_guess_lower_luck.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum HomePagePopupItem { bestRecord, license }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final List<MenuData> menuDataList = [
      MenuData(
        title: AppLocalizations.of(context)!.userGuessTitle,
        subtitle: AppLocalizations.of(context)!.userGuessSubtitle,
        icon: Icons.person,
        multiAction: [
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('3'),
            disabled: false,
            action: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (_) => const UserGuessPage(
                          numLength: 3,
                        )))
                .then((value) => reload()),
            tag: '3',
          ),
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('4'),
            disabled: false,
            action: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (_) => const UserGuessPage(
                          numLength: 4,
                        )))
                .then((value) => reload()),
            tag: '4',
          ),
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('5'),
            disabled: false,
            action: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (_) => const UserGuessPage(
                          numLength: 5,
                        )))
                .then((value) => reload()),
            tag: '5',
          )
        ],
      ),
      MenuData(
        title: AppLocalizations.of(context)!.userGuessLowerLuckTitle,
        subtitle: AppLocalizations.of(context)!.userGuessSubtitle,
        icon: Icons.person,
        multiAction: [
          MenuDataAction(
              title: AppLocalizations.of(context)!.xNumbers('3'),
              disabled: true,
              action: () => Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => const UserGuessLowerLuckPage(
                            numLength: 3,
                          )))
                  .then((value) => reload()),
              tag: '3HM',
              disabledCheckTag: '3'),
          MenuDataAction(
              title: AppLocalizations.of(context)!.xNumbers('4'),
              disabled: true,
              action: () => Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => const UserGuessLowerLuckPage(
                            numLength: 4,
                          )))
                  .then((value) => reload()),
              tag: '4HM',
              disabledCheckTag: '4'),
          MenuDataAction(
              title: AppLocalizations.of(context)!.xNumbers('5'),
              disabled: true,
              action: () => Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => const UserGuessLowerLuckPage(
                            numLength: 5,
                          )))
                  .then((value) => reload()),
              tag: '5HM',
              disabledCheckTag: '5')
        ],
      ),
      MenuData(
        title: AppLocalizations.of(context)!.machineGuessTitle,
        subtitle: AppLocalizations.of(context)!.machineGuessSubtitle,
        icon: Icons.devices,
        multiAction: [
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('3'),
            disabled: false,
            action: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const MachineGuessPage(
                      numLength: 3,
                    ))),
          ),
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('4'),
            disabled: false,
            action: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const MachineGuessPage(
                      numLength: 4,
                    ))),
          ),
          MenuDataAction(
            title: AppLocalizations.of(context)!.xNumbers('5'),
            disabled: false,
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
      ),
      drawer: Drawer(
          child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: Text(AppLocalizations.of(context)!.resetBestRecordTitle),
              onTap: () {
                Navigator.of(context).pop();
                resetBestScore();
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text(AppLocalizations.of(context)!.websiteTitle),
              onTap: () {
                Navigator.of(context).pop();
                launchUrlString(
                    'https://sites.google.com/view/ycyprogram/1a2b');
              },
            ),
            ListTile(
              leading: const Icon(CommunityMaterialIcons.license),
              title: Text(AppLocalizations.of(context)!.licenseTitle),
              onTap: () {
                Navigator.of(context).pop();
                showLicensePage(
                    context: context,
                    applicationName: '1A2B',
                    applicationLegalese: '©2022 YCY Program');
              },
            )
          ],
        ),
      )),
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: menuDataList.length,
          itemBuilder: (context, idx1) {
            final menuData = menuDataList[idx1];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: menuData.action,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      menuData.icon,
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
                                            menuData.title,
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.grey.shade900,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            menuData.subtitle,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ]))
                                  ]),
                            ),
                          ),
                          if (menuData.multiAction is List<MenuDataAction>)
                            for (int i = 0;
                                i < menuData.multiAction!.length * 2;
                                i++)
                              Builder(
                                builder: (context) {
                                  if (i.isEven) {
                                    return const Divider(
                                      thickness: 2,
                                    );
                                  } else {
                                    final int idx2 = ((i - 1) / 2).round();
                                    final actionData =
                                        menuData.multiAction![idx2];
                                    if (actionData.disabledCheckTag == null) {
                                      return MenuAction(
                                        disabled: actionData.disabled,
                                        title: actionData.title,
                                        tag: actionData.tag,
                                        action: actionData.action,
                                      );
                                    } else {
                                      return FutureBuilder(
                                          future: SPUtil().getBsetScore(
                                              tag: actionData.disabledCheckTag
                                                  as String),
                                          builder: (context, snap) {
                                            return MenuAction(
                                              disabled: !snap.hasData,
                                              title: actionData.title,
                                              tag: actionData.tag,
                                              action: actionData.action,
                                            );
                                          });
                                    }
                                  }
                                },
                              )
                        ],
                      ))),
            );
          }),
    );
  }

  void reload() => setState(() {});
  void resetBestScore() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.resetBestRecordTitle),
            content: Text(AppLocalizations.of(context)!.resetBestRecordContent),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    AppLocalizations.of(context)!.deleteBtn,
                    style: const TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(AppLocalizations.of(context)!.cancelBtn))
            ],
          );
        }).then((value) {
      if (value == true) {
        SPUtil().resetBestScore(tagList: ['3', '4', '5', '3HM', '4HM', '5HM']);
        reload();
      }
    });
  }
}

class MenuAction extends StatelessWidget {
  const MenuAction(
      {super.key,
      required this.disabled,
      required this.title,
      this.tag,
      this.action});
  final bool disabled;
  final String title;
  final String? tag;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: disabled
          ? const Icon(Icons.lock)
          : const Icon(Icons.play_circle_outline),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.blue,
        ),
      ),
      trailing: tag == null
          ? null
          : FutureBuilder(
              future: SPUtil().getBsetScore(tag: tag as String),
              builder: (context, snap) {
                if (snap.hasData) {
                  return Text(AppLocalizations.of(context)!
                      .times(snap.data.toString()));
                } else {
                  return const Text('');
                }
              }),
      onTap: disabled
          ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.itemDisabled)))
          : action,
    );
  }
}

@immutable
class MenuData {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? action;
  final List<MenuDataAction>? multiAction;
  const MenuData(
      {required this.title,
      required this.subtitle,
      required this.icon,
      this.action,
      this.multiAction});
}

class MenuDataAction {
  final String title;
  final bool disabled;
  final VoidCallback? action;
  final String? tag;
  final String? disabledCheckTag;
  MenuDataAction(
      {required this.title,
      required this.disabled,
      this.tag,
      this.disabledCheckTag,
      this.action});
}
