parameter SIZE = 8'd7;
parameter LIMIT = 255;

typedef struct packed {
	logic [SIZE:0] data;	   // Output Data - BITWIDTH: 8
	logic valid;		   // Data Envelope for output data	
}out_st;
module runLengthEncoder (
	input logic clock,    			// Clock
	input logic reset_n,			// Asynchronous reset - Active low
	input logic [SIZE-1:0] dataIn,		// Input Data - BITWIDTH: 7
	output out_st dataOut			// Output Data struct
);

typedef enum logic [2:0] {IDLE, START, COUNT} states;  // States for FSM

states State, nextState; 

logic [SIZE-1:0] in;		    // Reg to store input data for comparison	
logic [SIZE:0] count; 		// Count variable to store repetition count

logic eq;				// Comparison bit - high if repetiotion is found
logic count_check;		// High, if counter reaches 255

assign eq = (in == dataIn) && (in != 7'd0);					// Checking for repetition
assign count_check = (count < LIMIT);		// Checking for count limit

///////////   State assignment ///////////////////////
always_ff @(posedge clock or negedge reset_n) begin
	if(~reset_n) begin
		State <= IDLE;
		in <= 7'd0;
	end else begin
		State <= nextState; 
		in <= dataIn;
	end
end


//////////   Counter logic ///////////////////////////
always_ff @(posedge clock or negedge reset_n) begin
	if(~reset_n) begin
		 count <= 8'd0;
	end 
	else if (count_check & eq)begin
		count <= count + 8'd1;
	end
	else begin
		count <= 8'd0;
	end

end


//////////    Mealy State Machine ////////////////////
always_comb begin
	if (~reset_n) begin 
		nextState = IDLE;
		dataOut.data = 8'd0;
		dataOut.valid = 1'b0;
	end
	else begin
	case (State)
		IDLE: begin									// stays in IDLE till reset_n is low
			if (reset_n) begin
				nextState = START;
				dataOut.data = {1'b0, 7'd0};		
				dataOut.valid = 1'b0;
			end
			else begin
				dataOut.data = {1'b0, 7'd0};
				dataOut.valid = 1'b0;				
				nextState = IDLE;
			end
		end
		START: begin								// stays in START till repetition is found	
			if (eq) begin
				nextState = COUNT;
				dataOut.data = {1'b1, in};		    	
				dataOut.valid = 1'b1;
			end
			else begin
				nextState = START;
				dataOut.data = {1'b0, in};
				dataOut.valid = (in == 7'd0) ? 1'b0 : 1'b1;
			end
		end
		COUNT: begin							  // stays in COUNT till count value reaches max value or repetition bit is high
			if (eq & count_check) begin
				nextState = COUNT;
				dataOut.data = 7'd0;
				dataOut.valid = 1'b0;
				end
			else begin
				nextState = START;
				dataOut.data = count;
				dataOut.valid = 1'b1;
			end
		end
	endcase
	end 
end


endmodule