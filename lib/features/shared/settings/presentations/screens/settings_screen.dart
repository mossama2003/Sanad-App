import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/app_locals.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/network/local/cache/cache_helper.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_switch.dart';
import '../../../../../core/style/app_theme.dart';
import '../../../../volunteer/edit_profile/presentations/screens/edit_volunteer_profile_screen.dart';
import '../../../auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../cards/settings_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _toggleTheme(bool value) async {
    final newTheme = value ? CacheKeys.dark : CacheKeys.light;
    await CacheHelper.save(CacheKeys.theme, newTheme);
    AppTheme.setTheme(value ? AppThemeEnum.dark : AppThemeEnum.light);
  }

  void _navigateToEditProfile() {
    final user = AppCubit.get(context).user;
    if (user == null) {
      AppToast.error('User not found');
      return;
    }
    switch (user.role) {
      case 'volunteer':
        AppNavigator.push(const EditVolunteerProfileScreen());
        break;

      case 'organization':
        // AppNavigator.push(const OrganizationEditProfileScreen());
        break;

      default:
        AppToast.error('Unknown user role');
    }
  }

  Future<void> _showLanguagePicker() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);

        return SafeArea(
          child: Padding(
            padding: AppSize.padding(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'shared.settings.language'.tr(),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppSize.font(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(20)),

                ...AppLanguage.values.map((language) {
                  final isSelected =
                      context.locale.languageCode == language.code;

                  return Padding(
                    padding: AppSize.padding(bottom: AppSize.getHeight(10)),
                    child: SettingsTile(
                      icon: language == AppLanguage.arabic
                          ? AppIcons.egyptFlag
                          : AppIcons.usaFlag,
                      withColor: true,
                      title: language.displayName,
                      trailing: isSelected
                          ? Icon(
                              Icons.check,
                              color: theme.colorScheme.primary,
                              size: AppSize.getSize(20),
                            )
                          : _arrowIcon(),
                      onTap: () async {
                        if (isSelected) {
                          AppNavigator.pop();
                          return;
                        }

                        await AppLocales.changeLang(context, language);

                        if (!sheetContext.mounted) return;

                        AppNavigator.pop();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _arrowIcon() {
    final theme = Theme.of(context);

    return CustomIcon(
      icon: AppIcons.rightArrow,
      color: theme.colorScheme.onSurface,
      width: AppSize.getSize(20),
      height: AppSize.getSize(20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Text(
          'shared.settings.appbar'.tr(),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppSize.font(18),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSize.padding(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsGroupCard(
                icon: isDark ? AppIcons.darkMood : AppIcons.lightMood,
                title: isDark
                    ? 'shared.settings.dark_mood'.tr()
                    : 'shared.settings.light_mood'.tr(),

                trailing: CustomSwitch(value: isDark, onChanged: _toggleTheme),
              ),
              SizedBox(height: AppSize.getHeight(20)),

              SettingsGroupCard(
                title: 'shared.settings.account'.tr(),
                children: [
                  SettingsTile(
                    icon: AppIcons.profile,
                    title: 'shared.settings.edit_profile'.tr(),
                    trailing: _arrowIcon(),
                    onTap: _navigateToEditProfile,
                  ),
                  SizedBox(height: AppSize.getHeight(10)),
                  SettingsTile(
                    icon: AppIcons.password,
                    title: 'shared.settings.change_password'.tr(),
                    trailing: _arrowIcon(),
                  ),
                ],
              ),
              SizedBox(height: AppSize.getHeight(20)),

              SettingsGroupCard(
                title: 'shared.settings.preferences'.tr(),
                children: [
                  SettingsTile(
                    icon: AppIcons.lock,
                    title: 'shared.settings.privacy_settings'.tr(),
                    trailing: _arrowIcon(),
                  ),
                  SizedBox(height: AppSize.getHeight(10)),
                  SettingsTile(
                    icon: AppIcons.privacyPolicy,
                    title: 'shared.settings.security_settings'.tr(),
                    trailing: _arrowIcon(),
                  ),
                  SizedBox(height: AppSize.getHeight(10)),
                  SettingsTile(
                    icon: AppIcons.earth,
                    title: 'shared.settings.language'.tr(),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocales.currentLang?.displayName ?? 'English',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: .5,
                            ),
                            fontSize: AppSize.font(13),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: AppSize.getWidth(10)),
                        _arrowIcon(),
                      ],
                    ),
                    onTap: _showLanguagePicker,
                  ),
                ],
              ),
              SizedBox(height: AppSize.getHeight(20)),

              SettingsGroupCard(
                title: 'shared.settings.support'.tr(),
                children: [
                  SettingsTile(
                    icon: AppIcons.helpSupport,
                    title: 'shared.settings.help_center'.tr(),
                    trailing: _arrowIcon(),
                  ),
                  SizedBox(height: AppSize.getHeight(10)),
                  SettingsTile(
                    icon: AppIcons.contactSupport,
                    title: 'shared.settings.contact_support'.tr(),
                    trailing: _arrowIcon(),
                  ),
                ],
              ),
              SizedBox(height: AppSize.getHeight(20)),
              CustomButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmDialog(
                      title: 'shared.settings.sign_out'.tr(),
                      message: 'shared.settings.sign_out_desc'.tr(),
                      confirmText: 'shared.settings.sign_out'.tr(),
                      isDestructive: true,
                      onConfirm: () async {
                        await AppCubit.get(context).logOut();

                        if (!context.mounted) return;

                        AppNavigator.remove(const SignInScreen());
                      },
                    ),
                  );
                },
                icon: AppIcons.signOut,
                iconSize: AppSize.getSize(17),
                title: 'shared.settings.sign_out'.tr(),
                textColor: AppColors.red,
                textSize: AppSize.font(14),
                bgColor: Colors.transparent,
                borderColor: AppColors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
