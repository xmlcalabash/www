$(document).ready(function() {
    $("#nav-toggle").on('click', function () {
        if ($("#nav-menu").hasClass("is-active")) {
            $("#nav-menu").removeClass("is-active");
        } else {
            $("#nav-menu").addClass("is-active");
        }
    });
});
