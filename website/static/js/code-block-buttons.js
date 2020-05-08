// Turn off ESLint for this file because it's sent down to users as-is.
/* eslint-disable */
window.addEventListener("load", function () {
  function button(label, ariaLabel, className) {
    const btn = document.createElement("button");
    btn.classList.add("btnIcon", className);
    btn.setAttribute("type", "button");
    btn.setAttribute("aria-label", ariaLabel);
    btn.innerHTML = label;
    return btn;
  }

  function addButtons(codeBlockSelector, btn) {
    document.querySelectorAll(codeBlockSelector).forEach(function (code) {
      code.parentNode.appendChild(btn.cloneNode(true));
    });
  }

  addButtons(".hljs", button("Copy", "Copy code to clipboard", "btnClipboard"));

  const clipboard = new ClipboardJS(".btnClipboard", {
    target: function (trigger) {
      return trigger.parentNode.querySelector("code");
    },
  });

  clipboard.on("success", function (event) {
    event.clearSelection();
    const textEl = event.trigger.querySelector(".btnIcon__label");
    textEl.textContent = "Copied";
    setTimeout(function () {
      textEl.textContent = "Copy";
    }, 2000);
  });
});
