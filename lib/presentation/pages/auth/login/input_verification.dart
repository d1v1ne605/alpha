import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasteInputFormatter extends TextInputFormatter {
  final int index;
  final Function(String) onPaste;

  PasteInputFormatter({required this.index, required this.onPaste});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > 1) {
      onPaste(newValue.text);
      String firstDigit = InputNumber.formatNumber(newValue.text);
      if (firstDigit.isNotEmpty) {
        return TextEditingValue(
          text: firstDigit[0],
          selection: TextSelection.collapsed(offset: 1),
        );
      }
      return oldValue;
    }
    return newValue;
  }
}

class InputVerification extends StatefulWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(String, int) onChanged;
  final bool autoFocus;

  const InputVerification({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.autoFocus,
  });

  @override
  State<InputVerification> createState() => _InputVerificationState();
}

class _InputVerificationState extends State<InputVerification> {
  void _handlePaste(String pastedText) {
    String digits = InputNumber.formatNumber(pastedText);
    int currentIndex = -1;
    for (int i = 0; i < 6; i++) {
      if (widget.focusNodes[i].hasFocus) {
        currentIndex = i;
        break;
      }
    }
    for (int i = currentIndex >= 0 ? currentIndex : 0; i < 6; i++) {
      widget.controllers[i].clear();
    }
    int startIndex = currentIndex >= 0 ? currentIndex : 0;
    for (int i = 0; i < digits.length && (startIndex + i) < 6; i++) {
      widget.controllers[startIndex + i].text = digits[i];
      widget.onChanged(digits[i], startIndex + i);
    }
    int nextIndex = startIndex + digits.length;
    if (nextIndex < 6) {
      widget.focusNodes[nextIndex].requestFocus();
    } else {
      widget.focusNodes[5].requestFocus();
    }
  }

  void _handleChange(String value, int index) {
    final digit = InputNumber.formatNumber(value);
    if (digit.isNotEmpty) {
      if (index < 5) {
        widget.focusNodes[index + 1].requestFocus();
      }
    }
    widget.onChanged(digit, index);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      final bool currentFieldHasText =
          widget.controllers[index].text.isNotEmpty;

      if (currentFieldHasText) {
        widget.controllers[index].clear();
        widget.onChanged('', index);
        return KeyEventResult.handled;
      } else if (index > 0) {
        widget.controllers[index - 1].clear();
        widget.onChanged('', index - 1);
        widget.focusNodes[index - 1].requestFocus();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) {
        return SizedBox(
          width: AppSize.size55.w,
          child: Focus(
            onKeyEvent: (node, event) => _handleKeyEvent(node, event, i),
            child: TextField(
              controller: widget.controllers[i],
              focusNode: widget.focusNodes[i],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              autofocus: widget.autoFocus && i == 0,
              showCursor: false,
              inputFormatters: [
                PasteInputFormatter(index: i, onPaste: _handlePaste),
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: AppTextStyles.heading1.copyWith(
                fontSize: AppSize.size24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                contentPadding: EdgeInsets.zero,
                fillColor: AppColors.secondary,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.size8),
                  borderSide: const BorderSide(
                    color: AppColors.borderInput,
                    width: AppSize.size1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.size8),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: AppSize.size2,
                  ),
                ),
              ),
              onChanged: (value) => _handleChange(value, i),
              onTap: () {
                widget.controllers[i].selection = TextSelection.fromPosition(
                  TextPosition(offset: widget.controllers[i].text.length),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
