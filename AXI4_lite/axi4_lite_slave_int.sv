//***************************************************************************************
// MODULE : axi4_lite_slave
// AUTHOR : Mugilvanan Vinayagam
// DATE   : 11/20/2018
// DESCRIPTION
// -----------
//  This is a AXI4 Slave module that contains all Read and Write operation response generation logic.
//
//***************************************************************************************

module axi4_lite_slave
//------------------------------------------------------------------------------
//----------------Parameter signals---------------------------------------------
//------------------------------------------------------------------------------
#(parameter ADDRESS_WIDTH           =32 ,    //Address pointer data width
            REG_DATA_WIDTH          =32      //Input data width and output data width
)
(
  axi4_lite_interface.slave slv
);

logic  [REG_DATA_WIDTH-1   :0]    csr_reg_data_in    ; //Register map input data
logic  [(ADDRESS_WIDTH>>1)-1:0]        csr_reg_waddress   ; //Register map write address
logic  [(ADDRESS_WIDTH>>1)-1:0]        csr_reg_raddress   ; //Register map read address
logic                             csr_reg_wr_en      ; //Register map write enable
logic                             csr_reg_rd_en      ; //Register map read enable
logic  [REG_DATA_WIDTH-1   :0]    csr_reg_data_out   ; //Register map output data
logic                             csr_reg_data_valid ; //Register map output data valid

//Register Declaration

logic csr_reg_rd_en_1d                                                  ; //CSR Read Enable With One Delay


//CSR Read Enable and Write Enable signals

assign  csr_reg_rd_en              =(slv.axi4_lite_araddr[ADDRESS_WIDTH - 1 : 16] == 16'b0) ? (slv.axi4_lite_arvalid & slv.axi4_lite_arready) : 1'b0; 
assign  csr_reg_wr_en              =(slv.axi4_lite_awaddr[ADDRESS_WIDTH - 1 : 16] == 16'b0) ? (slv.axi4_lite_awvalid & slv.axi4_lite_wvalid & slv.axi4_lite_awready & slv.axi4_lite_wready) : 1'b0;     
assign  csr_reg_waddress           =(slv.axi4_lite_awaddr[ADDRESS_WIDTH - 1 : 16] == 16'b0) ? slv.axi4_lite_awaddr [15 : 0] : 16'b0;                                           
assign  csr_reg_data_in            =slv.axi4_lite_wdata;  
assign  csr_reg_raddress           =(slv.axi4_lite_araddr[ADDRESS_WIDTH - 1 : 16] == 16'b0) ? slv.axi4_lite_araddr [15 : 0] : 16'b0;
assign  slv.axi4_lite_rdata        =csr_reg_data_out;
assign  slv.axi4_lite_rvalid       =csr_reg_data_valid;


logic reset_n;

always_ff @(posedge slv.axi4_lite_aclk or negedge slv.axi4_lite_aresetn) begin : proc
  if(~slv.axi4_lite_aresetn) begin
    reset_n <= 0;
  end else begin
    reset_n <= 1;
  end
end

/////////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------WRITE ADDRESS & DATA CHANNEL ----------------------------------//
///////////////////////////////////////////////////////////////////////////////////////////////// 

always_ff @(posedge slv.axi4_lite_aclk or negedge reset_n )//Write address ready assertion & deassertion 
begin                                                //Write address sampling
    if(!reset_n)
    begin
      slv.axi4_lite_awready        <=1'b1;
      slv.axi4_lite_wready         <=1'b1;                                                                                                   
    end  	
	 else                                                                                      
    begin                                                                                   
    	if(~slv.axi4_lite_arvalid & ~slv.axi4_lite_rvalid)                                     
      	begin                                                                               
        	slv.axi4_lite_awready    <=1'b1;                                                                                           
        	slv.axi4_lite_wready     <=1'b1;                                                        
      	end                                                                                    
     	else                                                                                    
       	begin		                                                                         
        	slv.axi4_lite_awready    <= 1'b0;                                                
         	slv.axi4_lite_wready     <= 1'b0;                                                   
	  	  end
    end  
end


////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------WRITE RESPONSE CHANNEL ----------------------------------------//
//////////////////////////////////////////////////////////////////////////////////////////////// 

always_ff @(posedge slv.axi4_lite_aclk or negedge reset_n)//Write response valid assertion & deassertion 
begin                                                //Write response generation
  	if(!reset_n)
    begin
      	slv.axi4_lite_bvalid          <=1'b0;                                                            
      	slv.axi4_lite_bresp           <=2'b00;                                                           
    end                                                                                   
  	else
    begin
      	if(slv.axi4_lite_awvalid & slv.axi4_lite_wvalid & slv.axi4_lite_awready & slv.axi4_lite_wready & slv.axi4_lite_bready)    
        begin                                                                                 
        	slv.axi4_lite_bvalid      <=1'b1;                                  					      
          slv.axi4_lite_bresp       <=(slv.axi4_lite_awaddr[ADDRESS_WIDTH - 1 : 16] == 16'b0) ? 2'b00 : 2'b11;                                                           
        end
      	else 
	      begin
          slv.axi4_lite_bvalid  <=1'b0;                                                            
          slv.axi4_lite_bresp   <=2'b00;	                                                  			  
        end			
    end		
end

////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------READ ADDRESS CHANNEL ------------------------------------------//
//////////////////////////////////////////////////////////////////////////////////////////////// 

always_ff @(posedge slv.axi4_lite_aclk or negedge reset_n)//Read Address Ready assertion & deassertion 
begin                                                //Read Address sampling
  	if(!reset_n)
    begin
      slv.axi4_lite_arready        <=1'b1;                                                                                   
    end  
  	else
    begin	
      	if(~slv.axi4_lite_awvalid & ~slv.axi4_lite_wvalid)
        begin                                                                                
	      	slv.axi4_lite_arready    <=1'b1;                                                     
	    end                                                                                  
      	else			                                                                          
        begin                                                                                    
          slv.axi4_lite_arready    <=1'b0;                                                          
        end                                                                                   
    end		
end

////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------READ RESPONSE CHANNEL ---------------------------------------------//
//////////////////////////////////////////////////////////////////////////////////////////////// 

always_ff @(posedge slv.axi4_lite_aclk or negedge reset_n)//Read data Valid assertion & deassertion 
begin                                                //Read response generation	
  	if(!reset_n)
    begin                                                            
	  	slv.axi4_lite_rresp          <=2'b00;                                                            
    end
    else if (slv.axi4_lite_arready)
    begin
        slv.axi4_lite_rresp        <=(slv.axi4_lite_araddr[ADDRESS_WIDTH - 1 : 16] == 16'b0) ? 2'b00 : 2'b11;
    end  
    else
    begin
      slv.axi4_lite_rresp          <=2'b00;
    end                                                                       
end

block_ram
#( .REG_DATA_WIDTH(REG_DATA_WIDTH),
   .ADDRESS_WIDTH (16) 
 )
u_ram
(
.data_out    (csr_reg_data_out  ),
.reset       (~reset_n),    
.data_valid  (csr_reg_data_valid),
.data_in     (csr_reg_data_in   ),
.wr_addr     (csr_reg_waddress  ),
.rd_addr     (csr_reg_raddress  ),
.wr_en       (csr_reg_wr_en     ),
.rd_en       (csr_reg_rd_en     ),
.clk         (slv.axi4_lite_aclk        )
);



endmodule
