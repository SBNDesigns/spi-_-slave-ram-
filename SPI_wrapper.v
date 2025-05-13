
module SPI_wrapper(
input MOSI, ss_n , clk, rst_n ,
output MISO
    );
    wire [9:0] rx_data ;
    wire  rx_valid;
    wire [7:0] tx_data ;
    wire tx_valid ;
    
    SPI DUT1 (
    .MOSI(MOSI),
    .ss_n(ss_n),
    .rst_n(rst_n),
    .clk(clk),
    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .tx_data(tx_data),
    .tx_valid(tx_valid), 
    .MISO(MISO)   
    ) ; 
    
 RAM DUT2 (   
 .din(rx_data),
 .rx_valid(rx_valid),
 .clk(clk),
 .rst_n(rst_n),
 .dout(tx_data),
 .tx_valid(tx_valid)
 );    
endmodule
