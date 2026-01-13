import 'dart:ui';

import 'package:flutter/material.dart';

class AppSize {
  AppSize._();

  /// REFERENCE VALUES FROM THE FIGMA DESIGN.
  static const num _designWidth = 375;
  static const num _designHeight = 812;
  static const num _designStatusBar = 48;

  /// INITIALIZE SIZE USING THE PHYSICAL SIZE AND DEVICE PIXEL RATIO.
  static final Size _size =
      PlatformDispatcher.instance.views.first.physicalSize /
          PlatformDispatcher.instance.views.first.devicePixelRatio;

  /// GET THE DEVICE VIEWPORT WIDTH.
  static double _getWidth() => _size.width;

  /// GET THE DEVICE VIEWPORT HEIGHT, ACCOUNTING FOR STATUS BAR AND BOTTOM BAR.
  static double _getHeight() {
    final view = PlatformDispatcher.instance.views.first;
    final padding = view.viewPadding;
    final devicePixelRatio = view.devicePixelRatio;

    // Convert ViewPadding to logical values.
    final topPadding = padding.top / devicePixelRatio;
    final bottomPadding = padding.bottom / devicePixelRatio;

    return _size.height - topPadding - bottomPadding;
  }

  /// CALCULATE HORIZONTAL SIZE ACCORDING TO VIEWPORT WIDTH.
  static double getWidth(double px) {
    return (px * _getWidth()) / _designWidth;
  }

  /// CALCULATE VERTICAL SIZE ACCORDING TO VIEWPORT HEIGHT.
  static double getHeight(double px) {
    return (px * _getHeight()) / (_designHeight - _designStatusBar);
  }

  /// GET THE SMALLEST SIZE FOR IMAGE HEIGHT AND WIDTH.
  static double getSize(double px) {
    double vSize = getHeight(px);
    double hSize = getWidth(px);
    return (vSize < hSize)
        ? vSize.toInt().toDouble()
        : hSize.toInt().toDouble();
  }

  /// GET FONT SIZE ACCORDING TO VIEWPORT.
  static double font(double px) => getSize(px);

  static double fontHeight(double font, double height) {
    return height / font;
  }

  /// SET PADDING RESPONSIVELY.
  static EdgeInsetsGeometry padding({
    double? all,
    double? top,
    double? end,
    double? start,
    double? bottom,
    double? vertical,
    double? horizontal,
  }) {
    return _getMarginOrPadding(
      all: all,
      top: top,
      end: end,
      start: start,
      bottom: bottom,
      vertical: vertical,
      horizontal: horizontal,
    );
  }

  /// SET MARGIN RESPONSIVELY.
  static EdgeInsetsDirectional margin({
    double? all,
    double? top,
    double? end,
    double? start,
    double? bottom,
    double? vertical,
    double? horizontal,
  }) {
    return _getMarginOrPadding(
      all: all,
      top: top,
      end: end,
      start: start,
      bottom: bottom,
      vertical: vertical,
      horizontal: horizontal,
    );
  }

  /// GET PADDING OR MARGIN RESPONSIVELY.
  static EdgeInsetsDirectional _getMarginOrPadding({
    double? all,
    double? top,
    double? end,
    double? start,
    double? bottom,
    double? vertical,
    double? horizontal,
  }) {
    if (all != null) {
      top = all;
      end = all;
      start = all;
      bottom = all;
    }
    if (horizontal != null) {
      start = horizontal;
      end = horizontal;
    }
    if (vertical != null) {
      top = vertical;
      bottom = vertical;
    }
    return EdgeInsetsDirectional.only(
      top: getHeight(top ?? 0),
      end: getWidth(end ?? 0),
      start: getWidth(start ?? 0),
      bottom: getHeight(bottom ?? 0),
    );
  }
}
