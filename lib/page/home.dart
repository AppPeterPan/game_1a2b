import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game_1a2b/l10n.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/page/history.dart';
import 'package:game_1a2b/page/machine_guess.dart';
import 'package:game_1a2b/page/user_guess.dart';
import 'package:game_1a2b/page/user_guess_lower_luck.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                resetBestScore(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(AppLocalizations.of(context)!.gameRecordTitle),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HistoryPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: Text('Rate'),
              onTap: () {
                Navigator.of(context).pop();
                rate(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text(AppLocalizations.of(context)!.websiteTitle),
              onTap: () {
                Navigator.of(context).pop();
                launchUrlString(
                  'https://sites.google.com/view/ycyprogram/1a2b',
                  mode: LaunchMode.externalApplication,
                );
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: HomeItem(
              icon: Icons.person,
              title: AppLocalizations.of(context)!.userGuessTitle,
              subtitle: AppLocalizations.of(context)!.userGuessSubtitle,
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.0),
                      ),
                    ),
                    builder: (context) => HomeItemMenu(children: [
                          MenuAction(
                            disabled: false,
                            title: AppLocalizations.of(context)!.xNumbers('3'),
                            action: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const UserGuessPage(
                                  numLength: 3,
                                ),
                              ),
                            ),
                            tag: '3',
                          ),
                          const Divider(),
                          MenuAction(
                            disabled: false,
                            title: AppLocalizations.of(context)!.xNumbers('4'),
                            action: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const UserGuessPage(
                                  numLength: 4,
                                ),
                              ),
                            ),
                            tag: '4',
                          ),
                          const Divider(),
                          MenuAction(
                            disabled: false,
                            title: AppLocalizations.of(context)!.xNumbers('5'),
                            action: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const UserGuessPage(
                                  numLength: 5,
                                ),
                              ),
                            ),
                            tag: '5',
                          ),
                        ]));
              },
            ),
          ),
          Expanded(
            child: HomeItem(
              icon: Icons.person,
              title: AppLocalizations.of(context)!.userGuessLowerLuckTitle,
              subtitle: AppLocalizations.of(context)!.userGuessSubtitle,
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.0),
                      ),
                    ),
                    builder: (context) => HomeItemMenu(children: [
                          FutureBuilder(
                              future: SPUtil().getBsetScore(tag: '3'),
                              builder: (context, snap) {
                                return MenuAction(
                                  disabled: !snap.hasData,
                                  title: AppLocalizations.of(context)!
                                      .xNumbers('3'),
                                  action: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const UserGuessLowerLuckPage(
                                        numLength: 3,
                                      ),
                                    ),
                                  ),
                                  tag: '3HM',
                                );
                              }),
                          const Divider(),
                          FutureBuilder(
                              future: SPUtil().getBsetScore(tag: '4'),
                              builder: (context, snap) {
                                return MenuAction(
                                  disabled: !snap.hasData,
                                  title: AppLocalizations.of(context)!
                                      .xNumbers('4'),
                                  action: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const UserGuessLowerLuckPage(
                                        numLength: 4,
                                      ),
                                    ),
                                  ),
                                  tag: '4HM',
                                );
                              }),
                          const Divider(),
                          FutureBuilder(
                              future: SPUtil().getBsetScore(tag: '5'),
                              builder: (context, snap) {
                                return MenuAction(
                                  disabled: !snap.hasData,
                                  title: AppLocalizations.of(context)!
                                      .xNumbers('5'),
                                  action: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const UserGuessLowerLuckPage(
                                        numLength: 5,
                                      ),
                                    ),
                                  ),
                                  tag: '5HM',
                                );
                              }),
                        ]));
              },
            ),
          ),
          Expanded(
            child: HomeItem(
              icon: Icons.devices,
              title: AppLocalizations.of(context)!.machineGuessTitle,
              subtitle: AppLocalizations.of(context)!.machineGuessSubtitle,
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.0),
                      ),
                    ),
                    builder: (context) => HomeItemMenu(children: [
                          MenuAction(
                            disabled: false,
                            title: AppLocalizations.of(context)!.xNumbers('3'),
                            action: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MachineGuessPage(
                                  numLength: 3,
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          MenuAction(
                            disabled: false,
                            title: AppLocalizations.of(context)!.xNumbers('4'),
                            action: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MachineGuessPage(
                                  numLength: 4,
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          MenuAction(
                            disabled: false,
                            title: AppLocalizations.of(context)!.xNumbers('5'),
                            action: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MachineGuessPage(
                                  numLength: 5,
                                ),
                              ),
                            ),
                          ),
                        ]));
              },
            ),
          ),
        ],
      ),
    );
  }

  void resetBestScore(BuildContext context) {
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
      }
    });
  }

  void rate(BuildContext context) {
    if (kIsWeb) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => RatingDialog(
          initialRating: 0,
          title: const Text(
            'Rating Dialog',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          message: const Text(
            'Tap a star to set your rating. Add more description here if you want.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          image: const Icon(
            Icons.rate_review,
            color: Colors.blue,
            size: 150,
          ),
          submitButtonText: 'Submit',
          commentHint: 'Set your custom comment hint',
          onSubmitted: (response) async {
            await http.get(Uri.https(
                'docs.google.com',
                '/forms/d/e/1FAIpQLScHznDs6xzF-1yM1T2kY-oNCfUOrMaU63xfzfFLVOxHiehJ5w/formResponse',
                {
                  'usp': 'pp_url',
                  'entry.2074980730': 'com.gmail.app97204.numbergame',
                  'entry.905102409': '${response.rating}',
                  'entry.1257025373': response.comment,
                }));
          },
        ),
      );
    } else {
      launchUrlString(
        'https://play.google.com/store/apps/details?id=com.gmail.app97204.numbergame',
        mode: LaunchMode.externalApplication,
      );
    }
  }
}

class HomeItem extends StatelessWidget {
  const HomeItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ]))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeItemMenu extends StatelessWidget {
  const HomeItemMenu({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

class MenuAction extends StatelessWidget {
  const MenuAction({
    super.key,
    required this.disabled,
    required this.title,
    required this.action,
    this.tag,
  });
  final bool disabled;
  final String title;
  final String? tag;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minLeadingWidth: 50,
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
        onTap: () {
          Navigator.of(context).pop();
          if (disabled) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!.itemDisabled)));
          } else {
            action();
          }
        });
  }
}
