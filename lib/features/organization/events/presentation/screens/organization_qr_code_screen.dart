import 'dart:io';
import 'dart:typed_data';

import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../data/models/organization_event_details_model.dart';

class OrganizationQrCodeScreen extends StatefulWidget {
  const OrganizationQrCodeScreen({super.key, required this.event});

  final OrganizationEventDetailsModel event;

  @override
  State<OrganizationQrCodeScreen> createState() =>
      _OrganizationQrCodeScreenState();
}

class _OrganizationQrCodeScreenState extends State<OrganizationQrCodeScreen> {
  int selectedAction = 0;

  static const Color primaryGreen = Color(0xFF2ECC9B);
  static const Color darkTeal = Color(0xFF17A398);

  final ScreenshotController _screenshotController = ScreenshotController();

  String get qrData {
    return '${widget.event.id}:${widget.event.qr}';
  }

  Future<void> _downloadQr() async {
    try {
      final Uint8List? image = await _screenshotController.capture(
        pixelRatio: 3,
      );

      if (image == null) return;

      await ImageGallerySaverPlus.saveImage(
        image,
        quality: 100,
        name: 'event_qr_${widget.event.id}',
      );

      AppToast.success('organization.events.qr_saved_successfully'.tr());
    } catch (e, s) {
      debugPrint('Download QR Error: $e');
      debugPrintStack(stackTrace: s);

      AppToast.error('organization.events.something_went_wrong'.tr());
    }
  }

  Future<void> _shareQr() async {
    try {
      final Uint8List? image = await _screenshotController.capture(
        pixelRatio: 3,
      );

      if (image == null) return;

      final dir = await getTemporaryDirectory();

      final file = File('${dir.path}/event_qr_${widget.event.id}.png');

      await file.writeAsBytes(image);

      await Share.shareXFiles([XFile(file.path)], text: widget.event.name);
    } catch (_) {
      AppToast.error('organization.events.something_went_wrong'.tr());
    }
  }

  void _showFullScreenQr() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: InteractiveViewer(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 320,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? .35 : .12,
            ),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      clipBehavior: Clip.antiAlias,

      child: Column(
        children: [
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
                  widget.event.name,

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: AppSize.font(20),

                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(5)),

                Text(
                  'organization.events.scan_to_check_in'.tr(),

                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .8),

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
                Screenshot(
                  controller: _screenshotController,

                  child: Container(
                    padding: AppSize.padding(all: 10),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(color: Colors.grey.shade200),
                    ),

                    child: QrImageView(
                      data: qrData,

                      version: QrVersions.auto,

                      size: 220,

                      gapless: true,

                      backgroundColor: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: AppSize.getHeight(20)),

                _infoRow(
                  AppIcons.calendar,

                  DateFormat('dd MMM yyyy • hh:mm a').format(widget.event.date),
                ),

                SizedBox(height: AppSize.getHeight(8)),

                _infoRow(
                  AppIcons.location,

                  [
                        widget.event.location?['description'],

                        widget.event.location?['city'],
                      ]
                      .where((e) => e != null && e.toString().isNotEmpty)
                      .join(', '),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String icon, String text) {
    final theme = Theme.of(context);

    final color = theme.colorScheme.onSurface.withValues(alpha: .55);

    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        CustomIcon(
          icon: icon,

          width: AppSize.getWidth(16),

          height: AppSize.getHeight(16),

          color: color,
        ),

        SizedBox(width: AppSize.getWidth(6)),

        Text(
          text,

          style: TextStyle(color: color, fontSize: AppSize.font(14)),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final theme = Theme.of(context);

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
              onTap: () async {
                setState(() => selectedAction = i);

                switch (i) {
                  case 0:
                    await _downloadQr();
                    break;

                  case 1:
                    await _shareQr();
                    break;

                  case 2:
                    _showFullScreenQr();
                    break;
                }
              },

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

                        color: theme.colorScheme.onSurface,
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
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,

      padding: AppSize.padding(vertical: 24),

      decoration: BoxDecoration(
        color: theme.cardColor,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? .35 : .12,
            ),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            padding: AppSize.padding(all: 10),

            decoration: const BoxDecoration(
              color: Color(0xFFEAF6F1),

              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.qr_code_scanner, color: darkTeal),
          ),

          SizedBox(height: AppSize.getHeight(10)),

          Text(
            '${widget.event.attendees}',

            style: TextStyle(
              color: theme.colorScheme.onSurface,

              fontSize: AppSize.font(24),

              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: AppSize.getHeight(2)),

          Text(
            'organization.events.total_scans'.tr(),

            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: .55),

              fontSize: AppSize.font(13),
            ),
          ),
        ],
      ),
    );
  }
}
