document.getElementById('addAddress').addEventListener("click",function() 
{
      //create Date object
      var date = new Date();
  
      //get number of milliseconds since midnight Jan 1, 1970 
      //and use it for address key
      var mSec = date.getTime(); 
  
      //Replace 0 with milliseconds
      idAttributKind =  
            "invoice_transactions_attributes_0_vat_amount".replace("0", mSec);
      nameAttributKind =  
            "invoice[transactions_attributes][0][vat_amount]".replace("0", mSec);
  
      idAttributStreet =  
            "invoice_transactions_attributes_0_net_amount".replace("0", mSec);
      nameAttributStreet =  
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
  
      //add created <li> element with its child elements 
      //(label and input) to myList (<ul>) element
      document.getElementById("myList").appendChild(li);
  
      //show address header
      $("#addressHeader").show(); 
  }
) ;

window.onload = function() {
      var reloading = sessionStorage.getItem("reloading");
      if (reloading) {
          sessionStorage.removeItem("reloading");
          myFunction();
      }
  }
  function reloadP() {
      sessionStorage.setItem("reloading", "true");
      document.location.reload();
  }
  