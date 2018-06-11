//====================================================================
// Created       : Karianne Krokan Kragseth at 2018-03-07
//====================================================================

typedef enum {READ, WRITE} inst_t;

class par_transaction extends uvm_sequence_item;
  // Data and control fields
  rand inst_t     inst;
  //in
  rand bit [31:0] parDo;
  rand bit [11:0] parAddr;
  rand bit [3:0]  parWe;
  rand bit        parRe;
  //out
  bit [31:0]      parDi;

  // Utility and Field macros
  `uvm_object_utils_begin(par_transaction)
    `uvm_field_enum(inst_t,inst, UVM_ALL_ON)
    `uvm_field_int(parDo, UVM_ALL_ON)
    `uvm_field_int(parAddr, UVM_ALL_ON)
    `uvm_field_int(parWe, UVM_ALL_ON)
    `uvm_field_int(parRe, UVM_ALL_ON)
    `uvm_field_int(parDi, UVM_ALL_ON)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "");
    super.new(name);
  endfunction: new

  // Constaints
  constraint C_read  { inst==READ -> parRe; inst==READ -> parWe==4'h0;};
  constraint C_write { inst==WRITE -> parWe==4'hF; inst==WRITE -> parRe==1'b0;};
endclass: par_transaction

// Read sequence
class par_sequence_read extends uvm_sequence#(par_transaction);
  `uvm_object_utils(par_sequence_read)

  rand bit [11:0] addr;

  function new(string name = "", bit [11:0] addr = '0);
    super.new(name);
    this.addr = addr;
  endfunction: new

  task body();
    `uvm_do_with(req, {req.inst==READ; req.parAddr==addr;})
  endtask: body
endclass: par_sequence_read

// Write sequence
class par_sequence_write extends uvm_sequence#(par_transaction);
  `uvm_object_utils(par_sequence_write)

  rand bit [11:0] addr;
  rand bit [31:0] data;

  par_transaction req;

  function new(string name = "", bit [11:0] addr = '0, bit [31:0] data = '0);
    super.new(name);
    this.addr = addr;
    this.data = data;
  endfunction: new

  task body();
    `uvm_do_with(req, {req.inst==WRITE; req.parAddr==addr; req.parDo==data;})
  endtask: body
endclass: par_sequence_write

// Write sequence followed by read sequence
class par_sequence_write_read extends uvm_sequence#(par_transaction);
  `uvm_object_utils(par_sequence_write_read)

  rand bit [11:0] addr;
  rand bit [31:0] data;

  function new(string name = "", bit [11:0] addr = '0, bit [31:0] data = '0);
    super.new(name);
    this.addr = addr;
    this.data = data;
  endfunction: new

  par_sequence_write write_seq;
  par_sequence_read  read_seq;

  task body();
    `uvm_do_with(write_seq, {write_seq.addr==addr; write_seq.data==data;})
    `uvm_do_with(read_seq, {read_seq.addr==addr;})
  endtask: body
endclass: par_sequence_write_read

// PAR Sequencer
class par_sequencer extends uvm_sequencer#(par_transaction);
  `uvm_component_utils(par_sequencer)

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
endclass