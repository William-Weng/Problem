plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.jetbrains.kotlin.android)
}

android {
    namespace = "idv.william.changepagedemo"
    compileSdk = 34

    defaultConfig {
        applicationId = "idv.william.changepagedemo"
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

            manifestPlaceholders["my_app_icon"] = "@mipmap/ic_launcher_release"
        }

        debug {

            applicationIdSuffix = ".debug"
            isDebuggable = true

            manifestPlaceholders["my_app_icon"] = "@mipmap/ic_launcher_debug"
        }

        create("staging") {

            applicationIdSuffix = ".staging"
            isDebuggable = true
            signingConfig = signingConfigs.getByName("debug")

            manifestPlaceholders += mapOf(
                "my_app_name" to "Staging",
                "my_app_icon" to "@mipmap/ic_launcher_staging"
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
    implementation(libs.androidx.fragment)
    implementation(libs.androidx.navigation.fragment.ktx)
    implementation(libs.androidx.navigation.ui.ktx)
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
}