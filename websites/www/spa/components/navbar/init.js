(function ($) {
    "use strict";

    $("#nav-home").on("click", (e) => History(e, "home"));
    $("#nav-about").on("click", (e) => History(e, "about"));
    $("#nav-technology").on("click", (e) => History(e, "technology"));
    $("#nav-project").on("click", (e) => History(e, "project"));
    $("#nav-blog").on("click", (e) => History(e, "blog"));
    $("#nav-team").on("click", (e) => History(e, "team"));
    $("#nav-testimonial").on("click", (e) => History(e, "testimonial"));
    $("#nav-faqs").on("click", (e) => History(e, "faqs"));
    $("#nav-contact").on("click", (e) => History(e, "contact"));

    TranslateComponent('/spa/components/navbar');

    // Sticky Navbar
    $(window).scroll(function () {
        if ($(window).width() > 992) {
            if ($(this).scrollTop() > 45) {
                $('.sticky-top .container').addClass('shadow-sm').css('max-width', '100%');
            } else {
                $('.sticky-top .container').removeClass('shadow-sm').css('max-width', $('.topbar .container').width());
            }
        } else {
            $('.sticky-top .container').addClass('shadow-sm').css('max-width', '100%');
        }
    });

    NavBarDefaultFromMenu();
})(jQuery);