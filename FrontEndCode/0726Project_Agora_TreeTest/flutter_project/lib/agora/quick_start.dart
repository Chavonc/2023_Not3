import 'dart:async';

import 'package:fastboard_flutter/fastboard_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    // 檢查用戶是否已登錄
    bool isLoggedIn = false; // 替換為實際的登錄檢查

    return isLoggedIn ? const QuickStartBody() : FreeLeafExample(); // 切換頁面
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

   // 這是應用程序的根節點小工具。
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Start'), // 快速啟動標題
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
            child: InkWell(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {
                Navigator.of(context).pop(); // 點擊返回按鈕時，返回前一頁
              },
            ),
            left: 24,
            top: 24,
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
          child: FastPageIndicator(controller),
          bottom: FastGap.gap_3,
          right: FastGap.gap_3,
        ),
        FastToolBoxExpand(controller),
        FastStateHandlerView(controller),
      ],
    );
  }

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // 隱藏系統UI元素（例如狀態欄和導航欄）
  }

  @override
  void dispose() {
    super.dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
  }
}
