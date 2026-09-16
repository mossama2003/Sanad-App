import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class CreateCaseParam {
  CreateCaseParam({
    required this.name,
    required this.description,
    required this.category,
    required this.urgency,
    required this.contactName,
    required this.contactPhone,
    this.paymentType,
    this.paymentDescription,
    this.paymentEstimatedAmount,
    this.paymentRaisedAmount,
    this.info,
    this.paymentDetails,
    this.note,
    this.active = true,
    this.attachments = const [],
  });

  final String? paymentType;
  final String? paymentDescription;
  final double? paymentEstimatedAmount;
  final double? paymentRaisedAmount;
  final List<File> attachments;
  final String name;
  final String description;
  final String category;
  final String urgency;
  final String contactName;
  final String contactPhone;
  final String? info;
  final String? paymentDetails;
  final String? note;
  final bool active;

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap({
      if (paymentType != null) 'payment_type': paymentType,
      if (paymentDescription != null) 'payment_description': paymentDescription,
      if (paymentEstimatedAmount != null)
        'payment_estimated_amount': paymentEstimatedAmount,
      if (paymentRaisedAmount != null)
        'payment_raised_amount': paymentRaisedAmount,
      'name': name,
      'description': description,
      'category': category,
      'urgency': urgency,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      if (info != null) 'info': info,
      if (paymentDetails != null) 'payment_details': paymentDetails,
      if (note != null) 'note': note,
      'active': active,
    });

    for (var i = 0; i < attachments.length; i++) {
      formData.files.add(
        MapEntry(
          'attachments[$i]',
          await MultipartFile.fromFile(
            attachments[i].path,
            filename: p.basename(attachments[i].path),
          ),
        ),
      );
    }

    return formData;
  }
}
