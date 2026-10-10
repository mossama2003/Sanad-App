import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/emergency_model.dart';
import '../../data/params/emergency_param.dart';
import '../../data/repos/emergency_repo.dart';

part 'emergency_state.dart';

class EmergencyCubit extends Cubit<EmergencyState> {
  EmergencyCubit(this.repo) : super(EmergencyInitial());

  final EmergencyRepo repo;

  static EmergencyCubit get(BuildContext context) =>
      BlocProvider.of<EmergencyCubit>(context);

  // ============================================================
  // Emergencies
  // ============================================================

  final List<EmergencyModel> emergencies = [];
  final List<EmergencyModel> myEmergencies = [];

  final Set<int> _joiningEmergencies = {};

  bool isMySelected = false;
  bool isCreatingEmergency = false;
  bool isUpdatingEmergency = false;

  bool get isSavingEmergency => isCreatingEmergency || isUpdatingEmergency;

  bool isJoining(int id) => _joiningEmergencies.contains(id);

  bool isMine(int id) => myEmergencies.any((e) => e.id == id);

  int get myEmergenciesCount => myEmergencies.length;

  // ============================================================
  // Form
  // ============================================================

  final formKey = GlobalKey<FormState>();

  // ============================================================
  // Controllers
  // ============================================================

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final volunteersController = TextEditingController();
  final certificationsController = TextEditingController();
  final contactController = TextEditingController();

  // ============================================================
  // Dropdowns
  // ============================================================

  final selectedCategory = ValueNotifier<String?>(null);
  final selectedUrgency = ValueNotifier<String?>(null);
  final selectedBloodType = ValueNotifier<String?>(null);

  final List<String> categories = const [
    'medical',
    'rescue',
    'food',
    'shelter',
    'other',
  ];

  final List<String> urgencyLevels = const ['low', 'medium', 'high'];

  final List<String> skills = const [
    'Doctor',
    'Nurse',
    'Engineer',
    'Driver',
    'Translator',
    'Construction Worker',
    'General Volunteer',
  ];

  final List<String> bloodTypes = const [
    'Any',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // ============================================================
  // Skills
  // ============================================================

  final Set<String> selectedSkills = {};

  void toggleSkill(String skill) {
    if (!selectedSkills.remove(skill)) {
      selectedSkills.add(skill);
    }

    emit(EmergencyFormChanged());
  }

  // ============================================================
  // Location
  // ============================================================

  double? latitude;
  double? longitude;

  bool isLocating = false;

  bool get hasLocation =>
      latitude != null && longitude != null ||
      (editingEmergency?.location?.url.isNotEmpty ?? false);

  String? get locationUrl {
    if (latitude != null && longitude != null) {
      return 'https://www.google.com/maps/search/?api=1'
          '&query=$latitude,$longitude';
    }

    final existingUrl = editingEmergency?.location?.url;

    if (existingUrl != null && existingUrl.isNotEmpty) {
      return existingUrl;
    }

    return null;
  }

  Future<void> pickCurrentLocation() async {
    if (isLocating) return;

    isLocating = true;
    emit(EmergencyFormChanged());

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        AppToast.error('shared.emergency.gps_disabled'.tr());
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        AppToast.error('shared.emergency.location_permission_forever'.tr());
        return;
      }

      if (permission == LocationPermission.denied) {
        AppToast.error('shared.emergency.location_permission_denied'.tr());
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 15));

      latitude = position.latitude;
      longitude = position.longitude;

      debugPrint('========== EMERGENCY LOCATION ==========');
      debugPrint('Latitude: $latitude');
      debugPrint('Longitude: $longitude');
      debugPrint('URL: $locationUrl');
      debugPrint('========================================');
    } on TimeoutException {
      AppToast.error('shared.emergency.location_failed'.tr());
    } catch (e, stackTrace) {
      debugPrint('GET EMERGENCY LOCATION ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      AppToast.error('shared.emergency.location_failed'.tr());
    } finally {
      isLocating = false;
      emit(EmergencyFormChanged());
    }
  }

  // ============================================================
  // Attachments
  // ============================================================

  final int maxEmergencyPhotos = 5;
  final int maxSupportingDocuments = 3;

  final List<File> emergencyPhotos = [];
  final List<File> supportingDocuments = [];

  final List<EmergencyAttachment> existingPhotos = [];
  final List<EmergencyAttachment> existingDocuments = [];

  final Set<int> deletedAttachmentIds = {};

  EmergencyModel? editingEmergency;

  bool get isEditing => editingEmergency != null;

  int get currentEmergencyPhotosCount =>
      existingPhotos.length + emergencyPhotos.length;

  int get currentSupportingDocumentsCount =>
      existingDocuments.length + supportingDocuments.length;

  int get remainingEmergencyPhotos =>
      (maxEmergencyPhotos - currentEmergencyPhotosCount).clamp(
        0,
        maxEmergencyPhotos,
      );

  int get remainingSupportingDocuments =>
      (maxSupportingDocuments - currentSupportingDocumentsCount).clamp(
        0,
        maxSupportingDocuments,
      );

  void _showAttachmentLimitMessage(
    BuildContext context, {
    required String type,
    required int max,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('You can upload a maximum of $max $type.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ============================================================
  // Crop Image
  // ============================================================

  Future<File?> _cropImage(String sourcePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      compressQuality: 85,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'shared.emergency.reports.crop_image'.tr(),
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'shared.emergency.reports.crop_image'.tr(),
          aspectRatioLockEnabled: false,
        ),
      ],
    );

    return croppedFile == null ? null : File(croppedFile.path);
  }

  // ============================================================
  // Pick Photos
  // ============================================================

  Future<void> pickEmergencyPhotos(BuildContext context) async {
    final remaining = remainingEmergencyPhotos;

    if (remaining <= 0) {
      _showAttachmentLimitMessage(
        context,
        type: 'photos',
        max: maxEmergencyPhotos,
      );
      return;
    }

    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result.isEmpty) return;

    final validFiles = result
        .where((file) => file.path != null)
        .take(remaining)
        .toList();

    final totalValidFiles = result.where((file) => file.path != null).length;

    if (totalValidFiles > validFiles.length && context.mounted) {
      _showAttachmentLimitMessage(
        context,
        type: 'photos',
        max: maxEmergencyPhotos,
      );
    }

    for (final file in validFiles) {
      if (!context.mounted) return;

      final cropped = await _cropImage(file.path!);

      if (cropped != null) {
        emergencyPhotos.add(cropped);
      }
    }

    if (emergencyPhotos.length > maxEmergencyPhotos - existingPhotos.length) {
      emergencyPhotos.removeRange(
        maxEmergencyPhotos - existingPhotos.length,
        emergencyPhotos.length,
      );
    }

    emit(EmergencyFormChanged());
  }

  // ============================================================
  // Pick Supporting Documents
  // ============================================================

  Future<void> pickSupportingDocuments(BuildContext context) async {
    final remaining = remainingSupportingDocuments;

    if (remaining <= 0) {
      _showAttachmentLimitMessage(
        context,
        type: 'supporting documents',
        max: maxSupportingDocuments,
      );
      return;
    }

    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      allowMultiple: true,
    );

    if (result.isEmpty) return;

    final validFiles = result
        .where((file) => file.path != null)
        .take(remaining)
        .toList();

    final totalValidFiles = result.where((file) => file.path != null).length;

    if (totalValidFiles > validFiles.length && context.mounted) {
      _showAttachmentLimitMessage(
        context,
        type: 'supporting documents',
        max: maxSupportingDocuments,
      );
    }

    supportingDocuments.addAll(validFiles.map((file) => File(file.path!)));

    emit(EmergencyFormChanged());
  }

  // ============================================================
  // Remove Attachments
  // ============================================================

  void removeExistingPhoto(EmergencyAttachment attachment) {
    existingPhotos.remove(attachment);

    final id = attachment.id;
    if (id != null) {
      deletedAttachmentIds.add(id);
    }

    emit(EmergencyFormChanged());
  }

  void removeExistingDocument(EmergencyAttachment attachment) {
    existingDocuments.remove(attachment);

    final id = attachment.id;
    if (id != null) {
      deletedAttachmentIds.add(id);
    }

    emit(EmergencyFormChanged());
  }

  void removeNewPhoto(int index) {
    if (index < 0 || index >= emergencyPhotos.length) return;

    emergencyPhotos.removeAt(index);
    emit(EmergencyFormChanged());
  }

  void removeNewDocument(int index) {
    if (index < 0 || index >= supportingDocuments.length) return;

    supportingDocuments.removeAt(index);
    emit(EmergencyFormChanged());
  }

  // ============================================================
  // Initialize Form
  // ============================================================

  String normalizeEgyptianPhone(String phone) {
    var normalized = phone.trim().replaceAll(RegExp(r'[\s()+-]'), '');

    if (normalized.startsWith('0020')) {
      normalized = normalized.substring(4);
    } else if (normalized.startsWith('20') && normalized.length > 10) {
      normalized = normalized.substring(2);
    }

    if (normalized.startsWith('0')) {
      normalized = normalized.substring(1);
    }

    return normalized;
  }

  void fillFormForEditing(EmergencyModel emergency) {
    clearForm(emitState: false);

    editingEmergency = emergency;

    titleController.text = emergency.name;
    descriptionController.text = emergency.description;
    volunteersController.text = emergency.volunteers.toString();
    contactController.text = normalizeEgyptianPhone(emergency.contactPhone);

    selectedCategory.value = categories.contains(emergency.category)
        ? emergency.category
        : 'other';

    selectedUrgency.value = urgencyLevels.contains(emergency.urgency)
        ? emergency.urgency
        : 'medium';

    selectedSkills
      ..clear()
      ..addAll(emergency.skills.where((skill) => skills.contains(skill)));

    certificationsController.text = emergency.certifications.join(', ');

    final location = emergency.location;
    if (location != null) {
      locationController.text = location.description;

      final coordinates = emergency.coordinates;

      if (coordinates is Map) {
        latitude = double.tryParse(
          '${coordinates['latitude'] ?? coordinates['lat'] ?? ''}',
        );

        longitude = double.tryParse(
          '${coordinates['longitude'] ?? coordinates['lng'] ?? ''}',
        );
      }
    }

    final bloodType = emergency.bloodType;

    selectedBloodType.value =
        bloodType != null && bloodTypes.contains(bloodType) ? bloodType : 'Any';

    existingPhotos.addAll(
      emergency.attachments.where((attachment) => attachment.isImage),
    );

    existingDocuments.addAll(
      emergency.attachments.where((attachment) => !attachment.isImage),
    );

    emit(EmergencyFormChanged());
  }

  // ============================================================
  // Submit Form
  // ============================================================

  List<String> _getCertifications() {
    return certificationsController.text
        .split(RegExp(r'[,،]'))
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }

  String? get selectedFormBloodType {
    final value = selectedBloodType.value;

    return value == null || value == 'Any' ? null : value;
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<bool> submitForm() async {
    if (!validateForm()) return false;

    if (!hasLocation) {
      AppToast.error('shared.emergency.location_required'.tr());
      return false;
    }

    final paramAttachments = <File>[...emergencyPhotos, ...supportingDocuments];

    final certifications = _getCertifications();

    if (isEditing) {
      final emergency = editingEmergency!;

      final param = UpdateEmergencyParam(
        name: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory.value!,
        urgency: selectedUrgency.value!,
        contactPhone: contactController.text.trim(),
        volunteers: int.tryParse(volunteersController.text.trim()),
        skills: selectedSkills.toList(),
        certifications: certifications,
        locationDescription: locationController.text.trim(),
        locationUrl: locationUrl ?? emergency.location?.url,
        bloodType: selectedFormBloodType,
        attachments: paramAttachments,
        deletedAttachmentIds: deletedAttachmentIds.toList(),
      );

      return updateEmergency(emergency.id, param);
    }

    final param = CreateEmergencyParam(
      name: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategory.value!,
      urgency: selectedUrgency.value!,
      contactPhone: contactController.text.trim(),
      volunteers: int.tryParse(volunteersController.text.trim()),
      skills: selectedSkills.toList(),
      certifications: certifications,
      locationDescription: locationController.text.trim(),
      locationUrl: locationUrl,
      bloodType: selectedFormBloodType,
      attachments: paramAttachments,
    );

    return createEmergency(param);
  }

  // ============================================================
  // Create Emergency
  // ============================================================

  Future<bool> createEmergency(CreateEmergencyParam param) async {
    if (isCreatingEmergency) return false;

    isCreatingEmergency = true;
    emit(EmergencyLoading());

    try {
      final result = await repo.createEmergency(param);

      return await result.fold(
        (failure) {
          AppToast.error(failure.errMessage);
          emit(EmergencyError());
          return false;
        },
        (emergency) {
          emergencies.removeWhere((item) => item.id == emergency.id);
          myEmergencies.removeWhere((item) => item.id == emergency.id);

          myEmergencies.insert(0, emergency);
          isMySelected = true;

          emit(EmergencyCreated(emergency.id));
          AppToast.success('volunteer.emergency.created_success'.tr());

          return true;
        },
      );
    } catch (e, stackTrace) {
      debugPrint('CREATE EMERGENCY ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(EmergencyError());
      return false;
    } finally {
      isCreatingEmergency = false;
      emit(EmergencySuccess());
    }
  }

  // ============================================================
  // Init Emergency Screen
  // ============================================================

  Future<void> initEmergencyScreen({required bool isOrg}) async {
    if (isOrg) {
      final result = await repo.getEmergencies(me: true);

      result.fold((_) {}, (items) {
        myEmergencies
          ..clear()
          ..addAll(items);
      });
    }

    await getEmergencies(me: false);
  }

  // ============================================================
  // Tabs / Fetch / Refresh
  // ============================================================

  Future<void> switchTab(bool toMyEmergencies) async {
    isMySelected = toMyEmergencies;
    emit(EmergencySuccess());

    await getEmergencies(me: toMyEmergencies);
  }

  Future<void> getEmergencies({required bool me}) async {
    final target = me ? myEmergencies : emergencies;

    if (target.isEmpty) {
      emit(EmergencyLoading());
    }

    final result = await repo.getEmergencies(me: me);

    result.fold(
      (failure) {
        emit(EmergencyError());
        AppToast.error(failure.errMessage);
      },
      (items) {
        target
          ..clear()
          ..addAll(items);

        emit(EmergencySuccess());
      },
    );
  }

  Future<void> refresh() => getEmergencies(me: isMySelected);

  Future<void> refreshCurrentList() => refresh();

  // ============================================================
  // Find / Update Local Lists
  // ============================================================

  EmergencyModel? findById(int id) {
    for (final list in [myEmergencies, emergencies]) {
      for (final emergency in list) {
        if (emergency.id == id) return emergency;
      }
    }

    return null;
  }

  void _updateEverywhere(
    int id,
    EmergencyModel Function(EmergencyModel) update,
  ) {
    for (final list in [emergencies, myEmergencies]) {
      final index = list.indexWhere((item) => item.id == id);

      if (index != -1) {
        list[index] = update(list[index]);
      }
    }
  }

  // ============================================================
  // Join Emergency
  // ============================================================

  Future<void> joinEmergency(int id) async {
    if (!_joiningEmergencies.add(id)) return;

    emit(EmergencySuccess());

    try {
      final result = await repo.joinEmergency(id);

      result.fold(
        (failure) {
          AppToast.error(failure.errMessage);
        },
        (_) {
          _updateEverywhere(
            id,
            (emergency) => emergency.copyWith(
              joined: true,
              joiners: emergency.joiners + 1,
            ),
          );

          AppToast.success('shared.emergency.card.joined_success'.tr());
        },
      );
    } catch (e, stackTrace) {
      debugPrint('JOIN EMERGENCY ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _joiningEmergencies.remove(id);
      emit(EmergencySuccess());
    }
  }

  // ============================================================
  // Update Emergency
  // ============================================================

  Future<bool> updateEmergency(
    int id,
    UpdateEmergencyParam param, {
    BuildContext? context,
  }) async {
    if (isUpdatingEmergency) return false;

    isUpdatingEmergency = true;
    emit(EmergencyLoading());

    try {
      final result = await repo.updateEmergency(id, param);

      return await result.fold(
        (failure) {
          AppToast.error(failure.errMessage);
          emit(EmergencyError());
          return false;
        },
        (updatedEmergency) {
          final existingEmergency = findById(id);

          if (existingEmergency == null) {
            _updateEverywhere(id, (_) => updatedEmergency);
            emit(EmergencySuccess());
            return true;
          }

          final deletedIds = param.deletedAttachmentIds?.toSet() ?? <int>{};

          final remainingAttachments = existingEmergency.attachments.where((
            attachment,
          ) {
            final attachmentId = attachment.id;

            return attachmentId == null || !deletedIds.contains(attachmentId);
          }).toList();

          final attachmentsAfterUpdate = updatedEmergency.attachments.isNotEmpty
              ? updatedEmergency.attachments
              : remainingAttachments;

          final emergencyToSave = existingEmergency.copyWith(
            name: updatedEmergency.name.isNotEmpty
                ? updatedEmergency.name
                : existingEmergency.name,
            description: updatedEmergency.description.isNotEmpty
                ? updatedEmergency.description
                : existingEmergency.description,
            category: updatedEmergency.category.isNotEmpty
                ? updatedEmergency.category
                : existingEmergency.category,
            urgency: updatedEmergency.urgency.isNotEmpty
                ? updatedEmergency.urgency
                : existingEmergency.urgency,
            contactPhone: updatedEmergency.contactPhone.isNotEmpty
                ? updatedEmergency.contactPhone
                : existingEmergency.contactPhone,
            volunteers: updatedEmergency.volunteers,
            active: updatedEmergency.active,
            modified: updatedEmergency.modified,
            attachments: attachmentsAfterUpdate,
          );

          _updateEverywhere(id, (_) => emergencyToSave);

          emit(EmergencySuccess());
          return true;
        },
      );
    } catch (e, stackTrace) {
      debugPrint('UPDATE EMERGENCY ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(EmergencyError());
      return false;
    } finally {
      isUpdatingEmergency = false;
      emit(EmergencySuccess());
    }
  }

  // ============================================================
  // Delete Emergency
  // ============================================================

  Future<bool> deleteEmergency(int id) async {
    try {
      final result = await repo.deleteEmergency(id);

      return await result.fold(
        (failure) {
          AppToast.error(failure.errMessage);
          emit(EmergencyError());
          return false;
        },
        (_) {
          emergencies.removeWhere((item) => item.id == id);
          myEmergencies.removeWhere((item) => item.id == id);

          emit(EmergencySuccess());
          return true;
        },
      );
    } catch (e, stackTrace) {
      debugPrint('DELETE EMERGENCY ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(EmergencyError());
      return false;
    }
  }

  // ============================================================
  // Clear Form
  // ============================================================

  void clearForm({bool emitState = true}) {
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    volunteersController.clear();
    certificationsController.clear();
    contactController.clear();

    selectedCategory.value = null;
    selectedUrgency.value = null;
    selectedBloodType.value = null;

    selectedSkills.clear();

    latitude = null;
    longitude = null;

    emergencyPhotos.clear();
    supportingDocuments.clear();

    existingPhotos.clear();
    existingDocuments.clear();

    deletedAttachmentIds.clear();

    editingEmergency = null;

    if (emitState) {
      emit(EmergencyFormChanged());
    }
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    volunteersController.dispose();
    certificationsController.dispose();
    contactController.dispose();

    selectedCategory.dispose();
    selectedUrgency.dispose();
    selectedBloodType.dispose();

    return super.close();
  }
}
