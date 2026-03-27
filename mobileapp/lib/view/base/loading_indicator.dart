// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final bool? isWhiteColor;

  const LoadingIndicator({super.key, this.isWhiteColor});

  @override
  Widget build(BuildContext context) {
    // Loading checker
    final widget = (Platform.isAndroid)
        ? CircularProgressIndicator(
            color: isWhiteColor == true
                ? Theme.of(context).indicatorColor
                : Theme.of(context).primaryColor,
            strokeWidth: 3,
          )
        : CupertinoActivityIndicator(
            color: isWhiteColor == true
                ? Theme.of(context).indicatorColor
                : Theme.of(context).primaryColor,
          );
    return Container(
      alignment: Alignment.center,
      child: widget,
    );
  }
}
