//***************************************************************************
//*                 infact_uart_receive_transaction_gen.svh
//*
//* Copyright 2011 Mentor Graphics Corporation. All Rights Reserved
//***************************************************************************/

`ifndef  INCLUDED_infact_uart_receive_transaction_gen_SVH
`define INCLUDED_infact_uart_receive_transaction_gen_SVH

//<imports,gen>
import uvm_pkg::*;
import inFactSv::*;
`include "uvm_macros.svh"
`include "infact_uart_receive_transaction_gen_scheduler.svh"

// Class items
`include "infact_uart_receive_transaction_gen_items.svh"

`include "infact_uart_receive_transaction_gen_cov.svh"


// Forward declaration of callback closure classes
`include "infact_uart_receive_transaction_gen_callback_closures.svh"

/** Graph Parameters
 * 
 * Usage:
 * 
 * Pass parameters to the scheduler constructor in the body() task:
 * m_scheduler = new(get_full_name());
 *
 */

//</imports>

//<include,gen>

//</include>

//<base_class,gen>
typedef paTest_uart::uart_sequence_receive infact_uart_receive_transaction_gen_base_t;
//</base_class>

//<graph_cb,gen>
typedef class infact_uart_receive_transaction_gen_cb;
//</graph_cb>


//TODO: Specialize the sequence with REQ/RSP types
class infact_uart_receive_transaction_gen extends infact_uart_receive_transaction_gen_base_t;

    
    // Test-component class type used for registration.
    typedef infact_uart_receive_transaction_gen infact_uart_receive_transaction_gen_t;

    // Register this sequence with the UVM factory
    `uvm_object_utils(infact_uart_receive_transaction_gen)
    
    //***********************************************************************
    //* Class Data
    //***********************************************************************
    
    // inFact scheduler for this sequence
    infact_uart_receive_transaction_gen_scheduler                  m_scheduler;
    
//<item_fields,gen>
    // OFF=0, LOW=1, MEDIUM=2, HIGH=3
    int                                              m_gt_opt = 0;
    TestEngine                                       m_te;
    infact_uart_receive_transaction_gen_cb                         m_teCallback;     
    uart_receive_transaction m_uart_receive_transaction_inst;
    // Enables sequence termination when coverage goals are met
    bit m_terminateOnCoverageGoalsMet = 1;
    // Enables sequence termination when distribution replay data ends
    bit m_terminateOnReplayEnd = 1;
    bit m_replayEndReached = 0;
    // Enables sequence termination after a specific number of sequence items
    int m_iterationLimit = 0;
    // Tracks number of iterations
    int m_iterationCount = 0;
    // Controls how often a coverage report is produced
    int m_coverageReportInterval = 1;
    // Controls the execution of pre and post randomize() menthods
    bit m_run_randomize = 1;


// Coverage Strategy fields
    infact_uart_receive_transaction_gen_pc_closure #(infact_uart_receive_transaction_gen_t)       m_pc_closure;
    infact_uart_receive_transaction_gen_cov            m_infact_uart_receive_transaction_gen_cov;
    bit            m_create_infact_uart_receive_transaction_gen_cov = 1;

//</item_fields>
    
//<user_data,gen>

//</user_data>
     

    //***************************************************************
    //* new()
    //***************************************************************
    function new(string name="");
        super.new(name);
    endfunction
    
    //***************************************************************
    //* body()
    //***************************************************************
    virtual task body();
        // Create the inFact scheduler
        m_scheduler = new(get_full_name());
        
        // Register action tasks with the scheduler
        register_actions();
    
        // Create Coverage Strategies
        create_cov_strategies();
    
        // Run all the test engines
        m_scheduler.run_all();
        
        // Clean up after the test engines return
//<delete_testengines,gen>
        begin
            inFactSv::TestEngine   te;
            te = m_scheduler.infact_uart_receive_transaction_gen();
            te.delete();

        end
//</delete_testengines>
        
    endtask
    
    
    //***************************************************************
    //* Action Tasks
    //***************************************************************
//<action_tasks>

//<action::_infact_checkcov::()>
    //***************************************************************
    //* Action task action_infact_checkcov
    //* Displays coverage report 

    //**************************************************************** 
   virtual task action_infact_checkcov();
        begin
            bit ending = 0;
            m_iterationCount++;
            if ((m_iterationLimit > 0 && 
                m_iterationCount >= m_iterationLimit) ||
                (m_terminateOnCoverageGoalsMet && allCoverageGoalsHaveBeenMet())) begin
                ending = 1;
            end
            // Display a coverage report when requested or when the sequence ends
            if (m_coverageReportInterval > 0 && 
                (ending || !(m_iterationCount % m_coverageReportInterval))) begin
                string report = getCoverageReport();
                if (report != "") begin
                    `uvm_info(get_full_name(), {"Coverage Report:\n", report}, UVM_MEDIUM);
                end
            end
            if (m_terminateOnReplayEnd && m_replayEndReached) begin
      `uvm_info(get_full_name(), "Reached end of replay data. Ending sequence", UVM_MEDIUM);
      ending = 1;
    end
    if (ending) begin
                m_te.stop_loop_expansion_after(0, m_te.loop_depth()-1);
            end
        end

endtask
//</action::_infact_checkcov::()>

//<action::_do_item__uart_receive_transaction_inst__end::()>
    //***************************************************************
    //* Action task action_do_item__uart_receive_transaction_inst__end
    //**************************************************************** 
   virtual task action_do_item__uart_receive_transaction_inst__end();
                if (m_terminateOnReplayEnd && m_replayEndReached) begin
          `uvm_info(get_full_name(), "Skipping finish_item due to replay end", UVM_MEDIUM);
        end else begin
          finish_item(m_uart_receive_transaction_inst);
        end

endtask
//</action::_do_item__uart_receive_transaction_inst__end::()>

//<action::_uart_receive_transaction_inst__post__randomize::()>
    //***************************************************************
    //* Action task action_uart_receive_transaction_inst__post__randomize
    //**************************************************************** 
   virtual task action_uart_receive_transaction_inst__post__randomize();
        m_uart_receive_transaction_inst.post_randomize();

endtask
//</action::_uart_receive_transaction_inst__post__randomize::()>

//<action::_uart_receive_transaction_inst__pre__randomize::()>
    //***************************************************************
    //* Action task action_uart_receive_transaction_inst__pre__randomize
    //**************************************************************** 
   virtual task action_uart_receive_transaction_inst__pre__randomize();
        m_uart_receive_transaction_inst.pre_randomize();

endtask
//</action::_uart_receive_transaction_inst__pre__randomize::()>

//<action::_do_item__uart_receive_transaction_inst__begin::()>
    //***************************************************************
    //* Action task action_do_item__uart_receive_transaction_inst__begin
    //**************************************************************** 
   virtual task action_do_item__uart_receive_transaction_inst__begin();
        m_uart_receive_transaction_inst = uart_receive_transaction::type_id::create();
        if (m_terminateOnReplayEnd && m_replayEndReached) begin
          `uvm_info(get_full_name(), "Skipping start_item due to replay end", UVM_MEDIUM);
        end else begin
          start_item(m_uart_receive_transaction_inst);
        end

endtask
//</action::_do_item__uart_receive_transaction_inst__begin::()>

//<action::_init::()>
    //***************************************************************
    //* Action task action_init
    //**************************************************************** 
   virtual task action_init();
endtask
//</action::_init::()>

//<signed_meta_action::_uart_receive_transaction_inst__delay::()>
    //***************************************************************
    //* Action task action_uart_receive_transaction_inst__delay
    //**************************************************************** 
   virtual task action_uart_receive_transaction_inst__delay(longint meta_val);
        m_uart_receive_transaction_inst.delay = meta_val;
endtask
//</signed_meta_action::_uart_receive_transaction_inst__delay::()>

//<signed_meta_action::_uart_receive_transaction_inst__stop_type::(##ddea067eb86d4ca8a409d9482327cf3d)>
    //***************************************************************
    //* Action task action_uart_receive_transaction_inst__stop_type
    //* field_type = paTest_uart::stop_e
    //**************************************************************** 
   virtual task action_uart_receive_transaction_inst__stop_type(longint meta_val);
        m_uart_receive_transaction_inst.stop_type = paTest_uart::stop_e'(meta_val);
endtask
//</signed_meta_action::_uart_receive_transaction_inst__stop_type::(##ddea067eb86d4ca8a409d9482327cf3d)>

//<signed_meta_action::_uart_receive_transaction_inst__kind::(##50ae3d014218ae0f18c07d06c5c918ce)>
    //***************************************************************
    //* Action task action_uart_receive_transaction_inst__kind
    //* field_type = paTest_uart::kind_e
    //**************************************************************** 
   virtual task action_uart_receive_transaction_inst__kind(longint meta_val);
        m_uart_receive_transaction_inst.kind = paTest_uart::kind_e'(meta_val);
endtask
//</signed_meta_action::_uart_receive_transaction_inst__kind::(##50ae3d014218ae0f18c07d06c5c918ce)>

//<unsigned_meta_action::_uart_receive_transaction_inst__stop_bits::()>
    //***************************************************************
    //* Action task action_uart_receive_transaction_inst__stop_bits
    //**************************************************************** 
   virtual task action_uart_receive_transaction_inst__stop_bits(longint unsigned meta_val);
        m_uart_receive_transaction_inst.stop_bits = meta_val;
endtask
//</unsigned_meta_action::_uart_receive_transaction_inst__stop_bits::()>

//<unsigned_meta_action::_uart_receive_transaction_inst__start_bit::()>
    //***************************************************************
    //* Action task action_uart_receive_transaction_inst__start_bit
    //**************************************************************** 
   virtual task action_uart_receive_transaction_inst__start_bit(longint unsigned meta_val);
        m_uart_receive_transaction_inst.start_bit = meta_val;
endtask
//</unsigned_meta_action::_uart_receive_transaction_inst__start_bit::()>

//<unsigned_meta_action::_uart_receive_transaction_inst__payload::()>
    //***************************************************************
    //* Action task action_uart_receive_transaction_inst__payload
    //**************************************************************** 
   virtual task action_uart_receive_transaction_inst__payload(longint unsigned meta_val);
        m_uart_receive_transaction_inst.payload = meta_val;
endtask
//</unsigned_meta_action::_uart_receive_transaction_inst__payload::()>

//</action_tasks>
    
//<cov_cb_functions>
    /****************************************************************
     * Coverage Callback Functions
     ****************************************************************/

    /****************************************************************
     * pathCoverageCallback() 
     ****************************************************************/
    function void pathCoverageCallback(PathCoverage pc, CoverageCallbackReason reason);
        if (reason == Covered) begin
            $display("Path Coverage %s Complete", pc.name());
        end
    endfunction
//</cov_cb_functions>

//<end_of_replay>
    virtual function void end_of_replay();
      m_replayEndReached = 1;
    endfunction
//</end_of_replay>

//<cov_create_functions>

//<create_cov_strategies,gen>
    function void create_cov_strategies();
    m_pc_closure = new(this);

    if (m_create_infact_uart_receive_transaction_gen_cov) begin
        if (m_gt_opt > 0) $display("[inFact] Creating coverage strategy infact_uart_receive_transaction_gen_cov");
        create_infact_uart_receive_transaction_gen_cov();
    end
    

    endfunction
//</create_cov_strategies>

//<coverage_check_report_methods,gen>
    function string getCoverageReport();
        string report = "";
        if (m_infact_uart_receive_transaction_gen_cov != null) begin
            report = {report, m_infact_uart_receive_transaction_gen_cov.getCoverageReport()};
        end
        
        return report;
    endfunction
        
    function bit allCoverageGoalsHaveBeenMet();
        bit met = 1;
        int n_checked = 0;
        if (m_infact_uart_receive_transaction_gen_cov != null) begin
            met &= m_infact_uart_receive_transaction_gen_cov.allCoverageGoalsHaveBeenMet();
            n_checked++;
        end

        return (met && n_checked > 0);
    endfunction     
//</coverage_check_report_methods>

//<create_cov::infact_uart_receive_transaction_gen_cov>
    function void create_infact_uart_receive_transaction_gen_cov();
        m_infact_uart_receive_transaction_gen_cov = new(m_te, m_te.instance_name());
        m_infact_uart_receive_transaction_gen_cov.setPathCoverageCallback(m_pc_closure);
    endfunction
//</create_cov::infact_uart_receive_transaction_gen_cov>
//</cov_create_functions>
    
    /****************************************************************
     * Private Class Methods
     ****************************************************************/
//<graph_extern,gen>
    extern function int get_graph_trace_option(string instance_name);
//</graph_extern>

     
    /**
     * register_actions()
     *
     * Register action tasks with the scheduler 
     *
     */     
    extern function void register_actions();

endclass

// Implementation of the register_actions function
`include "infact_uart_receive_transaction_gen_register_actions.svh"

`endif /* INCLUDED_infact_uart_receive_transaction_gen_SVH */

`ifdef UNDEFINED
//<trashcan,gen>
//</trashcan>
`endif

