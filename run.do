vlib work
vdel -all
vlib work
vlog fifo1.sv fifomem.sv sync_r2w.sv sync_w2r.sv rptr_empty.sv wptr_full.sv +acc
vlog tb.sv
vsim work.tb +acc
#vsim -coverage tb -voptargs="+cover=bcesfx"
add wave -r *
run -all


