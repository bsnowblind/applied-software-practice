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

// Application-specific Includes
@include "led_control.nut";
@include "pulse_counter.nut";
@include "flow_meter.nut";
@include "device.main.nut";