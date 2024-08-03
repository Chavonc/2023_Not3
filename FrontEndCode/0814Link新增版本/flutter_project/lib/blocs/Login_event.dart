import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable 
{
  const LoginEvent();
  @override
  List<Object?> get props => [];
}
class LoginButtonPressedEvent extends LoginEvent
{
  //按下Button
  //成功=API回傳accessToken、ipAddress(有1種States)
  //失敗=API回傳防呆的資料(1種State->有2種message)
  final String account;
  final String password;
  const LoginButtonPressedEvent({required this.account,required this.password});
  @override
  List<Object?> get props => [account,password];
}
class LoginRefreshEvent extends LoginEvent{}//Reset LoginPage