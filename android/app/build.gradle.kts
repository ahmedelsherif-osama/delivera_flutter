import org.gradle.api.JavaVersion

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

fun Project.flutterProp(key: String, default: String? = null): String? =
    (findProperty(key) as String?) ?: default

android {
    namespace = "com.example.delivera_flutter"

    // Read Flutter properties (safe with fallbacks)
    val compileSdkInt = 35
    val minSdkInt = flutterProp("flutter.minSdkVersion")?.toIntOrNull() ?: 23
    val targetSdkInt = flutterProp("flutter.targetSdkVersion")?.toIntOrNull() ?: 34
    val versionCodeInt = flutterProp("flutter.versionCode")?.toIntOrNull() ?: 1
    val versionNameStr = flutterProp("flutter.versionName") ?: "1.0"

    compileSdk = compileSdkInt

    defaultConfig {
        applicationId = "com.example.delivera_flutter"
        minSdk = minSdkInt
        targetSdk = targetSdkInt
        versionCode = versionCodeInt
        versionName = versionNameStr
    }

    compileOptions {
        // Java 11 compatibility
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true // required by some libs (flutter_local_notifications)
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
            // Configure proguard or shrink if needed
        }
    }
}

dependencies {
    // Required for desugaring (enable in compileOptions above)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
