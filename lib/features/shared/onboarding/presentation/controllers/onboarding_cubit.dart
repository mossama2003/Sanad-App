import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/onboarding_model.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  static OnboardingCubit get(BuildContext ctx) => BlocProvider.of(ctx);

  int index = 0;

  void updateIndex(int value) {
    index = value;
    emit(UpdateIndex());
  }

  final controller = PageController();

  List<OnboardingModel> onboarding = [];

  void updateOnboarding(List<OnboardingModel> val) {
    onboarding = val;
    emit(UpdateList());
  }

  void previousPage() {
    if (index == 0) return;
    controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void nextTap() {
    if (index == onboarding.length - 1) return;
    controller.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  @override
  Future<void> close() async {
    controller.dispose();
    return super.close();
  }
}
