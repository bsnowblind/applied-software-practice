/**
 * @file
 * @details     Main executor on the device side for Project S.O.C.K
 */

// Instantiate necessary objects
local pulse_counter = PulseCounter(hardware.pinXM);
local flow_meter = FlowMeter(pulse_counter, 0.1, 1);

function SmartKegeratorStateMachine() {
    imp.wakeup(device_config.system_tick_period, SmartKegeratorStateMachine);

    ServiceMockTap();
}

imp.onidle(function() {
    server.log("Starting the device-side application...");
    SmartKegeratorStateMachine();
});