import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/features/volunteer/qr_check_in/data/repos/volunteer_qr_repo.dart';
import 'package:sanad_app/features/volunteer/qr_check_in/presentation/controllers/volunteer_qr_cubit.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/style/app_colors.dart';
import '../widgets/qr_camera_scanner.dart';

class QrCheckInScreen extends StatefulWidget {
  const QrCheckInScreen({super.key});

  @override
  State<QrCheckInScreen> createState() => _QrCheckInScreenState();
}

class _QrCheckInScreenState extends State<QrCheckInScreen> {
  late final VolunteerQrCubit _cubit;

  bool canScan = true;

  @override
  void initState() {
    super.initState();

    _cubit = VolunteerQrCubit(VolunteerQrRepoImpl());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _onQrDetected(String code) async {
    setState(() {
      canScan = false;
    });

    try {
      final qrParts = code.split(':');

      if (qrParts.length != 2) {
        AppToast.error("volunteer.qr_check_in.invalid_qr_code".tr());

        setState(() {
          canScan = true;
        });

        return;
      }

      final eventId = int.tryParse(qrParts.first);

      if (eventId == null) {
        AppToast.error("volunteer.qr_check_in.invalid_event".tr());

        setState(() {
          canScan = true;
        });

        return;
      }

      final qrCode = qrParts.last;

      debugPrint("EVENT ID => $eventId");
      debugPrint("QR VALUE => $qrCode");

      await _cubit.checkIn(qr: qrCode, eventId: eventId);
    } catch (e) {
      debugPrint("CHECK IN ERROR => $e");
    } finally {
      if (mounted) {
        setState(() {
          canScan = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;

    return BlocConsumer<VolunteerQrCubit, VolunteerQrState>(
      bloc: _cubit,

      listener: (context, state) {
        if (state is Success || state is Error) {
          setState(() {
            canScan = true;
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
                          onDetect: _onQrDetected,
                          canScan: canScan,
                        ),

                        if (state is Loading)
                          Container(
                            color: Colors.black.withValues(alpha: .35),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
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
