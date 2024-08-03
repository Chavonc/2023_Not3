import 'dart:async';

import 'package:fastboard_flutter/fastboard_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'page.dart';
import 'widgets.dart';

class CustomLayoutPage extends FastExamplePage {
  const CustomLayoutPage()
      : super(
        const Icon(Icons.space_dashboard_rounded),
        'Custom Layout',
      );

  @override
  Widget build(BuildContext context) {
    return const CustomLayoutBody();
  }
}

class CustomLayoutBody extends StatefulWidget {
  const CustomLayoutBody();

  @override
  State<StatefulWidget> createState() {
    return CustomLayoutBodyState();
  }
}

class CustomLayoutBodyState extends State<CustomLayoutBody> {
  Completer<FastRoomController> controllerCompleter = Completer();

  // 這個小工具是您應用程式的根
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 使用 LayoutBuilder 來獲取當前螢幕的寬高限制，並根據此來設置 FastRoomView 的 containerSizeRatio
        LayoutBuilder(
          builder: (context, constraints) {
            return FastRoomView(
              fastRoomOptions: FastRoomOptions(
                appId: APP_ID,
                uuid: ROOM_UUID,
                token: ROOM_TOKEN,
                uid: UNIQUE_CLIENT_ID,
                writable: true,
                fastRegion: FastRegion.cn_hz,
                containerSizeRatio: constraints.maxHeight / constraints.maxWidth,
              ),
              useDarkTheme: false,
              onFastRoomCreated: onFastRoomCreated,
              builder: customBuilder,
            );
          },
        ),
        FutureBuilder<FastRoomController>(
          future: controllerCompleter.future,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Positioned(
                    child: CloudTestWidget(controller: snapshot.data!),
                  )
                : Container();
          },
        ),
        Positioned(
          child: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          left: 24,
          top: 24,
        ),
      ],
    );
  }

  // 在此自訂 FastRoomView 中的佈局
  Widget customBuilder(
    BuildContext context,
    FastRoomController controller,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FastOverlayHandlerView(controller), // 覆蓋處理元素的視圖
        Positioned(
          child: FastPageIndicator(controller), // 頁面指示器
          bottom: FastGap.gap_3,
          right: FastGap.gap_3,
        ),
        FastToolBoxExpand(controller), // 工具箱展開按鈕
        FastStateHandlerView(controller), // 狀態處理元素的視圖
      ],
    );
  }

  Future<void> onFastRoomCreated(FastRoomController controller) async {
    controllerCompleter.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    super.dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
  }
}
