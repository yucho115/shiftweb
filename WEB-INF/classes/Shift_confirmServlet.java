import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/confirm")
public class Shift_confirmServlet extends HttpServlet {
  public void doPost(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    req.setCharacterEncoding("utf-8");
    HttpSession session = req.getSession(true);

    String email = req.getParameter("email");
    String name = req.getParameter("name");
    String password = req.getParameter("password");
    String role = req.getParameter("role");

    boolean hasError = false;
    if(role == null||role.isEmpty()){
      req.setAttribute("roleError","ユーザタイプを選択してください");
      hasError = true;
    }
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
      RequestDispatcher rd = req.getRequestDispatcher("/shift_signup1.jsp");
      rd.forward(req, res);
      return;
    }

    if(role.equals("employer")){
      role = "雇用者";
    }else if(role.equals("employee")){
      role = "労働者";
    }

    session.setAttribute("email",email);
    session.setAttribute("name", name);
    session.setAttribute("password", password);
    session.setAttribute("role", role);

    
    RequestDispatcher rd = req.getRequestDispatcher("/confirm.jsp");
    rd.forward(req, res);
  }
  public void doGet(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    doPost(req, res);
  }
}