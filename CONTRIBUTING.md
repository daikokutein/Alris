# Contributing to Alris

Thank you for considering contributing to Alris! This document provides guidelines and instructions for different teams working on the project, with special focus on AI model integration.

## Project Structure

```
alris/
├── lib/
│   ├── ai_models/           # AI functionality (for ML/AI team)
│   ├── screens/             # UI screens (for UI team)
│   ├── widgets/             # Reusable widgets
│   ├── utils/               # Utility classes and functions
│   └── main.dart            # App entry point
├── test/
│   ├── ai_models/           # Tests for AI functionality
│   └── widget_tests/        # UI tests
└── assets/
    └── images/              # App images and icons
```

## Team Responsibilities

### Frontend/UI Team
- Implement UI screens and interactions
- Handle state management
- Ensure responsive design
- Implement animations and transitions
- Connect to the AI module through the provided interfaces

### AI/ML Team
- Implement URL analysis functionality in `lib/ai_models/`
- Focus on the `ai_analyzer.dart` file which contains:
  - Interface definitions
  - Expected data structures
  - Placeholder implementation to be replaced
- Write tests in `test/ai_models/`
- See the dedicated [AI models README](lib/ai_models/README.md) for detailed instructions

## AI Module Implementation Guidelines

### Getting Started (AI Team)

1. Examine the interface in `lib/ai_models/ai_analyzer.dart`
2. Implement your AI functionality by creating a class that implements the `AIAnalyzer` interface
3. Your implementation can use:
   - On-device models (TensorFlow Lite, ML Kit)
   - API-based approaches (e.g., calling cloud AI services)
   - Hybrid approaches
4. Update tests in `test/ai_models/` to work with your implementation

### Integration Requirements

Your AI module MUST:
- Conform to the `AIAnalyzer` interface
- Handle errors gracefully
- Work offline if possible (or degrade gracefully)
- Provide meaningful analysis results
- Be efficient (minimal battery/CPU usage)
- Be well-tested

## Development Workflow

1. **Fork the repository**

2. **Clone your fork**
   ```
   git clone https://github.com/YOUR-USERNAME/alris.git
   ```

3. **Create a feature branch**
   ```
   git checkout -b feature/your-feature-name
   ```

4. **Implement your changes**
   - AI Team: Focus on the `lib/ai_models/` directory
   - UI Team: Focus on the `lib/screens/` and `lib/widgets/` directories

5. **Write/update tests**
   - Make sure your code is well-tested
   - Run tests using `flutter test`

6. **Run the analyzer**
   ```
   flutter analyze
   ```

7. **Submit a Pull Request**
   - Provide a clear description of your changes
   - Reference any relevant issues

## AI Module Testing

Test your AI module implementation thoroughly:

```
flutter test test/ai_models/
```

Be sure to test:
- Valid URLs
- Invalid URLs
- Edge cases (empty URLs, malformed URLs)
- Network failures (if using API)
- Model loading errors

## Communication

- Use GitHub Issues for bug reports and feature requests
- Tag issues appropriately:
  - `ai-model` for AI-related tasks
  - `ui` for interface-related tasks
  - `bug` for bugs
  - `enhancement` for improvements

## Code Style

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and [Flutter Style Guide](https://flutter.dev/docs/development/tools/formatting).

- Use `flutter format` before committing
- Keep methods small and focused
- Document public APIs with dartdoc comments
- Write clear commit messages

## Resources for AI Implementation

- [TensorFlow Lite Flutter plugins](https://www.tensorflow.org/lite/guide/flutter)
- [ML Kit for Flutter](https://developers.google.com/ml-kit)
- [Flutter HTTP package](https://pub.dev/packages/http) for API calls

## License

By contributing, you agree that your contributions will be licensed under the project's license. 