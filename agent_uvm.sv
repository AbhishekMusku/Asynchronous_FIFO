
class agent extends uvm_agent;
	`uvm_component_utils(agent)

	driver drv;
	monitor mon;
	sequencer sqr;

	function new(string path = "agent", uvm_component parent);
		super.new(path,parent);
		`uvm_info("AGENT_CLASS", "Inside Constructor!", UVM_NONE);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("AGENT_CLASS", "Build Phase!", UVM_NONE);

		sqr = sequencer::type_id::create("sqr",this);
		drv = driver::type_id::create("drv",this);
		mon = monitor::type_id::create("mon",this);

	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("AGENT_CLASS", "Connect Phase!", UVM_NONE);

		drv.seq_item_port.connect(sqr.seq_item_export);

	endfunction
	
endclass
