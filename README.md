# Alerta Criminal

**Alerta Criminal** is a Flutter-based mobile application designed to keep users informed about criminal activities in their area.

<div style="display:flex;">
<img src="https://i.imgur.com/CFRZcGh.jpeg" alt="teste" height="400" float="left"/>
<img src="https://i.imgur.com/U8LNcRt.jpeg" alt="teste" height="400" float="left"/>
<img src="https://i.imgur.com/dhQJTyq.jpeg" alt="teste" height="400" float="left"/>
<img src="https://i.imgur.com/OkjU38I.jpeg" alt="teste" height="400" float="left"/>
<img src="https://i.imgur.com/ZysTerf.jpeg" alt="teste" height="400" float="left"/>
</div>

## Prerequisites

Before you can set up and run this project, ensure you have the following tools installed:

1. **Git** (latest version)  
   [Download Git](https://git-scm.com/downloads)

2. **IDE** (choose one):
   - [Android Studio](https://developer.android.com/studio)
   - [Visual Studio Code](https://code.visualstudio.com/)
   - Any preferred IDE supporting Flutter and Dart.

3. **Flutter and Dart SDK**  
   Follow the installation guide: [Install Flutter and Dart](https://docs.flutter.dev/get-started/install)

4. **Firebase CLI**  
   Install it from: [Firebase CLI Installation Guide](https://firebase.google.com/docs/cli#install-cli-windows)

## Project Setup

Once the prerequisites are installed, follow these steps to set up the project:

1. Clone the repository:
```bash
git clone https://github.com/cesarfreitax/alerta_criminal.git
```

2. Navigate to the project directory:
```bash
cd alerta_criminal
```

3. Fetch the required dependencies:
```bash
flutter pub get
```

4. Run code generation:
```bash
dart run build_runner build
```

> Note: Firebase setup is required for certain dependencies to function. Configure Firebase by adding the appropriate configuration files (e.g., google-services.json for Android and GoogleService-Info.plist for iOS) to the project.

5. After completing the setup, you can run the project using the following command:
```bash
flutter run
```
> Make sure your device/emulator is connected and ready.

## Project Dependencies
The project uses the following dependencies as defined in the pubspec.yaml file:

### Core Dependencies
* flutter: Base SDK for building the app
* google_fonts: Custom fonts support
* flutter_localizations: Localized content support
* intl: Internationalization utilities
* google_maps_flutter: Google Maps integration
* location: Geolocation features
* image_picker: Media picker
* uuid: Generate unique IDs
* firebase: Firebase services including authentication, storage, Firestore
* flutter_riverpod: State management
* http: HTTP requests handling
* email_validator: Validate email addresses

### Development Dependencies
* build_runner: Code generation
* freezed: Data classes and immutability
* json_serializable: JSON serialization support
* custom_lint: Code linting

### Utility Tools
* flutter_launcher_icons: App launcher icons
* flutter_native_splash: Custom splash screens

For the full list of dependencies, refer to the pubspec.yaml file included in the project.
