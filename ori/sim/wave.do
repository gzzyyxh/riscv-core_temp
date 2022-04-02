onerror {resume}
quietly set dataset_list [list sim vsim]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/clk
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/rst
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/inst_addr
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/inst
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/rom_ce
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/rom_data_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/rom_addr_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/rom_ce_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/pc
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_pc_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_inst_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_aluop_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_alusel_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_reg1_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_reg2_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_wreg_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_wd_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_aluop_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_alusel_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_reg1_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_reg2_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_wreg_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_wd_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_wreg_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_wd_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_wdata_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wreg_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wd_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wdata_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wreg_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wd_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wdata_o
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/wb_wreg_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/wb_wd_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/wb_wdata_i
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/reg1_read
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/reg2_read
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/reg1_data
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/reg2_data
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/reg1_addr
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/reg2_addr
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/inst_rom0/addr
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/inst_rom0/inst
add wave -noupdate -radix hexadecimal sim:/openmips_min_sopc_tb/openmips_min_sopc0/inst_rom0/inst_mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 414
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {204139 ps} {332968 ps}
