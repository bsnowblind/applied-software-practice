/**
 * @file
 * @details     Main executor on the agent side for Project S.O.C.K
 */

function Statemachine() {
    imp.wakeup(0.01, Statemachine);

    ServiceDavraInterface();
}

server.log("Starting agent-side process...");

imp.onidle(function() {
    Statemachine();
});

function CalculateVoltageFromAdcCounts(counts) {
    local adc_full_span = 3.3
    local adc_resolution_bits = 16;
    local adc_resolution = adc_full_span / math.pow(2, adc_resolution_bits);

    return (adc_resolution * counts);
}

function DataModelUpdated(dataPacket) {

    local index = dataPacket.rawget("index");
    local value = dataPacket.rawget("value");

    local retVal = false;
    local updatedData = {};

    if (index >= data_model_size) {
        throw "Index out of range...";
    }

    switch (index) {
        case data_model_elements.n2_output_pressure: {
            
            // Resolve a NULL value
            value = (value == null) ? 0 : value;

            // ADD COMMENTS
            local shunt_resistance = 330;
            local milliamps_per_amp = 1000;
            local current_offset = 4;
            local pressure_per_current = 6.25;
            value = CalculateVoltageFromAdcCounts(value);
            value /= shunt_resistance;
            value *= 1000;
            value -= 4;
            value *= 6.25;
            local message = format("[SetElement] Index: %d    Value: %f", index, value);
            server.log(message);
            data_model.SetElement(index, value, false);
            break;
        }

        case data_model_elements.is_door_open: {

            // Resolve a NULL value
            value = (value == null) ? 0 : value;
            local message = format("[SetElement] Index: %d    Value: %d", index, value);
            server.log(message);
            data_model.SetElement(index, value, false);
            break;
        }

        case data_model_config.elements.coffee_total_dispensed_volume: {
            
            // Resolve a NULL value
            value = (value == null) ? 0 : value;
            local message = format("[SetElement] Index: %d    Value: %d", index, value);
            server.log(message);
            data_model.SetElement(index, value, false);
            break;
        }

        case data_model_elements.internal_temperature: {
            
            // Resolve a NULL value
            value = (value == null) ? 0 : value;

            // ADD COMMENTS
            local divider_resistance = 5360;
            local divider_voltage = 12;
            local ohms_per_celsius = 3.9;
            local zero_celsius_resistance = 1000;
            value = CalculateVoltageFromAdcCounts(value);
            value = (divider_resistance * value) / (divider_voltage - value);
            value = (value - 1000) / ohms_per_celsius;
            local message = format("[SetElement] Index: %d    Value: %f", index, value);
            server.log(message);
            data_model.SetElement(index, value, false);
            break;
        }

        default: {
            throw "DataModelSync() received an unexpected index..."
        }
    }

    return retVal;
}
device.on("data-model-updated", DataModelUpdated);


