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

@WebServlet("/adicionarPatologiasServlet")
public class adicionarPatologiasServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		
		// Recupera os parâmetros do formulário
		String userID = (String) session.getAttribute("userID");
        String nifCliente = (String) session.getAttribute("NIFCliente");
        System.out.println("userID obtido: " + userID);
        System.out.println("NIFCliente obtido: " + nifCliente);
        
        String novaPatologiaID = request.getParameter("novaPatologiaID");
        String descricaoNovaPatologia = request.getParameter("DescricaoNovaPatologia");
        String dataInicioNovaPatologia = request.getParameter("dataInicioNovaPatologia");
        String dataFimNovaPatologia = request.getParameter("dataFimNovaPatologia");

        try (Connection conn = LigacaoBD.getConnection()) {
            String sqlAddObjetivo = "INSERT INTO patologia (patologiaID, dataInicioPatologia, dataFimPatologia, patologiaDesc, NIFCliente) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement pstmtAddPatologia = conn.prepareStatement(sqlAddObjetivo)) {
            	pstmtAddPatologia.setString(1, novaPatologiaID);
            	pstmtAddPatologia.setString(2, dataInicioNovaPatologia);
            	pstmtAddPatologia.setString(3, dataFimNovaPatologia);
            	pstmtAddPatologia.setString(4, descricaoNovaPatologia);
            	pstmtAddPatologia.setString(5, nifCliente);
            	pstmtAddPatologia.executeUpdate();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Redireciona de volta para a página principal do cliente
        response.sendRedirect("cliente.jsp");
	}
}
