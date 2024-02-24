// Proof of concept for autofilling forms.

function autofillFormUsers() {
    var selection = document.getElementById("userSelection").value;
    var form = document.getElementById("userForm");
  
    if (selection === "anakinsucks") {
      form.userID.value = "66";
      form.username.value = "anakinsucks";
      form.firstName.value = "Obi-Wan";
      form.lastName.value = "Kenobi";
      form.email.value = "ihavethehighground@mustafar.com";
      form.phoneNumber.value = "5551234561";
      form.signupDate.value = "2021-03-11 20:00:00";
    } else if (selection === "ihatesand") {
        form.userID.value = "501";
        form.username.value = "ihatesand";
        form.firstName.value = "Anakin";
        form.lastName.value = "Skywalker";
        form.email.value = "thisiswherethefunbegins@nowthisispodracing.com";
        form.phoneNumber.value = "5215342567";
        form.signupDate.value = "2021-03-11 20:00:01";
    } else if (selection === "naboorep") {
        form.userID.value = "915";
        form.username.value = "naboorep";
        form.firstName.value = "Padme";
        form.lastName.value = "Amidala";
        form.email.value = "princessamidala@naboo.org";
        form.phoneNumber.value = "5521234567";
        form.signupDate.value = "2020-03-15 20:00:00";
    } else if (selection === "totallynotasithlord") {
        form.userID.value = "666";
        form.username.value = "totallynotasithlord";
        form.firstName.value = "Sheev";
        form.lastName.value = "Palpatine";
        form.email.value = "darthsidious_spamaccount@aol.com";
        form.phoneNumber.value = "5521234460";
        form.signupDate.value = "2020-03-20 19:00:00";
    } else if (selection === "sabercollector") {
        form.userID.value = "91";
        form.username.value = "sabercollector";
        form.firstName.value = "General";
        form.lastName.value = "Grievous";
        form.email.value = "techsupport@robotswithCOPD.org";
        form.phoneNumber.value = "6521334269";
        form.signupDate.value = "1970-01-01 00:00:00";
    } else {
        form.userID.value = "";
        form.username.value = "";
        form.firstName.value = "";
        form.lastName.value = "";
        form.email.value = "";
        form.phoneNumber.value = "";
        form.signupDate.value = "";
    }
  };

function autofillFormPosts() {
  var selection = document.getElementById("postSelection").value;
  var form = document.getElementById("postForm");

  if (selection === "1") {
    form.postID.value = "1";
    form.userID.value = "66";
    form.postDate.value = "2023-12-05 20:50:00";
    form.postBody.value = "Hello, there!";
  } else if (selection === "2") {
    form.postID.value = "2";
    form.userID.value = "501";
    form.postDate.value = "2023-12-05 20:50:00";
    form.postBody.value = "You're either with me or against me!";
  } else if (selection === "3") {
    form.postID.value = "3";
    form.userID.value = "915";
    form.postDate.value = "2023-12-05 20:50:00";
    form.postBody.value = "Traffic in Coruscant SUCKS!";
  } else if (selection === "4") {
    form.postID.value = "4";
    form.userID.value = "666";
    form.postDate.value = "2023-12-05 20:50:00";
    form.postBody.value = "I am the Senate!";
  } else if (selection === "5") {
    form.postID.value = "5";
    form.userID.value = "91";
    form.postDate.value = "2023-12-05 20:50:00";
    form.postBody.value = "*cough cough*";
  } else if (selection === "6") {
    form.postID.value = "6";
    form.userID.value = "91";
    form.postDate.value = "2023-12-05 20:50:01";
    form.postBody.value = "I need an inhaler";
  } else {
    form.postID.value = "";
    form.userID.value = "";
    form.postDate.value = "";
    form.postBody.value = "";
  }
};