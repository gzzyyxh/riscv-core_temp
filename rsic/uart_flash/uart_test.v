`include "spi_flash_defines.v"

module uart_test(
	input                        clk,
	input                        rst_n,
	input                        uart_rx,
	output                       uart_tx,
	
	output           ncs,
	output           dclk, // clock
	output           mosi, // master output
	input            miso //maser input
);

parameter                        CLK_FRE = 50;//Mhz
localparam                       IDLE =  0;
localparam                       SEND =  1;   //send HELLO ALINX\r\n
localparam                       WAIT =  2;   //wait 1 second and send uart received data
reg[7:0]                         tx_data;
reg[7:0]                         tx_str;
reg                              tx_data_valid;
wire                             tx_data_ready;
wire[7:0]                        rx_data;
wire                             rx_data_valid;
wire                             rx_data_ready;
reg[3:0]                         state;


localparam S_IDLE       = 0;
localparam S_READ_ID    = 1;
localparam S_SE         = 2;//Sector Erase
localparam S_PP         = 3;
localparam S_READ       = 4;
localparam S_WAIT       = 5;
reg[3:0] s_state;

reg[7:0] read_data;
reg[31:0] timer;

reg            flash_read;
reg            flash_write;
reg            flash_bulk_erase;
reg            flash_sector_erase;
wire           flash_read_ack;
wire           flash_write_ack;
wire           flash_bulk_erase_ack;
wire           flash_sector_erase_ack;
reg[23:0]      flash_read_addr;
reg[23:0]      flash_write_addr;
reg[23:0]      flash_sector_addr;
reg[7:0]       flash_write_data_in;
wire[8:0]      flash_read_size;
wire[8:0]      flash_write_size;
wire           flash_write_data_req;
wire[7:0]      flash_read_data_out;
wire           flash_read_data_valid;

assign rx_data_ready = 1'b1;//always can receive data,
							//if HELLO ALINX\r\n is being sent, the received data is discarded
							
assign flash_read_size = 9'd1;
assign flash_write_size = 9'd1;

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		tx_data <= 8'd0;
		state <= IDLE;
		tx_data_valid <= 1'b0;
	end
	else
	case(state)
		IDLE:
			if(flash_read_data_valid == 1'b1) begin
				state <= SEND;
			end
		SEND:
		begin
			tx_data <= read_data;

			if(tx_data_valid && tx_data_ready)//last byte sent is complete
			begin
				tx_data_valid <= 1'b0;
				state <= WAIT;
			end
			else if(~tx_data_valid)
			begin
				tx_data_valid <= 1'b1;
			end
		end
		WAIT:
		begin

			if(rx_data_valid == 1'b1)
			begin
				tx_data_valid <= 1'b1;
				tx_data <= rx_data;   // send uart received data
			end
			else if(tx_data_valid && tx_data_ready)
			begin
				tx_data_valid <= 1'b0;
			end
			else if(flash_read_data_valid == 1'b1)
				state <= SEND;
		end
		default:
			state <= IDLE;
	endcase
end

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		s_state <= S_IDLE;

		flash_read <= 1'b0;
		flash_write <= 1'b0;
		flash_bulk_erase <= 1'b0;
		flash_sector_erase <= 1'b0;
		flash_read_addr <= 24'd0;
		flash_write_addr <= 24'd0;
		flash_sector_addr <= 24'd0;
		flash_write_data_in <= 8'd0;
		timer <= 32'd0;
	end
	else
		case(s_state)
			S_IDLE:
			begin
				if(timer >= 32'd12_499_999)
					s_state <= S_READ;
				else
					timer <= timer + 32'd1;
			end
			S_WAIT:		begin
				timer <= 32'h00000000;
				s_state <= S_IDLE;
			end
			S_READ:
			begin
				if(flash_read_data_valid == 1'b1)
					read_data <= flash_read_data_out;

				if(flash_read_ack == 1'b1)
				begin
					flash_read <= 1'd0;
					s_state <= S_WAIT;
				end
				else
				begin
					flash_read <= 1'd1;
					flash_read_addr <= flash_read_addr + 1;
					if(flash_read_addr == 24'h800000) begin
						flash_read_addr <= 24'h000000;
					end
				end
			end
			default:
				s_state <= S_IDLE;
		endcase
end

uart_rx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(115200)
) uart_rx_inst
(
	.clk                        (clk                      ),
	.rst_n                      (rst_n                    ),
	.rx_data                    (rx_data                  ),
	.rx_data_valid              (rx_data_valid            ),
	.rx_data_ready              (rx_data_ready            ),
	.rx_pin                     (uart_rx                  )
);

uart_tx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(115200)
) uart_tx_inst
(
	.clk                        (clk                      ),
	.rst_n                      (rst_n                    ),
	.tx_data                    (tx_data                  ),
	.tx_data_valid              (tx_data_valid            ),
	.tx_data_ready              (tx_data_ready            ),
	.tx_pin                     (uart_tx                  )
);


spi_flash_top spi_flash_top_m0(
	.sys_clk                     (clk                      ),
	.rst                         (~rst_n                   ),
	.nCS                         (ncs                      ),
	.DCLK                        (dclk                     ),
	.MOSI                        (mosi                     ),
	.MISO                        (miso                     ),
	.clk_div                     (16'd0                    ), // 50Mhz / 4
	.flash_read                  (flash_read               ),
	.flash_write                 (flash_write              ),
	.flash_bulk_erase            (flash_bulk_erase         ),
	.flash_sector_erase          (flash_sector_erase       ),
	.flash_read_ack              (flash_read_ack           ),
	.flash_write_ack             (flash_write_ack          ),
	.flash_bulk_erase_ack        (flash_bulk_erase_ack     ),
	.flash_sector_erase_ack      (flash_sector_erase_ack   ),
	.flash_read_addr             (flash_read_addr          ),
	.flash_write_addr            (flash_write_addr         ),
	.flash_sector_addr           (flash_sector_addr        ),
	.flash_write_data_in         (flash_write_data_in      ),
	.flash_read_size             (flash_read_size          ),
	.flash_write_size            (flash_write_size         ),
	.flash_write_data_req        (flash_write_data_req     ),
	.flash_read_data_out         (flash_read_data_out      ),
	.flash_read_data_valid       (flash_read_data_valid    )
);
endmodule
