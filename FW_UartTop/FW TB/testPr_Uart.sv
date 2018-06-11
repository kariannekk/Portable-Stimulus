//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-05-11
//====================================================================

program automatic testPr_Uart(inDev_Princess uin_DevA, output int ErrCnt);

  //FW code
  string fwuart =  {"$VC_WORKSPACE/products/Princess/common/sim_Uart/fw/tb/uart_002.axf.vhx32"};

  initial begin
    string testName;
    $timeformat(-6, 3, " us", 0);

    wait(uin_DevA.uin_Ctrl.simTestInit);

    $display("%t - %m starting", $time);

    $display("------------------------------------------------------------");
    $display("   Running tests for UARTU0, with base addr: %0h",pa_AppBaseAddr::APP_UARTE0);
    $display("------------------------------------------------------------");

    ta_TransferRxTxDataWithDma();

    $display("%0t - %m done", $time); 
    $finish;
  end

  //GPIO used by RXD in UART, assigned to GPIO in FW applying receive information
  initial begin
    uin_DevA.GPIO[0].ctrl.en_control = 1'b1;
  end
  assign uin_Tb.uin_DevA.GPIO[0].ctrl.in = uin_Tb.uin_DevA.GPIO[5].ctrl.out;


  task ta_TransferRxTxDataWithDma();
    $display("");
    $display("--------------------------------------------------------------------------------");
    $display("%0t - %m starting", $time);
    $display("--------------------------------------------------------------------------------");

    // Load firmware
    uin_DevA.uin_Tasks.APPMCU.uin_AppFlashMem_Tasks.ta_LoadROM(.filename(fwuart));

    // Reset device to load FW
    #10ns;
    begin
      -> uin_DevA.uin_Ctrl.reset;
      #0;
      wait(uin_DevA.uin_Ctrl.resetDone);
    end

    fork : la_Timeout
      begin
        wait(`DevA.`AppPer_SS.la_SerIOBox[0].u_SerIOBox.u_Uart.uartEnable);
        wait(!(`DevA.`AppPer_SS.la_SerIOBox[0].u_SerIOBox.u_Uart.uartEnable));
      end
      begin
        #3000us;
        $error("Test timed out");
      end
    join_any
    disable la_Timeout;

    $display("%0t - Test complete", $time);
  endtask
endprogram