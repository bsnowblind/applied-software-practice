/**
 * @file
 * @details     Agent configuration content for Project S.O.C.K
 */

// High-level macro to define model as a 'AGENT'
@set ENVIRONMENT = "AGENT";

// System configuration table with respect to the agent side module
/*
 * NOTE:
 *  - All period values are in seconds, unless otherwise noted
 */

local agent_config = {
    "system_tick_period": 0.01,                
}