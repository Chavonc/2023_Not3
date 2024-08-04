class SignUpModel 
{
  //回傳什麼就設什麼
  final String errorMessage;
  const SignUpModel({required this.errorMessage});

  factory SignUpModel.fromJson(Map<String, dynamic> json) //API會給你的資料
  {
    return SignUpModel
    (
      //API return
      errorMessage: json['error_message'],
    );
  }
}