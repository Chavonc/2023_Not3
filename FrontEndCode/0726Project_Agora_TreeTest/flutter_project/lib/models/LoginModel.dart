//串接API
class LoginModel 
{
  //回傳什麼就設什麼
  final String accessToken;
  final String ipAddress;
  final String errormessage;
  const LoginModel({required this.accessToken, required this.ipAddress,required this.errormessage});

  factory LoginModel.fromJson(Map<String, dynamic> json) //API會給你的資料
  {
    return LoginModel
    (
      //API return
      accessToken: json['access_token'],
      ipAddress: json['ip_address'],
      errormessage:json['error_message'],
    );
  }
}