<%@page contentType="text/html;charset=utf-8" %>
<html>
    <head>
        <meta charset="utf-8">
        <title>signup</title>
        <style>
            body {
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .container {
                background-color: rgba(255, 255, 255, 0.9);
                border-radius: 5px;
                margin-top: 10%;
                margin-bottom: 10%;
                height: 500px;
                width: 600px;

            }

            .title {
                text-align: center;
                color: rgba(0, 0, 0, 0.743);
            }

            .info {
                margin-top: 5%;
            }

            .info strong {
                font-weight: 400;
                font-size: 20px;
                margin-left: 10%;
            }

            .info span {
                margin-left: 10%;
            }

            .submit-button {
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

        </style>
    </head>
    <body>
        <div class="container">
            <div class="title">
                <h1>入力情報を確認してください</h1>
            </div>
            <div class="info">
                <strong>ユーザタイプ</strong><br>
                <span><%= session.getAttribute("role") %></span><br>
                <strong>メールアドレス:</strong><br>
                <span><%= session.getAttribute("email") %></span><br>
                <strong>ユーザネーム</strong><br>
                <span><%= session.getAttribute("name") %></span><br>
                <strong>パスワード</strong><br>
                <span><%= session.getAttribute("password") %></span><br>
            </div>

            <form action="/shiftweb/insert" method="post">
                <input class="submit-button" type="submit" value="登録">
            </form>
        </div>
    </body>
</html>