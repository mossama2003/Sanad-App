import 'package:flutter/material.dart';

import '../../../../../../core/network/local/cache/cache_helper.dart';
import '../../../../../../core/style/app_text_style.dart';
import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/style/app_theme.dart';
import '../forms/Volunteer_sign_up_form.dart';

class VolunteerSignUpScreen extends StatefulWidget {
  const VolunteerSignUpScreen({super.key});

  @override
  State<VolunteerSignUpScreen> createState() => _VolunteerSignUpScreenState();
}

class _VolunteerSignUpScreenState extends State<VolunteerSignUpScreen> {
  Future<void> _toggleTheme() async {
    final currentTheme = CacheHelper.get(CacheKeys.theme) ?? CacheKeys.light;

    final isDark = currentTheme == CacheKeys.dark;

    final newTheme = isDark ? CacheKeys.light : CacheKeys.dark;

    await CacheHelper.save(CacheKeys.theme, newTheme);

    AppTheme.setTheme(
      newTheme == CacheKeys.dark ? AppThemeEnum.dark : AppThemeEnum.light,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppSize.padding(all: 30),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,

                  child: InkWell(
                    onTap: _toggleTheme,

                    borderRadius: BorderRadius.circular(30),

                    child: Container(
                      padding: AppSize.padding(horizontal: 12, vertical: 8),

                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,

                        borderRadius: BorderRadius.circular(30),

                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Icon(
                            isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,

                            size: 18,

                            color: textColor,
                          ),

                          SizedBox(width: AppSize.getWidth(6)),

                          Text(
                            isDark ? 'Light' : 'Dark',

                            style: TextStyle(color: textColor).xs,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSize.getHeight(15)),

                VolunteerSignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
