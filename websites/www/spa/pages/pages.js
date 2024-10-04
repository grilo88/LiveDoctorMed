function AddCompletedClassPageContent()
{
    LoadCompletedPageContent(() => $('#page-content').addClass('completed'));
}

function LoadCompletedPageContent(callback) 
{
    // Aguarda o carregamento completo da página, incluindo imagens e outros recursos
    // Garante que todo o conteúdo, incluindo imagens, scripts e CSS foram carregados
    let checkAllImagesLoaded = function() {
        let allImagesLoaded = true;
        $('#page-content img').each(function() {
            if (!this.complete || $(this).height() === 0) {
                allImagesLoaded = false;
            }
        });
        return allImagesLoaded;
    };

    let checkIfPageLoaded = function() {
        // Verifica se todas as imagens foram carregadas e se não há processos AJAX pendentes
        if (checkAllImagesLoaded() && !$.active) {
            clearInterval(intervalCheck); // Interrompe a verificação contínua
            clearTimeout(timeoutCheck);
            callback();
        }
    };

    // Realiza a verificação repetidamente até que todas as imagens e recursos AJAX estejam carregados
    let intervalCheck = setInterval(checkIfPageLoaded, 100); // Verifica a cada 100ms

    // Limite de tempo de 3 segundos (3000ms)
    let timeoutCheck = setTimeout(function() {
        clearInterval(intervalCheck); // Interrompe a verificação contínua
        callback(); // Executa o callback mesmo se o carregamento não estiver completo
    }, 3000);
}