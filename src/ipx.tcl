source "../src/config.tcl"

open_project $build_dir/$project_name.xpr
ipx::package_project -root_dir $build_dir -vendor user.org -library user -taxonomy /UserIP



ipx::add_bus_interface BRAM [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:bram_rtl:1.0 [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:bram:1.0 [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]
ipx::add_port_map RST [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]
set_property physical_name bram_rst [ipx::get_port_maps RST -of_objects [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]]
ipx::add_port_map CLK [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]
set_property physical_name bram_clk [ipx::get_port_maps CLK -of_objects [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]]
ipx::add_port_map DIN [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]
set_property physical_name bram_wrdata [ipx::get_port_maps DIN -of_objects [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]]
ipx::add_port_map EN [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]
set_property physical_name bram_en [ipx::get_port_maps EN -of_objects [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]]
ipx::add_port_map DOUT [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]
set_property physical_name bram_rddata [ipx::get_port_maps DOUT -of_objects [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]]
ipx::add_port_map WE [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]
set_property physical_name bram_we [ipx::get_port_maps WE -of_objects [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]]
ipx::add_port_map ADDR [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]
set_property physical_name bram_addr [ipx::get_port_maps ADDR -of_objects [ipx::get_bus_interfaces BRAM -of_objects [ipx::current_core]]]



ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces bram_clk -of_objects [ipx::current_core]]
set_property value BRAM [ipx::get_bus_parameters ASSOCIATED_BUSIF -of_objects [ipx::get_bus_interfaces bram_clk -of_objects [ipx::current_core]]]

ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces bram_clk -of_objects [ipx::current_core]]

set_property core_revision 4 [ipx::current_core]
set_property display_name chacha20_axi_v1_0 [ipx::current_core]
set_property description chacha20_axi_v1_0 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]

close_project

