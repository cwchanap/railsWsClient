// User signup form handling
interface AjaxSuccessEvent extends CustomEvent {
  detail: [any, string, XMLHttpRequest];
}

document.addEventListener('DOMContentLoaded', () => {
  const signUpForm = document.getElementById('signUp');
  if (!signUpForm) return;

  signUpForm.addEventListener('ajax:success', (event: Event) => {
    const ajaxEvent = event as AjaxSuccessEvent;
    const [data, status, xhr] = ajaxEvent.detail;
    if (data.error === true) {
      const signUpMsg = document.getElementById('signUpMsg');
      if (signUpMsg) {
        signUpMsg.innerHTML = data.message;
        signUpMsg.classList.add('alert', 'alert-danger');
      }
    }
  });

  signUpForm.addEventListener('ajax:error', (event: Event) => {
    console.log("Error in request");
    const ajaxEvent = event as AjaxSuccessEvent;
    const [data, status, xhr] = ajaxEvent.detail;
    const signUpMsg = document.getElementById('signUpMsg');
    if (signUpMsg) {
      signUpMsg.innerHTML = data;
      signUpMsg.classList.add('alert', 'alert-danger');
    }
  });
});
