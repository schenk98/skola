cmake_minimum_required(VERSION 3.17)
project(cpp2)

set(CMAKE_CXX_STANDARD 20)

add_executable(cpp2 main.cpp db/DatabaseHandler.cpp db/DatabaseHandler.h db/CMemory_database.cpp db/CMemory_database.h)