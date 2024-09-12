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

@WebServlet("/atualizaObjetivosServlet")
public class atualizaObjetivosServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		
		// Recupera os parâmetros do formulário
		String userID = (String) session.getAttribute("userID");
        String nifCliente = (String) session.getAttribute("NIFCliente");
        System.out.println("userID obtido: " + userID);
        System.out.println("NIFCliente obtido: " + nifCliente);
        
        String objetivoID = request.getParameter("objetivoID");
        String novaDescricao = request.getParameter("novaDescricao");

        // Atualiza os dados no banco de dados para o cliente selecionado pelo userID
        try (Connection conn = LigacaoBD.getConnection()) {
            //Atualiza os objetivos
            String sqlObjetivos = "UPDATE objetivos SET objetivoDesc=? WHERE objetivoID=? AND NIFCliente=?";
            try (PreparedStatement pstmtObjetivos = conn.prepareStatement(sqlObjetivos)) {
            	pstmtObjetivos.setString(1, novaDescricao);
            	pstmtObjetivos.setString(2, objetivoID);
            	pstmtObjetivos.setString(3, nifCliente);
            	pstmtObjetivos.executeUpdate();
            }
         
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Redireciona de volta para a página principal do cliente
        response.sendRedirect("cliente.jsp");
	}
}
