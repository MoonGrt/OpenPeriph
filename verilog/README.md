# SystemVerilog peripherals

This backend implements the OpenPeriph APB peripheral subsystem without a CPU.
The top module is `Apb3Peripherals`; its 20-bit APB address is the offset
inside the SoC MMIO window at `0xf0000000`.

- `vsrc/periph`: APB peripherals and AXI memory
- `vsrc/graphic`: display timing and test patterns
- `csrc`: Verilator tests

| Offset | Peripheral |
| --- | --- |
| `0x00000`, `0x01000` | GPIO A/B |
| `0x10000` | UART |
| `0x40000` | general-purpose timer |
| `0x50000`, `0x50400` | independent/window watchdog |
| `0x60000` | SysTick |
| `0x70000` | configurable VGA/DVT test-pattern output |
| `0xd0000` | AFIO |
| `0xe0000` | EXTI |
| `0x20000` | I2C |
| `0x30000` | SPI |
| `0x90000` | CAN |
| `0xa0000` | SDIO |
| `0xb0000` | CRC |

The CAN test uses the implemented internal mailbox loopback path; SDIO verifies
the command/response and FIFO register engine. Full CAN and SD-card PHY models
are intentionally outside this peripheral-level backend.

Run the APB and AXI memory Verilator tests with:

```sh
make test
```

From the repository root, use `make BACKEND=verilog test`.
