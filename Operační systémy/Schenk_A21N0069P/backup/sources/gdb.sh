gdb-multiarch -ex 'set architecture arm' -ex 'file userspace/build/sp_task' -ex 'target remote tcp:localhost:1234' -ex 'layout regs'
