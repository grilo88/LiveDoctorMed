(function ($) {
    "use strict";

    const loadComponent = (url, appendTo, pre) => {
        return $.get(url).then((data) => {
            if (pre)
                $(appendTo).prepend(data);
            else
                $(appendTo).append(data);
        });
    };

    const loadComponentsA = async () => {
        await loadComponent("/spa/components/navbar/index.html", 'body', true);
        await loadComponent("/spa/components/topbar/index.html", 'body', true);
        
        NavBarDefaultFromMenu();
    }
    const loadComponentsB = async () => {
        // await loadComponent("/spa/components/spinner/index.html", 'body');
        await loadComponent("/spa/components/modals/search/index.html", 'body');
        await loadComponent("/spa/components/footer/index.html", 'body');
        await loadComponent("/spa/components/copyright/index.html", 'body');
        await loadComponent("/spa/components/back-to-top/index.html", 'body');

        LoadPageContentFromUrl();
    };

    new WOW().init();

    loadComponentsA();
    loadComponentsB();
})(jQuery);