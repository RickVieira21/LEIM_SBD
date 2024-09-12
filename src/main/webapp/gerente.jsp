<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Página do Gerente</title>
    <style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #ffd7d7;
        color: #8e1818;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh;
    }

    .container {
        text-align: center;
    }

    h1 {
        color: #8e1818;
    }

    ol {
        list-style: none;
        padding: 0;
    }

    li {
        margin: 10px 0;
    }

    a {
        display: block;
        padding: 10px;
        text-decoration: none;
        color: #fff;
        background-color: #a52a2a;
        border-radius: 5px;
        transition: background-color 0.3s ease;
    }

    a:hover {
        background-color: #871c1c;
    }
</style>
    
</head>
<body>
    <h1>Bem-vindo, Gerente!</h1>
    <ol>
        <li><a href="atualizaHorarioContato.jsp">Atualizar horário e dados de contato do clube</a></li>
        <li><a href="configuraSalasEquipamentos.jsp">Configurar salas e equipamentos</a></li>
        <li><a href="criaGerePerfis.jsp">Criar/gerir perfis de utilizadores</a></li>
        <li><a href="consultaTop5Equipamentos.jsp">Consultar top 5 dos equipamentos menos utilizados</a></li>
        <li><a href="acessoMapaOcupacao.jsp">Aceder ao mapa semanal de ocupação das salas</a></li>
        <li><a href="index.jsp">Logout</a></li>
    </ol>
</body>
</html>
