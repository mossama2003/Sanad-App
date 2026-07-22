import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/auth/data/models/user_model.dart';
import '../../../../shared/auth/data/models/user_profile_model.dart';
import '../../../../shared/auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../../../../shared/settings/presentations/screens/settings_screen.dart';
import '../../../../../core/shared/widgets/contact_info_card.dart';
import '../cards/social_media_card.dart';

class OrganizationProfileScreen extends StatelessWidget {
  const OrganizationProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UserLoggedOut || state is ErrorState) {
          AppNavigator.remove(const SignInScreen());
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);

        final cubit = AppCubit.get(context);
        final user = cubit.user;

        final profile = user?.profile as OrganizationProfileModel?;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: IconThemeData(color: theme.iconTheme.color),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppSize.padding(all: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCoverAndAvatar(context, user),

                  SizedBox(height: AppSize.getHeight(44)),

                  _buildNameAndBadge(context, user),

                  SizedBox(height: AppSize.getHeight(10)),

                  _buildDescription(context, profile),

                  SizedBox(height: AppSize.getHeight(20)),

                  _buildStatsGrid(context),

                  SizedBox(height: AppSize.getHeight(16)),

                  ContactInfoCard(
                    email: user?.email ?? '',
                    phone: user?.phone ?? '',

                    website: 'test',
                    location: 'test',

                    // location: [
                    //   user?.profile?.state,
                    //   user?.profile?.headquarters,
                    // ]
                    //     .where((e) => e != null && e!.trim().isNotEmpty)
                    //     .join(', '),
                  ),

                  SizedBox(height: AppSize.getHeight(16)),
                  SocialMediaCard(),

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

  Widget _buildCoverAndAvatar(BuildContext context, UserModel? user) {
    final theme = Theme.of(context);

    final organizationName = user?.name ?? '';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),

          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 170,

                color: theme.colorScheme.surfaceContainerHighest,

                child: Center(
                  child: CustomIcon(
                    icon: AppIcons.uploadFile,
                    color: theme.colorScheme.onSurface.withValues(alpha: .4),
                    width: AppSize.getSize(35),
                    height: AppSize.getSize(35),
                  ),
                ),
              ),

              Positioned(
                top: 12,
                right: 12,

                child: Container(
                  width: AppSize.getSize(36),
                  height: AppSize.getSize(36),

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: theme.cardColor,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: theme.brightness == Brightness.dark ? .4 : .15,
                        ),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),

                  child: Center(
                    child: CustomIcon(
                      icon: AppIcons.edit,
                      color: theme.colorScheme.onSurface,
                      width: AppSize.getSize(18),
                      height: AppSize.getSize(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: -30,
          left: 16,

          child: Container(
            width: 64,
            height: 64,

            decoration: BoxDecoration(
              color: AppColors.primary,

              borderRadius: BorderRadius.circular(16),

              border: Border.all(
                color: theme.scaffoldBackgroundColor,
                width: 3,
              ),
            ),

            alignment: Alignment.center,

            child: Text(
              organizationName.isNotEmpty
                  ? organizationName[0].toUpperCase()
                  : 'O',

              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameAndBadge(BuildContext context, UserModel? user) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                user?.name ?? '',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppSize.font(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            CustomIcon(
              icon: AppIcons.verified,
              color: AppColors.primary,
              width: AppSize.getSize(20),
              height: AppSize.getSize(20),
            ),
          ],
        ),

        SizedBox(height: AppSize.getHeight(8)),

        Container(
          padding: AppSize.padding(horizontal: 12, vertical: 6),

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(20),
          ),

          child: Text(
            'organization.profile.verified_organization'.tr(),

            style: TextStyle(
              color: AppColors.primary,
              fontSize: AppSize.font(12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(
    BuildContext context,
    OrganizationProfileModel? profile,
  ) {
    final theme = Theme.of(context);

    return Text(
      profile?.headquarters?.isNotEmpty == true
          ? profile!.headquarters!
          : 'No organization description available',

      style: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: .6),
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final theme = Theme.of(context);

    final stats = [
      (
        AppIcons.events,
        theme.brightness == Brightness.dark
            ? AppColors.primary.withValues(alpha: .15)
            : const Color(0xFFEAF6F1),
        AppColors.primary,
        '60',
        'Events Created',
      ),

      (
        AppIcons.community,
        theme.brightness == Brightness.dark
            ? Colors.blue.withValues(alpha: .15)
            : const Color(0xFFEAF1FB),
        const Color(0xFF3B82F6),
        '1.2K',
        'Volunteers Engaged',
      ),

      (
        AppIcons.pound,
        theme.brightness == Brightness.dark
            ? Colors.orange.withValues(alpha: .15)
            : const Color(0xFFFDF1E4),
        const Color(0xFFE8A13D),
        'EGP 340K',
        'Donations Raised',
      ),

      (
        AppIcons.fileDone,
        theme.brightness == Brightness.dark
            ? AppColors.primary.withValues(alpha: .15)
            : const Color(0xFFEAF6F1),
        AppColors.primary,
        '34',
        'Cases Completed',
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: stats
          .map((s) => _statCard(context, s.$1, s.$2, s.$3, s.$4, s.$5))
          .toList(),
    );
  }

  Widget _statCard(
    BuildContext context,
    String icon,
    Color bg,
    Color iconColor,
    String value,
    String label,
  ) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: AppSize.padding(all: 16),

      decoration: BoxDecoration(
        color: theme.cardColor,

        borderRadius: BorderRadius.circular(30),

        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(
            alpha: isDark ? .12 : .10,
          ),
        ),

        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),

            color: Colors.black.withValues(alpha: isDark ? .35 : .15),

            blurRadius: 8,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: AppSize.padding(all: 8),

            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),

            child: CustomIcon(
              icon: icon,
              width: AppSize.getSize(18),
              height: AppSize.getSize(18),
              color: iconColor,
            ),
          ),

          SizedBox(height: AppSize.getHeight(10)),

          Text(
            value,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppSize.font(18),
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: AppSize.getHeight(2)),

          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: .5),
              fontSize: AppSize.font(12),
            ),
          ),
        ],
      ),
    );
  }
}
