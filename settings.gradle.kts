// Root-level settings.gradle.kts
// This file helps Android Studio identify the project structure

pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        // Check both root and android/ folder for local.properties
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
}

plugins {
    // We remove the version number here because the plugin is provided locally 
    // by the Flutter SDK tools included via 'includeBuild' above.
    id("dev.flutter.flutter-gradle-plugin") apply false
}

// This tells the IDE that the "app" module is inside the "android" folder
include(":app")
project(":app").projectDir = file("android/app")

rootProject.name = "News Pro"
