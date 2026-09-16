import 'package:cached_network_image/cached_network_image.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../dialogs/case_comments_bottom_sheet.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/cases_model.dart';
import '../controllers/case_cubit.dart';
import '../dialogs/cases_pop_up.dart';

class CasesCard extends StatelessWidget {
  final CaseListItemModel caseItem;
  final bool isOwner;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CasesCard({
    super.key,
    required this.caseItem,
    this.isOwner = false,
    this.onDelete,
    this.onEdit,
  });

  double get _progressValue {
    final estimated = caseItem.paymentDetails.estimatedAmount;
    final raised = caseItem.paymentDetails.raisedAmount;

    if (estimated <= 0) return 0;

    return (raised / estimated).clamp(0.0, 1.0);
  }

  String get _progressPercent {
    return (_progressValue * 100).toStringAsFixed(0);
  }

  String get _thumbnailUrl => caseItem.attachments.isNotEmpty
      ? caseItem.attachments.first.attachment.url
      : '';

  bool get _hasPayment => caseItem.paymentDetails.estimatedAmount > 0;

  String _formatEgyptianPhone(String phone) {
    final value = phone.trim();

    if (value.startsWith('+20')) {
      return '0${value.substring(3)}';
    }

    if (value.startsWith('20') && value.length == 12) {
      return '0${value.substring(2)}';
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                  child: _thumbnailUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: _thumbnailUrl,
                          width: double.infinity,
                          height: AppSize.getHeight(180),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: AppSize.getHeight(180),
                            color: AppColors.grey300,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            AppImages.casesImage,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          AppImages.casesImage,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  bottom: AppSize.getHeight(10),
                  right: AppSize.getWidth(10),
                  child: Container(
                    padding: AppSize.padding(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      timeago.format(caseItem.created),
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: AppSize.font(11),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                if (caseItem.urgency == 'high')
                  Positioned(
                    top: AppSize.getHeight(10),
                    left: AppSize.getWidth(10),
                    child: Container(
                      padding: AppSize.padding(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.brand200.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          CustomIcon(
                            icon: AppIcons.cases,
                            color: AppColors.red,
                            width: AppSize.getSize(17),
                            height: AppSize.getSize(17),
                          ),
                          SizedBox(width: AppSize.getWidth(5)),
                          Text(
                            'shared.cases.card.urgent'.tr(),
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: AppSize.font(11),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (caseItem.verified)
                  Positioned(
                    top: AppSize.getHeight(10),
                    left: AppSize.getWidth(
                      caseItem.urgency == 'high' ? 101 : 10,
                    ),
                    child: Container(
                      padding: AppSize.padding(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          CustomIcon(
                            icon: AppIcons.check,
                            color: AppColors.green,
                            width: AppSize.getSize(17),
                            height: AppSize.getSize(17),
                          ),
                          SizedBox(width: AppSize.getWidth(5)),
                          Text(
                            'shared.cases.card.verified'.tr(),
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: AppSize.font(11),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: AppSize.padding(all: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caseItem.name,
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Text(
                  caseItem.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    color: AppColors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(15)),
                if (_hasPayment) ...[
                  Container(
                    padding: AppSize.padding(all: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.grey300.withValues(alpha: 0.3),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'shared.cases.card.required'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(13),
                                    color: AppColors.grey600,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: AppSize.getHeight(5)),
                                Text(
                                  'EGP ${caseItem.paymentDetails.estimatedAmount.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: AppSize.font(20),
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'shared.cases.card.raised'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(13),
                                    color: AppColors.grey600,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: AppSize.getHeight(5)),
                                Text(
                                  'EGP ${caseItem.paymentDetails.raisedAmount.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: AppSize.font(20),
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: AppSize.getHeight(10)),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _progressValue,
                            minHeight: 8,
                            backgroundColor: AppColors.grey300,
                            valueColor: AlwaysStoppedAnimation(
                              AppColors.primary,
                            ),
                          ),
                        ),

                        SizedBox(height: AppSize.getHeight(5)),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$_progressPercent%',
                            style: TextStyle(
                              fontSize: AppSize.font(12),
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(10)),
                ],
                SizedBox(height: AppSize.getHeight(10)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomIcon(
                      icon: AppIcons.contact,
                      color: AppColors.grey700,
                      width: AppSize.getSize(20),
                      height: AppSize.getSize(20),
                    ),
                    SizedBox(width: AppSize.getWidth(10)),
                    Text(
                      caseItem.contactName,
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        color: AppColors.grey700,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(10)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomIcon(
                      icon: AppIcons.mobile,
                      color: AppColors.grey700,
                      width: AppSize.getSize(20),
                      height: AppSize.getSize(20),
                    ),
                    SizedBox(width: AppSize.getWidth(10)),
                    Text(
                      _formatEgyptianPhone(caseItem.contactPhone),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        color: AppColors.grey700,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                if (caseItem.paymentDetails.description != null) ...[
                  SizedBox(height: AppSize.getHeight(10)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomIcon(
                        icon: AppIcons.creditCard,
                        color: AppColors.grey700,
                        width: AppSize.getSize(20),
                        height: AppSize.getSize(20),
                      ),
                      SizedBox(width: AppSize.getWidth(10)),
                      Expanded(
                        child: Text(
                          caseItem.paymentDetails.paymentType == 'wallet'
                              ? _formatEgyptianPhone(
                                  caseItem.paymentDetails.description!,
                                )
                              : caseItem.paymentDetails.description!,
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            color: AppColors.grey700,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: AppSize.getHeight(10)),
                Divider(thickness: 0.3, height: 1, color: AppColors.grey300),
                SizedBox(height: AppSize.getHeight(15)),
                Row(
                  children: [
                    SizedBox(width: AppSize.getWidth(10)),

                    // ================= LIKE =================
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        final cubit = CasesCubit.get(context);

                        if (!cubit.isLikingCase(caseItem.id)) {
                          cubit.likeCase(caseItem.id);
                        }
                      },
                      child: Padding(
                        padding: AppSize.padding(vertical: 5, horizontal: 3),
                        child: Row(
                          children: [
                            CasesCubit.get(context).isLikingCase(caseItem.id)
                                ? SizedBox(
                                    width: AppSize.getWidth(18),
                                    height: AppSize.getHeight(18),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : CustomIcon(
                                    icon: AppIcons.donations,
                                    color: caseItem.isLiked
                                        ? AppColors.red
                                        : AppColors.grey600,
                                    width: AppSize.getWidth(18),
                                    height: AppSize.getHeight(18),
                                  ),
                            SizedBox(width: AppSize.getWidth(3)),
                            Text(
                              '${caseItem.likers}',
                              style: TextStyle(
                                fontSize: AppSize.font(15),
                                fontWeight: FontWeight.w300,
                                color: caseItem.isLiked
                                    ? AppColors.red
                                    : AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: AppSize.getWidth(10)),

                    // ================= COMMENTS =================
                    GestureDetector(
                      onTap: () => CaseCommentsBottomSheet.show(
                        context,
                        caseItem.id,
                        CasesCubit.get(context),
                      ),
                      child: Row(
                        children: [
                          CustomIcon(
                            icon: AppIcons.comment,
                            color: AppColors.grey600,
                            width: AppSize.getWidth(18),
                            height: AppSize.getHeight(18),
                          ),
                          SizedBox(width: AppSize.getWidth(3)),
                          Text(
                            '${caseItem.comments}',
                            style: TextStyle(
                              fontSize: AppSize.font(15),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Spacer(),

                    // ================= SHARE =================
                    InkWell(
                      onTap: () {
                        /// TODO
                        // Create share link here
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        padding: AppSize.padding(vertical: 5, horizontal: 10),
                        child: Row(
                          children: [
                            CustomIcon(
                              icon: AppIcons.share,
                              color: AppColors.black,
                              width: AppSize.getWidth(15),
                              height: AppSize.getHeight(15),
                            ),
                            SizedBox(width: AppSize.getWidth(5)),
                            Text(
                              'shared.cases.card.share'.tr(),
                              style: TextStyle(
                                fontSize: AppSize.font(15),
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: AppSize.getWidth(5)),

                    // ================= EDIT & DELETE =================
                    if (isOwner) ...[
                      // EDIT
                      InkWell(
                        onTap: onEdit,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          padding: AppSize.padding(vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              CustomIcon(
                                icon: AppIcons.edit,
                                color: AppColors.primary,
                                width: AppSize.getSize(18),
                                height: AppSize.getSize(18),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: AppSize.getWidth(5)),

                      // DELETE
                      InkWell(
                        onTap: onDelete,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.red.withValues(alpha: 0.12),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          padding: AppSize.padding(vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              CustomIcon(
                                icon: AppIcons.delete,
                                color: AppColors.red,
                                width: AppSize.getSize(18),
                                height: AppSize.getSize(18),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: AppSize.getWidth(10)),
                    ],
                  ],
                ),
                if (!isOwner) ...[
                  SizedBox(height: AppSize.getHeight(20)),
                  CustomButton(
                    title: 'shared.cases.card.button'.tr(),
                    height: AppSize.getHeight(40),
                    onTap: () => AppNavigator.dialog(
                      CasesPopUp(
                        caseItem: caseItem,
                        casesCubit: CasesCubit.get(context),
                      ),
                    ),
                    bgColor: AppColors.laserBlue,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
