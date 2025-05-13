vlib work
vlog RAM.v SPI.v SPI_wrapper.v SPI_wrapper_tb.v 
vsim -voptargs=+acc work.SPI_wrapper_tb
add wave *
add wave -hex SPI_wrapper_tb.dut.DUT1.rx_data
add wave -hex SPI_wrapper_tb.dut.DUT1.tx_data
add wave SPI_wrapper_tb.dut.DUT1.rx_valid
add wave SPI_wrapper_tb.dut.DUT1.tx_valid
run -all
