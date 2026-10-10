import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/helper/app_number_formatter.dart';
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

                  _buildNameAndBadge(context, user, profile),

                  SizedBox(height: AppSize.getHeight(10)),

                  _buildDescription(context, profile),

                  SizedBox(height: AppSize.getHeight(16)),

                  _buildOrganizationInfo(context, profile),

                  SizedBox(height: AppSize.getHeight(20)),

                  _buildStatsGrid(context, profile),

                  SizedBox(height: AppSize.getHeight(16)),

                  ContactInfoCard(
                    email: user?.email ?? '',
                    phone: user?.phone?.replaceFirst('+20', '0') ?? '',
                    website: _normalizeUrl(profile?.website),
                    location: [
                      profile?.state,
                      profile?.headquarters,
                    ].where((e) => e != null && e.trim().isNotEmpty).join(', '),
                  ),

                  if (profile?.socialMediaLinks?.isNotEmpty == true) ...[
                    SizedBox(height: AppSize.getHeight(16)),
                    SocialMediaCard(
                      socialMediaLinks: profile!.socialMediaLinks!,
                    ),
                  ],

                  // if (profile?.branches?.isNotEmpty == true) ...[
                  //   SizedBox(height: AppSize.getHeight(16)),
                  //   _buildBranchesCard(context, profile!.branches!),
                  // ],
                  SizedBox(height: AppSize.getHeight(16)),

                  CustomButton(
                    onTap: () {
                      AppNavigator.push(const SettingsScreen());
                    },
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

  /// Ensures the website always has a valid HTTP/HTTPS scheme.
  String _normalizeUrl(String? url) {
    final value = url?.trim() ?? '';

    if (value.isEmpty) {
      return '';
    }

    if (value.startsWith('https://') || value.startsWith('http://')) {
      return value;
    }

    return 'https://$value';
  }

  Widget _buildCoverAndAvatar(BuildContext context, UserModel? user) {
    final theme = Theme.of(context);

    final organizationName = user?.name ?? '';
    final avatar = user?.avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: double.infinity,
            height: 170,
            child: avatar != null && avatar.isNotEmpty
                ? Image.network(
                    avatar,
                    width: double.infinity,
                    height: 170,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: _buildAvatarInitial(organizationName),
                      );
                    },
                  )
                : Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: _buildAvatarInitial(organizationName),
                  ),
          ),
        ),

        Positioned(
          bottom: -30,
          left: 16,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.scaffoldBackgroundColor,
                width: 3,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: avatar != null && avatar.isNotEmpty
                  ? Image.network(
                      avatar,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return _buildAvatarInitial(organizationName);
                      },
                    )
                  : _buildAvatarInitial(organizationName),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarInitial(String organizationName) {
    return Center(
      child: Text(
        organizationName.isNotEmpty ? organizationName[0].toUpperCase() : 'O',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNameAndBadge(
    BuildContext context,
    UserModel? user,
    OrganizationProfileModel? profile,
  ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            user?.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppSize.font(20),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        if (profile?.isVerified == true) ...[
          SizedBox(width: AppSize.getSize(10)),
          CustomIcon(
            icon: AppIcons.verified,
            color: AppColors.primary,
            width: AppSize.getSize(20),
            height: AppSize.getSize(20),
          ),
        ],
      ],
    );
  }

  Widget _buildDescription(
    BuildContext context,
    OrganizationProfileModel? profile,
  ) {
    final theme = Theme.of(context);

    final headquarters = profile?.headquarters?.trim() ?? '';

    return Text(
      headquarters.isNotEmpty
          ? headquarters
          : 'No organization information available',
      style: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: .6),
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    OrganizationProfileModel? profile,
  ) {
    final theme = Theme.of(context);

    final stats = [
      (
        AppIcons.events,
        theme.brightness == Brightness.dark
            ? AppColors.primary.withValues(alpha: .15)
            : const Color(0xFFEAF6F1),
        AppColors.primary,
        (profile?.eventsCreated ?? 0).compact,
        'organization.profile.events_created'.tr(),
      ),
      (
        AppIcons.community,
        theme.brightness == Brightness.dark
            ? Colors.blue.withValues(alpha: .15)
            : const Color(0xFFEAF1FB),
        const Color(0xFF3B82F6),
        (profile?.attendeesCount ?? 0).compact,
        'organization.profile.volunteers_engaged'.tr(),
      ),
      (
        AppIcons.pound,
        theme.brightness == Brightness.dark
            ? Colors.orange.withValues(alpha: .15)
            : const Color(0xFFFDF1E4),
        const Color(0xFFE8A13D),
        'EGP ${(profile?.donationsRaised ?? 0).compact}',
        'organization.profile.donations_raised'.tr(),
      ),
      (
        AppIcons.fileDone,
        theme.brightness == Brightness.dark
            ? AppColors.primary.withValues(alpha: .15)
            : const Color(0xFFEAF6F1),
        AppColors.primary,
        (profile?.casesCompleted ?? 0).compact,
        'organization.profile.cases_completed'.tr(),
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

  // Widget _buildBranchesCard(BuildContext context, List<String> branches) {
  //   final theme = Theme.of(context);
  //   final isDark = theme.brightness == Brightness.dark;
  //
  //   return Container(
  //     width: double.infinity,
  //     padding: AppSize.padding(all: 16),
  //     decoration: BoxDecoration(
  //       color: theme.cardColor,
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(
  //         color: theme.colorScheme.onSurface.withValues(
  //           alpha: isDark ? .12 : .10,
  //         ),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           offset: const Offset(0, 2),
  //           color: Colors.black.withValues(alpha: isDark ? .35 : .15),
  //           blurRadius: 8,
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Branches',
  //           style: TextStyle(
  //             color: theme.colorScheme.onSurface,
  //             fontSize: AppSize.font(16),
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //
  //         SizedBox(height: AppSize.getHeight(12)),
  //
  //         ...branches.asMap().entries.map((entry) {
  //           final index = entry.key;
  //           final branch = entry.value;
  //
  //           return Padding(
  //             padding: EdgeInsets.only(
  //               bottom: index == branches.length - 1
  //                   ? 0
  //                   : AppSize.getHeight(10),
  //             ),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   '${index + 1}.',
  //                   style: TextStyle(
  //                     color: AppColors.primary,
  //                     fontSize: AppSize.font(13),
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //
  //                 SizedBox(width: AppSize.getWidth(8)),
  //
  //                 Expanded(
  //                   child: Text(
  //                     branch,
  //                     style: TextStyle(
  //                       color: theme.colorScheme.onSurface.withValues(
  //                         alpha: .65,
  //                       ),
  //                       fontSize: AppSize.font(13),
  //                       height: 1.4,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildOrganizationInfo(
    BuildContext context,
    OrganizationProfileModel? profile,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bio = profile?.bio?.trim() ?? '';
    final organizationType = profile?.organizationType?.trim() ?? '';
    final registrationNo = profile?.registerationNo?.trim() ?? '';

    if (bio.isEmpty && organizationType.isEmpty && registrationNo.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
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
          Text(
            'Organization Information',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppSize.font(16),
              fontWeight: FontWeight.bold,
            ),
          ),

          if (bio.isNotEmpty) ...[
            SizedBox(height: AppSize.getHeight(12)),

            Text(
              'About',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppSize.font(13),
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: AppSize.getHeight(5)),

            Text(
              bio,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: .65),
                fontSize: AppSize.font(13),
                height: 1.5,
              ),
            ),
          ],

          if (organizationType.isNotEmpty) ...[
            SizedBox(height: AppSize.getHeight(14)),

            _buildInfoRow(
              context,
              icon: AppIcons.organization,
              title: 'Organization Type',
              value: organizationType,
            ),
          ],

          if (registrationNo.isNotEmpty) ...[
            SizedBox(height: AppSize.getHeight(12)),

            _buildInfoRow(
              context,
              icon: AppIcons.idCard,
              title: 'Registration No.',
              value: registrationNo,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .10),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomIcon(
              icon: icon,
              width: AppSize.getSize(18),
              height: AppSize.getSize(18),
              color: AppColors.primary,
            ),
          ),
        ),

        SizedBox(width: AppSize.getWidth(10)),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: .5),
                  fontSize: AppSize.font(11),
                ),
              ),

              SizedBox(height: AppSize.getHeight(2)),

              Text(
                value,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
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
