set_policy("package.requires_lock", true)
add_rules("mode.debug", "mode.release")
add_rules("plugin.compile_commands.autoupdate", {outputdir = "build/"})

add_requires("raylib 6.0", {configs = {shared = true}})
add_requires("raygui 4.0")

target("interface")
  set_kind("phony")
  add_packages("raylib")
  after_build(function(target)
    local outputdir = path.join(os.projectdir(), "dist")
    local pkg = target:pkg("raylib")
    if pkg then
      local installdir = pkg:installdir()
      local includedir = path.join(outputdir, "include")
      os.mkdir(includedir)
      os.cp(path.join(installdir, "include", "**.h"), includedir)
    end
  end)

target("basic")
  set_kind("binary")
  add_files("example/001_core_basic_window.c")
  add_packages("raylib")

---------------------------------------------------------
--- Examples
---------------------------------------------------------
-- for _, file in ipairs(os.files("example/*.c")) do
--     local name = path.basename(file)
--     target(name)
--       set_kind("binary")
--       add_files(file)
--       add_packages("raylib")
--       add_packages("raygui")
--       add_includedirs("example/others")
-- end
