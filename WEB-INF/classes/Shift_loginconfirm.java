import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.util.ArrayList;

@WebServlet("/login")
public class Shift_loginconfirm extends HttpServlet {
  public void doPost(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    req.setCharacterEncoding("utf-8");

    String email = req.getParameter("email");
    String name = req.getParameter("name");
    String password = req.getParameter("password");

    boolean hasError = false;
    if(email == null||email.isEmpty()){
      req.setAttribute("emailError","メールアドレスを入力してください");
      hasError = true;
    }
    if(name == null||name.isEmpty()){
      req.setAttribute("nameError","ユーザネームを入力してください");
      hasError = true;
    }
    if(password == null||password.isEmpty()){
      req.setAttribute("passError","パスワードを入力してください");
      hasError = true;
    }
    if(hasError){
      RequestDispatcher rd = req.getRequestDispatcher("/shift_login.jsp");
      rd.forward(req, res);
      return;
    }

    Shift_DAO dao = new Shift_DAO();
    HttpSession session = req.getSession(true);
    String[] result = new String[3];
    String name_enrolled;
    String pass_enrolled;
    String role_enrolled;

    dao.connect();
    result = dao.select(email);
    name_enrolled = result[0];
    pass_enrolled = result[1];
    role_enrolled = result[2];

    if(name_enrolled.equals(name) && pass_enrolled.equals(password)){
      session.setAttribute("role",role_enrolled);
      session.setAttribute("name",name_enrolled);
      session.setAttribute("email",email);
      System.out.println("労働者");
      System.out.println(role_enrolled);
      if(role_enrolled.equals("労働者")){
        ServletContext app = getServletContext();
        ArrayList<String> shiftFalse = new ArrayList<>();
        ArrayList<String> shiftTrue = new ArrayList<>();

        shiftFalse = dao.select(email, false);
        shiftTrue = dao.select(email, true);
        app.setAttribute("shiftFalse", shiftFalse);
        app.setAttribute("shiftTrue", shiftTrue);
        RequestDispatcher rd = req.getRequestDispatcher("/shift_employee.jsp");
        rd.forward(req, res);
      }else if(role_enrolled.equals("雇用者")){
        RequestDispatcher rd = req.getRequestDispatcher("/shift_employer.jsp");
        rd.forward(req, res);
      }
    }else{
      req.setAttribute("enrollError","メールアドレスまたはユーザネームまたはパスワードが正しくありません");
      RequestDispatcher rd = req.getRequestDispatcher("/shift_login.jsp");
      rd.forward(req, res);
    }

    dao.disconnect();
  }
  public void doGet(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    doPost(req, res);
  }
}