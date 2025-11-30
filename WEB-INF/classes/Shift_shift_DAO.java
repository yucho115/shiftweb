import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

public class Shift_shift_DAO {
    private final String URL = "jdbc:mysql://localhost/shift_sample";
    private final String USER = "root";
    private final String PASS = "Hatimura1066!";
    private Connection con = null;

    public void connect(){
        try{
            con = DriverManager.getConnection(URL, USER, PASS);
        } catch(Exception e){
            e.printStackTrace();
        }
    }

    public void insert(String email,String username,String[] dates){
        PreparedStatement ps = null;
        String insert = "INSERT INTO shift (email, username, shift_date, shift_hour ) VALUES(?, ?, ?, ?)";        

        try{
            ps = con.prepareStatement(insert);
            for(int i = 0; i < dates.length; i++){
                String[] parts = dates[i].split(" ");
                String date = parts[0];
                String hour = parts[1];
                LocalDate localDate = LocalDate.parse(date, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                Date sqlDate = Date.valueOf(localDate);

                int hourint = Integer.parseInt(hour);

                ps.setString(1, email);
                ps.setString(2, username);
                ps.setDate(3, sqlDate);
                ps.setInt(4, hourint);
                ps.executeUpdate();
            }
        } catch(Exception e){
            e.printStackTrace();
        } finally {
            try{
                if(ps != null) ps.close();
            } catch(Exception e){
                e.printStackTrace();
            }
        }
    }

    //emailから過去に提出したシフトのデータを取得する
    public ArrayList<String> select(String email,boolean bool){
        Statement stmt = null;
        ResultSet rs = null;
        String select = "SELECT shift_date, shift_hour from shift where email = '" + email + "' and is_working = '" + String.valueOf(bool) + "'";
        ArrayList<String> list = new ArrayList<>();
        Date date;
        int hour;

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(select);

            while(rs.next()){
                date = rs.getDate("shift_date");
                hour = rs.getInt("shift_hour");
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                String dateString = formatter.format(date);
                list.add(dateString + "-" + String.valueOf(hour));
            }
        } catch(Exception e){
            e.printStackTrace();
        } finally {
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            } catch(Exception e){
                e.printStackTrace();
            }
        }
        return list;
    }

    public void disconnect(){
        try{
            if(con != null) con.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}