# REST API Example

A simple example demonstrating how to handle REST APIs with Riverpod, including proper testing practices.

## Key Points

This example demonstrates how to:

- Implement a REST API client with proper error handling
- Manage async state with AsyncNotifier
- Handle loading and error states
- Perform CRUD operations (Create and Read)
- Write comprehensive tests for all layers
- Use modern Dart patterns like pattern matching
- Implement form validation
- Handle pull-to-refresh

## Code Structure

- `lib/main.dart` - Contains all the code for simplicity
  - User model with JSON serialization
  - Repository for API communication
  - State management with AsyncNotifier
  - UI with proper error and loading states

- `test/user_test.dart` - Repository and state management tests
- `test/widget_test.dart` - Widget tests

## Testing

The example includes tests for:

- Repository layer (API calls)
- State management (AsyncNotifier)
- Widget behavior
- Form validation
- Error handling

Run tests with:

```bash
flutter test
```
