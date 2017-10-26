//Created by Sebastian Lee
//See LICENSE file, no reliability whatsoever, use AS IS condition.
//Date: 23/10/17
//Description:
//Global dlx typedefs and constants
//
//
//
//
////////////////////////////////////////////////////////////////////

`ifndef DLX_GLOBALS
`define DLX_GLOBALS

package dlx_global_pkg;
   
   `define DLX_WORD_SIZE 32
   `define DLX_ADDR_SIZE 32
   typedef dlx_word logic [`DLX_WORD_SIZE-1 : 0];   
   typedef dlx_addr logic [`DLX_ADDR_SIZE-1 : 0];
   typedef dlx_arith_word [`DLX_WORD_SIZE : 0];

   typedef opcode logic [5 : 0];
   typedef spfunc logic [5 : 0];
   typedef fpfunc logic [4 : 0];
   typedef regadr logic [4 : 0];
   typedef imm16 logic [15 :0];
   typedef imm26 logic [25: 0];
   typedef imm17 logic [16: 0];

   typedef alu_func logic [3 : 0];
   typedef mem_width logic [1 : 0];

   typedef enum { NOFORW , LOAD , STORE , RR_ALU , IM_ALU , BRANCH , MOVEI2S , MOVES2I } opcode_class;

   typedef enum {FWDSEL_NOFORW , FWDSEL_EX_MEM_ALU_OUT , FWDSEL_MEM_WB_DATA } fwd_select;

   //Constants

   `define ADDRESS_WIDTH 16;
   `define DLX_WORD_ZERO 0

   `define SEL_ALU_OUT 1'b1
   `define SEL_DM_OUT 1'b0
   `define SEL_UNSIGNED 1'b0
   `define SEL_SIGNED 1'b1
   `define SEL_ID_EX_B 1'b1
   `define SEL_ID_EX_IMM 1'b0
   `define REG_0 5'b00000
   `define REG_31 5'b11111
   `define MEM_WIDTH_WORD 2'b00
   `define MEM_WIDTH_HALFWORD 2'b10
   `define MEM_WIDTH_BYTE 2'b01
   `define bw_ic_offset 5
   `define bw_ic_tag 7
   `define bw_dc_offset 5
   `define bw_dc_tag 7
   `define bw_cacheline 128

endpackage; // dlx_global_pkg
   
  

   

   
     
   
  
   
