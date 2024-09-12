<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Página do Cliente</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7fb;
            color: #1e2a38;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            text-align: center;
        }

        h1 {
            color: #1e2a38;
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
            background-color: #1e2a38;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        a:hover {
            background-color: #0f1620;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Bem-vindo, Cliente!</h1>
        <ol>
            <li><a href="atualizaPerfil.jsp">Atualizar perfil</a></li>
            <li><a href="subscreveAtividadesIndividuais.jsp">Subscrever atividades individuais</a></li>
            <li><a href="adereAtividadesGrupo.jsp">Aderir a atividades de grupo</a></li>
            <li><a href="obtemCalendario.jsp">Obter calendário semanal</a></li>
            <li><a href="consultaRecomendacoes.jsp">Consultar recomendações do PT</a></li>
            <li><a href="index.jsp">Logout</a></li>
        </ol>
    </div>
</body>
</html>
