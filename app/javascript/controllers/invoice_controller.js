import { Controller } from "stimulus";

export default class extends Controller {  
      static targets = [ 'other' ];

  entity(event) {
    console.log("controller connected country !");

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
       //Replace 0 with milliseconds
       var idAttributKind =  
             "invoice_transactions_attributes_0_vat_amount".replace("0", mSec);
      console.log(idAttributKind);
       var nameAttributKind =  
             "invoice[transactions_attributes][0][vat_amount]".replace("0", mSec);
   
       var idAttributStreet =  
             "invoice_transactions_attributes_0_net_amount".replace("0", mSec);
       var nameAttributStreet =  
             "invoice[transactions_attributes][0][net_amount]".replace("0", mSec);
          
       //create <li> tag
       var li = document.createElement("li");
   
       //create label for Kind, set it's for attribute, 
       //and append it to <li> element
       var labelKind = document.createElement("label");
       labelKind.setAttribute("for", idAttributKind);
       var kindLabelText = document.createTextNode("Kind");
       labelKind.appendChild(kindLabelText);
       li.appendChild(labelKind);
   
       //create input for Kind, set it's type, id and name attribute, 
       //and append it to <li> element
       var inputKind = document.createElement("INPUT");
       inputKind.setAttribute("type", "text");
       inputKind.setAttribute("id", idAttributKind);
       inputKind.setAttribute("name", nameAttributKind);
       li.appendChild(inputKind);
   
       //create label for Street, set it's for attribute, 
       //and append it to <li> element
       var labelStreet = document.createElement("label");
       labelStreet.setAttribute("for", idAttributStreet);
       var streetLabelText = document.createTextNode("Street");
       labelStreet.appendChild(streetLabelText);
       li.appendChild(labelStreet);
   
       //create input for Street, set it's type, id and name attribute, 
       //and append it to <li> element
       var inputStreet = document.createElement("INPUT");
       inputStreet.setAttribute("type", "text");
       inputStreet.setAttribute("id", idAttributStreet);
       inputStreet.setAttribute("name", nameAttributStreet);
       li.appendChild(inputStreet);
   
       var result;

       var CodeStreet = document.createElement("label");
       CodeStreet.setAttribute("for", idAttributStreet);
       var CodeStreetText = document.createTextNode("Tax Code");
       labelStreet.appendChild(CodeStreetText);
       li.appendChild(CodeStreet);

       var codeStreet = document.createElement("INPUT");

       var elementId = document.getElementById("myList");
       //add created <li> element with its child elements 
       //(label and input) to myList (<ul>) element
       fetch(`./add_item`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
            var result = data.html_string;
            result = result.replace("entity_tax_codes_entity_tax_codes_id", `entity_tax_codes_entity_tax_codes_id[${mSec}]`);
            result = result.replaceAll("update_with_timestamp", `Input[${mSec}]`)
            console.log(result);
            elementId.innerHTML += (result);

      });
      document.getElementById("myList").appendChild(li);
      

     /*  fetch(`./add_item`, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then((data) => {
          console.log(data.html_string);
          this.otherTarget.innerHTML = data.html_string;
      }); */

  }
  
}