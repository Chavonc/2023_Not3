import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/Login.dart';
import 'package:flutter_project/MyPage1.dart';
import 'package:flutter_project/Repository/SignUpBloc_Repo.dart';
import 'package:flutter_project/blocs/Signup_bloc.dart';
import 'package:flutter_project/blocs/Signup_event.dart';
import 'package:flutter_project/blocs/Signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget
{
  const SignUpPage({Key?key}):super(key:key);
  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState()=>_SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage>
{
  final TextEditingController _accountController=TextEditingController();
  final TextEditingController _firstnameController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final SignUpRepository _signupRepository=SignUpRepository();
  File? _imageFile;
  Uint8List? _imageBytes;
  String? _imageFileName;
  bool _showPassword=false;
  @override
  Widget build(BuildContext context)
  {
    return BlocProvider
    (
      create: (context)=>SignUpBloc(_signupRepository),
      child:BlocConsumer<SignUpBloc,SignUpState>
      (
        listener: (context,state)
        {
          if(state is SignUpSuccessState)
          {
            _showResult(state.errorMessage, context, isSignUpSuccess: true);
          }
          else if(state is SignUpFailureState)
          {
            _showResult(state.errorMessage, context, isSignUpSuccess: false);
          }
        },
        builder:(context,state)
        {
          if(state is SignUpLoadingState)
          {
            return const Center
            (
              child:CircularProgressIndicator(),
            );
          }
          else
          {
            return Scaffold
            (
              appBar: AppBar
              (
                title: const Center
                (
                  child:Text
                  (
                    '註冊',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                backgroundColor: Colors.green,
              ),
              body:Container
              (
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Column
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>
                  [
                    GestureDetector
                    (
                      onTap: ()=>_showImageSourceDialog(context),
                      child: Container
                      (
                        width:120,
                        height: 120,
                        decoration: const BoxDecoration
                        (
                          color:Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: _getImageWidget(),
                      ),
                    ),
                    SizedBox
                    (
                      width:300,
                      height: 80,
                      child: TextField
                      (
                        controller: _accountController,
                        decoration: const InputDecoration
                        (
                          hintText: '請輸入6~40個字元內',
                          labelText: "帳號",
                          prefixIcon: Icon(Icons.person_2),
                        ),
                        maxLength: 40,
                      ),
                    ),
                    SizedBox
                    (
                      width:300,
                      height: 80,
                      child: TextField
                      (
                        controller: _firstnameController,
                        decoration: const InputDecoration
                        (
                          hintText: '請輸入10個字元內',
                          labelText: "名字",
                          prefixIcon: Icon(Icons.person),
                        ),
                        maxLength: 10,
                      ),
                    ),
                    SizedBox
                    (
                      width:300,
                      height: 80,
                      child: TextFormField
                      (
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration
                        (
                          hintText: '請輸入8~16個字元',
                          labelText: "密碼",
                          prefixIcon: const Icon(Icons.lock),
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
                    SizedBox
                    (
                      width: 250,
                      height: 48,
                      child: ElevatedButton
                      (
                        style: ElevatedButton.styleFrom
                        (
                          backgroundColor: const Color.fromARGB(255, 100, 181, 82),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle
                          (
                            fontWeight: FontWeight.bold,
                            fontSize:14,
                          ),
                        ),
                        onPressed: ()=>_onSignUpButtonPressed(context),
                        child:const Text('註冊'),
                      ),
                    ),
                  ],
                ),
              )
            );
          }
        }
      ),
    );
  }
  Future<void> _onSignUpButtonPressed(BuildContext context)async
  {
    final String account=_accountController.text;
    final String password=_passwordController.text;
    final String firstName=_firstnameController.text;

    if(account.isEmpty&&password.isEmpty&&firstName.isEmpty)
    {
      if(_imageFile==null&&_imageBytes==null)
      {
        _showResult('請選擇頭像照片', context);
      }
      else
      {
        _showResult('資料輸入不完整', context);
      }
    }
    else if(account.isEmpty||password.isEmpty||firstName.isEmpty)
    {
      if(_imageFile==null&&_imageBytes==null)
      {
        _showResult('請選擇頭像照片', context);
      }
      else
      {
        _showResult('資料輸入不完整', context);
      }
    }
    else if(account.isNotEmpty&&password.isNotEmpty&&firstName.isNotEmpty)
    {
      if(_imageFile==null&&_imageBytes==null)
      {
        _showResult('請選擇頭像照片', context);
      }
      else
      {
        BlocProvider.of<SignUpBloc>(context).add
        (
          SignUpButtonPressedEvent
          (
            account:account, 
            firstname: firstName, 
            password: password,
            imageFile:_imageFile, 
            imageBytes:_imageBytes, 
          ),
        );
      }
    }
  }
  Future <void> _pickImage(ImageSource source)async
  {
    final ImagePicker picker=ImagePicker();
    final pickedFile=await picker.pickImage(source: source);
    if(pickedFile!=null)
    {
      if(!kIsWeb)//IOS
      {
        setState(() 
        {
          _imageFile=File(pickedFile.path);
          _imageFileName=pickedFile.path.split('/').last;
        });
      }
      else//Web
      {
        final bytes=await pickedFile.readAsBytes();
        setState(() 
        {
          _imageBytes=bytes;
          _imageFileName=pickedFile.name;
        });
      }
    }
    else
    {
      if (kDebugMode) 
      {
        print('還沒有選擇頭像圖片噢');
      }
    }
  }
  Future <void> _showImageSourceDialog(BuildContext context)async
  {
    await  showDialog
    (
      context: context, 
      builder: (context)
      {
        return AlertDialog
        (
          title: const Text('選擇圖片來源'),
          content: Column
          (
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>
            [
              TextButton
              (
                onPressed: ()
                {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                }, 
                child: const Text('從相簿選擇'),
              ),
              TextButton
              (
                onPressed: ()
                {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                }, 
                child: const Text('拍攝照片'),
              ),
            ],
          ),
        );
      },
    );
  }
  void _showResult(String message,BuildContext context,{bool isSignUpSuccess = false})
  {
    showDialog
    (
      context: context, 
      builder: (context)=>AlertDialog
      (
        title: Text(isSignUpSuccess?'Sign Up Success':'Error'),
        content: Text(message),
        actions: 
        [
          TextButton
          (
            onPressed: ()=>Navigator.pop(context), 
            child: const Text('Try Again'),
          ),
          if(isSignUpSuccess==false&&message=='帳號已存在')
            TextButton
            (
              onPressed: ()
              {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const LoginPage()));
              }, 
              child: const Text('Go to Login'),
            ),
          if(isSignUpSuccess==true)
            TextButton
            (
              onPressed: ()
              {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const MyPage1()));
              }, 
              child: const Text('Start'),
            ),
        ],
      ),
    );
  }
  Widget _getImageWidget()
  {
    const double imageSize=120.0;
    if(_imageFile!=null)
    {
      return ClipOval
      (
        child:Image.file
        (
          _imageFile!,
          width: imageSize,
          height: imageSize,
          fit:BoxFit.cover,
        ),
      );
    }
    else if(_imageBytes!=null)
    {
      return ClipOval
      (
        child:Image.memory
        (
          _imageBytes!,
          width: imageSize,
          height: imageSize,
          fit:BoxFit.cover,
        ),
      );
    }
    else
    {
      return GestureDetector
      (
        onTap: ()=>_showImageSourceDialog(context),
        child: Container
        (
          width: imageSize,
          height: imageSize,
          decoration: const BoxDecoration
          (
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: const Icon
          (
            Icons.camera_alt,
            color:Colors.white,
            size:40,
          ),
        ),
      );
    }
  }
}