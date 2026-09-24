import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/helper/case_attachment_helpers.dart';
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

  Future<void> _openInstaPayLink(String url) async {
    final value = url.trim();

    final uri = Uri.tryParse(value);

    if (uri == null) {
      AppToast.error('shared.cases.pop_up.cant_open_link'.tr());
      return;
    }

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

  Future<void> _copyToClipboard(String value) async {
    await Clipboard.setData(ClipboardData(text: value));

    AppToast.success('shared.cases.pop_up.copied'.tr());
  }

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

  Widget _paymentValueWidget({
    required Color textColor,
    required Color secondaryColor,
  }) {
    final rawValue = caseItem.paymentDetails.description!.trim();

    final paymentType = caseItem.paymentDetails.paymentType;

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
                color: isInstaPay ? AppColors.laserBlue : textColor,
                fontWeight: FontWeight.w400,
                decoration: isInstaPay
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: isInstaPay ? AppColors.laserBlue : textColor,
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
            color: secondaryColor,
          ),
        ),
      ],
    );
  }

  bool get _hasPaymentAmounts =>
      caseItem.paymentDetails.estimatedAmount > 0 ||
      caseItem.paymentDetails.raisedAmount > 0;

  List<CaseAttachment> get _documentAttachments =>
      caseItem.attachments.where((a) => !isImageAttachment(a)).toList();

  Future<void> _openDocument(String url) async {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      AppToast.error('shared.cases.pop_up.cant_open_link'.tr());
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened) {
        AppToast.error('shared.cases.pop_up.cant_open_link'.tr());
      }
    } catch (e) {
      debugPrint('Failed to open document: $e');
      AppToast.error('shared.cases.pop_up.cant_open_link'.tr());
    }
  }

  IconData _iconForDocument(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Widget _documentsSection({
    required Color cardColor,
    required Color textColor,
    required Color secondaryColor,
  }) {
    final documents = _documentAttachments;

    if (documents.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'shared.cases.pop_up.documents'.tr(),
            style: TextStyle(
              fontSize: AppSize.font(13),
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          SizedBox(height: AppSize.getHeight(10)),
          for (int i = 0; i < documents.length; i++) ...[
            GestureDetector(
              onTap: () => _openDocument(documents[i].attachment.url),
              child: Row(
                children: [
                  Icon(
                    _iconForDocument(documents[i].attachment.contentType),
                    color: AppColors.laserBlue,
                    size: AppSize.getSize(20),
                  ),
                  SizedBox(width: AppSize.getWidth(10)),
                  Expanded(
                    child: Text(
                      documents[i].attachment.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        color: AppColors.laserBlue,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.laserBlue,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.getWidth(6)),
                  Text(
                    documents[i].attachment.size,
                    style: TextStyle(
                      fontSize: AppSize.font(11),
                      color: secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            if (i < documents.length - 1)
              SizedBox(height: AppSize.getHeight(10)),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final textColor = colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .65);

    final dialogColor =
        theme.dialogTheme.backgroundColor ?? colorScheme.surface;

    final sectionColor = theme.brightness == Brightness.dark
        ? colorScheme.surfaceContainerHighest
        : AppColors.grey50;

    final paymentDescription = caseItem.paymentDetails.description;

    return Dialog(
      backgroundColor: dialogColor,
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
                  color: textColor,
                ),
              ),

              SizedBox(height: AppSize.getHeight(10)),

              if (caseItem.description.isNotEmpty) ...[
                Text(
                  caseItem.description,
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    color: secondaryColor,
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
                  color: sectionColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'shared.cases.pop_up.contact_person'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(12),
                        color: secondaryColor,
                      ),
                    ),

                    SizedBox(height: AppSize.getHeight(5)),

                    Text(
                      caseItem.contactName,
                      style: TextStyle(
                        fontSize: AppSize.font(14),
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: AppSize.getHeight(10)),

                    Text(
                      'shared.cases.pop_up.phone'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(12),
                        color: secondaryColor,
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
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),

                    if (paymentDescription != null &&
                        paymentDescription.trim().isNotEmpty &&
                        caseItem.paymentDetails.paymentType != null) ...[
                      SizedBox(height: AppSize.getHeight(10)),

                      Text(
                        _paymentLabel,
                        style: TextStyle(
                          fontSize: AppSize.font(12),
                          color: secondaryColor,
                        ),
                      ),

                      SizedBox(height: AppSize.getHeight(5)),

                      _paymentValueWidget(
                        textColor: textColor,
                        secondaryColor: secondaryColor,
                      ),
                    ],
                  ],
                ),
              ),

              if (_hasPaymentAmounts) ...[
                SizedBox(height: AppSize.getHeight(15)),
                Container(
                  width: double.infinity,
                  padding: AppSize.padding(all: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: sectionColor,
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
                                color: secondaryColor,
                              ),
                            ),

                            SizedBox(height: AppSize.getHeight(5)),

                            Text(
                              'EGP ${caseItem.paymentDetails.estimatedAmount.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: AppSize.font(16),
                                fontWeight: FontWeight.bold,
                                color: textColor,
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
                                color: secondaryColor,
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

              if (_documentAttachments.isNotEmpty) ...[
                SizedBox(height: AppSize.getHeight(15)),
                _documentsSection(
                  cardColor: sectionColor,
                  textColor: textColor,
                  secondaryColor: secondaryColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
