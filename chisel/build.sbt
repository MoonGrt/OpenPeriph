ThisBuild / scalaVersion := "2.13.12"
ThisBuild / version := "0.1.0"
ThisBuild / organization := "com.github.moongrt"

val chiselVersion = "6.7.0"

lazy val root = (project in file("."))
  .settings(
    name := "OpenPeriphChisel",
    target := baseDirectory.value / "build" / "sbt" / "target",
    libraryDependencies ++= Seq(
      "org.chipsalliance" %% "chisel" % chiselVersion,
      "org.scalatest" %% "scalatest" % "3.2.19" % Test,
    ),
    Compile / unmanagedJars +=
      baseDirectory.value / ".." / "thirdpartys" / "rocket-chip" / "out" /
        "rocketchip" / "6.7.0" / "assembly.dest" / "out.jar",
    scalacOptions ++= Seq(
      "-language:reflectiveCalls",
      "-deprecation",
      "-feature",
      "-Xcheckinit",
      "-Ymacro-annotations",
    ),
    addCompilerPlugin(
      "org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full
    ),
  )

Compile / run / fork := true
Compile / run / forkOptions := (Compile / run / forkOptions).value
  .withWorkingDirectory(baseDirectory.value / "build")
