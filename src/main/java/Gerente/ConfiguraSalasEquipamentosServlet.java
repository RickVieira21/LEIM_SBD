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

@WebServlet("/ConfiguraSalasEquipamentosServlet")
public class ConfiguraSalasEquipamentosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Recupera os parâmetros do formulário
        String nifClube = request.getParameter("nifClube");
        String idSala = request.getParameter("idSala");
        String acao = request.getParameter("acao");

        // Executa a ação correspondente (adicionar ou remover sala)
        try (Connection conn = LigacaoBD.getConnection()) {
            if ("adicionar".equals(acao)) {
                adicionarSala(conn, nifClube, idSala);
            } else if ("remover".equals(acao)) {
                removerSala(conn, nifClube, idSala);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

     // Recupera os parâmetros do formulário para equipamentos
        String nSerieEquipamento = request.getParameter("nSerie");
        String foraServicoEquipamento = request.getParameter("foraServico");
        String idSalaEquipamento = request.getParameter("idSalaEquipamento");
        String designacaoEquipamento = request.getParameter("designacao");
        String nifClubeEquipamento = request.getParameter("nifClubeEquipamento"); // Novo campo adicionado
        String acaoEquipamento = request.getParameter("acaoEquipamento");

        // Executa a ação correspondente (adicionar ou remover equipamento)
        try (Connection conn = LigacaoBD.getConnection()) {
            if ("adicionar".equals(acaoEquipamento)) {
                adicionarEquipamento(conn, nSerieEquipamento, foraServicoEquipamento, idSalaEquipamento, designacaoEquipamento, nifClubeEquipamento);
            } else if ("remover".equals(acaoEquipamento)) {
                removerEquipamento(conn, nSerieEquipamento);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }


        // Redireciona de volta para a página principal do gerente
        response.sendRedirect("gerente.jsp");
    }

    private void adicionarSala(Connection conn, String nifClube, String idSala) throws SQLException {
        String sql = "INSERT INTO sala (idSala, NIFClube) VALUES (?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, idSala);
            pstmt.setString(2, nifClube);
            pstmt.executeUpdate();
        }
    }

    private void removerSala(Connection conn, String nifClube, String idSala) throws SQLException {
        try {
            // Desativa temporariamente as verificações de chave estrangeira
            conn.createStatement().execute("SET foreign_key_checks = 0");

            // Remove equipamentos associados à sala
            String sqlRemoveEquipamentos = "DELETE FROM equipamento WHERE idSala = ?";
            try (PreparedStatement pstmtRemoveEquipamentos = conn.prepareStatement(sqlRemoveEquipamentos)) {
                pstmtRemoveEquipamentos.setString(1, idSala);
                pstmtRemoveEquipamentos.executeUpdate();
            }

            // Remove a sala
            String sqlRemoveSala = "DELETE FROM sala WHERE idSala = ? AND NIFClube = ?";
            try (PreparedStatement pstmtRemoveSala = conn.prepareStatement(sqlRemoveSala)) {
                pstmtRemoveSala.setString(1, idSala);
                pstmtRemoveSala.setString(2, nifClube);
                pstmtRemoveSala.executeUpdate();
            }
        } finally {
            // Restaura as verificações de chave estrangeira
            conn.createStatement().execute("SET foreign_key_checks = 1");
        }
    }

    private void adicionarEquipamento(Connection conn, String nSerie, String foraServico, String idSala, String designacao, String nifClube)
            throws SQLException {
        String sql = "INSERT INTO equipamento (nSerie, foraServico, idSala, designacao, nifClube) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, nSerie);
            pstmt.setString(2, foraServico);
            pstmt.setString(3, idSala);
            pstmt.setString(4, designacao);
            pstmt.setString(5, nifClube);
            pstmt.executeUpdate();
        }
    }


    private void removerEquipamento(Connection conn, String nSerie) throws SQLException {
        String sql = "DELETE FROM equipamento WHERE nSerie = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, nSerie);
            pstmt.executeUpdate();
        }
    }
}
