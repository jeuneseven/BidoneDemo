# BidoneDemo

A SwiftUI meal recipe browsing app built with **MVI (Model-View-Intent)** architecture, demonstrating clean code practices, comprehensive testing, and modern iOS development techniques.

<p align="center">
  <img src="fastlane/screenshots/en-US/iPhone 17 Pro-01_Categories.png" width="200" />
  <img src="fastlane/screenshots/en-US/iPhone 17 Pro-02_Meals.png" width="200" />
  <img src="fastlane/screenshots/en-US/iPhone 17 Pro-03_MealDetail_Top.png" width="200" />
  <img src="fastlane/screenshots/en-US/iPhone 17 Pro-04_MealDetail_Bottom.png" width="200" />
</p>

<p align="center">
  <img src="fastlane/screenshots/en-US/iPad Pro 13-inch (M5)-03_MealDetail_Top.png" width="600" />
</p>

## Features

- **Three-level navigation**: Categories → Meals → Meal Detail
- **iPhone & iPad support**: `NavigationSplitView` with three-column layout on iPad, automatic stack collapse on iPhone
- **Localization**: English and Simplified Chinese
- **Accessibility**: Full VoiceOver support with semantic labels
- **Dark Mode**: Automatic support via semantic system colors

## Architecture

The app follows the **MVI (Model-View-Intent)** pattern with unidirectional data flow:

```
User Action → Intent → Store → State → View
```

Each feature module contains four components:

| Component  | Role                             | Example                                  |
| ---------- | -------------------------------- | ---------------------------------------- |
| **Model**  | Data structures                  | `Category`, `Meal`, `MealDetail`         |
| **View**   | UI rendering, reacts to state    | `CategoriesView`, `MealsView`            |
| **Intent** | User action descriptors          | `CategoriesIntent.loadCategories`        |
| **Store**  | Business logic, state management | `CategoriesStore`                        |
| **State**  | Enum-based UI states             | `.idle`, `.loading`, `.loaded`, `.error` |

State management uses iOS 17's `@Observable` macro (Observation framework), providing automatic SwiftUI view updates without manual publishers.

## Project Structure

```
BidoneDemo/
├── App/
│   ├── BidoneDemoApp.swift
│   └── ContentView.swift          # NavigationSplitView (iPhone + iPad)
├── Core/
│   ├── Constants/
│   │   └── Constants.swift        # Design tokens, strings, network config
│   ├── Network/
│   │   └── NetworkService.swift   # Protocol-based network layer
│   └── Components/
│       ├── LoadingView.swift      # Reusable loading indicator
│       ├── ErrorView.swift        # Reusable error with retry
│       └── FlowLayout.swift       # Custom tag flow layout
├── Models/
│   ├── Category.swift
│   ├── Meal.swift
│   └── MealDetail.swift
├── Features/
│   ├── Categories/                # MVI module
│   │   ├── CategoriesView.swift
│   │   ├── CategoriesStore.swift
│   │   ├── CategoriesState.swift
│   │   └── CategoriesIntent.swift
│   ├── Meals/                     # MVI module
│   │   ├── MealsView.swift
│   │   ├── MealsStore.swift
│   │   ├── MealsState.swift
│   │   └── MealsIntent.swift
│   └── MealDetail/                # MVI module
│       ├── MealDetailView.swift
│       ├── MealDetailStore.swift
│       ├── MealDetailState.swift
│       └── MealDetailIntent.swift
├── Resources/
│   └── Localizable.xcstrings      # String catalog (en, zh-Hans)
├── BidoneDemoTests/               # Unit tests
└── BidoneDemoUITests/             # UI + Snapshot tests
```

## Tech Stack

| Category         | Technology                                     |
| ---------------- | ---------------------------------------------- |
| UI Framework     | SwiftUI                                        |
| Architecture     | MVI (Model-View-Intent)                        |
| State Management | Observation framework (`@Observable`)          |
| Minimum Target   | iOS 17                                         |
| Networking       | URLSession + async/await                       |
| Testing          | Swift Testing (`@Test`, `#expect`) + XCTest    |
| Linting          | SwiftLint (Build Phase)                        |
| CI/CD            | GitHub Actions                                 |
| Screenshots      | Fastlane Snapshot                              |
| API              | [TheMealDB](https://www.themealdb.com/api.php) |

## Testing

### Unit Tests (Swift Testing)

Focused on business logic with high coverage:

- **Store Tests** — `CategoriesStoreTests`, `MealsStoreTests`, `MealDetailStoreTests`: state transitions (idle → loading → loaded/error), retry logic, dependency injection with `MockNetworkService`
- **Model Tests** — Ingredient parsing, tag parsing, edge cases (nil, empty strings, whitespace)
- **JSON Decoding Tests** — Response parsing, null handling, empty arrays
- **Network Tests** — `APIEndpoint` URL construction, `NetworkError` descriptions

### UI Tests (XCTest)

Core user flow verification against live API:

- Categories list loading and display
- Navigation: Categories → Meals → Meal Detail
- Back navigation
- Detail content verification (ingredients, instructions, YouTube link)

### Screenshot Tests (Fastlane)

Automated screenshot capture for 4 key screens across iPhone 17 Pro and iPad Pro 13-inch (M5).

## Getting Started

### Prerequisites

- Xcode 16+ (developed with Xcode 26)
- iOS 17.0+ deployment target

### Run

1. Clone the repository
2. Open `BidoneDemo.xcodeproj` in Xcode
3. Select a simulator and press `⌘R`

No third-party dependencies or API keys required. The app uses the free TheMealDB API.

### Run Tests

```bash
# Unit tests
⌘U in Xcode

# Or via command line
xcodebuild test -project BidoneDemo.xcodeproj -scheme BidoneDemo -destination 'platform=iOS Simulator,name=iPhone 16'
```

### Capture Screenshots

```bash
bundle install
bundle exec fastlane screenshots
```

## CI/CD

GitHub Actions runs on every push to `main`/`master`/`dev` and on pull requests:

- **Build & Test**: Compiles the project and runs unit tests on macOS 15 with Xcode 16.2
- **SwiftLint**: Enforces code style via Build Phase script

## Design Decisions

### Why MVI over MVVM?

MVI enforces unidirectional data flow through explicit Intent → Store → State transitions. This makes state changes predictable and easily testable — each Store can be tested by sending intents and asserting resulting states. For an e-commerce context where order reliability is critical, predictable state management reduces the risk of inconsistent UI states that could lead to user confusion or data loss.

### Why `NavigationSplitView` with `NavigationLink`?

The app uses `NavigationSplitView` to support both iPhone and iPad with a single navigation structure. On iPad, it provides a familiar three-column layout (categories sidebar → meals list → detail). On iPhone, it collapses automatically into a push-based stack. Meal cards use `NavigationLink(value:)` with `.navigationDestination(for:)` to ensure reliable push navigation in both collapsed (iPhone) and expanded (iPad) modes — a critical pattern since `onTapGesture`-based binding updates alone don't trigger push navigation in collapsed `NavigationSplitView`.

### Why protocol-based networking?

`NetworkServiceProtocol` enables dependency injection for testing. Stores accept the protocol in their initializer with a default production implementation, making it easy to inject `MockNetworkService` in tests. This pattern also supports future scenarios like offline caching or request retry strategies — essential for applications where data loss is unacceptable.

### Why `@Observable` over Combine?

The Observation framework (iOS 17+) provides automatic, fine-grained view updates with simpler syntax than `ObservableObject` + `@Published`. It eliminates boilerplate while providing better performance through selective observation.

### Reliability-first error handling

Every feature module's State enum includes an explicit `.error` case with retry capability. Network errors are classified by type (`serverError`, `decodingError`, `noData`) so the UI can present meaningful feedback. This design philosophy — making failure states explicit and recoverable — scales directly to critical flows like order submission where reliability is paramount.

### Centralized configuration for white-label readiness

All design tokens (spacing, corner radii, colors), strings, and network configuration are centralized in `Constants.swift`. Combined with `Localizable.xcstrings` for multi-language support, this structure allows theming and branding changes from a single point — a necessary foundation for white-label product distribution across different clients.

## Roadmap

- [ ] **Pull-to-refresh** — Add `.refreshable` to lists for intuitive content refresh
- [ ] **SPM modularization with TCA** — Extract features into Swift packages using [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) for scalable state management and modular codebase
- [ ] **Image caching** — Replace `AsyncImage` with a caching layer for smoother scrolling
- [ ] **Snapshot testing** — Visual regression tests with swift-snapshot-testing
- [ ] **Offline support** — Local persistence for previously loaded data

## License

This project is a technical demo for interview purposes.s