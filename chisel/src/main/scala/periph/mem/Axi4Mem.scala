package periph.mem

import bus.amba.axi.common.{AxiParams, AxiParameters}

class Axi4Mem(parameters: AxiParams, depthWords: Int = 1024)
    extends bus.demo.Axi4Ram(parameters, depthWords)

class ParameterizedAxi4Mem(depthWords: Int = 1024)(implicit parameters: AxiParameters)
    extends bus.demo.Axi4Ram(depthWords)
