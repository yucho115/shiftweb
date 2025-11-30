<%@page contentType="text/html;charset=utf-8" %>
<html>
    <head>
        <meta charset="utf-8">
        <title>ログイン画面</title>
        <style>
            body {
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .login-container {
                background-color: rgba(255, 255, 255, 0.9);
                border-radius: 10px;
                border: none;
                height: 600px;
                width: 400px;
                margin-top: 10%;
                margin-bottom: 10%;
            }

            .title {
                text-align: center;
            }

            .error span{
                color: red;
                width: 40%;
                font-size: 10px;
                text-align: center;
            }

            .form strong {
                font-weight: 400;
                font-size: 20px;
                margin-left: 10%;
            }

            .form span {
                color: red;
                width: 40%;
                font-size: 10px;
            }

            .form input {
                height: 30px;
                width: 80%;
                margin-left: 10%;
                margin-right: 10%;
                margin-top: 10px;
                border-radius: 10px;
                border-color: rgb(235, 232, 232);
            }

            .login-button {
                color: white;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                border: none;
                border-radius: 5px;
                height: 50px;
                width: 40%;
                margin-top: 5%;
                margin-left: 30%;
                margin-right: 30%;
                cursor: pointer;
            }

            .signup-link {
                text-align: center;
                margin-top: 10%;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="title">
                <h1>シフト管理</h1>
                <p>アカウントにログイン</p>
            </div>

            <form action="/shiftweb/login" method="post">
                <div class="error">
                <% if(request.getAttribute("enrollError") != null) { %>
                    <span>
                        <%= request.getAttribute("enrollError") %>
                    </span>
                    <br>
                <% } %>
                </div>
                <div class="form">
                    <strong>メールアドレス</strong>
                    <% if(request.getAttribute("emailError") != null) {%>
                        <span>
                            <%= request.getAttribute("emailError") %>
                        </span>
                    <% }%>
                    <br>
                    <input type="email" name="email" size="20">
                    <strong>ユーザネーム</strong>
                    <% if(request.getAttribute("nameError") != null) { %>
                        <span>
                            <%= request.getAttribute("nameError") %>
                        </span>
                    <% } %>
                    <br>
                    <input type="text" name="name" size="20">
                    <strong>パスワード</strong>
                    <% if(request.getAttribute("passError") != null) { %>
                        <span>
                            <%= request.getAttribute("passError") %>
                        </span>
                    <% } %>
                    <br>
                    <input type="password" name="password" size="20">
                </div>
                
                <button class="login-button" type="submit">ログイン</button>
            </form>

            <div class="signup-link">
                アカウントをお持ちでない方は <a href="/shiftweb/shift_signup1.jsp">サインアップ</a>
            </div>
        </div>
    </body>
</html>