## This file is a general .xdc for the Arty A7-35 Rev. D
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];

# Switches
set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 } [get_ports { hp }]; #IO_L12N_T1_MRCC_16 Sch=sw[0]
set_property -dict { PACKAGE_PIN C11   IOSTANDARD LVCMOS33 } [get_ports { lp }]; #IO_L13P_T2_MRCC_16 Sch=sw[1]
#set_property -dict { PACKAGE_PIN C10   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }]; #IO_L13N_T2_MRCC_16 Sch=sw[2]
#set_property -dict { PACKAGE_PIN A10   IOSTANDARD LVCMOS33 } [get_ports { sw[3] }]; #IO_L14P_T2_SRCC_16 Sch=sw[3]

#set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 } [get_ports { muted }]; #IO_L18N_T2_35 Sch=led0_b

# Pmod Header JA
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { tx_mclk }]; #IO_0_15 Sch=ja[1]
set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports { tx_lrck }]; #IO_L4P_T0_15 Sch=ja[2]
set_property -dict { PACKAGE_PIN A11   IOSTANDARD LVCMOS33 } [get_ports { tx_sclk }]; #IO_L4N_T0_15 Sch=ja[3]
set_property -dict { PACKAGE_PIN D12   IOSTANDARD LVCMOS33 } [get_ports { tx_data }]; #IO_L6P_T0_15 Sch=ja[4]
set_property -dict { PACKAGE_PIN D13   IOSTANDARD LVCMOS33 } [get_ports { rx_mclk }]; #IO_L6N_T0_VREF_15 Sch=ja[7]
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { rx_lrck }]; #IO_L10P_T1_AD11P_15 Sch=ja[8]
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { rx_sclk }]; #IO_L10N_T1_AD11N_15 Sch=ja[9]
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { rx_data }]; #IO_25_15 Sch=ja[10]

## Misc. ChipKit Ports
#set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { ck_ioa }]; #IO_L10N_T1_D15_14 Sch=ck_ioa
set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { reset }]; #IO_L16P_T2_35 Sch=ck_rst

## OUT SERIAL
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { tx_data }]; #IO_L19N_T3_VREF_16 Sch=uart_rxd_out
