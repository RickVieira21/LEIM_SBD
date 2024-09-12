package PT;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Gestao.LigacaoBD;

@WebServlet("/DetalhesClienteServlet")
public class DetalhesClienteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtém o primeiro e último nome do cliente selecionado
        String primeiroNome = request.getParameter("primeiroNome");
        String ultimoNome = request.getParameter("ultimoNome");

        // Obtém o NIF do cliente com base no primeiro e último nome
        String nifCliente = obterNIFCliente(primeiroNome, ultimoNome);

        // Obtém e exibe os detalhes do cliente (objetivos e patologias)
        String detalhesCliente = obterDetalhesCliente(nifCliente);

        // Envia a resposta ao cliente
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println(detalhesCliente);
        }
    }

    private String obterNIFCliente(String primeiroNome, String ultimoNome) {
        String nifCliente = null;
        String sql = "SELECT NIFCliente FROM cliente WHERE primeiroNomeCliente = ? AND ultimoNomeCliente = ?";

        try (Connection conn = LigacaoBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, primeiroNome);
            pstmt.setString(2, ultimoNome);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    nifCliente = rs.getString("NIFCliente");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return nifCliente;
    }

    private String obterDetalhesCliente(String nifCliente) {
        // Lógica para consultar o banco de dados e obter os detalhes do cliente
        String detalhes = "";
        String sqlCliente = "SELECT * FROM cliente WHERE NIFCliente = ?";
        String sqlObjetivos = "SELECT * FROM objetivos WHERE NIFCliente = ?";
        String sqlPatologias = "SELECT * FROM patologia WHERE NIFCliente = ?";

        try (Connection conn = LigacaoBD.getConnection();
             PreparedStatement pstmtCliente = conn.prepareStatement(sqlCliente);
             PreparedStatement pstmtObjetivos = conn.prepareStatement(sqlObjetivos);
             PreparedStatement pstmtPatologias = conn.prepareStatement(sqlPatologias)) {

            pstmtCliente.setString(1, nifCliente);
            pstmtObjetivos.setString(1, nifCliente);
            pstmtPatologias.setString(1, nifCliente);

            try (ResultSet rsCliente = pstmtCliente.executeQuery();
                 ResultSet rsObjetivos = pstmtObjetivos.executeQuery();
                 ResultSet rsPatologias = pstmtPatologias.executeQuery()) {

                // Adiciona detalhes do cliente
                detalhes += "<h2>Detalhes do Cliente</h2>";
                while (rsCliente.next()) {
                	String NIFCliente = rsCliente.getString("NIFCliente");
                	String telemovelCliente = rsCliente.getString("telemovelCliente");
                	String email = rsCliente.getString("emailCliente");
                    String primeiroNome = rsCliente.getString("primeiroNomeCliente");
                    String ultimoNome = rsCliente.getString("ultimoNomeCliente");
                    String emailPT = rsCliente.getString("emailPT");
                    
                   
                    detalhes += "<p>NIF: " + NIFCliente + "</p>";
                    detalhes += "<p>Telemovel: " + telemovelCliente + "</p>";
                    detalhes += "<p>Email: " + email + "</p>";
                    detalhes += "<p>Nome: " + primeiroNome + " " + ultimoNome + "</p>";
                    detalhes += "<p>EmailPT: " + emailPT + "</p>";
                }

                // Adiciona detalhes de objetivos
                detalhes += "<h3>Objetivos:</h3>";
                while (rsObjetivos.next()) {
                    String objetivoID = rsObjetivos.getString("objetivoID");
                    String objetivoDesc = rsObjetivos.getString("objetivoDesc");
                    detalhes += "<p>Objetivo ID: " + objetivoID + ", Descrição: " + objetivoDesc + "</p>";
                }

                // Adiciona detalhes de patologias
                detalhes += "<h3>Patologias:</h3>";
                while (rsPatologias.next()) {
                    String patologiaID = rsPatologias.getString("patologiaID");
                    String dataInicio = rsPatologias.getString("dataInicioPatologia");
                    String dataFim = rsPatologias.getString("dataFimPatologia");
                    String patologiaDesc = rsPatologias.getString("patologiaDesc");
                    detalhes += "<p>Patologia ID: " + patologiaID + ", Data Início: " + dataInicio +
                                ", Data Fim: " + dataFim + ", Descrição: " + patologiaDesc + "</p>";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return detalhes;
    }

}
