import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';

/// A content area that displays one of multiple child views based on the active tab.
///
/// Pairs with [DesktopTabBar] to create a complete tabbed interface.
/// Supports lazy loading, animated transitions, and custom empty states.
///
/// Example:
/// ```dart
/// DesktopTabView(
///   selectedId: _selectedTab,
///   tabs: {
///     'editor': DesktopTabContent(child: CodeEditor()),
///     'preview': DesktopTabContent(child: PreviewPanel()),
///   },
///   empty: Center(child: Text('No tabs open')),
/// )
/// ```
class DesktopTabView extends StatefulWidget {
  /// The ID of the currently selected tab.
  final String? selectedId;

  /// Map of tab IDs to their content.
  final Map<String, DesktopTabContent> tabs;

  /// Widget to display when no tab is selected or tabs map is empty.
  final Widget? empty;

  /// Duration for tab transition animations.
  final Duration transitionDuration;

  /// Curve for tab transition animations.
  final Curve transitionCurve;

  /// Creates a desktop tab view.
  const DesktopTabView({
    super.key,
    this.selectedId,
    required this.tabs,
    this.empty,
    this.transitionDuration = DesktopTokens.durationNormal,
    this.transitionCurve = Curves.easeInOut,
  });

  @override
  State<DesktopTabView> createState() => _DesktopTabViewState();
}

class _DesktopTabViewState extends State<DesktopTabView> {
  String? _previousId;

  @override
  void didUpdateWidget(DesktopTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedId != oldWidget.selectedId) {
      _previousId = oldWidget.selectedId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;

    if (widget.selectedId == null || !widget.tabs.containsKey(widget.selectedId)) {
      return Semantics(label: 'Tab view - empty', child: _buildEmpty(colors));
    }

    final content = widget.tabs[widget.selectedId]!;

    if (_previousId != widget.selectedId) {
      return Semantics(label: 'Tab view - ${widget.selectedId}', child: _buildAnimatedTransition(colors, content));
    }

    return Semantics(label: 'Tab view - ${widget.selectedId}', child: _buildContent(colors, content));
  }

  Widget _buildEmpty(DesktopColorScheme colors) {
    return widget.empty ??
        Center(
          child: Text(
            'No content',
            style: TextStyle(color: colors.textDisabled),
          ),
        );
  }

  Widget _buildAnimatedTransition(DesktopColorScheme colors, DesktopTabContent content) {
    return AnimatedSwitcher(
      duration: widget.transitionDuration,
      switchInCurve: widget.transitionCurve,
      switchOutCurve: widget.transitionCurve,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.02, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(widget.selectedId),
        child: _buildContent(colors, content),
      ),
    );
  }

  Widget _buildContent(DesktopColorScheme colors, DesktopTabContent content) {
    return Container(
      color: content.background ?? colors.surfaceContainer,
      child: content.child,
    );
  }
}

/// Defines the content for a single tab in a [DesktopTabView].
class DesktopTabContent {
  /// The child widget to display.
  final Widget child;

  /// Optional background color override.
  final Color? background;

  /// Whether to lazily build this content only when the tab is first selected.
  ///
  /// Defaults to false. Set to true for expensive views that shouldn't
  /// be built until needed.
  final bool lazy;

  /// Creates tab content.
  const DesktopTabContent({
    required this.child,
    this.background,
    this.lazy = false,
  });
}
