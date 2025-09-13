import 'package:flutter/material.dart';
import 'package:k8zdev/services/onboarding_guide_service.dart';

/// Guide overlay widget that shows onboarding tips
class GuideOverlay extends StatefulWidget {
  final Widget child;
  final GuideStep currentStep;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final String? targetKey;

  const GuideOverlay({
    super.key,
    required this.child,
    required this.currentStep,
    required this.onNext,
    required this.onSkip,
    this.targetKey,
  });

  @override
  State<GuideOverlay> createState() => _GuideOverlayState();
}

class _GuideOverlayState extends State<GuideOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.currentStep != GuideStep.completed)
          _buildGuideOverlay(context),
      ],
    );
  }

  Widget _buildGuideOverlay(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Stack(
          children: [
            // Spotlight effect (optional)
            if (widget.targetKey != null) _buildSpotlight(),
            
            // Guide content
            _buildGuideContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotlight() {
    // This would require more complex implementation with RenderBox
    // For now, we'll use a simple approach
    return Container();
  }

  Widget _buildGuideContent(BuildContext context) {
    final theme = Theme.of(context);
    
    String title;
    String content;
    IconData icon;
    
    switch (widget.currentStep) {
      case GuideStep.welcome:
        title = '欢迎使用 K8zDev！';
        content = '让我们快速了解一下主要功能。这是一个演示集群，您可以安全地探索各种功能。';
        icon = Icons.waving_hand;
        break;
      case GuideStep.podList:
        title = '查看 Pods';
        content = '这里显示了集群中的所有 Pod。Pod 是 Kubernetes 中最小的部署单元。点击任意 Pod 可以查看详细信息。';
        icon = Icons.view_list;
        break;
      case GuideStep.podLogs:
        title = '查看日志';
        content = '您可以查看 Pod 的实时日志来了解应用程序的运行状态。这对于调试和监控非常有用。';
        icon = Icons.article;
        break;
      case GuideStep.additionalFeatures:
        title = '更多功能';
        content = 'K8zDev 还提供了许多其他功能，如查看服务、配置映射、密钥等。您可以在左侧菜单中探索这些功能。';
        icon = Icons.explore;
        break;
      case GuideStep.completed:
        title = '完成！';
        content = '太棒了！您已经了解了 K8zDev 的基本功能。现在您可以添加自己的集群或继续探索演示集群。';
        icon = Icons.check_circle;
        break;
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: theme.primaryColor,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Content
            Text(
              content,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip button
                TextButton(
                  onPressed: widget.onSkip,
                  child: Text(
                    '跳过',
                    style: TextStyle(color: theme.hintColor),
                  ),
                ),
                
                // Next button
                ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    widget.currentStep == GuideStep.additionalFeatures
                        ? '完成'
                        : '下一步',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}