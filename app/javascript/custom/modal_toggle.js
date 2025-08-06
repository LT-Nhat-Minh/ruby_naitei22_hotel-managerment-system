document.addEventListener("turbo:load", function () {
    // Open modal
  document.querySelectorAll(".open-modal").forEach(button => {
    button.addEventListener("click", function () {
      const modalId = this.getAttribute("data-modal-id");

      document.getElementById(modalId).classList.add("show");
    });
  });

  // Đóng modal
  document.querySelectorAll(".close-modal").forEach(closeBtn => {
    closeBtn.addEventListener("click", function () {
      const modalId = this.getAttribute("data-modal-id");
      document.getElementById(modalId).classList.remove("show");
    });
  });
});
