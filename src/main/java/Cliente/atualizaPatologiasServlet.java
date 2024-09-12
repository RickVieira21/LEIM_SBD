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

@WebServlet("/atualizaPatologiasServlet")
public class atualizaPatologiasServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		
		// Recupera os parâmetros do formulário
		String userID = (String) session.getAttribute("userID");
        String nifCliente = (String) session.getAttribute("NIFCliente");
        System.out.println("userID obtido: " + userID);
        System.out.println("NIFCliente obtido: " + nifCliente);
         
        String patologiaID = request.getParameter("patologiaID");
        String novaDescricaoPatologia = request.getParameter("novaDescricaoPatologia");
        String novaDataInicio = request.getParameter("novaDataInicio");
        String novaDataFim = request.getParameter("novaDataFim");

        // Atualiza os dados no banco de dados para o cliente selecionado pelo userID
        try (Connection conn = LigacaoBD.getConnection()) {
          //Atualiza as patologias
            String sqlPatologias = "UPDATE patologia SET dataInicioPatologia=?, dataFimPatologia=?, patologiaDesc=? WHERE patologiaID=? AND NIFCliente=?";
            try (PreparedStatement pstmtPatologias = conn.prepareStatement(sqlPatologias)) {
            	pstmtPatologias.setString(1, novaDataInicio);
                pstmtPatologias.setString(2, novaDataFim);
            	pstmtPatologias.setString(3, novaDescricaoPatologia);
            	pstmtPatologias.setString(4, patologiaID);
            	pstmtPatologias.setString(5, nifCliente);
            	pstmtPatologias.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Redireciona de volta para a página principal do cliente
        response.sendRedirect("cliente.jsp");
	}
}