import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/features/volunteer/qr_check_in/data/repos/volunteer_qr_repo.dart';
import 'package:sanad_app/features/volunteer/qr_check_in/presentation/controllers/volunteer_qr_cubit.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/style/app_colors.dart';
import '../widgets/qr_camera_scanner.dart';

enum _ScanStatus { scanning, processing, success, error }

class QrCheckInScreen extends StatefulWidget {
  const QrCheckInScreen({super.key});

  @override
  State<QrCheckInScreen> createState() => _QrCheckInScreenState();
}

class _QrCheckInScreenState extends State<QrCheckInScreen> {
  late final VolunteerQrCubit _cubit;
  late final MobileScannerController _scannerController;

  _ScanStatus _status = _ScanStatus.scanning;

  @override
  void initState() {
    super.initState();

    _cubit = VolunteerQrCubit(VolunteerQrRepoImpl());
    _scannerController = MobileScannerController();
  }

  @override
  void dispose() {
    _cubit.close();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _onQrDetected(String code) async {
    if (_status != _ScanStatus.scanning) return;

    setState(() {
      _status = _ScanStatus.processing;
    });

    await _scannerController.stop();

    try {
      final qrParts = code.split(':');

      if (qrParts.length != 2) {
        AppToast.error("volunteer.qr_check_in.invalid_qr_code".tr());

        setState(() {
          _status = _ScanStatus.error;
        });

        return;
      }

      final eventId = int.tryParse(qrParts.first);

      if (eventId == null) {
        AppToast.error("volunteer.qr_check_in.invalid_event".tr());

        setState(() {
          _status = _ScanStatus.error;
        });

        return;
      }

      final qrCode = qrParts.last;

      debugPrint("EVENT ID => $eventId");
      debugPrint("QR VALUE => $qrCode");

      await _cubit.checkIn(qr: qrCode, eventId: eventId);
    } catch (e) {
      debugPrint("CHECK IN ERROR => $e");

      setState(() {
        _status = _ScanStatus.error;
      });
    }
  }

  Future<void> _scanAgain() async {
    setState(() {
      _status = _ScanStatus.scanning;
    });

    // بيفتح الكاميرا تاني بس لما اليوزر يدوس بنفسه
    await _scannerController.start();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;

    return BlocConsumer<VolunteerQrCubit, VolunteerQrState>(
      bloc: _cubit,

      listener: (context, state) {
        if (state is Success) {
          setState(() {
            _status = _ScanStatus.success;
          });
        } else if (state is Error) {
          setState(() {
            _status = _ScanStatus.error;
          });
        }
      },

      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,

          appBar: AppBar(
            title: Text(
              'volunteer.qr_check_in.appbar'.tr(),

              style: TextStyle(
                color: textColor,
                fontSize: AppSize.font(18),
                fontWeight: FontWeight.w600,
              ),
            ),

            backgroundColor: theme.scaffoldBackgroundColor,

            elevation: 0,

            scrolledUnderElevation: 0,

            iconTheme: IconThemeData(color: theme.iconTheme.color),
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppSize.padding(horizontal: 16, vertical: 24),

              child: Column(
                children: [
                  Container(
                    height: AppSize.getHeight(350),

                    width: double.infinity,

                    clipBehavior: Clip.antiAlias,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),

                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: .2),

                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        QrCameraScanner(
                          controller: _scannerController,
                          onDetect: _onQrDetected,
                          active: _status == _ScanStatus.scanning,
                        ),

                        if (_status == _ScanStatus.processing)
                          Container(
                            color: Colors.black.withValues(alpha: .45),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),

                        // في حالة النجاح: نعرض النتيجة من غير زرار Scan Again خالص
                        if (_status == _ScanStatus.success)
                          _buildSuccessOverlay(
                            message:
                            'volunteer.qr_check_in.checked_in_successfully'
                                .tr(),
                          ),

                        if (_status == _ScanStatus.error)
                          _buildResultOverlay(
                            icon: Icons.cancel_rounded,
                            color: AppColors.red,
                            message: 'volunteer.qr_check_in.check_in_failed'
                                .tr(),
                            buttonLabel: 'volunteer.qr_check_in.scan_again'
                                .tr(),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(24)),

                  Container(
                    padding: AppSize.padding(all: 20),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),

                      color: theme.cardColor,

                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: .2),

                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomIcon(
                              icon: AppIcons.info,

                              color: AppColors.primary,

                              width: AppSize.getWidth(15),

                              height: AppSize.getHeight(15),
                            ),

                            SizedBox(width: AppSize.getWidth(5)),

                            Text(
                              'volunteer.qr_check_in.how_why'.tr(),

                              style: TextStyle(
                                color: textColor,

                                fontSize: AppSize.font(15),

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppSize.getHeight(20)),

                        _buildInfoItem(
                          context,
                          AppIcons.camera,
                          'volunteer.qr_check_in.how_why_desc1'.tr(),
                        ),

                        SizedBox(height: AppSize.getHeight(15)),

                        _buildInfoItem(
                          context,
                          AppIcons.qr,
                          'volunteer.qr_check_in.how_why_desc2'.tr(),
                        ),

                        SizedBox(height: AppSize.getHeight(15)),

                        _buildInfoItem(
                          context,
                          AppIcons.check,
                          'volunteer.qr_check_in.how_why_desc3'.tr(),
                        ),

                        SizedBox(height: AppSize.getHeight(15)),

                        _buildInfoItem(
                          context,
                          AppIcons.achievement,
                          'volunteer.qr_check_in.how_why_desc4'.tr(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// أوفرلاي النجاح: أيقونة + رسالة بس، من غير أي زرار
  Widget _buildSuccessOverlay({required String message}) {
    return Container(
      color: Colors.black.withValues(alpha: .75),

      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: AppSize.getSize(90),

              height: AppSize.getSize(90),

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: AppColors.green.withValues(alpha: .15),
              ),

              child: Icon(
                Icons.check_circle_rounded,
                color: AppColors.green,
                size: AppSize.getSize(60),
              ),
            ),

            SizedBox(height: AppSize.getHeight(16)),

            Padding(
              padding: AppSize.padding(horizontal: 24),

              child: Text(
                message,

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white,

                  fontSize: AppSize.font(16),

                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultOverlay({
    required IconData icon,
    required Color color,
    required String message,
    required String buttonLabel,
  }) {
    return Container(
      color: Colors.black.withValues(alpha: .75),

      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: AppSize.getSize(90),

              height: AppSize.getSize(90),

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: color.withValues(alpha: .15),
              ),

              child: Icon(icon, color: color, size: AppSize.getSize(60)),
            ),

            SizedBox(height: AppSize.getHeight(16)),

            Padding(
              padding: AppSize.padding(horizontal: 24),

              child: Text(
                message,

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white,

                  fontSize: AppSize.font(16),

                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: AppSize.getHeight(20)),

            GestureDetector(
              onTap: _scanAgain,

              child: Container(
                padding: AppSize.padding(horizontal: 20, vertical: 10),

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .15),

                  borderRadius: BorderRadius.circular(30),

                  border: Border.all(color: Colors.white.withValues(alpha: .4)),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 18,
                    ),

                    SizedBox(width: AppSize.getWidth(8)),

                    Text(
                      buttonLabel,

                      style: const TextStyle(
                        color: Colors.white,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String icon, String text) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          height: AppSize.getSize(25),

          width: AppSize.getSize(25),

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .1),

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
          child: Text(
            text,

            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: .6),

              fontSize: AppSize.font(13),

              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
