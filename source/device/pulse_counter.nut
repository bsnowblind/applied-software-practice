/**
 * @file
 * @details     Pulse counter functionality for Project S.O.C.K
 *
 * @note        The pulse counter functionality for the counting pulses propogated 
 *              on a specified hardware pin using   
 */

/**
 * Pulse transition polarity definition enumeration
 */
enum PulseTransitionPolarity {
    kFalling = 0,
    kRising = 1
};

/**
 * Provides pulse counting functionality on a specified hardware pin                  
 */
class PulseCounter {
    /**
     * Reference to specified hardware pin for monitoring
     */
    signal_pin_ = null;

    /**
     * Signal transition polarity of interest
     */
    transition_polarity_ = null;

    /** 
     * Current pulse count
     */
    count_ = null;

    /**
     * Flag indicating that the count value has overflowed
     */
    count_overflow_ = null;

    /**
     * Constructs an instance of the class for future use
     *
     * @param   hardware_pin                Reference to a specified hardware pin for monitoring
     * @param   transition_direction        Signal transition direction (polarity) of interest
     */
    constructor(hardware_pin = null, transition_direction = PulseTransitionPolarity.kFalling) {
        if (hardware_pin == null) {
            throw "PulseCounter() must be called with a non-null hardware pin object...";
        }
        signal_pin_ = hardware_pin;
        transition_polarity_ = transition_direction;
        count_ = 0;
        count_overflow_ = false;

        // Configure the hardware pin
        signal_pin_.configure(DIGITAL_IN, SignalTransitionEvent_.bindenv(this));
    }

    /**
     * Resets the current pulse count value and clears the count overflow flag
     */
    function ResetCount_() {
        count_ = 0;
        count_overflow_ = false;
    }

    /**
     * Gets the current pulse count, resets the pulse count to zero, and clears the count
     * overflow flag
     *
     * @return  Current pulse count
     */
    function GetCount_() {
        local temp = count_;
        count_ = 0;
        count_overflow_ = false;
        return temp;
    }

    /**
     * Returns the current pulse count without resetting the pulse count to zero or clearing 
     * the count overflow flag
     *
     * @return  Current pulse count
     */
    function GetCountNoReset_() {
        return count_;
    }

    /**
     * Event handler for a signal transition
     */
    function SignalTransitionEvent_() {
        if (signal_pin_.read() == transition_polarity_) {
            count_ += 1;

            // Monitor for an overflow event
            if (count_ < 0) {
                count_ = 0;
                count_overflow_ = true;
            }
        }  
    }
}
