class SignInParam {
  final String email;
  final String password;

  SignInParam({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': email, 'password': password};
  }
}
