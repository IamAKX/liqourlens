import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/theme.dart';
import 'gaps.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      required this.isDisabled,
      required this.isLoading})
      : super(key: key);
  final VoidCallback onPressed;
  final String label;
  final bool isDisabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(defaultPadding * 3)),
          color: isDisabled ? Colors.grey.withOpacity(0.85) : primaryColor,
        ),
        child: Center(
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: background,
                      ),
                    ),
                    horizontalGap(20),
                    const Text(
                      'Please wait ...',
                      style: TextStyle(
                          color: background,
                          fontSize: 20.0,
                          letterSpacing: 1.0),
                    ),
                  ],
                )
              : Text(
                  label,
                  style: const TextStyle(
                      color: background,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      letterSpacing: 1.0),
                ),
        ),
      ),
    );
  }
}
