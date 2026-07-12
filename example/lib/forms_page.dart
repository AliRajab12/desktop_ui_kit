import 'package:flutter/material.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

class FormsPage extends StatefulWidget {
  const FormsPage({super.key});

  @override
  State<FormsPage> createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  String? _dropdownValue;
  bool _checkbox1 = true;
  bool _checkbox2 = false;
  bool? _checkbox3;
  String _radioValue = 'option1';
  bool _switch1 = true;
  bool _switch2 = false;

  @override
  Widget build(BuildContext context) {
    final typography = DesktopTheme.of(context).typography;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesktopTokens.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Form Controls', style: typography.heading2),
          const SizedBox(height: DesktopTokens.spaceXxl),
          _Section('Text Fields', children: [
            DesktopTextField(label: 'Email', hint: 'you@example.com', prefixIcon: Icons.email, helper: 'We will never share your email'),
            DesktopTextField(label: 'Password', hint: 'Enter password', obscureText: true, prefixIcon: Icons.lock, suffixIcon: Icons.visibility),
            DesktopTextField(label: 'With Error', hint: 'Invalid input', error: 'This field is required'),
            DesktopTextField(label: 'Disabled', hint: 'Cannot edit', disabled: true),
          ]),
          const SizedBox(height: DesktopTokens.spaceXxl),
          _Section('Dropdown', children: [
            DesktopDropdown<String>(
              label: 'Country',
              value: _dropdownValue,
              hint: 'Select country',
              options: const [
                DropdownOption(value: 'us', label: 'United States', icon: Icons.flag),
                DropdownOption(value: 'uk', label: 'United Kingdom', icon: Icons.flag),
                DropdownOption(value: 'de', label: 'Germany', icon: Icons.flag),
                DropdownOption(value: 'fr', label: 'France', icon: Icons.flag),
                DropdownOption(value: 'jp', label: 'Japan', icon: Icons.flag),
              ],
              onChanged: (v) => setState(() => _dropdownValue = v),
            ),
          ]),
          const SizedBox(height: DesktopTokens.spaceXxl),
          _Section('Checkboxes', children: [
            DesktopCheckbox(value: _checkbox1, label: 'Enable notifications', onChanged: (v) => setState(() => _checkbox1 = v ?? false)),
            DesktopCheckbox(value: _checkbox2, label: 'Subscribe to newsletter', onChanged: (v) => setState(() => _checkbox2 = v ?? false)),
            DesktopCheckbox(value: _checkbox3, label: 'Indeterminate state', onChanged: (v) => setState(() => _checkbox3 = v)),
            const DesktopCheckbox(value: false, label: 'Disabled', disabled: true),
          ]),
          const SizedBox(height: DesktopTokens.spaceXxl),
          _Section('Radio Buttons', children: [
            DesktopRadio<String>(value: 'option1', groupValue: _radioValue, label: 'Option 1', onChanged: (v) => setState(() => _radioValue = v ?? 'option1')),
            DesktopRadio<String>(value: 'option2', groupValue: _radioValue, label: 'Option 2', onChanged: (v) => setState(() => _radioValue = v ?? 'option1')),
            DesktopRadio<String>(value: 'option3', groupValue: _radioValue, label: 'Option 3', onChanged: (v) => setState(() => _radioValue = v ?? 'option1')),
            const DesktopRadio<String>(value: 'disabled', groupValue: null, label: 'Disabled', disabled: true),
          ]),
          const SizedBox(height: DesktopTokens.spaceXxl),
          _Section('Switches', children: [
            DesktopSwitch(value: _switch1, label: 'Dark mode', onChanged: (v) => setState(() => _switch1 = v)),
            DesktopSwitch(value: _switch2, label: 'Enable analytics', onChanged: (v) => setState(() => _switch2 = v)),
            const DesktopSwitch(value: false, label: 'Disabled', disabled: true),
          ]),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, {required this.children});

  @override
  Widget build(BuildContext context) {
    final typography = DesktopTheme.of(context).typography;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: typography.heading4),
        const SizedBox(height: DesktopTokens.spaceLg),
        Wrap(spacing: DesktopTokens.spaceXl, runSpacing: DesktopTokens.spaceLg, children: [for (final c in children) SizedBox(width: 280, child: c)]),
      ],
    );
  }
}
