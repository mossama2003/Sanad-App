import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/dialogs/custom_dialog.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/validator/app_validators.dart';
import '../../data/models/organization_event_details_model.dart';

class OrganizationPublishDialog extends StatefulWidget {
  const OrganizationPublishDialog({
    super.key,
    required this.event,
    required this.onPublish,
    required this.onEditFullEvent,
    this.loading,
  });

  final OrganizationEventDetailsModel event;

  final Function(DateTime date) onPublish;

  final VoidCallback onEditFullEvent;
  final bool? loading;

  @override
  State<OrganizationPublishDialog> createState() =>
      _OrganizationPublishDialogState();
}

class _OrganizationPublishDialogState extends State<OrganizationPublishDialog> {
  late TextEditingController dateController;
  late TextEditingController timeController;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    selectedDate = widget.event.date;

    selectedTime = TimeOfDay.fromDateTime(widget.event.date);

    dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(selectedDate!),
    );

    timeController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      timeController.text = selectedTime!.format(context);

      _initialized = true;
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final now = DateTime.now();

    final firstDate = DateTime(now.year, now.month, now.day + 1);

    final picked = await showDatePicker(
      context: context,

      initialDate: selectedDate!.isBefore(firstDate)
          ? firstDate
          : selectedDate!,

      firstDate: firstDate,

      lastDate: DateTime(now.year + 2, now.month, now.day),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;

        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime!,
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;

        timeController.text = picked.format(context);
      });
    }
  }

  void publish() {
    if (selectedDate == null || selectedTime == null) {
      return;
    }

    final date = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    widget.onPublish(date);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            CustomIcon(
              icon: AppIcons.calendar,
              color: AppColors.primary,
              width: AppSize.getSize(22),
              height: AppSize.getSize(22),
            ),

            SizedBox(width: AppSize.getWidth(5)),

            Text(
              'organization.events.update_the_date_first'.tr(),

              style: TextStyle(
                fontSize: AppSize.font(20),
                fontWeight: FontWeight.w600,
                color: AppColors.grey800,
              ),
            ),
          ],
        ),

        SizedBox(height: AppSize.getHeight(12)),

        Text(
          'organization.events.this_drafts_date_has_already_passed'.tr(),

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: AppSize.font(14),
            color: AppColors.grey600,
          ),
        ),

        SizedBox(height: AppSize.getHeight(20)),

        CustomFieldText(
          controller: dateController,

          iconEnd: AppIcons.calendar,

          title: 'organization.events.new_date'.tr(),

          readOnly: true,

          borderRadius: 20,

          validator: AppValidators.required,

          onTap: pickDate,
        ),

        SizedBox(height: AppSize.getHeight(15)),

        CustomFieldText(
          controller: timeController,

          iconEnd: AppIcons.time,

          title: 'organization.create_edit_event.start_time'.tr(),

          readOnly: true,

          borderRadius: 20,

          validator: AppValidators.required,

          onTap: pickTime,
        ),

        SizedBox(height: AppSize.getHeight(20)),

        CustomButton(
          loading: widget.loading!,
          title: 'organization.events.save_publish'.tr(),

          bgColor: AppColors.primary,

          textColor: AppColors.white,

          height: AppSize.getHeight(40),

          onTap: publish,
        ),

        SizedBox(height: AppSize.getHeight(10)),

        CustomButton(
          title: 'organization.events.edit_full_event'.tr(),

          bgColor: Colors.transparent,

          borderColor: AppColors.primary,

          textColor: AppColors.primary,

          height: AppSize.getHeight(40),

          onTap: () {
            Navigator.pop(context);

            widget.onEditFullEvent();
          },
        ),
      ],
    );
  }
}
