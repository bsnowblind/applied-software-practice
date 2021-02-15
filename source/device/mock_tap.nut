/**
 * @file
 * @details     Provides functionality to simulate the actuation of a tap on the kegerator 
 */

// Hardware pins
local tap_switch_pin = hardware.pinB;
local flow_pulse_pin = hardware.pinJ;

// Flag indicating module configuration state
local is_mock_tap_configured = false;

/**
 * Monitors the mock tap switch to enable or disable simulated flow pulses
 */
function ServiceMockTap() {
    if (!is_mock_tap_configured) {
        ConfigureMockTap();
        is_mock_tap_configured = true;
    }

    if (tap_switch_pin.read()) {
        flow_pulse_pin.write(0.5);
    } else {
        flow_pulse_pin.write(0);
    }
}

/**
 * Configures the hardware utilized by the mock tap functionality
 */
function ConfigureMockTap() {
    flow_pulse_pin.configure(PWM_OUT, 1, 0);
    tap_switch_pin.configure(DIGITAL_IN_PULLUP);
}
