<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="Gestao.LigacaoBD" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Aderir a atividades de grupo</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
            color: #333;
        }

        h1 {
            color: #1a237e;
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
            background-color: #1a237e;
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
            background-color: #1a237e;
            color: #fff;
            padding: 10px 15px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #0d1b52;
        }

        a {
            color: #1a237e;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>Lista de Atividades de Grupo disponíveis:</h1>
    
    <%
        String userID = (String) session.getAttribute("userID");
        System.out.println(userID);
        String NIFCliente = (String) session.getAttribute("NIFCliente");
        System.out.println(NIFCliente);
        String emailPT = (String) session.getAttribute("emailPT");
        System.out.println(emailPT);

        try {
            Connection conn = LigacaoBD.getConnection();
            String sql = "SELECT * FROM disponibilidade WHERE maxParticipantes > minParticipantes AND dataHoraConfirmacao IS NOT NULL AND dataHoraCancelamento IS NULL AND inicia > CURRENT_DATE";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
    %>
                    <table border="1">
                        <tr>
                            <th>Tipo de Atividade</th>
                            <th>Escalão etário</th>
                            <th>Personal Trainer</th>
                            <th>Número máximo de participantes</th>
                            <th>Início da Atividade</th>
                            <th>Fim da Atividade</th>
                        </tr>
                        <% do 
                        { 
                        %>
                        <tr>
                            <td><%= rs.getString("tipoAtividade") %></td>
                            <td><%= rs.getString("tipoEscalaoEtario") %></td>
                            <td><%= rs.getString("emailPT") %></td>
                            <td><%= rs.getString("maxParticipantes") %></td>
                            <td><%= rs.getString("inicia") %></td>
                            <td><%= rs.getString("acaba") %></td>
                        </tr>
                        <%  } 
                        while (rs.next()); 
                        %>
                    </table>
    <%
                }
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    
    <h1>Lista de Atividades de Grupo aderidas:</h1>
    
    <%
        try {
            Connection conn = LigacaoBD.getConnection();
            String sql = "SELECT * FROM disponibilidade INNER JOIN disponibilidade_cliente ON disponibilidade.dataMarcacao = disponibilidade_cliente.dataMarcacao WHERE disponibilidade_cliente.NIFCliente=? AND disponibilidade.maxParticipantes > disponibilidade.minParticipantes AND disponibilidade.dataHoraConfirmacao IS NOT NULL AND disponibilidade.dataHoraCancelamento IS NULL AND disponibilidade.inicia > CURRENT_DATE";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, NIFCliente);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    %>
                                    <table border="1">
                                        <tr>
                                            <th>Tipo de Atividade</th>
                                            <th>Escalão etário</th>
                                            <th>Personal Trainer</th>
                                            <th>Número máximo de participantes</th>
                                            <th>Início da Atividade</th>
                                            <th>Fim da Atividade</th>
                                        </tr>
                                        <% do 
                                        { 
                                        %>
                                        <tr>
                                            <td><%= rs.getString("tipoAtividade") %></td>
                                            <td><%= rs.getString("tipoEscalaoEtario") %></td>
                                            <td><%= rs.getString("emailPT") %></td>
                                            <td><%= rs.getString("maxParticipantes") %></td>
                                            <td><%= rs.getString("inicia") %></td>
                                            <td><%= rs.getString("acaba") %></td>
                                        </tr>
                                        <%  } 
                                        while (rs.next()); 
                                        %>
                                    </table>
                    <%
                                }
                                conn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
    
    <h1> Selecione a atividade de grupo que deseja aderir:</h1>
    <form action="adereAtividadesGrupoServlet" method="post">
        <select name="dataMarcacao" required>
        <%
            try {
                Connection conn = LigacaoBD.getConnection();
                String sql_o = "SELECT DISTINCT * FROM disponibilidade WHERE minParticipantes < maxParticipantes AND dataHoraConfirmacao IS NOT NULL AND inicia > CURRENT_DATE AND NOT EXISTS (SELECT 1 FROM disponibilidade_cliente WHERE disponibilidade_cliente.NIFCliente=? AND disponibilidade_cliente.dataMarcacao = disponibilidade.dataMarcacao)";
                try (PreparedStatement pstmt_o = conn.prepareStatement(sql_o)) {
                    pstmt_o.setString(1, NIFCliente);
                    ResultSet rs_o = pstmt_o.executeQuery();
                    while (rs_o.next()) {
            %>
                        <option value="<%= rs_o.getString("dataMarcacao") %>"><%= rs_o.getString("tipoAtividade") + " para " + rs_o.getString("tipoEscalaoEtario") + ", criada pelo PT " + rs_o.getString("emailPT") + ", que começa no dia " + rs_o.getString("inicia") %></option>
            <%
                    }
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
        </select>
        <br>
        <br>
        <input type="submit" value="Aderir Atividade de Grupo">
    </form>
    
    <a href="cliente.jsp">Voltar para a página inicial</a>
</body>
</html>
