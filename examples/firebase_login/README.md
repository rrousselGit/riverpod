# Firebase Login

Example flutter app built with Riverpod that demonstrates authentication with Firebase.

<table>
  <tr>
    <td><img src="./samples/demo.gif" alt="demo" width="320"></td>
    <td><img src="./samples/error.png" alt="error" width="320"></td>
    <td><img src="./samples/signup.png" alt="signup" width="320"></td>
    <td><img src="./samples/home.png" alt="home" width="320"></td>
  </tr>
</table>

## Features

- Sign up with Email and Password
- Sign in with Email and Password
- Sign in with Google
- Error handling

## Getting Started

1. Generate the native folders first by running `flutter create --platforms=android,ios,web,windows,macos .`
2. Create your firebase project, and enable email/password authentication and google.
3. Use [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup?platform=ios) to connect the app with the firebase project.
4. Follow the [platform integration steps](https://pub.dev/packages/google_sign_in#platform-integration) for the `google_sign_in` package.
5. Run the app.
6. To run the tests, run `flutter test`.
