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

`include "../include/dlx_global_pkg.svh"

import dlx_global_pkg::*;

module dlx_pipe_if (
		    input logic clk,
		    input logic rst,
		    input logic stall,
		    input logic dc_wait,
		    input dlx_word_us id_npc,
		    input logic id_cond,		    
		    input  dlx_word ic_data,
		    output dlx_addr ic_addr,
		    output dlx_word if_id_ir ,
		    output dlx_word_us if_id_npc
		    );

   //Internal signals
   
   dlx_word_us pc; //program counter
   dlx_word_us npc;
         
   always_comb begin: if_comb
      ic_addr = pc;
   end

   always_ff @ (posedge clk , posedge rst ) begin : if_seq      
      if(rst == 1'b1) begin
	 pc <= '0;
	 if_id_ir <= '0;	 
      end
      else begin
	 //Instruction cache miss, if and id stalled for branch instrunctions
	 //Rest of pipe can continue and resolver data dependencies
	 if(dc_wait == 1'b0 && stall == 1'b0)begin
	    if_id_ir <= ic_data;
	    if(id_cond == 1'b0)begin
	       npc = pc + 4; 
            end
	    else if (id_cond == 1'b1)begin
		    npc = id_npc;
            end
	    else begin
	       npc <= 'x; // default x propagation
            end
            if_id_npc <= npc;
            pc <= npc;  
        end
      end
   end : if_seq
   
endmodule
  
`endif

		    

		   
