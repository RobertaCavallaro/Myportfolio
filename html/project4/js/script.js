function validateLogin() {
  event.preventDefault();

const enteredfname=document.getElementById("firstname").value;
const enteredlname=document.getElementById("lastname").value;
const enteredEmail=document.getElementById("email").value;

// LOG IN INTO ACCOUNT.HTML
if (enteredfname && enteredlname && enteredEmail) {
  sessionStorage.setItem('auth','yes');
  window.location.href = 'account.html';

} 
else {
  document.getElementById("welcomeMsg").innerHTML='Please try again!';
}
return false;
}




//REMEMBER ME CHECKBOX
const rememberCheckbox = document.getElementById('remember');
rememberCheckbox.addEventListener('change',handleRememberChange);

function handleRememberChange() {
  if (rememberCheckbox.checked) {
      // Store the session data in local storage or cookies
      localStorage.setItem('rememberedSession', 'true');
  } else {
      // Remove the session data from local storage or cookies
      localStorage.removeItem('rememberedSession');
  }
}
// When the page loads, check if the session data is stored and set the checkbox state
window.addEventListener('load', function() {
  var rememberedSession = localStorage.getItem('rememberedSession');
  if (rememberedSession === 'true') {
      rememberCheckbox.checked = true;
  }
});



// TERMS AND CONDITIONS  CHECKBOX
// Add an event listener to the checkbox to detect when it changes
var termsCheckbox = document.getElementById('terms');
termsCheckbox.addEventListener('change', handleTermsChange);

// Create a function to handle the checkbox change event and enable/disable the login
function handleTermsChange() {
  var loginButton = document.getElementById('login');
  login.disabled = !termsCheckbox.checked;
}



    // Logout function
    function logoutButton() {
      sessionStorage.removeItem('auth');
      window.location.href = 'index.html'; // Redirect to the login page
    }

    // Add event listener to the logout button
    const logoutButtonElement = document.getElementById('logoutButton');
    logoutButtonElement.addEventListener('click', logoutButton);




    
      // HOME function
      function homeButton() {
      sessionStorage.removeItem('auth');
      window.location.href = 'account.html'; // Redirect to the home page
    }

    // Add event listener to the home button
    const homeButtonElement = document.getElementById('homeButton');
    homeButtonElement.addEventListener('click', homeButton);





    // WORK function
    function workButton() {
      sessionStorage.removeItem('auth');
      window.location.href = 'work.html'; // Redirect to the work page
    }

    // Add event listener to the work button
    const workButtonElement = document.getElementById('workButton');
    workButtonElement.addEventListener('click', workButton);



   // CONTACT function
       function contactButton() {
      sessionStorage.removeItem('auth');
      window.location.href = 'contact.html'; // Redirect to the contact page
    }

    // Add event listener to the settings button
    const contactButtonElement = document.getElementById('contactButton');
    contactButtonElement.addEventListener('click', contactButton);



    // dropdown button personal information function
    function dropDown() {
      var dropdownContent = document.getElementById("personalInfo");
      if (dropdownContent.style.display === "none") {
        dropdownContent.style.display = "block";
      } else {
        dropdownContent.style.display = "none";
      }
    } 








