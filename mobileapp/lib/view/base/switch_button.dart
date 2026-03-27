// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

class SwitchButton extends StatefulWidget {
  final String title;
  final bool? isButtonActive;
  final Function? onTap;
  const SwitchButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.isButtonActive});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool? _buttonActive;

  @override
  void initState() {
    super.initState();

    _buttonActive = widget.isButtonActive;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_SMALL,
        vertical: _buttonActive != null
            ? Dimensions.PADDING_SIZE_EXTRA_SMALL
            : Dimensions.PADDING_SIZE_DEFAULT,
      ),
      child: Row(children: [
        Expanded(
            child: Text(widget.title,
                textAlign: TextAlign.right,
                style: poppinsRegular.copyWith(
                    color: Get.isDarkMode
                        ? Colors.white
                        : Theme.of(context).disabledColor))),
        const SizedBox(
          width: Dimensions.PADDING_SIZE_SMALL,
        ),

        // Switch Button Section
        _buttonActive != null
            ? Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: _buttonActive!,
                  onChanged: (bool isActive) {
                    if (_buttonActive != null) {
                      setState(() {
                        _buttonActive = !_buttonActive!;
                      });
                    }
                    widget.onTap!();
                  },
                  activeColor: Theme.of(context).indicatorColor,
                  activeTrackColor: Theme.of(context).primaryColor,
                ),
              )
            : const SizedBox(),
      ]),
    );
  }
}
