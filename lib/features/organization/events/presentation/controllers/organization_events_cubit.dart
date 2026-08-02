import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sanad_app/features/organization/events/data/models/organization_event_details_model.dart';
import 'package:sanad_app/features/organization/events/data/params/get_organization_events_param.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../../home/presentation/controllers/organization_home_cubit.dart';
import '../../../../../core/shared/models/governorate_model.dart';
import '../../data/params/create_organization_event_param.dart';
import '../../data/params/organization_event_update_param.dart';
import '../../../../../core/shared/models/city_model.dart';
import '../../../../../core/storage/hive/hive_boxes.dart';
import '../../data/repos/organization_events_repo.dart';
import '../../../../../core/helper/app_toast.dart';

part 'organization_events_state.dart';

enum CreateOrganizationEventAction { draft, publish }

enum OrganizationEventFormMode { create, edit }

class OrganizationEventsCubit extends Cubit<OrganizationEventsState> {
  OrganizationEventsCubit(this.repo, {this.editingEvent, this.homeCubit})
    : super(EventsInitial()) {
    if (editingEvent != null) {
      formMode = OrganizationEventFormMode.edit;
    }
  }

  final OrganizationEventsRepo repo;

  final OrganizationHomeCubit? homeCubit;

  static OrganizationEventsCubit get(BuildContext context) =>
      BlocProvider.of<OrganizationEventsCubit>(context);

  static const String _eventsLastUpdatedKey = 'events_last_updated';

  // ===================== Form =====================

  final formKey = GlobalKey<FormState>();

  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final otherCategoryController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationLinkController = TextEditingController();
  final locationAddressController = TextEditingController();
  final requiredVolunteersController = TextEditingController();

  // ===================== Search =====================

  final TextEditingController searchController = TextEditingController();

  Timer? debounce;

  String? search;

  void onSearchChanged(String value) {
    debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () {
      getOrganizationEvents(
        refresh: true,
        statuses: selectedStatuses,
        searchText: value,
      );
    });
  }

  // ===================== Edit Mode =====================

  OrganizationEventDetailsModel? editingEvent;

  OrganizationEventFormMode formMode = OrganizationEventFormMode.create;

  bool get isEditMode => formMode == OrganizationEventFormMode.edit;

  CreateOrganizationEventAction? loadingAction;

  // ===================== Event =====================

  File? eventCover;

  bool removeOldCover = false;

  List<String>? selectedStatuses;

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
    'Other',
  ];

  final selectedCategory = ValueNotifier<String?>(null);

  bool get isOtherCategory => selectedCategory.value == 'Other';

  void selectCategory(String? value) {
    selectedCategory.value = value;

    if (value != 'Other') {
      otherCategoryController.clear();
    }

    emit(Success());
  }

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

    emit(Success());
  }

  void selectCity(CityModel city) {
    selectedCity.value = city;
  }

  // ===================== Load Location Data =====================
  Future<void> loadLocationData() async {
    // Already loaded
    if (governorates.isNotEmpty && cities.isNotEmpty) {
      return;
    }

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

  // ===================== Fill Edit Data =====================

  Future<void> fillEventData(OrganizationEventDetailsModel event) async {
    editingEvent = event;

    formMode = OrganizationEventFormMode.edit;

    eventCover = null;
    removeOldCover = false;

    eventNameController.text = event.name;

    eventDescriptionController.text = event.description;

    if (eventCategories.contains(event.category)) {
      selectedCategory.value = event.category;
      otherCategoryController.clear();
    } else {
      selectedCategory.value = 'Other';
      otherCategoryController.text = event.category;
    }

    dateController.text = DateFormat('dd/MM/yyyy').format(event.date);

    startTime = TimeOfDay(hour: event.date.hour, minute: event.date.minute);

    startTimeController.text = startTime!.format(
      AppNavigator.key.currentContext!,
    );

    locationLinkController.text = event.location?['url'] ?? '';

    locationAddressController.text = event.location?['description'] ?? '';

    requiredVolunteersController.text = event.spots.toString();

    selectedSkills.value = List<String>.from(event.skills);

    // ===================== Load Location Data =====================

    if (governorates.isEmpty || cities.isEmpty) {
      await loadLocationData();
    }

    final govName = event.location?['state'];

    final cityName = event.location?['city'];

    final gov = governorates.firstWhere(
      (e) => e.nameEn == govName,
      orElse: () => governorates.first,
    );

    selectedGov.value = gov;

    filteredCities = cities.where((e) => e.governorateId == gov.id).toList();

    final city = filteredCities.firstWhere(
      (e) => e.nameEn == cityName,
      orElse: () => filteredCities.first,
    );

    selectedCity.value = city;

    emit(Success());
  }

  // ===================== Reset Create Form =====================
  void resetForm() {
    eventCover = null;
    removeOldCover = false;

    eventNameController.clear();
    eventDescriptionController.clear();
    otherCategoryController.clear();
    dateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    locationLinkController.clear();
    locationAddressController.clear();
    requiredVolunteersController.clear();

    selectedCategory.value = null;
    selectedSkills.value = [];
    selectedGov.value = null;
    selectedCity.value = null;

    startTime = null;
    endTime = null;

    editingEvent = null;
    formMode = OrganizationEventFormMode.create;
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
      removeOldCover = false;
      emit(Success());
    } catch (e) {
      emit(Error());
    }
  }

  void removeEventCover() {
    eventCover = null;
    removeOldCover = true;
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

    if (picked == null || !context.mounted) return;

    startTime = picked;
    startTimeController.text = picked.format(context);

    if (endTime == null) return;

    final startMinutes = (picked.hour * 60) + picked.minute;
    final endMinutes = (endTime!.hour * 60) + endTime!.minute;

    if (endMinutes <= startMinutes) {
      endTime = null;
      endTimeController.clear();
    }
  }

  // ===================== Create Event =====================
  Future<void> createOrganizationEvent({
    required String status,
    required CreateOrganizationEventAction action,
  }) async {
    if (!formKey.currentState!.validate()) return;

    if (eventCover == null) {
      AppToast.error(
        'organization.create_edit_event.pleasee_select_event_cover'.tr(),
      );
      return;
    }

    loadingAction = action;

    emit(Loading());

    final result = await repo.createOrganizationEvent(
      CreateOrganizationEventParam(
        name: eventNameController.text.trim(),
        description: eventDescriptionController.text.trim(),
        category: selectedCategory.value == 'Other'
            ? otherCategoryController.text.trim()
            : selectedCategory.value ?? '',
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
      (createdEvent) async {
        loadingAction = null;

        final newEvent = OrganizationEventDetailsModel(
          id: createdEvent.id,

          name: createdEvent.name,

          description: createdEvent.description,

          category: createdEvent.category,

          date: createdEvent.date,

          status: createdEvent.status,

          skills: createdEvent.skills,

          spots: createdEvent.spots,

          cover: createdEvent.cover,

          location: {
            'url': createdEvent.locationUrl,
            'description': createdEvent.locationDescription,
            'city': createdEvent.locationCity,
            'state': createdEvent.locationState,
          },

          joiners: 0,

          attendees: 0,

          joined: false,

          avgRating: 0.0,

          unreadChatMessages: 0,

          qr: createdEvent.qr,

          due: createdEvent.due,

          created: createdEvent.created,

          modified: createdEvent.modified,
        );

        // ===================== Hive وقتها بس بعد نجاح الـ API =====================

        events.insert(0, newEvent);

        await saveEventsToCache();

        if (homeCubit != null) {
          await homeCubit!.insertHomeEvent(newEvent);
        }

        // ===================== مسح الفورم دلوقتي بس بعد نجاح الإنشاء الفعلي =====================

        resetForm();

        emit(Success());

        AppToast.success(
          'organization.create_edit_event.event_created_successfully'.tr(),
        );

        AppNavigator.pop();
      },
    );
  }

  // ===================== Update Event =====================

  Future<void> updateOrganizationEvent({
    required int id,
    bool publish = false,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    loadingAction = publish
        ? CreateOrganizationEventAction.publish
        : CreateOrganizationEventAction.draft;

    emit(Loading());

    final result = await repo.updateOrganizationEvent(
      OrganizationEventUpdateParam(
        id: id,

        name: eventNameController.text.trim(),

        description: eventDescriptionController.text.trim(),

        category: selectedCategory.value == 'Other'
            ? otherCategoryController.text.trim()
            : selectedCategory.value,

        locationUrl: locationLinkController.text.trim(),

        locationCity: selectedCity.value?.nameEn,

        locationState: selectedGov.value?.nameEn,

        locationDescription: locationAddressController.text.trim(),

        date: getEventDateTime(),

        spots: int.tryParse(requiredVolunteersController.text),

        skills: selectedSkills.value,

        cover: eventCover,

        status: publish ? "upcoming" : null,
      ),
    );

    result.fold(
      (failure) {
        loadingAction = null;

        emit(Error());

        AppToast.error(failure.errMessage);
      },
      (_) async {
        loadingAction = null;

        final baseEvent =
            events.firstWhereOrNull((e) => e.id == id) ?? editingEvent;

        if (baseEvent != null) {
          final updatedEvent = baseEvent.copyWith(
            status: publish ? "upcoming" : baseEvent.status,
            name: eventNameController.text.trim(),
            description: eventDescriptionController.text.trim(),
            category: selectedCategory.value == 'Other'
                ? otherCategoryController.text.trim()
                : selectedCategory.value,
            date: getEventDateTime(),
            spots:
                int.tryParse(requiredVolunteersController.text) ??
                baseEvent.spots,
            skills: selectedSkills.value,
            location: {
              'url': locationLinkController.text.trim(),
              'description': locationAddressController.text.trim(),
              'city': selectedCity.value?.nameEn,
              'state': selectedGov.value?.nameEn,
            },
            cover: eventCover != null ? eventCover!.path : baseEvent.cover,
          );

          // تحديث الليست المحلي بتاع شاشة الـ Events (لو الـ event موجود فيها أصلاً)
          final index = events.indexWhere((e) => e.id == id);

          if (index != -1) {
            events[index] = updatedEvent;

            await saveEventsToCache();
          }

          // تحديث الهوم دايمًا، سواء الـ event كان موجود في الليست المحلي أو لأ
          if (homeCubit != null) {
            await homeCubit!.updateHomeEvent(updatedEvent);
          }
        }

        emit(Success());

        AppToast.success(
          'organization.create_edit_event.event_updated_successfully'.tr(),
        );

        AppNavigator.pop();
      },
    );
  }

  // ===================== Publish Event =====================
  Future<void> publishOrganizationEvent({
    required int id,
    required DateTime date,
  }) async {
    final result = await repo.updateOrganizationEvent(
      OrganizationEventUpdateParam(id: id, date: date, status: "upcoming"),
    );

    result.fold(
      (failure) {
        AppToast.error(failure.errMessage);
      },
      (_) async {
        final index = events.indexWhere((e) => e.id == id);

        if (index != -1) {
          events[index] = events[index].copyWith(
            date: date,
            status: "upcoming",
          );

          await saveEventsToCache();

          if (homeCubit != null) {
            await homeCubit!.updateHomeEvent(events[index]);
          }
        }

        emit(Success());

        AppToast.success(
          'organization.events.event_published_successfully'.tr(),
        );
      },
    );
  }

  // ===================== Hive Cache =====================

  Future<void> saveEventsToCache() async {
    final box = HiveBoxes.organizationEventsBox;

    await box.clear();

    await box.addAll(events);

    await HiveBoxes.cacheInfoBox.put(_eventsLastUpdatedKey, DateTime.now());
  }

  bool loadEventsFromCache() {
    final box = HiveBoxes.organizationEventsBox;

    if (box.isEmpty) return false;

    events
      ..clear()
      ..addAll(box.values);

    emit(Success());

    return true;
  }

  // ===================== Get Organization Events =====================
  Future<void> getOrganizationEvents({
    bool refresh = false,
    List<String>? statuses,
    String? searchText,
  }) async {
    if (refresh) {
      currentPage = 1;
      selectedStatuses = statuses;
      search = searchText;
    }

    // ================= Cache First =================

    if (!refresh && events.isEmpty) {
      loadEventsFromCache();
    }

    // ================= API Background Refresh =================

    final result = await repo.getOrganizationEvents(
      GetOrganizationEventsParam(
        page: currentPage,
        size: 10,
        status: selectedStatuses,
        search: search?.trim().isEmpty ?? true ? null : search,
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
        events
          ..clear()
          ..addAll(data.results);

        nextPage = data.next;

        await saveEventsToCache();

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

        await saveEventsToCache();

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
        status: selectedStatuses,
        search: search,
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

        await saveEventsToCache();

        emit(Success());
      },
    );

    isLoadingMore = false;
  }

  @override
  Future<void> close() {
    eventNameController.dispose();

    eventDescriptionController.dispose();

    otherCategoryController.dispose();

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

    debounce?.cancel();

    return super.close();
  }
}
