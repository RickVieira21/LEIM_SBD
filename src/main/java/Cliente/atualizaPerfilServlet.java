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

@WebServlet("/atualizaPerfilServlet")
public class atualizaPerfilServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		
		// Recupera os parâmetros do formulário
		String userID = (String) session.getAttribute("userID");
        String nifCliente = (String) session.getAttribute("NIFCliente");
        System.out.println("userID obtido: " + userID);
        System.out.println("NIFCliente obtido: " + nifCliente);
        
        String novoTelefone = request.getParameter("novoTelefone");
        String novoEmail = request.getParameter("novoEmail");
        String novoPrimeiroNome = request.getParameter("novoPrimeiroNome");
        String novoUltimoNome = request.getParameter("novoUltimoNome");
        String novaData = request.getParameter("novaData");
        
        try (Connection conn = LigacaoBD.getConnection()) {
            String sqlPerfilCliente = "UPDATE cliente SET telemovelCliente=?, emailCliente=?, primeiroNomeCliente=?, ultimoNomeCliente=?, dataNascimento=? WHERE userID=? AND NIFCliente=?";
            try (PreparedStatement pstmtPerfilCliente = conn.prepareStatement(sqlPerfilCliente)) {
            	pstmtPerfilCliente.setString(1, novoTelefone);
            	pstmtPerfilCliente.setString(2, novoEmail);
            	pstmtPerfilCliente.setString(3, novoPrimeiroNome);
            	pstmtPerfilCliente.setString(4, novoUltimoNome);
            	pstmtPerfilCliente.setString(5, novaData);
            	pstmtPerfilCliente.setString(6, userID);
            	pstmtPerfilCliente.setString(7, nifCliente);
            	pstmtPerfilCliente.executeUpdate();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Redireciona de volta para a página principal do cliente
        response.sendRedirect("cliente.jsp");
	}
}
