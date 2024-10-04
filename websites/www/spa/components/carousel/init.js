(function ($) {
    "use strict";
    
    // Hero Header carousel
    $(".header-carousel").owlCarousel({
        items: 1,
        autoplay: true,
        autoplayTimeout: 10000,
        smartSpeed: 2000,
        center: false,
        dots: false,
        // loop: true, // BUG
        margin: 0,
        nav : true,
        navText : [
            '<i class="bi bi-arrow-left"></i>',
            '<i class="bi bi-arrow-right"></i>'
        ],
        // Após o carrossel ser iniciado, chamar a função de tradução
        onInitialized: function() {
            TranslateComponent('/spa/components/carousel');
        },
        onTranslate: function() {
            TranslateComponent('/spa/components/carousel');
        }
    });
})(jQuery);