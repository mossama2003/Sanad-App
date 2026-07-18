import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/features/organization/events/data/params/get_organization_events_param.dart';
import 'package:sanad_app/features/organization/events/data/models/organization_event_details_model.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/shared/models/city_model.dart';
import '../../../../../core/shared/models/governorate_model.dart';
import '../../../../../core/storage/hive/hive_boxes.dart';
import '../../data/params/create_organization_event_param.dart';
import '../../data/repos/organization_events_repo.dart';

part 'organization_events_state.dart';

enum CreateOrganizationEventAction { draft, publish }

class OrganizationEventsCubit extends Cubit<OrganizationEventsState> {
  OrganizationEventsCubit(this.repo) : super(EventsInitial());

  final OrganizationEventsRepo repo;

  static OrganizationEventsCubit get(BuildContext context) =>
      BlocProvider.of<OrganizationEventsCubit>(context);

  static const String _eventsLastUpdatedKey = 'events_last_updated';

  // ===================== Form =====================

  final formKey = GlobalKey<FormState>();

  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationLinkController = TextEditingController();
  final locationAddressController = TextEditingController();
  final requiredVolunteersController = TextEditingController();

  CreateOrganizationEventAction? loadingAction;

  // ===================== Event =====================

  File? eventCover;

  String? selectedStatus;

  // ===================== Time =====================

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // ===================== Location =====================

  List<GovernorateModel> governorates = [];

  List<CityModel> cities = [];

  List<CityModel> filteredCities = [];

  final selectedGov = ValueNotifier<GovernorateModel?>(null);

  final selectedCity = ValueNotifier<CityModel?>(null);

  // ===================== Events =====================

  final List<OrganizationEventDetailsModel> events = [];

  int currentPage = 1;

  String? nextPage;

  bool isLoadingMore = false;

  // ===================== Hive Refresh Events =====================l
  bool shouldRefreshEvents() {
    final lastUpdated = HiveBoxes.cacheInfoBox.get(_eventsLastUpdatedKey);

    if (lastUpdated == null) {
      return true;
    }

    final difference = DateTime.now().difference(lastUpdated);

    return difference.inMinutes > 10;
  }

  // ===================== Categories =====================

  final List<String> eventCategories = [
    'Education',
    'Healthcare',
    'Environment',
    'Community Service',
    'Food Distribution',
    'Fundraising',
    'Blood Donation',
    'Elderly Care',
    'Children Support',
    'Animal Welfare',
    'Sports',
    'Arts & Culture',
    'Technology',
    'Career Development',
    'Emergency Relief',
  ];

  final selectedCategory = ValueNotifier<String?>(null);

  // ===================== Skills =====================

  final List<String> skills = [
    'Communication',
    'Leadership',
    'Teamwork',
    'Problem Solving',
    'First Aid',
    'Teaching',
    'Public Speaking',
    'Photography',
    'Videography',
    'Graphic Design',
    'Social Media',
    'Marketing',
    'Fundraising',
    'Event Planning',
    'Customer Service',
    'Data Entry',
    'Translation',
    'Driving',
    'Cooking',
    'Cleaning',
  ];

  final selectedSkills = ValueNotifier<List<String>>([]);

  // ===================== Skills Actions =====================

  void updateSelectedSkills(List<String> value) {
    selectedSkills.value = value;
  }

  // ===================== Location Actions =====================

  void selectGovernorate(GovernorateModel governorate) {
    selectedGov.value = governorate;

    selectedCity.value = null;

    filteredCities = cities
        .where((city) => city.governorateId == governorate.id)
        .toList();
  }

  void selectCity(CityModel city) {
    selectedCity.value = city;
  }

  // ===================== Load Location Data =====================
  Future<void> loadLocationData() async {
    emit(Loading());

    try {
      final governoratesJson = await rootBundle.loadString(
        'assets/data/governorates.json',
      );

      final citiesJson = await rootBundle.loadString('assets/data/cities.json');

      final governoratesData = json.decode(governoratesJson);

      final citiesData = json.decode(citiesJson);

      final List governoratesList = governoratesData is List
          ? governoratesData
          : governoratesData['data'];

      final List citiesList = citiesData is List
          ? citiesData
          : citiesData['data'];

      governorates = governoratesList
          .map((e) => GovernorateModel.fromJson(e))
          .toList();

      cities = citiesList.map((e) => CityModel.fromJson(e)).toList();

      emit(Success());
    } catch (e) {
      emit(Error());

      AppToast.error(e.toString());
    }
  }

  // ===================== Event Date Time =====================

  DateTime getEventDateTime() {
    final date = DateFormat('dd/MM/yyyy').parse(dateController.text);

    return DateTime(
      date.year,
      date.month,
      date.day,
      startTime?.hour ?? 0,
      startTime?.minute ?? 0,
    );
  }

  // ===================== Event Due Time =====================

  DateTime getEventDueDateTime() {
    final date = DateFormat('dd/MM/yyyy').parse(dateController.text);

    return DateTime(
      date.year,
      date.month,
      date.day,
      endTime?.hour ?? 0,
      endTime?.minute ?? 0,
    );
  }

  // ===================== Pick Cover =====================

  Future<void> pickEventCover() async {
    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      eventCover = File(image.path);
    } catch (e) {
      emit(Error());
    }
  }

  void removeEventCover() {
    eventCover = null;
    emit(Success());
  }

  // ===================== Pick Date =====================

  Future<void> pickEventDate(BuildContext context) async {
    final now = DateTime.now();

    final firstDate = DateTime(now.year, now.month, now.day + 1);

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

    if (pickedDate == null) return;

    dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);

    emit(Success());
  }

  // ===================== Pick Start Time =====================

  Future<void> pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    startTime = picked;
    startTimeController.text = picked.format(context);

    if (endTime != null) {
      final startMinutes = picked.hour * 60 + picked.minute;

      final endMinutes = endTime!.hour * 60 + endTime!.minute;

      if (endMinutes <= startMinutes) {
        endTime = null;
        endTimeController.clear();
      }
    }
  }

  // ===================== Pick End Time =====================

  Future<void> pickEndTime(BuildContext context) async {
    if (startTime == null) {
      emit(Error());

      return;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: startTime!,
    );

    if (picked == null) return;

    final startMinutes = startTime!.hour * 60 + startTime!.minute;

    final endMinutes = picked.hour * 60 + picked.minute;

    if (endMinutes <= startMinutes) {
      emit(Error());

      return;
    }

    endTime = picked;

    endTimeController.text = picked.format(context);
  }

  // ===================== Create Event =====================
  Future<void> createOrganizationEvent({
    required String status,
    required CreateOrganizationEventAction action,
  }) async {
    if (!formKey.currentState!.validate()) return;

    if (eventCover == null) {
      AppToast.error(
        'organization.create_event.pleasee_select_event_cover'.tr(),
      );
      return;
    }

    loadingAction = action;

    emit(Loading());

    final result = await repo.createOrganizationEvent(
      CreateOrganizationEventParam(
        name: eventNameController.text.trim(),
        description: eventDescriptionController.text.trim(),
        category: selectedCategory.value ?? '',
        locationUrl: locationLinkController.text.trim(),
        locationCity: selectedCity.value?.nameEn ?? '',
        locationState: selectedGov.value?.nameEn ?? '',
        locationDescription: locationAddressController.text.trim(),
        date: getEventDateTime(),
        status: status,
        skills: selectedSkills.value,
        spots: int.tryParse(requiredVolunteersController.text.trim()) ?? 0,
        cover: eventCover,
      ),
    );

    result.fold(
      (failure) {
        loadingAction = null;

        emit(Error());

        AppToast.error(failure.errMessage);
      },
      (_) {
        loadingAction = null;

        emit(Success());

        AppToast.success(
          'organization.create_event.event_created_successfully'.tr(),
        );

        AppNavigator.pop();
      },
    );
  }

  // ===================== Hive Cache =====================

  Future<void> _saveEventsToCache() async {
    final box = HiveBoxes.organizationEventsBox;

    await box.clear();

    await box.addAll(events);
  }

  void loadEventsFromCache() {
    final box = HiveBoxes.organizationEventsBox;

    if (box.isEmpty) return;

    events
      ..clear()
      ..addAll(box.values);

    emit(Success());
  }

  // ===================== Get Organization Events =====================
  Future<void> getOrganizationEvents({
    bool refresh = false,
    String? status,
  }) async {
    if (refresh) {
      currentPage = 1;
      selectedStatus = status;
    }

    // Load Cache First
    if (!refresh && events.isEmpty) {
      loadEventsFromCache();

      if (!shouldRefreshEvents() && events.isNotEmpty) {
        return;
      }
    }

    final result = await repo.getOrganizationEvents(
      GetOrganizationEventsParam(
        page: currentPage,
        size: 10,
        status: selectedStatus == null ? null : [selectedStatus!],
      ),
    );

    result.fold(
      (failure) {
        if (events.isEmpty) {
          emit(Error());
        }

        AppToast.error(failure.errMessage);
      },

      (data) async {
        if (refresh) {
          events
            ..clear()
            ..addAll(data.results);
        } else {
          events
            ..clear()
            ..addAll(data.results);
        }

        nextPage = data.next;

        await _saveEventsToCache();

        await HiveBoxes.cacheInfoBox.put(_eventsLastUpdatedKey, DateTime.now());

        emit(Success());
      },
    );
  }

  // ===================== Delete Organization Event =====================

  Future<bool> deleteOrganizationEvent({required int id}) async {
    final result = await repo.deleteOrganizationEvent(id);

    return result.fold(
      (failure) {
        emit(Error());

        AppToast.error(failure.errMessage);

        return false;
      },
      (_) async {
        events.removeWhere((event) => event.id == id);

        final box = HiveBoxes.organizationEventsBox;

        await box.clear();

        await box.addAll(events);

        emit(Success());

        AppToast.success('organization.events.event_deleted_successfully'.tr());

        return true;
      },
    );
  }

  // ===================== Load More =====================

  Future<void> loadMoreOrganizationEvents() async {
    if (isLoadingMore || nextPage == null) {
      return;
    }

    isLoadingMore = true;

    final result = await repo.getOrganizationEvents(
      GetOrganizationEventsParam(
        page: currentPage + 1,
        size: 10,
        status: selectedStatus == null ? null : [selectedStatus!],
      ),
    );

    result.fold(
      (failure) {
        AppToast.error(failure.errMessage);
      },

      (response) async {
        currentPage++;

        events.addAll(response.results);

        nextPage = response.next;

        await _saveEventsToCache();

        emit(Success());
      },
    );

    isLoadingMore = false;
  }

  @override
  Future<void> close() {
    eventNameController.dispose();

    eventDescriptionController.dispose();

    dateController.dispose();

    startTimeController.dispose();

    endTimeController.dispose();

    locationLinkController.dispose();

    locationAddressController.dispose();

    requiredVolunteersController.dispose();

    selectedCategory.dispose();

    selectedSkills.dispose();

    selectedGov.dispose();

    selectedCity.dispose();

    return super.close();
  }
}
