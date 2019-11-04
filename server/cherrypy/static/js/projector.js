

function setStatus(status) {
    document.getElementById("location0").innerHTML = status[0].location;
    document.getElementById("online0").innerHTML = status[0].online;
    document.getElementById("lampHrs0").innerHTML = status[0].lampHrs;
    document.getElementById("serviceHrs0").innerHTML = status[0].serviceHrs;
    document.getElementById("msgCount0").innerHTML = status[0].msgCount;
}

function getStatus() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
        setStatus(JSON.parse(this.responseText))
    }
  };
  xhttp.open("GET", "projector", true);
  xhttp.send();
}

function on_ws_open() {
  ws_send('Hello Websocket');
}
function on_ws_close() {
  
}
function on_ws_message(msg) {
  console.log('ws: ' + msg);
}
function on_ws_erorr(err) {
  
}


getStatus()
ws_init(
    'ws://' + document.location.host + '/ws',
    on_ws_open,
    on_ws_close,
    on_ws_message,
    on_ws_erorr
  );