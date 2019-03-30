// Cache implemetation code

// importing parameters package
import parameters::*;

module L1_split_cache(
    input  logic [ADDR_LEN - 1 : 0] input_address,
    input  int                      n,
    input  int                      mode,
    input  logic                    valid,
    output logic                    busy 
);


// Defining variables 
logic [B_OFFSET - 1 : 0]  byte_offset;
logic [INDEX - 1 : 0]     set_index;
logic [D_TAG_LEN - 1 : 0] current_data_tag;
logic [I_TAG_LEN - 1 : 0] current_instruction_tag;
logic [D_LINE - 1 : 0]    current_data_line;
logic [I_LINE - 1 : 0]    current_instruction_line;
logic                     data_hit;
logic                     cache_hit;


assign byte_offset = input_address [B_OFFSET - 1 : 0];
assign set_index   = input_address [SET_OFF : B_OFFSET];


integer i, j, k, l;
integer D_hit_count    = 0;
integer I_hit_count    = 0;
integer I_access_count = 0;
integer D_access_count = 0;
integer D_read_count   = 0;
integer D_write_count  = 0;
integer I_read_count   = 0;
integer I_miss_count   = 0;
integer D_miss_count   = 0;
real    D_hit_ratio    = 0.0000;
real    I_hit_ratio    = 0.0000;

initial begin
    reset_cache(data, instruction);
end // initial

always_comb
begin
    if(valid)
    begin
        busy = 1'b1;
        current_data_tag        = (n == 0 || n == 1 || n == 3 || n == 4) ? input_address [ADDR_LEN - 1 : SET_OFF + 1] : 0;
        current_instruction_tag = (n == 2) ? input_address [I_ADDR - 1 : SET_OFF + 1] : 0;

        unique case (n)                                                                                     // case select
            32'd0, 32'd1:
            begin
            	if(mode == 0) begin
            		$display("BEFORE: ");
                	display_D_set(data[set_index], set_index);
                end
                D_access_count = D_access_count + 1;
                D_read_count   = (n == 0)?(D_read_count + 1):D_read_count;
                D_write_count  = (n == 1)?(D_write_count + 1):D_write_count;
                for (i = 0; i < D_LINES; i++)
                begin
                    if (data[set_index].tag[i] == current_data_tag && data[set_index].D_state != I)         // if tag matches and state is not invalid
                    begin
                        current_data_line = i;
                        data_hit          = 1'b1;                                                           // inc hit count    
                        if(mode == 0) $display("D_Cache Hit!");                                //update mesi bits
                            D_hit_count = D_hit_count + 1;
                        if (mode == 0) begin
                        if (n == 1)
                            $display("Data written to L1_DATA_CACHE at address 0x%08x", input_address);
                        else if(n == 0)
                            $display("Data read from L1_DATA_CACHE at address 0x%08x", input_address); 
                        end
                        break;
                    end
                end
                if (i == D_LINES)                                                                            // checking if the i has reached the end of data
                begin
                    data_hit = 1'b0;
                    if(mode == 0) $display ("D_Cache Miss!");
                        D_miss_count = D_miss_count + 1;                                                     // inc miss count                   
                    for (j = 0; j < D_LINES; j++)
                    begin
                        if (data[set_index].D_state[j] == I)
                        begin
                            data[set_index].tag[j] = current_data_tag;
                            current_data_line      = j;
                            if(mode == 0) begin                                                               // when in mode 0 print all the $display below
                                if(n == 1)
                                    $display("Data written to L1_DATA_CACHE at address 0x%08x which was Invalid/empty", input_address);
                                else if(n == 0)
                                    $display("Data written to and read from L1_DATA_CACHE in order at address 0x%08x which was Invalid/empty.", input_address);
                                if(n == 1)
                                    $display("Write to L2 0x%08x(Write Through) \n Read for Ownership from L2 0x%08x", input_address, input_address);
                                else if(n == 0)
                                    $display("Read data from L2 0x%08x", input_address);
                            end
                            break;
                        end
                    end
                    if (j == D_LINES)                                                                          // when j is end of the line
                    begin
                        for (k = 0; k < D_LINES; k++) begin
                            if(data[set_index].lru[k] == D_LINES - 1)                                               // set LRU to 111
                                break;
                        end
                        current_data_line = k;
                        data[set_index].tag[current_data_line] = current_data_tag;                              // set tag bits
                        if (mode == 0) begin
                            if(n == 1)
                                 $display("Data has been replaced in L1_DATA_CACHE at address 0x%08x which was LRU", input_address);
                            else if(n == 0)
                                $display("Data has been replaced and read from L1_DATA_CACHE in order at address 0x%08x which was LRU", input_address); 
                            if(data[set_index].D_state[current_data_line] == M)
                                 $display("Write to L2 0x%08x(Write Through)", {data[set_index].tag[i], set_index, 6'd0});
                            if(n == 1)
                                $display("Read for Ownership from L2 0x%08x", input_address);
                            else if(n == 0)
                                $display("Read from L2 0x%08x", input_address); 
                            end  
                    	end   
                	end
                // calling LRU function
                LRU_D_implementation(current_data_line, data[set_index]);        
                // calling MESI function
                MESI_data(n, data_hit, data[set_index], current_data_line);
                
                if(mode == 0) begin
                	$display("AFTER: ");
                	display_D_set(data[set_index], set_index);
                	$display("");
                end
            end             
            32'd2:
            begin
                if(mode == 0) begin
                	$display("BEFORE: ");
                	display_I_set(instruction[set_index], set_index);
                end
                I_access_count = I_access_count + 1;
                I_read_count   = I_read_count + 1;
                for (k = 0; k < I_LINES; k++)
                begin
                    if (instruction[set_index].tag[k] == current_instruction_tag  && instruction[set_index].I_state != I)
                    begin
                        current_instruction_line = k;
                        I_hit_count = I_hit_count + 1;
                        cache_hit                = 1'b1;
                        if (mode == 0) begin
                        	$display("I_Cache hit!");
                        	$display("Instruction read from L1_INSTRUCTION_CACHE at address 0x%06x", input_address[I_ADDR - 1 : 0]);
                        end 
                        break;
                    end
                end
                if (k == I_LINES)
                begin
                    cache_hit = 1'b0;
                    if (mode == 0) $display("I_Cache miss!");
                    I_miss_count = I_miss_count + 1;
                    for (l =0; l < I_LINES; l++)
                    begin
                        if (instruction[set_index].I_state[l] == I)
                        begin
                            instruction[set_index].tag[l] = current_instruction_tag;
                            current_instruction_line      = l;
                            if (mode == 0) $display("Instruction written to and read from L1_DATA_CACHE in order at address 0x%06x which was Invalid/empty", input_address[I_ADDR - 1 : 0]);
                            break;
                        end
                    if (l == I_LINES)
                    begin
                        for (k = 0; k < I_LINES; k++) begin
                            if(instruction[set_index].lru[k] == I_LINES - 1)
                                break;
                        end
                        current_instruction_line = k;
                        instruction[set_index].tag[current_data_line] = current_data_tag;
                        if (mode == 0) $display("Instruction has been replaced and read from L1_DATA_CACHE in order at address 0x%06x which was LRU", input_address[I_ADDR - 1 : 0]);                        
                    end
                    end
                end
                LRU_I_implementation(current_instruction_line, instruction[set_index]);             // invoking the LRU function for instruction
                MESI_instr(n, cache_hit, instruction[set_index], current_instruction_line);         // invoking MESI for instruction
                if(mode == 0) begin
                	$display("AFTER: ");
                	display_I_set(instruction[set_index], set_index);
                	$display("");
                end
            end
            
            32'd3:
            begin
                if(mode == 0) begin
                	$display("BEFORE: ");
                	display_D_set(data[set_index], set_index);
                end
                for(i = 0; i < D_LINES; i++)
                begin
                    if (data[set_index].tag[i] == current_data_tag  && data[set_index].D_state != I)    //  if same tag found and data is valid
                    break;
                end
                if(i < D_LINES) begin
                    current_data_line = i;
                    if(data[set_index].D_state[current_data_line] == M) begin                            // if the state of data is modified
                        if (mode == 0) $display("Return data to L2 %08x", input_address);
                    end
                    if (mode == 0) $display("Data has been invalidated in L1_DATA_CACHE at address %08x", input_address);
                    MESI_data(n, data_hit, data[set_index], current_data_line);    //update the invalidate state
                    LRU_D_implementation(current_data_line, data[set_index]);
                end // if(i < D_LINES)
                else begin
                    if (mode == 0) $display("Line not found");
                end
                if(mode == 0) begin
                	$display("AFTER: ");
                	display_D_set(data[set_index], set_index);
                	$display("");
                end
            end
            
            32'd4:
            begin
                if(mode == 0) begin
                	$display("BEFORE: ");
                	display_D_set(data[set_index], set_index);
                end
                for(i = 0; i < D_LINES; i++)
                begin
                    if (data[set_index].tag[i] == current_data_tag  && data[set_index].D_state != I)
                    break;
                end
                if(i < D_LINES) begin
                    current_data_line = i;
                    if(data[set_index].D_state[current_data_line] == M) begin
                        if (mode == 0) $display("Data in M state is sent to L2_CACHE and goes to S State.");
                        if (mode == 0) $display("Return data to L2 %08x", input_address);
                    end
                    if (mode == 0) $display("Data has been invalidated on RFO in L1_DATA_CACHE at address %08x which was either in S or in E State", input_address);
                    MESI_data(n, data_hit, data[set_index], current_data_line);    //update the invalidate state
                    LRU_D_implementation(current_data_line, data[set_index]);
                end // if(i < D_LINES)
                else begin
                    if (mode == 0) $display("Line not found");
                end
                if(mode == 0) begin
                	$display("AFTER: ");
                	display_D_set(data[set_index], set_index);
                	$display("");
                end
            end
            
            32'd8:
            begin
                for (i = 0; i < SET_LEN; i++)
                begin
                    for (j = 0; j < D_LINES; j++)
                    begin
                        data[i].tag[j] = 12'b0;
                        data[i].lru[j] = D_LINES - 1;
                        if(data[i].D_state[j] == M) begin
                            if (mode == 0) $display("Data at index %5d and line %1d is in M state. So, datad sent to L2_CACHE before invalidating it", i, j);
                        end
                        data[i].D_state[j] = I;
                    end
                end
                for (k = 0; k < SET_LEN; k++)
                begin
                    for (l = 0; l < I_LINES; l++)
                    begin
                        instruction[k].tag[l] = 12'b0;
                        instruction[k].lru[l] = I_LINES - 1;
                        instruction[k].I_state[l] = I;
                    end
                end
                D_hit_count    = 0;
                I_hit_count    = 0;
                D_access_count = 0;
                I_access_count = 0;
                D_read_count   = 0;
                D_write_count  = 0;
                I_read_count   = 0;
                I_miss_count   = 0;
                D_miss_count   = 0;
            end
            
            32'd9:
            begin
                $display("INDEX     LINE0       LINE1       LINE2       LINE3       LINE4       LINE5       LINE6       LINE7");
                $display("        LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG");
                for (i = 0; i < SET_LEN; i++)
                begin
                    for(j = 0; j < D_LINES; j++)
                    begin
                        if(data[i].D_state[j] != I)
                            break;
                    end
                    if(j < D_LINES) begin                      
                    $write("%5d   ", i);
                        for (j = 0; j < D_LINES; j++)
                        begin
                            $write("%3b|%S|%3x   ", data[i].lru[j], data[i].D_state[j], data[i].tag[j]);                
                        end
                    $display("");
                    end
                end
                $display("INDEX     LINE0       LINE1       LINE2       LINE3");
                $display("        LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG");
                for (i = 0; i < SET_LEN; i++)
                begin
                    for(j = 0; j < I_LINES; j++)
                    begin
                        if(instruction[i].I_state[j] != I)
                            break;
                    end
                    if(j < I_LINES) begin                      
                    $write("%5d   ", i);
                        for (j = 0; j < I_LINES; j++)
                        begin
                            $write("%3b|%S|%3x   ", instruction[i].lru[j], instruction[i].I_state[j], instruction[i].tag[j]);                
                        end
                    $display("");
                    end
                end  
                D_hit_ratio   = (100.00000 * D_hit_count)/(1.0000 * D_access_count);
                I_hit_ratio   = (100.00000 * I_hit_count)/(1.0000 * I_access_count);
                $display("INSTRUCTION CACHE STATISTICS: ");
                $display("Instruction_cache Read_count   = %7d", I_read_count);
                $display("Instruction_cache Write count  =       0");
                $display("Instruction_cache Hit_count    = %7d", I_hit_count);
                $display("Instruction_cache Miss_count   = %7d", I_miss_count);
                $display("Instruction_cache Hit Ratio    = %.5f", I_hit_ratio);
                $display("\n\nDATA CACHE STATISTICS: ");
                $display("Data_cache read_count          = %7d", D_read_count);
                $display("Data_cache write_count         = %7d", D_write_count);
                $display("Data_cache hit_count           = %7d", D_hit_count);
                $display("Data_cache miss_count          = %7d", D_miss_count);
                $display("Datacache Hit Ratio            = %.5f", D_hit_ratio);
            end
            
            default: $display("\nInvalid Command!\n");
        endcase // input_address
    end
    else
        busy = 1'b0;
end
endmodule 