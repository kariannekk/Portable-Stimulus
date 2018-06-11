//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

typedef enum {RECEIVE, TRANSMIT} kind_e;
typedef enum {TWO_STOP_BITS, ONE_STOP_BIT} stop_e;

class uart_transaction extends uvm_sequence_item;
  // Data and control fields
  rand bit [7:0] payload; //rxd or txData
  rand bit       start_bit;
  rand bit [1:0] stop_bits;

  // Receive
  bit rxDataReady;
  bit [7:0] rxData;

  // Transmit
  bit [7:0] txd;
  bit txDataRead;

  // Control
  rand kind_e   kind;
  rand stop_e   stop_type;
  rand int      delay;
  int           uart_id;

  // Utility and Field macros
  `uvm_object_utils_begin(uart_transaction)
    `uvm_field_enum(kind_e,kind, UVM_ALL_ON)
    `uvm_field_enum(stop_e,stop_type, UVM_ALL_ON)
    `uvm_field_int(delay, UVM_ALL_ON)
    `uvm_field_int(payload, UVM_ALL_ON)
    `uvm_field_int(start_bit, UVM_ALL_ON)
    `uvm_field_int(stop_bits, UVM_ALL_ON)
    `uvm_field_int(rxDataReady, UVM_ALL_ON)
    `uvm_field_int(rxData, UVM_ALL_ON)
    `uvm_field_int(txd, UVM_ALL_ON)
    `uvm_field_int(txDataRead, UVM_ALL_ON)
    `uvm_field_int(uart_id, UVM_ALL_ON)
  `uvm_object_utils_end

  // Constraints
  constraint c_delay       { delay >= 1; delay < 20; }
  constraint c_start_bit   { start_bit == 1'b0; }
  constraint c_stop_bits   { stop_bits == 2'b11; }
  constraint c_stop_bits_t { stop_type == ONE_STOP_BIT; }

  function new(string name = "");
    super.new(name);
  endfunction: new
endclass: uart_transaction

// Receive transaction
class uart_receive_transaction extends uart_transaction;
  `uvm_object_utils(uart_receive_transaction)

  function new(string name = "");
    super.new(name);
  endfunction: new

  constraint c_receive { kind == RECEIVE; }
endclass : uart_receive_transaction

// Tranmsit transaction
class uart_transmit_transaction extends uart_transaction;
  `uvm_object_utils(uart_transmit_transaction)

  function new(string name = "");
    super.new(name);
  endfunction: new

  constraint c_transmit { kind == TRANSMIT; }
endclass : uart_transmit_transaction

// Receive transaction with fixed delay
class uart_receive_delay_transaction extends uart_transaction;
  `uvm_object_utils(uart_receive_delay_transaction)

  function new(string name = "");
    super.new(name);
  endfunction: new

  constraint c_receive     { kind == RECEIVE; }
  constraint c_fixed_delay { delay == 1; }
endclass : uart_receive_delay_transaction

  // Receive sequence
class uart_sequence_receive extends uvm_sequence#(uart_receive_transaction);
  `uvm_object_utils(uart_sequence_receive)

  function new(string name = "uart_sequence_receive");
    super.new(name);
  endfunction: new

  task body();
    repeat(5) begin
      uart_receive_transaction rec_req = uart_receive_transaction::type_id::create("rec_req");
      start_item(rec_req);
     assert(rec_req.randomize());
      finish_item(rec_req);
    end
  endtask: body
endclass: uart_sequence_receive

  // Transmit sequence
class uart_sequence_transmit extends uvm_sequence#(uart_transmit_transaction);
  `uvm_object_utils(uart_sequence_transmit)

  function new(string name = "uart_sequence_transmit");
    super.new(name);
  endfunction: new

  task body();
    repeat(5) begin
      uart_transmit_transaction trans_req = uart_transmit_transaction::type_id::create("trans_req");
      start_item(trans_req);
     assert(trans_req.randomize());
      finish_item(trans_req);
    end
  endtask: body
endclass: uart_sequence_transmit

  // Receive sequence fixed delay
class uart_sequence_receive_fixed_delay extends uvm_sequence#(uart_receive_delay_transaction);
  `uvm_object_utils(uart_sequence_receive_fixed_delay)

  function new(string name = "uart_sequence_receive_fixed_delay");
    super.new(name);
  endfunction: new

  task body();
    repeat(5) begin
      uart_receive_delay_transaction rec_delay_req = uart_receive_delay_transaction::type_id::create("rec_delay_req");
      start_item(rec_delay_req);
      assert(rec_delay_req.randomize());
      finish_item(rec_delay_req);
    end
  endtask: body
endclass: uart_sequence_receive_fixed_delay

// UART sequencer
class uart_sequencer extends uvm_sequencer#(uart_transaction);
  `uvm_component_utils(uart_sequencer)

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
endclass