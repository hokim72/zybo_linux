`timescale 1ns / 1ps

module system_pl(
	input wire	clk_i,
	input wire rstn_i,

	input wire [31:0] sys_addr_i,
	input wire [31:0] sys_wdata_i,
	input wire sys_wen_i,
	input wire sys_ren_i,
	output wire [31:0] sys_rdata_o,
	output wire sys_err_o,
	output wire sys_ack_o,

	output wire [31:0] axi0_waddr_o,
	output wire [63:0] axi0_wdata_o,
	output wire [7:0] axi0_wsel_o,
	output wire axi0_wvalid_o,
	output wire [3:0] axi0_wlen_o,
	output wire axi0_wfixed_o,
	input wire axi0_werr_i,
	input wire axi0_wrdy_i,
	output wire [3:0] led_o
    );


	/*
	wire [31:0] next_addr;
	reg [63:0] wr_data_reg, wr_data_next;
	reg wr_val_reg, wr_val_next;
	reg clr_buf;

	axi_wr_fifo #(
	  .DW  (  64    ), // data width (8,16,...,1024)
	  .AW  (  32    ), // address width
	  .FW  (   8    )  // address width of FIFO pointers
	) i_wr0 (
	   // global signals
	  .axi_clk_i          (  clk_i   		   ), // global clock
	  .axi_rstn_i         (  rstn_i 	       ), // global reset

	   // Connection to AXI master
	  .axi_waddr_o        (  axi0_waddr_o      ), // write address
	  .axi_wdata_o        (  axi0_wdata_o      ), // write data
	  .axi_wsel_o         (  axi0_wsel_o       ), // write byte select
	  .axi_wvalid_o       (  axi0_wvalid_o     ), // write data valid
	  .axi_wlen_o         (  axi0_wlen_o       ), // write burst length
	  .axi_wfixed_o       (  axi0_wfixed_o     ), // write burst type (fixed / incremental)
	  .axi_werr_i         (  axi0_werr_i       ), // write error
	  .axi_wrdy_i         (  axi0_wrdy_i       ), // write ready

   // data and configuration
	  .wr_data_i          (  wr_data_reg       ), // write data
	  .wr_val_i           (  wr_val_reg 	   ), // write data valid
	  .ctrl_start_addr_i  (  32'h1E000000 	   ), // range start address
	  .ctrl_stop_addr_i   (  32'h1E003FF8	   ), // range stop address
	  .ctrl_trig_size_i   (  4'hF              ), // trigger level
	  .ctrl_wrap_i        (  1'b1              ), // start from begining when reached stop
	  .ctrl_clr_i         (  clr_buf           ), // clear / flush
	  .stat_overflow_o    (                    ), // overflow indicator
	  .stat_cur_addr_o    (  next_addr    	   ), // current write address
	  .stat_write_data_o  (                    )  // write data indicator
	);
	*/

	reg sys_ack_o_reg;
	wire  sys_ack_o_next;
	reg [31:0] sys_rdata_o_reg, sys_rdata_o_next;

	always @(posedge clk_i, negedge rstn_i)
		if (~rstn_i)
			begin
				sys_ack_o_reg <= 1'b0;
				sys_rdata_o_reg <= 32'h0;
			end
		else
			begin
				sys_ack_o_reg <= sys_ack_o_next;
				sys_rdata_o_reg <= sys_rdata_o_next;
			end

	assign sys_ack_o_next = sys_wen_i | sys_ren_i;
	assign sys_ack_o = sys_ack_o_reg;
	assign sys_err_o = 1'b0;

	reg [3:0] led_o_reg, led_o_next;

	always @(posedge clk_i, negedge rstn_i)
		if (~rstn_i)
			begin
				led_o_reg <= 4'h0;
			end
		else
			begin
				led_o_reg <= led_o_next;
			end

	always @*
	begin
		if (sys_wen_i)
			casez (sys_addr_i[19:0])
				20'h00000 : led_o_next = sys_wdata_i[3:0];
			endcase
	end

	always @*
		if (sys_ren_i)
			casez (sys_addr_i[19:0])
				20'h00000 : sys_rdata_o_next = {{28{1'b0}}, led_o_reg};
				default   : sys_rdata_o_next = 32'h0;
			endcase

	assign sys_rdata_o = sys_rdata_o_reg;

	assign led_o = led_o_reg;

endmodule
