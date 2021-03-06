/**
 * @file
 * @details     Device include content for Project S.O.C.K
 */

// Configuration Includes
@include "device.config.nut";

// Application-specific Includes
@include "../data_model/data_model.config.nut";
@include "../data_model/data_model.nut";
@include "led_control.nut";
@include "pulse_counter.nut";
@include "flow_meter.nut";
@include "pressure_monitor.nut";
@include "temperature_monitor.nut";
@include "door_switch.nut";
@include "device.main.nut";