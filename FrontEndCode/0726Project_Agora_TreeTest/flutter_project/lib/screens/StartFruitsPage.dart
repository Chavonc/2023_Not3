import 'package:flutter/material.dart';
import 'package:flutter_project/MyPage2.dart';
import 'package:flutter_project/screens/TreeTest.dart';

class StartFruitsPage extends StatefulWidget {
  const StartFruitsPage({Key? key}) : super(key: key);

  @override
  _StartFruitsPageState createState() => _StartFruitsPageState();
}

class _StartFruitsPageState extends State<StartFruitsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Center(
            child: Text(
              "透過創建Tree來分類您的葉子們優",
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Container(
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/StartFruits_2.png',
                  width: 150, height: 150),
            ),
          ),
          Center(
            child: Container(
              height: 60,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color.fromARGB(222, 5, 202, 169),
                borderRadius: BorderRadius.circular(0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyPage2()),
                  );
                },
                child: const Text(
                  '創建我的Tree',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // 添加間距
          // 新增的 Tree test 按鈕
          TextButton(
            onPressed: () {
              // 在這裡處理 Tree test 按鈕的動作
              // 例如跳轉到其他頁面或執行特定操作
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TreeTest()),
                  );
            },
            child: const Text(
              'Tree test',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
