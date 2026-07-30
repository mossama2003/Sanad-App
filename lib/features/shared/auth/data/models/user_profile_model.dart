class UserProfileModel {
  int? id;
  String? type;
  String? created;

  UserProfileModel({this.id, this.type, this.created});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('nid')) {
      return VolunteerProfileModel.fromJson(json);
    }

    return OrganizationProfileModel.fromJson(json);
  }
}

class VolunteerProfileModel extends UserProfileModel {
  String? gender;
  String? dob;
  String? bloodGroup;
  String? nid;
  String? country;
  String? state;
  String? city;
  String? address;

  VolunteerProfileModel({
    super.id,
    this.gender,
    this.dob,
    this.bloodGroup,
    this.nid,
    this.country,
    this.state,
    this.city,
    this.address,
    super.created,
  }) : super(type: "volunteer");

  factory VolunteerProfileModel.fromJson(Map<String, dynamic> json) {
    return VolunteerProfileModel(
      id: json['id'],
      created: json['created'],
      gender: json['gender'],
      dob: json['dob'],
      bloodGroup: json['blood_group'],
      nid: json['nid'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      address: json['address'],
    );
  }
}

class OrganizationProfileModel extends UserProfileModel {
  String? website;
  String? state;
  String? headquarters;

  OrganizationProfileModel({
    super.id,
    this.website,
    this.state,
    this.headquarters,
  }) : super(type: "organization");

  factory OrganizationProfileModel.fromJson(Map<String, dynamic> json) {
    return OrganizationProfileModel(
      id: json['id'],
      website: json['website'],
      state: json['state'],
      headquarters: json['headquarters'],
    );
  }
}
