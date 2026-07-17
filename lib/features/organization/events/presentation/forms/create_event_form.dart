import 'package:flutter/services.dart';
import 'package:sanad_app/core/shared/widgets/custom_upload_file.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_text.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/validator/app_validators.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/repos/events_repo.dart';
import '../controllers/events_cubit.dart';

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  State<CreateEventForm> createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  late EventsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = EventsCubit(EventsRepoImpel());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<EventsCubit, EventsState>(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleSpacing: 0,
            title: Text(
              'organization.create_event.appbar'.tr(),
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppSize.font(18),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: AppSize.padding(horizontal: 16, vertical: 24),
              child: Form(
                key: _cubit.formKey,
                child: Column(
                  children: [
                    CustomUploadFile(
                      hint: 'organization.create_event.upload_event_cover'.tr(),
                      hintColor: theme.colorScheme.onSurface.withValues(
                        alpha: .5,
                      ),
                      hintSize: AppSize.font(14),
                      icon: AppIcons.addPhoto,
                      iconColor: theme.colorScheme.onSurface.withValues(
                        alpha: .5,
                      ),
                      iconSize: AppSize.getSize(30),
                      isRequired: true,
                      height: AppSize.getHeight(150),
                      image: _cubit.eventCover,
                      validator: (file) {
                        if (file == null) {
                          return 'organization.create_event.cover_required'
                              .tr();
                        }
                        return null;
                      },
                      onTap: () {
                        _cubit.pickEventCover();
                      },
                      onRemove: () {
                        _cubit.removeEventCover();
                      },
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    CustomFieldText(
                      controller: _cubit.eventNameController,
                      title: 'organization.create_event.event_name'.tr(),
                      hintText: 'organization.create_event.event_name_hint'
                          .tr(),
                      titleSize: AppSize.font(15),
                      titleColor:
                          theme.textTheme.bodyMedium?.color ??
                          AppColors.textPrimary,
                      borderRadius: 20,
                      validator: AppValidators.required,
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    /// TODO Dropdown
                    CustomFieldText(
                      controller: _cubit.eventCategoryController,
                      title: 'organization.create_event.event_category'.tr(),
                      hintText: 'organization.create_event.select_category'
                          .tr(),
                      titleSize: AppSize.font(15),
                      titleColor:
                          theme.textTheme.bodyMedium?.color ??
                          AppColors.textPrimary,
                      borderRadius: 20,
                      validator: AppValidators.required,
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    CustomFieldText(
                      controller: _cubit.eventDescriptionController,
                      title: 'organization.create_event.event_description'.tr(),
                      hintText:
                          'organization.create_event.event_description_hint'
                              .tr(),
                      titleSize: AppSize.font(15),
                      titleColor:
                          theme.textTheme.bodyMedium?.color ??
                          AppColors.textPrimary,
                      borderRadius: 20,
                      minLines: 5,
                      validator: AppValidators.required,
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    CustomFieldText(
                      controller: _cubit.dateController,
                      iconEnd: AppIcons.calendar,
                      title: 'organization.create_event.date'.tr(),
                      titleSize: AppSize.font(15),
                      titleColor:
                          theme.textTheme.bodyMedium?.color ??
                          AppColors.textPrimary,
                      borderRadius: 20,
                      hintText: 'DD / MM / YYYY',
                      readOnly: true,
                      validator: AppValidators.required,
                      onTap: () async {
                        final now = DateTime.now();
                        final firstDate = DateTime(
                          now.year,
                          now.month,
                          now.day + 1,
                        );
                        final lastDate = DateTime(
                          firstDate.year,
                          firstDate.month + 2,
                          firstDate.day,
                        );
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: firstDate,
                          firstDate: firstDate,
                          lastDate: lastDate,
                        );
                        if (pickedDate != null) {
                          _cubit.dateController.text = DateFormat(
                            'dd/mm/yyyy',
                          ).format(pickedDate);
                        }
                      },
                    ),

                    SizedBox(height: AppSize.getHeight(15)),
                    CustomFieldText(
                      controller: _cubit.startTimeController,
                      title: 'organization.create_event.start_time'.tr(),
                      titleSize: AppSize.font(15),
                      titleColor:
                          theme.textTheme.bodyMedium?.color ??
                          AppColors.textPrimary,
                      iconEnd: AppIcons.time,
                      hintText: '00:00 AM',
                      readOnly: true,
                      validator: AppValidators.required,
                      borderRadius: 20,
                      onTap: () {
                        _cubit.pickStartTime(context);
                      },
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: AppSize.padding(all: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'organization.create_event.location'.tr(),
                              style: TextStyle(
                                fontSize: AppSize.font(15),
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: AppSize.getHeight(20)),

                            CustomFieldText(
                              controller: _cubit.locationLinkController,
                              title: 'organization.create_event.location_link'
                                  .tr(),
                              hintText:
                                  'organization.create_event.location_link_hint'
                                      .tr(),
                              titleSize: AppSize.font(15),
                              titleColor:
                                  theme.textTheme.bodyMedium?.color ??
                                  AppColors.textPrimary,
                              borderRadius: 20,
                              validator: AppValidators.googleMapsUrl,
                            ),

                            SizedBox(height: AppSize.getHeight(15)),

                            CustomFieldText(
                              controller: _cubit.locationAddressController,
                              title:
                                  'organization.create_event.location_address'
                                      .tr(),
                              hintText:
                                  'organization.create_event.location_address_hint'
                                      .tr(),
                              titleSize: AppSize.font(15),
                              titleColor:
                                  theme.textTheme.bodyMedium?.color ??
                                  AppColors.textPrimary,

                              borderRadius: 20,
                              validator: AppValidators.required,
                            ),

                            SizedBox(height: AppSize.getHeight(15)),

                            Row(
                              children: [
                                /// TODO Dropdown
                                Expanded(
                                  child: CustomFieldText(
                                    controller: _cubit.governorateController,
                                    title:
                                        'organization.create_event.governorate'
                                            .tr(),
                                    titleSize: AppSize.font(15),
                                    titleColor:
                                        theme.textTheme.bodyMedium?.color ??
                                        AppColors.textPrimary,
                                    hintText:
                                        'organization.create_event.governorate_hint'
                                            .tr(),
                                    validator: AppValidators.required,
                                    borderRadius: 20,
                                    onTap: () {},
                                  ),
                                ),

                                SizedBox(width: AppSize.getWidth(12)),

                                Expanded(
                                  child: CustomFieldText(
                                    controller: _cubit.cityController,
                                    title: 'organization.create_event.city'
                                        .tr(),
                                    titleSize: AppSize.font(15),
                                    titleColor:
                                        theme.textTheme.bodyMedium?.color ??
                                        AppColors.textPrimary,
                                    hintText:
                                        'organization.create_event.city_hint'
                                            .tr(),
                                    validator: AppValidators.required,
                                    borderRadius: 20,
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    CustomFieldText(
                      controller: _cubit.requiredVolunteersController,
                      title: 'organization.create_event.required_volunteers'
                          .tr(),
                      hintText:
                          'organization.create_event.required_volunteers_hint'
                              .tr(),
                      titleSize: AppSize.font(15),
                      titleColor:
                          theme.textTheme.bodyMedium?.color ??
                          AppColors.textPrimary,
                      borderRadius: 20,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        final error = AppValidators.onlyNumbers(value);
                        if (error != null) return error;

                        if (value != null && value.startsWith('0')) {
                          return 'organization.create_event.number_must_be_positive'
                              .tr();
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    /// TODO Dropdown
                    CustomFieldText(
                      controller: _cubit.requiredSkillsController,
                      title: 'organization.create_event.required_skills'.tr(),
                      hintText: 'organization.create_event.required_skills_hint'
                          .tr(),
                      titleSize: AppSize.font(15),
                      titleColor:
                          theme.textTheme.bodyMedium?.color ??
                          AppColors.textPrimary,
                      borderRadius: 20,
                      validator: AppValidators.required,
                    ),

                    SizedBox(height: AppSize.getHeight(20)),

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onTap: () {
                              _cubit.createEvent(status: "draft");
                            },
                            title: 'organization.create_event.save_draft'.tr(),
                            textColor: AppColors.primary,
                            bgColor: Colors.transparent,
                            borderColor: AppColors.primary,
                            height: AppSize.getHeight(40),
                          ),
                        ),

                        SizedBox(width: AppSize.getWidth(12)),

                        Expanded(
                          child: CustomButton(
                            onTap: () {
                              _cubit.createEvent(status: "upcoming");
                            },
                            title: 'organization.create_event.publish_event'
                                .tr(),
                            textColor: AppColors.white,
                            height: AppSize.getHeight(40),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
