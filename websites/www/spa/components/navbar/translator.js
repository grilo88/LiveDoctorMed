// Elementos do DOM
const languageSelect = document.getElementById('navbar-language-select');

// Função para alterar o idioma com base na seleção
function changeLanguage(language) {
    localStorage.setItem('preferredLanguage', language);
}

// Verificar se o idioma preferido já está no localStorage
const savedLanguage = localStorage.getItem('preferredLanguage');
if (savedLanguage) {
    // Se existir um idioma salvo, aplica-o e define no select
    changeLanguage(savedLanguage);
    languageSelect.value = savedLanguage;
} else {
    // Se não houver, usa o padrão (inglês)
    changeLanguage('en-us');
}

// Detecta mudanças no select e aplica o novo idioma
languageSelect.addEventListener('change', (event) => {
    const selectedLanguage = event.target.value;
    changeLanguage(selectedLanguage);
    location.reload();
});