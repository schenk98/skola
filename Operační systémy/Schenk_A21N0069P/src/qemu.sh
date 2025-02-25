./build.sh
cd userspace
./build.sh
cd ..
./build.sh
#zastavit na zacatek nebo ne
#/home/schenkj/os2022/qemu2/qemu/Build/qemu-system-arm -M raspi0 -serial null -serial mon:stdio -kernel build/kernel.img -nographic -gdb tcp::1234 -S
/home/schenkj/os2022/qemu2/qemu/Build/qemu-system-arm -M raspi0 -serial null -serial mon:stdio -kernel build/kernel.img -nographic -gdb tcp::1234
