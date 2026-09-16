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

class CasesPopUp extends StatelessWidget {
  final CaseListItemModel caseItem;
  final CasesCubit casesCubit;

  const CasesPopUp({
    super.key,
    required this.caseItem,
    required this.casesCubit,
  });

  // ---------------------------------------------------------------------------
  // Phone
  // ---------------------------------------------------------------------------

  Future<void> _callPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.trim());

    try {
      final opened = await launchUrl(uri);

      if (!opened) {
        AppToast.error('shared.cases.pop_up.cant_call'.tr());
      }
    } catch (e) {
      debugPrint('Failed to call phone: $e');

      AppToast.error('shared.cases.pop_up.cant_call'.tr());
    }
  }

  // ---------------------------------------------------------------------------
  // InstaPay
  // ---------------------------------------------------------------------------

  Future<void> _openInstaPayLink(String url) async {
    final value = url.trim();

    final uri = Uri.tryParse(value);

    if (uri == null) {
      AppToast.error('shared.cases.pop_up.cant_open_link'.tr());
      return;
    }

    // Make sure this is an HTTPS InstaPay link.
    if (uri.scheme.toLowerCase() != 'https' ||
        uri.host.toLowerCase() != 'ipn.eg') {
      AppToast.error('shared.cases.pop_up.cant_open_link'.tr());
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalNonBrowserApplication,
      );

      if (!opened) {
        // Fallback:
        //
        // If the device does not expose InstaPay as an external
        // application handler, open the official URL normally.
        final fallbackOpened = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!fallbackOpened) {
          AppToast.error('shared.cases.pop_up.cant_open_link'.tr());
        }
      }
    } catch (e) {
      debugPrint('Failed to open InstaPay link: $e');

      AppToast.error('shared.cases.pop_up.cant_open_link'.tr());
    }
  }

  // ---------------------------------------------------------------------------
  // Clipboard
  // ---------------------------------------------------------------------------

  Future<void> _copyToClipboard(String value) async {
    await Clipboard.setData(ClipboardData(text: value));

    AppToast.success('shared.cases.pop_up.copied'.tr());
  }

  // ---------------------------------------------------------------------------
  // Egyptian phone formatting
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // InstaPay validation
  // ---------------------------------------------------------------------------

  bool get _isValidInstaPayLink {
    final description = caseItem.paymentDetails.description;

    if (description == null || description.trim().isEmpty) {
      return false;
    }

    final uri = Uri.tryParse(description.trim());

    if (uri == null) {
      return false;
    }

    return uri.scheme.toLowerCase() == 'https' &&
        uri.host.toLowerCase() == 'ipn.eg';
  }

  // ---------------------------------------------------------------------------
  // Payment label
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // Payment value
  // ---------------------------------------------------------------------------

  Widget _paymentValueWidget() {
    final rawValue = caseItem.paymentDetails.description!.trim();

    final paymentType = caseItem.paymentDetails.paymentType;

    // Wallet numbers are displayed in Egyptian local format.
    final value = paymentType == 'wallet'
        ? _formatEgyptianPhone(rawValue)
        : rawValue;

    final isInstaPay = paymentType == 'instapay' && _isValidInstaPayLink;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isInstaPay ? () => _openInstaPayLink(rawValue) : null,
            onLongPress: () => _copyToClipboard(value),
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppSize.font(14),
                color: isInstaPay ? AppColors.laserBlue : AppColors.black,
                fontWeight: FontWeight.w400,
                decoration: isInstaPay
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: isInstaPay
                    ? AppColors.laserBlue
                    : AppColors.black,
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

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final paymentDescription = caseItem.paymentDetails.description;

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
              // ----------------------------------------------------------------
              // Case name
              // ----------------------------------------------------------------

              Text(
                caseItem.name,
                style: TextStyle(
                  fontSize: AppSize.font(20),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              SizedBox(height: AppSize.getHeight(10)),

              // ----------------------------------------------------------------
              // Case description
              // ----------------------------------------------------------------
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

              // ----------------------------------------------------------------
              // Contact + Payment
              // ----------------------------------------------------------------
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
                    // ==========================================================
                    // Contact Person
                    // ==========================================================

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

                    // ==========================================================
                    // Phone
                    // ==========================================================
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

                    // ==========================================================
                    // Payment
                    // ==========================================================
                    if (paymentDescription != null &&
                        paymentDescription.trim().isNotEmpty) ...[
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

              // ----------------------------------------------------------------
              // Required / Raised
              // ----------------------------------------------------------------
              Container(
                width: double.infinity,
                padding: AppSize.padding(all: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.grey50,
                ),
                child: Row(
                  children: [
                    // ==========================================================
                    // Required
                    // ==========================================================

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

                    // ==========================================================
                    // Raised
                    // ==========================================================
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
            ],
          ),
        ),
      ),
    );
  }
}
