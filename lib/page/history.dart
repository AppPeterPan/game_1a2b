import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_1a2b/cubit/history_cubit.dart';
import 'package:game_1a2b/l10n.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> appBarActions = [const _DeleteRecordBtn()];

    return Scaffold(
      backgroundColor: const Color(0xFFE5EAEA),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.gameRecordTitle),
        actions: appBarActions,
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state.gameRecordList.isEmpty) {
            return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: Text(
                 'No game record yet, let\'s start the game first!',
                  style: const TextStyle(fontSize: 25),
                ));
          } else {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.gameRecordList.length,
              itemBuilder: (context, idx) {
                IconData leading = Icons.circle;
                String title = '';
                final String subtitle = AppLocalizations.of(context)!
                    .times(state.gameRecordList[idx].times.toString());
                final String timeString =
                    state.gameRecordList[idx].dateTime.toString();
                final String trailing =
                    timeString.substring(0, timeString.indexOf('.'));
                switch (state.gameRecordList[idx].gameMode) {
                  case 0:
                    leading = Icons.person;
                    title = AppLocalizations.of(context)!.userGuessTitle;
                    break;
                  case 1:
                    leading = Icons.devices;
                    title = AppLocalizations.of(context)!.machineGuessTitle;
                    break;
                }
                return ListTile(
                  leading: Icon(leading),
                  title: Text(title),
                  subtitle: Text(subtitle),
                  trailing: Text(trailing),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _DeleteRecordBtn extends StatelessWidget {
  const _DeleteRecordBtn();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title:
                      Text(AppLocalizations.of(context)!.deleteAllRecordTitle),
                  content: Text(
                      AppLocalizations.of(context)!.deleteAllRecordContent),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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
            if (value) {
              BlocProvider.of<HistoryCubit>(context).deleteAllRecord();
            }
          });
        },
        icon: const Icon(Icons.delete_forever));
  }
}
