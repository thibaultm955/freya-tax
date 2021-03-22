import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ 'country', 'entity' ];
  

  connect() {
    console.log("controller connected country !");

 }
 country(event) {
    console.log("entity connected !");
    var country_id = document.getElementById("country").value;
    console.log(`/countries/${country_id}/select_country`);
    fetch(`/countries/${country_id}/select_country`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
          console.log(data);
          this.entityTarget.innerHTML = data.html_string;
      });
  }
}