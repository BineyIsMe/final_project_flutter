import 'package:flutter/material.dart';
import 'package:myapp/ui/widgets/custom_textfield.dart';

class InputWrapper extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final int maxLines;

  const InputWrapper({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hint: hint,
      icon: icon,
      maxLines: maxLines,
    );
  }
}
