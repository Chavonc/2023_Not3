import 'dart:convert';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/screens/OpenFruitsPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_project/screens/ShowTreeInfoPage.dart';

class StartFruitsPage extends StatefulWidget {
  const StartFruitsPage({super.key});
  @override
  //ignore: library_private_types_in_public_api
  _StartFruitsPageState createState() => _StartFruitsPageState();
}

class _StartFruitsPageState extends State<StartFruitsPage> {
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
  final _storage = const FlutterSecureStorage(); // 用於存儲 access_token
  String? firstName;
  String? account;
  String? avatarFileName;
  Uint8List? avatarImageBytes;
  Uint8List? plantImageBytes;

  List<Map<String,dynamic>> plantNames = []; // 存植物名稱列表
  Map<String, bool> hasLoadedImages = {}; // Track if an image has been loaded for each plant


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

  Future<void> getUserInfo() async {
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
            if (kDebugMode) {
              print('檔名:$avatarFileName');
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

  Future<void> getAvatar() async {
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

  Future<void> showLogoutResultDialog(String message) async {
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

  Future<void> showFruitDialog(BuildContext context, String message) async {
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

  Future<void> showPlant() async {
    final savedAccessToken = await getAccessToken();
    if (savedAccessToken != null && avatarFileName != null) {
      try {
        final response = await http.post(
          Uri.parse('http://120.126.16.222/plants/show-all-plants'),
          headers: <String, String>{
            'Authorization': 'Bearer $savedAccessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{}),
        );

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final responseData = jsonDecode(response.body);
          if (kDebugMode) {
            print('showPlant API回傳資料: $responseData');
          }

          setState(() {
            plantNames = responseData[0]['plant_name'];
          });

          final plantCount = responseData[0]['plant_num'];

          if (plantNames.isNotEmpty) {
            final message = '植物名稱: ${plantNames.join(", ")}\n總數量: $plantCount';
            if (kDebugMode) {
              print('成功取得植物資訊: $message');
            }
            await showFruitDialog(context, message);
          } else {
            final errorMsg = '未找到植物資訊';
            await showFruitDialog(context, errorMsg);
          }
        } else {
          if (kDebugMode) {
            print(
                'Error: show all plants請求失敗\n$response\nStatusCode: ${response.statusCode}');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('show all plants Catch Error: $e');
          await showFruitDialog(context, 'Catch Error: $e');
        }
      }
    }
  }

  Future<void> getPlantPicture(String plantName) async {
    final savedAccessToken = await getAccessToken();
    if (savedAccessToken != null && avatarFileName != null) {
      try {
        final response = await http.post(
          Uri.parse('http://120.126.16.222/plants/show-plant-picture'),
          headers: <String, String>{
            'Authorization': 'Bearer $savedAccessToken',
          },
          body: jsonEncode(<String, String>{
            'plant_name': plantName,
          }),
        );
        if (response.statusCode >= 200 && response.statusCode < 405) {
          setState(() {
            plantImageBytes = response.bodyBytes;
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

  @override
  void initState() {
    super.initState();
    //pageItem=[const ChatPage(),const StartLeafPage(),const OpenFruitsPage()];
    getUserInfo();
  }

  Widget buildPlantButtons(List<dynamic> plantNames) {
    return Container(
      width: 600.0, // Set the desired width of the Container
      child: Wrap(
        alignment: WrapAlignment.center, // Align the buttons at the center
        spacing: 10.0, // Set the horizontal spacing between buttons
        runSpacing: 10.0, // Set the vertical spacing between buttons
        children: plantNames.map<Widget>((plantName) {
          final bool hasLoaded = hasLoadedImages[plantName] ?? false;
          if (!hasLoaded) {
            getPlantPicture(plantName);
            hasLoadedImages[plantName] = true;
          }
          getPlantPicture(plantName);

          return TextButton(
            onPressed: () {
              // TODO: Perform actions based on the plant name
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('You clicked the button for $plantName'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Column(
              children: [
                if (hasLoaded && plantImageBytes != null) // Check if plantImageBytes is available
                  Image.memory(
                    plantImageBytes!,
                    width: 150,
                    height: 150,
                  ),
                SizedBox(height: 8), // Add some spacing between image and text
                Text(plantName.toString()),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

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
          const SizedBox(height: 20), // 添加空白
          Center(
            child: Container(
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/StartFruits_2.png',
                  width: 150, height: 150),
            ),
          ),
          const SizedBox(height: 20), // 添加空白
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
                      MaterialPageRoute(
                          builder: (_) => const OpenFruitsPage()));
                },
                child: const Text(
                  '創建我的Tree',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // 添加空白
          ElevatedButton(
            onPressed: () async {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (_) => const ShowTreeInfoPage()));
              await showPlant();
            },
            child: const Text('查看Tree信息'),
          ),
          const SizedBox(height: 20), // 添加空白
          // 在这里根据植物名稱生成按鈕
          if (firstName != null && plantNames != null)
            buildPlantButtons(plantNames),
        ],
      ),
    );
  }
}
