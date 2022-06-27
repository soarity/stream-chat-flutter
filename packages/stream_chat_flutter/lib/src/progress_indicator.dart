import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///
class CustomProgressIndicator extends StatelessWidget {
  /// The Constructor
  const CustomProgressIndicator({
    super.key,
    this.defaultColor = false,
    this.size,
  });

  /// color of the indicator
  final bool defaultColor;

  /// size of the indicator
  final double? size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size ?? 30.r,
        height: size ?? 30.r,
        child: Platform.isIOS
            ? const CupertinoActivityIndicator()
            : const CircularProgressIndicator(strokeWidth: 2),
      );
}
