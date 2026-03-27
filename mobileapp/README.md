# InvoiceX Setup Guide

## Prerequisites

Ensure you have the following installed:
- Flutter SDK (version 3.22.0)
- An IDE such as Android Studio, Visual Studio Code, or IntelliJ IDEA

## Installation Steps

1. **Open the Project**: Open the project in your chosen IDE.

## Changing the Logo

1. **Locate the Icon Files**: Find the launcher icon files in the `android/app/src/main/res/mipmap-*dpi` directories.
2. **Replace the Icons**: Replace the existing icon files with your new logo. Ensure your logo meets the requirements for Android app icons.

## Modifying the Package Name

1. **Edit the `build.gradle` File**: Locate the `build.gradle` file in the `android/app` directory.
2. **Update the `applicationId`**: Change the `applicationId` value to your desired package name within the `defaultConfig` block.

## Getting Dependencies
`flutter clean`
`flutter pub get`

## Running the Application

1. **Select a Device**: Choose an Android device or emulator from the IDE.
2. **Run the Application**: Use the IDE's run button or execute the command `flutter run` in the terminal.

## Building the APK

1. **Prepare for Release**: Make sure all necessary changes are saved and tested.
2. **Build the APK**: In the terminal, navigate to the project directory and run `flutter build apk --release`.
3. **Find the APK**: The built APK will be located in the `build/app/outputs/apk/release` directory.

This guide provides a concise overview of setting up, customizing, and building the InvoiceX Flutter project.