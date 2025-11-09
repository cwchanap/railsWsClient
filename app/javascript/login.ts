// Login form handling
interface AjaxSuccessEvent extends CustomEvent {
  detail: [any, string, XMLHttpRequest];
}

document.addEventListener('DOMContentLoaded', () => {
  const loginForm = document.getElementById('login');
  if (!loginForm) return;

  loginForm.addEventListener('ajax:success', (event: Event) => {
    const ajaxEvent = event as AjaxSuccessEvent;
    const [data, status, xhr] = ajaxEvent.detail;
    if (data.error === true) {
      const loginMsg = document.getElementById('loginMsg');
      if (loginMsg) {
        loginMsg.innerHTML = data.message;
        loginMsg.classList.add('alert', 'alert-danger');
      }
    }
  });

  loginForm.addEventListener('ajax:error', (event: Event) => {
    console.log("Error in request");
    const ajaxEvent = event as AjaxSuccessEvent;
    const [data, status, xhr] = ajaxEvent.detail;
    const loginMsg = document.getElementById('loginMsg');
    if (loginMsg) {
      loginMsg.innerHTML = data;
      loginMsg.classList.add('alert', 'alert-danger');
    }
  });
});
