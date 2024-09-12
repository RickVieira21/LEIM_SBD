package PT;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

@WebServlet("/PublicarManchaServlet")
public class PublicarManchaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Recupera os parâmetros do formulário
        String dataInicioStr = request.getParameter("dataInicio");
        String dataFimStr = request.getParameter("dataFim");
        String tipoAtividade = request.getParameter("tipoAtividade");
        String tipoEscalaoEtario = request.getParameter("tipoEscalaoEtario");
        int minParticipantes = Integer.parseInt(request.getParameter("minParticipantes"));
        int maxParticipantes = Integer.parseInt(request.getParameter("maxParticipantes"));
        boolean semanal = Boolean.parseBoolean(request.getParameter("semanal"));

        // Obtém o valor de reservarSala do formulário
        String reservarSala = request.getParameter("reservarSala");

        // Obtém o NIFClube associado ao PT
        HttpSession sessin = request.getSession();
        String emailPT = (String) sessin.getAttribute("emailPT");
        String nifClube = obterNIFClube(emailPT);

        // Converte as strings de data para objetos Date
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        Date dataInicio = null;
        Date dataFim = null;
        try {
            dataInicio = dateFormat.parse(dataInicioStr);
            dataFim = dateFormat.parse(dataFimStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        // Insere na tabela Disponibilidade
        try (Connection conn = LigacaoBD.getConnection()) {
            String sqlDisponibilidade = "INSERT INTO Disponibilidade (dataMarcacao, minParticipantes, maxParticipantes, inicia, acaba, emailPT, tipoAtividade, tipoEscalaoEtario, semanal) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmtDisponibilidade = conn.prepareStatement(sqlDisponibilidade)) {
                pstmtDisponibilidade.setTimestamp(1, new java.sql.Timestamp(System.currentTimeMillis())); // dataMarcacao
                pstmtDisponibilidade.setInt(2, minParticipantes); // minParticipantes
                pstmtDisponibilidade.setInt(3, maxParticipantes); // maxParticipantes
                pstmtDisponibilidade.setTimestamp(4, new java.sql.Timestamp(dataInicio.getTime())); // inicia
                pstmtDisponibilidade.setTimestamp(5, new java.sql.Timestamp(dataFim.getTime())); // acaba
                pstmtDisponibilidade.setString(6, emailPT);
                pstmtDisponibilidade.setString(7, tipoAtividade); // tipoAtividade
                pstmtDisponibilidade.setString(8, tipoEscalaoEtario); // tipoEscalaoEtario
                pstmtDisponibilidade.setBoolean(9, semanal); // semanal

                pstmtDisponibilidade.executeUpdate();
            }

            // Verifica se o utilizador escolheu "Sim" para reservar a sala
            if ("sim".equalsIgnoreCase(reservarSala)) {
                // Obtém o idSala do formulário
                String idSala = request.getParameter("idSala");

                // Insere na tabela sala_disponibilidade
                String sqlSalaDisponibilidade = "INSERT INTO sala_disponibilidade (dataMarcacao, idSala, NIFClube) VALUES (?, ?, ?)";
                try (PreparedStatement pstmtSalaDisponibilidade = conn.prepareStatement(sqlSalaDisponibilidade)) {
                    pstmtSalaDisponibilidade.setTimestamp(1, new java.sql.Timestamp(System.currentTimeMillis())); // dataMarcacao
                    pstmtSalaDisponibilidade.setString(2, idSala); // idSala
                    pstmtSalaDisponibilidade.setString(3, nifClube); // NIFClube

                    pstmtSalaDisponibilidade.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("pt.jsp");
    }

    // Método para obter o NIFClube associado ao PT
    private String obterNIFClube(String emailPT) {
        String nifClube = "";
        String sql = "SELECT NIFClube FROM pt WHERE emailPT = ?";
        
        try (Connection conn = LigacaoBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, emailPT);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    nifClube = rs.getString("NIFClube");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return nifClube;
    }

}
