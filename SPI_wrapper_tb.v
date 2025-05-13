
module SPI_wrapper_tb();
reg clk , ss_n , MOSI , rst_n ;
wire MISO;

SPI_wrapper  dut (MOSI, ss_n, clk , rst_n , MISO);
initial begin
    clk = 0;
    forever #5 clk = ~clk; 
end
initial begin
    rst_n = 0 ;
    @(negedge clk);
    rst_n = 1;
    ss_n = 0; //Activate Communication
   //Write address
    #10 MOSI = 0; //Control bit for the write process
    #10 MOSI = 0;
    #10 MOSI = 0; //din[9:8] = 2'b00

    #10 MOSI = 1;
    #10 MOSI = 1;
    #10 MOSI = 1;
    #10 MOSI = 1;
    #10 MOSI = 0;
    #10 MOSI = 0;
    #10 MOSI = 0;
    #10 MOSI = 0;
    //address finished
    #20 ss_n = 1; //Back to idle state
    repeat(4) @(negedge clk) ; 


    ss_n = 0; 
    // Write data 
    #10 MOSI = 0; //Control bit for the write process
    #10 MOSI = 0;
    #10 MOSI = 1; //din[9:8] = 2'b01
    repeat(8) begin
        #10 MOSI = $random; //randomize the data 
    end
    #10 ss_n = 1; //end communication
    repeat(4) @(negedge clk) ; 


    ss_n = 0; 
    // Read address 
    #10 MOSI = 1; //Control bit for the read prcoess
    #10 MOSI = 1;
    #10 MOSI = 0; //din[9:8] = 2'b10
// Read_enable is by default high when we asserted the reset so the cs is READ_ADD
    #10 MOSI = 1;
    #10 MOSI = 1;
    #10 MOSI = 1;
    #10 MOSI = 1;
    #10 MOSI = 0;
    #10 MOSI = 0;
    #10 MOSI = 0;
    #10 MOSI = 0;
    //address finished   
    #20 ss_n = 1; //end Communication
    repeat(4) @(negedge clk) ;//time to wait until the next process comes


    ss_n = 0; 
    // Read data 
    #10 MOSI = 1; //Control a read process
    #10 MOSI = 1; 
    #10 MOSI = 1; //din[9:8] == 2'b11

    repeat(8) begin
        #10 MOSI = $random; //Doesn't matter as it will be ignored
    end
    #100 ss_n = 1; //10 clocks
    repeat(4) @(negedge clk) ; 
    $stop;
end
endmodule