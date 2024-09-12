package Gerente;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import Gestao.LigacaoBD;

@WebServlet("/ConfiguraConteudoServlet")
@MultipartConfig
public class ConfiguraConteudoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Recupera os parâmetros do formulário
        String designacaoConteudo = request.getParameter("designacaoConteudo");
        String conteudoID = request.getParameter("conteudoID");
        String acaoConteudo = request.getParameter("acaoConteudo");

        // Executa a ação correspondente (adicionar ou remover)
        try (Connection conn = LigacaoBD.getConnection()) {
            if ("adicionar".equals(acaoConteudo)) {
                adicionarConteudo(conn, designacaoConteudo, conteudoID, request.getPart("demonstracao"), request.getPart("fotografia"));
            } else if ("remover".equals(acaoConteudo)) {
                removerConteudo(conn, conteudoID);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Redireciona de volta para a página principal do gerente
        response.sendRedirect("gerente.jsp");
    }

    private void adicionarConteudo(Connection conn, String designacaoConteudo, String conteudoID, Part videoPart, Part imagemPart)
            throws SQLException, IOException, ServletException {
        // Define os diretórios de upload para vídeo e imagem
        String uploadDir = getServletContext().getRealPath("/uploads");
        Path videoUploadPath = Paths.get(uploadDir, "videos");
        Path imagemUploadPath = Paths.get(uploadDir, "imagens");

        // Cria diretorias se não existirem
        Files.createDirectories(videoUploadPath);
        Files.createDirectories(imagemUploadPath);

        // Obtém os nomes dos arquivos de vídeo e imagem
        String videoFileName = conteudoID + "_video.mp4";
        String imagemFileName = conteudoID + "_imagem.jpg";

        // Faz o upload dos arquivos
        uploadArquivo(videoPart, videoUploadPath.resolve(videoFileName));
        uploadArquivo(imagemPart, imagemUploadPath.resolve(imagemFileName));

        // Insere os dados na tabela "conteudo"
        String sql = "INSERT INTO conteudo (designacao, conteudoID, demonstracao, fotografia) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, designacaoConteudo);
            pstmt.setString(2, conteudoID);
            pstmt.setString(3, "uploads/videos/" + videoFileName);
            pstmt.setString(4, "uploads/imagens/" + imagemFileName);
            pstmt.executeUpdate();
        }
    }

    private void removerConteudo(Connection conn, String conteudoID) throws SQLException {
        // Remove os dados da tabela "conteudo"
        String sql = "DELETE FROM conteudo WHERE conteudoID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, conteudoID);
            pstmt.executeUpdate();
        }
    }

    private void uploadArquivo(Part part, Path path) throws IOException {
        try (InputStream input = part.getInputStream()) {
            Files.copy(input, path, StandardCopyOption.REPLACE_EXISTING);
        }
    }
}
