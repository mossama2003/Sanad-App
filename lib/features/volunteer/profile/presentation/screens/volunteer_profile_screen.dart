import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/auth/data/models/user_profile_model.dart';
import '../../../../shared/auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../../../../shared/settings/presentations/screens/settings_screen.dart';
import '../../../rewards/presentation/screens/rewards_screen.dart';
import '../cards/badges_card.dart';
import '../../../../../core/shared/widgets/contact_info_card.dart';
import '../cards/past_roles_card.dart';
import '../cards/reliability_score_card.dart';
import '../cards/stats_card.dart';
import '../cards/volunteer_profile_card.dart';
import '../cards/avatar_card.dart';

class VolunteerProfileScreen extends StatelessWidget {
  const VolunteerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UserLoggedOut || state is ErrorState) {
          AppNavigator.remove(const SignInScreen());
        }
      },
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        final user = cubit.user;

        String formatJoinedDate(String? date) {
          if (date == null || date.isEmpty) return '';

          final parsedDate = DateTime.parse(date);

          return 'Joined ${DateFormat('MMMM yyyy').format(parsedDate)}';
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppSize.padding(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  AvatarCard(
                    name: '${user?.name ?? ''} ${user?.lastName ?? ''}',
                    location: user?.profile is VolunteerProfileModel
                        ? [
                                (user!.profile as VolunteerProfileModel).city,
                                (user.profile as VolunteerProfileModel).state,
                                (user.profile as VolunteerProfileModel).country,
                              ]
                              .where((e) => e != null && e.trim().isNotEmpty)
                              .join(', ')
                        : '',
                    createdAt: formatJoinedDate(user?.profile?.created),
                    image: user?.avatar,
                    level: 'volunteer.profile.level'.tr(),
                  ),

                  SizedBox(height: AppSize.getHeight(24)),

                  GestureDetector(
                    onTap: () =>
                        AppNavigator.push(const VolunteerRewardsScreen()),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.50,
                      children: [
                        StatCard(
                          icon: AppIcons.voltage,
                          iconColor: const Color(0xFF7B5EA7),
                          value: '2,450',
                          label: 'volunteer.profile.xp'.tr(),
                        ),
                        StatCard(
                          icon: AppIcons.fire,
                          iconColor: const Color(0xFFFF6B35),
                          value: '7',
                          label: 'volunteer.profile.streak'.tr(),
                        ),
                        StatCard(
                          icon: AppIcons.calendar,
                          iconColor: const Color(0xFF2ECFA0),
                          value: '24',
                          label: 'volunteer.profile.attended'.tr(),
                        ),
                        StatCard(
                          icon: AppIcons.donations,
                          iconColor: const Color(0xFFE05C5C),
                          value: 'EGP 12.5K',
                          label: 'volunteer.profile.donations'.tr(),
                          smallValue: true,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(16)),

                  const BadgesCard(),

                  SizedBox(height: AppSize.getHeight(16)),

                  const ReliabilityScoreCard(),

                  SizedBox(height: AppSize.getHeight(16)),

                  const VolunteerProfileCard(),

                  SizedBox(height: AppSize.getHeight(16)),

                  const PastRolesCard(),

                  SizedBox(height: AppSize.getHeight(16)),

                  ContactInfoCard(
                    email: user?.email ?? '',
                    phone: user?.phone ?? '',
                  ),

                  SizedBox(height: AppSize.getHeight(16)),

                  CustomButton(
                    onTap: () => AppNavigator.push(const SettingsScreen()),
                    title: 'volunteer.profile.settings'.tr(),
                    textSize: AppSize.font(14),
                    iconSize: AppSize.getSize(17),
                    icon: AppIcons.settings,
                    textColor: AppColors.primary,
                    bgColor: Colors.transparent,
                    borderColor: AppColors.primary,
                  ),

                  SizedBox(height: AppSize.getHeight(16)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
