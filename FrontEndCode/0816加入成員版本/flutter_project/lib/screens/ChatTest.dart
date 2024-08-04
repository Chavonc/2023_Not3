import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project/agora/constants.dart';
import 'package:flutter_project/agora/quick_start.dart'; // 引入QuickStartPage

  String chatroomUUID = '';
  String chatroomToken = '';
  String chatappID = '';
  
class ChatTest extends StatefulWidget {
  const ChatTest({Key? key}) : super(key: key);

  @override
  _ChatTestState createState() => _ChatTestState();
}

class ChatTestModel {
  final String uuid;
  final String roomToken;
  final String appIdentifier;

  const ChatTestModel({
    required this.roomToken,
    required this.appIdentifier,
    required this.uuid,
  });

  factory ChatTestModel.fromJson(Map<String, dynamic> json) {
    final roomData = json['roomData'];
    final roomToken = json['roomToken'];
    final appIdentifier = roomData['appIdentifier'];
    final uuid = roomData['uuid'];

    return ChatTestModel(
      roomToken: roomToken,
      appIdentifier: appIdentifier,
      uuid: uuid,
    );
  }

  @override
  String toString() {
    return 'FreeLeafModel{uuid: $uuid, roomToken: $roomToken, appIdentifier: $appIdentifier}';
  }
}

class _ChatTestState extends State<ChatTest> {
  final _storage = FlutterSecureStorage(); // 用於存儲 access_token
  final TextEditingController _textFieldController =
      TextEditingController(); // 新增控制器
  


  Future<String?> getAccessToken() async {
    // 從 flutter_secure_storage 取得 access_token
    String? accessToken = await _storage.read(key: 'access_token');
    print('Access Token: $accessToken');
    return accessToken;
  }

  Future<void> deleteAccessToken() async {
    // 從 flutter_secure_storage 刪除 access_token
    await _storage.delete(key: 'access_token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora API Information(Post) Post'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: buildColumn(),
      ),
    );
  }

  Widget buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        

        SizedBox(height: 16), // Adding spacing between buttons

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300,
              child: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(
                  hintText: '輸入文字',
                ),
              ),
            ),
            SizedBox(
                width: 16), // Adding spacing between the text field and button
            SizedBox
            (
              width: 150,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final link = _textFieldController.text; // 獲取輸入的文字
                  print('輸入的文字內容：$link');

                  final response = await http.post(
                    Uri.parse('http://120.126.16.222/leafs/catch-link'),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'link': link,
                    }),
                  );

                  if (response.statusCode >= 200 && response.statusCode < 300) {
                    final responseData = jsonDecode(response.body);

                    if (responseData.isNotEmpty) 
                    {

                      setState(() {
                        chatroomUUID = responseData[0]['roomUUID'];
                        chatroomToken = responseData[0]['roomToken'];
                        chatappID = responseData[0]['appID'];
                      });
                      
                      final chatTestModel = ChatTestModel(
                        roomToken: chatroomToken,
                        appIdentifier: chatappID,
                        uuid: chatroomUUID,
                      );
                      print('ChatTestModel: $chatTestModel');
                    } else {
                      print('API response is missing required data');
                    }

                    // 更新 constant.dart 的變數值
                            APP_ID = '2z_FcDpIEe6Kl1cgr87Xbw/efXTp3d7xPV6_g';//等等改回chatappID
                            ROOM_UUID = chatroomUUID;
                            ROOM_TOKEN = chatroomToken;

                            
                  } else {
                    throw Exception(
                        '${response.reasonPhrase},${response.statusCode}');
                  }
                },
                child: const Text('取得link'),
              ),
            ),
            SizedBox(width: 16),

            SizedBox(
              width: 150,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final savedAccessToken = await getAccessToken();
                  if (savedAccessToken != null) {
                    try {
                      final response = await http.post(
                        Uri.parse('http://120.126.16.222/leafs/create-white-leaf'),
                        headers: <String, String>{
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer $savedAccessToken',
                        },
                        body: jsonEncode(<String, dynamic>{
                          'region': 'cn-hz',
                        }),
                      );

                      if (response.statusCode >= 200 && response.statusCode < 300) {
                        final responseData = jsonDecode(response.body);

                        if (responseData.isNotEmpty &&
                            responseData[0]['roomData'] != null &&
                            responseData[0]['roomToken'] != null) {
                          final roomData = responseData[0]['roomData'];
                          final roomToken = responseData[0]['roomToken'];
                          final appIdentifier = responseData[0]['appIdentifier'];
                          final uuid = roomData['uuid'];
                          final freeLeafModel = ChatTestModel(
                            roomToken: roomToken,
                            appIdentifier: appIdentifier,
                            uuid: uuid,
                          );
                          print('FreeLeafModel: $freeLeafModel');

                           

                          // 跳轉至 QuickStartPage
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => QuickStartPage(),
                            ),
                          );
                        } else {
                          print('API response is missing required data');
                        }
                      } else {
                        throw Exception(
                            '${response.reasonPhrase},${response.statusCode}');
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
                  } else {
                    print('API response is empty');
                  }
                },
                child: const Text('Show'),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16), // Adding spacing

           Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Chatroom UUID: $chatroomUUID'),
            Text('Chatroom Token: $chatroomToken'),
            Text('Chat App ID: $chatappID'),
          ],
        ),

        
      ],
    );
  }
}
