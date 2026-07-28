plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    // The Flutter plugin is loaded from the Flutter SDK
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "in.refixer.newspro"
    compileSdk = 35

    defaultConfig {
        applicationId = "in.refixer.newspro"
        minSdk = 21
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
    
    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/java")
        }
    }
}

flutter {
    source = ".."
}

dependencies {
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
}
