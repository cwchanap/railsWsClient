// Login form handling
document.addEventListener('DOMContentLoaded', () => {
  const loginForm = document.getElementById('login');
  if (!loginForm) return;

  loginForm.addEventListener('ajax:success', (event) => {
    const [data, status, xhr] = event.detail;
    if (data.error === true) {
      const loginMsg = document.getElementById('loginMsg');
      loginMsg.innerHTML = data.message;
      loginMsg.classList.add('alert', 'alert-danger');
    }
  });

  loginForm.addEventListener('ajax:error', (event) => {
    console.log("Error in request");
    const [data, status, xhr] = event.detail;
    const loginMsg = document.getElementById('loginMsg');
    loginMsg.innerHTML = data;
    loginMsg.classList.add('alert', 'alert-danger');
  });
});
