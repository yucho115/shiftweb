<%@page contentType="text/html;charset=utf-8" %>
<html>
    <head>
        <meta charset="utf-8">
        <title>個人画面</title>
        <style>
            body {
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            }

            header {
                position: fixed;
                background-color: rgba(255, 255, 255, 1);
                top: 0;
                left: 0;
                width: 100%;
                height: 60px;
                display: flex;
                align-items: center;
            }

            .title {
                font-size: 35px;
            }

            .calendar {
                background-color: rgba(255, 255, 255, 0.9);
                width: 90%;
                height: 400px;
                border-radius: 5px;
                margin-left: 5%;
                margin-right: 5%;
                margin-top: 80px;
            }

            .calendar-title{
                margin-top: 10px;
                margin-left: 10px;
                margin-right: 10px;
                width: calc(100% - 20px);
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin: 10px;
            }

            .monthYear {
                flex: 1;
                text-align: center;
                font-weight: bold;
            }

            .calendar table{
                margin-top: 10px;
                margin-bottom: 10px;
                margin-left: 10px;
                margin-right: 10px;
                width: calc(100% - 20px);
                height: calc(100% - 40px);
            }

            .calendar td button {
                width: 100%;
                height: 100%;
            }

            .clicked {
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            }

            .clicked-fade {
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                opacity: 0.6;
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
        <header>
            <div class="title">
                <strong><%= session.getAttribute("name") %></strong>さん
            </div>
        </header>

        <div class="calendar">
            <form action="/shiftweb/Shift_search" method="post" id="form-search">
            </form>
            <div class="calendar-title">
                <button class="btn-left" id="prior">＜</button><span class="monthYear" id="monthYear"></span><button class="btn-right" id="later">＞</button>
            </div>
            <table>
                <thead>
                    <tr id="day">
                        <th>日</th><th>月</th><th>火</th><th>水</th><th>木</th><th>金</th><th>土</th>
                    </tr>
                </thead>
                <tbody id = "calendar-body">
                </tbody>
            </table>
        </div>

        <form action="/shiftweb/Shift_finalize" method="post" id="form">
            <input class="submit-button" type="submit" value="提出">
        </form>

        <script>
            const pad = n => n.toString().padStart(2,'0');

            const today = new Date();
            let currentYear = today.getFullYear();
            let currentMonth = today.getMonth();

            function renderCalendar(y, m){
                document.getElementById("monthYear").textContent = y + "年 " + (m + 1) + "月";

                const firstDay = new Date(y, m , 1).getDay();
                const lastDay = new Date(y, m + 1, 0).getDate();

                const calendarBody = document.getElementById("calendar-body");
                calendarBody.innerHTML = "";
                let row = document.createElement("tr");

                for(let i = 0; i < firstDay; i++){
                    row.appendChild(document.createElement("td"));
                }

                for(let date = 1; date <= lastDay; date++){
                    let cell = document.createElement("td");
                    let button = document.createElement("button");
                    button.type = "button";
                    button.id = y +  "_" + m + "_" + date;
                    button.textContent = date;

                    cell.appendChild(button);

                    row.appendChild(cell);
                    if((firstDay + date) % 7 === 0){
                        calendarBody.appendChild(row);
                        row = document.createElement("tr");
                    }
                }

                if(row.children.length > 0){
                    calendarBody.appendChild(row);
                }
            }

            const primonth = document.getElementById("prior");
            const latmonth = document.getElementById("later");

            primonth.addEventListener("click", () => {
                currentMonth--;
                if(currentMonth < 0){
                    currentMonth = 11;
                    currentYear--;
                }
                renderCalendar(currentYear, currentMonth);
            });

            latmonth.addEventListener("click", () => {
                currentMonth++;
                if(currentMonth > 11){
                    currentMonth = 0;
                    currentYear++;
                }
                renderCalendar(currentYear, currentMonth);
            });

            renderCalendar(currentYear, currentMonth);

            let selectedDateButton = null;
            document.getElementById("calendar-body").addEventListener("click", (e) => {
                if(e.target.tagName === "BUTTON") {
                    const clickedId = e.target.id;

                    const [year, month, day] = clickedId.split("_");
                
                    const form = document.getElementById("form-search");
                    form.innerHTML = "";

                    const input = document.createElement("input");
                    input.type = "hidden";
                    input.value = year + "-" + pad((parseInt(month)+1)) + "-" + pad(day);
                    input.name = "date";
                    form.appendChild(input);

                    form.submit();

                    const member = <%= new com.google.gson.Gson().toJson((java.util.ArrayList<String>)session.getAttribute("member"))  %>;

                }
            });
            

        </script>
    </body>
</html>