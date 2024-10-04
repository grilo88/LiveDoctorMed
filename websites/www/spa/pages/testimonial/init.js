(function ($) {
    "use strict";

    $('#comp-header').load("/spa/components/header/index.html", () => UpdateHeaderFromMenu());
    $('#comp-testimonial').load("/spa/components/testimonial/index.html");

    NavBarDefaultFromMenu();
    AddCompletedClassPageContent();
})(jQuery);