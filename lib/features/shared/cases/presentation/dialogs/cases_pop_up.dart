import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/cases_model.dart';
import '../controllers/case_cubit.dart';
import 'case_comments_bottom_sheet.dart';

class CasesPopUp extends StatelessWidget {
  final CaseListItemModel caseItem;
  final CasesCubit casesCubit;

  const CasesPopUp({
    super.key,
    required this.caseItem,
    required this.casesCubit,
  });

  Future<void> _callPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppToast.error('shared.cases.pop_up.cant_call'.tr());
    }
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppToast.error('shared.cases.pop_up.cant_open_link'.tr());
    }
  }

  void _copyToClipboard(String value) {
    Clipboard.setData(ClipboardData(text: value));
    AppToast.success('shared.cases.pop_up.copied'.tr());
  }

  String _formatEgyptianPhone(String phone) {
    final value = phone.trim();

    // +201012345678 -> 01012345678
    if (value.startsWith('+20')) {
      return '0${value.substring(3)}';
    }

    // 201012345678 -> 01012345678
    if (value.startsWith('20') && value.length == 12) {
      return '0${value.substring(2)}';
    }

    return value;
  }

  bool get _isValidLink {
    final value = caseItem.paymentDetails.description;

    if (value == null) return false;

    final uri = Uri.tryParse(value.trim());

    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String get _paymentLabel {
    switch (caseItem.paymentDetails.paymentType) {
      case 'instapay':
        return 'shared.cases.pop_up.instapay_link'.tr();

      case 'wallet':
        return 'shared.cases.pop_up.wallet_number'.tr();

      case 'bank_account':
        return 'shared.cases.pop_up.bank_account'.tr();

      default:
        return 'shared.cases.pop_up.payment_details'.tr();
    }
  }

  Widget _paymentValueWidget() {
    final rawValue = caseItem.paymentDetails.description!;
    final type = caseItem.paymentDetails.paymentType;

    // Wallet numbers are displayed without the country code.
    final value = type == 'wallet' ? _formatEgyptianPhone(rawValue) : rawValue;

    VoidCallback? onTapAction;
    Color textColor = AppColors.black;
    bool underline = false;

    // InstaPay link
    if (type == 'instapay' && _isValidLink) {
      onTapAction = () => _openLink(rawValue);
      textColor = AppColors.laserBlue;
      underline = true;
    }

    // Wallet:
    // No onTap action intentionally.
    // The user can only copy the number.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTapAction,
            onLongPress: () => _copyToClipboard(value),
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppSize.font(14),
                color: textColor,
                fontWeight: FontWeight.w400,
                decoration: underline
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: textColor,
              ),
            ),
          ),
        ),

        SizedBox(width: AppSize.getWidth(8)),

        GestureDetector(
          onTap: () => _copyToClipboard(value),
          child: Icon(
            Icons.copy_outlined,
            size: AppSize.getSize(16),
            color: AppColors.grey700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF5F5F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: AppSize.padding(all: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                caseItem.name,
                style: TextStyle(
                  fontSize: AppSize.font(20),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              SizedBox(height: AppSize.getHeight(10)),

              if (caseItem.description.isNotEmpty) ...[
                Text(
                  caseItem.description,
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    color: AppColors.grey700,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(15)),
              ],

              Container(
                width: double.infinity,
                padding: AppSize.padding(all: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.grey50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact Person
                    Text(
                      'shared.cases.pop_up.contact_person'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(12),
                        color: AppColors.grey700,
                      ),
                    ),

                    SizedBox(height: AppSize.getHeight(5)),

                    Text(
                      caseItem.contactName,
                      style: TextStyle(
                        fontSize: AppSize.font(14),
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: AppSize.getHeight(10)),

                    // Phone
                    Text(
                      'shared.cases.pop_up.phone'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(12),
                        color: AppColors.grey700,
                      ),
                    ),

                    SizedBox(height: AppSize.getHeight(5)),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _callPhone(caseItem.contactPhone),
                            onLongPress: () =>
                                _copyToClipboard(caseItem.contactPhone),
                            child: Text(
                              _formatEgyptianPhone(caseItem.contactPhone),
                              style: TextStyle(
                                fontSize: AppSize.font(15),
                                color: AppColors.laserBlue,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.laserBlue,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: AppSize.getWidth(8)),

                        GestureDetector(
                          onTap: () => _copyToClipboard(caseItem.contactPhone),
                          child: CustomIcon(
                            icon: AppIcons.copy,
                            width: AppSize.getSize(16),
                            height: AppSize.getSize(16),
                            color: AppColors.grey700,
                          ),
                        ),
                      ],
                    ),

                    if (caseItem.paymentDetails.description != null) ...[
                      SizedBox(height: AppSize.getHeight(10)),

                      Text(
                        _paymentLabel,
                        style: TextStyle(
                          fontSize: AppSize.font(12),
                          color: AppColors.grey700,
                        ),
                      ),

                      SizedBox(height: AppSize.getHeight(5)),

                      _paymentValueWidget(),
                    ],
                  ],
                ),
              ),

              SizedBox(height: AppSize.getHeight(15)),

              // Required / Raised
              Container(
                width: double.infinity,
                padding: AppSize.padding(all: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.grey50,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'shared.cases.card.required'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(12),
                              color: AppColors.grey700,
                            ),
                          ),

                          SizedBox(height: AppSize.getHeight(5)),

                          Text(
                            'EGP ${caseItem.paymentDetails.estimatedAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: AppSize.font(16),
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'shared.cases.card.raised'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(12),
                              color: AppColors.grey700,
                            ),
                          ),

                          SizedBox(height: AppSize.getHeight(5)),

                          Text(
                            'EGP ${caseItem.paymentDetails.raisedAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: AppSize.font(16),
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSize.getHeight(15)),

              Divider(thickness: 0.3, height: 1, color: AppColors.grey300),
              SizedBox(height: AppSize.getHeight(15)),
              Row(
                children: [
                  SizedBox(width: AppSize.getWidth(20)),
                  CustomIcon(
                    icon: AppIcons.donations,
                    color: AppColors.grey600,
                    width: AppSize.getWidth(18),
                    height: AppSize.getHeight(18),
                  ),
                  SizedBox(width: AppSize.getWidth(3)),
                  Text(
                    '${caseItem.likers}',
                    style: TextStyle(
                      fontSize: AppSize.font(15),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(width: AppSize.getWidth(25)),
                  GestureDetector(
                    onTap: () => CaseCommentsBottomSheet.show(
                      context,
                      caseItem.id,
                      casesCubit,
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
                  InkWell(
                    onTap: () {
                      ///TODO
                      //Create share link here
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
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
                  SizedBox(width: AppSize.getWidth(20)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
