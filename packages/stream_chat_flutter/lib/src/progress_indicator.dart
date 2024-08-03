import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        width: size ?? 30,
        height: size ?? 30,
        child: Platform.isIOS
            ? const CupertinoActivityIndicator()
            : const CircularProgressIndicator(strokeWidth: 2),
      );
}
