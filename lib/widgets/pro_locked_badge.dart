import 'package:flutter/material.dart';

/// A lock badge overlay widget that indicates a feature is Pro-only.
///
/// The badge is positioned at the top-right corner of its child widget
/// with a semi-transparent background and lock icon.
class ProLockedBadge extends StatelessWidget {
  /// The child widget that this badge overlays.
  final Widget child;

  /// Size of the badge. Default is 20.
  final double badgeSize;

  const ProLockedBadge({
    super.key,
    required this.child,
    this.badgeSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -badgeSize / 2,
          right: -badgeSize / 2,
          child: Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.lock,
              size: badgeSize * 0.6,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// A constrained version of the badge that limits child size.
  ///
  /// Useful for wrapping buttons and other interactive elements.
  static Widget constrained({
    required Widget child,
    double badgeSize = 20,
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ProLockedBadge(
        badgeSize: badgeSize,
        child: child,
      ),
    );
  }

  /// A button version that wraps an Icon or IconButton.
  static Widget icon({
    required IconData icon,
    required VoidCallback? onPressed,
    Color? color,
    double badgeSize = 20,
    double? iconSize,
  }) {
    return ProLockedBadge(
      badgeSize: badgeSize,
      child: Icon(
        icon,
        size: iconSize,
        color: color?.withOpacity(0.5) ?? Colors.grey.withOpacity(0.5),
      ),
    );
  }
}
