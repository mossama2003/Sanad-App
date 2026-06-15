class UserProfileModel {
  int? id;
  String? gender;
  String? dob;
  String? bloodGroup;
  String? nid;
  String? country;
  String? state;
  String? city;
  String? address;
  List<int>? interests;

  UserProfileModel({
    this.id,
    this.gender,
    this.dob,
    this.bloodGroup,
    this.nid,
    this.country,
    this.state,
    this.city,
    this.address,
    this.interests,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      gender: json['gender'],
      dob: json['dob'],
      bloodGroup: json['blood_group'],
      nid: json['nid'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      address: json['address'],
      interests: json['interests'] != null
          ? List<int>.from(json['interests'])
          : [],
    );
  }
}