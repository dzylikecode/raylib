set_policy("package.requires_lock", true)
add_rules("mode.debug", "mode.release")
add_rules("plugin.compile_commands.autoupdate", {outputdir = "build/"})

add_requires("raylib 6.0")
add_requires("raygui 4.0")

---------------------------------------------------------
--- Examples
---------------------------------------------------------
for _, file in ipairs(os.files("example/c/*.c")) do
    local name = path.basename(file)
    target(name)
      set_kind("binary")
      add_files(file)
      add_packages("raylib")
      add_packages("raygui")
      -- add_includedirs("example/others")
end
