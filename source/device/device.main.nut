/**
 * @file
 * @details     Main executor on the device side for Project S.O.C.K
 */

// Instantiate necessary objects
local pulse_counter = PulseCounter(hardware.pinXH);
local flow_meter = FlowMeter(pulse_counter, 0.1, 1);
local pressure_monitor = PressureMonitor(10, hardware.pinV);
local temperature_monitor = TemperatureMonitor(10, hardware.pinXD);
local door_switch = DoorSwitch(hardware.pinXT);

function SmartKegeratorStateMachine() {
    imp.wakeup(device_config.system_tick_period, SmartKegeratorStateMachine);
}

imp.onidle(function() {
    server.log("Starting the device-side application...");
    SmartKegeratorStateMachine();
});