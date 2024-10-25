buildscript {
  repositories {
    mavenLocal()
    mavenCentral()
    maven { url = uri("https://maven.saxonica.com/maven") }
  }

  configurations.all {
    resolutionStrategy.eachDependency {
      if (requested.group == "xml-apis" && requested.name == "xml-apis") {
        useVersion("1.4.01")
      }
      if (requested.group == "net.sf.saxon" && requested.name == "Saxon-HE") {
        useVersion(project.properties["saxonVersion"].toString())
      }
      if (requested.group == "org.xmlresolver" && requested.name == "xmlresolver") {
        useVersion(project.properties["xmlResolverVersion"].toString())
      }
    }
  }

  dependencies {
    classpath("net.sf.saxon:Saxon-HE:${project.properties["saxonVersion"]}")
    classpath("org.docbook:schemas-docbook:5.2")
    classpath("org.docbook:docbook-xslTNG:2.4.0")
  }
}

plugins {
  id("com.nwalsh.gradle.saxon.saxon-gradle") version "0.10.4"
  id("com.nwalsh.gradle.relaxng.validate") version "0.10.3"
  id("com.nwalsh.gradle.relaxng.translate") version "0.10.5"
  id("buildlogic.kotlin-common-conventions")
}

import java.net.URI
import java.net.URL
import java.net.HttpURLConnection
import java.io.File
import java.io.BufferedReader
import java.io.FileInputStream
import java.io.PrintStream
import java.io.InputStreamReader
import java.io.ByteArrayOutputStream
import com.nwalsh.gradle.saxon.SaxonXsltTask
import com.nwalsh.gradle.relaxng.validate.RelaxNGValidateTask
import com.nwalsh.gradle.relaxng.translate.RelaxNGTranslateTask

val saxonVersion = project.properties["saxonVersion"].toString()

repositories {
  mavenLocal()
  mavenCentral()
}

configurations.all {
  resolutionStrategy.eachDependency {
    if (requested.group == "xml-apis" && requested.name == "xml-apis") {
      useVersion("1.4.01")
    }
    if (requested.group == "net.sf.saxon" && requested.name == "Saxon-HE") {
      useVersion(saxonVersion)
    }
    if (requested.group == "org.xmlresolver" && requested.name == "xmlresolver") {
      useVersion(project.properties["xmlResolverVersion"].toString())
    }
  }
}

val documentation by configurations.creating
val transform by configurations.creating {
  extendsFrom(configurations["documentation"])
}

dependencies {
  documentation ("net.sf.saxon:Saxon-HE:${saxonVersion}")
  documentation ("org.docbook:schemas-docbook:5.2")
  documentation ("org.docbook:docbook-xslTNG:2.4.0")
}

// This build script doesn't do very much yet.

defaultTasks("publish")

tasks.register("publish") {
  dependsOn("copyArchive1x")
  dependsOn("copyStaticFiles")
}

tasks.register<Copy>("copyArchive1x") {
  from(zipTree(layout.projectDirectory.file("src/archive-1x.zip")))
  into(layout.buildDirectory.dir("website"))
}

tasks.register("copyStaticFiles") {
  doFirst {
    copy {
      from(layout.projectDirectory.dir("src/main/html"))
      into(layout.buildDirectory.dir("website"))
    }
  }
  doFirst {
    copy {
      from(layout.projectDirectory.dir("src/main/css"))
      into(layout.buildDirectory.dir("website/css"))
    }
  }
  doFirst {
    copy {
      from(layout.projectDirectory.dir("src/main/img"))
      into(layout.buildDirectory.dir("website/img"))
    }
  }
  doFirst {
    copy {
      from(layout.projectDirectory.dir("src/main/fonts"))
      into(layout.buildDirectory.dir("website/fonts"))
    }
  }
  doFirst {
    copy {
      from(layout.projectDirectory.dir("src/main/extension"))
      into(layout.buildDirectory.dir("website/extension"))
    }
  }
}

// ============================================================

tasks.register("helloWorld") {
  doLast {
    println("Hello, world.")
  }
}
