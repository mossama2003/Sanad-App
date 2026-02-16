class SocialParam {
  final String fName;
  final String lName;
  final String email;
  final String providerId;
  final String providerName;

  SocialParam({
    required this.fName,
    required this.lName,
    required this.email,
    required this.providerId,
    required this.providerName,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": fName,
      "last_name": lName,
      "email": email,
      "provider_id": providerId,
      "provider_name": providerName,
    };
  }
}
