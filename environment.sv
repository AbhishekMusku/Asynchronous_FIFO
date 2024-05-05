class env;
 
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  mailbox #(transaction) gdmbx;  // Generator + Driver mailbox
  mailbox #(transaction) msmbx;  // Monitor + Scoreboard mailbox
  virtual fifo_inf fifo;
  event nextgs;

  
function new(virtual fifo_inf fifo);
    gdmbx = new();
    gen = new(gdmbx);
    drv = new(gdmbx);
    msmbx = new();
    mon = new(msmbx);
    sco = new(msmbx);
    this.fifo = fifo;
    drv.fifo = this.fifo;
    mon.fifo = this.fifo;
	gen.sconext = nextgs;
    sco.sconext = nextgs;
  endfunction  
  
task pre_test();
    drv.initialize();
endtask
  
task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_any
endtask  

  task post_test(); 
    wait(gen.done.triggered);  
    $display("---------------------------------------------");
    //$display("Error Count :%0d", sco.err);
    $display("---------------------------------------------");  
    $finish();
  endtask
  
  
task run();
    pre_test();
    test();
    post_test();
endtask
endclass

