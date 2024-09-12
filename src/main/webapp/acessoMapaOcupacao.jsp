<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="Gestao.LigacaoBD" %>
<html>
<head>
    <title>Aceder ao Mapa Semanal de Ocupação das Salas</title>
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
    <h1>Aceder ao Mapa Semanal de Ocupação das Salas</h1>
    
     <!-- Lista de todos os clubes -->
    <h2>Lista de Clubes</h2>
    <table border="1">
        <tr>
            <th>NIF do Clube</th>
            <th>Latitude</th>
            <th>Longitude</th>
            <th>Telefone do Clube</th>
            <th>Artéria</th>
            <th>Número</th>
            <th>Andar</th>
            <th>Localidade</th>
            <th>Código Postal</th>
            <th>Código Postal Auxiliar</th>
            <th>Email do Clube</th>
            <th>Designação Comercial</th>
        </tr>
        <% 
            try {
                Connection conn = LigacaoBD.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rsClubes = stmt.executeQuery("SELECT * FROM clube");

                while (rsClubes.next()) {
        %>
                    <tr>
                        <td><%= rsClubes.getString("NIFClube") %></td>
                        <td><%= rsClubes.getString("latitude") %></td>
                        <td><%= rsClubes.getString("longitude") %></td>
                        <td><%= rsClubes.getString("telefoneClube") %></td>
                        <td><%= rsClubes.getString("arteria") %></td>
                        <td><%= rsClubes.getString("numero") %></td>
                        <td><%= rsClubes.getString("andar") %></td>
                        <td><%= rsClubes.getString("localidade") %></td>
                        <td><%= rsClubes.getString("codPostal") %></td>
                        <td><%= rsClubes.getString("codPostalAux") %></td>
                        <td><%= rsClubes.getString("emailClube") %></td>
                        <td><%= rsClubes.getString("designacaoComercial") %></td>
                    </tr>
        <%
                }
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    </table>

    <!-- Formulário para escolher o clube -->
    <form action="AcessoMapaOcupacaoServlet" method="post">
        Escolha o Clube (NIF): <input type="text" name="nifClube" required>
        <input type="submit" value="Ver Mapa Semanal">
    </form>

	<!-- Lista de salas usadas durante a semana atual -->
	<h2>Salas Usadas na Semana Atual</h2>
	<table border="1">
	    <tr>
	        <th>ID da Sala</th>
	        <th>Data de início da Atividade</th>
	    </tr>
	    <%
	        // Recupera o NIF do clube escolhido
	        String nifClube = request.getParameter("nifClube");
	
	        // Obtém a data de início da semana atual
	    	Calendar cal = Calendar.getInstance();
	    	cal.setFirstDayOfWeek(Calendar.MONDAY);
	    	cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
	    	cal.set(Calendar.HOUR_OF_DAY, 0);
	    	cal.set(Calendar.MINUTE, 0);
	    	cal.set(Calendar.SECOND, 0);
	    	Date inicioSemana = cal.getTime();
	    	System.out.println(inicioSemana);

	    	// Obtém a data de fim da semana atual
	    	cal.add(Calendar.DAY_OF_WEEK, 7);
	    	cal.set(Calendar.HOUR_OF_DAY, 23);
	    	cal.set(Calendar.MINUTE, 59);
	    	cal.set(Calendar.SECOND, 59);
	    	Date fimSemana = cal.getTime();
	    	System.out.println(fimSemana);
	
	        // Consulta as salas usadas durante a semana atual para o clube escolhido
	        try {
		        Connection conn = LigacaoBD.getConnection();
		        String sql = "SELECT sala_disponibilidade.idSala, disponibilidade.inicia " +
		                "FROM sala_disponibilidade " +
		                "INNER JOIN disponibilidade ON sala_disponibilidade.dataMarcacao = disponibilidade.dataMarcacao " +
		                "WHERE sala_disponibilidade.NIFClube = ? AND disponibilidade.dataHoraConfirmacao IS NOT NULL AND disponibilidade.inicia BETWEEN ? AND ?";

		        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
		            pstmt.setString(1, nifClube);
		            pstmt.setDate(2, new java.sql.Date(inicioSemana.getTime()));
	                pstmt.setDate(3, new java.sql.Date(fimSemana.getTime()));
		
		            ResultSet rsSalas = pstmt.executeQuery();
		
		            if (!rsSalas.next()) {
		                // Sem resultados, exibe mensagem de debug
		    %>
		                <tr>
		                    <td colspan="2">Nenhuma sala usada na semana atual para o clube escolhido.</td>
		                </tr>
		    <%
		            } else {
		                // Exibe resultados
		                do {
		    %>
		                    <tr>
						        <td><%= rsSalas.getString("idSala") %></td>
						        <td><%= rsSalas.getString("inicia") %></td>
						    </tr>
		    <%
		                } while (rsSalas.next());
		            }
		        }
		        conn.close();
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		%>
	</table>
	<br>
	<a href="gerente.jsp"> Voltar para a página principal</a>
</body>
</html>
