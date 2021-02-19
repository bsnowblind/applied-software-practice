/**
 * @file
 * @details     Provides functionality to simulate an RTD temperature sensor output 
 *
 * @note        Sample code (modified) provided by Electric Imp
 *              https://gist.github.com/ElectricImpSampleCode/b0cecf7571c428719a84f91289fac96f
 */

// Hardware pins
local sensor_output = hardware.pinXC;

// DEVICE CODE
// Define the buffer-processing function
function bufferEmpty(buffer) {
//   server.log("bufferEmpty() called");

  if (!buffer) {
    // server.log("Warning: buffer underrun");
    return;
  }

  // Get another buffer
  agent.send("more.data.please", 1);
}

// Set up our agent message handlers
agent.on("start.fixed.frequency.dac", function(configuration) {
//   server.log("Got start message with " + configuration.buffers.len() + " buffers");

  local options = configuration.useALAW ? A_LAW_DECOMPRESS : 0;
  local type = ("info" in imp) ? imp.info().type : "imp001";

  if (type == "imp004m") {
    // Set the configuration
    hardware.fixedfrequencydac.configure(hardware.pwmpairKD,
                                         configuration.sampleRateHz,
                                         configuration.buffers,
                                         bufferEmpty,
                                         options);
  } else {
    // Set the FFDAC pin as specified
    local pin = null;
    if (type == "imp001" || type == "imp002") pin = configuration.usePin1 ? hardware.pin1 : hardware.pin5;
    if (type == "imp003") pin = configuration.usePin1 ? hardware.pinA : hardware.pinC;
    if (type == "imp006") pin = configuration.usePin1 ? hardware.pinXC : hardware.pinXD;
    if (type == "imp005") throw "This code will not run on an imp005, which has no FFDAC";

    // Set the configuration
    hardware.fixedfrequencydac.configure(pin,
                                         configuration.sampleRateHz,
                                         configuration.buffers,
                                         bufferEmpty,
                                         options);
  }

  // Start the DAC
  hardware.fixedfrequencydac.start();
});

agent.on("stop.fixed.frequency.dac", function(dummy) {
  // Stop the DAC
  hardware.fixedfrequencydac.stop();
//   server.log("Received stop message");
});

agent.on("more.data", function(buffer) {
  // Add the received data buffer to the DAC
  hardware.fixedfrequencydac.addbuffer(buffer);
//   server.log("Received more data");
});

// Start the process by signalling device readiness
agent.send("device.ready", true);