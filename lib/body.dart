import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_1a2b/data.dart';
import 'package:game_1a2b/guess.dart';

class AppBody extends StatefulWidget {
  final GlobalKey<AppBodyState> _key;
  const AppBody(this._key) : super(key: _key);

  @override
  State<AppBody> createState() => AppBodyState();

  restart() {
    _key.currentState?.restart();
  }

  showSnackBar(msg) {
    _key.currentState?.showSnackBar(msg);
  }
}

class AppBodyState extends State<AppBody> {
  List<GuessData> guess = [];
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: const Color.fromARGB(255, 188, 235, 236),
          child: SafeArea(
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
                onChanged: (txt) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  counterText: '',
                  suffixIcon: IconButton(
                      color: _inputController.text.length == 4
                          ? Colors.red
                          : Colors.grey,
                      onPressed: () {
                        if (_inputController.text.length == 4) {
                          inputComplete();
                        } else {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                      icon: Icon(
                        _inputController.text.length == 4
                            ? Icons.send
                            : Icons.keyboard,
                        size: 30,
                      )),
                  border: const OutlineInputBorder(),
                  labelText: '4 unique numbers',
                  hintText: 'Ex: 1234',
                )),
          ),
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
          guess.add(GuessData(_inputController.text, a, b));
          _inputController.clear();
        });
        Future.delayed(const Duration(milliseconds: 16)).then((value) =>
            _listController.animateTo(_listController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutQuart));
        if (a == 4) {
          SharedPreferencesUtil().setBestScore(guess.length).then(((bestScore) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('You guessed right!'),
                    content: Text(
                        'The answer is $ans,\nYou spend ${guess.length} times.\n' +
                            (bestScore == guess.length
                                ? 'You broke the record!'
                                : 'Your best record is: ' +
                                    bestScore.toString() +
                                    '.')),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK"))
                    ],
                  );
                }).then((value) => restart());
          }));
        }
      }
    }
  }

  void showSnackBar(String msg) {
    var snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () {},
      ),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void restart() {
    ans = answer();
    setState(() {
      guess = [];
    });
  }
}
