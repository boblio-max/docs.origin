// Single source of truth for the site version. Bump on release.
var ORIGIN_VERSION = "1.7.29";
document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("[data-origin-version]").forEach(function (el) {
        el.textContent = ORIGIN_VERSION;
    });
});
