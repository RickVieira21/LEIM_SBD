package Gestao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class LigacaoBD {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/sbd_leim52d_49705_45871_tp2?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "tpsbd";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found.", e);
        }
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace(); 
            }
        }
    }
    
    public static ResultSet getQueryResult(String QUERY, Connection connection) throws SQLException {
    	List<String> emailList = new ArrayList<>();
    	try {
    		Statement stmt = connection.createStatement();
        	ResultSet rs = stmt.executeQuery(QUERY);

    		while (rs.next()) {
    			String email = rs.getString("Email");
                emailList.add(email);	
			}
    		
    		for (String email : emailList) {
                System.out.println("Email: " + email);
            }
        	return rs;
		} catch (SQLException e) {
			throw new SQLException(e);
		}
	}
}