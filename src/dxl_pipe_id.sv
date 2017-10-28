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
		   input dlx_word if_id_ir,
		   //Data from register file
		   input dlx_word id_a,
		   input dlx_word id_b,
		   //Instr data to/from forwarding control
		   output opcode_class id_opcode_class,
		   output reg_adr id_ir_rs1,
		   output reg_adr id_ir_rs2,
		   input  fwd_select id_a_fwd_sel,
		   input  dlx_word ex_mem_alu_out,

		   //ctrl signals for IF stage
		   output logic id_cond,
		   output dlx_word id_npc,
		   output logic id_illegal_instr,
		   output logic id_halt,

		   //ctrl signal for EX/MEM/WB stage
		   output dlx_word id_ex_a,
		   output dlx_word id_ex_b,
		   output imm17 id_ex_imm,
		   output alu_func id_ex_alu_func,
		   output logic id_ex_alu_opb_sel,
		   output logic id_ex_dm_en ,
		   output logic id_ex_dm_wen ,
		   output mem_width id_ex_dm_width,
		   output logic id_ex_us_sel,
		   output logic id_ex_data_sel ,
		   output reg_adr id_ex_reg_rd,
		   output logic id_ex_reg_wen ,
		   output opcode_class id_ex_opcode_class,
		   output reg_adr id_ex_ir_rs1,
		   output reg_adr id_ex_ir_rs2
		   );
   
		   
//internal signals
   dlx_word_us iar;
   dlx_word id_a_fwd;
   opcode_class id_opcode_class_int;

   opcode if_id_ir_opcode;
   reg_adr if_id_ir_rs1;
   reg_adr if_id_ir_rs2;
   reg_adr if_id_ir_rd_rtype;
   reg_adr if_id_ir_rd_itype;
   spfunc if_id_ir_spfunc;
   fpfunc if_id_ir_fpfunc;
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

   always_comb begin : id_comb
      logic [31:0] imm16 , imm26;

      id_cond = '0;
      id_illegal_instr = '0;
      id_halt = '0;
      id_npc = 'x;

      //Address calculation + sign extension
      imm16 = {{16{if_id_ir_imm16[15]}},if_id_ir_imm16[15:0]};
      imm26 = {{6{if_id_ir_imm26[25]}},if_id_ir_imm26[25]};

      //Trap
      if(if_id_ir_opcode == op_trap)
	id_halt = 1'b1;
      else
	id_halt = 1'b0;
      //Branch and jump logic
      //Set id_cond if jump instruction or branch and condition satisfied
      if( (if_id_ir_opcode == op_j || if_id_ir_opcode == op_jal || if_id_ir_opcode == op_jalr || if_id_ir_opcode == op_jr) || (if_id_ir_opcode == op_beqz && id_a_fwd == '0) || (if_id_ir_opcode == op_bnez && id_a_fwd != '0))
	id_cond = 1'b1;
      else
	id_cond = 1'b0;
   //Next address calculation logic
     if( if_id_ir_opcode == op_jr || if_id_ir_opcode == op_jal)
       id_npc = if_id_npc + imm_26;
     else if (if_id_ir_opcode == op_jr || if_id_ir_opcode == op_jalr)
       id_npc = id_a_fwd;
     else if (if_id_Ir_opcode == op_beqz || if_id_ir_opcode == op_bnez)
       id_npc = if_id_npc + imm16;

      //Opcode class decode
      case (if_id_ir_opcode) begin
	 op_special:
	   if( if_id_ir_spfunc == sp_nop)
	     id_opcode_class_int = NOFORW;
	   else
	     id_opcode_class_int = RR_ALU;
	 op_addi :
	   id_opcode_class_int = IM_ALU;
	 op_addui:
	   id_opcode_class_int = IM_ALU;
	 op_andi :
	   id_opcode_class_int = IM_ALU;
	 op_beq:
	   id_opcode_class_int = BRANCH;
	 op_bnez:
	   id_opcode_class_int = BRANCH;
	 op_jalr:
	   id_opcode_class_int = BRANCH;
	 op_jr:
	   id_opcode_class_int = BRANCH;
	 op_lb:
	   id_opcode_class_int = LOAD;
	 op_lbu:
	   id_opcode_class_int = LOAD;
	 op_lh :
	   id_opcode_class_int = LOAD;
	 op_lhi:
	   id_opcode_class_int = IM_ALU;
	 op_lhu:
	   id_opcode_class_int = LOAD;
	 op_lw :
	   id_opcode_class_int = LOAD;
	 op_ori:
	   id_opcode_class_int = IM_ALU;
	 op_seqi:
	   id_opcode_class_int = IM_ALU;
	 op_sgei:
	   id_opcode_class_int = IM_ALU;
	 op_sgti:
	   id_opcode_class_int = IM_ALU;
	 op_sh :
	   id_opcode_class_int = STORE;
	 op_slei:
	   id_opcode_class_int = IM_ALU;
	 op_slli:
	   id_opcode_class_int = IM_ALU;
	 op_slti:
	   id_opcode_class_int = IM_ALU;
	 op_snei:
	   id_opcode_class_int = IM_ALU;
	 op_srai:
	   id_opcode_class_int = IM_ALU;
	 op_srli:
	   id_opcode_class_int = IM_ALU;
	 op_subi:
	   id_opcode_class_int = IM_ALU;
	 op_sw:
	   id_opcode_class_int = STORE;
	 op_sb:
	   id_opcode_class_int = STORE;
	 op_xori:
	   id_opcode_class_int = IM_ALU;
	 op_j:
	   id_opcode_class_int = NOFORW;
	 op_jal:
	   id_opcode_class_int = NOFORW;
	 default:
	   id_opcode_class_int = NOFORW;
	   id_illegal_instr = 1'b1;
      endcase // case (if_id_ir_opcode)
            	 	 	 	 	 	 	                  
   end: id_comb
   
      
endmodule // dlx_pipe_id
`endif
   
      
   
   
 
