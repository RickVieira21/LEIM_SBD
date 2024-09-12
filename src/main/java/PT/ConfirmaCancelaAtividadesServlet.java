package PT;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Gestao.LigacaoBD;

@WebServlet("/ConfirmaCancelaAtividadesServlet")
public class ConfirmaCancelaAtividadesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verifica se o botão de confirmação foi pressionado
        if (request.getParameter("confirmar") != null) {
        	System.out.print("1");
            confirmarAtividades(request);
        } else if (request.getParameter("cancelar") != null) {
        	System.out.print("2");
            cancelarAtividades(request);
        }

        // Redireciona de volta para a página principal do gerente
        response.sendRedirect("pt.jsp");
    }

    private void confirmarAtividades(HttpServletRequest request) {
        String dataMarcacao = request.getParameter("dataMarcacaoConfirmar");
       	System.out.print(dataMarcacao);

        // Lógica para confirmar atividades selecionadas
        try (Connection conn = LigacaoBD.getConnection()) {
            String sql = "UPDATE Disponibilidade SET dataHoraConfirmacao = ? WHERE dataMarcacao = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, getCurrentDateTime());
                pstmt.setString(2, dataMarcacao);
                pstmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void cancelarAtividades(HttpServletRequest request) {
        String dataMarcacao = request.getParameter("dataMarcacaoCancelar");

        // Lógica para cancelar atividades selecionadas
        try (Connection conn = LigacaoBD.getConnection()) {
            String sql = "UPDATE Disponibilidade SET dataHoraCancelamento = ? WHERE dataMarcacao = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, getCurrentDateTime());
                pstmt.setString(2, dataMarcacao);
                pstmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private String getCurrentDateTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(new Date());
    }
}
