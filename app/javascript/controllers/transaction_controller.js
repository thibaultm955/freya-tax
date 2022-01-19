import { Controller } from "stimulus";

export default class extends Controller {  
    static targets = [ 'items' ];

    get_item_rate(event) {
        console.log("connected");
        var item_id = document.getElementById("item_id").value;
        // location where to put the output 
        var elementId = document.getElementById("myList");
  
        console.log(item_id);
        fetch(`./get_item/${item_id}`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
              // elementId.innerHTM = data.html_string;
              console.log(data);
              this.itemsTarget.innerHTML = data.html_string;
        
  
  
        })
      }

    
  }