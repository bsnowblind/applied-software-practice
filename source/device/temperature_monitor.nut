/**
 * @file
 * @details     Internal temperature monitoring functionality for Project S.O.C.K
 *
 * @note        The internal temperature monitoring functionality uses an RTD circuit to measure
 *              measure the internal temperature of the kegerator
 */

/**
 * Provides monitoring functionality for the temperature sensor using an analog signal 
 * from an RTD circuit           
 */
class TemperatureMonitor {
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
            throw "TemperatureMonitor() must be called with a non-null hardware pin object...";
        }
        signal_pin_ = hardware_pin;

        // Configure the hardware pin
        signal_pin_.configure(ANALOG_IN);
    }

    /**
     * Gets a reading from the analog input
     *
     * @return  Raw analog input value
     */
    function GetReading() {
        return signal_pin_.pin.read()
    }
}
