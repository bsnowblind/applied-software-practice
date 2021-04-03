/**
 * @file
 * @details     Davra server class for interfacing to the Davra cloud instance
 */

/**
 * Davra server class for interfacing to the Davra cloud instance                  
 */
class DavraServer {

    /**
     * URL of the Davra Server to communicate with
     */
    m_url = null;

    /**
     * Authentication Token for the Davra Server
     */
    m_authToken = null;

    /**
     * Constructs an instance of the class 
     *
     * @param   url                 URL of the Davra Server to communicate with                    
     * @param   authToken           Authentication Token for the Davra Server                        
     */
    constructor(url = null, authToken = null) {
        if (url == null) {
            throw "DeviceServer() must be called with a non-null url";
        } else if (authToken == null) {
            throw "DeviceServer() must be called wit a non-null Authentication Token";
        }
        m_url = url;
        m_authToken = authToken;
    }

    /**
     * Sends data to the Davra Server 
     *
     * @param   metricName          Name of the metric to which the data will be sent                          
     * @param   value               Value of metric which will be posted
     * @param   timestamp           Timestamp of the value to be sent, if none is provided the 
     *                              server should timestamp at reception. THIS MUST BE IN UNIX EPOCH 
     *                              SECONDS NOT MILLISECONDS as Electric Imp only supports 32 bits
     * @param   uuid                Device UUID 
     *
     * @return  Table containing the HTTP response
     */
    function SendData(metricName, value, timestamp = null, uuid = null) {
        return _PostValue(metricName, value, "datum", timestamp, uuid);
    }

    /**
     * Sends an event to the Davra Server 
     *
     * @param   metricName          Name of the metric to which the data will be sent                          
     * @param   value               Value of metric which will be posted
     * @param   timestamp           Timestamp of the value to be sent, if none is provided the 
     *                              server should timestamp at reception. THIS MUST BE IN EPOCH 
     *                              SECONDS NOT MILLISECONDS as Electric Imp only supports 32 bits
     * @param   uuid                Device UUID 
     *
     * @return  Table containing the HTTP response
     */
    function SendEvent(metricName, value, timestamp = null, uuid = null) {
        return _PostValue(metricName, value, "event", timestamp, uuid);
    }

    /**
     * POSTs value using HTTP in JSON format to the Davra Server
     *
     * @param   metricName          Name of the metric which will be posted                          
     * @param   value               Value of metric which will be posted
     * @param   msgType             HTTP message type  
     * @param   timestamp           Timestamp of the value to be sent, if none is provided the 
     *                              server should timestamp at reception. THIS MUST BE IN EPOCH 
     *                              SECONDS NOT MILLISECONDS as Electric Imp only supports 32 bits
     * @param   uuid                Device UUID 
     *
     * @return  Table containing the HTTP response
     */
    function _PostValue(metricName, value, msgType = "datum", timestamp = null, uuid = null) {
        local optionalHeaders = {};
        optionalHeaders.rawset("Authorization", "Bearer " + m_authToken);
        optionalHeaders.rawset("content-type", "application/json");

        local body = {
                "name": metricName,
                "msg_type": msgType,
                "value": value};
        
        if(timestamp != null) body.rawset("timestamp", timestamp);
        if(uuid != null) body.rawset("UUID", uuid);
                
        local request = http.post(m_url, optionalHeaders, http.jsonencode([body]));
        return request.sendsync();
    }

    /**
     * PUTs value using HTTP in JSON format to the  Davra Server
     *
     * @param   metricName          Name of the metric which will be updated                          
     * @param   value               Value of metric which will be updated
     * @param   msgType             HTTP message type  
     * @param   timestamp           Timestamp of the value to be sent, if none is provided the 
     *                              server should timestamp at reception. THIS MUST BE IN EPOCH 
     *                              SECONDS NOT MILLISECONDS as Electric Imp only supports 32 bits
     * @param   uuid                Device UUID 
     * 
     * @return  Table containing the HTTP response
     */
    function _PutValue(metricName, value,  msgType = "datum", timestamp = null, uuid = null) {
        local optionalHeaders = {};
        optionalHeaders.rawset("Authorization", "Bearer " + m_authToken);
        optionalHeaders.rawset("content-type", "application/json");

        local body = {
                "name": metricName,
                "msg_type": msgType,
                "value": value};
        
        if(timestamp != null) body.rawset("timestamp", timestamp);
        if(uuid != null) body.rawset("UUID", uuid);

        local request = http.put(m_url, optionalHeaders, http.jsonencode([body]));
        return request.sendsync();
    }
}