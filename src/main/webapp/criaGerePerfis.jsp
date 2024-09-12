<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="Gestao.LigacaoBD" %>
<html>
<head>
    <title>Criar/Gerir Perfis de Utilizadores</title>
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
    <h1>Criar/Gerir Perfis de Utilizadores</h1>

    <h2>Lista de Utilizadores</h2>
    <table border="1">
        <tr>
            <th>User ID</th>
            <th>Nome de Utilizador</th>
            <th>Palavra-passe</th>
            <th>Tipo</th>
        </tr>
        <% 
            try {
                Connection conn = LigacaoBD.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rsUtilizadores = stmt.executeQuery("SELECT * FROM Utilizador");

                while (rsUtilizadores.next()) {
        %>
                    <tr>
                        <td><%= rsUtilizadores.getString("userID") %></td>
                        <td><%= rsUtilizadores.getString("nomeUtilizador") %></td>
                        <td><%= rsUtilizadores.getString("palavraPasse") %></td>
                        <td><%= rsUtilizadores.getString("tipo") %></td>
                    </tr>
        <%
                }
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    </table>

	<h2>Importar/Exportar Perfis via XML</h2>
	<form action="CriaGerePerfisServlet" method="post" enctype="multipart/form-data">
	    <label for="xmlFile">Escolha um ficheiro XML:</label>
	    <input type="file" name="xmlFile" accept=".xml" required><br>
	    <input type="submit" value="Importar Perfis">
	</form>
	
	<form action="CriaGerePerfisServlet" method="post" enctype="multipart/form-data">
	    <input type="hidden" name="export" value="true">
	    <label for="exportUserID">Escolha o userID para exportar:</label>
	    <input type="text" name="exportUserID" required><br>	
	    <input type="submit" value="Exportar Perfis">
	</form>
	
	<form action="adicionarUtilizadorServlet" method="post">
	<h2> Adicionar um novo Utilizador </h2>
		ID do novo utilizador: <input type="number" name="novoUserID" min="1" required><br>
        Nome de Utilizador: <input type="text" name="novoNomeUtilizador" required><br>
        Palavra-Passe: <input type="text" name="novaPalavraPasse" required ><br>
        Tipo de Utilizador:
        <select name="novoTipo" required>
            <% 
                try {
                    Connection conn = LigacaoBD.getConnection();
                    String sql_o = "SELECT DISTINCT * FROM tipoUtilizador";
                    try (PreparedStatement pstmt_o = conn.prepareStatement(sql_o)) {
                        ResultSet rs_o = pstmt_o.executeQuery();

                        while (rs_o.next()) {
            %>
                        <option value="<%= rs_o.getString("tipo") %>"><%= rs_o.getString("tipo") %></option>
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
        <input type="submit" value="Criar Utilizador">
	</form>
	<br>
	
	<h2> Remover um Utilizador</h2>
	<form action="removerUtilizadorServlet" method="post">
		ID do utilizador a remover:
        <select name="userID" required>
            <% 
                try {
                    Connection conn = LigacaoBD.getConnection();
                    String sql_o = "SELECT DISTINCT userID FROM Utilizador";
                    try (PreparedStatement pstmt_o = conn.prepareStatement(sql_o)) {
                        ResultSet rs_o = pstmt_o.executeQuery();

                        while (rs_o.next()) {
            %>
                        <option value="<%= rs_o.getString("userID") %>"><%= rs_o.getString("userID") %></option>
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
        <input type="submit" value="Remover Utilizador">
	</form>
	
	<a href="gerente.jsp"> Voltar para a página principal</a>
	
	<script>
        function mostrarCamposCliente() {
            var tipoUtilizador = document.getElementById("tipoUtilizador").value;
            var camposCliente = document.getElementById("camposCliente");

            if (tipoUtilizador === "cliente") {
                camposCliente.style.display = "block";
            } else {
                camposCliente.style.display = "none";
            }
        }
    </script>
</body>
</html>