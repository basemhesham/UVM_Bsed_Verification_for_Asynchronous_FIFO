vlib work
vlog -f src_files_list.txt +cover -covercells
vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all
add wave /top/intf1/*
add wave -position insertpoint sim:/top/Async_fifo_TEST/u_fifo_mem/w_addr
add wave -position insertpoint sim:/top/Async_fifo_TEST/u_fifo_mem/r_addr
add wave -position insertpoint sim:/top/Async_fifo_TEST/u_fifo_mem/FIFO_MEM
add wave -position insertpoint sim:/top/Async_fifo_TEST/u_fifo_wr/w_ptr
add wave -position insertpoint sim:/top/Async_fifo_TEST/u_fifo_rd/rd_ptr
add wave -position insertpoint sim:/top/Async_fifo_TEST/u_fifo_wr/gray_w_ptr

coverage save top.ucdb -onexit
run -all
vcover report top.ucdb -details -all -output coverage.txt
