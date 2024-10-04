(function ($) {
    "use strict";

    let headerComponent = $('#comp-header').load("/spa/components/header/index.html", () => UpdateHeaderFromMenu());
    let faqComponent    = $('#comp-faqs').load("/spa/components/faqs/index.html");

    NavBarDefaultFromMenu();
    AddCompletedClassPageContent();
})(jQuery);