import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:sanad_app/core/shared/widgets/custom_upload_file.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_text.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared/models/city_model.dart';
import '../../../../../core/shared/models/governorate_model.dart';
import '../../../../../core/shared/widgets/custom_field_dropdown.dart';
import '../../../../../core/shared/widgets/custom_field_multi_dropdown.dart';
import '../../../../../core/validator/app_validators.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/organization_event_details_model.dart';
import '../controllers/organization_events_cubit.dart';

class OrganizationEventFormScreen extends StatefulWidget {
  const OrganizationEventFormScreen({super.key, this.event});

  final OrganizationEventDetailsModel? event;

  bool get isEdit => event != null;

  @override
  State<OrganizationEventFormScreen> createState() =>
      _OrganizationEventFormScreenState();
}

class _OrganizationEventFormScreenState
    extends State<OrganizationEventFormScreen> {
  late final OrganizationEventsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OrganizationEventsCubit.get(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    if (widget.isEdit) {
      await _cubit.fillEventData(widget.event!);
    } else {
      await _cubit.loadLocationData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<OrganizationEventsCubit, OrganizationEventsState>(
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
              widget.isEdit
                  ? 'organization.create_edit_event.appbar_edit_event.appbar'
                        .tr()
                  : 'organization.create_edit_event.appbar_create_event.appbar'
                        .tr(),

              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppSize.font(18),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: AppSize.padding(horizontal: 16, vertical: 24),

              child: Form(
                key: _cubit.formKey,

                child: Column(
                  children: [
                    CustomUploadFile(
                      hint: 'organization.create_edit_event.upload_event_cover'
                          .tr(),
                      hintColor: theme.colorScheme.onSurface.withValues(
                        alpha: .5,
                      ),

                      hintSize: AppSize.font(14),

                      icon: AppIcons.addPhoto,

                      iconColor: theme.colorScheme.onSurface.withValues(
                        alpha: .5,
                      ),

                      iconSize: AppSize.getSize(30),

                      isRequired: !widget.isEdit,

                      height: AppSize.getHeight(150),

                      image: _cubit.eventCover,

                      networkImage: _cubit.displayNetworkCover,

                      validator: (file) {
                        if (!widget.isEdit && file == null) {
                          return 'organization.create_edit_event.cover_required'
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

                      title: 'organization.create_edit_event.event_name'.tr(),

                      hintText: 'organization.create_edit_event.event_name_hint'
                          .tr(),

                      titleSize: AppSize.font(15),

                      titleColor:
                          theme.textTheme.bodyMedium?.color ??
                          AppColors.textPrimary,

                      borderRadius: 20,

                      validator: AppValidators.required,
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    CustomFieldDropdown<String>(
                      title: 'organization.create_edit_event.event_category'
                          .tr(),

                      titleSize: AppSize.font(15),

                      titleColor:
                          theme.textTheme.bodyMedium?.color ??
                          AppColors.textPrimary,

                      borderRadius: 20,

                      hintText: 'organization.create_edit_event.select_category'
                          .tr(),

                      validator: AppValidators.dropdownRequired<String>,

                      selected: _cubit.selectedCategory,

                      items: _cubit.eventCategories.map((category) {
                        return DropdownItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),

                      onChanged: _cubit.selectCategory,
                    ),

                    if (_cubit.isOtherCategory) ...[
                      SizedBox(height: AppSize.getHeight(15)),

                      CustomFieldText(
                        controller: _cubit.otherCategoryController,

                        title: 'organization.create_edit_event.other_category'
                            .tr(),

                        hintText:
                            'organization.create_edit_event.enter_category'
                                .tr(),

                        titleSize: AppSize.font(15),

                        titleColor:
                            theme.textTheme.bodyMedium?.color ??
                            AppColors.textPrimary,

                        borderRadius: 20,

                        validator: (value) {
                          if (_cubit.isOtherCategory) {
                            return AppValidators.required(value);
                          }

                          return null;
                        },
                      ),
                    ],

                    SizedBox(height: AppSize.getHeight(15)),

                    CustomFieldText(
                      controller: _cubit.eventDescriptionController,

                      title: 'organization.create_edit_event.event_description'
                          .tr(),

                      hintText:
                          'organization.create_edit_event.event_description_hint'
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

                      title: 'organization.create_edit_event.date'.tr(),

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

                        final currentDate =
                            widget.event?.date ?? DateTime.now();

                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: currentDate.isBefore(firstDate)
                              ? firstDate
                              : currentDate,
                          firstDate: firstDate,
                          lastDate: lastDate,
                        );

                        if (pickedDate != null) {
                          _cubit.dateController.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(pickedDate);
                        }
                      },
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    CustomFieldText(
                      controller: _cubit.startTimeController,

                      title: 'organization.create_edit_event.start_time'.tr(),

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
                              'organization.create_edit_event.location'.tr(),

                              style: TextStyle(
                                fontSize: AppSize.font(15),
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: AppSize.getHeight(20)),

                            CustomFieldDropdown<GovernorateModel>(
                              title:
                                  'organization.create_edit_event.governorate'
                                      .tr(),
                              titleSize: AppSize.font(15),
                              borderRadius: 20,
                              titleColor:
                                  theme.textTheme.bodyMedium?.color ??
                                  AppColors.textPrimary,
                              hintText:
                                  'organization.create_edit_event.governorate_hint'
                                      .tr(),
                              validator: AppValidators
                                  .dropdownRequired<GovernorateModel>,
                              selected: _cubit.selectedGov,
                              items: _cubit.governorates.map((gov) {
                                return DropdownItem(
                                  value: gov,
                                  child: Text(gov.nameEn),
                                );
                              }).toList(),
                              onChanged: (gov) {
                                if (gov != null) {
                                  _cubit.selectGovernorate(gov);
                                }
                              },
                            ),

                            SizedBox(height: AppSize.getHeight(15)),

                            CustomFieldDropdown<CityModel>(
                              title: 'organization.create_edit_event.city'.tr(),
                              titleSize: AppSize.font(15),
                              borderRadius: 20,
                              titleColor:
                                  theme.textTheme.bodyMedium?.color ??
                                  AppColors.textPrimary,
                              hintText:
                                  'organization.create_edit_event.city_hint'
                                      .tr(),
                              validator:
                                  AppValidators.dropdownRequired<CityModel>,
                              selected: _cubit.selectedCity,
                              items: _cubit.filteredCities.map((city) {
                                return DropdownItem(
                                  value: city,
                                  child: Text(city.nameEn),
                                );
                              }).toList(),
                              onChanged: (city) {
                                if (city != null) {
                                  _cubit.selectCity(city);
                                }
                              },
                            ),

                            SizedBox(height: AppSize.getHeight(15)),

                            CustomFieldText(
                              controller: _cubit.locationLinkController,

                              title:
                                  'organization.create_edit_event.location_link'
                                      .tr(),

                              hintText:
                                  'organization.create_edit_event.location_link_hint'
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
                                  'organization.create_edit_event.location_address'
                                      .tr(),

                              hintText:
                                  'organization.create_edit_event.location_address_hint'
                                      .tr(),

                              titleSize: AppSize.font(15),

                              titleColor:
                                  theme.textTheme.bodyMedium?.color ??
                                  AppColors.textPrimary,

                              borderRadius: 20,

                              validator: AppValidators.required,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    CustomFieldText(
                      controller: _cubit.requiredVolunteersController,

                      title:
                          'organization.create_edit_event.required_volunteers'
                              .tr(),

                      hintText:
                          'organization.create_edit_event.required_volunteers_hint'
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

                        if (error != null) {
                          return error;
                        }

                        if (value != null && value.startsWith('0')) {
                          return 'organization.create_edit_event.number_must_be_positive'
                              .tr();
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    CustomFieldMultiDropdown<String>(
                      title: 'organization.create_edit_event.required_skills'
                          .tr(),

                      titleSize: AppSize.font(15),

                      borderRadius: 20,

                      hintText:
                          'organization.create_edit_event.required_skills_hint'
                              .tr(),

                      selectedItems: _cubit.selectedSkills,

                      items: _cubit.skills.map((skill) {
                        return DropdownItem(value: skill, child: Text(skill));
                      }).toList(),

                      onChanged: (skills) {
                        _cubit.updateSelectedSkills(skills);
                      },
                    ),

                    SizedBox(height: AppSize.getHeight(20)),

                    /// Buttons
                    if (widget.isEdit)
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              loading: state is Loading,

                              bgColor: Colors.transparent,

                              textColor: AppColors.primary,

                              borderColor: AppColors.primary,

                              onTap: () {
                                _cubit.updateOrganizationEvent(
                                  id: widget.event!.id,
                                );
                              },

                              title:
                                  'organization.create_edit_event.save_changes'
                                      .tr(),

                              height: AppSize.getHeight(40),
                            ),
                          ),

                          if (widget.event?.status == 'draft') ...[
                            SizedBox(width: AppSize.getWidth(12)),

                            Expanded(
                              child: CustomButton(
                                loading:
                                    state is Loading &&
                                    _cubit.loadingAction ==
                                        CreateOrganizationEventAction.publish,

                                onTap: () {
                                  _cubit.updateOrganizationEvent(
                                    id: widget.event!.id,
                                    publish: true,
                                  );
                                },

                                title:
                                    'organization.create_edit_event.publish_event'
                                        .tr(),

                                textColor: AppColors.white,

                                height: AppSize.getHeight(40),
                              ),
                            ),
                          ],
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              loading:
                                  state is Loading &&
                                  _cubit.loadingAction ==
                                      CreateOrganizationEventAction.draft,

                              onTap: () {
                                _cubit.createOrganizationEvent(
                                  status: 'draft',

                                  action: CreateOrganizationEventAction.draft,
                                );
                              },

                              title: 'organization.create_edit_event.save_draft'
                                  .tr(),

                              textColor: AppColors.primary,

                              bgColor: Colors.transparent,

                              borderColor: AppColors.primary,

                              height: AppSize.getHeight(40),
                            ),
                          ),

                          SizedBox(width: AppSize.getWidth(12)),

                          Expanded(
                            child: CustomButton(
                              loading:
                                  state is Loading &&
                                  _cubit.loadingAction ==
                                      CreateOrganizationEventAction.publish,

                              onTap: () {
                                _cubit.createOrganizationEvent(
                                  status: 'upcoming',

                                  action: CreateOrganizationEventAction.publish,
                                );
                              },

                              title:
                                  'organization.create_edit_event.publish_event'
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
