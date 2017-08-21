project(sfmle)
cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH ${sfmle_SOURCE_DIR}/cmake/modules
                      ${CMAKE_MODULE_PATH})
					 
set(SFML_ROOT ${sfmle_SOURCE_DIR}/external/SFML-2.4.2})
find_package(SFML 3.1 REQUIRED audio graphics network system window)

include_directories(${SFML_INCLUDE_DIR})
link_libraries(${SFML_LIBRARIES})

# Build a simple program
add_executable(test test.cpp)
