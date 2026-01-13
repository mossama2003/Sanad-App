import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    super.key,
    this.height,
    required this.item,
    required this.count,
    required this.position,
    required this.updatePosition,
  });

  final int count;
  final int position;
  final double? height;
  final Function(int i) item;
  final Function(int i) updatePosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: count,
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            autoPlayCurve: Curves.linearToEaseOut,
            height: height ?? AppSize.getHeight(200),
            onPageChanged: (i, r) => updatePosition(i),
            scrollPhysics: const BouncingScrollPhysics(),
            autoPlayAnimationDuration: const Duration(seconds: 1),
          ),
          itemBuilder: (_, i, any) => item(i),
        ),
        SizedBox(height: AppSize.getHeight(8)),
        DotsIndicator(
          dotsCount: count,
          position: double.parse(position.toString()),
          decorator: DotsDecorator(
            size: Size(AppSize.getSize(8), AppSize.getSize(8)),
            activeSize: Size(AppSize.getSize(8), AppSize.getSize(8)),
            color: AppColors.fieldBorderLight,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.getSize(4)),
            ),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.getSize(4)),
            ),
          ),
        ),
      ],
    );
  }
}
