/**
 * @file
 * @details     Door position monitoring functionality for Project S.O.C.K
 *
 * @note        Door position monitoring functionality use a magnetic Reed switch 
 *              to sense door position
 */

/**
 * Provides monitoring functionality for position of the door using a magnetic Reed switch           
 */
class DoorSwitch {
    /**
     * Reference to specified hardware pin for monitoring
     */
    signal_pin_ = null;

    /**
     * Constructs an instance of the class for future use
     *
     * @param   hardware_pin                Reference to a specified hardware pin for monitoring
     */
    constructor(hardware_pin = null) {
        if (hardware_pin == null) {
            throw "DoorSwitch() must be called with a non-null hardware pin object...";
        }
        signal_pin_ = hardware_pin;

        // Configure the hardware pin
        signal_pin_.configure(DIGITAL_IN_PULLUP, DoorSwitchEventHandler.bindenv(this));
    }

    /**
     * Handles a door position transition event
     */
    function DoorSwitchEventHandler() {
        // Update the data model
        data_model.SetElement(
            data_model_elements.is_door_open,
            signal_pin_.read());
    }
}
