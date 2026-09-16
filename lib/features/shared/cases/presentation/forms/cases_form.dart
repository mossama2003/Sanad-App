import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/style/app_text_style.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/shared/widgets/custom_upload_file.dart';
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

class _CasesFormState extends State<CasesForm> {
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

  // Payment fields
  final TextEditingController instapayLinkController = TextEditingController();
  final TextEditingController walletPhoneController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();

  final ValueNotifier<String?> selectedCategory = ValueNotifier(null);
  final ValueNotifier<String?> selectedPaymentType = ValueNotifier(null);

  int selectedUrgency = 0;

  // New files selected by the user
  File? casePhoto;
  File? supportingDocument;

  // Existing files from API
  String? existingCasePhotoUrl;
  String? existingSupportingDocumentUrl;

  String? existingCasePhotoName;
  String? existingSupportingDocumentName;

  final List<DropdownItem<String>> categories = [
    DropdownItem(value: 'Medical', child: Text('Medical')),
    DropdownItem(value: 'Education', child: Text('Education')),
    DropdownItem(value: 'Food & Shelter', child: Text('Food & Shelter')),
    DropdownItem(value: 'Disaster Relief', child: Text('Disaster Relief')),
    DropdownItem(value: 'Other', child: Text('Other')),
  ];

  static const _urgencyValues = ['low', 'medium', 'high'];

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

    estimatedAmountController.text = caseItem.paymentDetails.estimatedAmount
        .toStringAsFixed(0);

    raisedAmountController.text = caseItem.paymentDetails.raisedAmount
        .toStringAsFixed(0);

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

    // Existing attachments from API
    if (caseItem.attachments.isNotEmpty) {
      final attachment = caseItem.attachments.first.attachment;

      existingCasePhotoUrl = attachment.url;
      existingCasePhotoName = attachment.name;
    }

    if (caseItem.attachments.length > 1) {
      final attachment = caseItem.attachments[1].attachment;

      existingSupportingDocumentUrl = attachment.url;
      existingSupportingDocumentName = attachment.name;
    }
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

  Future<void> _pickCasePhoto() async {
    final file = await FilePicker.pickFile(type: FileType.image);

    if (file != null && file.path != null) {
      setState(() {
        casePhoto = File(file.path!);

        existingCasePhotoUrl = null;
        existingCasePhotoName = null;
      });
    }
  }

  Future<void> _pickSupportingDocument() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (file != null && file.path != null) {
      setState(() {
        supportingDocument = File(file.path!);

        existingSupportingDocumentUrl = null;
        existingSupportingDocumentName = null;
      });
    }
  }

  String? _paymentDescriptionForType(String? type) {
    switch (type) {
      case 'instapay':
        return instapayLinkController.text.trim();

      case 'wallet':
        return walletPhoneController.text.trim();

      case 'bank_account':
        return ibanController.text.trim().toUpperCase().replaceAll(' ', '');

      default:
        return null;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
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
      paymentEstimatedAmount: double.tryParse(
        estimatedAmountController.text.trim(),
      ),
      paymentRaisedAmount: double.tryParse(raisedAmountController.text.trim()),
      note: additionalNotesController.text.trim(),

      attachments: [
        if (casePhoto != null) casePhoto!,
        if (supportingDocument != null) supportingDocument!,
      ],
    );

    if (widget.isEdit) {
      CasesCubit.get(context).updateCase(id: widget.caseItem!.id, param: param);
    } else {
      CasesCubit.get(context).createCase(param);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CasesCubit, CasesState>(
      listener: (context, state) {
        if (state is Success) {
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
              validator: (v) => AppValidators.required(v),
              items: categories,
              onChanged: (_) {},
            ),

            SizedBox(height: AppSize.getHeight(15)),

            _UrgencySelector(
              title: 'shared.cases.submit.urgency_level'.tr(),
              selected: selectedUrgency,
              onTap: (i) {
                setState(() {
                  selectedUrgency = i;
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

            // CASE PHOTO
            CustomUploadFile(
              image: casePhoto,
              networkImage: existingCasePhotoUrl,
              onTap: _pickCasePhoto,
              onRemove: () {
                setState(() {
                  casePhoto = null;
                  existingCasePhotoUrl = null;
                  existingCasePhotoName = null;
                });
              },
              title: 'shared.cases.submit.case_photos'.tr(),
              hint:
                  casePhoto?.path.split('/').last ??
                  existingCasePhotoName ??
                  'shared.cases.submit.hint_case_photos'.tr(),
              icon: AppIcons.addPhoto,
              minLines: 4,
              maxLines: 4,
              isRequired: !widget.isEdit,
            ),

            SizedBox(height: AppSize.getHeight(15)),

            // SUPPORTING DOCUMENT
            CustomUploadFile(
              image: supportingDocument,
              networkImage: existingSupportingDocumentUrl,
              onTap: _pickSupportingDocument,
              onRemove: () {
                setState(() {
                  supportingDocument = null;
                  existingSupportingDocumentUrl = null;
                  existingSupportingDocumentName = null;
                });
              },
              title: 'shared.cases.submit.supporting_documents'.tr(),
              hint:
                  supportingDocument?.path.split('/').last ??
                  existingSupportingDocumentName ??
                  'shared.cases.submit.hint_supporting_documents'.tr(),
              icon: AppIcons.uploadFile,
              minLines: 4,
              maxLines: 4,
              isRequired: false,
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
                    bgColor: AppColors.grey.withValues(alpha: 0.15),
                    textColor: const Color(0xFF1A1A2E),
                  ),
                ),

                SizedBox(width: AppSize.getWidth(12)),

                Expanded(
                  flex: 2,
                  child: BlocBuilder<CasesCubit, CasesState>(
                    builder: (context, state) {
                      return CustomButton(
                        loading: state is Loading,
                        onTap: state is Loading ? null : _submit,
                        title: widget.isEdit
                            ? 'shared.cases.edit.button'.tr()
                            : 'shared.cases.submit.submit_button'.tr(),
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

// ─────────────────────────────────────────────────────────────────────────────
// Verification Banner
// ─────────────────────────────────────────────────────────────────────────────
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
          color: const Color(0xFF4A90D9).withValues(alpha: 0.3),
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

// ─────────────────────────────────────────────────────────────────────────────
// Urgency Selector
// ─────────────────────────────────────────────────────────────────────────────
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(color: AppColors.grey700).xs,
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
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.grey300,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _labels[i],
                    style: TextStyle(
                      fontSize: AppSize.font(14),
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFF1A1A2E),
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

// ─────────────────────────────────────────────────────────────────────────────
// Contact Information Section
// ─────────────────────────────────────────────────────────────────────────────
class _ContactInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const _ContactInfoSection({
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: AppSize.getSize(18),
                color: const Color(0xFF1A1A2E),
              ),
              SizedBox(width: AppSize.getWidth(6)),
              Text(
                'shared.cases.submit.contact_information'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(15),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
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

// ─────────────────────────────────────────────────────────────────────────────
// Payment Method Section
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentMethodSection extends StatelessWidget {
  final ValueNotifier<String?> selectedPaymentType;
  final TextEditingController instapayLinkController;
  final TextEditingController walletPhoneController;
  final TextEditingController ibanController;
  final TextEditingController estimatedAmountController;
  final TextEditingController raisedAmountController;

  const _PaymentMethodSection({
    required this.selectedPaymentType,
    required this.instapayLinkController,
    required this.walletPhoneController,
    required this.ibanController,
    required this.estimatedAmountController,
    required this.raisedAmountController,
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
    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.credit_card_outlined,
                size: AppSize.getSize(18),
                color: const Color(0xFF1A1A2E),
              ),
              SizedBox(width: AppSize.getWidth(6)),
              Text(
                'shared.cases.submit.banking_information'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(15),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(4)),
          Text(
            'shared.cases.submit.banking_desc'.tr(),
            style: TextStyle(fontSize: AppSize.font(12), color: AppColors.grey),
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
                      onTap: () => selectedPaymentType.value = type,
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
                              ? AppColors.primary.withValues(alpha: 0.08)
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.grey300,
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
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xFF1A1A2E),
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
                                    : const Color(0xFF1A1A2E),
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
                    isRequired: true,
                    validator: AppValidators.instapayLink,
                    keyboardType: TextInputType.url,
                  );

                case 'wallet':
                  return CustomFieldText(
                    controller: walletPhoneController,
                    title: 'shared.cases.submit.wallet_phone'.tr(),
                    hintText: '01xxxxxxxxx',
                    isRequired: true,
                    validator: AppValidators.egyptianPhone,
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
                    isRequired: true,
                    validator: AppValidators.egyptianIban,
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
            isRequired: true,
            validator: AppValidators.requiredAmount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
          ),
          SizedBox(height: AppSize.getHeight(12)),

          // Raised amount — optional, defaults to 0 server-side if left empty
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

// ─────────────────────────────────────────────────────────────────────────────
// Warning Note Banner
// ─────────────────────────────────────────────────────────────────────────────
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
          color: const Color(0xFFFFB300).withValues(alpha: 0.4),
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
