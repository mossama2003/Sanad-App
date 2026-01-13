import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:open_file/open_file.dart';
import 'package:shuaa_alamal/core/style/app_text_style.dart';

import '../../constant/app_assets.dart';
import '../../constant/app_size.dart';
import '../../style/app_colors.dart';
import 'custom_icon.dart';

class CustomUploadFiles extends StatelessWidget {
  const CustomUploadFiles({
    super.key,
    this.onRemove,
    this.selectedFiles,
    required this.onTap,
  });

  final Function() onTap;
  final Function(File)? onRemove;
  final List<File>? selectedFiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: AppSize.padding(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.getSize(12)),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIcon(
                  withColor: true,
                  width: AppSize.getSize(50),
                  height: AppSize.getSize(50),
                  color: AppColors.primary,
                  icon: AppIcons.uploadFile,
                ),
                SizedBox(height: AppSize.getHeight(12)),
                Text(
                  'core.upload_files_title'.tr(),
                  style: TextStyle(color: AppColors.brand700).md,
                ),
                SizedBox(height: AppSize.getHeight(4)),
                Text(
                  'core.upload_files_desc'.tr(),
                  style: TextStyle(color: AppColors.grey600).xs,
                ),
              ],
            ),
          ),
        ),
        if (selectedFiles != null && selectedFiles!.isNotEmpty) ...[
          SizedBox(height: AppSize.getHeight(20)),
          ListView.separated(
            shrinkWrap: true,
            itemCount: selectedFiles!.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) => CustomFileCard(
              onRemove: onRemove,
              file: selectedFiles![i],
            ),
            separatorBuilder: (_, i) => SizedBox(
              height: AppSize.getHeight(15),
            ),
          ),
        ],
      ],
    );
  }
}

class CustomFileCard extends StatelessWidget {
  const CustomFileCard({
    super.key,
    required this.file,
    this.onRemove,
  });

  final File file;
  final Function(File)? onRemove;

  /// Converts a byte count into a human-readable string, e.g. "4.2 MB"
  String _formatBytes(int bytes, [int decimals = 1]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (log(bytes) / log(1024)).floor();
    final value = bytes / pow(1024, i);
    return "${value.toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  @override
  Widget build(BuildContext context) {
    final filename = file.path.split('/').last;
    final bytes = file.lengthSync();
    final sizeLabel = _formatBytes(bytes);

    return InkWell(
      onTap: () => OpenFile.open(file.path),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.getSize(12)),
          border: Border.all(color: AppColors.grey200),
        ),
        padding: AppSize.padding(all: 16),
        child: Row(
          spacing: AppSize.getWidth(16),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomIcon(
              icon: AppIcons.file,
              color: AppColors.grey500,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSize.getHeight(4),
                children: [
                  Text(
                    filename,
                    style: TextStyle(color: AppColors.grey700).sm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    sizeLabel,
                    style: TextStyle(color: AppColors.grey600).sm,
                  ),
                ],
              ),
            ),
            if (onRemove != null)
              CustomIcon(
                width: AppSize.getSize(20),
                height: AppSize.getSize(20),
                icon: AppIcons.delete,
                onTap: () => onRemove!(file),
                color: AppColors.grey500,
              ),
          ],
        ),
      ),
    );
  }
}
