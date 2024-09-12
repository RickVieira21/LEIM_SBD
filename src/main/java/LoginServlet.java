import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Gestao.LigacaoBD;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = LigacaoBD.getConnection()) {
            String sql = "SELECT * FROM Utilizador WHERE nomeUtilizador = ? AND palavraPasse = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    // válido, obter tipo de usuário
                    String userType = rs.getString("tipo");
                    System.out.println(userType);
                    String userID = rs.getString("userID");
                    
                    HttpSession session = request.getSession();
                    session.setAttribute("userID", userID);
                    
                    String userIDobtido = (String) session.getAttribute("userID");
                    System.out.println(userIDobtido);
                    
                    if (userType.equals("Cliente")) {
                    		Statement stmtCliente = conn.createStatement();
                    		String userIDString = (String)userID;
                    		ResultSet rsCliente = stmtCliente.executeQuery("SELECT * FROM Cliente WHERE userID="+userIDString);
                    		
                    		if (rsCliente.next()) {
                    			String NIFCliente = rsCliente.getString("NIFCliente");
                    			session.setAttribute("NIFCliente", NIFCliente);
                    			String NIFClienteobtido = (String) session.getAttribute("NIFCliente");
                                System.out.println(NIFClienteobtido);
                                
                                String emailPT = rsCliente.getString("emailPT");
                                session.setAttribute("emailPT", emailPT);
                    			String emailPTobtido = (String) session.getAttribute("emailPT");
                                System.out.println(emailPTobtido);
                    		}
                    }  else if (userType.equals("PT")) {
                        Statement stmtPT = conn.createStatement();
                        String userIDString = (String) userID;
                        ResultSet rsPT = stmtPT.executeQuery("SELECT * FROM PT WHERE userID=" + userIDString);
                        
                        if (rsPT.next()) {                           
                            String emailPT = rsPT.getString("emailPT");
                            session.setAttribute("emailPT", emailPT);
                            String emailPTobtido = (String) session.getAttribute("emailPT");
                            System.out.println(emailPTobtido);
                        }
                    }
                    //System.out.print(userType);
                    redirectToRolePage(response, userType);

                } else {
                    // inválido
                    response.sendRedirect("index.jsp");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private void redirectToRolePage(HttpServletResponse response, String userType) throws IOException {
        String targetPage;
        switch (userType) {
            case "Gerente":
                targetPage = "gerente.jsp";
                break;
            case "PT":
                targetPage = "pt.jsp";
                break;
            case "Cliente":
                targetPage = "cliente.jsp";
                break;
            default:
                targetPage = "index.jsp";
                break;
        }
        response.sendRedirect(targetPage);
    }
}
