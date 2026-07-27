# Software demos

Only two firmware demos are kept at the top level:

- `bare`: bare-metal firmware
- `rthtread`: RT-Thread firmware used by the NVBoard project

Select a demo through the common Makefile:

```sh
make -C software list
make -C software DEMO=bare
make -C software DEMO=rthtread
make -C software DEMO=rthtread clean
```

`make -C software DEMO=<name> info` prints the selected runtime, startup
file, and linker script. Runtime support is stored in `sdk`:

- `sdk/startup/bare.S` and `sdk/linker/bare.ld`
- `sdk/startup/rtthread.S` and `sdk/linker/rtthread.ld`
- `sdk/rt-thread`: RT-Thread kernel, components, and RISC-V port

Each demo contains only its application sources and writes all generated
firmware files to its own `build` directory.
