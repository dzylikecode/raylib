set_policy("package.requires_lock", true)
add_rules("mode.debug", "mode.release")
add_rules("plugin.compile_commands.autoupdate", {outputdir = "build/"})

add_requires("raylib 5.5")

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
