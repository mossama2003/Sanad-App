import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;

class CreateEmergencyParam {
  CreateEmergencyParam({
    required this.name,
    required this.description,
    required this.category,
    required this.urgency,
    required this.contactPhone,
    required this.attachments,
    this.volunteers,
    this.skills = const [],
    this.certifications = const [],
    this.locationDescription,
    this.locationUrl,
    this.bloodType,
    this.note,
    this.active,
  });

  final String name;
  final String description;
  final String category;
  final String urgency;
  final String contactPhone;

  final int? volunteers;

  final List<String> skills;
  final List<String> certifications;

  final String? locationDescription;
  final String? locationUrl;

  // Optional blood type, sent inside info.
  final String? bloodType;

  final String? note;
  final bool? active;

  final List<File> attachments;

  // Additional information sent inside info.
  Map<String, dynamic> get _info => {
    if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
    if (active != null) 'active': active,
    if (bloodType != null && bloodType!.trim().isNotEmpty)
      'blood_type': bloodType!.trim(),
  };

  Future<FormData> toFormData() async {
    final info = _info;

    final locationDescriptionValue =
        locationDescription?.trim().isNotEmpty == true
        ? locationDescription!.trim()
        : 'Emergency location';

    final formData = FormData.fromMap({
      'name': name.trim(),
      'description': description.trim(),
      'category': category,
      'urgency': urgency,
      'contact_phone': contactPhone.trim(),

      if (volunteers != null) 'volunteers': volunteers,

      // Always send a non-empty location description.
      'location_description': locationDescriptionValue,

      if (locationUrl?.trim().isNotEmpty == true)
        'location_url': locationUrl!.trim(),

      if (info.isNotEmpty) 'info': info,
    });

    // Skills: skills[0], skills[1], ...
    for (var i = 0; i < skills.length; i++) {
      formData.fields.add(MapEntry('skills[$i]', skills[i]));
    }

    // Certifications: certifications[0], certifications[1], ...
    for (var i = 0; i < certifications.length; i++) {
      formData.fields.add(MapEntry('certifications[$i]', certifications[i]));
    }

    // Attachments: attachments[0], attachments[1], ...
    for (var i = 0; i < attachments.length; i++) {
      final file = attachments[i];

      formData.files.add(
        MapEntry(
          'attachments[$i]',
          await MultipartFile.fromFile(
            file.path,
            filename: p.basename(file.path),
          ),
        ),
      );
    }

    // Debug request fields.
    debugPrint('========== EMERGENCY FORM DATA ==========');
    for (final field in formData.fields) {
      debugPrint('${field.key}: ${field.value}');
    }
    for (final file in formData.files) {
      debugPrint('${file.key}: ${file.value.filename}');
    }
    debugPrint('=========================================');

    return formData;
  }
}

class UpdateEmergencyParam {
  final String? name;
  final String? description;
  final String? category;
  final String? urgency;
  final String? contactPhone;
  final int? volunteers;
  final List<String>? skills;
  final List<String>? certifications;
  final String? locationDescription;
  final String? locationUrl;
  final String? bloodType;

  /// New local files only. Do not include existing server attachments.
  final List<File>? attachments;

  /// IDs of existing attachments the user explicitly deleted.
  final List<int>? deletedAttachmentIds;

  final bool? active;

  const UpdateEmergencyParam({
    this.name,
    this.description,
    this.category,
    this.urgency,
    this.contactPhone,
    this.volunteers,
    this.skills,
    this.certifications,
    this.locationDescription,
    this.locationUrl,
    this.bloodType,
    this.attachments,
    this.deletedAttachmentIds,
    this.active,
  });

  /// Creates a parameter object for updating the status only.
  const UpdateEmergencyParam.statusOnly({
    required bool this.active,
  })  : name = null,
        description = null,
        category = null,
        urgency = null,
        contactPhone = null,
        volunteers = null,
        skills = null,
        certifications = null,
        locationDescription = null,
        locationUrl = null,
        bloodType = null,
        attachments = null,
        deletedAttachmentIds = null;

  Map<String, dynamic> get _info => {
    if (bloodType != null && bloodType!.trim().isNotEmpty)
      'blood_type': bloodType!.trim(),
  };

  Future<FormData> toFormData() async {
    final formData = FormData();

    // ============================================================
    // Text Fields
    // ============================================================

    void addField(String key, String? value) {
      if (value != null) {
        formData.fields.add(MapEntry(key, value));
      }
    }

    addField('name', name?.trim());
    addField('description', description?.trim());
    addField('category', category);
    addField('urgency', urgency);
    addField('contact_phone', contactPhone?.trim());
    addField('location_description', locationDescription?.trim());
    addField('location_url', locationUrl?.trim());

    if (volunteers != null) {
      formData.fields.add(
        MapEntry('volunteers', volunteers.toString()),
      );
    }

    // ============================================================
    // Skills
    // ============================================================

    if (skills != null) {
      for (var i = 0; i < skills!.length; i++) {
        formData.fields.add(
          MapEntry('skills[$i]', skills![i]),
        );
      }
    }

    // ============================================================
    // Certifications
    // ============================================================

    if (certifications != null) {
      for (var i = 0; i < certifications!.length; i++) {
        formData.fields.add(
          MapEntry('certifications[$i]', certifications![i]),
        );
      }
    }

    // ============================================================
    // Info
    // ============================================================

    final info = _info;

    if (info.isNotEmpty) {
      formData.fields.add(
        MapEntry('info', jsonEncode(info)),
      );
    }

    // ============================================================
    // Active Status
    // ============================================================

    if (active != null) {
      formData.fields.add(
        MapEntry('active', active.toString()),
      );
    }

    // ============================================================
    // Deleted Existing Attachments
    // ============================================================

    final uniqueDeletedIds = deletedAttachmentIds?.toSet().toList() ?? [];

    for (final id in uniqueDeletedIds) {
      formData.fields.add(
        MapEntry('deleted_attachments', id.toString()),
      );
    }

    // ============================================================
    // New Attachments Only
    // ============================================================

    final newAttachments = attachments ?? const <File>[];

    for (var i = 0; i < newAttachments.length; i++) {
      final file = newAttachments[i];

      if (!await file.exists()) {
        debugPrint(
          'Skipping missing emergency attachment: ${file.path}',
        );
        continue;
      }

      formData.files.add(
        MapEntry(
          'attachments[$i]',
          await MultipartFile.fromFile(
            file.path,
            filename: p.basename(file.path),
          ),
        ),
      );
    }

    // ============================================================
    // Debug
    // ============================================================

    debugPrint('========== UPDATE EMERGENCY FORM DATA ==========');

    for (final field in formData.fields) {
      debugPrint('${field.key}: ${field.value}');
    }

    for (final file in formData.files) {
      debugPrint(
        'NEW FILE => ${file.key}: ${file.value.filename}',
      );
    }

    debugPrint('New files count: ${formData.files.length}');
    debugPrint('Deleted attachment IDs: $uniqueDeletedIds');
    debugPrint('================================================');

    return formData;
  }
}
