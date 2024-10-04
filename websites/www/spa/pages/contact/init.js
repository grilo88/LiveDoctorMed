(function ($) {
    "use strict";

    NavBarDefaultFromMenu();
    AddCompletedClassPageContent();

    let headerComponent  = $('#comp-header').load("/spa/components/header/index.html", () => UpdateHeaderFromMenu());
    let contactComponent = $('#comp-contact').load("/spa/components/contact/index.html", () => LoadedContactComponent());

    function LoadedContactComponent()
    {
        contactComponent.inputYourName = contactComponent.find("#contact-input-your-name");

        contactComponent.on('animationend', function() {
            ReadyContactForm();
        });
    }

    function ReadyContactForm()
    {
        contactComponent.inputYourName.focus();
    }
})(jQuery);