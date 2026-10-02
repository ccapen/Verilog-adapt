module simple_async_ram_lut_anlogic #(
	parameter	DATAWIDTH	= 8,	//must >= 1, must <= 256
	parameter	DATADEPTH	= 256,	//must >= 2, must <= 256
	parameter	ADDRWIDTH	= $clog2(DATADEPTH)
) (
	input					I_wclk,
	input					I_we,
	input	[ADDRWIDTH-1:0]	I_waddr,
	input	[DATAWIDTH-1:0]	I_wdata,

	input	[ADDRWIDTH-1:0]	I_raddr,
	output	[DATAWIDTH-1:0]	O_rdata
);


localparam RESETMODE = "ASYNC";
localparam READREG = "DISABLE";
localparam DATA_WIDTH_W = DATAWIDTH;
localparam ADDR_WIDTH_W = ADDRWIDTH;
localparam DATA_DEPTH_W = DATADEPTH;
localparam DATA_WIDTH_R = DATAWIDTH;
localparam ADDR_WIDTH_R = ADDRWIDTH;
localparam DATA_DEPTH_R = DATADEPTH;

wire  [DATA_WIDTH_W-1:0] di = I_wdata;
wire  [ADDR_WIDTH_W-1:0] waddr = I_waddr;
wire  wclk = I_wclk;
wire  we = I_we;
wire  [ADDR_WIDTH_R-1:0] raddr = I_raddr;

wire  [DATA_WIDTH_R-1:0] dout;
assign O_rdata = dout;



	wire [DATA_WIDTH_R-1:0] rdo;
	reg  [DATA_WIDTH_R-1:0] dout_r1;
	assign dout=(READREG == "ENABLE") ? dout_r1:rdo;

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
