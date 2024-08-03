import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable 
{
  const LoginState();
  @override
  List<Object?> get props => [];
}
class LoginInitialState extends LoginState{}//Initial
class LoginLoadingState extends LoginState{}//Loading
class LoginSuccessState extends LoginState
{
  //成功=API回傳accessToken、ipAddress
  final String accessToken;
  final String ipAddress;
  const LoginSuccessState(this.accessToken,this.ipAddress);
  @override
  List<Object?>get props=>[accessToken,ipAddress];
}
class LoginFailureState extends LoginState
{
  //失敗=API回傳防呆的資料(有2種message)
  final String errorMessage;
  const LoginFailureState(this.errorMessage);
  @override
  List<Object?>get props=>[errorMessage];
}