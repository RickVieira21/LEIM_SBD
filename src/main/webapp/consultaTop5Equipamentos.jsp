<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="Gestao.LigacaoBD" %>
<html>
<head>
    <title>Consultar Top 5 dos Equipamentos Menos Utilizados</title>
    <style>
    body {
        font-family: 'Arial', sans-serif;
        margin: 20px;
        background-color: #ffd7d7;
        color: #8e1818;
    }

    h1 {
        color: #8e1818;
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
        background-color: #8e1818;
        color: #fff;
    }

    form {
        margin-top: 20px;
    }

    select {
        width: 100%;
        padding: 8px;
        margin: 5px 0;
        box-sizing: border-box;
    }

    input[type="submit"] {
        background-color: #8e1818;
        color: #fff;
        padding: 10px 15px;
        border: none;
        border-radius: 3px;
        cursor: pointer;
    }

    input[type="submit"]:hover {
        background-color: #871c1c;
    }

    a {
        color: #8e1818;
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
    }
</style>
</head>
<body>
    <h1>Consultar Top 5 dos Equipamentos Menos Utilizados</h1>

    <h2>Lista de Clubes</h2>
    <form action="ConsultaTop5EquipamentosServlet" method="post">
        <label for="nifClube">Escolha um clube pelo NIF:</label>
        <select name="nifClube">
            <% 
                try {
                    Connection conn = LigacaoBD.getConnection();
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM clube");

                    while (rs.next()) {
            %>
                        <option value="<%= rs.getString("NIFClube") %>"><%= rs.getString("NIFClube") %></option>
            <%
                    }
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </select>
        <input type="submit" value="Escolher Clube">
    </form>

    <h2>Entradas de Sala Disponibilidade no Último Trimestre</h2>
    <table border="1">
        <tr>
            <th>ID da Sala</th>
            <th>Data de Marcação</th>
        </tr>
        <%
         ResultSet resultadosSalaDisponibilidade = (ResultSet)request.getAttribute("resultadosSalaDisponibilidade");


        if (resultadosSalaDisponibilidade != null) {
            while (resultadosSalaDisponibilidade.next()) {
        %>
            <tr>
                <td><%= resultadosSalaDisponibilidade.getString("idSala") %></td>
                <td><%= resultadosSalaDisponibilidade.getString("dataMarcacao") %></td>
            </tr>
        <%
            }
        }
        %>
    </table>
    
	<h2>Duração de Atividades</h2>
	<table border="1">
	    <tr>
	        <th>Data de Marcação</th>
	        <th>Duração (minutos)</th>
	    </tr>
	    <%
	        ResultSet resultadosDuracao = (ResultSet) request.getAttribute("duracoes");

	
	    if (resultadosDuracao != null) {
	        while (resultadosDuracao.next()) {
	    %>
	        <tr>
	            <td><%= resultadosDuracao.getString("dataMarcacao") %></td>
	            <td><%= resultadosDuracao.getString("duracao") %></td>
	        </tr>
	    <%
	        }
	    }
	    %>
	</table>

	<br>
    <a href="gerente.jsp">Voltar para a página principal</a>
    
</body>
</html>
