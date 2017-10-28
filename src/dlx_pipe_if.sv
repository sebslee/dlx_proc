//Created by Sebastian Lee
//See LICENSE file, no reliability whatsoever, use AS IS condition.
//Date: 23/10/17
//Description:
//DLX Instruction fetch pipe stage
//
//
//
//
////////////////////////////////////////////////////////////////////

`ifndef DLX_PIPE_IF
`define DLX_PIPE_IF

`include "dlx_globals.svh"

module dlx_pipe_if (
		    input logic clk,
		    input logic rst,
		    input logic stall,
		    input logic dc_wait,
		    input dlx_word id_npc,
		    input logic id_cond,		    
		    input dlx_word ic_data,
		    output dlx_address ic_addr,
		    output dlx_word if_id_ir ,
		    output dlx_word if_id_npc
		    );

   //Internal signals
   
   dlx_word pc; //program counter
   dlx_word npc;
         
   always_comb begin: if_comb
      ic_addr = pc;
   end

   always_ff @ (posedge clk , posedge rst ) begin : if_seq      
      if(rst == 1'b1) {
	 pc <= '0;
	 if_id_ir <= '0;	 
      }
      else {
	 //Instruction cache miss, if and id stalled for branch instrunctions
	 //Rest of pipe can continue and resolver data dependencies
	 if(dc_wait == 1'b0 && stall == 1'b0){
	    if_id_ir <= ic_data;
	    if(id_cond == 1'b0){
	       npc = pc + 4; 
            }
	    else if (id_cond = 1'b1){
		    npc = id_npc;
            }
	    else{
	       npc <= 'x; // default x propagation
            }
            if_id_npc <= npc;
            pc <= npc;  
        }
      }
   end : if_seq
   
endmodule
  
   
		    

		   
