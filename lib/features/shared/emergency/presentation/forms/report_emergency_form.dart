import 'dart:async';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_text.dart';
import 'package:sanad_app/core/validator/app_validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/shared/widgets/custom_field_dropdown.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/emergency_model.dart';
import '../../data/params/emergency_param.dart';
import '../controllers/emergency_cubit.dart';
import 'package:flutter/services.dart';

class OrganizationEmergencyForm extends StatefulWidget {
  final EmergencyCubit emergencyCubit;
  final EmergencyModel? emergency;

  const OrganizationEmergencyForm({
    super.key,
    required this.emergencyCubit,
    this.emergency,
  });

  bool get isEditing => emergency != null;

  @override
  State<OrganizationEmergencyForm> createState() =>
      _OrganizationEmergencyFormState();
}

class _OrganizationEmergencyFormState extends State<OrganizationEmergencyForm> {
  EmergencyCubit get cubit => widget.emergencyCubit;

  bool get isEditing => cubit.isEditing;

  bool get hasLocation => cubit.hasLocation;

  String? get locationUrl => cubit.locationUrl;

  int get _currentEmergencyPhotosCount => cubit.currentEmergencyPhotosCount;

  int get _currentSupportingDocumentsCount =>
      cubit.currentSupportingDocumentsCount;

  @override
  void initState() {
    super.initState();

    final emergency = widget.emergency;

    if (emergency != null) {
      cubit.fillFormForEditing(emergency);
    } else {
      cubit.clearForm();
    }
  }

  void _fillFormForEditing() {
    final emergency = widget.emergency;

    if (emergency == null) return;

    cubit.titleController.text = emergency.name;
    cubit.descriptionController.text = emergency.description;
    cubit.volunteersController.text = emergency.volunteers.toString();
    cubit.contactController.text = cubit.normalizeEgyptianPhone(
      emergency.contactPhone,
    );

    cubit.selectedCategory.value = cubit.categories.contains(emergency.category)
        ? emergency.category
        : 'other';

    cubit.selectedUrgency.value =
        cubit.urgencyLevels.contains(emergency.urgency)
        ? emergency.urgency
        : 'medium';

    cubit.selectedSkills
      ..clear()
      ..addAll(emergency.skills.where((skill) => cubit.skills.contains(skill)));

    cubit.certificationsController.text = emergency.certifications.join(', ');

    final location = emergency.location;

    if (location != null) {
      cubit.locationController.text = location.description;

      final coordinates = emergency.coordinates;

      if (coordinates is Map) {
        cubit.latitude = double.tryParse(
          '${coordinates['latitude'] ?? coordinates['lat'] ?? ''}',
        );

        cubit.longitude = double.tryParse(
          '${coordinates['longitude'] ?? coordinates['lng'] ?? ''}',
        );
      }
    }

    final bloodType = emergency.bloodType;

    cubit.selectedBloodType.value =
        bloodType != null && cubit.bloodTypes.contains(bloodType)
        ? bloodType
        : 'Any';

    cubit.existingPhotos
      ..clear()
      ..addAll(emergency.attachments.where((attachment) => attachment.isImage));

    cubit.existingDocuments
      ..clear()
      ..addAll(
        emergency.attachments.where((attachment) => !attachment.isImage),
      );
  }

  // ============================================================
  // Limit Message
  // ============================================================

  void _showAttachmentLimitMessage({required String type, required int max}) {
    if (!mounted) return;

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

    if (croppedFile == null) {
      return null;
    }

    return File(croppedFile.path);
  }

  // ============================================================
  // Pick Emergency Photos
  // ============================================================

  Future<void> _pickEmergencyPhotos() async {
    final remaining = cubit.remainingEmergencyPhotos;

    if (remaining <= 0) {
      _showAttachmentLimitMessage(
        type: 'photos',
        max: cubit.maxEmergencyPhotos,
      );
      return;
    }

    final files = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (files.isEmpty) return;

    final validFiles = files
        .where((file) => file.path != null)
        .take(remaining)
        .toList();

    final totalValidFiles = files.where((file) => file.path != null).length;

    final skippedCount = totalValidFiles - validFiles.length;

    if (skippedCount > 0) {
      _showAttachmentLimitMessage(
        type: 'photos',
        max: cubit.maxEmergencyPhotos,
      );
    }

    final List<File> croppedFiles = [];

    for (final file in validFiles) {
      if (!mounted) return;

      final cropped = await _cropImage(file.path!);

      if (cropped != null) {
        croppedFiles.add(cropped);

        if (croppedFiles.length >= remaining) {
          break;
        }
      }
    }

    if (!mounted || croppedFiles.isEmpty) {
      return;
    }

    setState(() {
      final availableSlots =
          cubit.maxEmergencyPhotos - cubit.emergencyPhotos.length;

      if (availableSlots <= 0) {
        return;
      }

      cubit.emergencyPhotos.addAll(croppedFiles.take(availableSlots));
    });
  }

  // ============================================================
  // Pick Supporting Documents
  // ============================================================

  Future<void> _pickSupportingDocuments() async {
    final remaining = cubit.remainingSupportingDocuments;

    if (remaining <= 0) {
      _showAttachmentLimitMessage(
        type: 'supporting documents',
        max: cubit.maxSupportingDocuments,
      );
      return;
    }

    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      allowMultiple: true,
    );

    if (files.isEmpty) return;

    final validFiles = files
        .where((file) => file.path != null)
        .take(remaining)
        .toList();

    final totalValidFiles = files.where((file) => file.path != null).length;

    final skippedCount = totalValidFiles - validFiles.length;

    if (skippedCount > 0) {
      _showAttachmentLimitMessage(
        type: 'supporting documents',
        max: cubit.maxSupportingDocuments,
      );
    }

    if (!mounted || validFiles.isEmpty) {
      return;
    }

    setState(() {
      final availableSlots =
          cubit.maxSupportingDocuments - cubit.supportingDocuments.length;

      if (availableSlots <= 0) {
        return;
      }

      cubit.supportingDocuments.addAll(
        validFiles.take(availableSlots).map((file) => File(file.path!)),
      );
    });
  }

  // ============================================================
  // Pick Current Location
  // ============================================================

  Future<void> _pickCurrentLocation() async {
    if (cubit.isLocating) return;

    setState(() {
      cubit.isLocating = true;
    });

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

      if (!mounted) return;

      setState(() {
        cubit.latitude = position.latitude;
        cubit.longitude = position.longitude;
      });

      debugPrint('======================================');
      debugPrint('EMERGENCY LOCATION');
      debugPrint('Latitude: ${cubit.latitude}');
      debugPrint('Longitude: ${cubit.longitude}');
      debugPrint('URL: $locationUrl');
      debugPrint('======================================');
    } on TimeoutException {
      AppToast.error('shared.emergency.location_failed'.tr());
    } catch (e) {
      debugPrint('GET EMERGENCY LOCATION ERROR: $e');

      AppToast.error('shared.emergency.location_failed'.tr());
    } finally {
      if (mounted) {
        setState(() {
          cubit.isLocating = false;
        });
      }
    }
  }

  // ============================================================
  // Toggle Skill
  // ============================================================

  void _toggleSkill(String skill) {
    setState(() {
      if (!cubit.selectedSkills.remove(skill)) {
        cubit.selectedSkills.add(skill);
      }
    });
  }

  // ============================================================
  // Submit
  // ============================================================

  Future<void> _submit() async {
    if (!cubit.formKey.currentState!.validate()) return;

    if (!hasLocation) {
      AppToast.error('shared.emergency.location_required'.tr());
      return;
    }

    final certifications = cubit.certificationsController.text
        .split(RegExp(r'[,،]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final bloodType =
        cubit.selectedBloodType.value == null ||
            cubit.selectedBloodType.value == 'Any'
        ? null
        : cubit.selectedBloodType.value;

    final newAttachments = <File>[
      ...cubit.emergencyPhotos,
      ...cubit.supportingDocuments,
    ];

    FocusScope.of(context).unfocus();

    if (isEditing) {
      final emergency = widget.emergency!;

      final param = UpdateEmergencyParam(
        name: cubit.titleController.text.trim(),
        description: cubit.descriptionController.text.trim(),
        category: cubit.selectedCategory.value!,
        urgency: cubit.selectedUrgency.value!,
        contactPhone: cubit.contactController.text.trim(),
        volunteers: int.tryParse(cubit.volunteersController.text.trim()),
        skills: cubit.selectedSkills.toList(),
        certifications: certifications,
        locationDescription: cubit.locationController.text.trim(),
        locationUrl: locationUrl ?? emergency.location?.url,
        bloodType: bloodType,
        attachments: newAttachments,
        deletedAttachmentIds: cubit.deletedAttachmentIds.toList(),
      );

      final success = await widget.emergencyCubit.updateEmergency(
        emergency.id,
        param,
        context: context,
      );

      if (success && mounted) {
        Navigator.pop(context);
      }

      return;
    }

    final param = CreateEmergencyParam(
      name: cubit.titleController.text.trim(),
      description: cubit.descriptionController.text.trim(),
      category: cubit.selectedCategory.value!,
      urgency: cubit.selectedUrgency.value!,
      contactPhone: cubit.contactController.text.trim(),
      volunteers: int.tryParse(cubit.volunteersController.text.trim()),
      skills: cubit.selectedSkills.toList(),
      certifications: certifications,
      locationDescription: cubit.locationController.text.trim(),
      locationUrl: locationUrl,
      bloodType: bloodType,
      attachments: newAttachments,
    );

    widget.emergencyCubit.createEmergency(param);
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleColor =
        theme.textTheme.bodyMedium?.color ?? AppColors.textPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // ============================================================
      // AppBar
      // ============================================================
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            if (widget.emergencyCubit.isCreatingEmergency) {
              return;
            }

            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.red,
            size: AppSize.getSize(20),
          ),
        ),

        title: Text(
          isEditing
              ? 'shared.emergency.edit_title'.tr()
              : 'shared.emergency.title'.tr(),
          style: TextStyle(
            fontSize: AppSize.font(18),
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),

        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.red),
      ),

      // ============================================================
      // Body
      // ============================================================
      body: BlocListener<EmergencyCubit, EmergencyState>(
        bloc: widget.emergencyCubit,

        listener: (context, state) {
          debugPrint(
            'EMERGENCY FORM LISTENER => '
            'cubit=${identityHashCode(widget.emergencyCubit)} '
            'state=${state.runtimeType}',
          );

          if (state is EmergencyCreated) {
            debugPrint(
              'EMERGENCY CREATED => '
              'id=${state.emergencyId}',
            );

            Navigator.pop(context);
          }
        },

        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            padding: AppSize.padding(
              horizontal: AppSize.getWidth(16),
              top: AppSize.getHeight(10),
              bottom: AppSize.getHeight(30),
            ),

            child: Form(
              key: cubit.formKey,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  // ========================================================
                  // Page Title
                  // ========================================================

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'shared.emergency.reports.title'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(24),
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(6)),

                  // ========================================================
                  // Page Description
                  // ========================================================
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'shared.emergency.desc'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(14),
                        fontWeight: FontWeight.w300,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: .65,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(24)),

                  // ========================================================
                  // Emergency Title
                  // ========================================================
                  CustomFieldText(
                    controller: cubit.titleController,
                    title: 'shared.emergency.reports.emergency_title'.tr(),
                    hintText: 'shared.emergency.reports.brief'.tr(),
                    titleSize: AppSize.font(15),
                    titleColor: titleColor,
                    borderRadius: 20,
                    validator: AppValidators.required,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Category
                  // ========================================================
                  CustomFieldDropdown<String>(
                    title: 'shared.emergency.reports.category'.tr(),
                    titleSize: AppSize.font(15),
                    titleColor: titleColor,
                    borderRadius: 20,
                    hintText: 'shared.emergency.reports.select_category'.tr(),
                    validator: AppValidators.dropdownRequired<String>,
                    selected: cubit.selectedCategory,
                    items: cubit.categories.map((category) {
                      return DropdownItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Description
                  // ========================================================
                  CustomFieldText(
                    controller: cubit.descriptionController,
                    title: 'shared.emergency.reports.description'.tr(),
                    hintText: 'shared.emergency.reports.detailed'.tr(),
                    titleSize: AppSize.font(15),
                    titleColor: titleColor,
                    borderRadius: 20,
                    minLines: 5,
                    validator: AppValidators.required,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Urgency
                  // ========================================================
                  CustomFieldDropdown<String>(
                    title: 'shared.emergency.reports.urgency_level'.tr(),
                    titleSize: AppSize.font(15),
                    titleColor: titleColor,
                    borderRadius: 20,
                    hintText: 'shared.emergency.reports.select_urgency'.tr(),
                    validator: AppValidators.dropdownRequired<String>,
                    selected: cubit.selectedUrgency,
                    items: cubit.urgencyLevels.map((level) {
                      return DropdownItem(value: level, child: Text(level));
                    }).toList(),
                    onChanged: (_) {},
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Location Description
                  // ========================================================
                  // CustomFieldText(
                  //   controller: locationController,
                  //   title: 'shared.emergency.reports.location'.tr(),
                  //   hintText: 'shared.emergency.reports.location_hint'.tr(),
                  //   titleSize: AppSize.font(15),
                  //   titleColor: titleColor,
                  //   borderRadius: 20,
                  //   validator: AppValidators.required,
                  // ),
                  //
                  // SizedBox(height: AppSize.getHeight(10)),

                  // ========================================================
                  // Current Location
                  // ========================================================
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'shared.emergency.reports.location'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        color: titleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(10)),

                  _DashedActionBox(
                    icon: hasLocation
                        ? Icons.check_circle_outline
                        : Icons.location_on_outlined,
                    label: cubit.isLocating
                        ? 'shared.emergency.reports.getting_location'.tr()
                        : hasLocation
                        ? 'shared.emergency.reports.location_picked'.tr()
                        : 'shared.emergency.reports.pick_location'.tr(),
                    loading: cubit.isLocating,
                    height: AppSize.getHeight(110),
                    onTap: _pickCurrentLocation,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Volunteers Needed
                  // ========================================================
                  CustomFieldText(
                    controller: cubit.volunteersController,
                    title: 'shared.emergency.reports.volunteers_needed'.tr(),
                    hintText: '20',
                    titleSize: AppSize.font(15),
                    titleColor: titleColor,
                    borderRadius: 20,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      final error = AppValidators.onlyNumbers(value);

                      if (error != null) {
                        return error;
                      }

                      if (value != null &&
                          value.isNotEmpty &&
                          value.startsWith('0')) {
                        return 'shared.emergency.reports.'
                                'number_must_be_positive'
                            .tr();
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Required Skills
                  // ========================================================
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'shared.emergency.reports.required_skills'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        color: titleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(10)),

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      spacing: AppSize.getWidth(8),
                      runSpacing: AppSize.getHeight(8),
                      children: cubit.skills.map((skill) {
                        return _SkillChip(
                          label: skill,
                          selected: cubit.selectedSkills.contains(skill),
                          onTap: () => _toggleSkill(skill),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Blood Type
                  // ========================================================
                  CustomFieldDropdown<String>(
                    title: 'shared.emergency.reports.required_blood_type'.tr(),
                    titleSize: AppSize.font(15),
                    titleColor: titleColor,
                    borderRadius: 20,
                    hintText: 'shared.emergency.reports.any'.tr(),
                    selected: cubit.selectedBloodType,
                    items: cubit.bloodTypes.map((type) {
                      return DropdownItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (_) {},
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Certifications
                  // ========================================================
                  CustomFieldText(
                    controller: cubit.certificationsController,
                    title:
                        'shared.emergency.reports.'
                                'required_certifications'
                            .tr(),
                    hintText:
                        'shared.emergency.reports.'
                                'certifications_hint'
                            .tr(),
                    titleSize: AppSize.font(15),
                    titleColor: titleColor,
                    borderRadius: 20,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Contact
                  // ========================================================
                  CustomFieldText(
                    controller: cubit.contactController,
                    title: 'shared.emergency.reports.contact_info'.tr(),
                    hintText: '1xxxxxxxxx',
                    isRequired: true,
                    titleSize: AppSize.font(15),
                    titleColor: titleColor,
                    borderRadius: 20,
                    keyboardType: TextInputType.phone,
                    prefixText: '+20 ',
                    validator: AppValidators.egyptianPhoneWithoutZero,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.deny(RegExp(r'^0')),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Emergency Photos
                  // ========================================================
                  _MultiAttachmentsField(
                    title: 'shared.emergency.reports.upload_images'.tr(),
                    icon: Icons.add_photo_alternate_outlined,
                    maxFiles: cubit.maxEmergencyPhotos,
                    currentFilesCount: _currentEmergencyPhotosCount,
                    existingFiles: cubit.existingPhotos,
                    newFiles: cubit.emergencyPhotos,
                    onAdd: _pickEmergencyPhotos,
                    onRemoveExisting: (attachment) {
                      setState(() {
                        cubit.existingPhotos.remove(attachment);

                        if (attachment.id != null) {
                          cubit.deletedAttachmentIds.add(attachment.id!);
                        }
                      });
                    },
                    onRemoveNew: (index) {
                      setState(() {
                        cubit.emergencyPhotos.removeAt(index);
                      });
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Supporting Documents
                  // ========================================================
                  _MultiAttachmentsField(
                    title: 'shared.emergency.reports.upload_documents'.tr(),
                    icon: Icons.upload_file_outlined,
                    maxFiles: cubit.maxSupportingDocuments,
                    currentFilesCount: _currentSupportingDocumentsCount,
                    existingFiles: cubit.existingDocuments,
                    newFiles: cubit.supportingDocuments,
                    onAdd: _pickSupportingDocuments,
                    onRemoveExisting: (attachment) {
                      setState(() {
                        cubit.existingDocuments.remove(attachment);

                        if (attachment.id != null) {
                          cubit.deletedAttachmentIds.add(attachment.id!);
                        }
                      });
                    },
                    onRemoveNew: (index) {
                      setState(() {
                        cubit.supportingDocuments.removeAt(index);
                      });
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(25)),

                  // ========================================================
                  // Buttons
                  // ========================================================
                  BlocBuilder<EmergencyCubit, EmergencyState>(
                    bloc: widget.emergencyCubit,
                    builder: (context, state) {
                      final isLoading =
                          widget.emergencyCubit.isCreatingEmergency ||
                          widget.emergencyCubit.isUpdatingEmergency;

                      return Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              onTap: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              title: 'shared.emergency.reports.cancel'.tr(),
                              textColor: AppColors.primary,
                              bgColor: Colors.transparent,
                              borderColor: AppColors.primary,
                              height: AppSize.getHeight(40),
                            ),
                          ),

                          SizedBox(width: AppSize.getWidth(12)),

                          Expanded(
                            child: CustomButton(
                              loading: isLoading,
                              onTap: isLoading
                                  ? null
                                  : () {
                                      FocusScope.of(context).unfocus();
                                      _submit();
                                    },
                              title:
                                  (isEditing
                                          ? 'shared.emergency.reports.save_changes'
                                          : 'shared.emergency.reports.submit_emergency')
                                      .tr(),
                              textColor: AppColors.white,
                              bgColor: AppColors.red,
                              height: AppSize.getHeight(40),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Multi Attachments Field
// ============================================================================

class _MultiAttachmentsField extends StatelessWidget {
  final String title;
  final IconData icon;
  final int maxFiles;
  final int currentFilesCount;

  final List<EmergencyAttachment> existingFiles;
  final List<File> newFiles;

  final VoidCallback onAdd;
  final void Function(EmergencyAttachment attachment) onRemoveExisting;
  final void Function(int index) onRemoveNew;

  const _MultiAttachmentsField({
    required this.title,
    required this.icon,
    required this.maxFiles,
    required this.currentFilesCount,
    required this.existingFiles,
    required this.newFiles,
    required this.onAdd,
    required this.onRemoveExisting,
    required this.onRemoveNew,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .65);
    final borderColor = textColor.withValues(alpha: .18);

    final canAdd = currentFilesCount < maxFiles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppSize.font(15),
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            Text(
              '$currentFilesCount/$maxFiles',
              style: TextStyle(
                fontSize: AppSize.font(11),
                color: secondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.getHeight(8)),
        Wrap(
          spacing: AppSize.getWidth(8),
          runSpacing: AppSize.getHeight(8),
          children: [
            // Existing server attachments.
            for (final attachment in existingFiles)
              _ExistingAttachmentChip(
                attachment: attachment,
                icon: icon,
                onRemove: () => onRemoveExisting(attachment),
              ),

            // Newly selected local attachments.
            for (int i = 0; i < newFiles.length; i++)
              _AttachmentChip(
                name: newFiles[i].path.split('/').last,
                icon: icon,
                onRemove: () => onRemoveNew(i),
              ),

            if (canAdd)
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: AppSize.getSize(90),
                  height: AppSize.getSize(90),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: secondaryColor,
                        size: AppSize.getSize(24),
                      ),
                      SizedBox(height: AppSize.getHeight(4)),
                      Text(
                        'shared.emergency.reports.add_file'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppSize.font(11),
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ExistingAttachmentChip extends StatelessWidget {
  final EmergencyAttachment attachment;
  final IconData icon;
  final VoidCallback onRemove;

  const _ExistingAttachmentChip({
    required this.attachment,
    required this.icon,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final url = attachment.url;

    return Container(
      width: AppSize.getSize(90),
      height: AppSize.getSize(90),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: textColor.withValues(alpha: .18)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: AppSize.padding(all: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (attachment.isImage && url.isNotEmpty)
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            icon,
                            color: textColor.withValues(alpha: .65),
                          ),
                        ),
                      ),
                    )
                  else
                    Icon(
                      icon,
                      color: textColor.withValues(alpha: .65),
                      size: AppSize.getSize(24),
                    ),
                  SizedBox(height: AppSize.getHeight(4)),
                  Text(
                    attachment.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSize.font(9),
                      color: textColor.withValues(alpha: .75),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: AppSize.getSize(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Attachment Chip
// ============================================================================

class _AttachmentChip extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onRemove;

  const _AttachmentChip({
    required this.name,
    required this.icon,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;

    final secondaryColor = textColor.withValues(alpha: .65);

    final borderColor = textColor.withValues(alpha: .18);

    return Container(
      width: AppSize.getSize(90),
      height: AppSize.getSize(90),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Stack(
        children: [
          Padding(
            padding: AppSize.padding(all: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: secondaryColor, size: AppSize.getSize(22)),
                SizedBox(height: AppSize.getHeight(4)),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppSize.font(9),
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: AppSize.getSize(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Skill Chip
// ============================================================================

class _SkillChip extends StatelessWidget {
  const _SkillChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: AppSize.padding(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppSize.font(12),
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Dashed Action Box
// ============================================================================

class _DashedActionBox extends StatelessWidget {
  const _DashedActionBox({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.height,
    this.loading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double height;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withValues(alpha: .5);

    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.primary.withValues(alpha: .3),
          radius: 20,
        ),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                SizedBox(
                  width: AppSize.getSize(24),
                  height: AppSize.getSize(24),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              else
                Icon(icon, color: color, size: AppSize.getSize(26)),

              SizedBox(height: AppSize.getHeight(8)),

              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: AppSize.font(14), color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Dashed Border Painter
// ============================================================================

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    const dash = 6.0;
    const gap = 5.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dash), paint);

        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) {
    return old.color != color || old.radius != radius;
  }
}
