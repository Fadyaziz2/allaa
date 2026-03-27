// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'package:flutter/material.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final double? radius;
  final Widget? buttonTextWidget;
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.transparent = false,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.color,
    this.radius,
    this.textColor,
    this.buttonTextWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Button Style
    final ButtonStyle _flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : transparent
              ? Colors.transparent
              : color ?? Theme.of(context).primaryColor,
      minimumSize:
          Size(width != null ? width! : 1170, height != null ? height! : 48),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: transparent
                ? Theme.of(context).primaryColor
                : Colors.transparent),
        borderRadius: BorderRadius.circular(radius ?? Dimensions.RADIUS_SMALL),
      ),
    );

    return Padding(
      padding: margin == null ? const EdgeInsets.all(0) : margin!,
      child: TextButton(
        onPressed: onPressed,
        style: _flatButtonStyle,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_SMALL),
          child: buttonTextWidget ??
              Text(
                buttonText,
                textAlign: TextAlign.center,
                style: poppinsMedium.copyWith(
                  overflow: TextOverflow.ellipsis,
                  color: textColor ??
                      (transparent
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor),
                  fontSize: fontSize ?? Dimensions.FONT_SIZE_LARGE,
                ),
              ),
        ),
      ),
    );
  }
}
