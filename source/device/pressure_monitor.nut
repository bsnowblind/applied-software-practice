/**
 * @file
 * @details     Gas output pressure monitoring functionality for Project S.O.C.K
 *
 * @note        The gas output pressure monitoring functionality uses a 4-20 milli-amphere
 *              current loop analog sensor to measure the pressure of the gas output
 *              of the kegerator
 */

/**
 * Provides monitoring functionality for the pressure sensor using an analog signal 
 * from a pressure transducer            
 */
class PressureMonitor {
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
            throw "PressureMonitor() must be called with a non-null hardware pin object...";
        }
        signal_pin_ = hardware_pin;
        refresh_rate_ = refresh_rate;

        // Configure the hardware pin
        signal_pin_.configure(ANALOG_IN);

        // Initialize the wakeup timer
        imp.wakeup(refresh_rate_, CaptureMeasurement_.bindenv(this));
    }

    /**
     * Captures a pressure measurement
     */
    function CaptureMeasurement_() {
        // Reset the wakeup timer
        imp.wakeup(refresh_rate_, CaptureMeasurement_.bindenv(this));

        // Update the data model
        data_model.SetElement(
            data_model_elements.n2_output_pressure,
            GetReading_.bindenv(this));
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
