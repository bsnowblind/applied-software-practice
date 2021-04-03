/**
 * @file
 * @details     Davra node class for interfacing to the Davra cloud instance
 */

/**
 * Davra node class for interfacing to the Davra cloud instance
 */
class DavraNode {
    /**
     * Instantiations of the Davra Server class
     */
    static davra_if = DavraServer(
        "https://preddiodev.davra.com/microservices/services/device/iotdata",
        // "nWNqTti4nG4JRnFWiQzEQKj9cUetwlqAeP2lNwco5zNGqbxF"
        "IfXOx0S7rHetr2aZp4Fp7eRtdCAhRAom4VrCcgCB2rzG9QnQ"
    );

    /**
     * Data model element name represented as a string
     */
    element_name_ = "";

    /**
     * Period between update calls of calling method, in seconds
     */
    update_period_ = null;

    /**
     * Period between synchronization attempts, in seconds
     */
    sync_period_ = null;

    /**
     * Number of update events between synchronization attempts
     */
    sync_count_ = null;

    /**
     * Last value transferred through the interface
     */
    last_value = null;

    /**
     * Constructs an instance of the class for future use
     *
     * @param   element_name                    Data model element name represented as a string
     * @param   update_period                   Period between synchronization attempts 
     *                                          of calling method, in seconds
     * @param   sync_period                     Period between synchronization attempts, in seconds
     *                                          with a minimum of 10 millisecond resolution    
     */
    constructor(element_name, update_period, sync_period) {
        element_name_ = element_name;
        update_period_ = update_period
        sync_period_ = sync_period;
        sync_count_ = 0;
    }

    /**
     * Service the system node with respect to the Davra cloud instance
     */
    function ServiceNode() {
        local new_value = data_model.GetElement(data_model_elements[element_name_]);
        local value_change = false;

        if (sync_count_ == 0) {
            server.log("Entering ServiceNode()...");
            local message = format("[ServiceNode] Index:%d    Value:%d", data_model_elements[element_name_], (new_value == null) ? 0 : new_value);
            server.log(message);

            // Evaluate last value against new value to determine if the value changed since
            // the last evaluation
            if (last_value != new_value) {
                last_value = new_value;
                value_change = true;
            }

            // Update the Davra interface with the new value
            if (value_change) {
                if (data_model_metrics[element_name_].find("event.") != null) {
                    davra_if.SendEvent(data_model_metrics[element_name_], new_value);
                } else {
                    davra_if.SendData(data_model_metrics[element_name_], new_value);
                }
                local message = format("[DAVRA] Key: \'%s\' updated...", element_name_)
                server.log(message);
            }

            sync_count_ = (sync_period_ / update_period_).tointeger();
            sync_count_ = (sync_count_ == 0) ? 1 : sync_count_;
        } else {
            sync_count_--;
        }
    }
}
