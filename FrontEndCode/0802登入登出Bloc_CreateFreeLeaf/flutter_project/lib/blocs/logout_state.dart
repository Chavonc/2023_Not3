abstract class AuthState {}

class LogoutSuccessState extends AuthState 
{
  final String message;
  LogoutSuccessState(this.message);
}
