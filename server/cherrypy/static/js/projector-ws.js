
let ws_conn = {
  ws: null,
  on_open: null,
  on_close: null,
  on_message: null,
  on_error: null,
}

function ws_init(uri, on_open, on_close, on_message, on_error) {
  'use strict';

  console.log("ws: " + uri);

  let ws = new WebSocket(uri);
  ws.onopen = function (evt) { onOpen(evt); };
  ws.onclose = function (evt) { onClose(evt); };
  ws.onmessage = function (evt) { onMessage(evt); };
  ws.onerror = function (evt) { onError(evt); };

  ws_conn.ws = ws;
  ws_conn.on_open = on_open;
  ws_conn.on_close = on_close;
  ws_conn.on_message = on_message;
  ws_conn.on_error = on_error;
}

function ws_send(msg) {
  if (ws_conn.ws != null) {
    ws_conn.ws.send(msg);
    return true;
  }
  return false;
}

function onOpen(evt) {
  'use strict';
  ws_conn.connected = true;
  ws_conn.on_open();
}

function onClose(evt) {
  'use strict';
  ws_conn.ws = null;
  ws_conn.on_close();
}

function onMessage(evt) {
  'use strict';
  var json, msgType, msg;
  msg = evt.data.toString();

  try {
    ws_conn.on_message(JSON.parse(msg))
  } catch (err) {
    console.log("catch: " + err.toString());
    console.log("recv: " + msg);
  }    
}

function onError(evt) {
    'use strict';
    ws_conn.on_error(evt.data);
}