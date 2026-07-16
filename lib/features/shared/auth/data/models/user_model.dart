import 'package:sanad_app/features/shared/auth/data/models/user_attachment_model.dart';
import 'package:sanad_app/features/shared/auth/data/models/user_profile_model.dart';

class UserModel {
  int? id;
  String? username;
  String? email;
  String? name;
  String? lastName;
  String? phone;
  String? avatar;
  String? role;
  int? unreadNotifications;

  UserProfileModel? profile;
  List<UserAttachmentModel> attachments;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.name,
    this.lastName,
    this.phone,
    this.avatar,
    this.role,
    this.unreadNotifications,
    this.profile,
    this.attachments = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      name: json['name'],
      lastName: json['last_name'],
      phone: json['phone'],
      avatar: json['avatar'],
      role: json['role'],
      unreadNotifications: json['unread_notifications'],
      profile: json['profile'] != null
          ? UserProfileModel.fromJson(json['profile'])
          : null,

      attachments: json['attachments'] != null
          ? List<UserAttachmentModel>.from(
              json['attachments'].map((e) => UserAttachmentModel.fromJson(e)),
            )
          : [],
    );
  }
}
