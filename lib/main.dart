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
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _listController = ScrollController();
  @override
  void initState() {
    super.initState();
    guess = [];
    ans = answer();
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
                          horizontal: 10, vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${idx + 1}. ${guess[idx].guess} ${guess[idx].a}A${guess[idx].b}B',
                        style:
                            const TextStyle(fontSize: 25, color: Colors.white),
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
                  keyboardType: TextInputType.number,
                  controller: _inputController,
                  maxLength: 4,
                  style: const TextStyle(fontSize: 20),
                  onEditingComplete: () {
                    inputComplete();
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '4 unique numbers',
                    hintText: 'Ex: 1234',
                  )),
            ),
            IconButton(
                onPressed: () {
                  inputComplete();
                },
                color: Colors.red,
                icon: const Icon(Icons.send)),
          ],
        )
      ],
    );
  }

  //取得隨機答案
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

  //判斷書入內容是否重複
  bool inputRepeat(String input) {
    for (int i1 = 0; i1 < 3; i1++) {
      for (int i2 = i1 + 1; i2 < 4; i2++) {
        if (input[i1] == input[i2]) return true;
      }
    }
    return false;
  }

  void inputComplete() {
    String input = _inputController.text;
    if (input.length < 4) {
      showSnackBar('Input must be 4 numbers.');
    } else {
      if (inputRepeat(input)) {
        showSnackBar('Input must be unique.');
      } else {
        int a = 0;
        int b = 0;
        for (int i1 = 0; i1 < 4; i1++) {
          for (int i2 = 0; i2 < 4; i2++) {
            if (input[i1] == ans[i2]) {
              if (i1 == i2) {
                a++;
              } else {
                b++;
              }
            }
          }
        }

        setState(() {
          guess.add(_GuessData(_inputController.text, a, b));
          _inputController.clear();
        });
        Future.delayed(const Duration(milliseconds: 16)).then((value) =>
            _listController.animateTo(_listController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutQuart));
        if (a == 4) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Your answer $input is correct!'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("OK"))
                  ],
                );
              }).then((value) {
            ans = answer();
            setState(() {
              guess = [];
            });
            showSnackBar('Play it again!');
          });
        }
      }
    }
  }

  void showSnackBar(String msg) {
    var snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
