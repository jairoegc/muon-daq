## Voltage config
set_property CFGBVS VCCO [current_design];
set_property CONFIG_VOLTAGE 3.3 [current_design];

set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVDS_25} [get_ports Ch[0][0][1]]; #B35_L1_P
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVDS_25} [get_ports Ch[0][0][0]]; #B35_L1_N

set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVDS_25} [get_ports Ch[0][1][1]]; #B35_L6_P
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVDS_25} [get_ports Ch[0][1][0]]; #B35_L6_N

set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVDS_25} [get_ports Ch[0][2][1]]; #B35_L3_P
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVDS_25} [get_ports Ch[0][2][0]]; #B35_L3_N

set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVDS_25} [get_ports Ch[0][3][1]]; #B35_L5_P
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVDS_25} [get_ports Ch[0][3][0]]; #B35_L5_N

set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVDS_25} [get_ports Ch[0][4][1]]; #B35_L20_P
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVDS_25} [get_ports Ch[0][4][0]]; #B35_L20_N

set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVDS_25} [get_ports Ch[0][5][1]]; #B35_L23_P
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVDS_25} [get_ports Ch[0][5][0]]; #B35_L23_N

set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVDS_25} [get_ports Ch[0][6][1]]; #B35_L4_P
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVDS_25} [get_ports Ch[0][6][0]]; #B35_L4_N

set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25} [get_ports Ch[0][7][1]]; #B35_L11_P
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVDS_25} [get_ports Ch[0][7][0]]; #B35_L11_N

set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVDS_25} [get_ports Ch[0][8][1]]; #B35_L21_P ERROR corregido
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVDS_25} [get_ports Ch[0][8][0]]; #B35_L21_N ERROR corregido

set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVDS_25} [get_ports Ch[0][9][1]]; #B35_L8_P
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVDS_25} [get_ports Ch[0][9][0]]; #B35_L8_N

set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVDS_25} [get_ports Ch[0][10][1]]; #B35_L2_P
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVDS_25} [get_ports Ch[0][10][0]]; #B35_L2_N

set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVDS_25} [get_ports Ch[0][11][1]]; #B35_L22_P
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVDS_25} [get_ports Ch[0][11][0]]; #B35_L22_N

set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVDS_25} [get_ports Ch[0][12][1]]; #B35_L15_P
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVDS_25} [get_ports Ch[0][12][0]]; #B35_L15_N

set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVDS_25} [get_ports Ch[0][13][1]]; #B35_L18_P
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVDS_25} [get_ports Ch[0][13][0]]; #B35_L18_N

set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVDS_25} [get_ports Ch[0][14][1]]; #B35_L24_P
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVDS_25} [get_ports Ch[0][14][0]]; #B35_L24_N

set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVDS_25} [get_ports Ch[0][15][1]]; #B35_L10_P
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVDS_25} [get_ports Ch[0][15][0]]; #B35_L10_N

set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS33} [get_ports trigger]; #B13_L20_P
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports event_saved]; #B33_L14_P


set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS33} [get_ports	test_salida[0]]; #B13_L17_P
set_property -dict {PACKAGE_PIN U4  IOSTANDARD LVCMOS33} [get_ports test_salida[1]]; #B13_L20_N
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports	test_salida[2]]; #B13_L17_N
set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVCMOS33} [get_ports	test_salida[3]]; #B13_L16_P
set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVCMOS33} [get_ports	test_salida[4]]; #B13_L16_N
set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS33} [get_ports	test_salida[5]]; #B13_L15_P
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports test_salida[6]]; #B33_L12_P
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS33} [get_ports test_salida[7]]; #B33_L12_N
set_property -dict {PACKAGE_PIN AA17 IOSTANDARD LVCMOS33} [get_ports test_salida[8]]; #B33_L17_P
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS33} [get_ports test_salida[9]]; #B33_L17_N
set_property -dict {PACKAGE_PIN AB1 IOSTANDARD LVCMOS33} [get_ports test_salida[10]]; #B13_L15_N
set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS33} [get_ports test_salida[11]]; #B33_L18_P
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS33} [get_ports test_salida[12]]; #B33_L18_N
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS33} [get_ports test_salida[13]]; #B13_L7_P
set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVCMOS33} [get_ports test_salida[14]]; #B13_L7_N
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports test_salida[15]]; #B13_L8_P
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports test_salida[16]]; #B13_L8_N
set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS33} [get_ports test_salida[17]]; #B13_L11_P
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33} [get_ports test_salida[18]]; #B13_L11_N
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33} [get_ports test_salida[19]]; #B13_L9_P
set_property -dict {PACKAGE_PIN AB9 IOSTANDARD LVCMOS33} [get_ports test_salida[20]]; #B13_L9_N
set_property -dict {PACKAGE_PIN W8  IOSTANDARD LVCMOS33} [get_ports test_salida[21]]; #B13_L2_N
set_property -dict {PACKAGE_PIN W6  IOSTANDARD LVCMOS33} [get_ports test_salida[22]]; #B13_L24_P
set_property -dict {PACKAGE_PIN W5  IOSTANDARD LVCMOS33} [get_ports test_salida[23]]; #B13_L24_N
set_property -dict {PACKAGE_PIN U6  IOSTANDARD LVCMOS33} [get_ports test_salida[24]]; #B13_L22_P
set_property -dict {PACKAGE_PIN U5  IOSTANDARD LVCMOS33} [get_ports test_salida[25]]; #B13_L22_N
set_property -dict {PACKAGE_PIN V5  IOSTANDARD LVCMOS33} [get_ports test_salida[26]]; #B13_L21_P
set_property -dict {PACKAGE_PIN V4  IOSTANDARD LVCMOS33} [get_ports test_salida[27]]; #B13_L21_N
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports test_salida[28]]; #B33_L8_P
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports test_salida[29]]; #B33_L8_N
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33} [get_ports test_salida[30]]; #B33_L4_P
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports test_salida[31]]; #B33_L4_N


#set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports B13_IO25];
#set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS33} [get_ports B13_IO0];
