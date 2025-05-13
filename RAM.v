module RAM #(parameter MEM_DEPTH = 256 ,ADDR_SIZE =8)
    (
    input [ 9 : 0 ] din ,
    input rx_valid , clk , rst_n ,
    output reg [7:0] dout ,
    output reg tx_valid 
    );
    reg [ADDR_SIZE-1:0]mem[MEM_DEPTH-1:0];
    reg [7:0] r_addr, w_addr;
always @(posedge clk) begin
    if(~rst_n) begin
     dout <= 0 ;
     tx_valid <= 0 ;
     r_addr <= 0;
     w_addr <= 0;
  end else if (rx_valid) begin
    if (din[9:8] == 2'b00) begin
      w_addr <= din[7:0] ;
       tx_valid <= 0;
    end else if (din[9:8] == 2'b01) begin
      mem[w_addr] <= din[7:0] ;
    tx_valid <= 0;
    end   else if (din[9:8] == 2'b10) begin
    r_addr <= din[7:0] ;
    tx_valid <= 0;
 end   else if (din[9:8] == 2'b11) begin
    dout <= mem[r_addr] ;
      tx_valid <= 1 ;
end
end
end
    endmodule 