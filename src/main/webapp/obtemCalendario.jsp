<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>
<%@ page import="Gestao.LigacaoBD"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<html>
<head>
<title>Calendário Semanal de Atividades</title>
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
	<h1>Calendário Semanal de Atividades</h1>

	<%
	String userID = (String) session.getAttribute("userID");
	String NIFCliente = (String) session.getAttribute("NIFCliente");

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
	cal.add(Calendar.DAY_OF_WEEK, 6);
	cal.set(Calendar.HOUR_OF_DAY, 23);
	cal.set(Calendar.MINUTE, 59);
	cal.set(Calendar.SECOND, 59);
	Date fimSemana = cal.getTime();
	System.out.println(fimSemana);
	%>
	<h2>
		Atividades que serão realizadas durante esta semana (<%=formatDate(inicioSemana)%>,
		<%=formatDate(fimSemana)%>)
	</h2>

	<%
	try {
		Connection conn = LigacaoBD.getConnection();
		String sql = "SELECT * FROM disponibilidade INNER JOIN disponibilidade_cliente ON disponibilidade.dataMarcacao = disponibilidade_cliente.dataMarcacao WHERE disponibilidade_cliente.NIFCliente=? AND disponibilidade.inicia BETWEEN ? AND ?";
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, NIFCliente);
			pstmt.setTimestamp(2, new java.sql.Timestamp(inicioSemana.getTime()));
			pstmt.setTimestamp(3, new java.sql.Timestamp(fimSemana.getTime()));
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
		<%
		do {
		%>
		<tr>
			<td><%=rs.getString("tipoAtividade")%></td>
			<td><%=rs.getString("tipoEscalaoEtario")%></td>
			<td><%=rs.getString("emailPT")%></td>
			<td><%=rs.getString("maxParticipantes")%></td>
			<td><%=rs.getString("inicia")%></td>
			<td><%=rs.getString("acaba")%></td>
		</tr>
		<%
		} while (rs.next());
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

	<%!private String formatDate(Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM");
		return sdf.format(date);
	}%>
	<br>
	<a href="cliente.jsp">Voltar para a página principal</a>
</body>
</html>