<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="Gestao.LigacaoBD" %>
<html>
<head>
    <title>Configurar Salas e Equipamentos</title>
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
    <h1>Configurar Salas e Equipamentos</h1>

    <h2>Lista de Clubes</h2>
    <table border="1">
        <tr>
            <th>NIF do Clube</th>
            <th>Salas</th>
        </tr>
        <% 
            try {
                Connection conn = LigacaoBD.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM clube");

                while (rs.next()) {
                    String nifClube = rs.getString("NIFClube");
        %>
                    <tr>
                        <td><%= nifClube %></td>
                        <td>
                            <ul>
                                <% 
                                    // Consulta as salas do clube atual
                                    PreparedStatement pstmtSalas = conn.prepareStatement("SELECT * FROM sala WHERE NIFClube = ?");
                                    pstmtSalas.setString(1, nifClube);
                                    ResultSet rsSalas = pstmtSalas.executeQuery();

                                    while (rsSalas.next()) {
                                        String idSala = rsSalas.getString("idSala");
                                %>
                                        <li><%= idSala %></li>
                                <%
                                    }
                                    pstmtSalas.close();
                                %>
                            </ul>
                        </td>
                    </tr>
        <%
                }
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    </table>

    <h2>Adicionar/Remover Salas</h2>
    <form action="ConfiguraSalasEquipamentosServlet" method="post">
        NIF do Clube: <input type="text" name="nifClube" required><br>
        ID da Sala: <input type="text" name="idSala" required><br>
        Ação: 
        <select name="acao">
            <option value="adicionar">Adicionar</option>
            <option value="remover">Remover</option>
        </select><br>
        <input type="submit" value="Executar Ação">
    </form>

	<h2>Lista de Equipamentos</h2>
	<table border="1">
	    <tr>
	        <th>Número de Série</th>
	        <th>Fora de Serviço</th>
	        <th>ID da Sala</th>
	        <th>Designação</th>
	        <th>NIF do Clube</th> 
	    </tr>
	    <% 
	        try {
	            Connection conn = LigacaoBD.getConnection();
	            Statement stmt = conn.createStatement();
	            ResultSet rsEquipamentos = stmt.executeQuery("SELECT * FROM equipamento");
	
	            while (rsEquipamentos.next()) {
	    %>
	                <tr>
	                    <td><%= rsEquipamentos.getString("nSerie") %></td>
	                    <td><%= rsEquipamentos.getString("foraServico") %></td>
	                    <td><%= rsEquipamentos.getString("idSala") %></td>
	                    <td><%= rsEquipamentos.getString("designacao") %></td>
	                    <td><%= rsEquipamentos.getString("nifClube") %></td> 
	                </tr>
	    <%
	            }
	            conn.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    %>
	</table>
	
	<h2>Adicionar/Remover Equipamentos</h2>
	<form action="ConfiguraSalasEquipamentosServlet" method="post">
	    Número de Série: <input type="text" name="nSerie" required><br>
	    Fora de Serviço: <input type="text" name="foraServico"><br>
	    ID da Sala: <input type="text" name="idSalaEquipamento"><br>
	    Designação: <input type="text" name="designacao"><br>
	    NIF do Clube: <input type="text" name="nifClubeEquipamento"><br> 
	    Ação: 
	    <select name="acaoEquipamento">
	        <option value="adicionar">Adicionar</option>
	        <option value="remover">Remover</option>
	    </select><br>
	    <input type="submit" value="Executar Ação">
	</form>

	<h2>Lista de Conteúdo</h2>
	<table border="1">
	    <tr>
	        <th>Designação</th>
	        <th>ID do Conteúdo</th>
	        <th>Demonstração</th>
	        <th>Fotografia</th>
	    </tr>
	    <% 
	        try {
	            Connection conn = LigacaoBD.getConnection();
	            Statement stmt = conn.createStatement();
	            ResultSet rsConteudo = stmt.executeQuery("SELECT * FROM conteudo");
	
	            while (rsConteudo.next()) {
	    %>
	                <tr>
	                    <td><%= rsConteudo.getString("designacao") %></td>
	                    <td><%= rsConteudo.getString("conteudoID") %></td>
	                    <td>
	                        <video width="100" height="100" controls>
	                            <source src="<%= rsConteudo.getString("demonstracao") %>" type="video/mp4">
	                        </video>
	                    </td>
	                    <td><img src="<%= rsConteudo.getString("fotografia") %>" alt="Fotografia" width="100" height="100"></td>
	                </tr>
	    <%
	            }
	            conn.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    %>
	</table>

    <h2>Adicionar/Remover Conteúdo</h2>
    <form action="ConfiguraConteudoServlet" method="post" enctype="multipart/form-data">
        Designação: <input type="text" name="designacaoConteudo" required><br>
        ID do Conteúdo: <input type="text" name="conteudoID" required><br>
        Demonstração (Vídeo): <input type="file" name="demonstracao" accept="video/*"><br>
        Fotografia: <input type="file" name="fotografia" accept="image/*"><br>
        Ação: 
        <select name="acaoConteudo">
            <option value="adicionar">Adicionar</option>
            <option value="remover">Remover</option>
        </select><br>
        <input type="submit" value="Executar Ação">
    </form>
    <br>
    <a href="gerente.jsp"> Voltar para a página principal</a>
</body>
</html>
