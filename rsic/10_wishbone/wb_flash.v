//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2014 leishangwen@163.com                       ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Module:  flash_top
// File:    wb_flash.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: Nor Flash Controller for DE2    
// Revision: 1.0
//////////////////////////////////////////////////////////////////////
`include "spi_flash_defines.v"
module flash_top(
    // Parallel FLASH Interface
    wb_clk_i, wb_rst_i, wb_adr_i, wb_dat_o, wb_dat_i, wb_sel_i, wb_we_i,
    wb_stb_i, wb_cyc_i, wb_ack_o,
	 dclk, ncs, mosi, miso
//    flash_adr_o, flash_dat_i, flash_rst,
//    flash_oe, flash_ce, flash_we
);

    //
    // Default address and data bus width
    //
    parameter aw = 19;   // number of address-bits
    parameter dw = 32;   // number of data-bits
    parameter ws = 4'h3; // number of wait-states

    //
    // FLASH interface
    //
    input   wb_clk_i;
    input   wb_rst_i;
    input   [31:0] wb_adr_i;
    output reg [dw-1:0] wb_dat_o;
    input   [dw-1:0] wb_dat_i;
    input   [3:0] wb_sel_i;
    input   wb_we_i;
    input   wb_stb_i;
    input   wb_cyc_i;
    output reg wb_ack_o;
//    output reg [31:0] flash_adr_o;
//    input   [7:0] flash_dat_i;
//    output  flash_rst;
//    output  flash_oe;
//    output  flash_ce;
//    output  flash_we;
    reg [3:0] waitstate;
    wire    [1:0] adr_low;
	 
	output           ncs;
	output           dclk; // clock
	output           mosi; // master output
	input            miso; //maser input
	 
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

    // Wishbone read/write accesses
    wire wb_acc = wb_cyc_i & wb_stb_i;    // WISHBONE access
//    wire wb_wr  = wb_acc & wb_we_i;       // WISHBONE write access
//    wire wb_rd  = wb_acc & !wb_we_i;      // WISHBONE read access

    always @(posedge wb_clk_i) begin
        if( wb_rst_i == 1'b1 ) begin
            waitstate <= 4'h0;
            wb_ack_o <= 1'b0;
				
				flash_read <= 1'b0;
				flash_write <= 1'b0;
				flash_bulk_erase <= 1'b0;
				flash_sector_erase <= 1'b0;
				flash_read_addr <= 24'd0;
				flash_write_addr <= 24'd0;
				flash_sector_addr <= 24'd0;
				flash_write_data_in <= 8'd0;
        end else if(wb_acc == 1'b0) begin
            waitstate <= 4'h0;
            wb_ack_o <= 1'b0;
            wb_dat_o <= 32'h00000000;
        end else if(waitstate == 4'h0) begin
            wb_ack_o <= 1'b0;
            if(wb_acc) begin
              waitstate <= waitstate + 4'h1;
					 flash_read <= 1'b1;
            end
//				flash_adr_o <= {10'b0000000000,wb_adr_i[21:2],2'b00};
				flash_read_addr <= {wb_adr_i[23:2], 2'b00};

        end else begin
//            waitstate <= waitstate + 4'h1;
				    if(waitstate == 4'h1) begin
							if(flash_read_data_valid == 1'b1) begin
								wb_dat_o[31:24] <= flash_read_data_out;
							end
							if(flash_read_ack == 1'b1) begin
							  flash_read_addr <= {wb_adr_i[23:2], 2'b01};
							  waitstate <= waitstate + 4'h1;
							 end
						end else if(waitstate == 4'h2) begin
							if(flash_read_data_valid == 1'b1) begin
								wb_dat_o[23:16] <= flash_read_data_out;
							end
							if(flash_read_ack == 1'b1) begin
							  flash_read_addr <= {wb_adr_i[23:2], 2'b10};
							  waitstate <= waitstate + 4'h1;
							 end
						end else if(waitstate == 4'h3) begin
							if(flash_read_data_valid == 1'b1) begin
								wb_dat_o[15:8] <= flash_read_data_out;
							end
							if(flash_read_ack == 1'b1) begin
							  flash_read_addr <= {wb_adr_i[23:2], 2'b11};
							  waitstate <= waitstate + 4'h1;
							 end
						end else if(waitstate == 4'h4) begin
							if(flash_read_data_valid == 1'b1) begin
								wb_dat_o[7:0] <= flash_read_data_out;
							end
							if(flash_read_ack == 1'b1) begin
							  waitstate <= waitstate + 4'h1;
							 end
							wb_ack_o <= 1'b1;
						end else if(waitstate == 4'hd) begin
               wb_ack_o <= 1'b0;
               waitstate <= 4'h0;
            end
         end
      end

//    assign flash_ce = wb_acc;			//flash使能 高有效
//    assign flash_we = 1'b1;
//    assign flash_oe = !wb_rd;


//    assign flash_rst = !wb_rst_i;
	 
spi_flash_top spi_flash_top_m0(
	.sys_clk                     (clk                      ),
	.rst                         (~wb_rst_i                ),
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
