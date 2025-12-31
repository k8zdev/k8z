# Project Context

## Purpose

K8z is a cross-platform Kubernetes administration application built with Flutter, designed to provide mobile and desktop users with a convenient way to manage their Kubernetes clusters. The app allows users to add clusters from kubeconfig files, view cluster metrics, browse and manage Kubernetes resources (Pods, Deployments, Services, etc.), and perform common administrative tasks from iOS, iPadOS, macOS, Windows, and Linux devices.

Key capabilities include:
- Cluster management: add/delete clusters from kubeconfig, demo cluster for first-time users
- Resource viewing: browse Kubernetes resources organized by category (workloads, storage, config, networking)
- Metrics overview: cluster-level performance charts and health status
- Multi-cluster support with local persistence
- Multi-language support (English/Chinese)

## Tech Stack

### Frontend
- **Framework**: Flutter (Dart >=3.2.6 <4.0.0)
- **UI Libraries**: `google_nav_bar`, `settings_ui`, `geekyants_flutter_gauges`
- **State Management**: `provider` (Provider pattern)
- **Navigation**: `go_router`
- **Routing**: declarative deep-linking via `AppScope` + `MaterialApp.router`

### Backend (Native Layer)
- **Language**: Golang (compiled to native library)
- **Integration**: Flutter FFI for cross-language calls
- **Function**: Kubernetes API client with full auth support (token, cert, basic auth)
- **Components**:
  - k8z.dll / k8z.so / k8z.dylib (per platform)
  - Local HTTP server on port 29257 for API proxying

### Data Storage
- **Database**: SQLite via `sqflite`
- **Caching**: `stash` with `stash_sqlite` backend
- **Schema**: Cluster credentials, user preferences, session data

### External Services
- **Firebase**: Analytics, Crashlytics, Remote Config
- **RevenueCat**: In-app purchases and subscription management
- **App Store**: Native iOS distribution

### Key Dependencies
```
# Core
flutter sdk 3.2.6+
provider: state management
go_router: navigation
intl: localization

# K8s & Data
kubeconfig: K8s config parsing
sqflite: local database
stash: caching layer

# Utilities
talker_flutter: logging
connectivity_plus: network detection
file_selector: file picker
```

## Project Conventions

### Code Style
- **Formatting**: Use `flutter_lints` (analysis_options.yaml)
- **Naming**: camelCase for variables, PascalCase for classes, snake_case for files
- **Language**: English for code comments, Chinese for user-facing strings (via `flutter_intl`)
- **Nullable types**: Explicit nullability using Dart's sound null safety
- **Error handling**: Prefer explicit error returns over exceptions where possible

### Architecture Patterns

**Native Bridge Pattern**:
- Flutter Dart layer handles UI and state
- Golang native library (FFI) handles all Kubernetes API communication
- Requests proxied through local server (localhost:29257) for auth handling
- Isolate-based async requests to prevent blocking UI

**Layered Structure**:
```
lib/
├── services/       # Business logic, external service integrations
│   ├── k8z_service.dart      # K8s API client wrapper
│   ├── k8z_native.dart       # FFI native bridge
│   ├── demo_cluster_service.dart  # Demo cluster feature
│   ├── encryption_service.dart    # Data encryption
│   ├── analytics_service.dart     # Firebase analytics
│   └── revenuecat.dart           # Payment handling
│
├── providers/      # State management (Provider pattern)
│   ├── current_cluster.dart    # Selected cluster state
│   ├── theme.dart              # Theme mode (light/dark)
│   ├── lang.dart               # Localization state
│   ├── timeout.dart            # Request timeout config
│   └── terminals.dart          # Terminal sessions
│
├── models/         # Data models
│   ├── models.dart             # Core app models
│   ├── helm_release.dart       # Helm-related models
│   └── kubernetes/             # **Auto-generated** K8s API types
│
├── dao/            # Database access layer
│   └── kube.dart               # Cluster CRUD operations
│
├── pages/          # UI Screens
│   ├── k8s_list/               # Resource list pages
│   │   ├── workloads/          # Pods, Deployments, etc.
│   │   ├── resources/          # ConfigMaps, Secrets, Events, etc.
│   │   ├── cluster/            # Cluster management
│   │   └── networks/           # Services, Ingresses, etc.
│   ├── k8s_detail/             # Resource detail views
│   ├── workloads.dart          # Workloads overview
│   ├── resources.dart          # Resources overview
│   └── settings.dart           # App settings
│
├── widgets/        # Reusable UI components
│   ├── terminals.dart          # Terminal emulator (xterm)
│   ├── overview_metrics.dart   # Dashboard charts
│   ├── detail_widgets/         # Resource detail widgets
│   └── modal.dart              # Modal dialogs
│
├── common/         # Shared utilities
│   ├── ops.dart                # Common operations
│   ├── const.dart              # Constants
│   ├── styles.dart             # App-wide styles
│   └── resources/              # Resource-specific helpers
│
├── generated/      # **Auto-generated**, do NOT edit manually
│   └── l10n.dart               # Localization strings
│
└── main.dart       # App entry point
```

**Design Patterns**:
- Provider pattern for global state
- InheritedWidget (`AppScope`) for context propagation
- Repository pattern via DAO layer
- Service layer for external integrations
- Widget composition for reusable UI

### Testing Strategy
Our testing strategy follows a layered approach to balance development speed with quality assurance.

- **Unit Tests**: Use `flutter_test` for isolated testing of individual widgets, classes, and functions (e.g., in `services`, `providers`, `dao`).

- **BDD Integration Tests**: We use Behavior-Driven Development (BDD) for end-to-end integration testing, powered by the `flutter_gherkin` package. This allows us to write human-readable feature files that describe application behavior.
    - **Single Source of Truth**: All BDD tests (`.feature` and step files) are written once and stored in a dedicated test directory.
    - **Two-Tiered Execution**: We employ a two-tiered execution strategy using Gherkin tags to optimize for speed and coverage:
        - **Fast Feedback (macOS)**: The primary test suite runs on the macOS desktop build. It covers the majority of business logic and UI (`@logic`, `@smoke` tags). This suite is designed to be run frequently during development for rapid feedback.
        - **Critical Path (iOS)**: A smaller, targeted suite runs on an iOS simulator/device. It focuses on validating platform-specific integrations and critical user flows (`@smoke`, `@ios-critical` tags), such as in-app purchases, permissions, and final UI rendering on a mobile form factor.

- **Test Data**: Mock Kubernetes responses and a pre-defined demo cluster are used to ensure tests are repeatable and isolated from external dependencies.

### Git Workflow
- **Main branch**: `main` (production releases)
- **Development branch**: `dev/*` for feature branches
- **Commit format**: Follow conventional commits (see example below)
- **PR reviews**: Required before merging to main
- **Version tags**: Used for release management

**Commit Message Format**:
```
feat(scope): brief description

Add what was done in present tense.
Explain how it was implemented.
Fix any related issues.
Ensure tests pass.

Closes: #issue-number
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting (no logic changes)
- `refactor`: Code restructuring
- `test`: Test additions/changes
- `chore`: Build/tooling changes

## Domain Context

### Kubernetes Concepts
K8z follows standard Kubernetes terminology and API conventions:
- **Cluster**: A connected K8s cluster endpoint with authentication credentials
- **Namespace**: Logical partition within a cluster (default scoped unless specified)
- **Resources**: K8s API resources typed by GroupVersionKind (GVK)
- **Workloads**: Pods, Deployments, StatefulSets, DaemonSets, etc.
- **Storage**: PV, PVC, StorageClass
- **Config**: ConfigMap, Secret, ServiceAccount
- **Networking**: Service, Ingress, Endpoint

### Key Entities
- **K8zCluster**: Represents a connected cluster with credentials
  - `server`: API server endpoint
  - `namespace`: Current default namespace
  - `caData`, `clientCert`, `clientKey`: TLS certificates
  - `token`, `username`, `password`: Auth credentials
  - `isDemo`: Flag for demo/readonly clusters
  - `isReadonly`: Flag for read-only mode restriction

- **DemoCluster**: Special demo cluster for onboarding
  - Downloaded from `https://static.k8z.dev/k8z-demo/kubeconfig`
  - Read-only to prevent accidental changes
  - Encrypted config, decrypted with build-embedded key

## Important Constraints

### Platform Constraints
- **iOS**: Primary target platform, App Store distribution required
- **Desktop support**: macOS, Windows, Linux (window_manager)
- **Native library**: Must compile platform-specific shared libraries (dylib/dll/so)
- **FFI interface**: Stable cross-version contract required for Dart/Go bridge

### Security Constraints
- **Credential storage**: Clustering credentials encrypted in SQLite
- **Demo cluster**: Always read-only, restrict mutation operations
- **TLS verification**: Default secure mode with CA validation
- **Insecure skip**: Optional but discouraged, explicit UI warning required

### Performance Constraints
- **Request timeout**: Default 60s, configurable via UI
- **Concurrent requests**: Limited (use isolates for non-blocking)
- **Local server**: Single-instance binding on port 29257
- **Memory constraints**: Mobile devices have limited RAM, cache carefully

### Privacy Constraints
- **Analytics**: Firebase Analytics only for crash/error tracking and feature usage
- **No telemetry**: K8s data never sent to external servers
- **Credential privacy**: Never log or transmit cluster credentials

## External Dependencies

### Kubernetes API
- **Documentation**: https://kubernetes.io/docs/reference/kubernetes-api/
- **OpenAPI**: Used for auto-generating Dart models (lib/models/kubernetes/)
- **Versions**: Supports 1.27+ (verify compatibility on cluster addition)

### Services
| Service | Purpose | Authentication |
|---------|---------|----------------|
| Firebase Analytics | Crash reporting, usage stats | GoogleService-Info.plist |
| Firebase Crashlytics | Crash reporting | GoogleService-Info.plist |
| RevenueCat | In-app purchases | SDK API keys |
| App Store | iOS distribution | Apple Developer account |

### Build Tools
- **Flutter SDK**: >=3.2.6
- **CocoaPods**: iOS dependencies management
- **Go toolchain**: For compiling native library
- **icons_launcher**: Icon generation

### CI/CD (if configured)
- GitHub Actions or similar for automated builds
- App Store Connect integration for iOS releases
