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

@WebServlet("/AtualizaHorarioContatoServlet")
public class AtualizaHorarioContatoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Recupera os parâmetros do formulário
        String nifClube = request.getParameter("nifClube");
        String diaSemanaSelecionado = request.getParameter("diaSemana");
        String novoAberto = request.getParameter("novoAberto");
        String novoFechado = request.getParameter("novoFechado");
        String novoEmail = request.getParameter("novoEmail");
        String novoTelefone = request.getParameter("novoTelefone");

        // Atualiza os dados no banco de dados para o clube selecionado pelo NIF
        try (Connection conn = LigacaoBD.getConnection()) {
            // Atualiza os horários na tabela "periodo"
            String sqlHorario = "UPDATE periodo SET abrir=?, fechar=? WHERE NIFClube=? AND diaSemana=?";
            try (PreparedStatement pstmtHorario = conn.prepareStatement(sqlHorario)) {
                pstmtHorario.setString(1, novoAberto);
                pstmtHorario.setString(2, novoFechado);
                pstmtHorario.setString(3, nifClube);
                pstmtHorario.setString(4, diaSemanaSelecionado); // Substitua por sua variável de dia da semana
                pstmtHorario.executeUpdate();
            }

            // Atualiza os contatos na tabela "clube"
            String sqlContato = "UPDATE clube SET emailClube=?, telefoneClube=? WHERE NIFClube=?";
            try (PreparedStatement pstmtContato = conn.prepareStatement(sqlContato)) {
                pstmtContato.setString(1, novoEmail);
                pstmtContato.setString(2, novoTelefone);
                pstmtContato.setString(3, nifClube);
                pstmtContato.executeUpdate();
            }
            //conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Redireciona de volta para a página principal do gerente
        response.sendRedirect("gerente.jsp");
    }
}
