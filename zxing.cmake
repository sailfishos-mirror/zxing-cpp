
macro(zxing_add_package_stb)
    unset (STB_FOUND CACHE)

    if (BUILD_DEPENDENCIES STREQUAL "AUTO")
        find_package(PkgConfig)
        pkg_check_modules (STB IMPORTED_TARGET stb)
    elseif (BUILD_DEPENDENCIES STREQUAL "LOCAL")
        find_package(PkgConfig REQUIRED)
        pkg_check_modules (STB REQUIRED IMPORTED_TARGET stb)
    endif()

    if (NOT STB_FOUND)
        include(FetchContent)
        FetchContent_Declare (stb
            GIT_REPOSITORY https://github.com/nothings/stb.git)
        FetchContent_MakeAvailable (stb)
        add_library(stb::stb INTERFACE IMPORTED)
        target_include_directories(stb::stb INTERFACE ${stb_SOURCE_DIR})
    else()
        add_library(stb::stb ALIAS PkgConfig::STB)
    endif()
endmacro()

macro(zxing_add_package name git_repo git_rev)
    unset(${name}_FOUND CACHE) # see https://github.com/nu-book/zxing-cpp/commit/8db14eeead45e0f1961532f55061d5e4dd0f78be#commitcomment-66464026

    if (BUILD_DEPENDENCIES STREQUAL "AUTO")
        find_package (${name} CONFIG)
    elseif (BUILD_DEPENDENCIES STREQUAL "LOCAL")
        find_package (${name} REQUIRED CONFIG)
    endif()

    if (NOT ${name}_FOUND)
        include(FetchContent)
        FetchContent_Declare (${name}
            GIT_REPOSITORY ${git_repo}
            GIT_TAG ${git_rev})
        FetchContent_MakeAvailable (${name})
        set (${name}_POPULATED TRUE) # this is supposed to be done in MakeAvailable but it seems not to?!?
    endif()
endmacro()