# Contributing to Balaji Gold

First off, thank you for considering contributing to Balaji Gold! It's people like you that make Balaji Gold such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the issue list as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

* **Use a clear and descriptive title**
* **Describe the exact steps to reproduce the problem**
* **Provide specific examples to demonstrate the steps**
* **Describe the behavior you observed after following the steps**
* **Explain which behavior you expected to see instead and why**
* **Include screenshots if possible**
* **Include your environment details** (Flutter version, device, OS version)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

* **Use a clear and descriptive title**
* **Provide a step-by-step description of the suggested enhancement**
* **Provide specific examples to demonstrate the steps**
* **Describe the current behavior and explain the expected behavior**
* **Explain why this enhancement would be useful**

### Pull Requests

* Fill in the required template
* Do not include issue numbers in the PR title
* Follow the Flutter style guide
* Include thoughtful commit messages
* Include screenshots for UI changes
* Update documentation as needed
* Add tests if applicable

## Development Process

### Setup Development Environment

1. Fork the repo
2. Clone your fork
```bash
git clone https://github.com/your-username/Gold-Mobile-application.git
cd Gold-Mobile-application
```

3. Add upstream remote
```bash
git remote add upstream https://github.com/lakshman38/Gold-Mobile-application.git
```

4. Install dependencies
```bash
flutter pub get
```

5. Create a branch
```bash
git checkout -b feature/your-feature-name
```

### Coding Standards

#### Dart/Flutter Guidelines

* Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
* Use meaningful variable and function names
* Add comments for complex logic
* Keep functions small and focused
* Use const constructors where possible
* Prefer `final` over `var` when possible

#### Example:

```dart
// Good
class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Widget implementation
    );
  }
}

// Avoid
class customer_card extends StatelessWidget {
  var c;
  var t;
  
  customer_card(this.c, this.t);
}
```

#### File Organization

```
lib/
├── controllers/    # State management
├── models/        # Data models
├── screens/       # UI screens
├── services/      # Business logic
├── widgets/       # Reusable widgets
└── utils/         # Utilities and helpers
```

#### Widget Structure

1. Constructor and required parameters
2. State variables (if StatefulWidget)
3. Lifecycle methods
4. Helper methods
5. Build method
6. Private widget builders

### Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line

#### Examples:

```
Add customer search functionality

- Implement search bar in home screen
- Add filter logic in customer controller
- Update UI to show search results
- Add tests for search feature

Fixes #123
```

### Testing

* Write tests for new features
* Ensure all tests pass before submitting PR
* Update existing tests if behavior changes

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Documentation

* Update README.md if needed
* Add comments to complex code
* Update API documentation
* Add examples for new features

## Project Structure

### Key Files

* `lib/main.dart` - App entry point
* `lib/utils/theme.dart` - Theme configuration
* `lib/firebase_options.dart` - Firebase configuration
* `pubspec.yaml` - Dependencies

### State Management

We use Provider for state management:

```dart
// Controller
class CustomerController extends ChangeNotifier {
  // State and methods
}

// Usage
context.read<CustomerController>().addCustomer();
context.watch<CustomerController>().customers;
```

### Services

Services handle business logic and external APIs:

```dart
class CustomerService {
  Future<List<Customer>> getCustomers() async {
    // Implementation
  }
}
```

## Review Process

1. Create a pull request
2. Wait for review from maintainers
3. Address feedback
4. Once approved, it will be merged

### PR Checklist

- [ ] Code follows project style guidelines
- [ ] Self-reviewed the code
- [ ] Commented complex code
- [ ] Updated documentation
- [ ] No breaking changes (or documented if necessary)
- [ ] Added tests (if applicable)
- [ ] All tests pass
- [ ] No warnings from `flutter analyze`

## Questions?

Feel free to open an issue with your question or contact the maintainers.

## Recognition

Contributors will be recognized in:
* CONTRIBUTORS.md file
* Release notes
* Project README

Thank you for contributing! 🎉
