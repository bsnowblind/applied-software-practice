/**
 * @file
 * @details     Davra interface to the Davra cloud instance
 */

local update_period = 0.01;             // Minimum of 10 milliseconds resolution
local node_sync_period = 10;  

local door_switch_node = DavraNode("is_door_open", update_period, node_sync_period);
// local internal_temperature_node = 
//     DavraNode("internal_temperature", update_period, node_sync_period);
// local gas_output_pressure_node = 
//     DavraNode("n2_output_pressure", update_period, node_sync_period);

function ServiceDavraInterface() {
    door_switch_node.ServiceNode();
}
