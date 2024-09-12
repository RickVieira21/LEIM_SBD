package Gerente;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Gestao.LigacaoBD;

@WebServlet("/AcessoMapaOcupacaoServlet")
public class AcessoMapaOcupacaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nifClube = request.getParameter("nifClube");

        // Verifica se o NIF do clube é válido 
        if (nifClube != null && !nifClube.isEmpty()) {
        	
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

            // Obtém as salas usadas durante a semana atual para o clube escolhido
            try (Connection conn = LigacaoBD.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement("SELECT sala_disponibilidade.idSala, disponibilidade.inicia " +
    		                "FROM sala_disponibilidade " +
    		                "INNER JOIN disponibilidade ON sala_disponibilidade.dataMarcacao = disponibilidade.dataMarcacao " +
    		                "WHERE sala_disponibilidade.NIFClube = ? AND disponibilidade.dataHoraConfirmacao IS NOT NULL AND disponibilidade.inicia BETWEEN ? AND ?")) {
                pstmt.setString(1, nifClube);
                pstmt.setDate(2, new java.sql.Date(inicioSemana.getTime()));
                pstmt.setDate(3, new java.sql.Date(fimSemana.getTime()));

                ResultSet rsSalas = pstmt.executeQuery();
                
                request.setAttribute("rsSalas", rsSalas);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Redireciona de volta para o JSP
        request.getRequestDispatcher("acessoMapaOcupacao.jsp").forward(request, response);
    }
}
