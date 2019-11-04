let LOCATION = 'config-location'

var initialized = false

function setStatus(status) {
  table = document.getElementById("proj-table").getElementsByTagName('tbody')[0];
  nproj = status.length;

  for (var i=0; i<nproj; ++i) {
    let projector = status[0];

    // add the column header
    var row = document.getElementById("proj-header");
    var cell;
    
    var cell_id = "proj-name" + i;
    cell = document.getElementById(cell_id);
    if (cell == null) {
      cell = document.createElement('th');
      cell.id = "proj-name" + i;
      row.appendChild(cell);
    }
    cell.innerHTML = projector[LOCATION];

    Object.keys(projector)
      .sort()
      .forEach(function(prop, i) {
          let row_id = "prop-" + prop;
          row = document.getElementById(row_id);
  
          if (null == row) {
            row = table.insertRow();
            row.id = row_id;
  
            cell = row.insertCell();
            cell.id = row_id + "-name";
            cell.innerHTML = prop.toString();
  
            //for (var i=0; i<nproj; ++i) {
            //}
          }

          cell_id = row_id + "i";
          cell = document.getElementById(cell_id);
          if (cell == null) {
            cell = row.insertCell();
            cell.id = row_id + "i";
          }
          cell.innerHTML = projector[prop];
        });
  }
}

function getStatus() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4) {

      switch(this.status) {
        case 200:
          setStatus(JSON.parse(this.responseText));
          break;
        default: 
          break;
      }
    }
  };
  xhttp.open("GET", "projector", true);
  xhttp.send();
}

getStatus();