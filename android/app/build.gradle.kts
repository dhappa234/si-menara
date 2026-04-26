plugins {
    id("com.android.application")
    id("kotlin-android")

    // Flutter Gradle Plugin (WAJIB paling bawah)
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.simenara"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {

        // ⚠️ GANTI NANTI KALAU MAU RILIS (unik)
        applicationId = "com.example.simenara"

        minSdk = 29
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Supaya multidex aman kalau lib makin banyak
        multiDexEnabled = true
    }

    buildTypes {

        release {

            // Pakai debug dulu (sementara)
            signingConfig = signingConfigs.getByName("debug")

            // Optimasi ringan
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }

    // Biar tidak error packaging
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

dependencies {

    // Multidex support
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
