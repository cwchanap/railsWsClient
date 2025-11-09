// User signup form handling
document.addEventListener('DOMContentLoaded', () => {
  const signUpForm = document.getElementById('signUp');
  if (!signUpForm) return;

  signUpForm.addEventListener('ajax:success', (event) => {
    const [data, status, xhr] = event.detail;
    if (data.error === true) {
      const signUpMsg = document.getElementById('signUpMsg');
      signUpMsg.innerHTML = data.message;
      signUpMsg.classList.add('alert', 'alert-danger');
    }
  });

  signUpForm.addEventListener('ajax:error', (event) => {
    console.log("Error in request");
    const [data, status, xhr] = event.detail;
    const signUpMsg = document.getElementById('signUpMsg');
    signUpMsg.innerHTML = data;
    signUpMsg.classList.add('alert', 'alert-danger');
  });
});
