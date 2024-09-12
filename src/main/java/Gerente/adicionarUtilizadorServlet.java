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

@WebServlet("/adicionarUtilizadorServlet")
public class adicionarUtilizadorServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String novoUserID = request.getParameter("novoUserID");
        System.out.println(novoUserID);
        String novoNomeUtilizador = request.getParameter("novoNomeUtilizador");
        System.out.println(novoNomeUtilizador);
        String novaPalavraPasse = request.getParameter("novaPalavraPasse");
        System.out.println(novaPalavraPasse);
        String novoTipo = request.getParameter("novoTipo");
        System.out.println(novoTipo);

        try (Connection conn = LigacaoBD.getConnection()) {
            String sqlAddUtilizador = "INSERT INTO Utilizador (userID, nomeUtilizador, palavraPasse, tipo) VALUES (?, ?, ?, ?)";
            try (PreparedStatement pstmtAddUtilizador = conn.prepareStatement(sqlAddUtilizador)) {
            	pstmtAddUtilizador.setString(1, novoUserID);
            	pstmtAddUtilizador.setString(2, novoNomeUtilizador);
            	pstmtAddUtilizador.setString(3, novaPalavraPasse);
            	pstmtAddUtilizador.setString(4, novoTipo);
            	pstmtAddUtilizador.executeUpdate();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("gerente.jsp");
	}
}