# The set of languages for which implicit dependencies are needed:
set(CMAKE_DEPENDS_LANGUAGES
  "ASM"
  "CXX"
  )
# The set of files for implicit dependencies of each language:
set(CMAKE_DEPENDS_CHECK_ASM
  "/home/schenkj/os2022/sp/sources/kernel/src/interrupts.s" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/interrupts.s.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/memory/mmu.s" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/memory/mmu.s.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/process/spinlock.s" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/process/spinlock.s.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/process/switch.s" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/process/switch.s.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/start.s" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/start.s.obj"
  )
set(CMAKE_ASM_COMPILER_ID "GNU")

# Preprocessor definitions for this target.
set(CMAKE_TARGET_DEFINITIONS_ASM
  "RPI0"
  "RPI0=1"
  )

# The include file search paths:
set(CMAKE_ASM_TARGET_INCLUDE_PATH
  "../kernel/include"
  "../stdlib/include"
  "../stdutils/include"
  "../kernel/include/board/rpi0"
  )
set(CMAKE_DEPENDS_CHECK_CXX
  "/home/schenkj/os2022/sp/sources/kernel/src/cxx.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/cxx.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/drivers/bcm_aux.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/bcm_aux.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/drivers/gpio.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/gpio.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/drivers/i2c.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/i2c.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/drivers/oled_ssd1306.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/oled_ssd1306.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/drivers/segmentdisplay.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/segmentdisplay.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/drivers/shiftregister.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/shiftregister.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/drivers/timer.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/timer.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/drivers/trng.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/trng.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/drivers/uart.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/uart.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/fs/filesystem.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/fs/filesystem.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/fs/filesystem_drivers.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/fs/filesystem_drivers.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/initsys.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/initsys.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/interrupt_controller.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/interrupt_controller.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/main.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/main.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/memory/kernel_heap.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/memory/kernel_heap.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/memory/mmu.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/memory/mmu.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/memory/pages.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/memory/pages.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/memory/pt_alloc.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/memory/pt_alloc.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/memory/userspace_heap.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/memory/userspace_heap.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/process/condvar.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/process/condvar.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/process/mutex.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/process/mutex.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/process/pipe.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/process/pipe.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/process/process_manager.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/process/process_manager.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/process/resource_manager.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/process/resource_manager.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/process/scheduler.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/process/scheduler.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/process/semaphore.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/process/semaphore.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/startup.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/startup.cpp.obj"
  "/home/schenkj/os2022/sp/sources/kernel/src/test_processes.cpp" "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kernel.dir/kernel/src/test_processes.cpp.obj"
  )
set(CMAKE_CXX_COMPILER_ID "GNU")

# Preprocessor definitions for this target.
set(CMAKE_TARGET_DEFINITIONS_CXX
  "RPI0"
  "RPI0=1"
  )

# The include file search paths:
set(CMAKE_CXX_TARGET_INCLUDE_PATH
  "../kernel/include"
  "../stdlib/include"
  "../stdutils/include"
  "../kernel/include/board/rpi0"
  )

# Targets to which this target links.
set(CMAKE_TARGET_LINKED_INFO_FILES
  "/home/schenkj/os2022/sp/sources/build/CMakeFiles/kivrtos_stdlib.dir/DependInfo.cmake"
  )

# Fortran module output directory.
set(CMAKE_Fortran_TARGET_MODULE_DIR "")
