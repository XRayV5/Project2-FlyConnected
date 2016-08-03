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

$(document).ready(function () {
   $("#cpw").keyup(checkPasswordMatch);
});
