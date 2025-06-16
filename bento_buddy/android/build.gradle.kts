buildscript { // <-- BLOK INI DENGAN SINTAKS KOTLIN DSL
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Gunakan `classpath(...)` untuk Kotlin DSL
        classpath("com.android.tools.build:gradle:8.1.4") // Sesuaikan versi Gradle Anda
        classpath("com.google.gms:google-services:4.4.1") // Gunakan versi stabil terbaru
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