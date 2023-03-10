import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game_1a2b/l10n.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/page/history.dart';
import 'package:game_1a2b/page/machine_guess.dart';
import 'package:game_1a2b/page/user_guess.dart';
import 'package:game_1a2b/page/user_guess_lower_luck.dart';
import 'package:game_1a2b/web_app_review.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              title: Text(AppLocalizations.of(context)!.rateTitle),
              onTap: () {
                Navigator.of(context).pop();
                rateByUser(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text(AppLocalizations.of(context)!.websiteTitle),
              onTap: () async {
                Navigator.of(context).pop();
                if (await canLaunchUrlString(
                    'https://sites.google.com/view/ycyprogram/1a2b')) {
                  launchUrlString(
                    'https://sites.google.com/view/ycyprogram/1a2b',
                    mode: LaunchMode.externalApplication,
                  );
                }
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
                    applicationLegalese: '??2022 YCY Program');
              },
            )
          ],
        ),
      )),
      body: const _Body(),
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

  Future<void> rateByUser(BuildContext context) async {
    if (kIsWeb) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const WebInAppReview(),
      );
    } else {
      if (await canLaunchUrlString(
          'https://sites.google.com/view/ycyprogram/1a2b')) {
        launchUrlString(
          'https://play.google.com/store/apps/details?id=com.gmail.app97204.numbergame',
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }
}

Future<void> rateByApp(BuildContext context) async {
  List historyRecord = await SPUtil().getHistory();
  bool rated = await SPUtil().checkRated();
  if ((historyRecord.length >= 5 && !rated) ||
      historyRecord.length % 100 == 0) {
    if (kIsWeb) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const WebInAppReview(),
      ).then((value) => SPUtil().rated());
    } else {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview().then((value) => SPUtil().rated());
      }
    }
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 750),
    vsync: this,
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          AnimatedBuilder(
              animation: _controller,
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
                              title:
                                  AppLocalizations.of(context)!.xNumbers('3'),
                              action: () => Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (_) => const UserGuessPage(
                                    numLength: 3,
                                  ),
                                ),
                              )
                                  .then((value) {
                                if (value is bool && value == true) {
                                  rateByApp(context);
                                }
                              }),
                              tag: '3',
                            ),
                            const Divider(),
                            MenuAction(
                              disabled: false,
                              title:
                                  AppLocalizations.of(context)!.xNumbers('4'),
                              action: () => Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (_) => const UserGuessPage(
                                    numLength: 4,
                                  ),
                                ),
                              )
                                  .then((value) {
                                if (value is bool && value == true) {
                                  rateByApp(context);
                                }
                              }),
                              tag: '4',
                            ),
                            const Divider(),
                            MenuAction(
                              disabled: false,
                              title:
                                  AppLocalizations.of(context)!.xNumbers('5'),
                              action: () => Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (_) => const UserGuessPage(
                                    numLength: 5,
                                  ),
                                ),
                              )
                                  .then((value) {
                                if (value is bool && value == true) {
                                  rateByApp(context);
                                }
                              }),
                              tag: '5',
                            ),
                          ]));
                },
              ),
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeIn,
                  ),
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0, 100 * (_controller.value - 1), 0),
                      child: child),
                );
              }),
          AnimatedBuilder(
              animation: _controller,
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
                                    action: () => Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const UserGuessLowerLuckPage(
                                          numLength: 3,
                                        ),
                                      ),
                                    )
                                        .then((value) {
                                      if (value is bool && value == true) {
                                        rateByApp(context);
                                      }
                                    }),
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
                                    action: () => Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const UserGuessLowerLuckPage(
                                          numLength: 4,
                                        ),
                                      ),
                                    )
                                        .then((value) {
                                      if (value is bool && value == true) {
                                        rateByApp(context);
                                      }
                                    }),
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
                                    action: () => Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const UserGuessLowerLuckPage(
                                          numLength: 5,
                                        ),
                                      ),
                                    )
                                        .then((value) {
                                      if (value is bool && value == true) {
                                        rateByApp(context);
                                      }
                                    }),
                                    tag: '5HM',
                                  );
                                }),
                          ]));
                },
              ),
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeIn,
                  ),
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0, 100 * (_controller.value - 1), 0),
                      child: child),
                );
              }),
          AnimatedBuilder(
              animation: _controller,
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
                              title:
                                  AppLocalizations.of(context)!.xNumbers('3'),
                              action: () => Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (_) => const MachineGuessPage(
                                    numLength: 3,
                                  ),
                                ),
                              )
                                  .then((value) {
                                if (value is bool && value == true) {
                                  rateByApp(context);
                                }
                              }),
                            ),
                            const Divider(),
                            MenuAction(
                              disabled: false,
                              title:
                                  AppLocalizations.of(context)!.xNumbers('4'),
                              action: () => Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (_) => const MachineGuessPage(
                                    numLength: 4,
                                  ),
                                ),
                              )
                                  .then((value) {
                                if (value is bool && value == true) {
                                  rateByApp(context);
                                }
                              }),
                            ),
                            const Divider(),
                            MenuAction(
                              disabled: false,
                              title:
                                  AppLocalizations.of(context)!.xNumbers('5'),
                              action: () => Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (_) => const MachineGuessPage(
                                    numLength: 5,
                                  ),
                                ),
                              )
                                  .then((value) {
                                if (value is bool && value == true) {
                                  rateByApp(context);
                                }
                              }),
                            ),
                          ]));
                },
              ),
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeIn,
                  ),
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0, 100 * (_controller.value - 1), 0),
                      child: child),
                );
              }),
        ],
      ),
    );
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
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey.shade900
                                    : Colors.white),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade400,
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
