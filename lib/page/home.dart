import 'package:flutter/material.dart';
import 'package:game_1a2b/page/machine_guess.dart';
import 'package:game_1a2b/page/user_guess.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xE5EAEAFF),
      appBar: AppBar(
        title: const Text('1A2B'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            MenuItem(
                icon: Icons.person,
                title: 'User Guess',
                actionIcon: Icons.play_arrow,
                action: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UserGuessPage()));
                }),
            MenuItem(
                icon: Icons.devices,
                title: 'Machine Guess',
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
