source "../src/config.tcl"

open_project $build_dir/$project_name.xpr

ipx::open_ipxact_file $build_dir/component.xml
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
