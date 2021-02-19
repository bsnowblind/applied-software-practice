/**
 * @file
 * @details     Provides functionality to simulate an RTD temperature sensor output 
 *
 * @note        Sample code (modified) provided by Electric Imp
 *              https://gist.github.com/ElectricImpSampleCode/b0cecf7571c428719a84f91289fac96f
 */

// AGENT CODE
const AMPLITUDE = 0x3FFF;
const NUMBER_POINTS = 1024;
const CLIP_VALUE = 32635;
const INCR_X = 0.78531475;

local streaming = true;
local logTable = [
  1,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
  6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
  7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
  7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
];

function aLawCompress(sample) {
  local sample = sample == -32768 ? -32767 : sample;
  local sign = ((~sample) >> 8) & 0x80;

  if (!sign) sample = -sample;
  if (sample > CLIP_VALUE) sample = CLIP_VALUE;

  local compressedValue = 0;

  if (sample >= 256) {
    local exponent = logTable[(sample >> 8) & 0x7F];
    local mantissa = (sample >> (exponent + 3)) & 0x0F;
    compressedValue = ((exponent << 4) | mantissa);
  } else {
    compressedValue = sample >> 4;
  }

  compressedValue = compressedValue ^ (sign ^ 0x55);
  return compressedValue;
}

function writeSineBuffer() {
  // Generate a 1kHz sine wave data as a blob
  local buffer = blob();
  local curr_x = 0;

  for (local i = 0 ; i < NUMBER_POINTS ; i++) {
    local a = AMPLITUDE * math.cos(curr_x);
    curr_x += INCR_X;
    local y = aLawCompress(a.tointeger());
    buffer.writen(y, 'c');
  }

  return buffer;
}

// Define the DAC configuration
local configuration = {
  "buffers" : [writeSineBuffer(), writeSineBuffer(), writeSineBuffer(), writeSineBuffer()],
  "sampleRateHz" : 0.800,     /* Frequency of sine wave sample rate divided by 8 */
  "usePin1" : true,
  "useALAW" : true
}

// Set up our device message handlers:
// First, deal with requests for more audio data
device.on("more.data.please", function(nbuffers) {
  if (streaming) device.send("more.data", writeSineBuffer());
});

// Second, continue when the device has signalled its readiness
device.on("device.ready", function(dummy) {
  streaming = true;

  // Tell the DAC to start and send its configuration
  device.send("start.fixed.frequency.dac", configuration);

//   // Wake after 10s and tell the device to stop the DAC
//   imp.wakeup(10, function() {
//     device.send("stop.fixed.frequency.dac", true);
//     streaming = false;
//   });
});