package Gerente;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Gestao.LigacaoBD;

@WebServlet("/ConsultaTop5EquipamentosServlet")
public class ConsultaTop5EquipamentosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nifClube = request.getParameter("nifClube");

        // Consulta as entradas de sala_disponibilidade no último trimestre
        String sql = "SELECT * FROM sala_disponibilidade " +
                     "WHERE NIFClube = ? AND dataMarcacao BETWEEN ? AND ?";

        try (Connection conn = LigacaoBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // Configurar os parâmetros da consulta
            pstmt.setString(1, nifClube);
            pstmt.setString(2, getFirstDayOfLastQuarter());
            pstmt.setString(3, getCurrentDate());

            // Executar a consulta
            ResultSet rs = pstmt.executeQuery();
            
            
            
            
            /**********************************************************/
            
            
            

            // Armazenar as datas de marcação
            List<String> datasMarcacao = new ArrayList<>();
            while (rs.next()) {
                datasMarcacao.add(rs.getString("dataMarcacao"));
            }

            // Consultar a tabela disponibilidade usando as datas de marcação
            List<Integer> duracoes = new ArrayList<>();
            for (String dataMarcacao : datasMarcacao) {
                String disponibilidadeSql = "SELECT * FROM disponibilidade " +
                        "WHERE dataMarcacao = ?";
                try (PreparedStatement pstmtDisponibilidade = conn.prepareStatement(disponibilidadeSql)) {
                    pstmtDisponibilidade.setString(1, dataMarcacao);
                    ResultSet rsDisponibilidade = pstmtDisponibilidade.executeQuery();

                    if (rsDisponibilidade.next()) {
                        String inicia = rsDisponibilidade.getString("inicia");
                        String acaba = rsDisponibilidade.getString("acaba");
                        int duracao = calcularDuracao(inicia, acaba);
                        duracoes.add(duracao);
                    }
                }
            }

            // Redirecionar para o JSP com os resultados
            request.setAttribute("resultadosSalaDisponibilidade", rs);
            request.setAttribute("resultadosDuracao", duracoes);
            request.getRequestDispatcher("consultaTop5Equipamentos.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private int calcularDuracao(String inicia, String acaba) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            Date dataInicio = sdf.parse(inicia);
            Date dataFim = sdf.parse(acaba);
            long diferencaMillis = dataFim.getTime() - dataInicio.getTime();
            // Calcular a diferença em minutos
            return (int) (diferencaMillis / (60 * 1000));
        } catch (ParseException e) {
            e.printStackTrace();
            return 0; // ou outra manipulação de erro desejada
        }
    }


    private String getFirstDayOfLastQuarter() {
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1; // Calendar.MONTH é baseado em zero
        int quarterStartMonth = ((currentMonth - 1) / 3) * 3;

        // Se estivermos em janeiro, retroceder para o último trimestre do ano anterior
        if (currentMonth == 1) {
            quarterStartMonth = 9; // 9 corresponde a outubro (último trimestre do ano anterior)
            cal.add(Calendar.YEAR, -1);
        }

        cal.set(Calendar.MONTH, quarterStartMonth);
        cal.set(Calendar.DAY_OF_MONTH, 1);

        Date firstDayOfLastQuarter = cal.getTime();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(firstDayOfLastQuarter);
    }

    private String getCurrentDate() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(new Date());
    }
}
