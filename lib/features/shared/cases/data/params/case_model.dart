class PaymentDetails {
  PaymentDetails({
    this.paymentType,
    this.description,
    this.estimatedAmount,
    this.raisedAmount,
  });

  final String? paymentType;
  final String? description;
  final double? estimatedAmount;
  final double? raisedAmount;

  factory PaymentDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PaymentDetails();

    return PaymentDetails(
      paymentType: json['payment_type'],
      description: json['description'],
      estimatedAmount: (json['estimated_amount'] as num?)?.toDouble(),
      raisedAmount: (json['raised_amount'] as num?)?.toDouble(),
    );
  }
}

class CaseModel {
  CaseModel({
    required this.id,
    this.paymentType,
    this.paymentDescription,
    required this.paymentEstimatedAmount,
    required this.paymentRaisedAmount,
    this.paymentDetails,
    required this.created,
    required this.modified,
    required this.name,
    required this.description,
    required this.category,
    required this.urgency,
    required this.contactName,
    required this.contactPhone,
    this.info,
    this.note,
    required this.active,
  });

  final int id;
  final String? paymentType;
  final String? paymentDescription;
  final double paymentEstimatedAmount;
  final double paymentRaisedAmount;
  final PaymentDetails? paymentDetails;
  final DateTime created;
  final DateTime modified;
  final String name;
  final String description;
  final String category;
  final String urgency;
  final String contactName;
  final String contactPhone;
  final Map<String, dynamic>? info;
  final String? note;
  final bool active;

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'],
      paymentType: json['payment_type'],
      paymentDescription: json['payment_description'],
      paymentEstimatedAmount:
          (json['payment_estimated_amount'] as num?)?.toDouble() ?? 0.0,
      paymentRaisedAmount:
          (json['payment_raised_amount'] as num?)?.toDouble() ?? 0.0,
      paymentDetails: json['payment_details'] is Map<String, dynamic>
          ? PaymentDetails.fromJson(json['payment_details'])
          : null,
      created: DateTime.parse(json['created']),
      modified: DateTime.parse(json['modified']),
      name: json['name'],
      description: json['description'],
      category: json['category'],
      urgency: json['urgency'],
      contactName: json['contact_name'],
      contactPhone: json['contact_phone'],
      info: json['info'] is Map<String, dynamic> ? json['info'] : null,
      note: json['note'],
      active: json['active'] ?? true,
    );
  }
}
