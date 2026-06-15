class UserAttachmentModel {
  final int? id;
  final String? url;
  final String? name;
  final String? size;
  final String? contentType;
  final String? created;
  final String? modified;

  UserAttachmentModel({
    this.id,
    this.url,
    this.name,
    this.size,
    this.contentType,
    this.created,
    this.modified,
  });

  factory UserAttachmentModel.fromJson(Map<String, dynamic> json) {
    final attachment = json['attachment'];

    return UserAttachmentModel(
      id: json['id'],
      url: attachment?['url'],
      name: attachment?['name'],
      size: attachment?['size'],
      contentType: attachment?['content-type'],
      created: json['created'],
      modified: json['modified'],
    );
  }
}
