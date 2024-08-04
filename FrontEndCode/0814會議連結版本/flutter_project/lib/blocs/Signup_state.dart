import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable 
{
  const SignUpState();
  @override
  List<Object?> get props => [];
}
class SignUpInitialState extends SignUpState{}//初始
class SignUpLoadingState extends SignUpState{}//Loading
class SignUpSuccessState extends SignUpState//成功註冊
{
  //回傳"error_message":"註冊成功"
  final String errorMessage;
  const SignUpSuccessState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
class SignUpFailureState extends SignUpState//失敗
{
  //失敗API回傳
  //"error_message":"帳號已存在"或"資料輸入不完整"或"請選擇Avatar"
  final String errorMessage;
  const SignUpFailureState({required this.errorMessage});
  @override
  List<Object?>get props=>[errorMessage];
}
