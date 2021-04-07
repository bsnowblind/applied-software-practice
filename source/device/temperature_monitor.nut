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
     * Measurement refresh rate, in seconds
     */
    refresh_rate_ = null;

    /**
     * Constructs an instance of the class for future use
     *
     * @param   refresh_rate                Period between counter capture events, in seconds
     * @param   hardware_pin                Reference to a specified hardware pin for monitoring
     */
    constructor(refresh_rate, hardware_pin = null) {
        if (hardware_pin == null) {
            throw "TemperatureMonitor() must be called with a non-null hardware pin object...";
        }
        signal_pin_ = hardware_pin;
        refresh_rate_ = refresh_rate;

        // Configure the hardware pin
        signal_pin_.configure(ANALOG_IN);

        // Initialize the wakeup timer
        imp.wakeup(refresh_rate_, CaptureMeasurement_.bindenv(this));
    }

    /**
     * Captures a temperature measurement
     */
    function CaptureMeasurement_() {
        // Reset the wakeup timer
        imp.wakeup(refresh_rate_, CaptureMeasurement_.bindenv(this));

        // Update the data model
        data_model.SetElement(
            data_model_elements.internal_temperature,
            GetReading_());
    }

    /**
     * Gets a reading from the analog input
     *
     * @return  Raw analog input value
     */
    function GetReading_() {
        return signal_pin_.read()
    }
}
