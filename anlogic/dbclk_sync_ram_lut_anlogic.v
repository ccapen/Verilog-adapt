module dbclk_sync_ram_lut_anlogic #(
	parameter	WDATAWIDTH	= 8,	//must >= 1, must <= 256
	parameter	WDATADEPTH	= 256,	//must >= 2, must <= 256
	parameter	RDATAWIDTH	= 8,	//WDATAWIDTH * [1/16, 1/8, 1/4, 1/2, 1, 2, 4], must >= 1, must <= 256, must be divisible
									//(WDATAWIDTH * WDATADEPTH / RDATAWIDTH) must >= 2, must <= 256, must be divisible
	parameter	RDATADEPTH	= WDATAWIDTH * WDATADEPTH / RDATAWIDTH,
	parameter	WADDRWIDTH	= $clog2(WDATADEPTH),
	parameter	RADDRWIDTH	= $clog2(RDATADEPTH)
) (
	input						I_wclk,
	input						I_we,
	input	[WADDRWIDTH-1:0]	I_waddr,
	input	[WDATAWIDTH-1:0]	I_wdata,

	input						I_rclk,
	input						I_rrstn,
	input						I_re,
	input	[RADDRWIDTH-1:0]	I_raddr,
	output	[RDATAWIDTH-1:0]	O_rdata
);


localparam RESETMODE = "ASYNC";
localparam READREG = "ENABLE";
localparam DATA_WIDTH_W = WDATAWIDTH;
localparam ADDR_WIDTH_W = WADDRWIDTH;
localparam DATA_DEPTH_W = WDATADEPTH;
localparam DATA_WIDTH_R = RDATAWIDTH;
localparam ADDR_WIDTH_R = RADDRWIDTH;
localparam DATA_DEPTH_R = RDATADEPTH;

wire  [DATA_WIDTH_W-1:0] di = I_wdata;
wire  [ADDR_WIDTH_W-1:0] waddr = I_waddr;
wire  wclk = I_wclk;
wire  we = I_we;
wire  rclk = I_rclk;
wire  rrst = !I_rrstn;
wire  rce = I_re;
wire  [ADDR_WIDTH_R-1:0] raddr = I_raddr;

wire  [DATA_WIDTH_R-1:0] dout;
assign O_rdata = dout;



	wire [DATA_WIDTH_R-1:0] rdo;
	reg  [DATA_WIDTH_R-1:0] dout_r1;
	assign dout=(READREG == "ENABLE") ? dout_r1:rdo;
	generate if(RESETMODE == "SYNC")begin
	wire sync_rst  = rrst;
	always @(posedge rclk) begin
	if (sync_rst) begin
	dout_r1 <= 0;
	end else if (rce) begin
	dout_r1 <= rdo;
	end
	end
	end else if (RESETMODE == "ASYNC") begin
	wire async_rst = rrst;
	always @(posedge rclk or posedge async_rst) begin
	if (async_rst) begin
	dout_r1 <= 0;
	end else if (rce) begin
	dout_r1 <= rdo;
	end
	end
	end
	endgenerate

	EG_LOGIC_DRAM #(
 			.INIT_FILE("NONE"),
			.DATA_WIDTH_W(DATA_WIDTH_W),
			.ADDR_WIDTH_W(ADDR_WIDTH_W),
			.DATA_DEPTH_W(DATA_DEPTH_W),
			.DATA_WIDTH_R(DATA_WIDTH_R),
			.ADDR_WIDTH_R(ADDR_WIDTH_R),
			.DATA_DEPTH_R(DATA_DEPTH_R))
		dram(
			.di(di),
			.waddr(waddr),
			.wclk(wclk),
			.we(we),
			.do(rdo),
			.raddr(raddr)
	);


endmodule
