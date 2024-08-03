import 'package:flutter/material.dart';
import 'package:flutter_project/agora/agora_model.dart';
import 'package:flutter_project/agora/quick_start.dart';
import 'package:flutter_project/agora/constants.dart';

class FreeLeafExample extends StatefulWidget {
  const FreeLeafExample({Key? key}) : super(key: key);

  @override
  _FreeLeafExampleState createState() => _FreeLeafExampleState();
}

class _FreeLeafExampleState extends State<FreeLeafExample> {
  final TextEditingController _regionController = TextEditingController();
  Future<List<LoginModel>>? _futureLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora API Information(Post) Post'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: (_futureLogin == null) ? buildColumn() : buildFutureBuilder(),
      ),
    );
  }

  // 顯示輸入地區的TextField和提交按鈕的Column
  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 300,
          height: 80,
          child: TextField(
            controller: _regionController,
            decoration: const InputDecoration(
              hintText: 'Enter Account for region',
              labelText: "地區",
              prefixIcon: Icon(Icons.person),
            ),
          ),
        ),
        SizedBox(
          width: 150,
          height: 48,
          child: ElevatedButton(
            onPressed: () async {
              // 當按鈕被點擊時，將輸入的地區值傳遞到createLogin函數中發送API請求
              setState(() {
                _futureLogin = createLogin(_regionController.text);
              });
              try {
                var loginModels = await _futureLogin;
                if (loginModels != null && loginModels.isNotEmpty) {
                  // 如果API回傳了有效數據，則更新constant.dart中的值
                  APP_ID = loginModels[0].appIdentifier;
                  ROOM_UUID = loginModels[0].uuid;
                  ROOM_TOKEN = loginModels[0].roomToken;
                  // 導航到QuickStartBody頁面執行功能
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuickStartBody()),
                  );
                } else {
                  // 處理API回傳資料為空的情況
                  print('API response is empty');
                }
              } catch (e) {
                // 處理錯誤情況，例如API請求失敗
                print('Error: $e');
              }
            },
            child: const Text('Show'), // 按鈕上的文字
          ),
        ),
      ],
    );
  }

  // 顯示處理API請求結果的FutureBuilder
  FutureBuilder<List<LoginModel>> buildFutureBuilder() {
    return FutureBuilder<List<LoginModel>>(
      future: _futureLogin,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 當API請求進行中時顯示一個進度指示器
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // 如果API請求成功且回傳了有效數據，不需要再重複顯示頁面，直接導航到QuickStartBody
          return Container();
        } else if (snapshot.hasError) {
          // 處理API請求錯誤的情況
          return Text('${snapshot.error}');
        } else {
          // 處理API回傳資料為空的情況
          return const Text('No data available');
        }
      },
    );
  }
}
