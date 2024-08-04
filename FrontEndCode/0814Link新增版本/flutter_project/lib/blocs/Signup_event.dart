import 'package:equatable/equatable.dart';
import 'dart:io';
import 'dart:typed_data';

abstract class SignUpEvent extends Equatable 
{
  const SignUpEvent();
  @override
  List<Object?> get props => [];
}
class SignUpButtonPressedEvent extends SignUpEvent
{
  final String account;
  final String firstname;
  final String password;
  final File? imageFile;
  final Uint8List? imageBytes;
  const SignUpButtonPressedEvent
  (
    {
      required this.account,
      required this.firstname,
      required this.password, 
      this.imageFile, 
      this.imageBytes,
    }
  );
  @override
  List<Object?> get props => [account,firstname,password,imageFile,imageBytes];
}
class SignUpRefreshEvent extends SignUpEvent{}
