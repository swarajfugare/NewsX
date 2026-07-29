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

# Ignore R8 warnings for Play Core deferred components and third party libraries
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
-dontwarn okhttp3.**
-dontwarn retrofit2.**
