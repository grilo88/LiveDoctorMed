(function ($) {
    "use strict";

    let headerComponent = $('#comp-header').load("/spa/components/header/index.html", () => UpdateHeaderFromMenu());
    let blogComponent   = $('#comp-blog').load("/spa/components/blog/index.html");

    NavBarDefaultFromMenu();
    AddCompletedClassPageContent();
})(jQuery);