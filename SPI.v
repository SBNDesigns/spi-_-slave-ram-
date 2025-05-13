module SPI (
    input MOSI, ss_n, clk, rst_n, tx_valid,
    input [7:0] tx_data,
    output reg [9:0] rx_data, 
    output reg MISO , rx_valid
);
 localparam IDLE = 3'b000 ,CHK_CMD = 3'b001, WRITE = 3'b010 , READ_ADD = 3'b011 , READ_DATA = 3'b100 ;
    reg [2:0] cs, ns ;
    reg read_enable ;
    reg [3:0] counter_1 ;
    reg [2:0] counter_2 ;
    reg [9:0] data ;
    always @(posedge clk ) begin
        if (~rst_n)
        cs <= IDLE;
        else 
        cs <= ns; 
        end
        // next state 
        always @(*) begin 
            case (cs) 
            IDLE : begin 
                if (ss_n == 1)
                ns = IDLE;
                else
                ns = CHK_CMD;
            end

            CHK_CMD : begin
                if (ss_n == 0 && MOSI == 0)
                ns = WRITE ;
                else if ( ss_n ==0 && MOSI == 1 && read_enable == 1) 
                ns = READ_ADD ;
                else 
                ns = READ_DATA ;
            end

            WRITE : begin
                if (ss_n == 1)
                ns = IDLE;
                else 
                ns = WRITE;
            end

            READ_ADD:  begin
                if (ss_n == 1)
                ns = IDLE;
                else 
                ns = READ_ADD;
            end

            READ_DATA : begin
                if (ss_n == 1)
                ns = IDLE ;
                else 
                ns = READ_DATA;
                end
            default : ns = IDLE;
            endcase 
        end
// OUTPUT
        always@(posedge clk )begin
            if (~rst_n) begin
            MISO <= 0; rx_data <= 0;  rx_valid <= 0;  counter_1 <= 9;counter_2 <= 7; read_enable <= 1; data <= 0; 
            end
            else begin
                 if (cs == IDLE) begin
                counter_1 <= 9;
                counter_2 <= 7;
                rx_valid <= 0;
                 end

                else if ( cs == WRITE ) begin
                    if (counter_1 >=0)begin
                     data[counter_1] <= MOSI ; // serial to parallel
                    counter_1 <= counter_1 - 1;
                    end
                    if (counter_1 == 0) begin
                    rx_valid <= 1;
                    rx_data <= data;
                end 
                end

                else if ( cs == READ_ADD ) begin
                    if (counter_1>=0)begin
                     data[counter_1] <= MOSI ; // serial to parallel
                    counter_1 <= counter_1 - 1;
                    end
                    if (counter_1 == 0) begin
                    rx_valid <= 1;
                    rx_data <= data;
                    read_enable <= 0 ; //R-ADDR is recieved
                end
                end

                else if (cs == READ_DATA) begin    
                  if (counter_1 >= 0)begin
                data[counter_1] <= MOSI;
                counter_1 <= counter_1 - 1;   
                end
            if(counter_1 == 0) begin
                rx_valid <= 1;
                rx_data <= data ; 
                counter_1 <= 9 ;
            end
            if(rx_valid  == 1) rx_valid <= 0; 
            if(tx_valid==1 && counter_2 >=0)begin
                MISO <= tx_data[counter_2] ; //counter-2 as it it's an 8 bit bus not 10 bit bus 
                counter_2 <= counter_2 - 1 ;
            end
            if(counter_2 == 7)begin
                read_enable <= 1;
                end
            end
            end
        end
            
endmodule