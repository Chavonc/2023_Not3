import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class LoginRepository//API_service
{
  String url = 'http://120.126.16.222/gardeners/login';
  Future<List<dynamic>> login(String account,String password)async
  {

    final response=await http.post
    (
      Uri.parse(url),
      headers:<String,String>{'Content-Type': 'application/json;charset=UTF-8'},
      body:jsonEncode(<String,String>//編碼,你要給什麼資料?
      {
        //input
        'account': account,
        'password': password,
      }),
    );
    if(response.statusCode>=200&&response.statusCode<300)//請求成功
    {
      List<dynamic> body =jsonDecode(response.body);
      return body;
    }
    else
    {
      //測試到底有沒有接收到資料
      log(response.body);
      log('${response.statusCode}');
      throw Exception('${response.reasonPhrase},${response.statusCode}');
    }
  }
}