<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="Gestao.LigacaoBD" %>
<html>
<head>
    <title>Atualizar Horário e Dados de Contato do Clube</title>
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
    <h1>Atualizar Horário e Dados de Contato do Clube</h1>

    <h2>Horários, Email e Telefone Atuais:</h2>
    <table border="1">
        <tr>
            <th>NIF do Clube</th>
            <th>Dia</th>
            <th>Horário de Funcionamento</th>
            <th>Email</th>
            <th>Telefone</th>
        </tr>
        <% 
            try {
                Connection conn = LigacaoBD.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM periodo INNER JOIN clube ON periodo.NIFClube = clube.NIFClube");

                while (rs.next()) {
        %>
                    <tr>
                        <td><%= rs.getString("NIFClube") %></td>
                        <td><%= rs.getString("diaSemana") %></td>
                        <td><%= rs.getString("abrir") %> - <%= rs.getString("fechar") %></td>
                        <td><%= rs.getString("emailClube") %></td>
                        <td><%= rs.getString("telefoneClube") %></td>
                    </tr>
        <%
                }
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    </table>

    <form action="AtualizaHorarioContatoServlet" method="post">
        Escolha o NIF do Clube:
        <select name="nifClube" required>
            <% 
                try {
                    Connection conn = LigacaoBD.getConnection();
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT DISTINCT NIFClube FROM periodo");

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
        </select><br>
        Dia da Semana:
        <select name="diaSemana" required>
            <option value="Segunda-Feira">Segunda-Feira</option>
            <option value="Terca-Feira">Terça-Feira</option>
            <option value="Quarta-Feira">Quarta-Feira</option>
            <option value="Quinta-Feira">Quinta-Feira</option>
            <option value="Sexta-Feira">Sexta-Feira</option>
            <option value="Sábado">Sábado</option>
            <option value="Domingo">Domingo</option>
        </select><br>
        Novo Horário de Funcionamento: <input type="text" name="novoAberto" required> - <input type="text" name="novoFechado" required><br>
        Novo Endereço de Email de Contato: <input type="email" name="novoEmail" required><br>
        Novo Número de Telefone de Contato: <input type="text" name="novoTelefone" required><br>
        <br>
        <input type="submit" value="Atualizar Dados">
    </form>
    
    <a href="gerente.jsp">Voltar para a página principal</a>
</body>
</html>
