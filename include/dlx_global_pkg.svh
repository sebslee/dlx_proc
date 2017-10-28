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
   typedef logic [`DLX_WORD_SIZE-1 : 0] dlx_word ; 
   typedef logic unsigned  [`DLX_WORD_SIZE-1 : 0] dlx_word_us;  
   typedef logic [`DLX_ADDR_SIZE-1 : 0] dlx_addr ;
   typedef logic [`DLX_WORD_SIZE : 0] dlx_arith_word;

   typedef  logic [5 : 0] opcode;
   typedef  logic [5 : 0] spfunc;
   typedef  logic [4 : 0] fpfunc;
   typedef  logic [4 : 0] regadr;
   typedef  logic [15 :0] imm16;
   typedef  logic [25: 0] imm26;
   typedef  logic [16: 0] imm17;

   typedef  logic [3 : 0] alu_func;
   typedef  logic [1 : 0] mem_width;

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

endpackage // dlx_global_pkg
   
`endif

   

   
     
   
  
   
