function copyCode(button) {
    const code = button.previousElementSibling.innerText;
    navigator.clipboard.writeText(code).then(() => {
        button.innerText = "¡Copiado!";
        setTimeout(() => {
            button.innerText = "Copiar";
        }, 2000);
    }).catch(err => {
        console.error('Error al copiar: ', err);
    });
}
