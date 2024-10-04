(function ($) {
    "use strict";

    let headerComponent = $('#comp-header').load("/spa/components/header/index.html", () => UpdateHeaderFromMenu());
    let teamComponent   = $('#comp-team').load("/spa/components/team/index.html");

    NavBarDefaultFromMenu();
    AddCompletedClassPageContent();
})(jQuery);