# Dudi Court Reservation App

A Flutter-based application that integrates with Firebase to manage court reservations. This project is designed to simplify the process of reserving courts, providing a seamless user experience.

## Features

- **Firebase Authentication**: Secure login and registration functionality using Firebase.
- **Real-Time Database Integration**: Connects to Firebase for real-time updates on court availability and reservations.
- **Cross-Platform Support**: Available for Android, iOS, and web platforms.
- **Modern UI**: Built with Flutter to deliver a responsive and user-friendly interface.
- **Multi-User System**: Supports multiple user profiles for court reservations.

## About Dudi Sela Tennis Academy

The Dudi Sela Tennis Academy is a premier institution dedicated to nurturing tennis talent. Known for its state-of-the-art facilities and expert coaching staff, the academy offers programs for players of all skill levels. The academy fosters discipline, skill development, and sportsmanship, making it a hub for aspiring tennis professionals and enthusiasts alike.

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **Backend**: Firebase Authentication and Firebase Database
- **Platforms**: Android, iOS, Web

## Project Structure

```plaintext
|-- android/              # Android-specific files
|-- ios/                  # iOS-specific files
|-- lib/                  # Main application code (Dart files)
|-- web/                  # Web platform files
|-- windows/              # Windows-specific files
|-- assets/               # Static assets like images
|-- analysis_options.yaml # Dart linter rules
|-- pubspec.yaml          # Project configuration and dependencies
|-- codemagic.yaml        # CI/CD configuration for Codemagic
```

## Setup and Installation

### Prerequisites

- Install Flutter SDK ([Flutter Installation Guide](https://docs.flutter.dev/get-started/install)).
- Firebase project setup:
  - Create a Firebase project.
  - Add the `google-services.json` file for Android.
  - Add the `GoogleService-Info.plist` file for iOS.

### Steps to Run the Project

1. Clone the repository:

   ```bash
   git clone https://github.com/doronkabaso/dudi-court-reservation-app.git
   cd dudi-court-reservation-app
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Place the `google-services.json` file in the `android/app` directory.
   - Place the `GoogleService-Info.plist` file in the `ios/Runner` directory.

4. Run the application:

   ```bash
   flutter run
   ```

   Select your target device if prompted.

## Usage

- **Login/Register**: Use Firebase Authentication to log in or create a new account.
- **Reserve Courts**: View available courts and make reservations.
- **Manage Reservations**: View or cancel existing reservations.

## Future Enhancements

- **Payment Integration**: Add a payment gateway for reserving premium courts.
- **Push Notifications**: Notify users about upcoming reservations or court availability.
- **Enhanced Reporting**: Provide admins with analytics and usage reports.

## Contributors

- Doron Kabaso
- Sharon Bello

## Feedback

For suggestions or issues, please raise them in the [GitHub repository](https://github.com/doronkabaso/dudi-court-reservation-app/issues).

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)

