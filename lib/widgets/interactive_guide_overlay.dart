import 'package:flutter/material.dart';
import 'package:k8zdev/models/guide_step_definition.dart';

/// Theme configuration for the guide overlay
class GuideOverlayTheme {
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final Color? overlayColor;
  final Color? widgetShapeColor;
  final TextStyle? buttonNextStyle;
  final TextStyle? buttonSkipStyle;
  final TextStyle? buttonPreviousStyle;
  final Alignment? contentAlignment;
  final EdgeInsets? contentPadding;

  const GuideOverlayTheme({
    this.titleStyle,
    this.descriptionStyle,
    this.overlayColor,
    this.widgetShapeColor,
    this.buttonNextStyle,
    this.buttonSkipStyle,
    this.buttonPreviousStyle,
    this.contentAlignment,
    this.contentPadding,
  });

  /// Default theme for the guide overlay
  factory GuideOverlayTheme.defaultTheme() {
    return GuideOverlayTheme(
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      descriptionStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
      overlayColor: Colors.black.withOpacity(0.7),
      widgetShapeColor: Colors.blue,
      contentAlignment: Alignment.center,
      contentPadding: const EdgeInsets.all(24),
    );
  }

  /// Copy with new values
  GuideOverlayTheme copyWith({
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    Color? overlayColor,
    Color? widgetShapeColor,
    TextStyle? buttonNextStyle,
    TextStyle? buttonSkipStyle,
    TextStyle? buttonPreviousStyle,
    Alignment? contentAlignment,
    EdgeInsets? contentPadding,
  }) {
    return GuideOverlayTheme(
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      overlayColor: overlayColor ?? this.overlayColor,
      widgetShapeColor: widgetShapeColor ?? this.widgetShapeColor,
      buttonNextStyle: buttonNextStyle ?? this.buttonNextStyle,
      buttonSkipStyle: buttonSkipStyle ?? this.buttonSkipStyle,
      buttonPreviousStyle:
          buttonPreviousStyle ?? this.buttonPreviousStyle,
      contentAlignment: contentAlignment ?? this.contentAlignment,
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }
}

/// Interactive guide overlay widget
///
/// This widget provides an interactive onboarding experience with:
/// - Step navigation with next/previous/skip buttons
/// - Customizable theming
/// - Integration with the app's routing system
///
/// The overlay displays a dimmed background with a centered content card.
/// For more advanced features like target highlighting, integrate with
/// tutorial_coach_mark or similar packages.
class InteractiveGuideOverlay extends StatefulWidget {
  /// Whether the guide is active
  final bool isActive;

  /// Current step ID
  final String? currentStepId;

  /// Complete list of guide steps
  final List<GuideStepDefinition> steps;

  /// Callback when next button is pressed
  final VoidCallback? onNext;

  /// Callback when skip button is pressed
  final VoidCallback? onSkip;

  /// Callback when previous button is pressed
  final VoidCallback? onPrevious;

  /// Custom theme for the guide overlay
  final GuideOverlayTheme? theme;

  /// Child widget to display the overlay over
  final Widget child;

  const InteractiveGuideOverlay({
    super.key,
    required this.isActive,
    required this.currentStepId,
    required this.steps,
    required this.child,
    this.onNext,
    this.onSkip,
    this.onPrevious,
    this.theme,
  });

  @override
  State<InteractiveGuideOverlay> createState() => _InteractiveGuideOverlayState();
}

class _InteractiveGuideOverlayState extends State<InteractiveGuideOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _updateStep();

    // Start animation if overlay is initially active
    if (widget.isActive) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(InteractiveGuideOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update when active state or step changes
    if (oldWidget.isActive != widget.isActive ||
        oldWidget.currentStepId != widget.currentStepId) {
      _updateStep();
      setState(() {
        if (widget.isActive) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateStep() {
    if (!widget.isActive || widget.currentStepId == null) {
      _currentStepIndex = -1;
      return;
    }

    _currentStepIndex = widget.steps.indexWhere(
      (step) => step.id == widget.currentStepId,
    );
  }

  GuideStepDefinition? get _currentStep {
    if (_currentStepIndex < 0 || _currentStepIndex >= widget.steps.length) {
      return null;
    }
    return widget.steps[_currentStepIndex];
  }

  @override
  Widget build(BuildContext context) {
    // Ensure step index is updated on each build (handles direct widget creation)
    _updateStep();

    if (!widget.isActive || _currentStep == null) {
      return widget.child;
    }

    final theme = widget.theme ?? GuideOverlayTheme.defaultTheme();
    final isLastStep = _currentStepIndex == widget.steps.length - 1;
    final isFirstStep = _currentStepIndex == 0;

    return Stack(
      children: [
        widget.child,
        // Overlay content with fade animation
        FadeTransition(
          opacity: _fadeAnimation,
          child: ColoredBox(
            color: theme.overlayColor ?? Colors.black.withOpacity(0.7),
            child: Center(
              child: _buildGuideContent(
                _currentStep!,
                theme,
                isFirstStep,
                isLastStep,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuideContent(
    GuideStepDefinition step,
    GuideOverlayTheme theme,
    bool isFirstStep,
    bool isLastStep,
  ) {
    return Container(
      margin: const EdgeInsets.all(32),
      constraints: const BoxConstraints(
        maxWidth: 400,
        maxHeight: 500,
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: theme.contentPadding,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator
              if (widget.steps.length > 1) _buildStepIndicator(theme),
              const SizedBox(height: 16),
              // Title
              Text(
                step.title,
                style: theme.titleStyle ??
                    Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
              ),
              const SizedBox(height: 12),
              // Description
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    step.description,
                    style: theme.descriptionStyle ??
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                              height: 1.5,
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Buttons
              Row(
                children: [
                  // Skip button
                  TextButton(
                    onPressed: widget.onSkip,
                    child: Text(
                      step.buttonSkip ?? 'Skip',
                      style: theme.buttonSkipStyle ??
                          TextStyle(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ),
                  const Spacer(),
                  // Previous button
                  if (!isFirstStep)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextButton(
                        onPressed: widget.onPrevious,
                        child: Text(
                          step.buttonPrevious ?? 'Back',
                          style: theme.buttonPreviousStyle ??
                              TextStyle(
                                color: theme.widgetShapeColor ?? Colors.blue,
                              ),
                        ),
                      ),
                    ),
                  // Next/Complete button
                  ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.widgetShapeColor ?? Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      step.buttonNext ?? (isLastStep ? 'Complete' : 'Next'),
                      style: theme.buttonNextStyle ??
                          const TextStyle(
                            fontSize: 14,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(GuideOverlayTheme theme) {
    final primaryColor = theme.widgetShapeColor ?? Colors.blue;
    return Row(
      children: [
        const SizedBox(width: 8),
        ...List.generate(widget.steps.length, (index) {
          final isActive = index == _currentStepIndex;
          final isPast = index < _currentStepIndex;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 4,
            width: isActive ? 24 : 8,
            decoration: BoxDecoration(
              color: isActive
                  ? primaryColor
                  : isPast
                      ? primaryColor.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ],
    );
  }
}
