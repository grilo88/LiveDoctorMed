(function ($) {
    "use strict";

    let headerComponent         = $('#comp-carousel').load("/spa/components/carousel/index.html");
    let aboutComponent          = $('#comp-about').load("/spa/components/about/index.html");
    let servicesComponent       = $('#comp-services').load("/spa/components/services/index.html");
    let projectComponent        = $('#comp-project').load("/spa/components/project/index.html");
    let blogComponent           = $('#comp-blog').load("/spa/components/blog/index.html");
    let teamComponent           = $('#comp-team').load("/spa/components/team/index.html");
    let feedbackComponent       = $('#comp-testimonial').load("/spa/components/testimonial/index.html");
    let faqComponentComponent   = $('#comp-faqs').load("/spa/components/faqs/index.html");

    NavBarDefaultFromMenu();
    AddCompletedClassPageContent();
})(jQuery);