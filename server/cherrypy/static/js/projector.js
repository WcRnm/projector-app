

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


getStatus()