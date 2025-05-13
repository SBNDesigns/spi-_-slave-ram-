# spi-_-slave-ram-
SPI (Serial Peripheral Interface) is a synchronous serial communication protocol used to transfer data between a master (like a microcontroller) and one or more slave devices (like sensors, memory chips, or FPGAs).

SPI has 4 main signals:

SCLK: Serial Clock (from master)

MOSI: Master Out Slave In (data from master)

MISO: Master In Slave Out (data to master)

SS: Slave Select (active low)

A SPI slave is the receiving/responding device. It waits for the master to send clock and data signals, and it responds accordingly—either reading data or sending data back.

In this case, the SPI Slave is your custom logic (usually inside an FPGA or ASIC) that communicates with a master (e.g., a microcontroller).
