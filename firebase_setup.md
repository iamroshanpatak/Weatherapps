# Firebase Setup Guide

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: "Weather App"
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Enable Authentication

1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password"
5. Click "Save"

## Step 3: Enable Firestore Database

1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location close to your users
5. Click "Done"

## Step 4: Configure Android App

1. In Firebase Console, click the gear icon → "Project settings"
2. Scroll down to "Your apps" section
3. Click "Add app" → "Android"
4. Enter package name: `com.example.weathers_app`
5. Enter app nickname: "Weather App"
6. Click "Register app"
7. Download `google-services.json`
8. Place it in `android/app/` directory

## Step 5: Configure iOS App (if needed)

1. In Firebase Console, click "Add app" → "iOS"
2. Enter bundle ID: `com.example.weathersApp`
3. Enter app nickname: "Weather App"
4. Click "Register app"
5. Download `GoogleService-Info.plist`
6. Place it in `ios/Runner/` directory

## Step 6: Update Android Configuration

Add to `android/app/build.gradle.kts`:
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")  // Add this line
}
```

Add to `android/build.gradle.kts`:
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

## Step 7: Update iOS Configuration (if needed)

Add to `ios/Podfile`:
```ruby
platform :ios, '12.0'
```

## Step 8: Security Rules for Firestore

In Firebase Console → Firestore Database → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /favorites/{document} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /weather_history/{document} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

## Step 9: Test the Setup

1. Run `flutter pub get`
2. Run `flutter run`
3. Test authentication and database operations

## Troubleshooting

### Common Issues:

1. **Firebase not initialized**: Make sure `google-services.json` is in the correct location
2. **Authentication errors**: Check if Email/Password is enabled in Firebase Console
3. **Database permission errors**: Verify Firestore security rules
4. **Location permission errors**: Add location permissions to AndroidManifest.xml

### Location Permissions

Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

Add to `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location to show weather for your current location.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location to show weather for your current location.</string>
``` 