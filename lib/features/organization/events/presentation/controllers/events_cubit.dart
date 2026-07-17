import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../data/params/create_event_param.dart';
import '../../data/repos/events_repo.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  EventsCubit(this.repo) : super(EventsInitial());

  final EventsRepo repo;

  static EventsCubit get(BuildContext context) =>
      BlocProvider.of<EventsCubit>(context);

  // Controllers
  final formKey = GlobalKey<FormState>();

  final eventNameController = TextEditingController();
  final eventCategoryController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationLinkController = TextEditingController();
  final locationAddressController = TextEditingController();
  final governorateController = TextEditingController();
  final cityController = TextEditingController();
  final requiredVolunteersController = TextEditingController();
  final requiredSkillsController = TextEditingController();

  // Image
  File? eventCover;

  // Time
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // Create Event
  Future<void> createEvent({required String status}) async {
    if (!formKey.currentState!.validate()) return;

    if (eventCover == null) {
      AppToast.error(
        'organization.create_event.pleasee_select_event_cover'.tr(),
      );
      return;
    }

    emit(Loading());

    final api = await repo.createEvent(
      CreateEventParam(
        name: eventNameController.text.trim(),
        description: eventDescriptionController.text.trim(),
        category: eventCategoryController.text.trim(),
        locationUrl: locationLinkController.text.trim(),
        locationCity: cityController.text.trim(),
        locationState: governorateController.text.trim(),
        locationDescription: locationAddressController.text.trim(),
        date: getEventDateTime(),
        status: status,
        skills: requiredSkillsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
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

  // Get Event DateTime
  DateTime getEventDateTime() {
    final date = DateFormat('dd / MM / yyyy').parse(dateController.text);
    return DateTime(
      date.year,
      date.month,
      date.day,
      startTime?.hour ?? 0,
      startTime?.minute ?? 0,
    );
  }

  // Get Event Due DateTime
  DateTime getEventDueDateTime() {
    final date = DateFormat('dd / MM / yyyy').parse(dateController.text);
    return DateTime(
      date.year,
      date.month,
      date.day,
      endTime?.hour ?? 0,
      endTime?.minute ?? 0,
    );
  }

  // Pick Event Cover
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

  // Pick Date
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
      dateController.text = DateFormat('dd / MM / yyyy').format(pickedDate);
      emit(EventDatePicked());
    }
  }

  // Pick Start Time
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

  // Pick End Time
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

  @override
  Future<void> close() {
    eventNameController.dispose();
    eventCategoryController.dispose();
    eventDescriptionController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    locationLinkController.dispose();
    locationAddressController.dispose();
    governorateController.dispose();
    cityController.dispose();
    requiredVolunteersController.dispose();
    requiredSkillsController.dispose();
    return super.close();
  }
}
