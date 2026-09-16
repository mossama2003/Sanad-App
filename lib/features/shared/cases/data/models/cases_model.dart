enum CommentStatus { sent, sending, failed }

class Creator {
  Creator({required this.id, required this.name, this.avatar});

  final int id;
  final String name;
  final String? avatar;

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'],
      name: json['name'] ?? '',
      avatar: json['avatar'],
    );
  }
}

class CasePaymentDetails {
  CasePaymentDetails({
    this.paymentType,
    this.description,
    required this.estimatedAmount,
    required this.raisedAmount,
  });

  final String? paymentType;
  final String? description;
  final double estimatedAmount;
  final double raisedAmount;

  factory CasePaymentDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CasePaymentDetails(estimatedAmount: 0.0, raisedAmount: 0.0);
    }

    return CasePaymentDetails(
      paymentType: json['payment_type'],
      description: json['description'],
      estimatedAmount: (json['estimated_amount'] as num?)?.toDouble() ?? 0.0,
      raisedAmount: (json['raised_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CaseAttachmentFile {
  CaseAttachmentFile({
    required this.url,
    required this.name,
    required this.size,
    required this.contentType,
  });

  final String url;
  final String name;
  final String size;
  final String contentType;

  factory CaseAttachmentFile.fromJson(Map<String, dynamic> json) {
    return CaseAttachmentFile(
      url: json['url'] ?? '',
      name: json['name'] ?? '',
      size: json['size'] ?? '',
      contentType: json['content-type'] ?? '',
    );
  }
}

class CaseAttachment {
  CaseAttachment({
    required this.id,
    required this.attachment,
    required this.created,
    required this.modified,
  });

  final int id;
  final CaseAttachmentFile attachment;
  final DateTime created;
  final DateTime modified;

  factory CaseAttachment.fromJson(Map<String, dynamic> json) {
    return CaseAttachment(
      id: json['id'],
      attachment: CaseAttachmentFile.fromJson(json['attachment']),
      created: DateTime.parse(json['created']),
      modified: DateTime.parse(json['modified']),
    );
  }
}

class CaseListItemModel {
  CaseListItemModel({
    required this.id,
    required this.creator,
    required this.paymentDetails,
    required this.comments,
    required this.likers,
    required this.isLiked,
    required this.attachments,
    required this.created,
    required this.modified,
    required this.name,
    required this.description,
    required this.category,
    required this.urgency,
    required this.contactName,
    required this.contactPhone,
    this.info,
    required this.verified,
    this.note,
    required this.active,
  });

  final int id;
  final Creator creator;
  final CasePaymentDetails paymentDetails;
  final int comments;
  final int likers;
  final bool isLiked;
  final List<CaseAttachment> attachments;
  final DateTime created;
  final DateTime modified;
  final String name;
  final String description;
  final String category;
  final String urgency;
  final String contactName;
  final String contactPhone;
  final dynamic info;
  final bool verified;
  final String? note;
  final bool active;

  factory CaseListItemModel.fromJson(Map<String, dynamic> json) {
    return CaseListItemModel(
      id: json['id'],
      creator: Creator.fromJson(json['creator']),
      paymentDetails: CasePaymentDetails.fromJson(json['payment_details']),
      comments: json['comments'] ?? 0,
      likers: json['likers'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((e) => CaseAttachment.fromJson(e))
          .toList(),
      created: DateTime.parse(json['created']),
      modified: DateTime.parse(json['modified']),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      urgency: json['urgency'] ?? '',
      contactName: json['contact_name'] ?? '',
      contactPhone: json['contact_phone'] ?? '',
      info: json['info'],
      verified: json['verified'] ?? false,
      note: json['note'],
      active: json['active'] ?? true,
    );
  }

  CaseListItemModel copyWithCommentsIncremented() {
    return CaseListItemModel(
      id: id,
      creator: creator,
      paymentDetails: paymentDetails,
      comments: comments + 1,
      likers: likers,
      isLiked: isLiked,
      attachments: attachments,
      created: created,
      modified: modified,
      name: name,
      description: description,
      category: category,
      urgency: urgency,
      contactName: contactName,
      contactPhone: contactPhone,
      info: info,
      verified: verified,
      note: note,
      active: active,
    );
  }
}

class CasesListModel {
  CasesListModel({
    required this.maxPages,
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  final int maxPages;
  final int count;
  final String? next;
  final String? previous;
  final List<CaseListItemModel> results;

  factory CasesListModel.fromJson(Map<String, dynamic> json) {
    return CasesListModel(
      maxPages: json['max_pages'] ?? 1,
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => CaseListItemModel.fromJson(e))
          .toList(),
    );
  }
}

class CaseCommentModel {
  CaseCommentModel({
    required this.id,
    this.creator,
    required this.created,
    required this.modified,
    required this.comment,
    this.status = CommentStatus.sent,
    this.localId,
  });

  final int id;
  final Creator? creator;
  final DateTime created;
  final DateTime modified;
  final String comment;
  final CommentStatus status;
  final String? localId;

  factory CaseCommentModel.fromJson(Map<String, dynamic> json) {
    return CaseCommentModel(
      id: json['id'],
      creator: json['creator'] != null
          ? Creator.fromJson(json['creator'])
          : null,
      created: DateTime.parse(json['created']),
      modified: DateTime.parse(json['modified']),
      comment: json['comment'] ?? '',
    );
  }

  CaseCommentModel copyWith({
    int? id,
    Creator? creator,
    DateTime? created,
    DateTime? modified,
    CommentStatus? status,
  }) {
    return CaseCommentModel(
      id: id ?? this.id,
      creator: creator ?? this.creator,
      created: created ?? this.created,
      modified: modified ?? this.modified,
      comment: comment,
      status: status ?? this.status,
      localId: localId,
    );
  }
}

class CaseChatTokenModel {
  CaseChatTokenModel({
    required this.keyName,
    required this.clientId,
    required this.timestamp,
    required this.nonce,
    required this.mac,
    required this.ttl,
    required this.capability,
  });

  final String keyName;
  final String clientId;
  final int timestamp;
  final String nonce;
  final String mac;
  final int ttl;
  final String capability;

  factory CaseChatTokenModel.fromJson(Map<String, dynamic> json) {
    return CaseChatTokenModel(
      keyName: json['keyName'],
      clientId: json['clientId'],
      timestamp: json['timestamp'],
      nonce: json['nonce'],
      mac: json['mac'],
      ttl: json['ttl'],
      capability: json['capability'],
    );
  }
}

class CaseCommentsListModel {
  CaseCommentsListModel({
    required this.maxPages,
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  final int maxPages;
  final int count;
  final String? next;
  final String? previous;
  final List<CaseCommentModel> results;

  factory CaseCommentsListModel.fromJson(Map<String, dynamic> json) {
    return CaseCommentsListModel(
      maxPages: json['max_pages'] ?? 1,
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => CaseCommentModel.fromJson(e))
          .toList(),
    );
  }
}
