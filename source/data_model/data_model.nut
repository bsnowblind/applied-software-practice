/**
 * @file
 * @details     Data model functionality for Agent-Device data model interactions 
 *              for Project S.O.C.K
 */

/** 
 * Data Model class implementation for a Singleton design instance in Squirrel
 */
local DataModelInstance = {

    /**
     * Flag to indicate instance initialization status
     */
    initialized_ = false,

    /**
     * Internal data model array
     */
    array_ = null,

    /** 
     * Array of flags to indicate an element value needs to be sync across the 
     * agent-device interface
     */
    needs_to_be_synced_ = null,

    /**
     * Period between element synchronization events, in seconds
     */
    sync_period_ = null,

    /**
     * Flag indicating the previous sync process did not finish before the next process
     * was initiated to begin
     */
    sync_overrun_ = false,

    /**
     * Indicates the initialization status of the instance
     *
     * @return  Returns the initialization status of the instance
     */
    IsInitialized = function() {
        return initialized_;
    },

    /**
     * Initializes the instance of the class for future use
     */
    Initialize = function() {
        if (!initialized_) {
            array_ = array(data_model_size);
            needs_to_be_synced_ = array(data_model_size);
            sync_period_ = data_model_config.sync_period;
            initialized_ = true;

            // Initiate the synchronization timer
            imp.wakeup(sync_period_, EvaluateDataModel.bindenv(this));
        }
    },

    /**
     * Sets the value of a specific data model element
     *
     * @param   index                       Index of the data model element of interest
     * @param   value                       Value to be stored in the data model element
     * @param   to_be_synced                Flag indicating that value needs to be synced 
     *                                      across agent-device interface
     */
    SetElement = function(index, value, to_be_synced = true) {
        local array_length = array_.len();
        if (index >= array_length) {
            throw "Index out of range...";
        } else if ((typeof(array_[index]) != typeof(value)) && 
                (typeof(array_[index]) != "null")) {
            throw "Data element type mismatch...";
        }

        array_[index] = value;
        needs_to_be_synced_[index] = to_be_synced;
    },

    /**
     * Gets the value of a specific data model element
     *
     * @param   index                       Index of the data model element of interest
     * 
     * @return  The value stored in the data model element
     */
    GetElement = function(index) {
        local array_length = array_.len();
        if (index >= array_length) {
            throw "Index out of range...";
        }

        return array_[index];
    },

    /**
     * Updates a data model element from a data model sync update request
     *
     * @param   index                       Index of the data model element of interest
     * @param   value                       Value to be stored in the data model element
     */
    UpdateElement = function(index, value) {
        SetElement(index, value, false);
    },

    /**
     * Updates the data model with data received from the corresponding module
     *
     * @param   element_update_packet           Table containing updated data elements
     */
    UpdateDataModel = function(element_update_packet) {
        local index = element_update_packet.rawget("index");
        if (index == null) {
            server.error("Error attempting to retrieve index from update...")
        }

        local value = element_update_packet.rawget("value");
        if (value == null) {
            server.error("Error attempting to retrieve value from update...")
        }
        UpdateElement(index, value);
    },

    /**
     * Evaluates the data model for internal changes
     */
    EvaluateDataModel = function() {
        imp.wakeup(sync_period_, EvaluateDataModel.bindenv(this));

        // Determine type of imp implementing class (agent or device)
        local imp_type = imp.environment();
        if (imp_type == ENVIRONMENT_CARD) {
            server.error("Imp type not supported by the DataModel() class...");
            return;
        }

        // Check for a sychronization duration overrun event
        if (sync_overrun_) {
            server.log("Datamodel synchronization duration overrun occurred...");
            return;
        }
        else {
            sync_overrun_ = true;
        }
        
        // Parse the data model table for elements to be synced
        foreach (index, data in array_) {
            if (needs_to_be_synced_[index]) {
                local element_update_packet = {};
                element_update_packet.rawset("index", index);
                element_update_packet.rawset("value", GetElement(index));

                if (imp_type == ENVIRONMENT_MODULE) {
                   if (agent.send("data-model-updated", element_update_packet) == 0) {
                        needs_to_be_synced_[index] = false;
                    }
                } else if (imp_type == ENVIRONMENT_AGENT) {
                   if (device.send("data-model-updated", element_update_packet) == 0) {
                        needs_to_be_synced_[index] = false;
                    } 
                }
            }
        }
        sync_overrun_ = false;
    },
}

/**
 * Class definition for the data model interface between a single instance of an Electric Imp
 * device and agent module                  
 */
class DataModel {
    /**
     * Library version
     */
    static VERSION = "1.0.0";

    /**
     * Gets a reference to the data model instance
     *
     * @note    This method is intended to create a "Singleton-like" instance
     */
    function GetInstance() {
        if (data_model_size == 0) {
            server.error("DataModel() requires a minimum of one element...");
            server.error("DataModel() failed to instantiate...");
            return;
        }
        else if (data_model_config.sync_period == 0) {
            server.error("DataModel() requires a sync period greater than zero...");
            server.error("DataModel() failed to instantiate...");
            return;
        }
        else if (!DataModelInstance.IsInitialized()) {
            DataModelInstance.Initialize();
        }
        return DataModelInstance;
    }
}

/*
 * Create a global instance of the data model
 */
local data_model_instance = DataModel();
local data_model = data_model_instance.GetInstance();

// Pre-build conditionals  
@ Evaluate for the presence of a ENVIRONMENT variable
@if ENVIRONMENT == "AGENT"
device.on("data-model-update", function (element_update_packet) {
    data_model.UpdateDataModel(element_update_packet);
});
@elseif ENVIRONMENT == "DEVICE"
agent.on("data-model-update", function (element_update_packet) {
    data_model.UpdateDataModel(element_update_packet);
});
@else
@error "DataModel() requires a ENVIRONMENT variable to be included..."
@endif
