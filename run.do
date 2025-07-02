vlib work
vlog -sv can_tx_crc.sv
vlog -sv can_tx_crc_tb.sv
vsim -voptargs=+acc work.can_tx_crc_tb

add wave -divider "Testbench Signals"
add wave sim:/can_tx_crc_tb/clk
add wave sim:/can_tx_crc_tb/rst_n
add wave sim:/can_tx_crc_tb/start
add wave sim:/can_tx_crc_tb/id
add wave sim:/can_tx_crc_tb/data
add wave sim:/can_tx_crc_tb/tx
add wave sim:/can_tx_crc_tb/busy
add wave sim:/can_tx_crc_tb/crc_out

add wave -divider "DUT Internal Signals"
add wave sim:/can_tx_crc_tb/uut/state
add wave sim:/can_tx_crc_tb/uut/next_state
add wave sim:/can_tx_crc_tb/uut/bit_cnt
add wave sim:/can_tx_crc_tb/uut/shift_reg
add wave sim:/can_tx_crc_tb/uut/crc_reg
add wave sim:/can_tx_crc_tb/uut/crc_cnt

run 500us
wave zoom full

