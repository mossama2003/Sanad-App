import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/style/app_text_style.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/validator/app_validators.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/cases_model.dart';
import '../../data/params/create_case_param.dart';
import '../controllers/case_cubit.dart';

class CasesForm extends StatefulWidget {
  final CaseListItemModel? caseItem;

  const CasesForm({super.key, this.caseItem});

  bool get isEdit => caseItem != null;

  @override
  State<CasesForm> createState() => _CasesFormState();
}

class _ExistingAttachment {
  final String url;
  final String name;

  _ExistingAttachment({required this.url, required this.name});
}

class _CasesFormState extends State<CasesForm> {
  static const int _maxCasePhotos = 5;
  static const int _maxSupportingDocuments = 3;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController estimatedAmountController =
      TextEditingController();
  final TextEditingController additionalNotesController =
      TextEditingController();
  final TextEditingController raisedAmountController = TextEditingController();

  final TextEditingController instapayLinkController = TextEditingController();
  final TextEditingController walletPhoneController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();

  final ValueNotifier<String?> selectedCategory = ValueNotifier(null);
  final ValueNotifier<String?> selectedPaymentType = ValueNotifier(null);

  int selectedUrgency = 0;

  List<File> casePhotos = [];
  List<File> supportingDocuments = [];

  List<_ExistingAttachment> existingCasePhotos = [];
  List<_ExistingAttachment> existingSupportingDocuments = [];

  final List<DropdownItem<String>> categories = [
    DropdownItem(value: 'Medical', child: Text('Medical')),
    DropdownItem(value: 'Education', child: Text('Education')),
    DropdownItem(value: 'Food & Shelter', child: Text('Food & Shelter')),
    DropdownItem(value: 'Disaster Relief', child: Text('Disaster Relief')),
    DropdownItem(value: 'Other', child: Text('Other')),
  ];

  static const _urgencyValues = ['low', 'medium', 'high'];

  static const _imageExtensions = ['jpg', 'jpeg', 'png'];

  @override
  void initState() {
    super.initState();

    if (widget.caseItem != null) {
      _fillForm(widget.caseItem!);
    }
  }

  void _fillForm(CaseListItemModel caseItem) {
    titleController.text = caseItem.name;
    descriptionController.text = caseItem.description;

    contactNameController.text = caseItem.contactName;

    contactPhoneController.text = _normalizeEgyptianPhone(
      caseItem.contactPhone,
    );

    estimatedAmountController.text = caseItem.paymentDetails.estimatedAmount > 0
        ? caseItem.paymentDetails.estimatedAmount.toStringAsFixed(0)
        : '';

    raisedAmountController.text = caseItem.paymentDetails.raisedAmount > 0
        ? caseItem.paymentDetails.raisedAmount.toStringAsFixed(0)
        : '';

    additionalNotesController.text = caseItem.note ?? '';

    selectedCategory.value = caseItem.category;

    selectedPaymentType.value = caseItem.paymentDetails.paymentType;

    selectedUrgency = _urgencyValues.indexOf(caseItem.urgency);

    if (selectedUrgency == -1) {
      selectedUrgency = 0;
    }

    final paymentType = caseItem.paymentDetails.paymentType;

    final paymentDescription = caseItem.paymentDetails.description ?? '';

    switch (paymentType) {
      case 'instapay':
        instapayLinkController.text = paymentDescription;
        break;

      case 'wallet':
        walletPhoneController.text = _normalizeEgyptianPhone(
          paymentDescription,
        );
        break;

      case 'bank_account':
        ibanController.text = paymentDescription;
        break;
    }

    for (final att in caseItem.attachments) {
      final extension = att.attachment.name.split('.').last.toLowerCase();

      final existing = _ExistingAttachment(
        url: att.attachment.url,
        name: att.attachment.name,
      );

      if (_imageExtensions.contains(extension)) {
        existingCasePhotos.add(existing);
      } else {
        existingSupportingDocuments.add(existing);
      }
    }

    // Safety check:
    // لو الـ API رجع بيانات قديمة فيها أكتر من الحد المسموح،
    // نعرض أول الملفات فقط داخل الفورم.
    if (existingCasePhotos.length > _maxCasePhotos) {
      existingCasePhotos = existingCasePhotos.take(_maxCasePhotos).toList();
    }

    if (existingSupportingDocuments.length > _maxSupportingDocuments) {
      existingSupportingDocuments = existingSupportingDocuments
          .take(_maxSupportingDocuments)
          .toList();
    }
  }

  int get _currentCasePhotosCount =>
      existingCasePhotos.length + casePhotos.length;

  int get _currentSupportingDocumentsCount =>
      existingSupportingDocuments.length + supportingDocuments.length;

  int get _remainingCasePhotos => _maxCasePhotos - _currentCasePhotosCount;

  int get _remainingSupportingDocuments =>
      _maxSupportingDocuments - _currentSupportingDocumentsCount;

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

  Future<File?> _cropImage(String sourcePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      compressQuality: 85,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'shared.cases.submit.crop_image'.tr(),
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'shared.cases.submit.crop_image'.tr(),
          aspectRatioLockEnabled: false,
        ),
      ],
    );

    if (croppedFile == null) {
      return null;
    }

    return File(croppedFile.path);
  }

  Future<void> _pickCasePhotos() async {
    final remaining = _remainingCasePhotos;

    if (remaining <= 0) {
      _showAttachmentLimitMessage(type: 'photos', max: _maxCasePhotos);
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

    final skippedCount =
        files.where((file) => file.path != null).length - validFiles.length;

    if (skippedCount > 0) {
      _showAttachmentLimitMessage(type: 'photos', max: _maxCasePhotos);
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
          _maxCasePhotos - existingCasePhotos.length - casePhotos.length;

      if (availableSlots <= 0) {
        return;
      }

      casePhotos.addAll(croppedFiles.take(availableSlots));
    });
  }

  Future<void> _pickSupportingDocuments() async {
    final remaining = _remainingSupportingDocuments;

    if (remaining <= 0) {
      _showAttachmentLimitMessage(
        type: 'supporting documents',
        max: _maxSupportingDocuments,
      );
      return;
    }

    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      allowMultiple: true,
    );

    if (files.isEmpty) return;

    final validFiles = files
        .where((file) => file.path != null)
        .take(remaining)
        .toList();

    final skippedCount =
        files.where((file) => file.path != null).length - validFiles.length;

    if (skippedCount > 0) {
      _showAttachmentLimitMessage(
        type: 'supporting documents',
        max: _maxSupportingDocuments,
      );
    }

    if (!mounted || validFiles.isEmpty) {
      return;
    }

    setState(() {
      final availableSlots =
          _maxSupportingDocuments -
          existingSupportingDocuments.length -
          supportingDocuments.length;

      if (availableSlots <= 0) {
        return;
      }

      supportingDocuments.addAll(
        validFiles.take(availableSlots).map((file) => File(file.path!)),
      );
    });
  }

  String _normalizeEgyptianPhone(String phone) {
    final value = phone.trim();

    if (value.startsWith('+20')) {
      return '0${value.substring(3)}';
    }

    if (value.startsWith('20') && value.length == 12) {
      return '0${value.substring(2)}';
    }

    return value;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    contactNameController.dispose();
    contactPhoneController.dispose();
    estimatedAmountController.dispose();
    raisedAmountController.dispose();
    additionalNotesController.dispose();
    instapayLinkController.dispose();
    walletPhoneController.dispose();
    ibanController.dispose();

    selectedCategory.dispose();
    selectedPaymentType.dispose();

    super.dispose();
  }

  String? _optional(String? value, String? Function(String?) validator) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return validator(value);
  }

  String? _paymentDescriptionForType(String? type) {
    switch (type) {
      case 'instapay':
        final value = instapayLinkController.text.trim();

        return value.isEmpty ? null : value;

      case 'wallet':
        final value = walletPhoneController.text.trim();

        return value.isEmpty ? null : value;

      case 'bank_account':
        final value = ibanController.text.trim().toUpperCase().replaceAll(
          ' ',
          '',
        );

        return value.isEmpty ? null : value;

      default:
        return null;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Final safety check.
    if (_currentCasePhotosCount > _maxCasePhotos) {
      _showAttachmentLimitMessage(type: 'photos', max: _maxCasePhotos);

      return;
    }

    if (_currentSupportingDocumentsCount > _maxSupportingDocuments) {
      _showAttachmentLimitMessage(
        type: 'supporting documents',
        max: _maxSupportingDocuments,
      );

      return;
    }

    final param = CreateCaseParam(
      name: titleController.text.trim(),

      description: descriptionController.text.trim(),

      category: selectedCategory.value!,

      urgency: _urgencyValues[selectedUrgency],

      contactName: contactNameController.text.trim(),

      contactPhone: contactPhoneController.text.trim(),

      paymentType: selectedPaymentType.value,

      paymentDescription: _paymentDescriptionForType(selectedPaymentType.value),

      paymentEstimatedAmount: estimatedAmountController.text.trim().isEmpty
          ? null
          : double.tryParse(estimatedAmountController.text.trim()),

      paymentRaisedAmount: raisedAmountController.text.trim().isEmpty
          ? null
          : double.tryParse(raisedAmountController.text.trim()),

      note: additionalNotesController.text.trim(),

      attachments: [...casePhotos, ...supportingDocuments],
    );

    final cubit = context.read<CasesCubit>();

    if (widget.isEdit) {
      cubit.updateCase(id: widget.caseItem!.id, param: param);
    } else {
      cubit.createCase(param, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CasesCubit, CasesState>(
      listener: (context, state) {
        final cubit = context.read<CasesCubit>();

        debugPrint(
          'SUBMIT CASE LISTENER => '
          'cubit=${identityHashCode(cubit)} '
          'state=${state.runtimeType}',
        );

        if (state is CaseCreated) {
          debugPrint(
            'SUBMIT CASE => POP '
            'caseId=${state.caseId}',
          );

          AppNavigator.pop();
        }
      },

      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VerificationBanner(),

            SizedBox(height: AppSize.getHeight(20)),

            CustomFieldText(
              controller: titleController,
              title: 'shared.cases.submit.case_title'.tr(),
              hintText: 'shared.cases.submit.hint_case_title'.tr(),
              isRequired: true,
              validator: AppValidators.required,
            ),

            SizedBox(height: AppSize.getHeight(15)),

            CustomFieldDropdown<String>(
              title: 'shared.cases.submit.category'.tr(),
              hintText: 'shared.cases.submit.hint_category'.tr(),
              selected: selectedCategory,
              isRequired: true,
              validator: (value) => AppValidators.required(value),
              items: categories,
              onChanged: (_) {},
            ),

            SizedBox(height: AppSize.getHeight(15)),

            _UrgencySelector(
              title: 'shared.cases.submit.urgency_level'.tr(),
              selected: selectedUrgency,
              onTap: (index) {
                setState(() {
                  selectedUrgency = index;
                });
              },
              isRequired: true,
            ),

            SizedBox(height: AppSize.getHeight(15)),

            CustomFieldText(
              controller: descriptionController,
              title: 'shared.cases.submit.description'.tr(),
              hintText: 'shared.cases.submit.hint_description'.tr(),
              isRequired: true,
              minLines: 4,
              maxLines: 4,
              validator: AppValidators.required,
            ),

            SizedBox(height: AppSize.getHeight(15)),

            _MultiAttachmentsField(
              title: 'shared.cases.submit.case_photos'.tr(),
              icon: AppIcons.addPhoto,
              isRequired: !widget.isEdit,
              maxFiles: _maxCasePhotos,
              currentFilesCount: _currentCasePhotosCount,
              onAdd: _pickCasePhotos,
              newFiles: casePhotos,
              existingFiles: existingCasePhotos,
              onRemoveNew: (index) {
                setState(() {
                  casePhotos.removeAt(index);
                });
              },
              onRemoveExisting: (index) {
                setState(() {
                  existingCasePhotos.removeAt(index);
                });
              },
            ),

            SizedBox(height: AppSize.getHeight(15)),

            _MultiAttachmentsField(
              title: 'shared.cases.submit.supporting_documents'.tr(),
              icon: AppIcons.uploadFile,
              isRequired: false,
              maxFiles: _maxSupportingDocuments,
              currentFilesCount: _currentSupportingDocumentsCount,
              onAdd: _pickSupportingDocuments,
              newFiles: supportingDocuments,
              existingFiles: existingSupportingDocuments,
              onRemoveNew: (index) {
                setState(() {
                  supportingDocuments.removeAt(index);
                });
              },
              onRemoveExisting: (index) {
                setState(() {
                  existingSupportingDocuments.removeAt(index);
                });
              },
            ),

            SizedBox(height: AppSize.getHeight(20)),

            _ContactInfoSection(
              nameController: contactNameController,
              phoneController: contactPhoneController,
            ),

            SizedBox(height: AppSize.getHeight(15)),

            _PaymentMethodSection(
              selectedPaymentType: selectedPaymentType,
              instapayLinkController: instapayLinkController,
              walletPhoneController: walletPhoneController,
              ibanController: ibanController,
              estimatedAmountController: estimatedAmountController,
              raisedAmountController: raisedAmountController,
              optionalValidator: _optional,
            ),

            SizedBox(height: AppSize.getHeight(15)),

            CustomFieldText(
              controller: additionalNotesController,
              title: 'shared.cases.submit.additional_notes'.tr(),
              hintText: 'shared.cases.submit.hint_additional_notes'.tr(),
              minLines: 4,
              maxLines: 4,
            ),

            SizedBox(height: AppSize.getHeight(15)),

            _WarningNoteBanner(),

            SizedBox(height: AppSize.getHeight(20)),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.pop(context),
                    title: 'shared.cases.submit.cancel_button'.tr(),
                    bgColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: .08),
                    textColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: AppSize.getWidth(12)),
                Expanded(
                  flex: 2,
                  child: BlocBuilder<CasesCubit, CasesState>(
                    builder: (context, state) {
                      return CustomButton(
                        loading: state is Loading,
                        onTap: state is Loading
                            ? null
                            : _submit,
                        title: widget.isEdit
                            ? 'shared.cases.edit.button'.tr()
                            : 'shared.cases.submit.submit_button'
                            .tr(),
                        bgColor: AppColors.primary,
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSize.getHeight(16)),
          ],
        ),
      ),
    );
  }
}

class _MultiAttachmentsField extends StatelessWidget {
  final String title;
  final String icon;
  final bool isRequired;

  final int maxFiles;
  final int currentFilesCount;

  final VoidCallback onAdd;

  final List<File> newFiles;
  final List<_ExistingAttachment> existingFiles;

  final void Function(int index) onRemoveNew;
  final void Function(int index) onRemoveExisting;

  const _MultiAttachmentsField({
    required this.title,
    required this.icon,
    required this.onAdd,
    required this.newFiles,
    required this.existingFiles,
    required this.onRemoveNew,
    required this.onRemoveExisting,
    required this.maxFiles,
    required this.currentFilesCount,
    this.isRequired = false,
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
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(color: secondaryColor).xs,
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: AppSize.font(12),
                  ),
                ),
              TextSpan(
                text: '  ($currentFilesCount/$maxFiles)',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: AppSize.font(11),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppSize.getHeight(8)),

        Wrap(
          spacing: AppSize.getWidth(8),
          runSpacing: AppSize.getHeight(8),
          children: [
            for (int i = 0; i < existingFiles.length; i++)
              _AttachmentChip(
                name: existingFiles[i].name,
                onRemove: () => onRemoveExisting(i),
              ),

            for (int i = 0; i < newFiles.length; i++)
              _AttachmentChip(
                name: newFiles[i].path.split('/').last,
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
                    border: Border.all(color: borderColor, width: 1),
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
                        'shared.cases.submit.add_file'.tr(),
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

class _AttachmentChip extends StatelessWidget {
  final String name;
  final VoidCallback onRemove;

  const _AttachmentChip({required this.name, required this.onRemove});

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
                Icon(
                  Icons.insert_drive_file_outlined,
                  color: secondaryColor,
                  size: AppSize.getSize(22),
                ),
                SizedBox(height: AppSize.getHeight(4)),
                Text(
                  name,
                  maxLines: 1,
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

class _VerificationBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4A90D9).withValues(alpha: .3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: const Color(0xFF4A90D9),
            size: AppSize.getSize(20),
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'shared.cases.submit.verification_process'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4A90D9),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(4)),
                Text(
                  'shared.cases.submit.verification_desc'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(12),
                    color: const Color(0xFF4A90D9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UrgencySelector extends StatelessWidget {
  final String title;
  final int selected;
  final ValueChanged<int> onTap;
  final bool isRequired;

  static const _labels = ['Low', 'Medium', 'High'];

  const _UrgencySelector({
    required this.title,
    required this.selected,
    required this.onTap,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final borderColor = textColor.withValues(alpha: .18);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(color: textColor.withValues(alpha: .65)).xs,
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: AppSize.font(12),
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        SizedBox(height: AppSize.getHeight(6)),
        Row(
          children: List.generate(_labels.length, (i) {
            final isSelected = selected == i;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                    right: i < 2 ? AppSize.getWidth(8) : 0,
                  ),
                  padding: AppSize.padding(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: .08)
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : borderColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _labels[i],
                    style: TextStyle(
                      fontSize: AppSize.font(14),
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : textColor,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ContactInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const _ContactInfoSection({
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final sectionColor = theme.colorScheme.onSurface.withValues(alpha: .06);

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: sectionColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.phone,
                width: AppSize.getSize(18),
                height: AppSize.getSize(18),
                color: textColor,
              ),
              SizedBox(width: AppSize.getWidth(6)),
              Text(
                'shared.cases.submit.contact_information'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(15),
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(14)),
          CustomFieldText(
            controller: nameController,
            title: 'shared.cases.submit.contact_name'.tr(),
            hintText: 'shared.cases.submit.hint_contact_name'.tr(),
            isRequired: true,
            validator: AppValidators.required,
          ),
          SizedBox(height: AppSize.getHeight(12)),
          CustomFieldText(
            controller: phoneController,
            title: 'shared.cases.submit.contact_phone'.tr(),
            hintText: '01xxxxxxxxx',
            isRequired: true,
            validator: AppValidators.egyptianPhone,
            keyboardType: TextInputType.phone,
            prefixText: '+20 ',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodSection extends StatelessWidget {
  final ValueNotifier<String?> selectedPaymentType;

  final TextEditingController instapayLinkController;

  final TextEditingController walletPhoneController;

  final TextEditingController ibanController;

  final TextEditingController estimatedAmountController;

  final TextEditingController raisedAmountController;

  final String? Function(String?, String? Function(String?)) optionalValidator;

  const _PaymentMethodSection({
    required this.selectedPaymentType,
    required this.instapayLinkController,
    required this.walletPhoneController,
    required this.ibanController,
    required this.estimatedAmountController,
    required this.raisedAmountController,
    required this.optionalValidator,
  });

  static const _types = ['instapay', 'wallet', 'bank_account'];

  String _labelFor(String type) {
    switch (type) {
      case 'instapay':
        return 'shared.cases.submit.payment_type_instapay'.tr();

      case 'wallet':
        return 'shared.cases.submit.payment_type_wallet'.tr();

      default:
        return 'shared.cases.submit.payment_type_bank_account'.tr();
    }
  }

  String _iconFor(String type) {
    switch (type) {
      case 'instapay':
        return AppIcons.instapay;

      case 'wallet':
        return AppIcons.wallet;

      default:
        return AppIcons.bank;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .6);
    final sectionColor = textColor.withValues(alpha: .06);
    final borderColor = textColor.withValues(alpha: .18);

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: sectionColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.creditCard,
                width: AppSize.getSize(18),
                height: AppSize.getSize(18),
                color: textColor,
              ),
              SizedBox(width: AppSize.getWidth(6)),
              Expanded(
                child: Text(
                  'shared.cases.submit.banking_information'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(4)),

          Text(
            'shared.cases.submit.banking_desc'.tr(),
            style: TextStyle(fontSize: AppSize.font(12), color: secondaryColor),
          ),

          SizedBox(height: AppSize.getHeight(14)),

          ValueListenableBuilder<String?>(
            valueListenable: selectedPaymentType,
            builder: (context, selected, _) {
              return Row(
                children: List.generate(_types.length, (i) {
                  final type = _types[i];
                  final isSelected = selected == type;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        selectedPaymentType.value = isSelected ? null : type;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(
                          right: i < _types.length - 1
                              ? AppSize.getWidth(8)
                              : 0,
                        ),
                        padding: AppSize.padding(vertical: 10, horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: .08)
                              : theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : borderColor,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIcon(
                              icon: _iconFor(type),
                              width: AppSize.getSize(18),
                              height: AppSize.getSize(18),
                              color: isSelected ? AppColors.primary : textColor,
                            ),
                            SizedBox(height: AppSize.getHeight(4)),
                            Text(
                              _labelFor(type),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppSize.font(12),
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          SizedBox(height: AppSize.getHeight(14)),

          ValueListenableBuilder<String?>(
            valueListenable: selectedPaymentType,
            builder: (context, selected, _) {
              switch (selected) {
                case 'instapay':
                  return CustomFieldText(
                    controller: instapayLinkController,
                    title: 'shared.cases.submit.instapay_link'.tr(),
                    hintText: 'shared.cases.submit.hint_instapay_link'.tr(),
                    isRequired: false,
                    validator: (value) =>
                        optionalValidator(value, AppValidators.instapayLink),
                    keyboardType: TextInputType.url,
                  );

                case 'wallet':
                  return CustomFieldText(
                    controller: walletPhoneController,
                    title: 'shared.cases.submit.wallet_phone'.tr(),
                    hintText: '01xxxxxxxxx',
                    isRequired: false,
                    validator: (value) =>
                        optionalValidator(value, AppValidators.egyptianPhone),
                    keyboardType: TextInputType.phone,
                    prefixText: '+20 ',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                  );

                case 'bank_account':
                  return CustomFieldText(
                    controller: ibanController,
                    title: 'shared.cases.submit.iban'.tr(),
                    hintText: 'EG380019000500000000263180002',
                    isRequired: false,
                    validator: (value) =>
                        optionalValidator(value, AppValidators.egyptianIban),
                    keyboardType: TextInputType.text,
                    inputFormatters: [LengthLimitingTextInputFormatter(29)],
                  );

                default:
                  return const SizedBox.shrink();
              }
            },
          ),

          SizedBox(height: AppSize.getHeight(12)),

          CustomFieldText(
            controller: estimatedAmountController,
            title: 'shared.cases.submit.estimated_amount'.tr(),
            hintText: 'shared.cases.submit.hint_estimated_amount'.tr(),
            isRequired: false,
            validator: (value) =>
                optionalValidator(value, AppValidators.requiredAmount),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
          ),

          SizedBox(height: AppSize.getHeight(12)),

          CustomFieldText(
            controller: raisedAmountController,
            title: 'shared.cases.submit.raised_amount'.tr(),
            hintText: 'shared.cases.submit.hint_raised_amount'.tr(),
            isRequired: false,
            validator: null,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
          ),
        ],
      ),
    );
  }
}

class _WarningNoteBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFB300).withValues(alpha: .4),
          width: 1,
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'shared.cases.submit.note_label'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(13),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF996600),
              ),
            ),
            TextSpan(
              text: ' ${'shared.cases.submit.note_text'.tr()}',
              style: TextStyle(
                fontSize: AppSize.font(13),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF996600),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
