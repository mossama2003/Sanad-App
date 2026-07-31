import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/shared/auth/data/models/user_model.dart';
import '../network/local/cache/cache_helper.dart';
import '../shared/controllers/user/app_cubit.dart';
import 'app_navigator.dart';
import 'app_toast.dart';

class AppHelper {
  AppHelper._();

  static Future closeKeyboard() async {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    AppToast.success('core.copied_to_clipboard'.tr());
  }

  static UserModel? get authUser {
    return AppCubit.get(AppNavigator.context).user;
  }

  static Future<void> getAuthUser() async {
    // await AppCubit.get(AppNavigator.context).getAuth();
  }

  static Future<void> share(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }

  static Future<void> launchLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // static Future<void> downloadAndOpenFile(String attachment) async {
  //   try {
  //     AppNavigator.push(
  //       Scaffold(
  //         backgroundColor: Colors.transparent,
  //         body: Center(child: CircularProgressIndicator()),
  //       ),
  //     );
  //     final tempDir = await getTemporaryDirectory();
  //     final filePath = '${tempDir.path}/${attachment.split('/').last}';
  //     final file = File(filePath);
  //     final api = attachment;
  //     await DioHelper.download(url: api, savePath: filePath);
  //     await OpenFile.open(file.path);
  //     AppNavigator.pop();
  //   } catch (e) {
  //     AppNavigator.pop();
  //     AppToast.error('Error: $e');
  //   }
  // }

  static Future<DateTime?> pickDate({
    DateTime? min,
    DateTime? initial,
    DateTime? max,
  }) async {
    final ctx = AppNavigator.key.currentContext;
    if (ctx != null) {
      return await showDatePicker(
        context: ctx,
        firstDate: min ?? DateTime.now(),
        initialDate: initial ?? min ?? DateTime.now(),
        lastDate: max ?? DateTime.parse("2222-12-31"),
      );
    }
    return null;
  }

  static String timeFormat(String? time, String format) {
    if (time == null) return '';
    final String lang = CacheHelper.get(CacheKeys.lang);
    DateTime parsedTime = DateTime.parse(time).toLocal();
    String formattedTime = DateFormat(format, lang).format(parsedTime);
    return formattedTime;
  }

  static String timeAgoShort(DateTime date) {
    final diff = DateTime.now().difference(date);

    // Future date
    if (diff.isNegative) {
      final future = date.difference(DateTime.now());

      if (future.inMinutes < 60) {
        return '${future.inMinutes} m';
      }

      if (future.inHours < 24) {
        return '${future.inHours} H';
      }

      if (future.inDays < 365) {
        return '${future.inDays} D';
      }

      final years = (future.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''}';
    }

    // Past date
    if (diff.inMinutes < 1) {
      return 'now';
    }

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} m';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours} H';
    }

    if (diff.inDays < 365) {
      return '${diff.inDays} D';
    }

    final years = (diff.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''}';
  }
}
