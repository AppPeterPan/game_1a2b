import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1A2B'),
      ),
      body: const AppBody(),
    );
  }
}

class AppBody extends StatefulWidget {
  const AppBody({Key? key}) : super(key: key);

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  List<_GuessData> guess = [];
  String ans = '';
  bool sendDisable = true;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _listController = ScrollController();
  @override
  void initState() {
    super.initState();
    guess = [];
    ans = answer();
    print(ans);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: ListView.builder(
                controller: _listController,
                itemCount: guess.length,
                itemBuilder: (context, idx) {
                  return Card(
                    color: Colors.grey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${idx+1}. ${guess[idx].guess} ${guess[idx].a}A${guess[idx].b}B',
                        style: const TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  );
                })),
        Row(
          children: <Widget>[
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                  ],
                  onChanged: (data) {
                    setState(() {
                      sendDisable = _inputController.text.length < 4;
                    });
                  },
                  keyboardType: TextInputType.number,
                  controller: _inputController,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '4 numbers',
                    hintText: 'Ex: 1234',
                  )),
            ),
            IconButton(
                onPressed: () {
                  if (_inputController.text.length == 4) {
                    setState(() {
                      guess.add(_GuessData(_inputController.text, 0, 0));
                      _inputController.clear();
                    });
                    Future.delayed(const Duration(milliseconds: 16)).then(
                        (value) => _listController.animateTo(
                            _listController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutQuart));
                  }
                },
                color: sendDisable ? Colors.black : Colors.red,
                icon: const Icon(Icons.send)),
          ],
        )
      ],
    );
  }

  String answer() {
    String ansString = '';
    List numList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    for (int i = 9; i > 5; i--) {
      int ranNum = Random().nextInt(i);
      ansString = ansString + numList[ranNum].toString();
      numList.removeAt(ranNum);
    }
    return ansString;
  }
}

class _GuessData {
  final String _guessNum;
  final int _a;
  final int _b;
  _GuessData(this._guessNum, this._a, this._b);
  get guess => _guessNum;
  get a => _a;
  get b => _b;
}
