vlib work
vlog synchronizer.sv wptr_handler.sv rptr_handler.sv fifo_mem.sv asynchronous_fifo.sv +acc
vlog top.sv +acc
vopt testbench -o top_optimized  +acc +cover=sbfec+asynchronous_fifo(rtl).
vsim top_optimized -coverage 
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
add wave -r *
run -all
coverage save cov.ucdb
vcover report cov.ucdb 
vcover report cov.ucdb -cvg -details
coverage report -assert -binrhs -details -cvg
quit

