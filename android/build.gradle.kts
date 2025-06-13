
// iseeyou/android/build.gradle.kts (ROOT PROJECT LEVEL)
plugins {
    // Other plugins that apply to the root project or for global declaration
    // These versions now align with settings.gradle.kts
    id("com.android.application") version "8.7.3" apply false
    // Removed: id("com.android.library") version "8.7.3" apply false - (to resolve persistent conflicts)
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    id("com.google.gms.google-services") version "4.3.15" apply false
}

buildscript {
    val kotlin_version = "1.9.22"

    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.7.3")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
        // Removed: classpath("com.google.gms:google-services:4.4.1")
        // Reason: This is redundant with the 'plugins' block declaration above
        // and also had a version mismatch (4.4.1 vs 4.4.2).
        // The 'plugins' block approach is the preferred Kotlin DSL method.
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
