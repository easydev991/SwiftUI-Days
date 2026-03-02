# AGENTS.md

Guidelines for coding agents working on SwiftUI-Days.

## Project Overview

SwiftUI-Days is a countdown/tracker app built with SwiftUI, SwiftData, and modern Swift concurrency.

For general project information, see [README.md](README.md).

## Build/Test Commands

### Run Tests

Use XcodeBuildMCP tools (preferred) or `make test` as fallback.

### Build (Compilation Check)

Use XcodeBuildMCP tools (preferred) or `make build` as fallback.

### Format Code

```bash
make format
```

Runs swiftformat and markdownlint. Always run before committing.

## Code Style

### Imports

- Order: Foundation → Apple frameworks (SwiftUI, SwiftData, Observation) → third-party → local
- Separate groups with blank lines
- Use `@testable import SwiftUI_Days` in tests (note underscore)

```swift
import Foundation
import SwiftData
import SwiftUI

// Code here
```

### Formatting (.swiftformat)

- `--ifdef no-indent` - don't indent #if blocks
- `--header strip` - remove file headers
- `--trailingCommas never` - no trailing commas in multiline

### Types

- Use `@Observable` for shared state services
- Use `@Model` for SwiftData entities
- Use `@State`/`@Binding` for local view state
- Prefer `final class` for reference types
- Use `enum` for configuration options (e.g., `DisplayOption`)

### Naming Conventions

- Files: PascalCase matching the primary type (e.g., `Item.swift`, `AppSettings.swift`)
- Screens: `*Screen.swift` suffix (e.g., `RootScreen.swift`, `ItemScreen.swift`)
- Extensions: `Type+.swift` (e.g., `View+.swift`, `Color+Hex.swift`)
- Services: Plain nouns (e.g., `AppSettings`, `FeedbackSender`)
- Models: Plain nouns (e.g., `Item`, `DisplayOption`)
- Environment keys: `*EnvironmentKey.swift`

### State Management

- Local state: `@State`, `@Binding`
- Shared services: `@Observable` + `@Environment(ServiceType.self)`
- SwiftData: `@Model`, `@Query`, `@Environment(\.modelContext)`
- Do NOT nest `@Observable` objects inside each other

### Error Handling

- Use `do/try/catch` with `.task` for async operations
- Use `try?` for optional conversions where failure is expected
- Fatal errors acceptable in app initialization failures

### Services/DI

- Services go in `SwiftUI-Days/Services/`
- Inject at app level via `.environment(serviceInstance)`
- Access via `@Environment(ServiceType.self)`

### Testing (Swift Testing)

```swift
import Foundation
import SwiftUI
@testable import SwiftUI_Days
import Testing

@Suite("Test suite name")
struct MyTests {
    @Test func testName() throws {
        let value = try #require(optionalValue)
        #expect(value == expected)
    }
    
    @Test(arguments: [1, 2, 3])
    func parameterizedTest(input: Int) {
        #expect(input > 0)
    }
}
```

- Use `@Suite` for test struct with Russian description
- Use `@Test` for test functions
- Use `#expect` for assertions (not `XCTAssert`)
- Use `try #require` for unwrapping optionals
- Use `@Test(arguments:)` for parameterized tests

### Comments

- NO file headers (stripped by swiftformat)
- Doc comments (`///`) for public interfaces
- Russian language acceptable in test descriptions

## Project Structure

```
SwiftUI-Days/
├── SwiftUI_DaysApp.swift      # App entry point, DI
├── EnvironmentKeys/           # Custom Environment keys
├── Extensions/                # Extensions and utilities
├── Models/                    # Domain models, types
├── Preview Content/           # Preview data
├── Screens/                   # Views and screens
│   ├── CommonViews/          # Reusable components
│   ├── Detail/               # Item detail screens
│   ├── Main/                 # Main list screen
│   └── More/                 # Settings, about
├── Services/                  # Shared services
└── SupportingFiles/           # Assets, plist, localization
```

## Key Files to Reference

- Entry point + DI: `SwiftUI_DaysApp.swift`
- Main model: `Models/Item.swift`
- Settings service: `Services/AppSettings.swift`
- Sample tests: `SwiftUI-DaysTests/ItemTests.swift`
