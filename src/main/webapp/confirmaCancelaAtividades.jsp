<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*,javax.servlet.http.HttpSession" %>
<%@ page import="Gestao.LigacaoBD" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<html>
<head>
    <title>Confirmar ou Cancelar Atividades</title>
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
    <h1>Confirmar ou Cancelar Atividades</h1>

    <table border="1">
        <tr>
            <th>Data de Marcação</th>
            <th>Mínimo de Participantes</th>
            <th>Máximo de Participantes</th>
            <th>Data de Início</th>
            <th>Data de Fim</th>
            <th>Data/Hora de Cancelamento</th>
            <th>Data/Hora de Confirmação</th>
            <th>Email PT</th>
            <th>Tipo de Atividade</th>
            <th>Escalão etário</th>
            <th>Semanal?</th>
            <th>Confirmar</th>
            <th>Cancelar</th>
        </tr>
        <% 
            try {
                Connection conn = LigacaoBD.getConnection();
                HttpSession sesion = request.getSession();
                String emailPT = (String) sesion.getAttribute("emailPT");

                String query = "SELECT * FROM Disponibilidade WHERE emailPT = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                    pstmt.setString(1, emailPT);
                    ResultSet rs = pstmt.executeQuery();

                    while (rs.next()) {
        %>
                        <form action="ConfirmaCancelaAtividadesServlet" method="post">
                            <tr>
                                <td><%= rs.getString("dataMarcacao") %></td>
                                <td><%= rs.getInt("minParticipantes") %></td>
                                <td><%= rs.getInt("maxParticipantes") %></td>
                                <td><%= rs.getString("inicia") %></td>
                                <td><%= rs.getString("acaba") %></td>
                                <td><%= rs.getString("dataHoraCancelamento") %></td>
                                <td><%= rs.getString("dataHoraConfirmacao") %></td>
                                <td><%= rs.getString("emailPT") %></td>
                                <td><%= rs.getString("tipoAtividade") %></td>
                                <td><%= rs.getString("tipoEscalaoEtario") %></td>
                                <td><%= rs.getBoolean("semanal") ? "Sim" : "Não" %></td>
                                <td>
                                    <input type="submit" value="Confirmar" name="confirmar">
                                    <input type="hidden" name="dataMarcacaoConfirmar" value="<%= rs.getString("dataMarcacao") %>">
                                </td>
                                <td>
                                    <input type="submit" value="Cancelar" name="cancelar">
                                    <input type="hidden" name="dataMarcacaoCancelar" value="<%= rs.getString("dataMarcacao") %>">
                                </td>
                            </tr>
                        </form>
        <%
                    }
                }
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    </table>
    <br>
    <a href="pt.jsp"> Voltar para a página Principal</a>
</body>
</html>
