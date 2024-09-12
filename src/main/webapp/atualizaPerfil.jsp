<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="Gestao.LigacaoBD" %>

<html>
<head>
    <title>Atualização do Perfil</title>
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
        
        h2 {
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
    <h1>Perfil Atual:</h1>
    
    <%
        String userID = (String) session.getAttribute("userID");
        System.out.println(userID);

        try {
            Connection conn = LigacaoBD.getConnection();
            String sql = "SELECT * FROM cliente INNER JOIN utilizador ON cliente.userID = utilizador.userID WHERE cliente.userID=?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, userID);
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
    %>
                    <table>
                        <tr>
                            <th>Número de telemóvel</th>
                            <td><%= rs.getString("telemovelCliente") %></td>
                        </tr>
                        <tr>
                            <th>Email</th>
                            <td><%= rs.getString("emailCliente") %></td>
                        </tr>
                        <tr>
                            <th>Primeiro Nome</th>
                            <td><%= rs.getString("primeiroNomeCliente") %></td>
                        </tr>
                        <tr>
                            <th>Último Nome</th>
                            <td><%= rs.getString("ultimoNomeCliente") %></td>
                        </tr>
                        <tr>
                            <th>Email do PT</th>
                            <td><%= rs.getString("emailPT") %></td>
                        </tr>
                        <tr>
                            <th>Data de Nascimento</th>
                            <td><%= rs.getString("dataNascimento") %></td>
                        </tr>
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
    
    <h3>Objetivos Atuais:</h3>
    <table>
        <tr>
            <th>ID do objetivo</th>
            <th>Descrição</th>
        </tr>
        <%
            String NIFCliente = (String) session.getAttribute("NIFCliente");
            System.out.println(NIFCliente);

            try {
                Connection conn = LigacaoBD.getConnection();
                String sqlO = "SELECT * FROM objetivos WHERE NIFCliente=?";
                try (PreparedStatement pstmtO = conn.prepareStatement(sqlO)) {
                    pstmtO.setString(1, NIFCliente);
                    ResultSet rsO = pstmtO.executeQuery();

                    while (rsO.next()) {
        %>
                    <tr>
                        <td><%= rsO.getString("objetivoID") %></td>
                        <td><%= rsO.getString("objetivoDesc") %></td>
                    </tr>
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
    </table>
    
    <h3> Patologias Atuais: </h3>
    <table>
        <tr>
            <th>ID da patologia</th>
            <th>Data de início</th>
            <th>Data de Fim</th>
            <th>Descrição da Patologia</th>
        </tr>
        <%
            try {
                Connection conn = LigacaoBD.getConnection();
                String sqlP = "SELECT * FROM patologia WHERE NIFCliente=?";
                try (PreparedStatement pstmtP = conn.prepareStatement(sqlP)) {
                    pstmtP.setString(1, NIFCliente);
                    ResultSet rsP = pstmtP.executeQuery();

                    while (rsP.next()) {
        %>
                    <tr>
                        <td><%= rsP.getString("patologiaID") %></td>
                        <td><%= rsP.getString("dataInicioPatologia") %></td>
                        <td><%= rsP.getString("dataFimPatologia") %></td>
                        <td><%= rsP.getString("patologiaDesc") %></td>
                    </tr>
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
    </table>
    
    <br>
    <br>
    <br>
    <br>
    <br>
    
    <h1>Atualização de Perfil</h1>  
    
    <form action="atualizaPerfilServlet" method="post">
        Novo Número de telefone: <input type="text" name="novoTelefone" required><br>
        Novo Email: <input type="email" name="novoEmail" required><br>
        Novo Primeiro Nome: <input type="text" name="novoPrimeiroNome" required><br>
        Novo Último Nome: <input type="text" name="novoUltimoNome" required><br>
        Nova Data de Nascimento: <input type="date" name="novaData" required><br>
        <input type="submit" value="Atualizar Dados de Perfil">
    </form>
    <form action="atualizaObjetivosServlet" method="post">
        <br>
        <br>
        <h1> Objetivos </h1>
        <h2> Atualização de Objetivos </h2>
        Escolha o ID do objetivo a atualizar:
        <select name="objetivoID" required>
            <% 
                try {
                    Connection conn = LigacaoBD.getConnection();
                    String sql_o = "SELECT objetivoID FROM objetivos WHERE NIFCliente=?";
                    try (PreparedStatement pstmt_o = conn.prepareStatement(sql_o)) {
                        pstmt_o.setString(1, NIFCliente);
                        ResultSet rs_o = pstmt_o.executeQuery();

                        while (rs_o.next()) {
            %>
                        <option value="<%= rs_o.getString("objetivoID") %>"><%= rs_o.getString("objetivoID") %></option>
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
        </select><br>
        Nova Descrição : <input type="text" name="novaDescricao" required><br>
        <input type="submit" value="Atualizar Objetivo">
    </form>
    
    <form action="adicionarObjetivosServlet" method="post">
        <h2> Adicionar um novo Objetivo </h2>
        ID do novo objetivo : <input type="number" name="novoObjetivoID" min="1" required><br>
        Descrição do Objetivo : <input type="text" name="DescricaoNovoObjetivo" required><br>
        <input type="submit" value="Adicionar Objetivo">
    </form>
    
    <form action="removerObjetivosServlet" method="post">
        <h2> Remover um Objetivo </h2>
        Escolha o objetivo que deseja remover:
        <select name="objetivoID" required>
            <% 
                try {
                    Connection conn = LigacaoBD.getConnection();
                    String sql_o = "SELECT DISTINCT * FROM objetivos WHERE NIFCliente=?";
                    try (PreparedStatement pstmt_o = conn.prepareStatement(sql_o)) {
                        pstmt_o.setString(1, NIFCliente);
                        ResultSet rs_o = pstmt_o.executeQuery();

                        while (rs_o.next()) {
            %>
                        <option value="<%= rs_o.getString("objetivoID") %>"><%= rs_o.getString("objetivoDesc") %></option>
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
        </select><br>
        <input type="submit" value="Remover Objetivo">
    </form>
    
    <br>
    <br>
    <form action="atualizaPatologiasServlet" method="post">
        <h1> Patologias </h1>
        <h2> Atualização de Patologias </h2>
        Escolha o ID da patologia a atualizar:
        <select name="patologiaID" required>
            <% 
                try {
                    Connection conn = LigacaoBD.getConnection();
                    String sql_p = "SELECT patologiaID FROM patologia WHERE NIFCliente=?";
                    try (PreparedStatement pstmt_p = conn.prepareStatement(sql_p)) {
                        pstmt_p.setString(1, NIFCliente);
                        ResultSet rs_p = pstmt_p.executeQuery();

                        while (rs_p.next()) {
            %>
                        <option value="<%= rs_p.getString("patologiaID") %>"><%= rs_p.getString("patologiaID") %></option>
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
        </select><br>
        Descrição : <input type="text" name="novaDescricaoPatologia" required><br>
        Data de Início: <input type="datetime-local" name="novaDataInicio" required><br>
        Data de Fim: <input type="datetime-local" name="novaDataFim"><br>
        <input type="submit" value="Atualizar Patologia">
    </form>
    
    
    <form action="adicionarPatologiasServlet" method="post">
        <h2> Adicionar uma nova Patologia </h2>
        ID da Patologia: <input type="number" name="novaPatologiaID" min="1" required><br>
        Descrição da Patologia: <input type="text" name="DescricaoNovaPatologia" required><br>
        Data de início da Patologia: <input type="datetime-local" name="dataInicioNovaPatologia" required><br>
        Data de fim da Patologia: <input type="datetime-local" name="dataFimNovaPatologia" required><br>
        <input type="submit" value="Adicionar Patologia">
    </form>
    
    <form action="removerPatologiasServlet" method="post">
        <h2> Remover uma Patologia </h2>
        Escolha a patologia que deseja remover:
        <select name="patologiaID" required>
            <% 
                try {
                    Connection conn = LigacaoBD.getConnection();
                    String sql_o = "SELECT DISTINCT * FROM patologia WHERE NIFCliente=?";
                    try (PreparedStatement pstmt_o = conn.prepareStatement(sql_o)) {
                        pstmt_o.setString(1, NIFCliente);
                        ResultSet rs_o = pstmt_o.executeQuery();

                        while (rs_o.next()) {
            %>
                        <option value="<%= rs_o.getString("patologiaID") %>"><%= rs_o.getString("patologiaDesc") %></option>
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
        </select><br>
        <input type="submit" value="Remover Patologia">
    </form>
    
    <a href="cliente.jsp"> Voltar para a página Principal</a>

</body>
</html>