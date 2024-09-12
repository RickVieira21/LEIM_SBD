package Cliente;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Gestao.LigacaoBD;

@WebServlet("/adicionarObjetivosServlet")
public class adicionarObjetivosServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		
		// Recupera os parâmetros do formulário
		String userID = (String) session.getAttribute("userID");
        String nifCliente = (String) session.getAttribute("NIFCliente");
        System.out.println("userID obtido: " + userID);
        System.out.println("NIFCliente obtido: " + nifCliente);
        
        String novoObjetivoID = request.getParameter("novoObjetivoID");
        String descricaoNovoObjetivo = request.getParameter("DescricaoNovoObjetivo");

        try (Connection conn = LigacaoBD.getConnection()) {
            String sqlAddObjetivo = "INSERT INTO objetivos (NIFCliente, objetivoID, objetivoDesc) VALUES (?, ?, ?)";
            try (PreparedStatement pstmtAddObjetivo = conn.prepareStatement(sqlAddObjetivo)) {
            	pstmtAddObjetivo.setString(1, nifCliente);
            	pstmtAddObjetivo.setString(2, novoObjetivoID);
            	pstmtAddObjetivo.setString(3, descricaoNovoObjetivo);
            	pstmtAddObjetivo.executeUpdate();
            }   
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("cliente.jsp");
	}
}