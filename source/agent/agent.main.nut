/**
 * @file
 * @details     Main executor on the agent side for Project S.O.C.K
 */

function Statemachine() {
    imp.wakeup(0.01, Statemachine);

    // ServiceDavraInterface();
}

server.log("Starting agent-side process...");
// totalDispensedCount <- 0;
// persistentDataTable <- server.load();
// if (persistentDataTable.len() != 0) {
//     totalDispensedCount = persistentDataTable.rawget("totalDispensedCount");
// } else {
//     persistentDataTable.rawset("totalDispensedCount", totalDispensedCount);
// }
// local message = format("Total dispensed count initialized to %d...", totalDispensedCount);
// server.log(message);
// deviceDataModel <- DataModelSentry(DataModelKeys.numberOfKeys, 1.0);

imp.onidle(function() {
    Statemachine();
});

function DataModelUpdated(dataPacket) {

    local index = dataPacket.rawget("index");
    local value = dataPacket.rawget("value");

    // switch (index) {
    //     case DataModelKeys.volumeDispensed: {
    //         value = (value == null) ? 0 : value;
    //         local message = format("Element %d has been updated to %d...", index, value);
    //         server.log(message);
    //         deviceDataModel.SetElement(index, value, false);
    //         break;
    //     }

    //     default: {
    //         server.log("DataModelUpdated() received unexpected index...");
    //     }
    // }
    local retVal = false;
    local updatedData = {};

    if (index >= data_model_size) {
        throw "Index out of range...";
    }

    switch (index) {
        case data_model_elements.n2_output_pressure: {
            value = (value == null) ? 0 : value;
            value /= 65535.0;       // Get Voltage
            value /= 100;           // Get Current in Amps
            value *= 1000;          // Convert current to milliAmps
            value -= 4;             // Adjust current to 4-20mA range
            value *= 6.25;          // Convert current to pressure reading
            local message = format("[SetElement] Index: %d    Value: %f", index, value);
            server.log(message);
            data_model.SetElement(index, value, false);
            break;
        }

        case data_model_elements.is_door_open: {
            value = (value == null) ? 0 : value;
            local message = format("[SetElement] Index: %d    Value: %d", index, value);
            server.log(message);
            data_model.SetElement(index, value, false);
            break;
        }

        case data_model_config.elements.coffee_total_dispensed_volume: {
            value = (value == null) ? 0 : value;
            local message = format("[SetElement] Index: %d    Value: %d", index, value);
            server.log(message);
            data_model.SetElement(index, value, false);
            break;
        }

        case data_model_elements.internal_temperature: {
            value = (value == null) ? 0 : value;
            local message = format("[SetElement] Index: %d    Value: %d", index, value);
            server.log(message);
            data_model.SetElement(index, value, false);
            break;
        }
           

        // case DataModelKeys.volumeDispensed: {
        //     local url = "https://preddiodev.davra.com/api/v1/iotdata";
        //     // local url = "https://preddiodev.davra.com/user";
        //     local extraHeaders = {};
        //     extraHeaders.rawset("Authorization", "Bearer NhkLGQat4bQ1U5mtQteNt57xF19XFLS2dR8JL6EqnuBSDHFQ");
        //     extraHeaders.rawset("content-type", "application/json");

        //     // local value = dataModel.GetElement(index);
            
        //     if (value == null) break;

        //     totalDispensedCount += value;
        //     persistentDataTable.rawset("totalDispensedCount", totalDispensedCount);
        //     server.save(persistentDataTable);
            
        //     local message = format("Element %d has been updated to %d...", index, totalDispensedCount);
        //     server.log(message);
        //     deviceDataModel.SetElement(index, value, false);


        //     local body = http.jsonencode({
        //         "UUID": "988e0513-9e89-4568-8290-877a140b2278",
        //         "msg_type": "datum",
        //         "name": "metric.station.1.flow",
        //         "value": (totalDispensedCount.tofloat() / 4021.0)});

        //     local request = http.put(url, extraHeaders, body);

        //     local response = request.sendsync();
        //     if (response.statuscode == 200) {
        //         server.log("Sent message to Davra successfully...")
        //         retVal = true;
        //     }
        //     break;
        // }

        default: {
            throw "DataModelSync() received an unexpected index..."
        }
    }

    return retVal;
}
device.on("data-model-updated", DataModelUpdated);


