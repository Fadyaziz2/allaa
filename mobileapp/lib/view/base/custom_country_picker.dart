// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

class CustomCountryPicker extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputAction? inputAction;
  final bool? isPassword;
  final Function? onSubmit;
  final bool? isEnabled;
  final bool readOnly;
  final int? maxLines;
  final TextCapitalization? capitalization;
  final String? prefixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool hintColorEnable;
  final Color? hintColor;
  final Color? titleColor;
  final String? header;
  final bool isRequired;
  final TextStyle? hintStyle;
  final TextStyle? titleStyle;
  final Color? fillColor;
  final TextAlign? textAlign;
  final Widget? headerRightElement;
  final bool enableBorder;
  final double? width;
  final VoidCallback? prefixIconOnTap;
  final Color? borderColor;
  final Country country;

  const CustomCountryPicker(
      {super.key,
      this.hintText = '',
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.isEnabled = true,
      this.readOnly = false,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      this.onSubmit,
      this.prefixIcon,
      this.capitalization = TextCapitalization.none,
      this.isPassword = false,
      this.validator,
      this.onChanged,
      this.hintColorEnable = false,
      this.hintColor,
      this.titleColor,
      this.header,
      this.isRequired = false,
      this.hintStyle,
      this.titleStyle,
      this.fillColor,
      this.textAlign = TextAlign.start,
      this.headerRightElement,
      this.enableBorder = true,
      this.width,
      required this.prefixIconOnTap,
      this.borderColor,
      required this.country});

  @override
  _CustomCountryPickerState createState() => _CustomCountryPickerState();
}

class _CustomCountryPickerState extends State<CustomCountryPicker> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Section
        widget.header != null
            ? Row(
                children: [
                  Text(
                    widget.header!,
                    style: poppinsRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontSize: Dimensions.FONT_SIZE_DEFAULT),
                  ),
                  if (widget.isRequired)
                    Text(
                      " *",
                      style: poppinsRegular.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: Dimensions.FONT_SIZE_LARGE),
                    ),
                  const Spacer(),
                  widget.headerRightElement ?? const SizedBox(),
                ],
              )
            : const SizedBox(),
        SizedBox(
            height: widget.header != null ? Dimensions.PADDING_SIZE_SMALL : 0),

        // Text Field
        SizedBox(
          width: widget.width,
          child: TextFormField(
            textAlign: widget.textAlign!,
            onChanged: widget.onChanged,
            validator: widget.validator,
            maxLines: widget.maxLines,
            controller: widget.controller,
            focusNode: widget.focusNode,
            style: widget.titleStyle ??
                poppinsMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    color: widget.titleColor),
            textInputAction: widget.inputAction,
            keyboardType: TextInputType.phone,
            cursorColor: Theme.of(context).primaryColor,
            textCapitalization: widget.capitalization!,
            enabled: widget.isEnabled,
            autofocus: false,
            readOnly: widget.readOnly,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: widget.isPassword! ? _obscureText : false,
            decoration: widget.enableBorder
                ? InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      borderSide: BorderSide(
                        color: widget.borderColor ??
                            Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      borderSide: BorderSide(
                        color:
                            Theme.of(context).colorScheme.error.withOpacity(.7),
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      borderSide: BorderSide(
                        color:
                            Theme.of(context).colorScheme.error.withOpacity(.7),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      borderSide: BorderSide(
                        color: Theme.of(context).disabledColor.withOpacity(.3),
                        width: 1,
                      ),
                    ),
                    isDense: true,
                    hintText: widget.hintText,
                    fillColor: widget.fillColor ??
                        Theme.of(context).scaffoldBackgroundColor,
                    hintStyle: widget.hintStyle ??
                        poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            fontWeight: FontWeight.w300,
                            color: widget.hintColorEnable
                                ? widget.hintColor ?? Colors.black
                                : Theme.of(context).disabledColor),
                    filled: true,
                    prefixIcon: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.prefixIconOnTap,
                      child: Container(
                        width: 90,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${widget.country.flagEmoji} ',
                                style: poppinsMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE - 8,
                                )),
                            Text('+${widget.country.phoneCode}',
                                style: poppinsMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT - 1,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ),
                    ),
                    suffixIcon: widget.isPassword!
                        ? IconButton(
                            icon: Icon(
                                size: 10,
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.3)),
                            onPressed: _toggle,
                          )
                        : null,
                  )
                : const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
