function NavBarDefaultFromMenu() 
{
    const urlParams = new URLSearchParams(window.location.search);
    let menu = urlParams.get('menu') ?? 'home';

    var element = $("#navbarCollapse").first();

    // Remove a classe "active" de todos os itens do navbar
    element.find('.active').removeClass('active');

    var itemElement = element.find(`#nav-${menu}`);
    itemElement.addClass('active');

    // Dropdown Button Active
    itemElement.parent().parent().addClass('active');
}

function History(e, page)
{
    e.preventDefault();
    window.history.pushState({ page }, '', `?menu=${page}`);

    LoadPageContent(page, () => 
        {
            $('html, body').animate({ scrollTop: 0 }, 'fast');
        });
}

function FadeInPageContent() 
{
    const checkInterval = setInterval(function() 
    {
        // Verifica se a classe 'completed' está presente
        if ($('#page-content').hasClass('completed')) 
        {
            clearInterval(checkInterval); // Para o intervalo
            $("#page-content").animate({ opacity: 100 }, 500, function() {
                $(this).css("visibility", "visible");
            });
        }
    }, 100); // Verifica a cada 100ms
}

function LoadPageContent(page, callback)
{
    $('#page-content').removeClass('completed');
    $("#page-content").animate({ opacity: 0 }, 100, function() {
        $('#page-content').load(`/spa/pages/${page}/index.html`, function () 
        { 
            FadeInPageContent();
            callback();
        });
    });
}