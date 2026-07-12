import 'package:flutter/material.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Column(
      children: [
        _buildHeader(context, colors, typography),
        const Divider(height: 1),
        Expanded(child: _buildCenter(colors, typography)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, DesktopColorScheme colors, DesktopTextStyle typography) {
    return Container(
      padding: const EdgeInsets.all(DesktopTokens.spaceSm),
      color: colors.surface,
      child: Row(
        children: [
          Text('Widgets Demo', style: typography.label),
          const Spacer(),
          DesktopButton(
            label: 'Open Dialog',
            icon: Icons.open_in_new,
            variant: DesktopButtonVariant.secondary,
            onPressed: () => _showExampleDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCenter(DesktopColorScheme colors, DesktopTextStyle typography) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.widgets, size: 48, color: colors.textTertiary),
          const SizedBox(height: DesktopTokens.spaceLg),
          Text('desktop_ui_kit', style: typography.heading3),
          const SizedBox(height: DesktopTokens.spaceSm),
          Text('A Flutter desktop UI kit for Windows, macOS & Linux', style: typography.body),
          const SizedBox(height: DesktopTokens.spaceXxl),
          _buildButtonShowcase(),
        ],
      ),
    );
  }

  Widget _buildButtonShowcase() {
    return Wrap(
      spacing: DesktopTokens.spaceMd,
      children: [
        DesktopButton(label: 'Primary', icon: Icons.star, onPressed: () {}),
        DesktopButton(label: 'Secondary', variant: DesktopButtonVariant.secondary, onPressed: () {}),
        DesktopButton(label: 'Ghost', variant: DesktopButtonVariant.ghost, onPressed: () {}),
        DesktopButton(label: 'Danger', variant: DesktopButtonVariant.danger, onPressed: () {}),
      ],
    );
  }

  void _showExampleDialog(BuildContext context) {
    DesktopDialog.show(
      context,
      DesktopDialog(
        title: 'Example Dialog',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('This is an example dialog'),
            const SizedBox(height: DesktopTokens.spaceLg),
            DesktopDataTable(
              columns: [
                DesktopColumn(header: 'Name', width: 120, sortable: true, cellBuilder: (v) => Text('$v')),
                DesktopColumn(header: 'Value', width: 80, sortable: true, cellBuilder: (v) => Text('$v')),
              ],
              rows: [
                {'Name': 'Alpha', 'Value': 100},
                {'Name': 'Beta', 'Value': 200},
                {'Name': 'Gamma', 'Value': 300},
              ],
            ),
          ],
        ),
        actions: [
          DesktopButton(label: 'Cancel', variant: DesktopButtonVariant.secondary, onPressed: () => Navigator.of(context).pop()),
          DesktopButton(label: 'Confirm', onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}
