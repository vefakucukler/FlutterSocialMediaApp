import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/sayfalar/renk.dart';

int level = 8;

class Home extends StatefulWidget {
  final int size;

  const Home({Key key, this.size = 8}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  List<bool> cardFlips = [];
  List<String> data = [];
  int previousIndex = -1;
  bool flip = false;

  int time = 0;
  Timer timer;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.size; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
      cardFlips.add(true);
    }
    for (var i = 0; i < widget.size ~/ 2; i++) {
      data.add(i.toString());
    }
    for (var i = 0; i < widget.size ~/ 2; i++) {
      data.add(i.toString());
    }
    startTimer();
    data.shuffle();
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        time = time + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KprimaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Eşini Bul Oyunu"),
        elevation: 0,
        backgroundColor: KprimaryColor,
      ),
      body: Center(
        child: Container(
          width: size.width * 0.96,
          height: size.height * 0.87,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "$time",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Theme(
                    data: ThemeData.dark(),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) => FlipCard(
                          key: cardStateKeys[index],
                          onFlip: () {
                            if (!flip) {
                              flip = true;
                              previousIndex = index;
                            } else {
                              flip = false;
                              if (previousIndex != index) {
                                if (data[previousIndex] != data[index]) {
                                  cardStateKeys[previousIndex]
                                      .currentState
                                      .toggleCard();
                                  previousIndex = index;
                                } else {
                                  cardFlips[previousIndex] = false;
                                  cardFlips[index] = false;
                                  print(cardFlips);

                                  if (cardFlips.every((t) => t == false)) {
                                    print("Tebrikler");
                                    showResult();
                                  }
                                }
                              }
                            }
                          },
                          direction: FlipDirection.HORIZONTAL,
                          flipOnTouch: cardFlips[index],
                          front: Container(
                            margin: EdgeInsets.all(4.0),
                            color: KprimaryColor,
                          ),
                          back: Container(
                            margin: EdgeInsets.all(4.0),
                            color: Colors.deepOrange,
                            child: Center(
                              child: Text(
                                "${data[index]}",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ),
                        ),
                        itemCount: data.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Tebrikler"),
        content: Text(
          "Süre $time",
          style: Theme.of(context).textTheme.headline3,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Home(
                    size: level,
                  ),
                ),
              );
              level *= 2;
            },
            child: Text("Sonraki"),
          ),
        ],
      ),
    );
  }
}
