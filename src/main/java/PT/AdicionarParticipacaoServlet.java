package PT;

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

@WebServlet("/AdicionarParticipacaoServlet")
public class AdicionarParticipacaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nifCliente = request.getParameter("cliente");
        String dataMarcacao = request.getParameter("manchaDisponibilidade");

        adicionarParticipacao(nifCliente, dataMarcacao);

        // Redireciona de volta para a página de agenda após o agendamento
        response.sendRedirect("agendaParticipacao.jsp");
    }

    private void adicionarParticipacao(String nifCliente, String dataMarcacao) {
        String sql = "INSERT INTO disponibilidade_cliente (dataMarcacao, NIFCliente) VALUES (?, ?)";

        try (Connection conn = LigacaoBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, dataMarcacao);
            pstmt.setString(2, nifCliente);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
