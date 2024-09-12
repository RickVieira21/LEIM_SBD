package PT;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Gestao.LigacaoBD;

@WebServlet("/AdicionarRecomendacaoServlet")
public class AdicionarRecomendacaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtém os parâmetros do formulário
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dataEmissao = sdf.format(new Date());

        String dataInicio = request.getParameter("dataInicio");
        String dataFim = request.getParameter("dataFim");
        System.out.println(dataFim);

        HttpSession session = request.getSession();
        String emailPT = (String) session.getAttribute("emailPT");

        String NIFCliente = request.getParameter("NIFCliente");
        String designacao = request.getParameter("designacao");
        String recomendado = request.getParameter("recomendado");

        // Verifica se dataFim não foi preenchido
        Timestamp timestampDataFim = null;
        if (dataFim != null && !dataFim.isEmpty()) {
            // Converte a string para um objeto Timestamp
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                Date parsedDate = dateFormat.parse(dataFim);
                timestampDataFim = new Timestamp(parsedDate.getTime());
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }

        // Adiciona a recomendação à tabela
        adicionarRecomendacao(dataEmissao, dataInicio, timestampDataFim, emailPT, NIFCliente, designacao, recomendado);

        // Redireciona de volta para a página de recomendações
        response.sendRedirect("fazRecomendacoes.jsp");
    }

    private void adicionarRecomendacao(String dataEmissao, String dataInicio, Timestamp dataFim,
            String emailPT, String NIFCliente, String designacao, String recomendado) {
        try (Connection conn = LigacaoBD.getConnection()) {
            // Insere a recomendação na tabela
            String sql = "INSERT INTO recomendacao (dataEmissao, dataInicio, dataFim, emailPT, NIFCliente, designacao, recomendado) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, dataEmissao);
                pstmt.setString(2, dataInicio);
                if (dataFim != null) {
                    pstmt.setObject(3, dataFim);
                } else {
                    pstmt.setNull(3, Types.TIMESTAMP);
                }
                pstmt.setString(4, emailPT);
                pstmt.setString(5, NIFCliente);
                pstmt.setString(6, designacao);
                pstmt.setString(7, recomendado);
                pstmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
