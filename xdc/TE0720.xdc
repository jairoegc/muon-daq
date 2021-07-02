## Voltage config
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[0]}]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[0]}]

set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[1]}]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[1]}]

set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[2]}]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[2]}]

set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[3]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[3]}]

set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[4]}]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[4]}]

set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[5]}]
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[5]}]

set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[6]}]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[6]}]

set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[7]}]
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[7]}]

set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[8]}]
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[8]}]

set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[9]}]
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[9]}]

set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[10]}]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[10]}]

set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[11]}]
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[11]}]

set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[12]}]
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[12]}]

set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[13]}]
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[13]}]

set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[14]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[14]}]

set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVDS_25} [get_ports {Ch_A_P[15]}]
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVDS_25} [get_ports {Ch_A_N[15]}]


set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS33} [get_ports trigger]


#set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports B13_IO25];
#set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS33} [get_ports B13_IO0];

# set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
# set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
# set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
# connect_debug_port dbg_hub/clk [get_nets clk]
