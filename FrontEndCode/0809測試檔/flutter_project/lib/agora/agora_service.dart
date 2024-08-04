import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'quick_start.dart'; // 引入QuickStartPage

class FreeLeafExample extends StatefulWidget {
  const FreeLeafExample({Key? key}) : super(key: key);

  @override
  _FreeLeafExampleState createState() => _FreeLeafExampleState();
}

class FreeLeafModel {
  final String uuid;
  final String roomToken;
  final String appIdentifier;

  const FreeLeafModel({
    required this.roomToken,
    required this.appIdentifier,
    required this.uuid,
  });

  factory FreeLeafModel.fromJson(Map<String, dynamic> json) {
    final roomData = json['roomData'];
    final roomToken = json['roomToken'];
    final appIdentifier = roomData['appIdentifier'];
    final uuid = roomData['uuid'];

    return FreeLeafModel(
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



class _FreeLeafExampleState extends State<FreeLeafExample> {
  final _storage = FlutterSecureStorage();// 用於存儲 access_token

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
                        //'region': 'en-us',

                    }),
                  );

                  if (response.statusCode >= 200 && response.statusCode < 300) {
                    final responseData = jsonDecode(response.body);

                    if (responseData.isNotEmpty &&
                        responseData[0]['roomData'] != null &&
                        responseData[0]['roomToken'] != null) {
                      final roomData = responseData[0]['roomData'];
                      final roomToken = responseData[0]['roomToken'];
                      final appIdentifier =responseData[0]['appIdentifier'];
                      final uuid = roomData['uuid'];
                      final freeLeafModel = FreeLeafModel(
                        roomToken: roomToken,
                        appIdentifier: appIdentifier,
                        uuid: uuid,
                      );
                      print('FreeLeafModel: $freeLeafModel');

                      // 更新 constant.dart 的變數值
                      APP_ID = appIdentifier;
                      ROOM_UUID = uuid;
                      ROOM_TOKEN = roomToken;

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
    );
  }
}
