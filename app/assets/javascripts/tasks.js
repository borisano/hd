$(document).on('turbolinks:load', function() {

   $('#datepicker').datepicker({ dateFormat: 'dd-mm-yy' });

     $(".clickable-row").click(function() {
         window.location = $(this).data("href");
     });
});

function show(comment_id) {
  var $button_id = "#"+"edit_" + comment_id
  $("#" + comment_id).toggle();
  $($button_id).text($($button_id).text() == 'Edit' ? "Cancel" : "Edit" );
  text_area_var = document.getElementById('comment_content_' + comment_id);
  if (text_area_var.style.display == "none")
    {text_area_var.style.display = "block";}
  else
    {text_area_var.style.display = "none";}
  return false;
};


// IMPORTANT
// This function needs to corelate with the attachments and tasks models
function preview(e){
  input = document.getElementById(e.id);
  document.getElementById("image_thumbs").innerHTML="";

  if (input.files.length <= 10)
    {
     for (var i = 0; i < input.files.length; ++i) {
       // TODO restrict based on size
      //  alert(input.files.item(i).size);
      image_types = ["image/jpeg","image/png"]
      fReader = new FileReader();
      fReader.readAsDataURL(input.files[i]);
      fReader.name = input.files[i].name;
      fReader.type = input.files[i].type;
      fReader.onloadend = function(event){
        img_div_section = document.getElementById("image_thumbs");
        img_div = document.createElement("div");
        name_div = document.createElement("div");
        img = document.createElement("img");

        img.className = "thumb_image";
        img_div.className = "thumb_image_container";

        if ( image_types.includes(event.target.type) )
          {
            img.src = event.target.result;
          }
        else
          {
            img.src = "/site_images/no_doc_image_thumb.png";
          }

         img.title = event.target.name
         img_div.appendChild(img);

         name_div.innerHTML = event.target.name
         img_div_section.appendChild(img_div);
         img_div_section.appendChild(name_div);

       };
     }
    }
  else {
    form_name = $("#edit_form_name").text();
    document.forms[form_name].reset();
    alert("You can only upload 10 files at a time.");
  }
}
