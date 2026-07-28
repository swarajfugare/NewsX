# NewsX Production Android ProGuard & R8 Obfuscation Rules

# Preserve Flutter Wrapper & Plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.** { *; }

# Preserve Gson & JSON serializable data models
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Ignore R8 warning rules for third party libraries
-dontwarn okhttp3.**
-dontwarn retrofit2.**
