project "GLM"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "on"
    location "build"

    targetdir ("out/build/bin/%{cfg.buildcfg}/%{prj.name}")
    objdir    ("out/build/obj/%{cfg.buildcfg}/%{prj.name}")

    includedirs { "include" }

    files {
        "glm/**.hpp",
        "glm/**.inl"
    }

    filter "system:windows"
        systemversion "latest"

    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        optimize "on"
