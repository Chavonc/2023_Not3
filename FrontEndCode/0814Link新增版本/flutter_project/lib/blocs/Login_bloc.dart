import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/blocs/Login_event.dart';
import 'package:flutter_project/blocs/Login_state.dart';
import 'package:flutter_project/Repository/LoginBloc_Repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> 
{
  final LoginRepository _loginRepository;//套用API Model
  final _storage=FlutterSecureStorage ();
  LoginBloc(this._loginRepository):super(LoginInitialState());//初始
  
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*
  {
    if(event is LoginButtonPressedEvent)
    {
      yield* _mapLoginButtonPressedToState(event);
    }
    else if(event is LoginRefreshEvent)
    {
      yield LoginInitialState();
    }
  }
  //按下Button
  Stream<LoginState> _mapLoginButtonPressedToState(LoginButtonPressedEvent event)async*
  {
    try
    {
      yield LoginLoadingState();
      final List<dynamic> response=await _loginRepository.login(event.account,event.password);
      // ignore: unnecessary_type_check
      if(response.isNotEmpty &&  response is List<dynamic>)
      {
        final String responseData=response[0].toString();
        if(response.length >= 2)//Successful
        {
          final accessToken=response[0]['access_token'].toString();
          final ipAddress=response[1]['ip_address'].toString();
          await _storage.write(key:'access_token',value:accessToken);//把access_token保存到secure storage
          yield LoginSuccessState(accessToken, ipAddress);
        }
        else if(responseData=="Account error"||responseData=="Password error")
        {
          final errorMessage=response[0]['error_message'].toString();
          yield LoginFailureState(errorMessage);
        }
        else
        {
          yield const LoginFailureState('未知的錯誤');
        }
      }
      else
      {
        yield const LoginFailureState('未知的錯誤');
      }
    }
    catch(error)
    {
      if (kDebugMode) 
      {
        print('發生錯誤:');
        print('$error');
        yield LoginFailureState('發生錯誤:$error');
      }
    }
  }
}