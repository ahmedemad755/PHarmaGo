plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.pharma.go"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // تم ترك applicationId هنا كمرجع أساسي، ولكن الـ Flavors ستقوم بتغييره تلقائياً
        applicationId = "com.pharma.go"
        minSdk = flutter.minSdkVersion  
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "default"

    productFlavors {
        create("staging") {
            dimension = "default"
            applicationId = "com.pharma.go.staging"
            resValue("string", "app_name", "Pharma Go Staging")
            // يضمن توافق المكتبات مع هذا الـ Flavor
            matchingFallbacks += listOf("debug", "release")
        }
        create("production") {
            dimension = "default"
            applicationId = "com.pharma.go"
            resValue("string", "app_name", "Pharma Go")
            matchingFallbacks += listOf("debug", "release")
        }
    }

    buildTypes {
        release {
            // حل مشكلة الـ R8 و Missing Classes عن طريق إيقاف الـ Minify مؤقتاً
            // إذا أردت تفعيله لاحقاً، يجب إضافة ملف proguard-rules.pro
            isMinifyEnabled = false
            isShrinkResources = false
            
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}