//***************************************************************************************
// MODULE : axi4_lite_master
// AUTHOR : Mugilvanan Vinayagam, Sai Sushmitha Chandaka
// DATE   : 11/22/2018
// DESCRIPTION
// -----------
//  This is a AXI4 Master module that contains FSM to initiate Read and Write operation based on inputs from Top module.
//
//***************************************************************************************

 module axi4_lite_master
//------------------------------------------------------------------------------
//----------------Parameter signals---------------------------------------------
//------------------------------------------------------------------------------
#(parameter ADDRESS_WIDTH           =32 ,    //Address pointer data width
            REG_DATA_WIDTH          =32      //Input data width and output data width
)
(axi4_lite_interface.master m1,
input logic WRITE,
input logic READ,
input logic DATA_VALID,
input logic [REG_DATA_WIDTH-1:0] DATA_IN,
input logic [4 : 0] DATA_LENGTH,
input logic [ADDRESS_WIDTH-1:0] CPU_ADDR,
output logic [REG_DATA_WIDTH-1:0] DATA_OUT,
output logic OUT_VALID,
output logic BUSY,
output logic [4 : 0] error_count
);

logic [ADDRESS_WIDTH-1:0] CPU_ADDR_Master;
logic [4 : 0]Data_len;


assign DATA_OUT = m1.axi4_lite_rdata;
assign OUT_VALID = m1.axi4_lite_rvalid;

typedef enum {RESET_state, IDLE_state, WRITE_state, READ_state} state_t;
state_t state;

logic reset_n;

always_ff @(posedge m1.axi4_lite_aclk or negedge m1.axi4_lite_aresetn) begin : proc
  if(~m1.axi4_lite_aresetn) begin
    reset_n <= 0;
  end else begin
    reset_n <= 1;
  end
end

always_ff @(posedge m1.axi4_lite_aclk or negedge reset_n)
begin
	if(!reset_n) begin
		state<=IDLE_state;
		m1.axi4_lite_bready <= 1'b1;
		m1.axi4_lite_rready <= 1'b1;
		m1.axi4_lite_awaddr <= 0;
		m1.axi4_lite_awvalid <= 1'b0;
		m1.axi4_lite_wvalid <= 1'b0;
		m1.axi4_lite_wdata <= 0;
		m1.axi4_lite_araddr <= 0;
		m1.axi4_lite_arvalid <= 1'b0;
		BUSY <= 1'b0;
		CPU_ADDR_Master <= 32'b0;
		Data_len <= 5'b0;
		error_count <= 5'b0;
	end
	else
	begin
		unique case(state)
		
		IDLE_state:begin
			if(WRITE)
			begin
				state<=WRITE_state;
				m1.axi4_lite_awaddr <= CPU_ADDR;
				m1.axi4_lite_awvalid <= 1'b1;
				m1.axi4_lite_wvalid <= 1'b1;
				m1.axi4_lite_wdata <= DATA_IN;
				m1.axi4_lite_bready <= 1'b1;
				BUSY <= 1'b1;
				m1.axi4_lite_rready <= 1'b0;
				CPU_ADDR_Master <= CPU_ADDR;
				Data_len <= DATA_LENGTH;
				error_count <= 5'b0;				
			end
			else if(READ)
			begin
				state<=READ_state;
				m1.axi4_lite_araddr <= CPU_ADDR;
				m1.axi4_lite_arvalid <= 1'b1;
				m1.axi4_lite_rready <= 1'b1;
				BUSY <= 1'b1;
				m1.axi4_lite_bready <= 1'b0;
				CPU_ADDR_Master <= CPU_ADDR;
				Data_len <= DATA_LENGTH;
				error_count <= 5'b0;				
			end
			else
			begin
				state<=IDLE_state;
				m1.axi4_lite_bready <= 1'b1;
				m1.axi4_lite_rready <= 1'b1;
				m1.axi4_lite_awaddr <= 0;
				m1.axi4_lite_awvalid <= 1'b0;
				m1.axi4_lite_wvalid <= 1'b0;
				m1.axi4_lite_wdata <= 0;
				m1.axi4_lite_araddr <= 0;
				m1.axi4_lite_arvalid <= 1'b0;
				BUSY <= 1'b0;
				CPU_ADDR_Master <= 32'b0;
				Data_len <= 5'b0;
				error_count <= 5'b0;
			end
		end
		WRITE_state:begin
			if((m1.axi4_lite_awready & m1.axi4_lite_wready))
			begin
				if(m1.axi4_lite_awaddr < (CPU_ADDR_Master + Data_len - 1) && m1.axi4_lite_bresp == 2'b00)
				begin
					m1.axi4_lite_awaddr <= m1.axi4_lite_awaddr + 1;
					m1.axi4_lite_awvalid <= 1'b1;
					m1.axi4_lite_wvalid <= 1'b1;
					m1.axi4_lite_wdata <= DATA_IN;
					state <= WRITE_state;
				end
				else if (m1.axi4_lite_bresp == 2'b11)
				begin
					m1.axi4_lite_awaddr <= 0;
					m1.axi4_lite_awvalid <= 1'b0;
					m1.axi4_lite_wvalid <= 1'b0;
 					state <= IDLE_state;
 					error_count <= CPU_ADDR_Master + Data_len - m1.axi4_lite_awaddr + 1;	
 				end				
				else
				begin
					m1.axi4_lite_awaddr <= 0;
					m1.axi4_lite_awvalid <= 1'b0;
					m1.axi4_lite_wvalid <= 1'b0;
 					state <= IDLE_state;
				end
			end
			else
			begin
				m1.axi4_lite_awaddr <= m1.axi4_lite_awaddr;
				m1.axi4_lite_awvalid <= 1'b1;
				m1.axi4_lite_wvalid <= 1'b1;
				state <= WRITE_state;
			end
		end
		
		READ_state:begin
			if(m1.axi4_lite_arready)
			begin
				if(m1.axi4_lite_araddr < (CPU_ADDR_Master + Data_len - 1)  && m1.axi4_lite_rresp == 2'b00)
				begin
					m1.axi4_lite_araddr <= m1.axi4_lite_araddr + 1;
					m1.axi4_lite_arvalid <= 1'b1;
					state <= READ_state;
				end
				else if (m1.axi4_lite_rresp == 2'b11)
				begin
					m1.axi4_lite_araddr <= 0;
					m1.axi4_lite_arvalid <= 1'b0;
					state <= IDLE_state;
					error_count <= CPU_ADDR_Master + Data_len - m1.axi4_lite_araddr + 1;	
				end				
				else
				begin
					m1.axi4_lite_araddr <= 0;
					m1.axi4_lite_arvalid <= 1'b0;
					state <= IDLE_state;
				end
			end
			else
			begin
				m1.axi4_lite_araddr <= m1.axi4_lite_araddr;
				m1.axi4_lite_arvalid <= 1'b1;
				state <= READ_state;
			end
		end	

		default:
			state <= IDLE_state;
	endcase
	end
end
endmodule // axi4_lite_master 