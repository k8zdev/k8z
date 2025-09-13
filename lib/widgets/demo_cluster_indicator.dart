import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';

/// 演示集群指示器组件
class DemoClusterIndicator extends StatelessWidget {
  final bool isDemo;
  final bool isReadOnly;
  final bool showText;

  const DemoClusterIndicator({
    super.key,
    required this.isDemo,
    required this.isReadOnly,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDemo && !isReadOnly) {
      return const SizedBox.shrink();
    }

    final lang = S.of(context);
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDemo ? Colors.orange.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDemo ? Colors.orange : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDemo ? Icons.play_circle_outline : Icons.lock_outline,
            size: 12,
            color: isDemo ? Colors.orange : Colors.grey,
          ),
          if (showText) ...[
            const SizedBox(width: 4),
            Text(
              isDemo ? lang.demo_cluster_indicator : lang.readonly_indicator,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDemo ? Colors.orange : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}