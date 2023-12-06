# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
set_msg_config -id {Common 17-41} -limit 10000000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/sources_1/new/PmodJSTK.v}
  {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/sources_1/new/SPImode0.v}
  {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/sources_1/new/VGAdriver.v}
  {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/sources_1/new/clk5Hz.v}
  {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/sources_1/new/clk66kHZ.v}
  {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/sources_1/new/debouncer.v}
  {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/sources_1/new/pixelGenerator.v}
  {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/sources_1/new/scorecounter.v}
  {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/sources_1/new/sevenSeg.v}
  {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/sources_1/new/spiCtrl.v}
  {C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/sources_1/new/top.v}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/constrs_1/new/pong_project.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Benji/BENJI SCHOOL/UCLA UNDERGRAD/116L/Final Project/CSM152A_Lab4/final_project/final_project.srcs/constrs_1/new/pong_project.xdc}}]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top top -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
