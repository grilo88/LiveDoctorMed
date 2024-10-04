(function ($) {
    "use strict";
    
    $("#footer-home").on("click", (e) => History(e, "home"));
    $("#footer-about").on("click", (e) => History(e, "about"));
    $("#footer-technology").on("click", (e) => History(e, "technology"));
    $("#footer-project").on("click", (e) => History(e, "project"));
    $("#footer-blog").on("click", (e) => History(e, "blog"));
    $("#footer-team").on("click", (e) => History(e, "team"));
    $("#footer-feedback").on("click", (e) => History(e, "testimonial"));
    $("#footer-faq").on("click", (e) => History(e, "faqs"));
    $("#footer-contact").on("click", (e) => History(e, "contact"));
    $("#footer-view-all-posts").on("click", (e) => History(e, "blog"));

    TranslateComponent('/spa/components/footer');
})(jQuery);