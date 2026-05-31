import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/shared/widgets/custom_upload_file.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/validator/app_validators.dart';

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

  String? selectedCategory;
  int selectedUrgency = 0;
  bool acceptTerms = false;

  final List<String> categories = [
    'Medical',
    'Education',
    'Food & Shelter',
    'Disaster Relief',
    'Other',
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
          validator: AppValidators.required,
        ),
        SizedBox(height: AppSize.getHeight(15)),

        // Category
        _FieldLabel(
          label: 'shared.cases.submit.category'.tr(),
          isRequired: true,
        ),
        SizedBox(height: AppSize.getHeight(8)),
        _CategoryDropdown(
          value: selectedCategory,
          items: categories,
          hint: 'shared.cases.submit.hint_category'.tr(),
          onChanged: (v) => setState(() => selectedCategory = v),
        ),
        SizedBox(height: AppSize.getHeight(15)),

        // Urgency Level
        _FieldLabel(
          label: 'shared.cases.submit.urgency_level'.tr(),
          isRequired: true,
        ),
        SizedBox(height: AppSize.getHeight(8)),
        _UrgencySelector(
          selected: selectedUrgency,
          onTap: (i) => setState(() => selectedUrgency = i),
        ),
        SizedBox(height: AppSize.getHeight(15)),

        // Detailed Description
        _FieldLabel(
          label: 'shared.cases.submit.description'.tr(),
          isRequired: true,
        ),
        SizedBox(height: AppSize.getHeight(8)),
        _DescriptionField(controller: descriptionController),
        SizedBox(height: AppSize.getHeight(15)),

        // Case Photos
        CustomUploadFile(
          onTap: () {},
          onRemove: () {},
          title: 'shared.cases.submit.case_photos'.tr(),
          hint: 'shared.cases.submit.hint_case_photos'.tr(),
          icon: AppIcons.addPhoto,
        ),
        SizedBox(height: AppSize.getHeight(15)),

        // Supporting Documents
        CustomUploadFile(
          onTap: () {},
          onRemove: () {},
          title: 'shared.cases.submit.supporting_documents'.tr(),
          hint: 'shared.cases.submit.hint_supporting_documents'.tr(),
          icon: AppIcons.uploadFile,
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
        _FieldLabel(label: 'shared.cases.submit.additional_notes'.tr()),
        SizedBox(height: AppSize.getHeight(8)),
        _DescriptionField(
          controller: additionalNotesController,
          hintText: 'shared.cases.submit.hint_additional_notes'.tr(),
          minLines: 4,
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
// Field Label
// ─────────────────────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const _FieldLabel({required this.label, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: AppSize.font(14),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A2E),
        ),
        children: isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: AppSize.font(14),
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Dropdown
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;

  const _CategoryDropdown({
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSize.padding(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(fontSize: AppSize.font(13), color: AppColors.grey),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
          style: TextStyle(
            fontSize: AppSize.font(13),
            color: const Color(0xFF1A1A2E),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Urgency Selector
// ─────────────────────────────────────────────────────────────────────────────
class _UrgencySelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;

  static const _labels = ['Low', 'Medium', 'High'];

  const _UrgencySelector({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_labels.length, (i) {
        final isSelected = selected == i;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: i < 2 ? AppSize.getWidth(8) : 0),
              padding: AppSize.padding(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.grey.withValues(alpha: 0.3),
                  width: isSelected ? 1.5 : 0.8,
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Description Field
// ─────────────────────────────────────────────────────────────────────────────
class _DescriptionField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final int minLines;

  const _DescriptionField({
    required this.controller,
    this.hintText,
    this.minLines = 6,
  });

  @override
  State<_DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<_DescriptionField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.grey.withValues(alpha: 0.3),
              width: 0.8,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            maxLines: widget.minLines,
            style: TextStyle(
              fontSize: AppSize.font(13),
              color: const Color(0xFF1A1A2E),
            ),
            decoration: InputDecoration(
              hintText:
                  widget.hintText ??
                  'shared.cases.submit.hint_description'.tr(),
              hintStyle: TextStyle(
                fontSize: AppSize.font(13),
                color: AppColors.grey,
              ),
              border: InputBorder.none,
              contentPadding: AppSize.padding(all: 14),
            ),
          ),
        ),
        SizedBox(height: AppSize.getHeight(4)),
        Text(
          '${widget.controller.text.length} ${'shared.cases.submit.characters'.tr()}',
          style: TextStyle(fontSize: AppSize.font(11), color: AppColors.grey),
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
          // Section header
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

          // Contact Person Name
          CustomFieldText(
            controller: nameController,
            title: 'shared.cases.submit.contact_name'.tr(),
            hintText: 'shared.cases.submit.hint_contact_name'.tr(),
            validator: AppValidators.required,
          ),
          SizedBox(height: AppSize.getHeight(12)),

          // Contact Phone Number
          CustomFieldText(
            controller: phoneController,
            title: 'shared.cases.submit.contact_phone'.tr(),
            hintText: '+20 123 456 7890',
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
          // Section header
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

          // Bank Name
          CustomFieldText(
            controller: bankNameController,
            title: 'shared.cases.submit.bank_name'.tr(),
            hintText: 'shared.cases.submit.hint_bank_name'.tr(),
            validator: null,
          ),
          SizedBox(height: AppSize.getHeight(12)),

          // Account Number
          CustomFieldText(
            controller: accountNumberController,
            title: 'shared.cases.submit.account_number'.tr(),
            hintText: 'shared.cases.submit.hint_account_number'.tr(),
            validator: null,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: AppSize.getHeight(12)),

          // Estimated Amount
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
