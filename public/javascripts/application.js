function checkPasswordMatch() {
    var password = $("#npw").val();
    var confirmPassword = $("#cpw").val();
    if (password !== confirmPassword){

        $(".pwcheck1").html("");
        $(".pwcheck").html("Passwords do not match!");
        //
        // console.log("???");

      }
    else{
        $(".pwcheck").html("");
        $(".pwcheck1").html("Passwords match.");
        // $(".pwcheck").remove();
      }
}


function validateInput(val) {
  if (val) {
    return true;
  } else {
    return false;
  }
}

$(document).ready(function () {
   $("#cpw").keyup(checkPasswordMatch);
  //  empty_check("arpt_form", "arpt_input", "valcheck", "Please enter search query!");

  $( "#arpt_form" ).submit(function( event ) {
    if ( !validateInput($( "#arpt_input" ).val()) ) {
      $( "#valcheck" ).text( "Please enter search query" ).show();
      event.preventDefault();
      return false;
    } else {
      event.target.submit();
    }
  });

  $( "#flt_form" ).submit(function( event ) {
    if ( !validateInput($( "#flt_Input" ).val()) ) {
      $( "#valcheck_flt" ).text( "Please enter Flight Number." ).show();
      event.preventDefault();
      return false;
    } else {
      event.target.submit();
    }
  });
});









//
// empty_check("flt_form", "flt_Input", "valcheck_flt", "Please enter Flight Number!");
// // empty_check("arpt_form", "arpt_input", "valcheck", "Please enter search query!");
