<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="Gestao.LigacaoBD" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<html>
<head>
    <title>Fazer Recomendações aos Clientes</title>
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
    <h1>Fazer Recomendações aos Clientes</h1>

    <% 
        HttpSession sesion = request.getSession();
        String emailPT = (String) sesion.getAttribute("emailPT");
    %>

    <h1> Tabela de Recomendações efetuadas aos seus Clientes </h1>
    <table border="1">
        <tr>
            <th>Data de Emissão</th>
            <th>Data de Início</th>
            <th>Data de Fim</th>
            <th>NIF do seu Cliente</th>
            <th>Designação</th>
            <th>Recomendado</th>
        </tr>
        <% 
            try {
                Connection conn = LigacaoBD.getConnection();
                String query = "SELECT * FROM recomendacao WHERE emailPT = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                    pstmt.setString(1, emailPT);
                    ResultSet rs = pstmt.executeQuery();

                    while (rs.next()) {
        %>
                        <tr>
                            <td><%= rs.getString("dataEmissao") %></td>
                            <td><%= rs.getString("dataInicio") %></td>
                            <td><%= rs.getString("dataFim") %></td>
                            <td><%= rs.getString("NIFCliente") %></td>
                            <td><%= rs.getString("designacao") %></td>
                            <td><%= rs.getString("recomendado") %></td>
                        </tr>
        <%
                    }
                }
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    </table>

    <h2>Adicionar uma Recomendação para um determinado cliente</h2>
    <form action="AdicionarRecomendacaoServlet" method="post">

        <label>Data de Início:</label>
        <input type="datetime-local" name="dataInicio" required><br>

        <label>Data de Fim:</label>
        <input type="datetime-local" name="dataFim"><br>
        
        <label>NIF do Cliente:</label>
        <select name="NIFCliente" required>
            <% 
                // Consulta os NIFs dos clientes associados a um determinado PT
                Connection conn = LigacaoBD.getConnection();
                String queryClientes = "SELECT NIFCliente FROM Cliente WHERE emailPT = ?";
                try (PreparedStatement pstmtClientes = conn.prepareStatement(queryClientes)) {
                    pstmtClientes.setString(1, emailPT);
                    ResultSet rsClientes = pstmtClientes.executeQuery();

                    while (rsClientes.next()) {
                        String nifCliente = rsClientes.getString("NIFCliente");
            %>
                        <option value="<%= nifCliente %>"><%= nifCliente %></option>
            <%
                    }
                }
            %>
        </select><br>

        <label>Equipamento a recomendar:</label>
        <select name="designacao" required>
            <% 
                // Consulta os tipos de equipamentos, definidos na tabela tipoEquipamento
                String queryDesignacoes = "SELECT designacao FROM tipoequipamento";
                try (PreparedStatement pstmtDesignacoes = conn.prepareStatement(queryDesignacoes)) {
                    ResultSet rsDesignacoes = pstmtDesignacoes.executeQuery();

                    while (rsDesignacoes.next()) {
                        String nomeDesignacao = rsDesignacoes.getString("designacao");
            %>
                        <option value="<%= nomeDesignacao %>"><%= nomeDesignacao %></option>
            <%
                    }
                }
            %>
        </select><br>

        <label>Recomendado:</label>
        <input type="text" name="recomendado" required><br>
		<br>
        <input type="submit" value="Fazer Recomendação">
    </form>
    
    <a href="pt.jsp"> Voltar para a página Principal</a>
</body>
</html>
