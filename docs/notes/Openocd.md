[ubuntu 编译安装　openocd（支持cmsis-dap）](https://blog.csdn.net/eastgeneral/article/details/84873061)

###	Installing libraries and tools Dependency
```bash
  sudo apt-get install autotools-dev make libtool pkg-config autoconf automake texinfo libudev1 libudev-dev libusb-1.0-0-dev libfox-1.6-dev
```

Error:
```
The following packages have unmet dependencies:
  libudev-dev : Depends: libudev1 (= 245.4-4ubuntu3.20) but 245.4-4ubuntu3.24 is to be installed
E: Unable to correct problems, you have held broken packages.
```
Solution: Install the specified version of the dependency
```bash
  sudo apt install libudev1=245.4-4ubuntu3.20
```

###	Installing HIDAPI
```bash
  git clone https://github.com/signal11/hidapi.git
  cd hidapi/
  ./bootstrap
  ./configure
  make -j $(nproc)
  sudo make install
  echo 'PATH="$HOME/bin:/usr/local/lib:$PATH"' >> ~/.profile
  sudo ldconfig
  cd .. && rm -rf hidapi
```

###	Installing OpenOCD
```bash
  git clone https://github.com/SpinalHDL/openocd_riscv.git
  cd ~/openocd_riscv
  ./bootstrap
  ./configure --enable-cmsis-dap
  make -j
```

Error:
```
src/target/vexriscv.c:28:1o: fatal error: yaml.h: No such file or directory
  28 | #include <yaml.h>
     |           ^~~~~~
compilation terminated.
```
Solution: Install libyaml-dev
```bash
sudo apt-get update
sudo apt-get install libyaml-dev
```

### Add udev rule
```bash
lsusb
sudo nano /etc/udev/rules.d/CMSIS.rules
```

Add the following lines to the file:
```
KERNEL=="hidraw*", ATTRS{idVendor}=="0d28", ATTRS{idProduct}=="0204", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0d28", MODE="0666"
SUBSYSTEM=="usb_device", ATTRS{idVendor}=="0d28", MODE="0666"
```

> Note: Replace "0d28", "0204" with the vendor ID of your device.


### Reload udev rules
```bash
sudo udevadm control --reload-rules
```
