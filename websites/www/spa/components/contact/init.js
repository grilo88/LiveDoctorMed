(async function ($) {
    "use strict";
    var language = GetPreferredLanguage();
    var langFile = await loadLanguageFile(`/spa/components/contact/local/${language}.json`);

    TranslateComponent('/spa/components/contact');

    $(document).ready(async function() 
    {
        let contactComponent = $('#comp-contact');

        contactComponent.form               = contactComponent.find('form');
        contactComponent.inputYourName      = contactComponent.find('#contact-input-your-name');
        contactComponent.inputYourEmail     = contactComponent.find('#contact-input-your-email');
        contactComponent.inputYourPhone     = contactComponent.find('#contact-input-your-phone');
        contactComponent.inputYourProtocol  = contactComponent.find('#contact-input-your-protocol');
        contactComponent.inputYourSubject   = contactComponent.find('#contact-input-your-subject');
        contactComponent.inputYourMessage   = contactComponent.find('#contact-input-your-message');
        contactComponent.submitButton       = contactComponent.find('#contact-send-message-button');
        
        contactComponent.form.validate({
            rules: validate.rules,
            messages: validate.messages[language],
            errorPlacement: function(error, element) 
            {
                let id = element.attr("span-error-id");
                let span = $("span.error#" + id);
                span.text(error.text());
            },
            // Limpa o erro quando a validação for bem-sucedida
            success: function(label, element) {
                let id = $(element).attr("span-error-id");
                let span = $("span.error#" + id);
                if (span.length) span.text("");  // Limpa o conteúdo do span de erro
            },
            submitHandler: function(form) {
                
                var formData = {
                    name:       contactComponent.inputYourName.val(),
                    email:      contactComponent.inputYourEmail.val(),
                    phone:      contactComponent.inputYourPhone.val(),
                    protocol:   contactComponent.inputYourProtocol.val(),
                    subject:    contactComponent.inputYourSubject.val(),
                    message:    contactComponent.inputYourMessage.val()
                };

                alert(langFile['contact-response-message-submit']);
                form.reset();
            }
        });

        contactComponent.submitButton.removeAttr('disabled');
    });
})(jQuery);