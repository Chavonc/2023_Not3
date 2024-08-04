// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project/screens/GardenerSettingPage.dart';
import 'package:flutter_project/screens/ChatPage.dart';
import 'package:flutter_project/screens/StartFruitsPage.dart';
import 'package:flutter_project/screens/StartLeafPage.dart';
import 'package:flutter_project/AnimationBottomBar.dart';
import 'package:permission_handler/permission_handler.dart'; // 權限處理plugin
import 'package:volume_control/volume_control.dart'; // 音量控制plugin
import 'package:camera/camera.dart'; // 相機功能plugin
import 'package:mic_stream/mic_stream.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

class MyPage1 extends StatefulWidget {
  const MyPage1({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MyPage1State createState() => _MyPage1State();
}

class _MyPage1State extends State<MyPage1> {
  int pageIndex = 0;
  List<Widget> pageItem = [];
  // ignore: non_constant_identifier_names
  bool switchValue_Volume = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Mic = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Camera = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Notify = true;

  CameraController? controller; // 建立全域的相機控制器變數


  @override
  void initState() {
    super.initState();
    pageItem = [
      const ChatPage(),
      const StartLeafPage(),
      const StartFruitsPage()
    ];
  }

  final List<BarItemData> barItems = [
    BarItemData(
        "聊天室", Icons.accessibility, const Color.fromARGB(210, 48, 135, 24)),
    BarItemData("葉子", Icons.energy_savings_leaf,
        const Color.fromARGB(210, 48, 135, 24)),
    BarItemData("檢視果實", Icons.feed, const Color.fromARGB(210, 48, 135, 24))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Not3',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0.0, //陰影
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                color: Colors.green,
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: const [
                    SizedBox(width: 20),
                    CircleAvatar(
                      //圓形頭像
                      minRadius: 35,
                      maxRadius: 35,
                      backgroundImage: NetworkImage(
                        'https://memeprod.ap-south-1.linodeobjects.com/user-maker-thumbnail/a3079365d1a6e3d7d6919a03ae9eaf82.gif',
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Anya Forger",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              // Divider(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                //一個Padding是一個項目
                padding: const EdgeInsets.only(left: 15),
                child: GestureDetector(
                  onTap: (() {
                    // Navigator.pop(
                    //	 context,
                    //	 new MaterialPageRoute(
                    //		 builder: (context) => new HomePageMain()));
                  }),
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Icon(Icons.person),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: TextButton(
                          child: const Text(
                            "使用者檔案",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const GardenerSettingPage()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ExpansionTile(
                //下拉式
                title: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: const [
                    Icon(CupertinoIcons.settings),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "設定",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
                childrenPadding:
                    const EdgeInsets.only(left: 25), // children padding
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding //這裡修改0801
                      (
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      onTap: (() {
                        // Navigator.push(
                        //	 context,
                        //	 new MaterialPageRoute(
                        //		 builder: (context) => new VendorVenuePage()));
                      }),
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Icon(
                            CupertinoIcons.waveform_circle_fill,
                            color: Colors.black87,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "音量",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                          const Spacer(),
                          CupertinoSwitch(
                            // This bool value toggles the switch.
                            value: switchValue_Volume,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                switchValue_Volume = value ?? false;
                                controlVolume(switchValue_Volume);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      onTap: (() {
                        // Navigator.push(
                        //	 context,
                        //	 new MaterialPageRoute(
                        //		 builder: (context) =>
                        //			 new VendorPhotographerPage()));
                      }),
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(Icons.camera_alt_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "鏡頭",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                          const Spacer(),
                          CupertinoSwitch(
                            // This bool value toggles the switch.
                            value: switchValue_Camera,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                switchValue_Camera = value ?? false;
                                controlCamera();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      onTap: (() {
                        // Navigator.push(
                        //	 context,
                        //	 new MaterialPageRoute(
                        //		 builder: (context) =>
                        //			 new VendorCenematographyPage()));
                      }),
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(Icons.mic),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "麥克風",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                          const Spacer(),
                          CupertinoSwitch(
                            // This bool value toggles the switch.
                            value: switchValue_Mic,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                switchValue_Mic = value ?? false;
                                controlMicrophone();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      onTap: (() {
                        // Navigator.push
                        // (
                        //	 context,
                        //	 new MaterialPageRoute
                        //(
                        //		 builder: (context) => new VendorMakeupPage()),
                        //);
                      }),
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Icon(Icons.notifications),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "通知",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                          const Spacer(),
                          CupertinoSwitch(
                            // This bool value toggles the switch.
                            value: switchValue_Notify,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                switchValue_Notify = value ?? false;
                                controlNotifications(switchValue_Notify);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  //more child menu
                ],
              ),
              // const SizedBox
              // (
              // height: 10,
              // ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: pageIndex,
        children: pageItem,
      ),
      bottomNavigationBar: AnimationBottomBar(
        barItemsData: barItems,
        barStyle: BarStyle(
            fontSize: 20.0, fontWeight: FontWeight.w400, iconSize: 30.0),
        changePageIndex: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }

  // 控制音量開關
void controlVolume(switchValue_Volume) async {
  if (switchValue_Volume) {
    // 開啟音量
    await VolumeControl.setVolume(0.5); // 設定音量為0.5
  } else {
    // 關閉音量
    await VolumeControl.setVolume(0.0); // 設定音量為0
  }
}

// 控制鏡頭開關
void controlCamera() async {
  if (switchValue_Camera) {
    // 開啟相機
    try {
      List<CameraDescription> cameras = await availableCameras();
      controller = CameraController(cameras[0], ResolutionPreset.medium,imageFormatGroup: ImageFormatGroup.yuv420,);
      await controller!.initialize();
      controller!.startImageStream((image) {
        // 在這裡處理相機預覽圖像，例如顯示在UI上
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  } else {
    // 關閉相機
    if (controller != null) {
      controller!.stopImageStream(); // 停止相機預覽圖像流
      controller!.dispose(); // 釋放相機控制器
      controller = null; // 將相機控制器設為空
    }
  }
}

// 控制麥克風開關
void controlMicrophone() async {
  if (switchValue_Mic) {
    // 開啟麥克風
    try {
      const MethodChannel _channel = MethodChannel('mic_stream');
      await _channel.invokeMethod('start');
      _channel.setMethodCallHandler((call) async {
        if (call.method == "samples") {
          List<int> samples = List.from(call.arguments);
          Uint8List uint8Samples = Uint8List.fromList(samples);
          // 在這裡處理麥克風數據(uint8Samples)
          print(uint8Samples); // 輸出麥克風數據
        }
      });
    } on PlatformException catch (e) {
      print("Failed to start microphone: ${e.message}");
    }
  } else {
    // 關閉麥克風
    try {
      const MethodChannel _channel = MethodChannel('mic_stream');
      await _channel.invokeMethod('stop');
    } on PlatformException catch (e) {
      print("Failed to stop microphone: ${e.message}");
    }
  }
}

// 控制通知開關
void controlNotifications(bool? value) {
  setState(() {
    switchValue_Notify = value ?? false;
  });

  if (switchValue_Notify) {
    // 開啟通知
    // 處理相應邏輯，例如顯示通知、設置通知提醒等
    // 這裡只是一個示例，請根據實際需求進行處理
    showNotification();
  } else {
    // 關閉通知
    // 處理相應邏輯，例如取消通知、關閉通知提醒等
    // 這裡只是一個示例，請根據實際需求進行處理
    cancelNotification();
  }
}

void showNotification() {
  // 使用mic_stream套件模擬通知的開啟
  // 這裡只是一個示例，請根據實際需求進行處理
  print("Notification is turned on");
}

void cancelNotification() {
  // 使用mic_stream套件模擬通知的關閉
  // 這裡只是一個示例，請根據實際需求進行處理
  print("Notification is turned off");
}
}
