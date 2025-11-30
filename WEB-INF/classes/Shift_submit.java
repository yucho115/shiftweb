import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.util.ArrayList;

@WebServlet("/Shift_submit")
public class Shift_submit extends HttpServlet {
  public void doPost(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    req.setCharacterEncoding("utf-8");
    ServletContext app = getServletContext();
    HttpSession session = req.getSession(true);
    String email = (String)session.getAttribute("email");
    String username = (String)session.getAttribute("name");
    String[] date = req.getParameterValues("shift");


    Shift_DAO dao = new Shift_DAO();
    dao.connect();
    dao.insert(email,username,date);

    ArrayList<String> shiftFalse = new ArrayList<>();
    ArrayList<String> shiftTrue = new ArrayList<>();

    shiftFalse = dao.select(email, false);
    shiftTrue = dao.select(email, true); 
    dao.disconnect();

    app.setAttribute("shiftFalse", shiftFalse);
    app.setAttribute("shiftTrue", shiftTrue);
    RequestDispatcher rd = req.getRequestDispatcher("/shift_employee.jsp");
      rd.forward(req, res);
  }
  public void doGet(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    doPost(req, res);
  }
}