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
  ReliabilityScoreModel? reliabilityScore;

  List<VolunteerBadgeModel>? badges;
  List<VolunteerRoleModel>? roles;

  int? xp;
  int? streak;

  String? gender;
  String? dob;
  String? bloodGroup;
  String? nid;
  String? country;
  String? state;
  String? city;
  String? address;

  bool? ownVehicle;
  String? profession;
  List<String>? languages;
  List<String>? skills;
  int? emergencyExperience;
  List<String>? interests;

  VolunteerProfileModel({
    super.id,
    this.reliabilityScore,
    this.badges,
    this.roles,
    this.xp,
    this.streak,
    this.gender,
    this.dob,
    this.bloodGroup,
    this.nid,
    this.country,
    this.state,
    this.city,
    this.address,
    this.ownVehicle,
    this.profession,
    this.languages,
    this.skills,
    this.emergencyExperience,
    this.interests,
    super.created,
  }) : super(type: 'volunteer');

  factory VolunteerProfileModel.fromJson(Map<String, dynamic> json) {
    return VolunteerProfileModel(
      id: json['id'],
      created: json['created'],

      reliabilityScore: json['reliability_score'] != null
          ? ReliabilityScoreModel.fromJson(
              Map<String, dynamic>.from(json['reliability_score']),
            )
          : null,

      badges: (json['badges'] as List<dynamic>?)
          ?.map(
            (e) => VolunteerBadgeModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),

      roles: (json['roles'] as List<dynamic>?)
          ?.map(
            (e) => VolunteerRoleModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),

      xp: json['xp'],
      streak: json['streak'],

      gender: json['gender'],
      dob: json['dob'],
      bloodGroup: json['blood_group'],
      nid: json['nid'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      address: json['address'],

      ownVehicle: json['own_vehicle'],
      profession: json['profession'],

      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),

      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),

      emergencyExperience: json['emergencey_experience'],

      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}

class ReliabilityScoreModel {
  num? totalScore;
  double? participationRate;
  double? completionRate;
  double? emergencyResponseRate;
  double? casesEngagementScore;
  double? donationsEngagementScore;

  ReliabilityScoreModel({
    this.totalScore,
    this.participationRate,
    this.completionRate,
    this.emergencyResponseRate,
    this.casesEngagementScore,
    this.donationsEngagementScore,
  });

  factory ReliabilityScoreModel.fromJson(Map<String, dynamic> json) {
    return ReliabilityScoreModel(
      totalScore: json['total_score'],
      participationRate: (json['participation_rate'] as num?)?.toDouble(),
      completionRate: (json['completion_rate'] as num?)?.toDouble(),
      emergencyResponseRate: (json['emergency_response_rate'] as num?)
          ?.toDouble(),
      casesEngagementScore: (json['cases_engagment_score'] as num?)?.toDouble(),
      donationsEngagementScore: (json['donations_engagement_score'] as num?)
          ?.toDouble(),
    );
  }
}

class VolunteerBadgeModel {
  int? id;
  String? name;
  String? description;
  String? icon;

  VolunteerBadgeModel({this.id, this.name, this.description, this.icon});

  factory VolunteerBadgeModel.fromJson(Map<String, dynamic> json) {
    return VolunteerBadgeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class VolunteerRoleModel {
  int? id;
  String? volunteer;
  String? role;
  int? userId;
  String? created;

  VolunteerRoleModel({
    this.id,
    this.volunteer,
    this.role,
    this.userId,
    this.created,
  });

  factory VolunteerRoleModel.fromJson(Map<String, dynamic> json) {
    return VolunteerRoleModel(
      id: json['id'],
      volunteer: json['volunteer'],
      role: json['role'],
      userId: json['user_id'],
      created: json['created'],
    );
  }
}

class OrganizationProfileModel extends UserProfileModel {
  int? eventsCreated;
  double? donationsRaised;
  int? attendeesCount;
  int? casesCompleted;

  String? website;
  String? state;
  String? headquarters;

  List<String>? branches;

  Map<String, dynamic>? socialMediaLinks;

  String? bio;
  String? organizationType;
  String? registerationNo;

  bool? canManageCases;
  bool? isVerified;

  OrganizationProfileModel({
    super.id,
    this.eventsCreated,
    this.donationsRaised,
    this.attendeesCount,
    this.casesCompleted,
    this.website,
    this.state,
    this.headquarters,
    this.branches,
    this.socialMediaLinks,
    this.bio,
    this.organizationType,
    this.registerationNo,
    this.canManageCases,
    this.isVerified,
    super.created,
  }) : super(type: 'organization');

  factory OrganizationProfileModel.fromJson(Map<String, dynamic> json) {
    return OrganizationProfileModel(
      id: json['id'],
      created: json['created'],
      eventsCreated: json['events_created'],
      donationsRaised: double.tryParse(
        json['donations_raised']?.toString() ?? '',
      ),
      attendeesCount: json['attendees_count'],
      casesCompleted: json['cases_completed'],
      website: json['website'],
      state: json['state'],
      headquarters: json['headquarters'],
      branches: (json['branches'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      socialMediaLinks: json['social_media_links'] != null
          ? Map<String, dynamic>.from(json['social_media_links'])
          : null,
      bio: json['bio'],
      organizationType: json['organization_type'],
      registerationNo: json['registeration_no'],
      canManageCases: json['can_manage_cases'],
      isVerified: json['is_verified'],
    );
  }
}
