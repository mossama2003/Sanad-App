import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/auth/data/models/user_model.dart';
import '../network/local/cache/cache_helper.dart';
import '../shared/controllers/app/app_cubit.dart';
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
    await AppCubit.get(AppNavigator.context).getAuth();
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
}
