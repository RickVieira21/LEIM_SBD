<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Procurar Perfil de Cliente</title>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>
    $(document).ready(function () {
        $("#nomeCliente").on("input", function () {
            var termoPesquisa = $(this).val();
            $.ajax({
                type: "POST",
                url: "AutoCompleteServlet",
                data: { nomeCliente: termoPesquisa },
                success: function (result) {
                    // Atualiza a lista suspensa com as sugestões recebidas
                    $("#sugestoesClientes").empty();

                    // Verifica se há sugestões antes de exibir
                    if (result.trim() !== "") {
                        var sugestoes = result.split(",");
                        for (var i = 0; i < sugestoes.length; i++) {
                            $("#sugestoesClientes").append("<option value='" + sugestoes[i] + "'>" + sugestoes[i] + "</option>");
                        }
                    }
                }
            });
        });
        
        $("#procurarBtn").click(function () {
            // Obtem o nome selecionado da lista suspensa
            var nomeSelecionado = $("#sugestoesClientes").val();
            
            // Divide o nome selecionado em primeiro e último nome
            var partesNome = nomeSelecionado.split(" ");
            var primeiroNome = partesNome[0];
            var ultimoNome = partesNome.length > 1 ? partesNome.slice(1).join(" ") : "";

            // Faz outra chamada AJAX para obter os detalhes do cliente
            $.ajax({
                type: "POST",
                url: "DetalhesClienteServlet",
                data: { primeiroNome: primeiroNome, ultimoNome: ultimoNome },
                success: function (result) {
                    // Atualiza os elementos na página com os detalhes do cliente
                    $("#detalhesCliente").html(result);
                }
            });
        });
    });
    </script>
    <style>
    body {
        font-family: 'Arial', sans-serif;
        margin: 20px;
        background-color: #e5f1e8;
        color: #264d3c;
    }

    h1 {
        color: #264d3c;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        background-color: #fff;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    th, td {
        border: 1px solid #ddd;
        padding: 12px;
        text-align: left;
    }

    th {
        background-color: #264d3c;
        color: #fff;
    }

    form {
        margin-top: 20px;
    }

    input[type="text"],
    input[type="number"],
    input[type="email"],
    input[type="date"],
    input[type="datetime-local"],
    select {
        width: 100%;
        padding: 8px;
        margin: 5px 0;
        box-sizing: border-box;
    }

    input[type="submit"] {
        background-color: #264d3c;
        color: #fff;
        padding: 10px 15px;
        border: none;
        border-radius: 3px;
        cursor: pointer;
    }

    input[type="submit"]:hover {
        background-color: #1a2f26;
    }

    a {
        color: #264d3c;
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
    }
</style>
</head>
<body>
    <h1>Procurar Perfil de Cliente</h1>

    <label for="nomeCliente">Nome do Cliente:</label>
    <input type="text" id="nomeCliente" name="nomeCliente">

    <select id="sugestoesClientes"></select>

    <button id="procurarBtn">Procurar</button>

    <div id="detalhesCliente"></div>
    <br>
    <a href="pt.jsp"> Voltar para a página Principal</a>
</body>
</html>
