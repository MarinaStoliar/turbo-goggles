/***/

var Bpmn = Bpmn || {};

(function(app, win){
app.run = function(url) {
  var bpmn = new BpmnJS({container: '#canvas'});
  var req = new XMLHttpRequest();
  req.open('GET', url, true);
  req.onload = async function() {
      if(req.readyState == 4 && req.status == 200){
          await bpmn.importXML(req.responseText);
          let c = bpmn.get('canvas');
          c.zoom('fit-viewport')
      }
  }
  req.onerror = function(e) {}
  req.send();
}})(Bpmn, window);
