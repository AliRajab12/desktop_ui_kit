import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';
import 'dropdown.dart';

/// The overlay panel for [DesktopDropdown]. Not part of the public API.
class DropdownOverlay<T> extends StatelessWidget {
  final LayerLink layerLink;
  final double width;
  final List<DropdownOption<T>> options;
  final T? selectedValue;
  final ValueChanged<T?> onSelect;
  final VoidCallback onClose;

  const DropdownOverlay({
    super.key,
    required this.layerLink,
    required this.width,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;

    return Stack(
      children: [
        GestureDetector(onTap: onClose, child: Container(color: Colors.transparent)),
        Positioned(
          width: width,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, DesktopTokens.inputHeight + 4),
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
              color: colors.surfaceContainer,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
                  border: Border.all(color: colors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final selected = option.value == selectedValue;
                    return InkWell(
                      onTap: option.disabled ? null : () => onSelect(option.value),
                      hoverColor: colors.surfaceHover,
                      child: Container(
                        height: DesktopTokens.inputHeight,
                        padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceMd),
                        color: selected ? colors.accent.withAlpha(25) : null,
                        child: Row(
                          children: [
                            if (option.icon != null) ...[
                              Icon(option.icon, size: DesktopTokens.iconSm, color: option.disabled ? colors.textDisabled : colors.textSecondary),
                              const SizedBox(width: DesktopTokens.spaceSm),
                            ],
                            Expanded(
                              child: Text(
                                option.label,
                                style: typography.bodySmall.copyWith(
                                  color: option.disabled ? colors.textDisabled : selected ? colors.accent : colors.textPrimary,
                                ),
                              ),
                            ),
                            if (selected) Icon(Icons.check, size: DesktopTokens.iconSm, color: colors.accent),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
