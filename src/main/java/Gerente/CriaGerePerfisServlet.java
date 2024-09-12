package Gerente;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.transform.TransformerException;


import Gestao.LigacaoBD;

@WebServlet("/CriaGerePerfisServlet")
@MultipartConfig
public class CriaGerePerfisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getPart("xmlFile") != null) {
            importarPerfis(request.getPart("xmlFile").getInputStream());
        } 
        else if ("true".equals(request.getParameter("export"))) {
        	String userIDExport = request.getParameter("exportUserID");
            //System.out.println("UserID Export: " + userIDExport);
            exportarPerfis(response, userIDExport);      
        }

        // Redireciona de volta para a página principal do gerente ou para outra página, se necessário
        response.sendRedirect("gerente.jsp");
    }

    
    
    private void exportarPerfis(HttpServletResponse response, String userIDExport) throws IOException {
        response.setContentType("text/xml");
        response.setHeader("Content-Disposition", "attachment;filename=perfis_exportados.xml");

        try (PrintWriter out = response.getWriter(); Connection conn = LigacaoBD.getConnection()) {
            Document doc = criarDocumentoXML(conn, userIDExport);

            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer transformer = tf.newTransformer();
            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(out);

            transformer.transform(source, result);
        } catch (SQLException | TransformerException e) {
            e.printStackTrace();
        }
        response.sendRedirect("gerente.jsp");
    }

    private Document criarDocumentoXML(Connection conn, String userIDExport) {
        Document doc = null;
        try {
            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

            doc = docBuilder.newDocument();
            Element rootElement = doc.createElement("Perfis");
            doc.appendChild(rootElement);

            String sql = "SELECT * FROM Utilizador WHERE userID = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, userIDExport);
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    Element utilizadorElement = doc.createElement("Utilizador");
                    rootElement.appendChild(utilizadorElement);

                    // Adiciona elementos ao nó Utilizador
                    adicionarElementoXML(doc, utilizadorElement, "userID", rs.getString("userID"));
                    adicionarElementoXML(doc, utilizadorElement, "nomeUtilizador", rs.getString("nomeUtilizador"));
                    adicionarElementoXML(doc, utilizadorElement, "palavraPasse", rs.getString("palavraPasse"));
                    adicionarElementoXML(doc, utilizadorElement, "tipo", rs.getString("tipo"));
                }
            }
        } catch (ParserConfigurationException | SQLException e) {
            e.printStackTrace();
        }

        return doc;
    }



    private void adicionarElementoXML(Document doc, Element parentElement, String tagName, String textContent) {
        Element element = doc.createElement(tagName);
        element.appendChild(doc.createTextNode(textContent));
        parentElement.appendChild(element);
    }

    private void importarPerfis(InputStream xmlInputStream) {
        try {
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(xmlInputStream);
            doc.getDocumentElement().normalize();

            NodeList nodeList = doc.getElementsByTagName("Utilizador");

            for (int temp = 0; temp < nodeList.getLength(); temp++) {
                Node node = nodeList.item(temp);

                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    Element element = (Element) node;

                    String userID = element.getElementsByTagName("userID").item(0).getTextContent();
                    String nomeUtilizador = element.getElementsByTagName("nomeUtilizador").item(0).getTextContent();
                    String palavraPasse = element.getElementsByTagName("palavraPasse").item(0).getTextContent();
                    String tipo = element.getElementsByTagName("tipo").item(0).getTextContent();

                    inserirUtilizador(userID, nomeUtilizador, palavraPasse, tipo);
                }
            }
        } catch (ParserConfigurationException | SAXException | IOException | SQLException e) {
            e.printStackTrace();
        }
    }

    private void inserirUtilizador(String userID, String nomeUtilizador, String palavraPasse, String tipo)
            throws SQLException {
        try (Connection conn = LigacaoBD.getConnection()) {
            String sql = "INSERT INTO Utilizador (userID, nomeUtilizador, palavraPasse, tipo) VALUES (?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, userID);
                pstmt.setString(2, nomeUtilizador);
                pstmt.setString(3, palavraPasse);
                pstmt.setString(4, tipo);
                pstmt.executeUpdate();
            }
        }
    }
}
