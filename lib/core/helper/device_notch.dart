import 'package:flutter/material.dart';

bool hasNotch(BuildContext context) {
  // Get the top padding (safe area) of the device
  var topPadding = MediaQuery.of(context).padding.top;

  // Consider a device has a notch if the top padding is greater than a typical status bar height.
  return topPadding > 24; // 24 is a common status bar height on devices without a notch.
}