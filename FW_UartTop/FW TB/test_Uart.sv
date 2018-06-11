//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-05-11
//====================================================================

`timescale 1ns / 10ps

config testConfig;
  design work.test_Uart;
  default liblist work;
endconfig

module test_Uart;
  int ErrCnt;
  int ProgramErrCnt, TopErrCnt;

  // Define top level testbench interface.
  inTb_Princess uin_Tb();

  // Override testbench configuration
  defparam uin_Tb.uin_DevA.uin_PrincessTbConfig.INC_LTEDSP = 0;
  defparam uin_Tb.uin_DevA.uin_PrincessTbConfig.INC_DFT    = 0;

  // Instantiate the shared testbench, with it's error counter
  tb_Princess tb(.uin_Tb(uin_Tb), .ErrCnt(ErrCnt));
  
  // Instantiate the test program with the interfaces
  testPr_Uart utestPr_Uart(.uin_DevA(uin_Tb.uin_DevA), .ErrCnt(ErrCnt));
endmodule
