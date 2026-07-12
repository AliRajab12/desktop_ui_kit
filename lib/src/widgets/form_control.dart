import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

/// A wrapper for form controls (checkbox, radio, switch) that provides
/// consistent layout with label and child support.
///
/// Extracts the shared GestureDetector > MouseRegion > Row pattern
/// used by all form controls.
class DesktopFormControl extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget control;
  final String? label;
  final Widget? child;
  final bool disabled;

  const DesktopFormControl({
    super.key,
    required this.onTap,
    required this.control,
    this.label,
    this.child,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            control,
            if (label != null) ...[
              const SizedBox(width: DesktopTokens.spaceSm),
              Text(label!, style: typography.body.copyWith(color: disabled ? colors.textDisabled : colors.textPrimary)),
            ],
            if (child != null) ...[
              const SizedBox(width: DesktopTokens.spaceSm),
              child!,
            ],
          ],
        ),
      ),
    );
  }
}
