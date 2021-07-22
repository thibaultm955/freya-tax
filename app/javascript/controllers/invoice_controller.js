import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ 'greet', 'entity' ];
  

  entity(event) {
    console.log("controller connected country !");

 }
 greet(event) {
    console.log("entity connected !");
    console.log(`./add_item`);
    fetch(`./add_item`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
          console.log(data);
          this.entityTarget.innerHTML = data.html_string;
      }); 
  }
  
}