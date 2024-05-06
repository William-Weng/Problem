plugins {
    alias(libs.plugins.androidApplication)
    alias(libs.plugins.jetbrainsKotlinAndroid)
    id("com.google.gms.google-services")
}

android {
    namespace = "idv.william.fcm_demo"
    compileSdk = 34

    defaultConfig {
        applicationId = "idv.william.fcm_demo"
        minSdk = 26
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {

        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("debug")

            manifestPlaceholders += mapOf(
                "my_app_name" to "Release",
                "my_app_icon" to "@mipmap/ic_launcher_release"
            )
        }

        debug {
            applicationIdSuffix = ".debug"
            isDebuggable = true

            manifestPlaceholders += mapOf(
                "my_app_name" to "Debug",
                "my_app_icon" to "@mipmap/ic_launcher_debug"
            )
        }

        create("stage") {
            applicationIdSuffix = ".stage"
            isDebuggable = true
            signingConfig = signingConfigs.getByName("debug")

            manifestPlaceholders += mapOf(
                "my_app_name" to "Stage",
                "my_app_icon" to "@mipmap/ic_launcher_stage"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }
    buildFeatures {
        viewBinding = true
    }
}

dependencies {

    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.constraintlayout)
    implementation(platform(libs.firebase.bom))
    implementation(libs.firebase.messaging.ktx)
    implementation(libs.androidx.fragment)
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
}