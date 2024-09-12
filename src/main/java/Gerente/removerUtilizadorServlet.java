package Gerente;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Gestao.LigacaoBD;

@WebServlet("/removerUtilizadorServlet")
public class removerUtilizadorServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userID = request.getParameter("userID");

        try (Connection conn = LigacaoBD.getConnection()) {
            String sqlAddUtilizador = "DELETE FROM Utilizador WHERE userID=?";
            try (PreparedStatement pstmtAddUtilizador = conn.prepareStatement(sqlAddUtilizador)) {
            	pstmtAddUtilizador.setString(1, userID);
            	pstmtAddUtilizador.executeUpdate();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("gerente.jsp");
	}
}