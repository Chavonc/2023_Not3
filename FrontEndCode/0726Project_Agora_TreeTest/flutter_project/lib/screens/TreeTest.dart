import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:flutter_project/utils/time_util.dart';

class TreeTest extends StatefulWidget {
  const TreeTest({Key? key}) : super(key: key);

  @override
  _TreeTestState createState() => _TreeTestState();
}

class _TreeTestState extends State<TreeTest> {

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<double>? _progress;
  String plantButtonText = "";

  int _treeProgress = 0;
  int _treeMaxProgress = 60; 

  @override
  void initState() {
    super.initState();
    plantButtonText = "Plant";
    rootBundle.load('assets/tree_demo.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(artboard, 'Grow');
        if (controller != null) {
          artboard.addController(controller);
          _progress = controller.findInput('input');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  // 按下Plant按鈕後，TreeProgress增加20，直到等於或超過60時重置為0
  void _onPlantButtonPressed() {
    setState(() {
      _treeProgress += 20; //增加級距
      if (_treeProgress > _treeMaxProgress) {
        _treeProgress = 0;
      }
      _progress?.value = _treeProgress.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    double treeWidth = MediaQuery.of(context).size.width - 40;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Text(
              "您的樹與花朵",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.normal),
            ),
          ),
          Expanded(
            child: Center(
              child: _riveArtboard == null
                  ? const SizedBox()
                  : Rive(alignment: Alignment.center, artboard: _riveArtboard!),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              _treeProgress.toString() + '個檔案',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text(
              "櫻花",
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: MaterialButton(
              height: 40.0,
              minWidth: 180.0,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: Colors.green,
              textColor: Colors.white,
              child: Text(plantButtonText),
              onPressed: _onPlantButtonPressed,
              splashColor: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }
}