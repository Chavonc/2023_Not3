import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:carousel_slider/carousel_slider.dart";
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/screens/AnimationFruitsPage.dart';
import 'package:flutter_project/screens/GardenerSettingPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

String? firstName;
String? account;
Uint8List? avatarImageBytes;
File? _imageFile;
Uint8List? _imageBytes;
String? _imageFileName;
String? avatarName;
var imageName;
String? folderName = ''; // 用於儲存輸入的資料夾名稱

class OpenFruitsPage extends StatefulWidget {
  const OpenFruitsPage({super.key});
  @override
  //ignore: library_private_types_in_public_api
  _OpenFruitsPageState createState() => _OpenFruitsPageState();
}

class _OpenFruitsPageState extends State<OpenFruitsPage> {
  int _currentPageIndex = 0; // 用於跟踪當前頁面的索引
  // ignore: non_constant_identifier_names
  bool switchValue_Volume = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Mic = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Camera = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Notify = true;
  final _storage = const FlutterSecureStorage(); // 用於存儲 access_token
  final TextEditingController _createPlantController = TextEditingController();
  String? firstName;
  String? account;
  String? avatarFileName;
  Uint8List? avatarImageBytes;

  final List<String> _pageData = <String> // 定義頁面視圖數據
      [
    'assets/images/marigold.png|金盞花', // 添加金盞花對應的名稱
    'assets/images/SunFlower.png|太陽花', // 添加太陽花對應的名稱
    'assets/images/Greentree.png|玫瑰花', // 添加綠樹對應的名稱
  ];
  Future<String?> getAccessToken() async {
    // 從 flutter_secure_storage 取得 access_token
    String? accessToken = await _storage.read(key: 'access_token');
    if (kDebugMode) {
      print('Access Token: $accessToken');
    }
    return accessToken;
  }

  Future<void> deleteAccessToken() async {
    // 從 flutter_secure_storage 刪除 access_token
    await _storage.delete(key: 'access_token');
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async //顯示drawer的user資料
  {
    final savedAccessToken = await getAccessToken();
    if (savedAccessToken != null) {
      try {
        final response = await http.post(
          Uri.parse('http://120.126.16.222/gardeners/show-info'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $savedAccessToken',
          },
          body: jsonEncode(<String, String>{
            'access_token': savedAccessToken,
          }),
        );
        if (response.statusCode == 200) {
          // 解析API回傳的JSON數據
          final userInfo = jsonDecode(response.body);
          final userName = userInfo[0]['firstname'];
          final userAccount = userInfo[0]['account'];
          final avatarPath = userInfo[0]['file_path'];
          final avatarFileName = avatarPath.split('/').last;
          setState(() {
            firstName = userName;
            account = userAccount;
            this.avatarFileName = avatarFileName;
            avatarName = avatarFileName.split('.').first;
            if (kDebugMode) {
              print('帳號名字:$firstName');
              print('檔名:$avatarFileName');
              print('帳號名:$avatarName');
            }
          });
          await getAvatar(); //取得頭像圖檔
        } else {
          setState(() {
            firstName = null;
          });
          if (kDebugMode) {
            print('Error:請求失敗,$response,${response.statusCode}');
          }
        }
      } catch (e) {
        setState(() {
          firstName = null;
        });
        if (kDebugMode) {
          print('Error:請求出錯,$e');
        }
      }
    } else {
      setState(() {
        firstName = null;
      });
      if (kDebugMode) {
        print('沒有保存的access_token');
      }
    }
  }

  Future<void> getAvatar() async //顯示頭像
  {
    final savedAccessToken = await getAccessToken();
    if (savedAccessToken != null && avatarFileName != null) {
      try {
        final response = await http.post(
          Uri.parse('http://120.126.16.222/gardeners/show-info-avatar'),
          headers: <String, String>{
            'Authorization': 'Bearer $savedAccessToken',
          },
          body: jsonEncode(<String, String>{
            'access_token': savedAccessToken,
          }),
        );
        if (response.statusCode >= 200 && response.statusCode < 405) {
          setState(() {
            avatarImageBytes = response.bodyBytes;
          });
        } else {
          if (kDebugMode) {
            print('Error:請求圖檔失敗,$response,${response.statusCode}');
          }
        }
      } catch (error) {
        if (kDebugMode) {
          print('Error:請求圖檔出錯,$error');
        }
      }
    } else {
      if (kDebugMode) {
        print('沒有保存的access_token或沒有取得圖檔名');
      }
    }
  }

  Future<void> showLogoutResultDialog(String message) async //登出
  {
    // 顯示登出 API 回傳的結果
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        //title: const Text('登出結果'),
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (message.contains('登出成功')) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> showCreateRoomResultDialog(
      BuildContext context, String message) async 
      {
    //創植物對話框
    // 創植物 API 回傳的結果
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

  Future<void> createPlant(String plantName, String plantType) async {
    final String plantName = _createPlantController.text;
    final savedAccessToken = await getAccessToken();
    if (savedAccessToken != null && avatarFileName != null) {
      try {
        final response = await http.post(
          Uri.parse('http://120.126.16.222/plants/create-plant'),
          headers: <String, String>{
            'Authorization': 'Bearer $savedAccessToken',
            //'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'plant_name': plantName,
            'plant_type': plantType,
          }),
        );

        if (response.statusCode >= 200 && response.statusCode < 300) 
        {
          final responseData = jsonDecode(response.body);
          if (kDebugMode) 
          {
            print('CreatePlant API回傳資料: $responseData');
          }
          if(responseData[0]['message']!=null)
          {
            final message = responseData[0]['message'];
            if (kDebugMode) {
              print('CreatePlant success回傳資料: $responseData');
              // ignore: use_build_context_synchronously
            }
            await showCreateRoomResultDialog(context, message);
          }
          else
          {
            final errorMsg = responseData[0]['error_message'];
            await showCreateRoomResultDialog(context, errorMsg);

          }
        } 
        else 
        {
          if (kDebugMode) 
          {
            print('Error: create plant請求失敗\n$response\nStatusCode: ${response.statusCode}');
            // ignore: use_build_context_synchronously
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('create plant Catch Error: $e');
          // ignore: use_build_context_synchronously
          await showCreateRoomResultDialog(context, 'Catch Error: $e');
        }
      }
    }
  }

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
                  children: [
                    const SizedBox(width: 20),
                    if (avatarImageBytes != null)
                      CircleAvatar(
                        minRadius: 35,
                        maxRadius: 35,
                        backgroundImage: MemoryImage(avatarImageBytes!),
                      ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        const SizedBox(height: 25),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '名字: $firstName',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '帳號: $account',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                //一個Padding是一個項目
                padding: const EdgeInsets.only(left: 15),
                child: GestureDetector(
                  onTap: (() {}),
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
                title: const Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
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
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      onTap: (() {}),
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
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final savedAccessToken = await getAccessToken();
                  if (savedAccessToken != null) {
                    // 呼叫登出 API
                    try {
                      final response = await http.post(
                        Uri.parse(
                            'http://120.126.16.222/gardeners/logout?timestamp=${DateTime.now().millisecondsSinceEpoch}'),
                        headers: <String, String>{
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer $savedAccessToken',
                        },
                        body: jsonEncode(<String, String>{
                          //'account': account,
                          'access_token': savedAccessToken,
                        }),
                      );

                      if (response.statusCode == 200) {
                        // 輸出登出成功的回傳資料
                        //final body = jsonDecode(response.body);
                        const message = '登出成功\n';
                        await showLogoutResultDialog(message);
                        await deleteAccessToken(); // 登出後刪除保存的 access_token
                      } else {
                        // 登出失敗
                        final errorMessage = response.body;
                        await showLogoutResultDialog(errorMessage);
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print('登出失敗：$e');
                      }
                      final errorMessage = '登出失敗：$e';
                      await showLogoutResultDialog(errorMessage);
                    }
                  } else {
                    // 沒有保存的 access_token，直接顯示錯誤訊息
                    const errorMessage = '尚未登入，無法進行登出。';
                    await showLogoutResultDialog(errorMessage);
                  }
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                tooltip: '返回上一頁',
                icon: const Icon(Icons.arrow_circle_left_outlined, size: 30),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const Center(
            child: Text("選擇您的資料夾喲",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          Center(
            // 圓點指示器
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _pageData.map((page) {
                int index = _pageData.indexOf(page);
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentPageIndex == index ? Colors.blue : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CarouselSlider(
                    items: _pageData.map((page) {
                      var parts = page.split('|');
                      var imagePath = parts[0]; //取得樹或花朵圖片
                      imageName = parts[1]; //取得樹或花朵名字
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  imagePath,
                                  width: 200,
                                  height: 200,
                                ),
                                const SizedBox(height: 10), // 添加間距
                                Text(
                                  imageName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      // PageView左右滑動切換時的回調
                      onPageChanged: (index, reason) {
                        var parts = _pageData[index].split('|');

                        setState(() {
                          _currentPageIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 200,
            height: 80,
            child: TextField(
              controller: _createPlantController, // 使用 TextEditingController
              decoration: const InputDecoration(
                hintText: '請為您的資料夾取名',
                labelText: "資料夾名稱",
                prefixIcon: Icon(Icons.groups),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  final folderName = _createPlantController.text; // 获取输入的文件夹名字
                  if (folderName.isNotEmpty && imageName != null) {
                    // 如果資料夾名稱和植物名稱都不為空，才執行API請求
                    await createPlant(folderName, imageName);
                    print('$folderName $imageName'); //有取到值
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AnimationFruitsPage()));
                },
                child: const Text('跳至有Animation'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
