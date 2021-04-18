/**
 * @file
 * @details     Liquid dispense monitoring functionality for Project S.O.C.K
 *
 * @note        The liquid dispense monitoring functionality for the flow of liquid using   
 *              a discrete signal flow meter (pulse counting) 
 */

/**
 * Provides monitoring functionality for the flow of liquid using a discrete signal 
 * flow meter (pulse counting)            
 */
class FlowMeter {
    /**
     * Reference to a discrete signal flow meter
     */
    flow_meter_ = null;

    /**
     * Last recorded pulse count
     */
    last_pulse_count_ = null;

    /**
     * Count capture (monitoring) period, in seconds
     */
    monitor_period_ = null;

    /**
     * Dispense timeout (transition to idle) period count
     *
     * @note    Count is the resulting quotient of the idle period and monitor period as provided
     *          in the class constructor 
     */
    idle_period_count_ = null;

    /**
     * Idle counts remaining countdown counter
     */
    idle_count_remaining_ = null;

    /**
     * Flag indicating that liquid is flowing and object is active
     */
    is_liquid_flowing_ = null;

    /**
     * Flag indicating that liquid is not flowing and object is idle
     */
    is_idle_ = null;

    /**
     * Constructs an instance of the class for future use
     *
     * @param   pulse_counter               Reference to a pulse counter
     * @param   monitor_period              Period between counter capture events, in seconds
     * @param   idle_period                 Period after which the flow of liquid has stopped
     *                                      and the dispense is considered complete, in seconds
     */
    constructor(pulse_counter, monitor_period, idle_period) {
        if (pulse_counter == null) {
            throw "FlowMeter() must be called with a non-null pulse_counter object...";
        } else if(monitor_period <= 0) {
            throw "FlowMeter() must be called with a monitor period greater than zero...";
        } else if(idle_period <= 0) {
            throw "FlowMeter() must be called with an idle period greater than zero...";
        }

        flow_meter_ = pulse_counter;
        last_pulse_count_ = 0;
        monitor_period_ = monitor_period;
        idle_period_count_ = ((idle_period / monitor_period) + 0.5).tointeger();
        idle_count_remaining_ = idle_period_count_;
        is_liquid_flowing_ = false;
        is_idle_ = true;
        imp.wakeup(monitor_period_, CheckForLiquidFlowing_.bindenv(this));
    }

    /**
     * Evaluates whether the dispense is considered complete
     *
     * @return  TRUE is the object is idle, otherwise FALSE
     */
    function IsDispenseComplete_() {
        return is_idle_;
    }

    /**
     * Evaluates whether liquid is flowing and updates the associated flags
     */
    function CheckForLiquidFlowing_() {
        // Reset the wakeup timer
        imp.wakeup(monitor_period_, CheckForLiquidFlowing_.bindenv(this));
        local pulse_count = flow_meter_.GetCountNoReset_();

        if (pulse_count > last_pulse_count_) {
            if (is_idle_) {
                server.log("Dispense started...");
            }

            last_pulse_count_ = pulse_count;
            idle_count_remaining_ = idle_period_count_;
            is_liquid_flowing_ = true;
            is_idle_ = false;

        } else if (!is_idle_) {
            idle_count_remaining_ -= 1;
        }

        if (idle_count_remaining_ == 0) {
            if (!is_idle_) {
                local count_per_liter = 2956.0;
                local last_dispensed_volume = last_pulse_count_ / count_per_liter;
                server.log("Dispense completed...");
                local message = format("Last dispensed volume: %d...", last_dispensed_volume);
                server.log(message);

                // Update the data model
                data_model.SetElement(
                    data_model_config.elements.coffee_last_dispensed_volume,
                    last_dispensed_volume);
            }

            is_liquid_flowing_ = false;
            is_idle_ = true;
        }
    }
} 
