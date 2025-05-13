Librw = "D:/f32f/librw-master"
Librwgta = "D:/f32f/librwgta-master"

workspace "rwio"
	configurations { "Release", "Debug" }
	platforms { "x86", "amd64" }
	location "build"
	system "Windows"
	cppdialect "c++17"

	filter { "platforms:x86" }
		architecture "x86"
	filter { "platforms:amd64" }
		architecture "x86_64"
	filter {}

	files { "src/*.*" }

	includedirs { Librw }
	includedirs { path.join(Librwgta, "src") }

	libdirs { path.join(Librw, "lib/win-%{cfg.platform}-null/%{cfg.buildcfg}") }
	libdirs { path.join(Librwgta, "lib/win-%{cfg.platform}-null/%{cfg.buildcfg}") }

	links { "rw", "rwgta" }
	links { "core", "geom", "gfx", "mesh", "maxutil", "maxscrpt", "bmm" }

function maxplugin1(maxsdk)
	kind "SharedLib"
	language "C++"
	targetdir "lib/%{cfg.platform}/%{cfg.buildcfg}"
	targetextension ".dli"
	characterset ("MBCS")

	includedirs { path.join(maxsdk, "include") }

	filter { "platforms:amd64" }
		libdirs { path.join(maxsdk, "x64/lib") }

		buildoptions { "\"%40" .. maxsdk .. "ProjectSettings/AdditionalCompilerOptions64.txt\"" }
	filter { "platforms:x86" }
		libdirs { path.join(maxsdk, "lib") }
		buildoptions { "\"%40" .. maxsdk .. "ProjectSettings/AdditionalCompilerOptions.txt\"" }

	filter "configurations:Debug"
		defines { "DEBUG" }
		symbols "On"

	filter "configurations:Release"
		defines { "NDEBUG" }
		optimize "On"
	filter {}
end

function maxplugin2(maxsdk)
	kind "SharedLib"
	language "C++"
	targetdir "lib/%{cfg.platform}/%{cfg.buildcfg}"
	targetextension ".dli"
	characterset ("Unicode")
	removeplatforms { "x86" }

	includedirs { path.join(maxsdk, "include") }
	libdirs { path.join(maxsdk, "lib/x64/Release") }

	buildoptions { "/GR /we4706 /we4390 /we4557 /we4546 /we4545 /we4295 /we4310 /we4130 /we4611 /we4213 /we4121 /we4715 /w34701 /w34265 /wd4244 /wd4018 /wd4819" }

	filter "configurations:Debug"
		defines { "DEBUG" }
		symbols "On"

	filter "configurations:Release"
		defines { "NDEBUG" }
		optimize "On"
	filter {}
end

project "rwio2026"
	maxsdk = "C:/Program Files/Autodesk/3ds Max 2026 SDK/maxsdk"
	maxplugin2(maxsdk)
