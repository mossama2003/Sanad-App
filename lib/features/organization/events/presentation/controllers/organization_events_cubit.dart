import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/features/organization/events/data/models/get_organization_events_param.dart';
import 'package:sanad_app/features/organization/events/data/models/organization_event_details_model.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/shared/models/city_model.dart';
import '../../../../../core/shared/models/governorate_model.dart';
import '../../data/params/create_organization_event_param.dart';
import '../../data/repos/Organization_events_repo.dart';

part 'organization_events_state.dart';

enum CreateOrganizationEventAction { draft, publish }

class OrganizationEventsCubit extends Cubit<OrganizationEventsState> {
  OrganizationEventsCubit(this.repo) : super(EventsInitial());

  final OrganizationEventsRepo repo;

  static OrganizationEventsCubit get(BuildContext context) =>
      BlocProvider.of<OrganizationEventsCubit>(context);

  // ===================== Controllers =====================
  final formKey = GlobalKey<FormState>();

  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationLinkController = TextEditingController();
  final locationAddressController = TextEditingController();
  final requiredVolunteersController = TextEditingController();

  String? selectedStatus;

  CreateOrganizationEventAction? loadingAction;

  // ===================== Cover Image =====================
  File? eventCover;

  // ===================== Time =====================
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // ===================== Location =====================
  List<GovernorateModel> governorates = [];
  List<CityModel> cities = [];
  List<CityModel> filteredCities = [];

  // ===================== Events =====================
  List<OrganizationEventDetailsModel> events = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoadingMore = false;
  String? nextPage;

  // ===================== Event Categories =====================
  final eventCategories = <String>[
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
  final skills = <String>[
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

  void updateSelectedSkills(List<String> skills) {
    selectedSkills.value = skills;

    emit(UpdateSkillsState());
  }

  final ValueNotifier<GovernorateModel?> selectedGov =
      ValueNotifier<GovernorateModel?>(null);

  final ValueNotifier<CityModel?> selectedCity = ValueNotifier<CityModel?>(
    null,
  );

  // ===================== Governorate =====================
  void selectGovernorate(GovernorateModel gov) {
    selectedGov.value = gov;

    selectedCity.value = null;
    filteredCities = [];

    filteredCities = cities.where((c) => c.governorateId == gov.id).toList();

    emit(UpdateLocationState());
  }

  // ===================== City =====================
  void selectCity(CityModel city) {
    selectedCity.value = city;
    emit(UpdateLocationState());
  }

  // ===================== Load Data =====================
  Future<void> loadLocationData() async {
    emit(LoadingLocationData());

    try {
      final govString = await rootBundle.loadString(
        'assets/data/governorates.json',
      );

      final cityString = await rootBundle.loadString('assets/data/cities.json');

      final govJson = json.decode(govString);
      final cityJson = json.decode(cityString);

      // ================= GOV =================
      final List govList = govJson is List ? govJson : govJson['data'];

      governorates = govList.map((e) => GovernorateModel.fromJson(e)).toList();

      // ================= CITY =================
      final List cityList = cityJson is List ? cityJson : cityJson['data'];

      cities = cityList.map((e) => CityModel.fromJson(e)).toList();

      emit(Success());
    } catch (e) {
      emit(Error());
      AppToast.error(e.toString());
    }
  }

  // ===================== Get Event DateTime =====================
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

  // ===================== Get Event Due DateTime =====================
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

  // ===================== Pick Event Cover =====================
  Future<void> pickEventCover() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedImage != null) {
        eventCover = File(pickedImage.path);
        emit(EventCoverPicked());
      }
    } catch (e) {
      emit(EventCoverError(e.toString()));
    }
  }

  void removeEventCover() {
    eventCover = null;
    emit(EventCoverRemoved());
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
    if (pickedDate != null) {
      dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      emit(EventDatePicked());
    }
  }

  // ===================== Pick Start Time =====================
  Future<void> pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      startTime = picked;
      startTimeController.text = picked.format(context);
      if (endTime != null) {
        final startMinutes = startTime!.hour * 60 + startTime!.minute;
        final endMinutes = endTime!.hour * 60 + endTime!.minute;
        if (endMinutes <= startMinutes) {
          endTime = null;
          endTimeController.clear();
        }
      }

      emit(StartTimePicked());
    }
  }

  // ===================== Pick End Time =====================
  Future<void> pickEndTime(BuildContext context) async {
    if (startTime == null) {
      emit(
        EventTimeError(
          'organization.create_event.please_select_start_time'.tr(),
        ),
      );
      return;
    }
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime!,
    );
    if (picked != null) {
      final startMinutes = startTime!.hour * 60 + startTime!.minute;
      final endMinutes = picked.hour * 60 + picked.minute;
      if (endMinutes <= startMinutes) {
        emit(
          EventTimeError(
            'organization.create_event.please_select_end_time'.tr(),
          ),
        );
        return;
      }

      endTime = picked;

      endTimeController.text = picked.format(context);

      emit(EndTimePicked());
    }
  }

  // ===================== Create Events =====================
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

    emit(Loading(action));

    final api = await repo.createOrganizationEvent(
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

    api.fold(
      (l) {
        emit(Error());
        AppToast.error(l.errMessage);
      },

      (r) {
        emit(Success());
        AppToast.success(
          'organization.create_event.event_created_successfully'.tr(),
        );
        AppNavigator.pop();
      },
    );
  }

  // ===================== Get Organization Events =====================
  Future<void> getOrganizationEvents({
    bool refresh = false,
    String? status,
  }) async {
    if (refresh) {
      currentPage = 1;
      events.clear();

      selectedStatus = status;
    }

    emit(LoadingEvents());

    final api = await repo.getOrganizationEvents(
      GetOrganizationEventsParam(
        page: currentPage,
        size: 10,
        status: selectedStatus == null ? null : [selectedStatus!],
      ),
    );

    api.fold(
      (l) {
        emit(Error());
        AppToast.error(l.errMessage);
      },

      (r) {
        if (refresh) {
          events = r.results;
        } else {
          events.addAll(r.results);
        }

        nextPage = r.next;

        emit(EventsLoaded());
      },
    );
  }

  // ===================== Load More Organization Events =====================
  Future<void> loadMoreOrganizationEvents() async {
    if (isLoadingMore || nextPage == null) return;

    isLoadingMore = true;

    final api = await repo.getOrganizationEvents(
      GetOrganizationEventsParam(
        page: currentPage + 1,
        size: 10,
        status: selectedStatus == null ? null : [selectedStatus!],
      ),
    );

    api.fold(
      (l) {
        AppToast.error(l.errMessage);
      },
      (r) {
        currentPage++;
        events.addAll(r.results);
        nextPage = r.next;
        emit(EventsLoaded());
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
    return super.close();
  }
}
