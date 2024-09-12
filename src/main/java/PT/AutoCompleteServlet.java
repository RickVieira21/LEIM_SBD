package PT;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Gestao.LigacaoBD;

@WebServlet("/AutoCompleteServlet")
public class AutoCompleteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String termoPesquisa = request.getParameter("nomeCliente");
        List<String> sugestoes = consultarBancoDeDados(termoPesquisa);

        // Transforma a lista de sugestões em uma string separada por vírgulas
        String sugestoesString = String.join(",", sugestoes);

        response.setContentType("text/plain");
        response.getWriter().write(sugestoesString);
    }

    public List<String> consultarBancoDeDados(String termoPesquisa) {
        List<String> sugestoes = new ArrayList<>();

        // Ajuste a consulta SQL conforme necessário
        String sql = "SELECT primeiroNomeCliente, ultimoNomeCliente FROM cliente " +
                     "WHERE CONCAT(primeiroNomeCliente, ' ', ultimoNomeCliente) LIKE ?";

        try (Connection conn = LigacaoBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, termoPesquisa + "%"); // O "%" garante correspondência parcial

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String nomeCompleto = rs.getString("primeiroNomeCliente") + " " +
                                          rs.getString("ultimoNomeCliente");
                    sugestoes.add(nomeCompleto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return sugestoes;
    }
}
