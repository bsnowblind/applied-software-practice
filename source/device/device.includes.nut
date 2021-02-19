/**
 * @file
 * @details     Device include content for Project S.O.C.K
 */

// Configuration Includes
@include "device.config.nut";

// // Preddio Imp-based Library Includes
// @include "../DataModel/DataModel.config.nut";
// @include "../PreddioImpLibrary/src/sfal/DataModel/DataModel.nut";

// Mock components for testing
@include "mock_tap.nut";
@include "mock_temperature_sensor.nut";

// Application-specific Includes
// @include "led_control.nut";
// @include "pulse_counter.nut";
// @include "flow_meter.nut";
// @include "pressure_monitor.nut"
@include "temperature_monitor.nut"
@include "device.main.nut";