import 'dart:async';
import 'package:flutter_project/models/SignUpModel.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_project/blocs/Signup_event.dart';
import 'package:flutter_project/blocs/Signup_state.dart';
import 'package:flutter_project/Repository/SignUpBloc_Repo.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> 
{
  final SignUpRepository _signupRepository;
  SignUpBloc(this._signupRepository) : super(SignUpInitialState());
  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event)async*
  {
    if(event is SignUpButtonPressedEvent)
    {
      yield* _mapSignUpButtonPressedToState(event);
    }
    else if(event is SignUpRefreshEvent)
    {
      yield SignUpInitialState();
    }
  }
  Stream<SignUpState> _mapSignUpButtonPressedToState(SignUpButtonPressedEvent event)async*
  {
    yield SignUpLoadingState();
    try
    {
      final SignUpModel signUpResult=await _signupRepository.signUp
      (
        account:event.account,
        password:event.password,
        firstName:event.firstname,
        imageFile: event.imageFile,
        imageBytes: event.imageBytes,
      );
      if(signUpResult.errorMessage=='註冊成功')
      {
        yield SignUpSuccessState(errorMessage: signUpResult.errorMessage);
      }
      else
      {
        yield SignUpFailureState(errorMessage: signUpResult.errorMessage);
      }
    }
    catch(error)// 發生錯誤
    {
      if(kDebugMode)
      {
        print('發生錯誤:');
        print('$error');
      }
      yield SignUpFailureState(errorMessage: 'Error:$error');
    }
  }
}