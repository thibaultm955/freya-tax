import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ 'count', 'country', "project", "periodicity" ];
  

  connect() {
    console.log("controller connected !");

 }

  entity(event) {
    console.log("entity connected !");
    var entity_id = document.getElementById("entity").value;
    console.log(`/entities/${entity_id}/select_entities`);
    fetch(`/entities/${entity_id}/select_entities`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
          console.log(data);
          this.countryTarget.innerHTML = data.html_string;
      });
  }

  country(event) {
    console.log("country connected !");
    var entity_id = document.getElementById("entity").value;
    var country_id = document.getElementById("countries_country_id").value;
    console.log(`/entities/${entity_id}/countries/${country_id}/select_project`);
    fetch(`/entities/${entity_id}/countries/${country_id}/select_project`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
          console.log(data);
          this.projectTarget.innerHTML = data.html_string;
      });
  }
  project(event) {
    console.log("project connected !");
    var entity_id = document.getElementById("entity").value;
    var country_id = document.getElementById("countries_country_id").value;
    var project_id = document.getElementById("project_project_id").value;
    console.log(`/entities/${entity_id}/countries/${country_id}/project_types/${project_id}/select_periodicity`);
    fetch(`/entities/${entity_id}/countries/${country_id}/project_types/${project_id}/select_periodicity`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
          console.log(data);
          this.periodicityTarget.innerHTML = data.html_string;
      });
  }
 
  }