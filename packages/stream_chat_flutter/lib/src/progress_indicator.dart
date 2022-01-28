import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
class CustomProgressIndicator extends StatelessWidget {
  /// The Constructor
  const CustomProgressIndicator({
    Key? key,
    this.defaultColor = false,
    this.size,
  }) : super(key: key);

  /// color of the indicator
  final bool defaultColor;

  /// size of the indicator
  final double? size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size ?? 35.0,
        height: size ?? 35.0,
        child: Platform.isIOS
            ? const CupertinoActivityIndicator()
            : const CircularProgressIndicator(),
      );
}
