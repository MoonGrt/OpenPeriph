package core

import _root_.circt.stage.ChiselStage
import freechips.rocketchip.devices.debug.DebugModuleKey
import freechips.rocketchip.devices.tilelink.BootROMLocated
import freechips.rocketchip.rocket.{WithNoSimulationTimeout, WithNSmallCores, WithRV32}
import freechips.rocketchip.subsystem._
import freechips.rocketchip.system.{BaseConfig, ExampleRocketSystem}
import org.chipsalliance.cde.config.Config
import org.chipsalliance.diplomacy.lazymodule.LazyModule

class OpenPeriphRocketConfig extends Config(
  new Config((_, _, _) => {
    case DebugModuleKey => None
    case BootROMLocated(InSubsystem) => Nil
    case HasTilesExternalResetVectorKey => true
  }) ++
    new WithCustomMemPort(0x80000000L, 64 * 1024, 64, 4, 8) ++
    new WithCustomMMIOPort(0xf0000000L, 1024 * 1024, 64, 4, 8) ++
    new WithNoSlavePort ++
    new WithNoSimulationTimeout ++
    new WithRV32 ++
    new WithNSmallCores(1) ++
    new WithCoherentBusTopology ++
    new BaseConfig
)

object OpenPeriphRocket {
  def apply(): ExampleRocketSystem = {
    implicit val parameters: OpenPeriphRocketConfig = new OpenPeriphRocketConfig
    LazyModule(new ExampleRocketSystem)
  }
}

object OpenPeriphRocketGenerator extends App {
  val system = OpenPeriphRocket()
  ChiselStage.emitSystemVerilogFile(system.module, args)
}
