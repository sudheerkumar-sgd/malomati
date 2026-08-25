import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

/// Masks the UI before OS snapshots and clears the clipboard in background.
class PrivacyGuard extends StatefulWidget {
  const PrivacyGuard({super.key, required this.child});

  final Widget child;

  @override
  State<PrivacyGuard> createState() => _PrivacyGuardState();
}

class _PrivacyGuardState extends State<PrivacyGuard>
    with WidgetsBindingObserver {
  bool _masked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final hide = state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden;
    if (hide) {
      Clipboard.setData(const ClipboardData(text: ''));
      if (!_masked && mounted) setState(() => _masked = true);
    } else if (state == AppLifecycleState.resumed) {
      if (_masked && mounted) setState(() => _masked = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_masked)
          const ColoredBox(
            color: Color(0xFFFFFFFF),
            child: Center(
              child: Image(
                image: AssetImage(DrawableAssets.appIcon),
                width: 96,
              ),
            ),
          ),
      ],
    );
  }
}
