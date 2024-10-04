(function ($) {
    "use strict";

    let headerComponent = $('#comp-header').load("/spa/components/header/index.html", () => UpdateHeaderFromMenu());
    let _404Component   = $('#comp-404').load("/spa/components/404/index.html");

    AddCompletedClassPageContent();
})(jQuery);