# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter-invader is a classic Space Invaders game built entirely with Flutter, demonstrating clean architecture principles and cross-platform game development without external game engines. The project showcases pure Flutter implementation with custom graphics rendering.

## Development Commands

### Essential Commands
```bash
# Install dependencies
flutter pub get

# Run development builds
flutter run -d chrome          # Web (primary development target)
flutter run -d ios            # iOS simulator
flutter run -d android        # Android emulator
flutter run -d macos          # macOS desktop

# Build for release
flutter build web             # Web deployment
flutter build apk --release   # Android APK
flutter build ios --release   # iOS build

# Testing
flutter test                  # Run all tests
flutter test --coverage      # Run tests with coverage

# Code analysis
flutter analyze              # Static analysis
```

## Architecture

### Layer Structure
- **Models** (`lib/models/`): Game entities (Player, Bullet, Invader, GameState)
- **Services** (`lib/services/`): Core game logic (GameEngine)
- **Screens** (`lib/screens/`): UI controllers (TitleScreen, GameScreen)
- **Widgets** (`lib/widgets/`): Reusable components (PixelButton, PauseMenu)
- **Painters** (`lib/painters/`): Custom graphics rendering (PixelPainters)
- **Utils** (`lib/utils/`): Game configuration constants

### Key Design Patterns
- **Entity Pattern**: Immutable game objects with `copyWith()` methods
- **State Management**: GameState with copyWith pattern for immutable updates
- **Service Layer**: GameEngine handles all game logic and collision detection
- **Custom Rendering**: CustomPainter for pixel art graphics at 60 FPS

### Core Game Loop
The game runs at 60 FPS using Timer.periodic in GameEngine service. Game state updates are immutable, creating new state objects via `copyWith()` method calls.

## Critical Configuration

### Game Constants (`lib/utils/constants.dart`)
- Game resolution: 400x600 pixels
- Frame rate: 60 FPS (16ms intervals)
- Player speed: 20.0 units
- Bullet speed: 5.0 units
- Max simultaneous bullets: 3
- Invader grid: 5 rows × 8 columns (40 total)

### State Management
GameState is the single source of truth with fields:
- `player`: Player position and state
- `bullets`: List of active bullets
- `invaders`: List of remaining invaders
- `score`: Current game score
- `status`: GameStatus enum (playing/paused/gameOver)

## Development Guidelines

### When Adding Features
1. **Game Logic**: Implement in GameEngine service, never in UI widgets
2. **State Changes**: Always use `copyWith()` pattern for immutable updates
3. **Collision Detection**: Add to GameEngine's collision detection system
4. **Graphics**: Use CustomPainter for consistent pixel art style
5. **Performance**: Maintain 60 FPS by avoiding expensive operations in paint methods

### Testing Approach
- Test game logic in GameEngine service independently of UI
- Mock Timer for predictable game loop testing
- Test state transitions using GameState.copyWith()
- The default test file needs updating (still references `MyApp` instead of `SpaceInvaderApp`)

### Platform Considerations
- **Web**: Primary development target, uses Chrome for testing
- **Mobile**: Touch controls automatically handled by Flutter
- **Desktop**: Keyboard input works across all desktop platforms
- Pure Flutter implementation means no platform-specific game engine dependencies

## AI Tool Integration

### Gemini CLI vs Claude Code Role Distribution

This project uses a hybrid approach with Gemini CLI and Claude Code for optimal development efficiency:

#### Gemini CLI Responsibilities
- **Web Search**: Research game mechanics, Flutter best practices, and troubleshooting
- **Asset Creation**: Generate game sprites, sound effects, and visual assets
- **Design Guidance**: UI/UX recommendations, color schemes, and visual design patterns
- **Documentation**: Create README updates, API documentation, and user guides
- **Content Generation**: Game storylines, level designs, and creative content

#### Claude Code Responsibilities  
- **Code Analysis**: Understanding existing codebase structure and patterns
- **Code Implementation**: Writing Dart/Flutter code, game logic, and UI components
- **Testing**: Unit tests, widget tests, and integration tests
- **Refactoring**: Code optimization, architecture improvements, and performance enhancements
- **Technical Debugging**: Fixing bugs, performance issues, and technical problems

#### Collaboration Workflow
1. **Planning Phase**: Gemini CLI researches requirements and creates design specifications
2. **Asset Phase**: Gemini CLI generates sprites, sounds, and visual materials
3. **Implementation Phase**: Claude Code implements features following the design
4. **Testing Phase**: Claude Code creates comprehensive tests
5. **Documentation Phase**: Gemini CLI creates user-facing documentation
6. **Optimization Phase**: Claude Code handles performance and code quality improvements

#### Command Integration
```bash
# Gemini CLI for research and assets
gemini "research Flutter game optimization techniques"
gemini "create pixel art sprites for space invaders"
gemini "write user manual for space invaders game"

# Claude Code for implementation
# (Used through claude.ai/code interface)
# - Code analysis and implementation
# - Test creation and debugging
# - Architecture refactoring
```

## Language Guidelines

### Communication Protocol
- **Internal Processing**: All thinking, analysis, and problem-solving should be conducted in English
- **Output Communication**: All responses and communications to users should be in Japanese
- **Code Comments**: English for technical accuracy and international compatibility
- **Documentation**: Japanese for user-facing content, English for technical specifications

### Rationale
This bilingual approach optimizes:
- **Processing Efficiency**: English provides precise technical vocabulary and clearer logical structure
- **User Experience**: Japanese ensures natural communication and accessibility
- **Code Maintainability**: English comments maintain international development standards
- **Collaboration**: Facilitates work with both Japanese and international development teams

## Code Quality Standards

### Immutable State Pattern
All game objects (Player, Bullet, Invader, GameState) implement immutable updates:
```dart
// Correct pattern
final newPlayer = player.copyWith(x: newX, y: newY);

// Avoid direct mutation
player.x = newX; // Don't do this
```

### Performance Requirements
- Maintain 60 FPS rendering
- Efficient collision detection algorithms
- CustomPainter optimizations for pixel art rendering
- Timer cleanup on widget disposal