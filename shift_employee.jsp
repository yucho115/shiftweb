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

            .estimate {
                margin-left: 50%;
            }

            .setting-container {
                background-color: rgba(255, 255, 255, 0.9);
                width: 90%;
                height: 100px;
                border-radius: 5px;
                margin-left: 5%;
                margin-right: 5%;
                margin-top: 90px;
            }

            .setting-container h3 {
                margin-left: 10px;
            }

            .setting-container input {
                margin-left: 10px;
                margin-right: 10px;
                width: calc(100% - 20px);
                height: 40px;
            }

            .calendar {
                background-color: rgba(255, 255, 255, 0.9);
                width: 90%;
                height: 400px;
                border-radius: 5px;
                margin-left: 5%;
                margin-right: 5%;
                margin-top: 30px;
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

            .time-clicked {
                background-color: rgba(255, 255, 255, 0.9);
                width: 90%;
                height: 400px;
                margin-left: 5%;
                margin-top: 30px;
                border-radius: 5px;
            }

            .time strong {
                margin-left: 10px;
            }

            .time-table-clicked {
                display: flex;
                justify-content: center;
                align-items: center;
                height: calc(100% - 23px);
            }

            .time-chart-clicked {
                width: calc(100% - 20px);
                height: 100%;
            }

            .time-table td button {
                width: 100%;
                height: 100%;
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
            <div class="estimate">予想収入</div>
        </header>
        <div class="setting-container">
            <h3>時給設定(円)</h3>
            <input type="number" id="payment">
        </div>

        <div class="calendar">
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

        <div class="time" id="time">
            <strong id="monthYearTime"></strong>
            <div class="time-table" id="time-table">
                <table class="time-chart" id="time-chart">
                    <thead>
                    </thead>
                    <tbody id="time-manage">
                    </tbody>
                </table>
            </div>
        </div>

        <form action="/shiftweb/Shift_submit" method="post" id="form">
            <input class="submit-button" type="submit" value="提出">
        </form>

        <script>
            const shiftFalse = <%= new com.google.gson.Gson().toJson((java.util.ArrayList<String>)application.getAttribute("shiftFalse"))  %>;
            const shiftTrue = <%= new com.google.gson.Gson().toJson((java.util.ArrayList<String>)application.getAttribute("shiftTrue")) %>;

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
                    button.id = y +  "_" + m + "_" + date;
                    button.textContent = date;

                    const prefix = y + "-" + pad((m+1)) + "-" + pad(date);
                    if(shiftFalse.some(s => s.startsWith(prefix))){
                        button.style.backgroundColor = "red";
                    }

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
                    const clickedButton = document.getElementById(clickedId);

                    if(selectedDateButton && selectedDateButton !== clickedButton && selectedDateButton.classList.contains("clicked")){
                        selectedDateButton.classList.remove("clicked");
                        selectedDateButton.classList.add("clicked-fade");
                    }

                    clickedButton.classList.add("clicked");
                    selectedDateButton = clickedButton;
                    
                    const [year, month, day] = clickedId.split("_");

                    document.getElementById("time").classList.add("time-clicked");
                    document.getElementById("time-table").classList.add("time-table-clicked");
                    document.getElementById("time-chart").classList.add("time-chart-clicked");

                    const date = document.getElementById("monthYearTime");
                    date.textContent = year + "-" + (parseInt(month)+1) + "-" + day + " のシフト";

                    const timeTable = document.getElementById("time-manage");
                    timeTable.innerHTML = "";
                    for(let i = 0; i<12;i++){
                        let row = document.createElement("tr");
                        for(let j = 0;j<2;j++){
                            let cell = document.createElement("td");
                            let button = document.createElement("button");
                            button.id = clickedId + "_" + (2*i+j);
                            button.textContent = (2*i+j) + ":00";

                            const shiftKey = year + "-" + pad(parseInt(month)+1) + "-" + pad(day) + "-" + String(2*i+j);
                            if(shiftFalse.includes(shiftKey)){
                                button.style.backgroundColor = "red";
                            }

                            cell.appendChild(button);
                            row.appendChild(cell);
                        }
                        timeTable.appendChild(row);
                    }
                }
            });

            document.getElementById("time-manage").addEventListener("click", (e) => {
                if(e.target.tagName === "BUTTON") {
                    const clickedId = e.target.id;
                    const datebutton = document.getElementById(clickedId);

                    datebutton.classList.toggle("clicked");

                    const [year,month,day,hour] = clickedId.split("_");
                    const name = year + "_" + month + "_" + day;
                    const date = document.getElementById(name);
                    date.classList.add("clicked-fade");

                    const form = document.getElementById("form");

                    if(datebutton.classList.contains("clicked")){
                        const input = document.createElement("input");
                        input.type = "hidden";
                        input.value = year + "-" + pad((parseInt(month)+1)) + "-" + pad(day) + " " + hour;
                        input.name = "shift";
                        input.id = "input_" + clickedId;
                        form.appendChild(input);
                    } else {
                        const oldInput = document.getElementById("input_" + clickedId);
                        if(oldInput){
                            form.removeChild(oldInput);
                        }
                    }
                }
            });

        </script>
    </body>
</html>