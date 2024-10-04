(function ($) {
    "use strict";

    let headerComponent     = $('#comp-header').load("/spa/components/header/index.html", () => UpdateHeaderFromMenu());
    let servicesComponent   = $('#comp-services').load("/spa/components/services/index.html");
    let feedbackComponent   = $('#comp-testimonial').load("/spa/components/testimonial/index.html");
    let faqComponent        = $('#comp-faqs').load("/spa/components/faqs/index.html");

    NavBarDefaultFromMenu();
    AddCompletedClassPageContent();
})(jQuery);