# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/schenkj/os2022/sp/sources/userspace

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/schenkj/os2022/sp/sources/userspace

# Include any dependencies generated for this target.
include CMakeFiles/sp_task.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/sp_task.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/sp_task.dir/flags.make

CMakeFiles/sp_task.dir/crt0.s.o: CMakeFiles/sp_task.dir/flags.make
CMakeFiles/sp_task.dir/crt0.s.o: crt0.s
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/schenkj/os2022/sp/sources/userspace/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building ASM object CMakeFiles/sp_task.dir/crt0.s.o"
	/usr/bin/cc $(ASM_DEFINES) $(ASM_INCLUDES) $(ASM_FLAGS) -o CMakeFiles/sp_task.dir/crt0.s.o -c /home/schenkj/os2022/sp/sources/userspace/crt0.s

CMakeFiles/sp_task.dir/crt0.c.o: CMakeFiles/sp_task.dir/flags.make
CMakeFiles/sp_task.dir/crt0.c.o: crt0.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/schenkj/os2022/sp/sources/userspace/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/sp_task.dir/crt0.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/sp_task.dir/crt0.c.o   -c /home/schenkj/os2022/sp/sources/userspace/crt0.c

CMakeFiles/sp_task.dir/crt0.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/sp_task.dir/crt0.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/schenkj/os2022/sp/sources/userspace/crt0.c > CMakeFiles/sp_task.dir/crt0.c.i

CMakeFiles/sp_task.dir/crt0.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/sp_task.dir/crt0.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/schenkj/os2022/sp/sources/userspace/crt0.c -o CMakeFiles/sp_task.dir/crt0.c.s

CMakeFiles/sp_task.dir/cxxabi.cpp.o: CMakeFiles/sp_task.dir/flags.make
CMakeFiles/sp_task.dir/cxxabi.cpp.o: cxxabi.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/schenkj/os2022/sp/sources/userspace/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/sp_task.dir/cxxabi.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/sp_task.dir/cxxabi.cpp.o -c /home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp

CMakeFiles/sp_task.dir/cxxabi.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/sp_task.dir/cxxabi.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp > CMakeFiles/sp_task.dir/cxxabi.cpp.i

CMakeFiles/sp_task.dir/cxxabi.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/sp_task.dir/cxxabi.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp -o CMakeFiles/sp_task.dir/cxxabi.cpp.s

CMakeFiles/sp_task.dir/sp_task/main.cpp.o: CMakeFiles/sp_task.dir/flags.make
CMakeFiles/sp_task.dir/sp_task/main.cpp.o: sp_task/main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/schenkj/os2022/sp/sources/userspace/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object CMakeFiles/sp_task.dir/sp_task/main.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/sp_task.dir/sp_task/main.cpp.o -c /home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp

CMakeFiles/sp_task.dir/sp_task/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/sp_task.dir/sp_task/main.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp > CMakeFiles/sp_task.dir/sp_task/main.cpp.i

CMakeFiles/sp_task.dir/sp_task/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/sp_task.dir/sp_task/main.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp -o CMakeFiles/sp_task.dir/sp_task/main.cpp.s

# Object files for target sp_task
sp_task_OBJECTS = \
"CMakeFiles/sp_task.dir/crt0.s.o" \
"CMakeFiles/sp_task.dir/crt0.c.o" \
"CMakeFiles/sp_task.dir/cxxabi.cpp.o" \
"CMakeFiles/sp_task.dir/sp_task/main.cpp.o"

# External object files for target sp_task
sp_task_EXTERNAL_OBJECTS =

sp_task: CMakeFiles/sp_task.dir/crt0.s.o
sp_task: CMakeFiles/sp_task.dir/crt0.c.o
sp_task: CMakeFiles/sp_task.dir/cxxabi.cpp.o
sp_task: CMakeFiles/sp_task.dir/sp_task/main.cpp.o
sp_task: CMakeFiles/sp_task.dir/build.make
sp_task: ../build/libkivrtos_stdlib.a
sp_task: CMakeFiles/sp_task.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/schenkj/os2022/sp/sources/userspace/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Linking CXX executable sp_task"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/sp_task.dir/link.txt --verbose=$(VERBOSE)
	/usr/bin/objcopy ./sp_task -O binary ./sp_task.bin
	/usr/bin/objdump -l -S -D ./sp_task > ./sp_task.asm
	xxd -i ./sp_task > ./src_sp_task.h

# Rule to build all files generated by this target.
CMakeFiles/sp_task.dir/build: sp_task

.PHONY : CMakeFiles/sp_task.dir/build

CMakeFiles/sp_task.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/sp_task.dir/cmake_clean.cmake
.PHONY : CMakeFiles/sp_task.dir/clean

CMakeFiles/sp_task.dir/depend:
	cd /home/schenkj/os2022/sp/sources/userspace && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/schenkj/os2022/sp/sources/userspace /home/schenkj/os2022/sp/sources/userspace /home/schenkj/os2022/sp/sources/userspace /home/schenkj/os2022/sp/sources/userspace /home/schenkj/os2022/sp/sources/userspace/CMakeFiles/sp_task.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/sp_task.dir/depend

