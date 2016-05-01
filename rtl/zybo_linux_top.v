module zybo_linux_top(
    inout wire [14:0]DDR_addr,
    inout wire [2:0]DDR_ba,
    inout wire DDR_cas_n,
    inout wire DDR_ck_n,
    inout wire DDR_ck_p,
    inout wire DDR_cke,
    inout wire DDR_cs_n,
    inout wire [3:0]DDR_dm,
    inout wire [31:0]DDR_dq,
    inout wire [3:0]DDR_dqs_n,
    inout wire [3:0]DDR_dqs_p,
    inout wire DDR_odt,
    inout wire DDR_ras_n,
    inout wire DDR_reset_n,
    inout wire DDR_we_n,
    inout wire FIXED_IO_ddr_vrn,
    inout wire FIXED_IO_ddr_vrp,
    inout wire [53:0]FIXED_IO_mio,
    inout wire FIXED_IO_ps_clk,
    inout wire FIXED_IO_ps_porb,
    inout wire FIXED_IO_ps_srstb,
	inout wire iic_0_scl_io,
	inout wire iic_0_sda_io,

	// CLOCK
	input clk_i,		//clock

	// LED
	output wire [3:0] led_o
    );

//-----------------------------------------------------------------------------
// Connections to PS
	wire [3:0] fclk;		// [0]-125MHz, [1]-250MHz, [2]-50MHz, [3]-200MHz
	wire [3:0] frstn;

	wire ps_sys_clk;
	wire ps_sys_rstn;
	wire [31:0] ps_sys_addr;
	wire [31:0] ps_sys_wdata;
	wire [3:0] ps_sys_sel;
	wire ps_sys_wen;
	wire ps_sys_ren;
	wire [31:0] ps_sys_rdata;
	wire ps_sys_err;
	wire ps_sys_ack;

// AXI master
	wire axi0_clk;
	wire axi0_rstn;
	wire [31:0] axi0_waddr;
	wire [63:0] axi0_wdata;
	wire [7:0] axi0_wsel;
	wire axi0_wvalid;
	wire [3:0] axi0_wlen;
	wire axi0_wfixed;
	wire axi0_werr;
	wire axi0_wrdy;

	
	system_ps i_ps (
		.DDR_addr(DDR_addr),
		.DDR_ba(DDR_ba),
		.DDR_cas_n(DDR_cas_n),
		.DDR_ck_n(DDR_ck_n),
		.DDR_ck_p(DDR_ck_p),
		.DDR_cke(DDR_cke),
		.DDR_cs_n(DDR_cs_n),
		.DDR_dm(DDR_dm),
		.DDR_dq(DDR_dq),
		.DDR_dqs_n(DDR_dqs_n),
		.DDR_dqs_p(DDR_dqs_p),
		.DDR_odt(DDR_odt),
		.DDR_ras_n(DDR_ras_n),
		.DDR_reset_n(DDR_reset_n),
		.DDR_we_n(DDR_we_n),
		.FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
		.FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
		.FIXED_IO_mio(FIXED_IO_mio),
		.FIXED_IO_ps_clk(FIXED_IO_ps_clk),
		.FIXED_IO_ps_porb(FIXED_IO_ps_porb),
		.FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
		.fclk_clk_o(fclk),
		.fclk_rstn_o(frstn),
		.sys_clk_o(ps_sys_clk),
		.sys_rstn_o(ps_sys_rstn),
		.sys_addr_o(ps_sys_addr),
		.sys_wdata_o(ps_sys_wdata),
		.sys_sel_o(ps_sys_sel),
		.sys_wen_o(ps_sys_wen),
		.sys_ren_o(ps_sys_ren),
		.sys_rdata_i(ps_sys_rdata),
		.sys_err_i(ps_sys_err),
		.sys_ack_i(ps_sys_ack),
		.axi0_clk_i(axi0_clk),
		.axi0_rstn_i(axi0_rstn),
		.axi0_waddr_i(axi0_waddr),
		.axi0_wdata_i(axi0_wdata),
		.axi0_wsel_i(axi0_wsel),
		.axi0_wvalid_i(axi0_wvalid),
		.axi0_wlen_i(axi0_wlen),
		.axi0_wfixed_i(axi0_wfixed),
		.axi0_werr_o(axi0_werr),
		.axi0_wrdy_o(axi0_wrdy),
		.iic_0_scl_io(iic_0_scl_io),
		.iic_0_sda_io(iic_0_sda_io)
	);

// system bus

	wire sys_clk = ps_sys_clk;
	wire sys_rstn = ps_sys_rstn;
	wire [31:0] sys_addr = ps_sys_addr;
	wire [31:0] sys_wdata = ps_sys_wdata;
	wire [3:0] sys_sel = ps_sys_sel;
	wire sys_wen = ps_sys_wen;
	wire sys_ren = ps_sys_ren;
	wire [31:0] sys_rdata;
	wire sys_err;
	wire sys_ack;

	assign ps_sys_rdata = sys_rdata;
	assign ps_sys_err = sys_err;
	assign ps_sys_ack = sys_ack;

// local signals

	wire clk;
	reg rstn;

	BUFG bufg_clk (.O(clk), .I(clk_i));

// ADC reset (active low)
	always @(posedge clk)
		rstn <= frstn[0];

	assign axi0_clk = clk;
	assign axi0_rstn = rstn;

	system_pl i_pl (
		.clk_i(sys_clk),
		.rstn_i(sys_rstn),
		.sys_addr_i(sys_addr),
		.sys_wdata_i(sys_wdata),
		.sys_wen_i(sys_wen),
		.sys_ren_i(sys_ren),
		.sys_rdata_o(sys_rdata),
		.sys_err_o(sys_err),
		.sys_ack_o(sys_ack),
		.axi0_waddr_o(axi0_waddr),
		.axi0_wdata_o(axi0_wdata),
		.axi0_wsel_o(axi0_wsel),
		.axi0_wvalid_o(axi0_wvalid),
		.axi0_wlen_o(axi0_wlen),
		.axi0_wfixed_o(axi0_wfixed),
		.axi0_werr_i(axi0_werr),
		.axi0_wrdy_i(axi0_wrdy),
		.led_o(led_o)
	);
endmodule
