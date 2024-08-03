import 'dart:async';
//import 'package:whiteboard_sdk_flutter/whiteboard_sdk_flutter.dart';
import 'package:fastboard_flutter/fastboard_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'dart:convert';
import 'constants.dart';
import 'page.dart';
import 'widgets.dart';
import 'package:flutter_project/agora/agora_service.dart'; // 引入LoginPage

// 定義快速啟動頁面
class QuickStartPage extends FastExamplePage {
  const QuickStartPage()
      : super(
          const Icon(Icons.rocket_launch_rounded),
          'Quick Start',
        );

  @override
  Widget build(BuildContext context) {
    return const QuickStartBody();
  }
}

class QuickStartBody extends StatefulWidget {
  const QuickStartBody();

  @override
  State<StatefulWidget> createState() {
    return QuickStartBodyState();
  }
}

class QuickStartBodyState extends State<QuickStartBody> {
  Completer<FastRoomController> completerController = Completer();
  final _storage = FlutterSecureStorage(); // 用於存儲 access_token
  Future<String?> getAccessToken() async {
    // 從 flutter_secure_storage 取得 access_token
    String? accessToken = await _storage.read(key: 'access_token');
    print('Access Token: $accessToken');
    return accessToken;
  }

  Future<void> showBanRoomResultDialog(
      BuildContext context, String message) async {
    //Ban房間對話框
    // 顯示Ban房間 API 回傳的結果
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool _is_videio_on = false;
  bool _is_message_on = false; //xian0519
  // ignore: non_constant_identifier_names
  bool switchValue_Volume = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Mic = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Camera = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Notify = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('葉子名稱'),
        ),
        actions: <Widget>[
          //越後面的button越右，由左往右的方向

          IconButton(
            tooltip: "彈幕",
            icon: _is_message_on
                ? const Icon(Icons.message)
                : const Icon(
                    Icons.speaker_notes_off,
                  ),
            onPressed: () {
              // do something
              setState(() {
                // Here we changing the icon.
                _is_message_on = !_is_message_on;
              });
            },
          ),
          IconButton(
            tooltip: "錄影",
            icon: _is_videio_on
                ? const Icon(Icons.videocam)
                : const Icon(
                    Icons.videocam_off,
                  ),
            onPressed: () {
              // do something
              setState(() {
                // Here we changing the icon.
                _is_videio_on = !_is_videio_on;
              });
            },
          ),
          IconButton(
            tooltip: "離開/結束",
            //最右邊
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),

            // do something 0815修改ban房間
            onPressed: () async {
              final savedAccessToken = await getAccessToken();
              if (savedAccessToken != null) {
                // 呼叫登出 API
                try {
                  final response = await http.post(
                    Uri.parse('http://120.126.16.222/leafs/disable-room'),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $savedAccessToken',
                    },
                    body: jsonEncode(<String, String>{
                      //'account': account,
                      'region': 'cn-hz',
                      'uuid': ROOM_UUID,
                    }),
                  );

                  if (response.statusCode >= 200 && response.statusCode < 300) {
                    final body = jsonDecode(response.body);

                    if (kDebugMode) {
                      print('GetBanRoom API Response: $body');
                    }
                    // 輸出ban房間成功的回傳資料
                    // ignore: non_constant_identifier_names
                    final Message = body[0]['error_message'];
                    if (Message == '房間不存在' || Message == '不是此房間創始人，不能關閉房間') {
                      // ignore: use_build_context_synchronously
                      await showBanRoomResultDialog(context, Message);
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop(); //跳回上一步驟
                    }
                  } else {
                    // 失敗
                    final errorMessage = response.body;
                    await showBanRoomResultDialog(context, errorMessage);
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print('Ban房失敗：$e');
                  }
                  final errorMessage = 'Ban房失敗：$e';
                  await showBanRoomResultDialog(context, errorMessage);
                }
              } else {
                // 沒有保存的 access_token，直接顯示錯誤訊息
                const errorMessage = '尚未登入，無法進行登出。';
                await showBanRoomResultDialog(context, errorMessage);
              }
            },
          ),
        ],
        backgroundColor: Colors.green,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          FastRoomView(
            fastRoomOptions: FastRoomOptions(
              appId: APP_ID, // 從constant.dart中獲取的Agora應用程式ID
              uuid: ROOM_UUID, // 從constant.dart中獲取的Agora房間UUID
              token: ROOM_TOKEN, // 從constant.dart中獲取的Agora房間令牌
              uid: UNIQUE_CLIENT_ID, // 自定義的用戶ID
              writable: true, // 房間是否可寫（可編輯）
              fastRegion: FastRegion.cn_hz, // 快速的區域（此處為杭州地區）
              containerSizeRatio: null, // 容器大小比例，此處為空
            ),
            useDarkTheme: false, // 使用淺色主題
            onFastRoomCreated: onFastRoomCreated, // 當FastRoomController創建時的回調函數
          ),
          FutureBuilder<FastRoomController>(
            future: completerController.future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return Positioned(
                  child: CloudTestWidget(controller: snapshot.data!),
                );
              } else {
                return Container();
              }
            },
          ),
          Positioned(
            left: 30,
            top: 30,
            child: InkWell(
              child: const Icon(Icons.face),
              onTap: () {
                // 點擊face 按鈕時，動作
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String textToCopy = 'Someone sent you a link : $LINK';

                    return AlertDialog(
                      title: const Text('複製連結'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: TextEditingController(text: textToCopy),
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '複製連結',
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: textToCopy));
                              Navigator.of(context).pop(); // 關閉警示框
                            },
                            child: Text('複製連結'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget customControllerBuilder(
    BuildContext context,
    FastRoomController controller,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FastOverlayHandlerView(controller),
        Positioned(
          //頁數增加
          child: FastPageIndicator(controller),
          bottom: FastGap.gap_3,
          right: FastGap.gap_3,
        ),
        FastToolBoxExpand(controller), //工具箱
        FastStateHandlerView(controller), //工具箱縮放
        Positioned(
          child: InkWell(
            //0815
            child: Icon(Icons.power_settings_new), // 自訂斷開連接的按鈕圖示
            onTap: () {
              // 點擊按鈕時，執行斷開連接的操作
              if (controller != null) {
                controller.disconnect(); // 執行斷開連接的函式
                Navigator.pop(context); // 回到上一頁
              }
            },
          ),
          bottom: FastGap.gap_3,
          right: FastGap.gap_3,
        ),
      ],
    );
  }

  //Fastborad創建的地方
  Future<void> onFastRoomCreated(FastRoomController controller) async {
    completerController.complete(controller);
  }


  @override
  void initState() {
    super.initState();
   
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]); // 設置首選方向（支持橫屏和豎屏）
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky); // 隱藏系統UI元素（例如狀態欄和導航欄）
  }
}
