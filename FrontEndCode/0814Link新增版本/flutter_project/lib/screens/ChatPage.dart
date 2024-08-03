import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/ChatPageUsersModel.dart';
import 'package:flutter_project/components/ConversationList.dart';
import 'package:flutter_project/screens/ChatingPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
class ChatPage extends StatefulWidget 
{
  const ChatPage({super.key});
  @override
  //ignore: library_private_types_in_public_api
  _ChatPageState createState()=>_ChatPageState();
}
class _ChatPageState extends State<ChatPage>
{
  final TextEditingController _enterfirstnameController=TextEditingController();
  final _storage = const FlutterSecureStorage(); // 用於存儲 access_token
  String? firstName;
  String? account;
  String? avatarFileName;
  Uint8List? avatarImageBytes;
  List<dynamic> searchResults=[];
  List<dynamic> searchAccounts=[];
  List<dynamic> senderFirstName=[];
  List<dynamic> receiverFirstName=[];
  List<dynamic> sendTime=[];
  List<dynamic> chatData=[];
  static String? selectedResult;
  String? selectedAccount;
  List<ChatPageUsersModel> chatPageUsersModel=
  [
    ChatPageUsersModel(name:'Xian',messageText:'Set',imageURL:'assets/images/twoside_leaf.png',time:'Now'),
    ChatPageUsersModel(name:'Ting',messageText:'Hi',imageURL:'assets/images/maple_leaf2.png',time:'Now'),
    ChatPageUsersModel(name:'Ping',messageText:'Bye',imageURL:'assets/images/normal_leaf2.png',time:'Now'),
  ];
  Future<String?> getAccessToken()async
  {
    // 從 flutter_secure_storage 取得 access_token
    String? accessToken = await _storage.read(key:'access_token');
    if (kDebugMode) 
    {
      print('Access Token: $accessToken');
    }
    return accessToken;
  }
  Future<void> deleteAccessToken() async 
  {
    // 從 flutter_secure_storage 刪除 access_token
    await _storage.delete(key: 'access_token');
  }
  Future<void> searchName(String firstName)async
  {
    final savedAccessToken=await getAccessToken();
    final searchFirstName =_enterfirstnameController.text;
    if(savedAccessToken!=null)
    {
      if(searchFirstName.isNotEmpty)
      {
        try 
        {
          final response = await http.post
          (
            Uri.parse('http://120.126.16.222/gardeners/search'),
            headers: <String, String>
            {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $savedAccessToken',
            },
            body: jsonEncode(<String, String>
            {
              'enter_firstname': searchFirstName,
            }),
          );
          if (response.statusCode >= 200&&response.statusCode<405) 
          {
            // 解析API回傳的JSON數據
            final  userInfo = json.decode(response.body);
            if(kDebugMode)
            {
              print('Search API回傳資料:$userInfo');
            }
            if(userInfo.isNotEmpty)
            {
              if(userInfo[0]['error_message']=='搜尋不到資料')
              {
                setState(() 
                {
                  searchResults = userInfo.map((item) => item['error_message']).toList();
                  searchAccounts=userInfo.map((item)=>item['error_message']).toList();
                  selectedResult=searchResults.isNotEmpty?searchResults[0]:'搜尋不到資料';
                  selectedAccount = searchAccounts.isNotEmpty ? searchAccounts[0] :'搜尋不到資料';
                });
                if(kDebugMode)
                {
                  print('所找的帳號: $searchAccounts');
                  print('所找的姓名: $searchResults');
                  print('selectedResult內容: $selectedResult');
                  print('selectedAccount內容:$selectedAccount');
                }
                // ignore: use_build_context_synchronously
                showDialog
                (
                  context: context,
                  builder: (BuildContext context) 
                  {
                    return AlertDialog
                    (
                      title: const Text('搜尋結果'),
                      content: Text(userInfo[0]['error_message']),
                      actions: <Widget>
                      [
                        ElevatedButton
                        (
                          child: const Text('重新搜尋'),
                          onPressed: () 
                          {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              else
              {
                setState(() 
                {
                  searchResults = userInfo.map((item) => item['first_names']).toList();
                  searchAccounts=userInfo.map((item)=>item['account']).toList();
                  selectedResult=searchResults.isNotEmpty?searchResults[0]:'搜尋不到資料';
                  selectedAccount = searchAccounts.isNotEmpty ? searchAccounts[0] :'搜尋不到資料';

                });
                if(kDebugMode)
                {
                  print('API 回傳姓名: $userInfo');
                  print('所找的帳號: $searchAccounts');
                  print('所找的姓名: $searchResults');
                  print('selectedResult內容: $selectedResult');
                  print('selectedAccount內容:$selectedAccount');
                }
              }
            }
          } 
        } 
        catch (e) 
        {
          if(kDebugMode)
          {
            print('Error:firstname_search請求出錯,$e');
          }
        }
      }
    } 
    else 
    {
      if(kDebugMode)
      {
        print('沒有保存的access_token');
      }
    }      
  }
  Future<void> saveSelectedName(String selectedName)async
  {
    await _storage.write(key: 'selected_name', value: selectedName);
  }
  Future<void> showChatData()async
  {
    final savedAccessToken=await getAccessToken();
    if(savedAccessToken!=null)
    {
      try
      {
        final response=await http.post
        (
          Uri.parse('http://120.126.16.222/chats/record'),
          headers:<String,String>
          {
            'Content-Type':'application/json',
            'Authorization':'Bearer $savedAccessToken',
          },
          body:jsonEncode(<String,String>
          {
            'other_account':selectedAccount??'',
          }),
        );
        if(response.statusCode>=200&&response.statusCode<300)
        {
          final responseData=jsonDecode(response.body);
          senderFirstName = responseData.map((item) => item['sender_firstname']).toList();
          receiverFirstName=responseData.map((item) => item['receiver_firstname']).toList();
          sendTime=responseData.map((item) => item['send_time']).toList();
          chatData=responseData.map((item) => item['chat_data']).toList();
          // if(kDebugMode)
          // {
          //   print('ChatPage API 回傳資料: $responseData');
          //   print('傳送方名字: $senderFirstName');
          //   print('接收方名字: $receiverFirstName');
          //   print('傳送時間: $sendTime');
          //   print('所找的聊天內容: $chatData');
          // }
        }
        else
        {
          if(kDebugMode)
          {
            print('Error:請求失敗\n$response\nStatusCode: ${response.statusCode}');
          }
        }
      }
      catch(error)
      {
        if(kDebugMode)
        {
          print('Catch Error: $error');
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body:SingleChildScrollView
      (
        physics: const BouncingScrollPhysics(),
        child:Container
        (
          padding:const EdgeInsets.all(16.0),
          child:Column
          (
            mainAxisAlignment: MainAxisAlignment.start,
            children: 
            [
              Row
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
                  Column
                  (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [
                      Column
                      (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: 
                        [
                          SizedBox
                          (
                            width: 270,
                            height:100,
                            child:Padding
                            (
                              padding:const EdgeInsets.only(top:35,left:5),
                              child:TextField
                              (
                                controller:_enterfirstnameController,
                                onSubmitted: (value)
                                {
                                  searchName(value);
                                },
                                decoration:InputDecoration
                                (
                                  hintText:  "搜尋名字",
                                  hintStyle: TextStyle(color:Colors.grey.shade600),
                                  prefixIcon: Icon(Icons.search,color:Colors.grey.shade600,size:20),
                                  suffixIcon:IconButton
                                  (
                                    onPressed: ()
                                    {
                                      _enterfirstnameController.clear();
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                                  filled:true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: const EdgeInsets.all(8),
                                  enabledBorder: OutlineInputBorder
                                  (
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color:Colors.grey.shade100)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column
                  (
                    children: <Widget>
                    [
                      Padding
                      (
                        padding:const EdgeInsets.only(top:25,left:20),
                        child:MaterialButton
                        (
                          onPressed: ()
                          {
                            setState(()
                            {
                              searchName(_enterfirstnameController.text);
                            });
                          },
                          color:const Color.fromARGB(255,0,158,71),
                          child: const Text('搜尋',style:TextStyle(color:Colors.white))
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if(searchResults.isNotEmpty)
              Row
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
                  SizedBox
                  (
                    width: 270,
                    height:50,
                    child:DropdownButtonHideUnderline
                    (
                      child:DropdownButton<String>
                      (
                        borderRadius: BorderRadius.circular(20),
                        value:selectedResult, 
                        isExpanded: true,
                        onChanged: (newValue)
                        {
                          setState(() 
                          {
                            selectedResult=newValue;
                            selectedAccount=searchAccounts[searchResults.indexOf(newValue)];
                          });
                        }, 
                        items: searchResults.map<DropdownMenuItem<String>>((dynamic value)
                        {
                          return DropdownMenuItem
                          (
                            value:value,
                            child: Center
                            (
                              child:Text
                              (
                                value!,
                                style: const TextStyle
                                (
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          );
                        },).toList(),
                      ),
                    ),
                  ),
                  Column
                  (
                    children: <Widget>
                    [
                      Padding
                      (
                        padding:const EdgeInsets.only(top:25,left:20),
                        child:MaterialButton
                        (
                          onPressed: ()async
                          {
                            final savedAccessToken = await getAccessToken();
                            // ignore: unrelated_type_equality_checks
                            if (savedAccessToken != null) 
                            {
                              try 
                              {
                                if(selectedResult=='搜尋不到資料')
                                {
                                  // ignore: use_build_context_synchronously
                                  showDialog
                                  (
                                    context: context,
                                    builder: (BuildContext context) 
                                    {
                                      return AlertDialog
                                      (
                                        title: const Text('搜尋結果'),
                                        content: const Text('搜尋不到資料'),
                                        actions: <Widget>
                                        [
                                          ElevatedButton
                                          (
                                            child: const Text('確定'),
                                            onPressed: () 
                                            {
                                              Navigator.of(context).pop();
                                            }
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                }
                                else
                                {
                                  // 觸發 API 請求
                                  await showChatData();
                                  // ignore: use_build_context_synchronously
                                  Navigator.push
                                  (
                                    context,
                                    MaterialPageRoute
                                    (
                                      builder: (context)=>ChatingPage
                                      (
                                        selectedName: selectedResult,
                                        selectedAccount: selectedAccount,//seach得到的account
                                      ),
                                    ),
                                  );
                                }
                              } 
                              catch (error) 
                              {
                                if (kDebugMode) 
                                {
                                  print('Catch Error: $error');
                                }
                              }
                            }                          
                          },
                          color:const Color.fromARGB(255,0,158,71),
                          child: const Text('傳送訊息',style:TextStyle(color:Colors.white))
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ListView.builder
              (
                itemCount: chatPageUsersModel.length,
                shrinkWrap: true,
                padding:const EdgeInsets.only(top:16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index)
                {
                  return ConversationList
                  (
                    name:chatPageUsersModel[index].name,
                    messageText:chatPageUsersModel[index].messageText,
                    imageUrl:chatPageUsersModel[index].imageURL,
                    time:chatPageUsersModel[index].time,
                    isMessageRead:(index==0||index==3)?true:false
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}