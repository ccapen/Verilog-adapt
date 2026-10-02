module dbclk_sync_ram_anlogic #(
	parameter	WDATAWIDTH	= 8,
	parameter	WDATADEPTH	= 256,	//must be 2**n
	parameter	RDATAWIDTH	= 8,	//WDATAWIDTH * (2**n) or WDATAWIDTH / (2**n), must be divisible
	parameter	RDATADEPTH	= WDATAWIDTH * WDATADEPTH / RDATAWIDTH,
	parameter	WADDRWIDTH	= $clog2(WDATADEPTH),
	parameter	RADDRWIDTH	= $clog2(RDATADEPTH)
) (
	input						I_wclk,
	input						I_we,
	input	[WADDRWIDTH-1:0]	I_waddr,
	input	[WDATAWIDTH-1:0]	I_wdata,

	input						I_rclk,
	input						I_re,
	input	[RADDRWIDTH-1:0]	I_raddr,
	output	[RDATAWIDTH-1:0]	O_rdata
);


localparam DATA_WIDTH_A = WDATAWIDTH; 
localparam ADDR_WIDTH_A = WADDRWIDTH;
localparam DATA_DEPTH_A = WDATADEPTH;
localparam DATA_WIDTH_B = RDATAWIDTH;
localparam ADDR_WIDTH_B = RADDRWIDTH;
localparam DATA_DEPTH_B = RDATADEPTH;
localparam REGMODE_A    = "NOREG";
localparam REGMODE_B    = "NOREG";
localparam WRITEMODE_A  = "NORMAL";
localparam WRITEMODE_B  = "NORMAL";

wire [DATA_WIDTH_B-1:0] dob;
assign O_rdata = dob;


wire  [DATA_WIDTH_A-1:0] dia = I_wdata;
wire  [ADDR_WIDTH_A-1:0] addra = I_waddr;
wire  [ADDR_WIDTH_B-1:0] addrb = I_raddr;
wire  wea = I_we;
wire  ceb = I_re;
wire  clka = I_wclk;
wire  clkb = I_rclk;



EG_LOGIC_BRAM #( .DATA_WIDTH_A(DATA_WIDTH_A),
			.DATA_WIDTH_B(DATA_WIDTH_B),
			.ADDR_WIDTH_A(ADDR_WIDTH_A),
			.ADDR_WIDTH_B(ADDR_WIDTH_B),
			.DATA_DEPTH_A(DATA_DEPTH_A),
			.DATA_DEPTH_B(DATA_DEPTH_B),
			.MODE("PDPW"),
			.REGMODE_A(REGMODE_A),
			.REGMODE_B(REGMODE_B),
			.WRITEMODE_A(WRITEMODE_A),
			.WRITEMODE_B(WRITEMODE_B),
			.RESETMODE("ASYNC"),
			.IMPLEMENT("9K"),
			.INIT_FILE("NONE"),
			.FILL_ALL("NONE"))
		inst(
			.dia(dia),
			.dib({DATA_WIDTH_B{1'b0}}),
			.addra(addra),
			.addrb(addrb),
			.cea(1'b1),
			.ceb(ceb),
			.ocea(1'b0),
			.oceb(1'b0),
			.clka(clka),
			.clkb(clkb),
			.wea(wea),
			.bea(1'b0),
			.web(1'b0),
			.beb({(DATA_WIDTH_B/8){1'b0}}),
			.rsta(1'b0),
			.rstb(1'b0),
			.doa(),
			.dob(dob)
);


endmodule
