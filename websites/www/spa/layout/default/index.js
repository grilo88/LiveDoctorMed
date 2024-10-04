function LoadPageContentFromUrl()
{
    const urlParams = new URLSearchParams(window.location.search);
    let page = urlParams.get('menu');
    page = page ?? "home";

    $('#page-content').load(`/spa/pages/${page}/index.html`, function(response, status, xhr) {
        if (status === "error") {
            console.error("Erro ao carregar a página:", xhr.status, xhr.statusText);
        }
    });
}

function TranslateComponent(dirComponent)
{
    const savedLanguage = GetPreferredLanguage();
    translateLanguageFromFile(dirComponent, savedLanguage);
}

function GetPreferredLanguage()
{
    return localStorage.getItem('preferredLanguage') ?? 'en-us';
}

async function translateLanguageFromFile(dirComponent, language)
{
    // Caminho para o arquivo de tradução baseado no idioma escolhido
    const filePath = `${dirComponent}/local/${language}.json`;

    var data = await loadLanguageFile(filePath);

    if (data) {
        translateHtmlComponent(data);
    } else {
        console.error("Erro ao carregar a tradução.");
    }
}

// Função para carregar o arquivo JSON de tradução
async function loadLanguageFile(filePath)
{
    try {
        // Faz o fetch do arquivo JSON de tradução
        const response = await fetch(filePath);
        if (!response.ok) {
            throw new Error(`Erro ao buscar o arquivo: ${response.statusText}`);
        }
        const data = await response.json();
        return data; // Retorna os dados
    } catch (error) {
        console.error("Erro ao carregar o arquivo de tradução:", error);
        return null; // Retorna null em caso de erro
    }
}

function translateHtmlComponent(translations)
{
    // Percorre todas as chaves do objeto JSON
    $.each(translations, function (id, text) {
        // Seleciona o elemento cujo id corresponde à chave e altera o conteúdo
        $('body').find("#" + id).each(function() {
            var element = $(this);

            // Verifica se o elemento é um input
            if (element.is("input")) {
                element.attr("placeholder", text);
            } else {
                element.html(text); // Para outros elementos, mantém o comportamento de alterar o conteúdo
            }
        });

        $('body').find("." + id).each(function() {
            var element = $(this);

            // Verifica se o elemento é um input
            if (element.is("input")) {
                element.attr("placeholder", text);
            } else {
                element.html(text); // Para outros elementos, mantém o comportamento de alterar o conteúdo
            }
        });
    });
}

function CounterUpIndicators()
{
    // Facts counter
    $('[data-toggle="counter-up"]').counterUp({
        delay: 5,
        time: 2000
    });
}