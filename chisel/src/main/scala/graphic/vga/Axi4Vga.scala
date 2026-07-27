package graphic.vga

import graphic.lcd.Axi4Lcd

class Axi4Vga(apbAddressWidth: Int = 10, dataWidth: Int = 32, colorWidth: Int = 16)
    extends Axi4Lcd(apbAddressWidth, dataWidth, colorWidth)
