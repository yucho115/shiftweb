import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/insert")
public class Shift_dbinsertServlet extends HttpServlet {
  public void doPost(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {

    final String URL = "jdbc:mysql://localhost/shift_sample";
    final String USER = "root";
    final String PASS = "Hatimura1066!";
    String insert = "INSERT INTO enroll VALUES(?, ?, ?, ?)";
    String select = "SELECT email FROM enroll WHERE email = ";

    HttpSession session = req.getSession(true);
    String email = (String)session.getAttribute("email");
    String name = (String)session.getAttribute("name");
    String password = (String)session.getAttribute("password");
    String role = (String)session.getAttribute("role");

    Connection con = null;
    Statement stmt = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try{
      con = DriverManager.getConnection(URL, USER, PASS);
      stmt = con.createStatement();
      rs = stmt.executeQuery(select + "'" + email + "'");
      if(rs.next() == false){
        ps = con.prepareStatement(insert);
        ps.setString(1, email);
        ps.setString(2, name);
        ps.setString(3, password);
        ps.setString(4, role);
        ps.executeUpdate();

        RequestDispatcher rd = req.getRequestDispatcher("/dbinsert.jsp");
        rd.forward(req, res);
      } else {
        req.setAttribute("errorMessage","このメールアドレスは既に登録されています");
        RequestDispatcher rd = req.getRequestDispatcher("/shift_signup1.jsp");
        rd.forward(req, res);
      }
    } catch(Exception e){
      e.printStackTrace();
    } finally {
      try{
        if(rs != null) rs.close();
        if(stmt != null) stmt.close();
        if(ps != null) ps.close();
        if(con != null) con.close();
      } catch(Exception e){
        e.printStackTrace();
      }
    }
  }
  public void doGet(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    doPost(req, res);
  }
}