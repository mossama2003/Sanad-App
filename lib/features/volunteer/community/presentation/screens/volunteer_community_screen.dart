import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared/widgets/custom_search_field.dart';
import '../../../../../core/network/local/cache/cache_helper.dart';
import '../../../home/data/enums/volunteer_home_navbar_enum.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../controllers/volunteer_community_cubit.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../cards/volunteer_community_card.dart';

class VolunteerCommunityScreen extends StatefulWidget {
  const VolunteerCommunityScreen({super.key});

  @override
  State<VolunteerCommunityScreen> createState() =>
      _VolunteerCommunityScreenState();
}

class _VolunteerCommunityScreenState extends State<VolunteerCommunityScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VolunteerCommunityCubit>().getCommunities(
        volunteerId: CacheHelper.get(CacheKeys.profileId),
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<VolunteerCommunityCubit>();

    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final textColor = theme.colorScheme.onSurface;

    final cardColor = theme.cardColor;

    final secondaryColor = textColor.withValues(alpha: .6);

    final borderColor = textColor.withValues(alpha: isDark ? .18 : .12);

    final searchBorderColor = textColor.withValues(alpha: isDark ? .25 : .2);

    final footerColor = textColor.withValues(alpha: isDark ? .55 : .7);

    return BlocBuilder<VolunteerCommunityCubit, VolunteerCommunityState>(
      builder: (context, state) {
        if (state is Loading) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        }

        if (state is Error) {
          return Center(
            child: Text(
              'core.error_title'.tr(),
              style: TextStyle(color: textColor),
            ),
          );
        }

        return RefreshIndicator(
          color: theme.colorScheme.primary,
          backgroundColor: cardColor,

          onRefresh: () async {
            searchController.clear();

            await context.read<VolunteerCommunityCubit>().getCommunities(
              volunteerId: CacheHelper.get(CacheKeys.profileId),
              forceRefresh: true,
            );
          },

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),

            child: Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 15,
                bottom: MediaQuery.of(context).padding.bottom + 30,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      kToolbarHeight,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'volunteer.community.title'.tr(),

                      style: TextStyle(
                        fontSize: AppSize.font(22),
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),

                    SizedBox(height: AppSize.getHeight(3)),

                    Text(
                      'volunteer.community.desc'.tr(),

                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        color: secondaryColor,
                      ),
                    ),

                    SizedBox(height: AppSize.getHeight(20)),

                    CustomSearchField(
                      controller: searchController,

                      hint: 'volunteer.community.search'.tr(),

                      borderColor: searchBorderColor,

                      borderRadius: 20,

                      borderWidth: 1,

                      onChanged: (value) {
                        context.read<VolunteerCommunityCubit>().search(
                          volunteerId: CacheHelper.get(CacheKeys.profileId),
                          query: value,
                        );
                      },
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    if (cubit.communities.isEmpty)
                      Container(
                        width: double.infinity,

                        padding: AppSize.padding(all: 20),

                        decoration: BoxDecoration(
                          color: cardColor,

                          borderRadius: BorderRadius.circular(15),

                          border: Border.all(color: borderColor),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? .35 : .12,
                              ),

                              blurRadius: 8,

                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            Container(
                              height: AppSize.getHeight(40),
                              width: AppSize.getWidth(40),

                              decoration: BoxDecoration(
                                color: textColor.withValues(alpha: .1),
                                shape: BoxShape.circle,
                              ),

                              child: Center(
                                child: CustomIcon(
                                  icon: AppIcons.community,

                                  color: textColor.withValues(alpha: .5),

                                  width: AppSize.getSize(20),

                                  height: AppSize.getSize(20),
                                ),
                              ),
                            ),

                            SizedBox(height: AppSize.getHeight(15)),

                            Text(
                              'volunteer.community.no_communities'.tr(),

                              style: TextStyle(
                                color: textColor,
                                fontSize: AppSize.font(16),
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(height: AppSize.getHeight(10)),

                            Text(
                              'volunteer.community.join_event_to_access_chat'
                                  .tr(),

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: AppSize.font(14),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: AppSize.getHeight(15)),

                            CustomButton(
                              width: AppSize.getWidth(150),

                              height: AppSize.getHeight(40),

                              title: 'volunteer.community.browse_events'.tr(),

                              onTap: () {
                                cubit.updateSelectedNavbarItem(
                                  VolunteerHomeNavbarItem.events,
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: cubit.communities.length,

                        separatorBuilder: (_, _) =>
                            SizedBox(height: AppSize.getHeight(10)),

                        itemBuilder: (_, index) {
                          return VolunteerCommunityCard(
                            event: cubit.communities[index],
                          );
                        },
                      ),

                    SizedBox(height: AppSize.getHeight(20)),

                    Divider(
                      thickness: AppSize.font(1),

                      color: textColor.withValues(alpha: isDark ? .15 : .1),
                    ),

                    SizedBox(height: AppSize.getHeight(10)),

                    Center(
                      child: Text(
                        'volunteer.community.communities_are_automatically_created'
                            .tr(),

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: AppSize.font(13),
                          fontWeight: FontWeight.w400,
                          color: footerColor,
                        ),
                      ),
                    ),

                    Center(
                      child: Text(
                        'volunteer.community.chat_access_remains'.tr(),

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: AppSize.font(13),
                          fontWeight: FontWeight.w400,
                          color: footerColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
