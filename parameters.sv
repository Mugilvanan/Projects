// paramters package for defining variables


package parameters;

// setting the bit values

	parameter D_LINES   = 8;
	parameter I_LINES   = 4;
	parameter SET_LEN   = 16384;
	parameter D_TAG_LEN = 12;
	parameter I_TAG_LEN = 4;
	parameter D_LRU_LEN = 3;
	parameter I_LRU_LEN = 2;
	parameter ADDR_LEN  = 32;
	parameter INDEX     = 14;
	parameter B_OFFSET  = 6;
	parameter D_LINE    = 3;
	parameter I_LINE    = 2;
	parameter I_ADDR    = 24;
	parameter SET_OFF   = 19; 

typedef enum logic [1:0] {M = 2'b00, E, S, I}states;	

// Strucutre for Data and Instruction lines

typedef struct packed {
    logic  [D_LINES - 1 : 0] [D_LRU_LEN - 1 : 0]  lru;
    states [D_LINES - 1 : 0]                      D_state;
    bit    [D_LINES - 1 : 0] [D_TAG_LEN - 1 : 0]  tag;
} cache_data;

typedef struct packed {
    logic  [I_LINES - 1 : 0] [I_LRU_LEN - 1 : 0]  lru;
    states [I_LINES - 1 : 0]                      I_state;
    bit    [I_LINES - 1 : 0] [I_TAG_LEN - 1 : 0]  tag;
} cache_instruction;	

cache_data        data        [SET_LEN - 1 : 0];
cache_instruction instruction [SET_LEN - 1 : 0];

// Reset function for clearing all values

function automatic void reset_cache(ref cache_data set_data[SET_LEN - 1 : 0], ref cache_instruction set_instr[SET_LEN - 1 : 0]);
    int i, j, k, l;
    for (i = 0; i < SET_LEN; i++)
    begin
        for (j = 0; j < D_LINES; j++)
        begin
            set_data[i].tag[j] = 12'b0;                 // setting tag bits to 0
            set_data[i].lru[j] = D_LINES - 1;                // setting lru bits to 111 
            set_data[i].D_state[j] = I;                 // setting state to invalid
        end
    end
    for (k = 0; k < SET_LEN; k++)
    begin
        for (l = 0; l < I_LINES; l++)
        begin
            set_instr[k].tag[l] = 12'b0;
            set_instr[k].lru[l] = I_LINES - 1;
            set_instr[k].I_state[l] = I;
        end
    end
endfunction : reset_cache

// Display to show the status if the Cache

function automatic void display_D_set(cache_data set, int index);               
    $display("INDEX     LINE0       LINE1       LINE2       LINE3       LINE4       LINE5       LINE6       LINE7");
    $display("        LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG");
    $write("%5d   ", index);
    for (int j = 0; j < D_LINES; j++)                                  // loop for displaying data cache
     begin
        $write("%3b|%S|%3x   ", set.lru[j], set.D_state[j], set.tag[j]);                
     end
    $display("");	
endfunction : display_D_set

function automatic void display_I_set(cache_instruction set, int index);
    $display("INDEX     LINE0       LINE1       LINE2       LINE3");
    $display("        LRU|S|TAG   LRU|S|TAG   LRU|S|TAG   LRU|S|TAG");
    $write("%5d   ", index);
    for (int j = 0; j < I_LINES; j++)                                  // loop for displaying instruction cache
     begin
        $write("%3b|%S|%3x   ",  set.lru[j], set.I_state[j], set.tag[j]);                
     end
    $display("");
endfunction : display_I_set

// LRU implemetation for Data

function automatic void LRU_D_implementation(logic [D_LINE - 1 : 0] current_data_line, ref cache_data set); //sel = 0 - data sel =1 - inst
    for(int i = 0; i < D_LINES; i++)
    begin
        if(set.lru[i] < set.lru[current_data_line])                     // checking the lru bits of the current data line
        set.lru[i] = set.lru[i] + 3'b1;
    end
    set.lru[current_data_line] = 3'b0;
endfunction : LRU_D_implementation

// LRU implemetation for Data

function automatic void LRU_I_implementation(logic [I_LINE - 1 : 0] current_instruction_line, ref cache_instruction inst_Set);
    for(int i = 0; i < I_LINES; i++)
    begin
        if(inst_Set.lru[i] < inst_Set.lru[current_instruction_line])     // checking the lru bits of the current instructiom line
        inst_Set.lru[i] = inst_Set.lru[i] + 3'b1;
    end
    inst_Set.lru[current_instruction_line] = 3'b0;
endfunction : LRU_I_implementation

// MESI States for Data

function automatic void MESI_data(int n, logic data_hit,  ref cache_data set, logic [D_LINE - 1 : 0] current_data_line);
unique case (set.D_state[current_data_line])
    M:      //modified
    begin
        if (n == 1) 
            set.D_state[current_data_line] = (data_hit)?M:E;            // if data hit state from M to E
        else if (n == 0)
            set.D_state[current_data_line] = (data_hit)?M:E;            // if data hit state from M to E
        else if (n ==3 || n == 4)
            set.D_state[current_data_line] = I;                         // set to invalid
    end
    
    E:      //exclusive
    begin
        if (n == 0) 
            set.D_state[current_data_line] = (data_hit)?S:E;            // if data hit state from S to E
        else if (n == 1)
            set.D_state[current_data_line] = (data_hit)?M:E;            // if data hit state from M to E
        else if (n ==3 || n == 4)
            set.D_state[current_data_line] = I;                         // set to invalid
    end
    
    S:      //shared
    begin
        if (n == 0) 
            set.D_state[current_data_line] = (data_hit)?S:E;            // if data hit state from S to E
        else if (n == 1)
            set.D_state[current_data_line] = (data_hit)?M:E;            // if data hit state from M to E
        else if (n == 3 || n == 4)
            set.D_state[current_data_line] = I;                         // set to invalid
    end 
    
    I:      //invalid
    begin
        if (n == 0) 
            set.D_state[current_data_line] = E;                         // Set data to exclusive
        else if (n == 1)
            set.D_state[current_data_line] = E;
        else if (n == 3 || n == 4)
            set.D_state[current_data_line] = I;        
    end
    default: 
    	set.D_state[current_data_line] = I;
    endcase
endfunction    


// MESI States for Instruction

function automatic void MESI_instr(int n, logic cache_hit, ref cache_instruction set, logic [I_LINE - 1 : 0] current_instruction_line);
unique case (set.I_state[current_instruction_line])
   E:      //exclusive
    begin
        if (n == 2) 
            set.I_state[current_instruction_line] = (cache_hit)?S:E;          // if data hit state from I to E
        else if (n == 8)
            set.I_state[current_instruction_line] = I;                        // set state invalid
    end
    
    S:      //shared
    begin
        if (n == 2) 
            set.I_state[current_instruction_line] = (cache_hit)?S:E;           // if data hit state from I to E
        else if (n == 8)
            set.I_state[current_instruction_line] = I;    
    end
    
    I:      //invalid
    begin
        if (n == 2) 
            set.I_state[current_instruction_line] = E;                         // if data hit state from I to E
        else if (n == 8)
            set.I_state[current_instruction_line] = I;        
    end
    default:
    	set.I_state[current_instruction_line] = I;
    endcase
endfunction 
endpackage