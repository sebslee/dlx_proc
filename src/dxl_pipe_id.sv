//Created by Sebastian Lee
//See LICENSE file, no reliability whatsoever, use AS IS condition.
//Date: 23/10/17
//Description:
//DLX Instruction decode pipe stage
//
//
//
//
////////////////////////////////////////////////////////////////////


`ifndef DLX_PIPE_ID
 `define DLX_PIPE_ID

 `include "../include/dlx_global_pkg.svh"

import dlx_global_pkg::*;

module dlx_pipe_id(
		   input logic clk,
		   input logic rst,
		   input logic stall,
		   input logic dc_wait,
		   //NPC & IR from IF
		   input dlx_word if_id_npc,
		   input dlx_global_pkg::dlx_word if_id_ir,
		   //Data from register file
		   input dlx_global_pkg::dlx_word id_a,
		   input dlx_global_pkg::dlx_word id_b,
		   //Instr data to/from forwarding control
		   output dlx_global_pkg::opcode_class id_opcode_class,
		   output dlx_global_pkg::reg_adr id_ir_rs1,
		   output dlx_global_pkg::reg_adr id_ir_rs2,
		   input  dlx_global_pkg::fwd_select id_a_fwd_sel,
		   input dlx_global_pkg::dlx_word ex_mem_alu_out,

		   //ctrl signals for IF stage
		   output logic id_cond,
		   output dlx_global_pkg::dlx_word id_npc,
		   output logic id_illegal_instr,
		   output logic id_halt,

		   //ctrl signal for EX/MEM/WB stage
		   output dlx_global_pkg::dlx_word id_ex_a,
		   output dlx_global_pkg::dlx_word id_ex_b,
		   output dlx_global_pkg::imm17 id_ex_imm,
		   output dlx_global_pkg::alu_func id_ex_alu_func,
		   output logic id_ex_alu_opb_sel,
		   output logic id_ex_dm_en ,
		   output logic id_ex_dm_wen ,
		   output dlx_global_pkg::mem_width id_ex_dm_width,
		   output logic id_ex_us_sel,
		   output logic id_ex_data_sel ,
		   output dlx_global_pkg::reg_adr id_ex_reg_rd,
		   output logic id_ex_reg_wen ,
		   output dlx_global_pkg::opcode_class id_ex_opcode_class,
		   output dlx_global_pkg::reg_adr id_ex_ir_rs1,
		   output dlx_global_pkg::reg_adr id_ex_ir_rs2
		   );
   
		   
//internal signals
   dlx_global_pkg::dlx_word_us iar;
   dlx_global_pkg::dlx_word id_a_fwd;
   dlx_global_pkg::opcode_class id_opcode_class_int;

   dlx_global_pkg::opcode if_id_ir_opcode;
   dlx_global_pkg::reg_adr if_id_ir_rs1;
   dlx_global_pkg::reg_adr if_id_ir_rs2;
   dlx_global_pkg::reg_adr if_id_ir_rd_rtype;
   dlx_global_pkg::reg_adr if_id_ir_rd_itype;
   dlx_global_pkg::spfunc if_id_ir_spfunc;
   dlx_global_pkg::fpfunc if_id_ir_fpfunc;
   logic [15:0] 	  if_id_ir_imm16;
   logic [25:0] 	  if_id_ir_imm26;

   //split instruction word
   assign if_id_ir_opcode = if_id_ir[5:0];
   assign if_id_ir_rs1 = if_id_ir [10:6];
   assign if_id_ir_rs2 = if_id_ir [15:11];
   assign if_id_ir_rd_rtype = if_id_ir[20:16];
   assign if_id_ir_rd_itype = if_id_ir[15:11];
   assign if_id_ir_spfunc = if_id_ir[31:26];
   assign if_id_ir_fpfunc = if_id_ir[31:27];
   assign if_id_ir_imm16 = if_id_ir[31:16];
   assign if_id_ir_imm26 = if_id_ir[31:6];

   assign id_ir_rs1 = if_id_ir_rs1;
   assign id_ir_rs2 = if_id_ir_rs2;
   assign id_opcode_class = id_opcode_class_int;

   //Multiplex operand a
   //Forwarding
   always_comb begin : id_fwd_a_mux
      id_a_fwd = (ex_mem_alu_out == FWDSEL_EX_MEM_ALU_OUT) ? ex_mem_alu_out : id_a;
   end : id_fwd_a_mux

   //always_comb begin : id_comb
      
endmodule // dlx_pipe_id
`endif
   
      
   
   
 
