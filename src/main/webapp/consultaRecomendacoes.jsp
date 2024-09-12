<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>
<%@ page import="Gestao.LigacaoBD"%>
<html>
<head>
<meta charset="UTF-8">
<title>Consulta de Recomendações</title>
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
	<h1>Recomendações indicadas pelo seu PT:</h1>

	<%
	String NIFCliente = (String) session.getAttribute("NIFCliente");
	System.out.println(NIFCliente);
	%>
	<%
	try {
		Connection conn = LigacaoBD.getConnection();
		String sql = "SELECT * FROM recomendacao WHERE NIFCliente=? AND (dataInicio <= NOW() AND (dataFim IS NULL OR dataFim >= NOW()))";
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, NIFCliente);
			ResultSet rs = pstmt.executeQuery();
	%>

	<table>
		<tr>
			<th>Data de Emissão da Recomendação</th>
			<th>Email do PT</th>
			<th>Tipo de Equipamento</th>
			<th>Utilizar(1) ou Evitar(0)?</th>
			<th>Data de Início</th>
			<th>Data de Fim</th>
		</tr>
		<%
		while (rs.next()) {
		%>
		<tr>
			<td><%=rs.getString("dataEmissao")%></td>
			<td><%=rs.getString("emailPT")%></td>
			<td><%=rs.getString("designacao")%></td>
			<td><%=rs.getString("recomendado")%></td>
			<td><%=rs.getString("dataInicio")%></td>
			<td><%=rs.getString("dataFim")%></td>
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
	<a href="cliente.jsp"> Voltar para a Página Principal</a>
</body>
</html>