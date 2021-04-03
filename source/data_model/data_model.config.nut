/**
 * @file
 * @details     Data model configuration content for for Project S.O.C.K
 */

local data_model_config = {
    "sync_period" : 1, 
    "elements": {
        "n2_output_pressure": 0,
        "coffee_total_dispensed_volume": 1,
        "is_door_open": 2,
        "internal_temperature": 3
    },
    "metrics" : {
        "n2_output_pressure": "metric.tank.1.output.pressure",
        "coffee_total_dispensed_volume": "metric.station.1.flow.total",
        "is_door_open": "event.contact",
        "internal_temperature": "metric.ambient.temperature"
    }
};

local data_model_size = data_model_config.elements.len();
local data_model_elements = data_model_config.elements;
local data_model_metrics = data_model_config.metrics;
