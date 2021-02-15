/**
 * @file
 * @details     Device configuration content for Project S.O.C.K
 */

// High-level macro to define model as a 'DEVICE'
@set ENVIRONMENT = "DEVICE";

// System configuration table with respect to the device side module
/*
 * NOTE:
 *  - All period values are in seconds, unless otherwise noted
 */

local device_config = {
    "system_tick_period": 0.01,                
    "indicator_control": {
    },
    "enclosure_monitor": {
    },
    "temperature_monitor": {
        "sample_rate": 10                     
    }
}