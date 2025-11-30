import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.util.ArrayList;

@WebServlet("/Shift_search")
public class Shift_search extends HttpServlet {
  public void doPost(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    req.setCharacterEncoding("utf-8");
    HttpSession session = req.getSession(true);
    String date = req.getParameter("date");

    Shift_DAO dao = new Shift_DAO();
    dao.connect();

    ArrayList<String> member = new ArrayList<>();

    member = dao.selectFromRole("労働者");
    session.setAttribute("member", member);
    int length = member.size();
    for(int i = 0; i<length; i++){
        session.setAttribute(member.get(i),dao.selectFromEmail_Date(member.get(i), date, false));
    }

    RequestDispatcher rd = req.getRequestDispatcher("/shift_employer.jsp");
      rd.forward(req, res);
  }
  public void doGet(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    doPost(req, res);
  }
}