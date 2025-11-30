import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

public class Shift_DAO {
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

    public String[] select(String email){
        Statement stmt = null;
        ResultSet rs = null;
        String[] result = new String[3];
        String sql = "SELECT username, password, usertype from enroll where email = '" + email + "'";

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(sql);
            if(rs.next()){
                result[0] = rs.getString("username");
                result[1] = rs.getString("password");
                result[2] = rs.getString("usertype");
            } else {
                result[0] = "";
                result[1] = "";
                result[2] = "";
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return result;
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

    //雇用者用 
    //すべての労働者のusernameを取得する
    public ArrayList<String> selectFromRole(String role){
        PreparedStatement ps = null;
        ResultSet rs = null;
        String select = "SELECT username from enroll where usertype = ?";
        ArrayList<String> list = new ArrayList<>();

        try{
            ps = con.prepareStatement(select);
            ps.setString(1, role);
            rs = ps.executeQuery();

            while(rs.next()){
                list.add(rs.getString("username"));
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs != null) rs.close();
                if(ps != null) ps.close();
            } catch (Exception e){
                e.printStackTrace();
            }
        }
        return list;
    }

    //usernameと日付からselect
    public ArrayList<Integer> selectFromEmail_Date(String name,String date,boolean bool){
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<Integer> list = new ArrayList<>();
        LocalDate localDate = LocalDate.parse(date, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        Date sqlDate = Date.valueOf(localDate);
        String select = "SELECT shift_hour from shift where username = ? and shift_date = ? and is_working = ?";

        try{
            ps = con.prepareStatement(select);
            ps.setString(1, name);
            ps.setDate(2, sqlDate);
            ps.setBoolean(3, bool);
            rs = ps.executeQuery();

            while(rs.next()){
                list.add(rs.getInt("shift_hour"));
            }
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            try{
                if(rs != null) rs.close();
                if(ps != null) ps.close();
            }catch(Exception e){
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