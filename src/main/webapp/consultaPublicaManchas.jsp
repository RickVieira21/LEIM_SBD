<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="Gestao.LigacaoBD" %>
<html>
<head>
    <title>Publicar Nova Mancha de Disponibilidade</title>
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

        #opcoesSala {
            display: none;
        }
    </style>
</head>
<body>
	
	<h1>Consulta/Publicação de Manchas de Disponibilidade</h1>
    <form action="" method="post">
        Escolha o Escalão Etário:
        <select name="escalaoEtario" required>
            <option value="Jovens">Jovens</option>
            <option value="Adultos">Adultos</option>
            <option value="Idosos">Idosos</option>
        </select>
        <input type="submit" value="Filtrar">
    </form>

    <% 
        String escalaoEtarioEscolhido = request.getParameter("escalaoEtario");
        if (escalaoEtarioEscolhido != null) {
            HttpSession sessin = request.getSession();
            String emailPT = (String) sessin.getAttribute("emailPT");

    %>

    <h2>Manchas de Disponibilidade destinadas para o escalão etário <%= escalaoEtarioEscolhido %> e publicadas pelo PT cujo email é <%= emailPT %>:</h2>
    <table border="1">
        <tr>
            <th>Data Marcação</th>
            <th>Mínimo Participantes</th>
            <th>Máximo Participantes</th>
            <th>Data Início</th>
            <th>Data Fim</th>
            <th>Data/Hora Cancelamento</th>
            <th>Data/Hora Confirmação</th>
            <th>Email PT</th>
            <th>Tipo Atividade</th>
            <th>Tipo Escalão Etário</th>
            <th>Semanal</th>
        </tr>
        <% 
            try {
                Connection conn = LigacaoBD.getConnection();
                String query = "SELECT * FROM Disponibilidade WHERE tipoEscalaoEtario = ? AND emailPT = ?";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setString(1, escalaoEtarioEscolhido);
                pstmt.setString(2, emailPT);
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
        %>
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
                    </tr>
        <%
                }
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    </table>

    <% } %>


    <h1>Publicar Nova Mancha de Disponibilidade</h1>
    <form action="PublicarManchaServlet" method="post">
        Data de Início: <input type="datetime-local" name="dataInicio" required><br>
        Data de Fim: <input type="datetime-local" name="dataFim" required><br>
        Tipo de Atividade:
        <select name="tipoAtividade" required>
            <option value="Cardio">Cardio</option>
            <option value="Ciclismo">Ciclismo</option>
            <option value="Natação">Natação</option>
            <option value="Pilates">Pilates</option>
            <option value="Yoga">Yoga</option>
            <option value="Zumba">Zumba</option>
        </select><br>

        Tipo de Escalão Etário:
        <select name="tipoEscalaoEtario" required>
            <option value="Jovens">Jovens</option>
            <option value="Adultos">Adultos</option>
            <option value="Idosos">Idosos</option>
        </select><br>

        Número mínimo de Participantes: <input type="number" name="minParticipantes" min="1" required><br>
        Número máximo de Participantes: <input type="number" name="maxParticipantes" min="1" required><br>

        Reservar sala?
        <select name="reservarSala" onchange="mostrarSala(this)">
            <option value="nao">Não</option>
            <option value="sim">Sim</option>
        </select><br>

        <div id="opcoesSala">
            Sala:
            <select name="idSala">
                
                <% 
                    try {
                        
                        HttpSession sessao = request.getSession();
                        String emailPT = (String) sessao.getAttribute("emailPT");

                        String sqlNIFClube = "SELECT NIFClube FROM PT WHERE emailPT = ?";
                        try (Connection conn = LigacaoBD.getConnection();
                             PreparedStatement pstmtNIFClube = conn.prepareStatement(sqlNIFClube)) {

                            pstmtNIFClube.setString(1, emailPT);
                            ResultSet rsNIFClube = pstmtNIFClube.executeQuery();

                            if (rsNIFClube.next()) {
                                String nifClube = rsNIFClube.getString("NIFClube");

                                String sqlIdSala = "SELECT idSala FROM sala WHERE NIFClube = ?";
                                try (PreparedStatement pstmtIdSala = conn.prepareStatement(sqlIdSala)) {
                                    pstmtIdSala.setString(1, nifClube);
                                    ResultSet rsIdSala = pstmtIdSala.executeQuery();

                                    
                                    while (rsIdSala.next()) {
                                        String idSala = rsIdSala.getString("idSala");
                                %>
                                        <option value="<%= idSala %>"><%= idSala %></option>
                                <%
                                    }
                                }
                            }
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </select><br>
        </div>

        Semanal: <input type="checkbox" name="semanal"><br>
        <br>
        <input type="submit" value="Publicar Mancha">
    </form>

    <script>
        function mostrarSala(select) {
            var opcoesSala = document.getElementById("opcoesSala");
            opcoesSala.style.display = select.value === "sim" ? "block" : "none";
        }
    </script>
    <br>
    <a href="pt.jsp"> Voltar para a página principal</a>
</body>
</html>