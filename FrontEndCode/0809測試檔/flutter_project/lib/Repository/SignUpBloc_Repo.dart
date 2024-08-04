import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_project/models/SignUpModel.dart';
import 'package:http/http.dart' as http;

class SignUpRepository 
{
  Future<SignUpModel> signUp
  (
    {
      required String account,
      required String password,
      required String firstName,
      File? imageFile,
      Uint8List? imageBytes,
    }
  ) 
  async 
  {
    final url = Uri.parse('http://120.126.16.222/gardeners/signup-test');

    var request = http.MultipartRequest('POST', url);
    request.fields['account'] = account;
    request.fields['password'] = password;
    request.fields['first_name'] = firstName;

    if (imageFile != null) 
    {
      final fileStream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
      final fileLength = await imageFile.length();
      final multipartFile = http.MultipartFile
      (
        'file',
        fileStream,
        fileLength,
        filename: '$account.jpg',
      );
      request.files.add(multipartFile);
    } else if (imageBytes != null) 
    {
      final multipartFile = http.MultipartFile.fromBytes
      (
        'file',
        imageBytes,
        filename: '$account.jpg',
      );
      request.files.add(multipartFile);
    }

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) 
    {
      final List<dynamic> jsonResult = jsonDecode(response.body);
      final List<SignUpModel> signUpModels=jsonResult.map((json) => SignUpModel.fromJson(json)).toList();
      final String errorMessage = signUpModels.first.errorMessage;
      return SignUpModel(errorMessage: errorMessage);
    } 
    else 
    {
      if(kDebugMode)
      {
        print('發生錯誤');
      }
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
