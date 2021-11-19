
ps:
	iverilog -g2012 -o pixelSensor -c pixelSensor.fl
	vvp -n pixelSensor

psfsm:
	iverilog -g2012 -o pixelSensorFsm -c pixelSensorFsm.fl
	vvp -n pixelSensorFsm


ysfsm:
	yosys pixelSensorFsm.ys
	dot pixelSensorFsm.dot -Tpng > pixelSensorFsm.png

pa:
	@iverilog -g2012 -o pixelArray -c pixelArray.fl
	@vvp -n pixelArray

pt:
	@iverilog -g2012 -o pixelTop -c pixelTop.fl
	@vvp -n pixelTop

simpa:
	@gtkwave pixelArray_tb.vcd

simpt:
	@gtkwave pixelTop_tb.vcd
