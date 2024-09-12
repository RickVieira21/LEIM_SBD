<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Página do Personal Trainer</title>
    <style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #e5f1e8;
        color: #264d3c;
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
        color: #264d3c;
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
        background-color: #2a4d3c;
        border-radius: 5px;
        transition: background-color 0.3s ease;
    }

    a:hover {
        background-color: #1a2f26;
    }
</style>

    
</head>
<body>
    <h1>Bem-vindo, Personal Trainer!</h1>
    <ol>
        <li><a href="consultaPublicaManchas.jsp">Consultar/publicar manchas de disponibilidade</a></li>
        <li><a href="confirmaCancelaAtividades.jsp">Confirmar ou cancelar atividades</a></li>
        <li><a href="procuraPerfil.jsp">Procurar perfil de cliente</a></li>
        <li><a href="agendaParticipacao.jsp">Agendar participação dos clientes</a></li>
        <li><a href="fazRecomendacoes.jsp">Fazer recomendações aos clientes</a></li>
        <li><a href="index.jsp">Logout</a></li>
    </ol>
</body>
</html>
