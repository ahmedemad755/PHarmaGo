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
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // تم ترك applicationId هنا كمرجع أساسي، ولكن الـ Flavors ستقوم بتغييره تلقائياً
        applicationId = "com.pharma.go"
        minSdk = 26  
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
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

    dependencies {
    // 1. مكتبة الـ Desugaring (لازم تكون موجودة طالما فعلت isCoreLibraryDesugaringEnabled)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // 2. مكتبات الـ Window لمنع الـ Crash على أندرويد 12 فأحدث
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")
    
    // 3. دعم الـ MultiDex (اختياري لكن مفضل طالما فعلته في الـ defaultConfig)
    implementation("androidx.multidex:multidex:2.0.1")
}
}

dependencies {
    // 1. مكتبة الـ Desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // 2. ✅ حل مشكلة الـ Duplicate Classes باستخدام Firebase BoM
    // هذا السطر يضمن أن كل مكتبات Firebase متوافقة مع بعضها ولن تسبب تكرار
    implementation(platform("com.google.firebase:firebase-bom:33.1.0"))
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.firebase:firebase-analytics")

    // 3. مكتبات الـ Window لمنع الـ Crash
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")
    
    // 4. دعم الـ MultiDex
    implementation("androidx.multidex:multidex:2.0.1")
}
configurations.all {
    resolutionStrategy {
        // منع جلب مكتبة iid القديمة لأنها مدمجة بالفعل في النسخ الحديثة من Messaging
        exclude(group = "com.google.firebase", module = "firebase-iid")
        
        // اختيارياً: إجبار المشروع على نسخة معينة من Messaging إذا استمر التعارض
        force("com.google.firebase:firebase-messaging:24.1.2")
    }}

flutter {
    source = "../.."
}