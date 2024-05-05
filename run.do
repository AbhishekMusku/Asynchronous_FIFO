vlib work
vlog synchronizer.sv wptr_handler.sv rptr_handler.sv fifo_mem.sv asynchronous_fifo.sv +acc
vlog top.sv +acc
vopt testbench -o top_optimized  +acc
vsim top_optimized 
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
add wave -r *
run -all
quit

