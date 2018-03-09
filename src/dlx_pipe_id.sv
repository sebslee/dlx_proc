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
`include "/home/sleebarr/HDL_PROJECTS/dlx_proc/include/dlx_opcode_package.svh"
`include "/home/sleebarr/HDL_PROJECTS/dlx_proc/include/dlx_global_pkg.svh"
 //`include "../include/dlx_global_pkg.svh"
//`include "~/HDL_PROJECTS/dlx_proc/include/dlx_opcode_package.svh"

import dlx_global_pkg::*;
import dlx_opcode_package::*;

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
      imm26 = {{6{if_id_ir_imm26[25]}},if_id_ir_imm26[25:0]};

      //Trap
      if(if_id_ir_opcode == `op_trap)
	id_halt = 1'b1;
      else
	id_halt = 1'b0;
      //Branch and jump logic
      //Set id_cond if jump instruction or branch and condition satisfied
      if( (if_id_ir_opcode == `op_j || if_id_ir_opcode == `op_jal || if_id_ir_opcode == `op_jalr || if_id_ir_opcode == `op_jr) || (if_id_ir_opcode == `op_beqz && id_a_fwd == '0) || (if_id_ir_opcode == `op_bnez && id_a_fwd != '0))
	id_cond = 1'b1;
      else
	id_cond = 1'b0;
   //Next address calculation logic
     if( if_id_ir_opcode == `op_jr || if_id_ir_opcode == `op_jal)
       id_npc = if_id_npc + imm26;
     else if (if_id_ir_opcode == `op_jr || if_id_ir_opcode == `op_jalr)
       id_npc = id_a_fwd;
     else if (if_id_ir_opcode == `op_beqz || if_id_ir_opcode == `op_bnez)
       id_npc = if_id_npc + imm16;

      //Opcode class decode
      case (if_id_ir_opcode) 
	 `op_special:
	   if( if_id_ir_spfunc == `sp_nop)
	     id_opcode_class_int = NOFORW;
	   else
	     id_opcode_class_int = RR_ALU;
	 `op_addi :
	   id_opcode_class_int = IM_ALU;
	 `op_addui:
	   id_opcode_class_int = IM_ALU;
	 `op_andi :
	   id_opcode_class_int = IM_ALU;
	 `op_beqz:
	   id_opcode_class_int = BRANCH;
	 `op_bnez:
	   id_opcode_class_int = BRANCH;
	 `op_jalr:
	   id_opcode_class_int = BRANCH;
	 `op_jr:
	   id_opcode_class_int = BRANCH;
	 `op_lb:
	   id_opcode_class_int = LOAD;
	 `op_lbu:
	   id_opcode_class_int = LOAD;
	 `op_lh :
	   id_opcode_class_int = LOAD;
	 `op_lhi:
	   id_opcode_class_int = IM_ALU;
	 `op_lhu:
	   id_opcode_class_int = LOAD;
	 `op_lw :
	   id_opcode_class_int = LOAD;
	 `op_ori:
	   id_opcode_class_int = IM_ALU;
	 `op_seqi:
	   id_opcode_class_int = IM_ALU;
	 `op_sgei:
	   id_opcode_class_int = IM_ALU;
	 `op_sgti:
	   id_opcode_class_int = IM_ALU;
	 `op_sh :
	   id_opcode_class_int = STORE;
	 `op_slei:
	   id_opcode_class_int = IM_ALU;
	 `op_slli:
	   id_opcode_class_int = IM_ALU;
	 `op_slti:
	   id_opcode_class_int = IM_ALU;
	 `op_snei:
	   id_opcode_class_int = IM_ALU;
	 `op_srai:
	   id_opcode_class_int = IM_ALU;
	 `op_srli:
	   id_opcode_class_int = IM_ALU;
	 `op_subi:
	   id_opcode_class_int = IM_ALU;
	 `op_sw:
	   id_opcode_class_int = STORE;
	 `op_sb:
	   id_opcode_class_int = STORE;
	 `op_xori:
	   id_opcode_class_int = IM_ALU;
	 `op_j:
	   id_opcode_class_int = NOFORW;
	 `op_jal:
	   id_opcode_class_int = NOFORW;
	 default: begin
	   id_opcode_class_int = NOFORW;
	   id_illegal_instr    = 1'b1;
           end
      endcase // case (if_id_ir_opcode)
            	 	 	 	 	 	 	                  
   end: id_comb

   always_ff @(posedge clk) begin : id_seq
      if(rst == 1'b1) begin
	 iar <= '0;
	 id_ex_dm_wen <='0;
	 id_ex_dm_en <= '0;
	 id_ex_reg_wen <= '0;
	 id_ex_a <= '0;
	 id_ex_b <= '0;
	 id_ex_imm <= '0;
	 id_ex_opcode_class <= NOFORW;
      end
      else begin
	 if(dc_wait == 1'b0) begin
	    //Data cache wait off , NOP behavior default
	    id_ex_a            <= id_a;
            id_ex_b            <= id_b;
            id_ex_imm          <= {if_id_ir_imm16[15] , if_id_ir_imm16};	   
            id_ex_alu_opb_sel  <= `SEL_ID_EX_B;
            id_ex_us_sel       <= `SEL_SIGNED;
            id_ex_data_sel     <= `SEL_ALU_OUT;
            id_ex_alu_func     <= `alu_add;
            id_ex_dm_width     <= `MEM_WIDTH_WORD;
            id_ex_dm_wen       <= '0;
            id_ex_dm_en        <= '0;
            id_ex_reg_rd       <= `REG_0;	   
            id_ex_reg_wen      <= '0;	   
            id_ex_ir_rs1       <= if_id_ir_rs1;	   
            id_ex_ir_rs2       <= if_id_ir_rs2;       
	    if(stall == 1'b1) begin
	       id_ex_opcode_class <= NOFORW;
	    end	   
	    else begin
	       id_ex_opcode_class <= id_opcode_class_int;
	       //Pipe register
	       id_ex_a <= id_a_fwd;
	       id_ex_b <= id_b;
	       id_ex_imm <= {if_id_ir_imm16[15], if_id_ir_imm16};

	       //ALU function decode
	       if((if_id_ir_opcode == `op_special && (if_id_ir_spfunc == `sp_add || if_id_ir_spfunc == `sp_addu)) || (if_id_ir_opcode == `op_addi || if_id_ir_opcode == `op_addui))
		 id_ex_alu_func <= `alu_add;
	       else if ((if_id_ir_opcode == `op_special && (if_id_ir_spfunc == `sp_sub || if_id_ir_spfunc == `sp_subu)) || if_id_ir_opcode == `op_subi || if_id_ir_opcode == `op_subui)
		 id_ex_alu_func <= `alu_sub;
	       else if((if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_and) || if_id_ir_opcode == `op_andi)
		 id_ex_alu_func <= `alu_and;
	       else if((if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_or) ||  if_id_ir_opcode == `op_ori)
		 id_ex_alu_func <= `alu_or;
	       else if((if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_xor) ||  if_id_ir_opcode == `op_xori)
		 id_ex_alu_func <= `alu_xor;
	       else if(if_id_ir_opcode == `op_lhi) begin 
		  id_ex_a <= { if_id_ir_imm16 ,  '0};
		  id_ex_alu_func <= `alu_a;
	       end
	       else if((if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_sll) || if_id_ir_opcode == `op_slli)
		 id_ex_alu_func <= `alu_sll;
	       else if((if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_sra) || if_id_ir_opcode == `op_srai)
		 id_ex_alu_func <= `alu_sra;
	       else if((if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_slt) || if_id_ir_opcode == `op_slti)
		 id_ex_alu_func <= `alu_slt;
	       else if((if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_sgt) || if_id_ir_opcode == `op_sgti)
		 id_ex_alu_func <= `alu_sgt;
	       else if((if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_sle) || if_id_ir_opcode == `op_slei)
		 id_ex_alu_func <= `alu_sle;
	       else if((if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_sge) || if_id_ir_opcode == `op_sgei)
		 id_ex_alu_func <= `alu_sge;
	       else if((if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_seq) ||	 if_id_ir_opcode == `op_seqi)
		 id_ex_alu_func <= `alu_seq;
	       else if((if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_sne) ||  if_id_ir_opcode == `op_snei)
		 id_ex_alu_func <= `alu_sne;
	       else //x propagation if no valid operand //?
	       id_ex_alu_func <= 'x;

	       //Alu OP select
	       if(if_id_ir_opcode == `op_special)//RR
		 id_ex_alu_opb_sel <= `SEL_ID_EX_B;
	       else
		 id_ex_alu_opb_sel <= `SEL_ID_EX_IMM;
	       
	       //Memory enable/write logic generation
	       if(if_id_ir_opcode == `op_lb || if_id_ir_opcode == `op_lbu ||
		  if_id_ir_opcode == `op_lh || 
		  if_id_ir_opcode == `op_lhu || if_id_ir_opcode == `op_lw)
		 begin
		    id_ex_dm_en  <= 1'b1;
		    id_ex_dm_wen <= 1'b0;
		 end      
	       else if (if_id_ir_opcode == `op_sb || if_id_ir_opcode == `op_sh || if_id_ir_opcode == `op_sw)
		 begin
		    id_ex_dm_en  <= 1'b1;
		    id_ex_dm_wen <= 1'b1;
		 end            
	       else begin
		  id_ex_dm_en  <= 1'b0;
		  id_ex_dm_wen <= 1'b0;
	       end

	       //Memowy width load or store

	       case(if_id_ir_opcode)
		 `op_lb :
		   id_ex_dm_width <= `MEM_WIDTH_BYTE;
		 `op_sb :
		   id_ex_dm_width <= `MEM_WIDTH_BYTE;
		 `op_lbu :
		   id_ex_dm_width <= `MEM_WIDTH_BYTE;
		 `op_lh :
		   id_ex_dm_width <= `MEM_WIDTH_HALFWORD;	
		 `op_lhu :
		   id_ex_dm_width <= `MEM_WIDTH_HALFWORD;
		 `op_sh :
		   id_ex_dm_width <= `MEM_WIDTH_HALFWORD;
		 `op_lw :
		   id_ex_dm_width <= `MEM_WIDTH_WORD;
		 `op_sw :
		   id_ex_dm_width <= `MEM_WIDTH_WORD;
		 default :
		   id_ex_dm_width <= `MEM_WIDTH_WORD;
	       endcase // case (if_id_ir_opcode)

               //Signed or unsigned operation selector
	       if(if_id_ir_spfunc == `sp_add || if_id_ir_spfunc == `sp_sub ||
		  if_id_ir_opcode == `op_addi || if_id_ir_opcode == `op_subi ||
		  if_id_ir_opcode ==  `op_lb ||   if_id_ir_opcode == `op_lh  ||  if_id_ir_opcode == `op_lw ) 
		 id_ex_us_sel <= `SEL_SIGNED;
	       else
		 id_ex_us_sel <=  `SEL_UNSIGNED;

               //Target register write data select (ALU or MEMORY)
	       if(if_id_ir_opcode == `op_lw ||  if_id_ir_opcode == `op_lb || if_id_ir_opcode == `op_lh || if_id_ir_opcode == `op_lbu || if_id_ir_opcode == `op_lhu ) 
		 id_ex_data_sel <= `SEL_DM_OUT;
	       else
		 id_ex_data_sel <= `SEL_ALU_OUT;

	       if (if_id_ir_opcode == `op_special) 
		 id_ex_reg_rd <= if_id_ir_rd_rtype;
	       else
		 id_ex_reg_rd <= if_id_ir_rd_itype;

               // Write enable register logic 
	       if (if_id_ir_opcode == `op_j || if_id_ir_opcode == `op_jr ||
		   if_id_ir_opcode == `op_jal ||  if_id_ir_opcode == `op_jalr ||
		   if_id_ir_opcode == `op_beqz || if_id_ir_opcode == `op_bnez ||
		   (if_id_ir_opcode == `op_special && if_id_ir_spfunc == `sp_nop)
		   || if_id_ir_opcode == `op_sw ||  if_id_ir_opcode == `op_sh ||
		   if_id_ir_opcode == `op_sb ||  if_id_ir_opcode == `op_trap) 
		 id_ex_reg_wen <= 1'b0;
	       else
		 id_ex_reg_wen <= 1'b1;

               //Pipe register content
               id_ex_opcode_class <= id_opcode_class_int;
               id_ex_ir_rs1 <= if_id_ir_rs1;
               id_ex_ir_rs2 <= if_id_ir_rs2;
	       
            end
         end 	   
      end                    	
   end // block: id_seq
   	      		  	  	          
endmodule // dlx_pipe_id
`endif
   
      
   
   
 
