module dbclk_fifo_anlogic #(
	parameter	WDATAWIDTH	= 8,	//must be 1-432
	parameter	WDATADEPTH	= 512,	//only 5 values can be selected, [512, 1024, 2048, 4096, 8192]
	parameter	RDATAWIDTH	= 8,	//only 5 values can be selected, must >= 1, must <= 432
									//values: (WDATAWIDTH * (WDATADEPTH / 512)) / [1, 2, 4, 8, 16]
	parameter	RDATADEPTH	= WDATAWIDTH * WDATADEPTH / RDATAWIDTH,
	parameter	ENDIAN		= "LITTLE",		//"BIG" "LITTLE"
	parameter	ALMOSTFULL	= WDATADEPTH - 6,
	parameter	ALMOSTEMPTY	= 6
) (
	input						I_rstn,

	input						I_wclk,
	input						I_we,
	input	[WDATAWIDTH-1:0]	I_wdata,
	output						O_full,
	output						O_afull,

	input						I_rclk,
	input						I_re,
	output	[RDATAWIDTH-1:0]	O_rdata,
	output						O_empty,
	output						O_aempty
);


wire						rst		= !I_rstn;
wire	[WDATAWIDTH-1:0]	di		= I_wdata;
wire						clkw	= I_wclk;
wire						we		= I_we;
wire						clkr	= I_rclk;
wire						re		= I_re;

wire [RDATAWIDTH-1:0] do;
wire empty_flag;
wire aempty_flag;
wire full_flag;
wire afull_flag;

assign O_rdata	= do;
assign O_empty	= empty_flag;
assign O_aempty	= aempty_flag;
assign O_full	= full_flag;
assign O_afull	= afull_flag;


EG_LOGIC_FIFO #(
 	.DATA_WIDTH_W(WDATAWIDTH),
	.DATA_WIDTH_R(RDATAWIDTH),
	.DATA_DEPTH_W(WDATADEPTH),
	.DATA_DEPTH_R(RDATADEPTH),
	.ENDIAN(ENDIAN),
	.RESETMODE("ASYNC"),
	.E(0),
	.F(WDATADEPTH),
	.ASYNC_RESET_RELEASE("SYNC"),
	.AE(ALMOSTEMPTY),
	.AF(ALMOSTFULL))
fifo_inst(
	.rst(rst),
	.di(di),
	.clkw(clkw),
	.we(we),
	.csw(3'b111),
	.do(do),
	.clkr(clkr),
	.re(re),
	.csr(3'b111),
	.ore(1'b0),
	.empty_flag(empty_flag),
	.aempty_flag(aempty_flag),
	.full_flag(full_flag),
	.afull_flag(afull_flag)

);



endmodule
