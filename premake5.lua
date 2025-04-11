-- User options (similar to CMake options)
newoption {
   trigger = "buildlib",
   description = "Build GLM as a static library with implementation files"
}

newoption { trigger = "cxx98", description = "Enable C++98" }
newoption { trigger = "cxx11", description = "Enable C++11" }
newoption { trigger = "cxx14", description = "Enable C++14" }
newoption { trigger = "cxx17", description = "Enable C++17" }
newoption { trigger = "cxx20", description = "Enable C++20" }

newoption {
   trigger = "fastmath",
   description = "Enable fast math optimizations"
}

newoption {
   trigger = "pure",
   description = "Force pure math (no SIMD)"
}

newoption {
   trigger = "simd", value = "LEVEL",
   description = "Enable SIMD instruction set (sse2, sse3, ssse3, sse41, sse42, avx, avx2)",
   allowed = {
      { "sse2", "SSE2" }, { "sse3", "SSE3" }, { "ssse3", "SSSE3" },
      { "sse41", "SSE4.1" }, { "sse42", "SSE4.2" },
      { "avx", "AVX" }, { "avx2", "AVX2" }
   }
}

workspace "GLM"
   configurations { "Debug", "Release" }
   architecture "x86_64"

project "glm"
   kind (_OPTIONS["buildlib"] and "StaticLib" or "None")
   language "C++"
   staticruntime "on"
   location "build"
   targetdir "bin/%{cfg.buildcfg}"
   objdir "bin-int/%{cfg.buildcfg}"

   files {
      "glm/*.cpp", "glm/*.inl", "glm/*.hpp",
      "../*.txt", "../*.md", "../util/glm.natvis",
      "glm/detail/**.cpp", "glm/detail/**.inl", "glm/detail/**.hpp",
      "glm/ext/**.cpp", "glm/ext/**.inl", "glm/ext/**.hpp",
      "glm/gtc/**.cpp", "glm/gtc/**.inl", "glm/gtc/**.hpp",
      "glm/gtx/**.cpp", "glm/gtx/**.inl", "glm/gtx/**.hpp",
      "glm/simd/**.cpp", "glm/simd/**.inl", "glm/simd/**.h"
   }

   includedirs { "glm" }

   vpaths {
      ["Text Files"] = { "../*.txt", "../*.md" },
      ["Core Files"] = { "glm/detail/**" },
      ["EXT Files"]  = { "glm/ext/**" },
      ["GTC Files"]  = { "glm/gtc/**" },
      ["GTX Files"]  = { "glm/gtx/**" },
      ["SIMD Files"] = { "glm/simd/**" },
   }

   -- Define macro if building the library
   filter "options:buildlib"
      defines { "GLM_BUILD_LIBRARY" }

   -- C++ version filters
   filter "options:cxx20"
      cppdialect "C++20"
      defines { "GLM_FORCE_CXX20" }

   filter "options:cxx17"
      cppdialect "C++17"
      defines { "GLM_FORCE_CXX17" }

   filter "options:cxx14"
      cppdialect "C++14"
      defines { "GLM_FORCE_CXX14" }

   filter "options:cxx11"
      cppdialect "C++11"
      defines { "GLM_FORCE_CXX11" }

   filter "options:cxx98"
      cppdialect "C++98"
      defines { "GLM_FORCE_CXX98" }

   -- Fast math
   filter "options:fastmath"
      defines { "GLM_FAST_MATH" }
      buildoptions { "-ffast-math" }
      buildoptions { "/fp:fast" }

   -- Pure math
   filter "options:pure"
      defines { "GLM_FORCE_PURE" }
      buildoptions { "-mfpmath=387" }

   -- SIMD support
   filter "options:simd:sse2"
      defines { "GLM_FORCE_INTRINSICS" }
      buildoptions { "-msse2" }

   filter "options:simd:sse3"
      defines { "GLM_FORCE_INTRINSICS" }
      buildoptions { "-msse3" }

   filter "options:simd:ssse3"
      defines { "GLM_FORCE_INTRINSICS" }
      buildoptions { "-mssse3" }

   filter "options:simd:sse41"
      defines { "GLM_FORCE_INTRINSICS" }
      buildoptions { "-msse4.1" }

   filter "options:simd:sse42"
      defines { "GLM_FORCE_INTRINSICS" }
      buildoptions { "-msse4.2" }

   filter "options:simd:avx"
      defines { "GLM_FORCE_INTRINSICS" }
      buildoptions { "-mavx" }

   filter "options:simd:avx2"
      defines { "GLM_FORCE_INTRINSICS" }
      buildoptions { "-mavx2" }

   -- Clang warnings suppression
   filter "toolset:clang"
      buildoptions { "-Wno-c++98-compat", "-Wno-c++98-compat-pedantic" }

   filter "system:windows"
      systemversion "latest"

   filter "configurations:Debug"
      runtime "Debug"
      symbols "on"

   filter "configurations:Release"
      runtime "Release"
      optimize "on"

-- Header-only dummy project for interface-style linking
project "glm-header-only"
   kind "None"
   language "C++"
   includedirs { "glm" }
