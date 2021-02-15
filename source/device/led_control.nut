/**
 * @file
 * @details     Led control functionality for Project S.O.C.K
 */

// Constants, enumeration, and configuration content
enum LedState {
    kOff = 0,
    kOn = 1
};

enum LedColor {
    kRed,
    kGreen,
    kBlue
};

local red_led_pin = hardware.pinR;   
red_led_pin.configure(DIGITAL_OUT, LedState.kOff);
local green_led_pin = hardware.pinXA;
green_led_pin.configure(DIGITAL_OUT, LedState.kOff);
local blue_led_pin = hardware.pinXB; 
blue_led_pin.configure(DIGITAL_OUT, LedState.kOff); 

local leds = {
    "red": {
        "pin": red_led_pin,
        "state": LedState.kOff,
        "toggle_period": 0.5,
        "count": 0
    },
    "green": {
        "pin": green_led_pin,
        "state": LedState.kOff,
        "toggle_period": 0.5,
        "count": 0
    },
    "blue": {
        "pin": blue_led_pin,
        "state": LedState.kOff,
        "toggle_period": 0.5,
        "count": 0
    }
};

/**
 * Toggles an LED at a defined rate
 *
 * @param   color                           LED color of interest represented by the LedColor
 *                                          enumeration
 */
function ToggleLed(color) {
    // Evaluate which LED to service
    local led = {};
    switch (color) {
        case LedColor.kRed: {
            led = leds.red;
            break;
        };

        case LedColor.kGreen: {
            led = leds.green;
            break;
        };

        case LedColor.kBlue: {
            led = leds.blue;
            break;
        };
    }

    // Evaluate whether a state change is required
    if (led.count == 0) {
        if (led.state == LedState.kOff)
        {
            led.state = LedState.kOn;
        } else {
            led.state = LedState.kOff;
        }

        // Update the state change count-down variable
        led.count = (led.toggle_period / device_config.system_tick_period).tointeger();
        led.count = (led.count == 0) ? 1 : led.count;
    } else {
        led.count--;
    }
    led.pin.write(led.state);
}


