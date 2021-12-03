import { Controller } from "stimulus";

export default class extends Controller {  
      static targets = [ 'other', 'items' ];

  entity(event) {
    console.log("controller connected country !");
    var entity_id = document.getElementById("entity").value;
    console.log(entity_id);

    fetch(`../entities/${entity_id}/get_items_entity`, { headers: { accept: 'application/json' } })
    .then(response => response.json())
    .then((data) => {
      console.log(data);
      this.itemsTarget.innerHTML = data.html_string;
    });
 }
 add_item(event) {
    console.log("entity connected !");
    console.log(`./add_item`);
    var entity_id = document.getElementById("entity").value;      

    console.log(entity_id);
       //create Date object
       var date = new Date();
  
       //get number of milliseconds since midnight Jan 1, 1970 
       //and use it for address key
       var mSec = date.getTime(); 
   
       console.log(date);
      console.log(mSec);
      // Remove the content Please Select an Entity
      var previous_content = document.getElementById("myList").innerHTML.replace("Please select an entity", "");
      document.getElementById("myList").innerHTML = previous_content;

       var elementId = document.getElementById("myList");
       //add created <li> element with its child elements 
       //(label and input) to myList (<ul>) element
      if (entity_id !== "") {  
            fetch(`./add_item/${entity_id}`, { headers: { accept: 'application/json' } })
            .then(response => response.json())
            .then((data) => {
                  var result = data.html_string;
                  result = result.replace("entity_tax_codes_entity_tax_codes_id", `entity_tax_codes_entity_tax_codes_id[${mSec}]`);
                  result = result.replace("item_item_id", `item_item_id[${mSec}]`);
                  result = result.replaceAll("item_update_with_timestamp", `item[${mSec}]`);
                  result = result.replaceAll("comment_update_with_timestamp", `comment[${mSec}]`);
                  result = result.replaceAll("vat_amount_update_with_timestamp", `vat_amount[${mSec}]`);
                  result = result.replaceAll("net_amount_update_with_timestamp", `net_amount[${mSec}]`);
                  result = result.replaceAll("quantity_update_with_timestamp", `quantity[${mSec}]`);
                  console.log(result);
                  elementId.innerHTML += (result);

            });
      }
      else {
            elementId.innerHTML = "Please select an entity";
      }
      
  }

  add_item2(event) {
      console.log("entity connected !");
      console.log(`./add_item`);
      var entity_id = document.getElementById("entity").value;
  
      console.log(entity_id);
         //create Date object
         var date = new Date();
    
         //get number of milliseconds since midnight Jan 1, 1970 
         //and use it for address key
         var mSec = date.getTime(); 
     
         console.log(date);
        console.log(mSec);
        // Remove the content Please Select an Entity
        var previous_content = document.getElementById("myList").innerHTML.replace("Please select an entity", "");
        document.getElementById("myList").innerHTML = previous_content;
  
         var elementId = document.getElementById("myList");
         //add created <li> element with its child elements 
         //(label and input) to myList (<ul>) element
        if (entity_id !== "") {  
              fetch(`../add_item/${entity_id}`, { headers: { accept: 'application/json' } })
              .then(response => response.json())
              .then((data) => {
                    var result = data.html_string;
                    result = result.replace("entity_tax_codes_entity_tax_codes_id", `entity_tax_codes_entity_tax_codes_id[${mSec}]`);
                    result = result.replace("item_item_id", `item_item_id[${mSec}]`);
                    result = result.replaceAll("item_update_with_timestamp", `item[${mSec}]`);
                    result = result.replaceAll("comment_update_with_timestamp", `comment[${mSec}]`);
                    result = result.replaceAll("vat_amount_update_with_timestamp", `vat_amount[${mSec}]`);
                    result = result.replaceAll("net_amount_update_with_timestamp", `net_amount[${mSec}]`);
                    result = result.replaceAll("quantity_update_with_timestamp", `quantity[${mSec}]`);
                    console.log(result);
                    elementId.innerHTML += (result);
  
              });
        }
        else {
              elementId.innerHTML = "Please select an entity";
        }
        
    }
  

  
}