val spinalVersion = "1.12.0"

lazy val vexRiscv = RootProject(file("VexRiscv"))

lazy val root = (project in file("."))
  .dependsOn(vexRiscv)
  .settings(
  name := "OpenPeriph",
  inThisBuild(List(
    organization := "com.github.spinalhdl",
    scalaVersion := "2.12.18",
    version      := "0.1.0"
  )),
  libraryDependencies ++= Seq(
    "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion,
    "com.github.spinalhdl" %% "spinalhdl-lib"  % spinalVersion,
    compilerPlugin("com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion),
    "org.scalatest" %% "scalatest" % "3.2.17" % Test,
    "org.yaml" % "snakeyaml" % "1.8"
  )
)

fork := true
