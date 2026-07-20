import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';

class OrganizationQrCodeScreen extends StatefulWidget {
  const OrganizationQrCodeScreen({super.key});

  @override
  State<OrganizationQrCodeScreen> createState() =>
      _OrganizationQrCodeScreenState();
}

class _OrganizationQrCodeScreenState extends State<OrganizationQrCodeScreen> {
  int selectedAction = 0;

  static const Color primaryGreen = Color(0xFF2ECC9B);
  static const Color darkTeal = Color(0xFF17A398);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Text(
          'organization.events.event_qr_code'.tr(),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppSize.font(18),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSize.padding(all: 16),
          child: Column(
            children: [
              _buildQrCard(),
              SizedBox(height: AppSize.getHeight(16)),
              _buildActionButtons(),
              SizedBox(height: AppSize.getHeight(16)),
              _buildScansCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: .5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            padding: AppSize.padding(vertical: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [darkTeal, primaryGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Blood Donation Drive',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppSize.font(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(5)),
                Text(
                  'Scan to check in',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: .8),
                    fontSize: AppSize.font(15),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSize.padding(all: 20),
            child: Column(
              children: [
                Container(
                  padding: AppSize.padding(all: 10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: QrImageView(
                    data: 'blood-donation-drive-checkin',
                    version: QrVersions.auto,
                    size: 220,
                    gapless: true,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(20)),
                _infoRow(AppIcons.calendar, 'Dec 15, 2025 · 10:00 AM'),
                SizedBox(height: AppSize.getHeight(8)),
                _infoRow(AppIcons.location, 'Cairo Medical Center'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String icon, String text) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIcon(
          icon: icon,
          width: AppSize.getWidth(16),
          height: AppSize.getHeight(16),
          color: secondaryColor,
        ),
        SizedBox(width: AppSize.getWidth(6)),
        Text(
          text,
          style: TextStyle(color: secondaryColor, fontSize: AppSize.font(14)),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final actions = [
      (AppIcons.download, 'organization.events.download'.tr()),
      (AppIcons.share, 'organization.events.share'.tr()),
      (AppIcons.fullScreen, 'organization.events.full_screen'.tr()),
    ];

    return Row(
      children: List.generate(actions.length, (i) {
        return Expanded(
          child: Padding(
            padding: AppSize.padding(end: i != actions.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() => selectedAction = i),

              child: Container(
                padding: AppSize.padding(vertical: 14),

                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  children: [
                    CustomIcon(
                      icon: actions[i].$1,
                      color: AppColors.primary,
                      width: AppSize.getSize(20),
                      height: AppSize.getHeight(20),
                    ),

                    SizedBox(height: AppSize.getHeight(4)),

                    Text(
                      actions[i].$2,
                      style: TextStyle(
                        fontSize: AppSize.font(12),
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildScansCard() {
    return Container(
      width: double.infinity,
      padding: AppSize.padding(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: .2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: AppSize.padding(all: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6F1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.qr_code_scanner, color: darkTeal),
          ),
          SizedBox(height: AppSize.getHeight(10)),
          Text(
            '312',
            style: TextStyle(
              fontSize: AppSize.font(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSize.getHeight(2)),
          Text(
            'organization.events.total_scans'.tr(),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: AppSize.font(13),
            ),
          ),
        ],
      ),
    );
  }
}
