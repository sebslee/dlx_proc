//Created by Sebastian Lee
//See LICENSE file, no reliability whatsoever, use AS IS condition.
//Date: 23/10/17
//Description:
//Global dlx opcodes. NOTE: This file was "auto"-generated from 
//a VHDL description...
//
//
//
////////////////////////////////////////////////////////////////////


package dlx_opcode_package;

// Opcodes (Bits 0 to 5) 
// constants for subtype Opcode defined in package dlx_global
  `define  op_special    6'b000000 // Opcode for R-R-ALU Type instructions
  `define  op_fparith   6'b000001
  `define op_j          6'b000010
  `define op_jal        6'b000011
  `define op_beqz       6'b000100
  `define op_bnez       6'b000101
  `define op_bfpt       6'b000110
  `define op_bfpf       6'b000111
  `define op_addi       6'b001000
  `define op_addui      6'b001001
  `define op_subi	6'b001010
  `define op_subui	6'b001011
  `define op_andi	6'b001100
  `define op_ori	6'b001101
  `define op_xori       6'b001110
  `define op_lhi	6'b001111

  `define op_rfe	      6'b010000
  `define op_trap	   6'b010001
  `define op_jr	      6'b010010
  `define op_jalr	   6'b010011
  `define op_slli	   6'b010100
  `define op_undef_15 6'b010101
  `define op_srli	   6'b010110
  `define op_srai	   6'b010111
  `define op_seqi	   6'b011000
  `define op_snei	   6'b011001
  `define op_slti	   6'b011010
  `define op_sgti	   6'b011011
  `define op_slei	   6'b011100
  `define op_sgei	   6'b011101
  `define op_undef_1E 6'b011110
  `define op_undef_1F 6'b011111

  `define op_lb	      6'b100000
  `define op_lh	      6'b100001
  `define op_undef_22 6'b100010
  `define op_lw	      6'b100011
  `define op_lbu      6'b100100
  `define op_lhu      6'b100101
  `define op_sb	      6'b101000 
  `define op_sh	      6'b101001
  `define op_undef_2A 6'b101010
  `define op_sw	      6'b101011
  `define op_undef_2C 6'b101100
  `define op_undef_2D 6'b101101


  `define op_undef_36 6'b110110
  `define op_undef_37 6'b110111
  `define op_undef_38 6'b111000
  `define op_undef_39 6'b111001
  `define op_undef_3A 6'b111010
  `define op_undef_3B 6'b111011
  `define op_undef_3C 6'b111100
  `define op_undef_3D 6'b111101
  `define op_undef_3E 6'b111110
  `define op_undef_3F  6'b111111

// func codes for R-R-ALU Type instructions
// constants for subtype Spfunc defined in package dlx_global
  `define sp_undef_00  6'b000000
  `define sp_undef_01  6'b000001
  `define sp_undef_02  6'b000010
  `define sp_undef_03  6'b000011
  `define sp_sll       6'b000100
  `define sp_undef_05  6'b000101
  `define sp_srl       6'b000110
  `define sp_sra       6'b000111
  `define sp_undef_08  6'b001000
  `define sp_undef_09  6'b001001
  `define sp_undef_0A  6'b001010
  `define sp_undef_0B  6'b001011
  `define sp_undef_0C  6'b001100
  `define sp_undef_0D  6'b001101
  `define sp_undef_0E  6'b001110
  `define sp_undef_0F  6'b001111
	                 
  `define sp_sequ      6'b010000
  `define sp_sneu      6'b010001
  `define sp_sltu      6'b010010
  `define sp_sgtu      6'b010011
  `define sp_sleu      6'b010100
  `define sp_sgeu      6'b010101
  `define sp_undef_16  6'b010110
  `define sp_undef_17  6'b010111
  `define sp_undef_18  6'b011000
  `define sp_undef_19  6'b011001
  `define sp_undef_1A  6'b011010
  `define sp_undef_1B  6'b011011
  `define sp_undef_1C  6'b011100
  `define sp_undef_1D  6'b011101
  `define sp_undef_1E  6'b011110
  `define sp_undef_1F  6'b011111
			     
  `define sp_add       6'b100000
  `define sp_addu      6'b100001
  `define sp_sub       6'b100010
  `define sp_subu      6'b100011
  `define sp_and       6'b100100
  `define sp_or        6'b100101
  `define sp_xor       6'b100110
  `define sp_undef_27  6'b100111
  `define sp_seq       6'b101000
  `define sp_sne       6'b101001
  `define sp_slt       6'b101010
  `define sp_sgt       6'b101011
  `define sp_sle       6'b101100
  `define sp_sge       6'b101101
  `define sp_undef_2E  6'b101110
  `define sp_undef_2F  6'b101111
	                 
  `define sp_movi2s    6'b110000
  `define sp_movs2i    6'b110001
  `define sp_movf      6'b110010
  `define sp_movd      6'b110011
  `define sp_movfp2i   6'b110100
  `define sp_movi2fp   6'b110101
  `define sp_undef_36  6'b110110
  `define sp_undef_37  6'b110111
  `define sp_undef_38  6'b111000
  `define sp_undef_39  6'b111001
  `define sp_undef_3A  6'b111010
  `define sp_undef_3B  6'b111011
  `define sp_undef_3C  6'b111100
  `define sp_undef_3D  6'b111101
  `define sp_undef_3E  6'b111110
  `define sp_nop       6'b111111

  //not implemented ..			     
  `define fp_addf      6'b00000
  `define fp_subf      6'b00001
  `define fp_multf     6'b00010
  `define fp_divf      6'b00011
  `define fp_addd      6'b00100
  `define fp_subd      6'b00101
  `define fp_multd     6'b00110
  `define fp_divd      6'b00111
  `define fp_cvtf2d    6'b01000
  `define fp_cvtf2i    6'b01001
  `define fp_cvtd2f    6'b01010
  `define fp_cvtd2i    6'b01011
  `define fp_cvti2f    6'b01100
  `define fp_cvti2d    6'b01101
  `define fp_mult      6'b01110
  `define fp_div       6'b01111
	                 
  `define fp_eqf       6'b10000
  `define fp_nef       6'b10001
  `define fp_ltf       6'b10010
  `define fp_gtf       6'b10011
  `define fp_lef       6'b10100
  `define fp_gef       6'b10101
  `define fp_multu     6'b10110
  `define fp_divu      6'b10111
  `define fp_eqd       6'b11000
  `define fp_ned       6'b11001
  `define fp_ltd       6'b11010
  `define fp_gtd       6'b11011
  `define fp_led       6'b11100
  `define fp_ged       6'b11101
  `define fp_undef_1E  6'b11110
  `define fp_undef_1F  6'b11111

// Code for ALU functions
// constants for subtype Alu_func defined in package dlx_global
  `define alu_a        6'b0000
  `define alu_b        6'b0001
  `define alu_add      6'b0010
  `define alu_sub      6'b0011
  `define alu_and      6'b0100
  `define alu_or       6'b0101
  `define alu_xor      6'b0110
  `define alu_sll      6'b0111
  `define alu_srl      6'b1000
  `define alu_sra      6'b1001
  `define alu_slt      6'b1010
  `define alu_sgt      6'b1011
  `define alu_sle      6'b1100
  `define alu_sge      6'b1101
  `define alu_seq      6'b1110
  `define alu_sne      6'b1111
  
endpackage
