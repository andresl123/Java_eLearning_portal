window.addEventListener("DOMContentLoaded", function () {
    const params = new URLSearchParams(window.location.search);
    toastr.options = {
        "closeButton": true,
        "progressBar": true,
        "positionClass": "toast-top-right",
        "timeOut": "3000"
    };

    const loginParam = params.get("login");
    const userName = params.get("userName");

    if (loginParam === "success") {
        toastr.success("Login successful!", `🎉 Welcome ${userName || ""}!`);
    } else if (loginParam === "fail") {
        toastr.error("Invalid email or password", "Login Failed ❌");
    } else if (loginParam === "error") {
        toastr.error("An error occurred while logging in", "Server Error ❌");
    }
});
