let validate = {
    rules: {
        "contact-your-name": {
            required: true,
            minlength: 3
        },
        "contact-your-email": {
            required: true,
            email: true
        },
        "contact-your-phone": {
            required: true,
            digits: true,
            minlength: 10
        },
        "contact-your-protocol": {
            required: true
        },
        "contact-your-subject": {
            required: true,
            minlength: 3
        },
        "contact-your-message": {
            required: true,
            minlength: 10
        }
    },
    messages: {
        "en-us": {
            "contact-your-name": {
                required: "Please enter your name",
                minlength: "The name must be at least 3 characters long"
            },
            "contact-your-email": {
                required: "Please enter your email",
                email: "Please provide a valid email address"
            },
            "contact-your-phone": {
                required: "Please provide your phone number",
                digits: "The phone should only contain numbers",
                minlength: "The phone number must be at least 10 digits long"
            },
            "contact-your-protocol": {
                required: "Please advise the protocol"
            },
            "contact-your-subject": {
                required: "Please enter the subject",
                minlength: "The subject must be at least 3 characters long"
            },
            "contact-your-message": {
                required: "Please write your message",
                minlength: "The message must be at least 10 characters long"
            }
        },
        "pt-br": {
            "contact-your-name": {
                required: "Por favor, informe seu nome",
                minlength: "O nome deve ter pelo menos 3 caracteres"
            },
            "contact-your-email": {
                required: "Por favor, informe seu e-mail",
                email: "Informe um e-mail válido"
            },
            "contact-your-phone": {
                required: "Por favor, informe seu telefone",
                digits: "O telefone deve conter apenas números",
                minlength: "O telefone deve ter no mínimo 10 dígitos"
            },
            "contact-your-protocol": {
                required: "Por favor, informe o protocolo"
            },
            "contact-your-subject": {
                required: "Por favor, informe o assunto",
                minlength: "O assunto deve ter pelo menos 3 caracteres"
            },
            "contact-your-message": {
                required: "Por favor, escreva sua mensagem",
                minlength: "A mensagem deve ter no mínimo 10 caracteres"
            }
        }
    }
};