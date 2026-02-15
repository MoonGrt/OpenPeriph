#!/bin/bash
# setup.sh xx

set -e  # Enable error exit

setenv(){
  echo "export OPENPERIPH_HOME="$(pwd)"" >> ~/.bashrc
  echo "By default this script will add environment variables into ~/.bashrc."
  echo "After that, please run 'source ~/.bashrc' to let these variables take effect."
  echo "Try \"echo \$OPENPERIPH_HOME\" to check if it's set correctly."
}

install_prequisites(){
  sudo apt-get update
  sudo apt-get install -y curl autoconf flex bison libtool libyaml-dev libudev-dev libusb-1.0-0-dev help2man
}

install_java(){
  # JAVA JDK 8
  sudo add-apt-repository -y ppa:openjdk-r/ppa
  sudo apt-get update
  sudo apt-get install openjdk-8-jdk -y
  # sudo update-alternatives --config java # Set default Java version
  # sudo update-alternatives --config javac
}

install_sbt(){
  # Install SBT - https://www.scala-sbt.org/
  sudo apt-get install -y curl
  echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
  echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
  curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
  sudo apt-get update
  sudo apt-get install sbt
}

install_verilator(){
  sudo apt install -y make autoconf g++ flex libfl-dev bison help2man  # First time prerequisites
  if [ ! -d "openocd_riscv" ]; then
    git clone https://github.com/verilator/verilator.git
  fi
  unset VERILATOR_ROOT
  cd verilator
  git pull  # Make sure we're up-to-date
  git checkout v4.216
  autoconf  # Create ./configure script
  ./configure
  make -j $(nproc)
  sudo make install
  cd .. && rm -rf verilator
}

install_riscv_gcc(){
  # Download and install the Sifive GCC toolchain
  sudo apt install -y libncurses5
  version=riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14
  wget -O riscv64-unknown-elf-gcc.tar.gz https://static.dev.sifive.com/dev-tools/$version.tar.gz
  tar -xzvf riscv64-unknown-elf-gcc.tar.gz
  sudo mv $version /opt/riscv
  echo 'export PATH=/opt/riscv/bin:$PATH' >> ~/.bashrc
  rm riscv64-unknown-elf-gcc.tar.gz
  echo "RISC-V GCC installed. Please run 'source ~/.bashrc' or open a new terminal."
}

install_openocd(){
  sudo apt-get install -y libyaml-dev libhidapi-dev libtool libusb-1.0-0-dev
  if [ ! -d "openocd_riscv" ]; then
    git clone https://github.com/SpinalHDL/openocd_riscv.git
  fi
  cd openocd_riscv
  ./bootstrap
  ./configure --enable-cmsis-dap
  make -j $(nproc)
  sudo make install
  cd .. && rm -rf openocd_riscv
}

install_vexriscv(){
  # Download and install the VexRiscv RISC-V softcore
  if [ ! -d "openocd_riscv" ]; then
    git clone https://github.com/SpinalHDL/VexRiscv.git
  fi
  cd VexRiscv
  sbt publishLocal
  cd .. && rm -rf VexRiscv
}

install_iverilog(){
  sudo apt install -y gperf readline-common bison flex libfl-dev
  curl -fsSL https://github.com/steveicarus/iverilog/archive/v10_3.tar.gz | tar -xvz
  cd iverilog-10_3
  autoconf
  ./configure  --prefix ~/tools
  make -j $(nproc)
  sudo make install
  cd .. && rm -rf iverilog-10_3
}

install_mill(){
  curl --fail -L -o mill https://github.com/com-lihaoyi/mill/releases/download/0.11.6/0.11.6-assembly
  chmod +x mill
  sudo mv mill /usr/local/bin
}

if [ -z "$1" ]; then
  set -- all
fi
case $1 in
  env)
    setenv
    ;;
  prequisites)
    install_prequisites
    ;;
  java)
    install_java
    ;;
  sbt)
    install_sbt
    ;;
  verilator)
    install_verilator
    ;;
  riscv_gcc)
    install_riscv_gcc
    ;;
  openocd)
    install_openocd
    ;;
  vexriscv)
    install_vexriscv
    ;;
  iverilog)
    install_iverilog
    ;;
  mill)
    install_mill
    ;;
  all)
    setenv
    install_prequisites
    install_java
    install_sbt
    install_verilator
    install_riscv_gcc
    install_openocd
    ;;
  *)
    echo "Invalid input..."
    exit
    ;;
esac
