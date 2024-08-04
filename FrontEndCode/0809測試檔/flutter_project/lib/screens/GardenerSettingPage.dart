import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
final random = Random();
const _storage = FlutterSecureStorage(); // 用於存儲 access_token
String? firstName;
String? account;
Uint8List? avatarImageBytes;
File? _imageFile;
Uint8List? _imageBytes;
String? _imageFileName;
String? avatarName;

class GardenerSettingPage extends StatefulWidget 
{
  const GardenerSettingPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _GardenerSettingPageState createState()=>_GardenerSettingPageState();
}
class _GardenerSettingPageState extends State<GardenerSettingPage>
{
  static String? firstName;
  static String? avatarName;
  // ignore: non_constant_identifier_names
  bool switchValue_Volume = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Mic = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Camera = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Notify = true;
  String? avatarFileName;

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
  @override
  void initState()
  {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async//顯示drawer的user資料
  {
    final savedAccessToken=await getAccessToken();
    if(savedAccessToken!=null)
    {
      try 
      {
        final response = await http.post
        (
          Uri.parse('http://120.126.16.222/gardeners/show-info'),
          headers: <String, String>
          {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $savedAccessToken',
          },
          body: jsonEncode(<String, String>
          {
            'access_token': savedAccessToken,
          }),
        );
        if (response.statusCode == 200) 
        {
          // 解析API回傳的JSON數據
          final userInfo = jsonDecode(response.body);
          final userName=userInfo[0]['firstname'];
          final userAccount=userInfo[0]['account'];
          final avatarPath=userInfo[0]['file_path'];
          final avatarFileName=avatarPath.split('/').last;
          setState(() 
          {
            firstName = userName;
            account=userAccount;
            this.avatarFileName = avatarFileName;
            avatarName=avatarFileName.split('.').first;
            if(kDebugMode)
            {
              print('帳號名字:$firstName');
              print('檔名:$avatarFileName');
              print('帳號名:$avatarName');
            }
          });
          await getAvatar();//取得頭像圖檔
        } 
        else 
        {
          setState(() 
          {
            firstName = null;
          });
          if(kDebugMode)
          {
            print('Error:請求失敗,$response,${response.statusCode}');
          }
        }
      } 
      catch (e) 
      {
        setState(() 
        {
          firstName = null;
        });
        if(kDebugMode)
        {
          print('Error:請求出錯,$e');
        }
      }
    } 
    else 
    {
      setState(() 
      {
        firstName = null;
      });
      if(kDebugMode)
      {
        print('沒有保存的access_token');
      }
    }      
  }
  Future<void> getAvatar()async//顯示頭像
  {
    final savedAccessToken=await getAccessToken();
    if(savedAccessToken!=null&&avatarFileName!=null)
    {
      try
      {
        final response=await http.post
        (
          Uri.parse('http://120.126.16.222/gardeners/show-info-avatar'),
          headers: <String,String>
          {
            'Authorization':'Bearer $savedAccessToken',
          },
          body: jsonEncode(<String,String>
          {
            'access_token':savedAccessToken,
          }),
        );
        if(response.statusCode>=200&&response.statusCode<405)
        {
          setState(() 
          {
            avatarImageBytes=response.bodyBytes;
          });
          // final newAvatarInfo=jsonDecode(response.body);
          // final message=newAvatarInfo[0]['message'];
        }
        else
        {
          if(kDebugMode)
          {
            print('Error:請求圖檔失敗,$response,${response.statusCode}');
          }
        }
      }
      catch(error)
      {
        if(kDebugMode)
        {
          print('Error:請求圖檔出錯,$error');
        }
      }
    }
    else 
    {
      if(kDebugMode)
      {
        print('沒有保存的access_token或沒有取得圖檔名');
      }
    }      
  }
  @override
  Widget build(BuildContext context) //UI
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Center
        (
          child: Text
          (
            '編輯園丁檔案',
            style: TextStyle(color: Colors.white),
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
                child: Row
                (
                  // ignore: prefer_const_literals_to_create_immutables
                  children: 
                  [
                    const SizedBox(width: 20),
                    if(avatarImageBytes!=null)
                      CircleAvatar
                      (
                        //圓形頭像
                        minRadius: 35,
                        maxRadius: 35,
                        backgroundImage: MemoryImage(avatarImageBytes!),
                      ),
                    const SizedBox(width: 10),
                    Column
                    (
                      children: 
                      [
                        const SizedBox(height: 25),
                        Column
                        (
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                          [
                            Text
                            (
                              '名字: $firstName',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Column
                        (
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                          [
                            Text
                            (
                              '帳號: $account',
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox
              (
                height: 20,
              ),
              Padding
              (
                //一個Padding是一個項目
                padding: const EdgeInsets.only(left: 15),
                child: GestureDetector
                (
                  onTap: (() 
                  {
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
                        height:50,
                        child:TextButton
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
                              context,MaterialPageRoute(builder:(_)=> const GardenerSettingPage())
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox
              (
                height: 10,
              ),
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
                childrenPadding: const EdgeInsets.only(left: 25), // children padding
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
                      }),
                      child: Row
                      (
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
                      }),
                      child:  Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
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
                      }),
                      child:Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
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
      body:const Setting(),
    );
  }
  Future<void> showLogoutResultDialog(String message) async//登出
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

class Setting extends StatefulWidget
{
  const Setting({Key? key}):super(key:key);
  @override
  // ignore: library_private_types_in_public_api
  _SettingState createState()=>_SettingState();
}
class _SettingState extends State<Setting>
{
  final TextEditingController _firstnameController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  bool _showPassword=false;
  bool _showFields=false;
  bool _isAvatarUpdated=false;
  String? userPassword;
  String? userFirstName;
  String? updatedFirstName;
  String? updatedPassword;
  final _storage = const FlutterSecureStorage(); // 用於存儲 access_token
  @override
  void initState()
  {
    super.initState();
    getAvatar();
    updateUserInfo().then((_)
    {
      if(mounted)
      {
        setState(() 
        {
          _showFields=false;
        });
      }
    });
    getPassword().then((password)
    {
      setState(() 
      {
        userPassword=password;
      });
    });
    userFirstName=_GardenerSettingPageState.firstName??"Unknown";
  }
  Future<String?> getPassword()async
  {
    // 從 flutter_secure_storage 取得 access_token
    String? userPassword = await _storage.read(key:'password');
    if (kDebugMode) 
    {
      print('getPassword的userPassword: $userPassword');
    }
    return userPassword;
  }
  Future<String?> getAccessToken()async
  {
    // 從 flutter_secure_storage 取得 access_token
    String? accessToken = await _storage.read(key:'access_token');
    if(accessToken==null)
    {
      throw Exception('無法取得AccessToken');
    }
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
  Future<void> getAvatar()async
  {
    final savedAccessToken=await getAccessToken();
    if(savedAccessToken!=null)
    {
      try
      {
        final response=await http.post
        (
          Uri.parse('http://120.126.16.222/gardeners/show-info-avatar'),
          headers: <String,String>
          {
            'Authorization':'Bearer $savedAccessToken',
          },
          body: jsonEncode(<String,String>
          {
            'access_token':savedAccessToken,
          }),
        );
        if(response.statusCode>=200&&response.statusCode<405)
        {
          setState(() 
          {
            avatarImageBytes=response.bodyBytes;
          });
        }
        else
        {
          if(kDebugMode)
          {
            print('Error:請求圖檔失敗,$response,${response.statusCode}');
          }
        }
      }
      catch(error)
      {
        if(kDebugMode)
        {
          print('Error:請求圖檔出錯,$error');
        }
      }
    }
    else 
    {
      if(kDebugMode)
      {
        print('沒有保存的access_token或沒有取得圖檔名');
      }
    }      

  }
  Future<void> updateUserInfo()async
  {
    final savePassword=await getPassword();
    final savedAccessToken=await getAccessToken();
    final newFirstName =_firstnameController.text;
    final newPassword =_passwordController.text;
    if(kDebugMode)
    {
      print('userFirstName: $userFirstName');
      print('userPassword:$savePassword');
    }
    if(savedAccessToken!=null&&newFirstName.isEmpty&&newPassword.isEmpty)
    {
      setState(() 
      {
        _showFields=false;
      });
      return;
    }
    if(savedAccessToken!=null)
    {
      final requestBody=<String,String>{};
      if(newFirstName.isNotEmpty)
      {
        requestBody['first_name']=newFirstName;
      }
      else
      {
        requestBody['first_name']=_GardenerSettingPageState.firstName!;
      }
      if(newPassword.isNotEmpty)
      {
        requestBody['password']=newPassword;
      }
      else
      {
        requestBody['password']=savePassword!;
      }
      try
      {
        final response=await http.post
        (
          Uri.parse('http://120.126.16.222/gardeners/edit'),
          headers:<String, String>
          {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $savedAccessToken',
          },
          body:jsonEncode(requestBody),
        );
        if(response.statusCode>=200&&response.statusCode<300)
        {
          final newUserInfo=jsonDecode(response.body);
          final message=newUserInfo[0]['message'];
          if (kDebugMode) 
          {
            print('Edit Info API: $newUserInfo');
          }
          if(newFirstName.isNotEmpty||newPassword.isNotEmpty)
          {
            setState(() 
            {
              userFirstName=newFirstName.isNotEmpty?newFirstName:_GardenerSettingPageState.firstName!;
              userPassword=newPassword.isNotEmpty?newPassword:savePassword!;
            });
            // ignore: use_build_context_synchronously
            showDialog
            (
              context: context, 
              builder: (BuildContext context)
              {
                return AlertDialog
                (
                  title: const Text('編輯資料'),
                  content: Text
                  (
                    '資料(姓名、密碼)$message ! 請登出及重新登入來查看',
                  ),
                  actions: 
                  [
                    ElevatedButton
                    (
                      onPressed: ()
                      {
                        Navigator.of(context).pop();
                      }, 
                      child: const Text("確定資料"),
                    )
                  ],
                );
              },
            );

          }
          _firstnameController.clear();
          _passwordController.clear();
          setState(() 
          {
            _showFields=false;
          });
        }
      }
      catch(error)
      {
        if(kDebugMode)
        {
          print('Error:請求出錯,$error');
        }
      }
      
    }
  }
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      backgroundColor: Colors.white,
      body:SafeArea
      (
        child:Container
        (
          padding:const EdgeInsets.all(16.0),
          child:Column
          (
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              Row
              (
                mainAxisAlignment: MainAxisAlignment.start,
                children:<Widget>
                [
                  IconButton
                  (
                    tooltip: '返回上一頁',
                    icon:const Icon(Icons.arrow_circle_left_outlined,size:30),
                    onPressed: (){Navigator.of(context).pop();},
                  ),
                ],
              ),
              Row
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
                  const SizedBox(width: 20),
                  if(avatarImageBytes!=null) 
                    CircleAvatar
                    (
                      minRadius: 90,
                      maxRadius: 90,
                      backgroundImage: MemoryImage(avatarImageBytes!),
                    ),
                ],
              ),
              Row
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>
                [
                  IconButton//打開相簿上傳圖片
                  (
                    tooltip: '相簿上傳',
                    icon:const Icon(Icons.photo_library,size:25), 
                    onPressed:(){_pickImage(ImageSource.gallery);}
                  ),
                  IconButton//打開相機拍照
                  (
                    tooltip: '相機拍照',
                    icon:const Icon(Icons.camera_alt,size:25),
                    onPressed: () {_pickImage(ImageSource.camera);}
                  ),
                ],
              ),
              SizedBox
              (
                child:Text
                (
                  '目前姓名:  ${updatedFirstName??_GardenerSettingPageState.firstName}',
                ),
              ),
              SizedBox
              (
                child:Text
                (
                  '目前密碼:  ${updatedPassword??userPassword}',
                ),
              ),
              SizedBox
              (
                width:150,
                child: TextButton
                (
                  child: const Text
                  (
                    "修改資料",
                    style:TextStyle(color:Colors.green),
                  ),
                  onPressed: () 
                  {
                    setState(() 
                    {
                      _showFields=true;
                    });
                  },
                ),
              ),
              if(_showFields)
                Column
                (
                  children: 
                  [
                    SizedBox
                    (
                      width:300,
                      height:80,
                      child:TextField
                      (
                        controller: _firstnameController,
                        obscureText: false,
                        decoration:const InputDecoration
                        (
                          prefixIcon: Icon(Icons.person),
                          labelText: "更改姓名",
                          hintText: "請輸入新的姓名",
                        ),
                        maxLength: 10,
                      ),
                    ),
                    SizedBox
                    (
                      width:300,
                      height:80,
                      child:TextField
                      (
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration:InputDecoration
                        (
                          prefixIcon: const Icon(Icons.lock),
                          labelText: "更改密碼",
                          hintText: "請輸入新的密碼",
                          suffixIcon: IconButton
                          (
                            icon:Icon
                            (
                              _showPassword
                              ? Icons.visibility
                              :Icons.visibility_off,
                            ),
                            onPressed: ()
                            {
                              setState(() 
                              {
                                _showPassword=!_showPassword;
                              });
                            },
                          ),
                        ),
                        maxLength: 16,
                      ),
                    ),
                    ElevatedButton
                    (
                      onPressed: ()
                      {
                        updateUserInfo();
                      }, 
                      child:const Text('確認修改'),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _pickImage(ImageSource source)async
  {
    final ImagePicker picker=ImagePicker();
    final pickedFile=await picker.pickImage(source: source);
    if(pickedFile!=null)
    {
      if(!kIsWeb)//ios
      {
        _imageFile=File(pickedFile.path);
        _imageFileName='${_GardenerSettingPageState.avatarName}.jpg';//pickedFile.name;
        if (kDebugMode) 
        {
          print('IOS: $_imageFileName');
        }
        //_imageFileName=pickedFile.path.split('/').last;
        _uploadAvatar(_imageFile);
      }
      else//web
      {
        final bytes=await pickedFile.readAsBytes();
        _imageBytes=bytes;
        _imageFileName='${_GardenerSettingPageState.avatarName}.jpg';//pickedFile.name;
        if (kDebugMode) 
        {
          print('WEB :$_imageFileName');
        }
        _uploadAvatar(_imageBytes);
      }
      setState(() 
      {
        avatarImageBytes=_imageBytes;
        //this.avatarName=avatarName;
      });
    }
    else
    {
      if(kDebugMode)
      {
        print('保持原頭像圖片噢');
      }
    }
    setState(() 
    {
      _isAvatarUpdated=true;  
    });
  }
  Future<void> _uploadAvatar(dynamic image)async
  {
    try
    {
      final accessToken = await _storage.read(key: 'access_token');
      if(accessToken!=null)
      {
        var uri=Uri.parse('http://120.126.16.222/gardeners/edit-avatar');
        var request=http.MultipartRequest('POST',uri);
        request.headers['Authorization']='Bearer $accessToken';
        if(!kIsWeb&&_imageFile!=null)
        {
          final fileStream=http.ByteStream(Stream.castFrom(_imageFile?.openRead() as Stream));
          final fileLength=await _imageFile!.length();
          final multipartFile=http.MultipartFile
          (
            'file',
            fileStream,
            fileLength,
            filename:'${_GardenerSettingPageState.avatarName}.jpg'//_imageFileName
          );
          request.files.add(multipartFile);
        }
        else if(kIsWeb&&_imageBytes!=null)
        {
          final multipartFile=http.MultipartFile.fromBytes
          (
            'file',
            _imageBytes!,
            filename: '${_GardenerSettingPageState.avatarName}.jpg'//_imageFileName,
          );
          request.files.add(multipartFile);
        }
        final response=await http.Response.fromStream(await request.send());
        if(response.statusCode<=200&&response.statusCode<300)
        {
          final responseData=json.decode(response.body);
          if (responseData.isNotEmpty) 
          {
            //final message = responseData[0]['message'];
            if(_imageFile!=null||_imageBytes!=null)
            {
              if(_isAvatarUpdated)
              {
                // ignore: use_build_context_synchronously
                showDialog
                (
                  context: context, 
                  builder: (BuildContext context)
                  {
                    return AlertDialog
                    (
                      title: const Text('編輯頭像'),
                      content: const Text
                      (
                        '頭像上傳成功! \n 圖檔已更新，請登出及重新登入來查看'
                      ),
                      actions: 
                      [
                        ElevatedButton
                        (
                          onPressed: ()
                          {
                            Navigator.of(context).pop();
                          }, 
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
              _isAvatarUpdated=false;
            }
            if(kDebugMode)
            {
              print(responseData);
              print("頭像上傳成功");
              print('$_imageFileName');
            }
            else
            {
              if(kDebugMode)
              {
                print("Error: 頭像上傳失敗, ${response.statusCode}");
              }
            }
          }    
        }
      }
    }
    catch(error)
    {
      if(kDebugMode)
      {
        print("頭像上傳失敗:$error");
      }
      else
      {
        if (kDebugMode) 
        {
          print("無法取得Access Token");
        }
      }
    }
  }
}