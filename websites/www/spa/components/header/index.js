function UpdateHeaderFromMenu() 
{
    const urlParams = new URLSearchParams(window.location.search);
    let menu = urlParams.get('menu');

    var preferredLanguage = GetPreferredLanguage();

    fetch(`/spa/components/header/local/${preferredLanguage}.json`)
        .then(response => response.json())
        .then(data => {
            var headerList = data;

            let title = headerList[menu].title;
            let page = headerList[menu].text;

            var titleElement = $('#comp-header').find("h4").first();
            titleElement.html(title);

            var element = $('#comp-header').find("ol.breadcrumb").first();
            element.empty();

            element.append(`<il class="breadcrumb-item"><a>${headerList["principal"]}</a></il>`);
            element.append(`<il class="breadcrumb-item"><a>${headerList["pages"]}</a></il>`);
            element.append(`<il class="breadcrumb-item active text-primary">${page}</il>`);
        })
        .catch(error => {
            console.error("Erro ao carregar o arquivo de tradução:", error);
        });
}