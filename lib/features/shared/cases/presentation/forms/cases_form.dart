import 'package:sanad_app/core/shared/widgets/custom_field_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/style/app_text_style.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared/widgets/custom_upload_file.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/validator/app_validators.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class CasesForm extends StatefulWidget {
  const CasesForm({super.key});

  @override
  State<CasesForm> createState() => _CasesFormState();
}

class _CasesFormState extends State<CasesForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController estimatedAmountController =
      TextEditingController();
  final TextEditingController additionalNotesController =
      TextEditingController();

  final ValueNotifier<String?> selectedCategory = ValueNotifier(null);
  int selectedUrgency = 0;

  final List<DropdownItem<String>> categories = [
    DropdownItem(value: 'Medical', child: Text('Medical')),
    DropdownItem(value: 'Education', child: Text('Education')),
    DropdownItem(value: 'Food & Shelter', child: Text('Food & Shelter')),
    DropdownItem(value: 'Disaster Relief', child: Text('Disaster Relief')),
    DropdownItem(value: 'Other', child: Text('Other')),
  ];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    contactNameController.dispose();
    contactPhoneController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    estimatedAmountController.dispose();
    additionalNotesController.dispose();
    selectedCategory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Verification banner
        _VerificationBanner(),
        SizedBox(height: AppSize.getHeight(20)),

        // Case Title
        CustomFieldText(
          controller: titleController,
          title: 'shared.cases.submit.case_title'.tr(),
          hintText: 'shared.cases.submit.hint_case_title'.tr(),
          isRequired: true,
          validator: AppValidators.required,
        ),
        SizedBox(height: AppSize.getHeight(15)),

        // Category
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

        // Urgency Level
        _UrgencySelector(
          title: 'shared.cases.submit.urgency_level'.tr(),
          selected: selectedUrgency,
          onTap: (i) => setState(() => selectedUrgency = i),
          isRequired: true,
        ),
        SizedBox(height: AppSize.getHeight(15)),

        // Detailed Description
        CustomFieldText(
          controller: descriptionController,
          title: 'shared.cases.submit.description'.tr(),
          hintText: 'shared.cases.submit.hint_description'.tr(),
          isRequired: true,
          minLines: 6,
          maxLines: 6,
          validator: AppValidators.required,
        ),
        SizedBox(height: AppSize.getHeight(15)),

        // Case Photos
        CustomUploadFile(
          onTap: () {},
          onRemove: () {},
          title: 'shared.cases.submit.case_photos'.tr(),
          hint: 'shared.cases.submit.hint_case_photos'.tr(),
          icon: AppIcons.addPhoto,
          minLines: 6,
          maxLines: 6,
          isRequired: true,
        ),
        SizedBox(height: AppSize.getHeight(15)),

        // Supporting Documents
        CustomUploadFile(
          onTap: () {},
          onRemove: () {},
          title: 'shared.cases.submit.supporting_documents'.tr(),
          hint: 'shared.cases.submit.hint_supporting_documents'.tr(),
          icon: AppIcons.uploadFile,
          minLines: 6,
          maxLines: 6,
          isRequired: true,
        ),
        SizedBox(height: AppSize.getHeight(20)),

        // Contact Information section
        _ContactInfoSection(
          nameController: contactNameController,
          phoneController: contactPhoneController,
        ),
        SizedBox(height: AppSize.getHeight(15)),

        // Banking Information (Optional)
        _BankingInfoSection(
          bankNameController: bankNameController,
          accountNumberController: accountNumberController,
          estimatedAmountController: estimatedAmountController,
        ),
        SizedBox(height: AppSize.getHeight(15)),

        // Additional Notes (Optional)
        CustomFieldText(
          controller: additionalNotesController,
          title: 'shared.cases.submit.additional_notes'.tr(),
          hintText: 'shared.cases.submit.hint_additional_notes'.tr(),
          minLines: 4,
          maxLines: 4,
        ),
        SizedBox(height: AppSize.getHeight(15)),

        // Warning Note Banner
        _WarningNoteBanner(),
        SizedBox(height: AppSize.getHeight(20)),

        // Cancel + Submit buttons
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
              child: CustomButton(
                onTap: () {},
                title: 'shared.cases.submit.submit_button'.tr(),
                bgColor: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.getHeight(16)),
      ],
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
            hintText: '+20 123 456 7890',
            isRequired: true,
            validator: AppValidators.required,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Banking Information Section
// ─────────────────────────────────────────────────────────────────────────────
class _BankingInfoSection extends StatelessWidget {
  final TextEditingController bankNameController;
  final TextEditingController accountNumberController;
  final TextEditingController estimatedAmountController;

  const _BankingInfoSection({
    required this.bankNameController,
    required this.accountNumberController,
    required this.estimatedAmountController,
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
          CustomFieldText(
            controller: bankNameController,
            title: 'shared.cases.submit.bank_name'.tr(),
            hintText: 'shared.cases.submit.hint_bank_name'.tr(),
            validator: null,
          ),
          SizedBox(height: AppSize.getHeight(12)),
          CustomFieldText(
            controller: accountNumberController,
            title: 'shared.cases.submit.account_number'.tr(),
            hintText: 'shared.cases.submit.hint_account_number'.tr(),
            validator: null,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: AppSize.getHeight(12)),
          CustomFieldText(
            controller: estimatedAmountController,
            title: 'shared.cases.submit.estimated_amount'.tr(),
            hintText: 'shared.cases.submit.hint_estimated_amount'.tr(),
            validator: null,
            keyboardType: TextInputType.number,
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
