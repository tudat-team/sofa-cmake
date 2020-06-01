#    Copyright (c) 2010-2019, Delft University of Technology
#    All rigths reserved
#
#    This file is part of the Tudat. Redistribution and use in source and
#    binary forms, with or without modification, are permitted exclusively
#    under the terms of the Modified BSD license. You should have received
#    a copy of the license with this file. If not, please or visit:
#    http://tudat.tudelft.nl/LICENSE.
#
#    Note that this license only applies to this CMakeLists.txt file, not the
#    sofa library itself
#

# Specify minimum CMake version required to compile cspice.
cmake_minimum_required(VERSION 3.3)

# Specific project name.
project(Sofa VERSION 1.0.0 LANGUAGES C)

# Offer the user the choice of overriding the installation directories
set(INSTALL_LIB_DIR ${CMAKE_INSTALL_PREFIX}/lib CACHE PATH "Installation directory for libraries")
set(INSTALL_BIN_DIR ${CMAKE_INSTALL_PREFIX}/bin CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include CACHE PATH "Installation directory for header files")
set(INSTALL_DATA_DIR ${CMAKE_INSTALL_PREFIX}/data/ CACHE PATH "Installation directory for data files")
set(INSTALL_MAN_DIR ${CMAKE_INSTALL_PREFIX} CACHE PATH "Installation directory for man documentation")
set(INSTALL_CMAKE_DIR ${INSTALL_LIB_DIR}/cmake/sofa CACHE PATH "Installation directory for cmake config files")

# Make relative paths absolute (needed later on)
foreach (p LIB BIN INCLUDE DATA CMAKE)
    set(var INSTALL_${p}_DIR)
    set(RELATIVE_INSTALL_${p}_DIR ${INSTALL_${p}_DIR})
    if (NOT IS_ABSOLUTE "${${var}}")
        set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
    endif ()
endforeach ()

# Find relative paths for cmake-config file. (for find_package)
set(Sofa_CMAKE_DIR "${INSTALL_CMAKE_DIR}")
file(RELATIVE_PATH rel_include_dir "${Sofa_CMAKE_DIR}" "${INSTALL_INCLUDE_DIR}")
file(RELATIVE_PATH rel_lib_dir     "${Sofa_CMAKE_DIR}" "${INSTALL_LIB_DIR}")
file(RELATIVE_PATH rel_data_dir    "${Sofa_CMAKE_DIR}" "${INSTALL_DATA_DIR}")
file(RELATIVE_PATH rel_bin_dir     "${Sofa_CMAKE_DIR}" "${INSTALL_BIN_DIR}")
file(RELATIVE_PATH rel_man_dir     "${Sofa_CMAKE_DIR}" "${INSTALL_MAN_DIR}")

# Set relative paths for config.cmake.
foreach (p include lib data bin man)
    string(TOUPPER ${p} P)
    set(var RELATIVE_${CMAKE_PROJECT_NAME}_${P}_DIR)
    set(RELATIVE_${CMAKE_PROJECT_NAME}_${P}_DIR ${rel_${p}_dir})
endforeach ()

# Set the source and header files.
file(GLOB_RECURSE SOFA_HEADER_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src
        RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.h)
file(GLOB_RECURSE SOFA_SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src
        RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.c)

list(REMOVE_ITEM SOFA_SOURCE_FILES "t_sofa_c.c")

# Setup of library.
add_library(sofa STATIC "${SOFA_SOURCE_FILES}")

# Setup of namespaced library.
add_library(Sofa::sofa ALIAS sofa)


# Installation of the library.
install(TARGETS sofa
        EXPORT sofa_export
        LIBRARY DESTINATION ${RELATIVE_INSTALL_LIB_DIR}
        ARCHIVE DESTINATION ${RELATIVE_INSTALL_LIB_DIR}
        RUNTIME DESTINATION ${RELATIVE_INSTALL_BIN_DIR}
        )

# Installation of the header files.
install(DIRECTORY include/ DESTINATION "${RELATIVE_INSTALL_INCLUDE_DIR}")

# Set <project>_LIBRARIES for <project>-config.cmake.
set(Sofa_LIBRARIES "Sofa::sofa")

# Testing.
enable_testing()
add_executable(sofa-test src/t_sofa_c.c)
target_link_libraries(sofa-test Sofa::sofa)
add_test(sofa-test sofa-test)

# Configure cmake files.
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/sofa-config.cmake.in" "${CMAKE_CURRENT_BINARY_DIR}/sofa-config.cmake" @ONLY)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/sofa-config.cmake" DESTINATION ${INSTALL_CMAKE_DIR})
install(EXPORT sofa_export NAMESPACE Sofa:: DESTINATION "${RELATIVE_INSTALL_CMAKE_DIR}")

# Take care of versioning.
include(CMakePackageConfigHelpers)
# NOTE: SameMinorVersion available only
# since CMake 3.11.
if (${CMAKE_VERSION} VERSION_LESS "3.11.0")
    write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/sofa-config-version.cmake" VERSION ${Sofa_VERSION}
            COMPATIBILITY SameMajorVersion)
else ()
    write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/sofa-config-version.cmake" VERSION ${Sofa_VERSION}
            COMPATIBILITY SameMinorVersion)
endif ()
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/sofa-config-version.cmake" DESTINATION "${RELATIVE_INSTALL_CMAKE_DIR}")




# End of file.
