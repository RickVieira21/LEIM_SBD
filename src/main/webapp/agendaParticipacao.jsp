<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Gestao.LigacaoBD" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Agendar Participação dos Clientes</title>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
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
    <h1>Agendar Participação dos Clientes</h1>

    <h2>Manchas de Disponibilidade agendadas por si:</h2>
    <table border="1">
        <tr>
            <th>Data Marcação</th>
            <th>Mínimo Participantes</th>
            <th>Máximo Participantes</th>
            <th>Data Início</th>
            <th>Data Fim</th>
            <th>Data/Hora Cancelamento</th>
            <th>Data/Hora Confirmação</th>
            <th>Tipo Atividade</th>
            <th>Escalão Etário </th>
            <th>Semanal</th>
        </tr>
        <% 
            List<String> datasMarcacao = new ArrayList<>();

            try {
                Connection conn = LigacaoBD.getConnection();

                // Obtém o emailPT da sessão
                HttpSession sesion = request.getSession();
                String emailPT = (String) sesion.getAttribute("emailPT");

                // Consulta as manchas de disponibilidade para o emailPT atual
                String queryDisponibilidade = "SELECT * FROM Disponibilidade WHERE emailPT = ?";
                try (PreparedStatement pstmtDisponibilidade = conn.prepareStatement(queryDisponibilidade)) {
                    pstmtDisponibilidade.setString(1, emailPT);
                    ResultSet rsDisponibilidade = pstmtDisponibilidade.executeQuery();

                    while (rsDisponibilidade.next()) {
                        String dataMarcacao = rsDisponibilidade.getString("dataMarcacao");
                        datasMarcacao.add(dataMarcacao);
                      
        %>
                        <tr>
                            <td><%= rsDisponibilidade.getString("dataMarcacao") %></td>
                            <td><%= rsDisponibilidade.getInt("minParticipantes") %></td>
                            <td><%= rsDisponibilidade.getInt("maxParticipantes") %></td>
                            <td><%= rsDisponibilidade.getString("inicia") %></td>
                            <td><%= rsDisponibilidade.getString("acaba") %></td>
                            <td><%= rsDisponibilidade.getString("dataHoraCancelamento") %></td>
                            <td><%= rsDisponibilidade.getString("dataHoraConfirmacao") %></td>
                            <td><%= rsDisponibilidade.getString("tipoAtividade") %></td>
                            <td><%= rsDisponibilidade.getString("tipoEscalaoEtario") %></td>
                            <td><%= rsDisponibilidade.getBoolean("semanal") ? "Sim" : "Não" %></td>
                        </tr>
        <%
                    }
                }

                // Consulta os clientes para o emailPT atual
                String queryClientes = "SELECT * FROM Cliente WHERE emailPT = ?";
                try (PreparedStatement pstmtClientes = conn.prepareStatement(queryClientes)) {
                    pstmtClientes.setString(1, emailPT);
                    ResultSet rsClientes = pstmtClientes.executeQuery();
        %>
                </table>

				<h2>Participações Agendadas</h2>
				<table border="1">
				    <tr>
				        <th>Data Marcação</th>
				        <th>NIF Cliente</th>
				    </tr>
				    <% 
				        try (PreparedStatement pstmtParticipacoes = conn.prepareStatement("SELECT * FROM disponibilidade_cliente")) {
				            ResultSet rsParticipacoes = pstmtParticipacoes.executeQuery();
				
				            while (rsParticipacoes.next()) {
				                String dataMarcacaoParticipacao = rsParticipacoes.getString("dataMarcacao");
				                String nifClienteParticipacao = rsParticipacoes.getString("NIFCliente");
				    %>
				                <tr>
				                    <td><%= dataMarcacaoParticipacao %></td>
				                    <td><%= nifClienteParticipacao %></td>
				                </tr>
				    <%
				            }
				        }
				    %>
				</table>


                <h2>Escolher Cliente e Mancha de Disponibilidade</h2>
                <form action="AdicionarParticipacaoServlet" method="post">
                    <label for="cliente">Escolher Cliente:</label>
                    <select name="cliente">
                        <% 
                            while (rsClientes.next()) {
                                String nifCliente = rsClientes.getString("NIFCliente");
                                String nomeCliente = rsClientes.getString("primeiroNomeCliente") + " " + rsClientes.getString("ultimoNomeCliente");
                        %>
                            <option value="<%= nifCliente %>"><%= nomeCliente %></option>
                        <%
                            }
                        %>
                    </select>

                    <label for="manchaDisponibilidade">Escolher Mancha de Disponibilidade:</label>
                    <select name="manchaDisponibilidade">
                        <% 
                            for (String dataMarcacao : datasMarcacao) {
                        %>
                            <option value="<%= dataMarcacao %>"><%= dataMarcacao %></option>
                        <%
                            }
                        %>
                    </select>

                    <input type="submit" value="Agendar Participação">
                </form>
        <%
                }

                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    <a href="pt.jsp"> Voltar para a página Principal</a>
</body>
</html>
