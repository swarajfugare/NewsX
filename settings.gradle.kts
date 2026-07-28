// Root-level settings.gradle.kts
// This file helps Android Studio identify the project structure and link the Flutter SDK

pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        // Check for local.properties in root and android folder
        val locations = listOf(file("local.properties"), file("android/local.properties"))
        val localPropertiesFile = locations.find { it.exists() }
        
        if (localPropertiesFile != null) {
            localPropertiesFile.inputStream().use { properties.load(it) }
        }
        
        properties.getProperty("flutter.sdk") ?: System.getenv("FLUTTER_ROOT")
    }

    if (flutterSdkPath != null) {
        includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    }

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    // Re-adding version "1.0.0". This is satisfied by the local SDK tools included above.
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
}

// Link the modules so they appear in the IDE
include(":app")
project(":app").projectDir = file("android/app")

rootProject.name = "News Pro"
