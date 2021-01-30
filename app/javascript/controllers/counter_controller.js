import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ 'count', 'country', "project" ];
  

  connect() {
    console.log("controller connected !");

 }

  entity(event) {
    console.log("entity connected !");
    var entity_id = document.getElementById("entity").value;
    console.log(`/entities/${entity_id}/select_shares_sector`);
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
  /* country(event) {
    console.log("country connected !");
    var sector_id = document.getElementById("sector").value;
    var country_id = document.getElementById("country").value;
    console.log(sector_id);
    if (sector_id.length == 0 && country_id.length == 0) {
      var sector_id = "none";
      var country_id = "none";
      console.log(`/countries/${country_id}/sectors/${sector_id}/select_shares_sector`);
      fetch(`/countries/${country_id}/sectors/${sector_id}/select_shares_sector`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
          console.log(data);
          this.wrapperTarget.innerHTML = data.html_string;
      });
    }
    else if (sector_id.length == 0) {
      var sector_id = "none";
      console.log(`/countries/${country_id}/sectors/${sector_id}/select_shares_sector`);
      fetch(`/countries/${country_id}/sectors/${sector_id}/select_shares_sector`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
          console.log(data);
          this.wrapperTarget.innerHTML = data.html_string;
      });
    }
    else if (country_id.length == 0) {
      var country_id = "none";
      console.log(`/countries/${country_id}/sectors/${sector_id}/select_shares_sector`);
      fetch(`/countries/${country_id}/sectors/${sector_id}/select_shares_sector`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
          console.log(data);
          this.wrapperTarget.innerHTML = data.html_string;
      });
    }
    else {
      console.log(`/countries/${country_id}/sectors/${sector_id}/select_shares_sector`);
      fetch(`/countries/${country_id}/sectors/${sector_id}/select_shares_sector`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
          console.log(data);
          this.wrapperTarget.innerHTML = data.html_string;
      });
      }

    } */
  }