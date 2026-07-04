plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
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

    defaultConfig {
        applicationId = "com.pharma.go"
        minSdk = 26  
        targetSdk = 36
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
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
        implementation("androidx.window:window:1.3.0")
        implementation("androidx.window:window-java:1.3.0")
        implementation("androidx.multidex:multidex:2.0.1")
        
        implementation(platform("com.google.firebase:firebase-bom:33.9.0"))
        implementation("com.google.firebase:firebase-messaging")
        implementation("com.google.firebase:firebase-analytics")
    }
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}

configurations.all {
    resolutionStrategy {
        exclude(group = "com.google.firebase", module = "firebase-iid")
    }
}

flutter {
    source = "../.."
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}