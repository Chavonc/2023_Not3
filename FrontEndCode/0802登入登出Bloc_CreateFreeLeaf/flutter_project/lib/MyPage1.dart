// ignore: file_names
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project/HomePage.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_project/blocs/logout_event.dart';
import 'package:flutter_project/screens/GardenerSettingPage.dart';
import 'package:flutter_project/screens/ChatPage.dart';
import 'package:flutter_project/screens/StartFruitsPage.dart';
import 'package:flutter_project/screens/StartLeafPage.dart';
import 'package:flutter_project/AnimationBottomBar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MyPage1 extends StatefulWidget
{
  const MyPage1({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MyPage1State createState()=>_MyPage1State();
}
class _MyPage1State extends State<MyPage1>
{
  int pageIndex=0;
  List<Widget> pageItem=[];
  // ignore: non_constant_identifier_names
  bool switchValue_Volume = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Mic = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Camera = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Notify = true;
  final _storage = FlutterSecureStorage(); // 用於存儲 access_token

  Future<String?> getAccessToken()async
  {
    // 從 flutter_secure_storage 取得 access_token
    String? accessToken = await _storage.read(key:'access_token');
    print('Access Token: $accessToken');
    return accessToken;
  }
  Future<void> deleteAccessToken() async 
  {
    // 從 flutter_secure_storage 刪除 access_token
    await _storage.delete(key: 'access_token');
  }
  @override
  void initState()
  {
    super.initState();
    pageItem=[const ChatPage(),const StartLeafPage(),const StartFruitsPage()];
  }
  final List<BarItemData> barItems=
  [
    BarItemData("聊天室",Icons.accessibility,const Color.fromARGB(210, 48, 135, 24)),
    BarItemData("葉子",Icons.energy_savings_leaf,const Color.fromARGB(210, 48, 135, 24)),
    BarItemData("檢視果實",Icons.feed,const Color.fromARGB(210, 48, 135, 24))
  ];
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Center
        (
          child:Text
          (
            'Not3',
            style:TextStyle(color:Colors.white),
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0.0, //陰影
      ),
      drawer: Drawer
      (
        backgroundColor: Colors.white,
        child: SingleChildScrollView
        (
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              Container
              (
                height: 100,
                color: Colors.green,
                child: const Row
                (
                  // ignore: prefer_const_literals_to_create_immutables
                  children:  
                  [
                    SizedBox(width: 20),
                    CircleAvatar
                    (
                      //圓形頭像
                      minRadius: 35,
                      maxRadius: 35,
                      backgroundImage: NetworkImage
                      (
                        'https://memeprod.ap-south-1.linodeobjects.com/user-maker-thumbnail/a3079365d1a6e3d7d6919a03ae9eaf82.gif',
                      ),
                    ),
                    SizedBox(width: 10),
                    Text
                    (
                      "Anya Forger",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              // Divider(),
              const SizedBox(height: 20,),
              Padding
              (
                //一個Padding是一個項目
                padding: const EdgeInsets.only(left: 15),
                child: GestureDetector
                (
                  onTap: (() 
                  {
                    // Navigator.pop(
                    //	 context,
                    //	 new MaterialPageRoute(
                    //		 builder: (context) => new HomePageMain()));
                  }),
                  child: Row
                  (
                    // ignore: prefer_const_literals_to_create_immutables
                    children: 
                    [
                      const Icon(Icons.person),
                      SizedBox
                      (
                        width: 150,
                        height: 50,
                        child: TextButton
                        (
                          child: const Text
                          (
                            "使用者檔案",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                            ),
                          ),
                          onPressed: () 
                          {
                            Navigator.push
                            (
                              context,
                              MaterialPageRoute
                              (
                                builder: (_) =>const GardenerSettingPage()
                              )
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              ExpansionTile
              (
                //下拉式
                title: const Row
                (
                  // ignore: prefer_const_literals_to_create_immutables
                  children:  
                  [
                    Icon(CupertinoIcons.settings),
                    SizedBox
                    (
                      width: 10,
                    ),
                    Text
                    (
                      "設定",
                      style: TextStyle
                      (
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                      ),
                    )
                  ],
                ),
                childrenPadding:const EdgeInsets.only(left: 25), // children padding
                // ignore: prefer_const_literals_to_create_immutables
                children: 
                [
                  Padding
                  (
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector
                    (
                      onTap: (() 
                      {
                        // Navigator.push(
                        //	 context,
                        //	 new MaterialPageRoute(
                        //		 builder: (context) => new VendorVenuePage()));
                      }),
                      child: Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        children: 
                        [
                          const Icon
                          (
                            CupertinoIcons.waveform_circle_fill,
                            color: Colors.black87,
                          ),
                          const SizedBox
                          (
                            width: 10,
                          ),
                          const Text
                          (
                            "音量",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          ),
                          const Spacer(),
                          CupertinoSwitch
                          (
                            // This bool value toggles the switch.
                            value: switchValue_Volume,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) 
                            {
                              // This is called when the user toggles the switch.
                              setState(() 
                              {
                                switchValue_Volume = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding
                  (
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector
                    (
                      onTap: (() 
                      {
                        // Navigator.push(
                        //	 context,
                        //	 new MaterialPageRoute(
                        //		 builder: (context) =>
                        //			 new VendorPhotographerPage()));
                      }),
                      child: Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: 
                        [
                          const Icon(Icons.camera_alt_outlined),
                          const SizedBox
                          (
                            width: 10,
                          ),
                          const Text
                          (
                            "鏡頭",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          ),
                          const Spacer(),
                          CupertinoSwitch
                          (
                            // This bool value toggles the switch.
                            value: switchValue_Camera,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) 
                            {
                              // This is called when the user toggles the switch.
                              setState(() 
                              {
                                switchValue_Camera = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding
                  (
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector
                    (
                      onTap: (() 
                      {
                        // Navigator.push(
                        //	 context,
                        //	 new MaterialPageRoute(
                        //		 builder: (context) =>
                        //			 new VendorCenematographyPage()));
                      }),
                      child: Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: 
                        [
                          const Icon(Icons.mic),
                          const SizedBox
                          (
                            width: 10,
                          ),
                          const Text
                          (
                            "麥克風",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          ),
                          const Spacer(),
                          CupertinoSwitch
                          (
                            // This bool value toggles the switch.
                            value: switchValue_Mic,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) 
                            {
                              // This is called when the user toggles the switch.
                              setState(() 
                              {
                                switchValue_Mic = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding
                  (
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector
                    (
                      onTap: (() 
                      {
                        // Navigator.push
                        // (
                        //	 context,
                        //	 new MaterialPageRoute
                        //(
                        //		 builder: (context) => new VendorMakeupPage()),
                        //);
                      }),
                      child: Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        children: 
                        [
                          const Icon(Icons.notifications),
                          const SizedBox
                          (
                            width: 10,
                          ),
                          const Text
                          (
                            "通知",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          ),
                          const Spacer(),
                          CupertinoSwitch
                          (
                            // This bool value toggles the switch.
                            value: switchValue_Notify,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) 
                            {
                              // This is called when the user toggles the switch.
                              setState(() 
                              {
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
              const SizedBox(height: 10,),
              ElevatedButton
              (
                onPressed: ()async
                {
                  final savedAccessToken=await getAccessToken();
                  if (savedAccessToken != null) 
                  {
                    // 呼叫登出 API
                    try 
                    {
                      final response = await http.post
                      (
                          Uri.parse('http://120.126.16.222/gardeners/logout'),
                          headers: <String, String>
                          {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer $savedAccessToken',
                          },
                          body: jsonEncode(<String, String>
                          {
                            //'account': account,
                            'access_token': savedAccessToken,
                          }),
                        );

                        if (response.statusCode == 200) 
                        {
                          // 輸出登出成功的回傳資料
                          //final body = jsonDecode(response.body);
                          const message = '登出成功\n';
                          await showLogoutResultDialog(message);
                          await deleteAccessToken(); // 登出後刪除保存的 access_token
                        } 
                        else 
                        {
                          // 登出失敗
                          final errorMessage = response.body;
                          await showLogoutResultDialog(errorMessage);
                        }
                      } 
                      catch (e) 
                      {
                        if (kDebugMode) 
                        {
                          print('登出失敗：$e');
                        }
                        final errorMessage = '登出失敗：$e';
                        await showLogoutResultDialog(errorMessage);
                      }
                    } 
                    else 
                    {
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
      body:IndexedStack
      (
        index:pageIndex,
        children: pageItem,
      ),
      bottomNavigationBar: AnimationBottomBar
      (
        barItemsData:barItems,
        barStyle:BarStyle(fontSize:20.0,fontWeight:FontWeight.w400,iconSize:30.0),
        changePageIndex:(int index)
        {
          setState(() 
          {
            pageIndex=index;
          });
        }, 
      ),
    );
  }
  Future<void> showLogoutResultDialog(String message) async
  {
    // 顯示登出 API 回傳的結果
    await showDialog
    (
      context: context,
      builder: (context) => AlertDialog
      (
        //title: const Text('登出結果'),
        content: 
        Text
        (
          message,
          style: const TextStyle(fontWeight:FontWeight.bold,fontSize: 24),
          textAlign: TextAlign.center,
        ),
        actions:
        [
          TextButton
          (
            onPressed: () 
            {
              Navigator.of(context).pop();
              if(message.contains('登出成功'))
              {
                Navigator.pushAndRemoveUntil
                (
                  context,MaterialPageRoute(builder:(_)=>const HomePage()),
                  (route)=>false,
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}