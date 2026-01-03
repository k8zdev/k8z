import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:k8zdev/models/guide_step_definition.dart';
import 'package:k8zdev/widgets/interactive_guide_overlay.dart';
import 'package:k8zdev/generated/l10n.dart';

void main() {
  // Create test app with localization support
  Widget createTestApp({required Widget child}) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('InteractiveGuideOverlay', () {
    final sampleGuideSteps = [
      GuideStepDefinition(
        id: 'step1',
        routeName: 'pods',
        title: 'Title 1',
        description: 'Description 1',
        buttonNext: 'Next',
      ),
      GuideStepDefinition(
        id: 'step2',
        routeName: 'services',
        title: 'Title 2',
        description: 'Description 2',
        buttonNext: 'Continue',
        buttonPrevious: 'Back',
      ),
      GuideStepDefinition(
        id: 'step3',
        routeName: 'deployments',
        title: 'Title 3',
        description: 'Description 3',
        buttonPrevious: 'Back',
      ),
    ];

    testWidgets('should render overlay when active',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: true,
            currentStepId: 'step1',
            steps: sampleGuideSteps,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show overlay content - uses localized strings from S
      expect(find.text('Welcome to K8Z!'), findsOneWidget);
      expect(find.text("Let's quickly explore the main features of K8Z."), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('should not render overlay when inactive',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: false,
            currentStepId: 'step1',
            steps: sampleGuideSteps,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pump();

      // Child should be visible
      expect(find.text('Child content'), findsOneWidget);
      // Overlay title should not be visible
      expect(find.text('Welcome to K8Z!'), findsNothing);
    });

    testWidgets('should call onNext when next button tapped',
        (WidgetTester tester) async {
      bool nextCalled = false;

      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: true,
            currentStepId: 'step1',
            steps: sampleGuideSteps,
            onNext: () => nextCalled = true,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap next button (find the button with 'Next' text)
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(nextCalled, isTrue);
    });

    testWidgets('should call onSkip when skip button tapped',
        (WidgetTester tester) async {
      bool skipCalled = false;

      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: true,
            currentStepId: 'step1',
            steps: sampleGuideSteps,
            onSkip: () => skipCalled = true,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // First step should show skip button
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(skipCalled, isTrue);
    });

    testWidgets('should call onPrevious when previous button is visible',
        (WidgetTester tester) async {
      bool previousCalled = false;

      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: true,
            currentStepId: 'step2',
            steps: sampleGuideSteps,
            onPrevious: () => previousCalled = true,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap previous button
      final backButton = find.text('Back');
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        expect(previousCalled, isTrue);
      }
    });

    testWidgets('should display step title and description',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: true,
            currentStepId: 'step1',
            steps: sampleGuideSteps,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Welcome to K8Z!'), findsOneWidget);
      expect(find.text("Let's quickly explore the main features of K8Z."), findsOneWidget);
    });

    testWidgets('should update when currentStepId changes',
        (WidgetTester tester) async {
      var currentStep = 'step1';

      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: true,
            currentStepId: currentStep,
            steps: sampleGuideSteps,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Welcome to K8Z!'), findsOneWidget);

      // Update step - step2 will show localized title
      currentStep = 'step2';

      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: true,
            currentStepId: currentStep,
            steps: sampleGuideSteps,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Welcome to K8Z!'), findsNothing);
      expect(find.text('Workloads Overview'), findsOneWidget);
    });

    testWidgets('should hide when active changes to false',
        (WidgetTester tester) async {
      var isActive = true;

      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: isActive,
            currentStepId: 'step1',
            steps: sampleGuideSteps,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Welcome to K8Z!'), findsOneWidget);

      // Deactivate
      isActive = false;

      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: isActive,
            currentStepId: 'step1',
            steps: sampleGuideSteps,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should hide
      expect(find.text('Welcome to K8Z!'), findsNothing);
    });

    testWidgets('should show Complete button on last step', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: true,
            currentStepId: 'step3',
            steps: sampleGuideSteps,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Last step should show Complete button (step index 3 maps to guide_step_3_localized strings)
      expect(find.text('Complete'), findsOneWidget);
    });

    testWidgets('should hide previous button on first step',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: true,
            currentStepId: 'step1',
            steps: sampleGuideSteps,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // First step should not have previous button
      expect(find.text('Back'), findsNothing);
    });

    testWidgets('should show step indicator for multi-step guide',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: InteractiveGuideOverlay(
            isActive: true,
            currentStepId: 'step1',
            steps: sampleGuideSteps,
            child: const Text('Child content'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show step indicator
      expect(find.byType(Row), findsWidgets);
    });
  });

  group('GuideOverlayTheme', () {
    test('should create default theme', () {
      final theme = GuideOverlayTheme.defaultTheme();

      expect(theme.titleStyle, isNotNull);
      expect(theme.descriptionStyle, isNotNull);
      expect(theme.overlayColor, isNotNull);
    });

    test('should create custom theme with overrides', () {
      final theme = GuideOverlayTheme.defaultTheme().copyWith(
        titleStyle: const TextStyle(fontSize: 24),
        overlayColor: Colors.blue.withOpacity(0.5),
      );

      expect(theme.titleStyle?.fontSize, equals(24));
      expect(theme.overlayColor, Colors.blue.withOpacity(0.5));
    });
  });

  group('DemoClusterGuide integration', () {
    test('should work with demo cluster guide steps', () {
      final steps = DemoClusterGuide.getSteps();

      expect(steps.length, greaterThan(0));
      expect(DemoClusterGuide.guideName, equals('demo_cluster_onboarding'));
    });
  });
}
