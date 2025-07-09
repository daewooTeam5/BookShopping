package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


@Repository("oracleUserDAO")
public class OracleUserDAO implements UserDAO{
	
	@Autowired
	DataSource ds;
	 @Override
	    public int login(int id) {
	        User u = null;
	        String sql = "SELECT * FROM account WHERE id = ?";

	        try (Connection conn = ds.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setInt(1, id);//id 1개만 물어보면 되니까
	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                u = new User();
	                u.setId(rs.getInt("id"));
	                u.setUserid(rs.getString("userid"));
	                u.setPassword(rs.getString("password"));
	                u.setName(rs.getString("name"));  
	                u.setUser_role(rs.getString("user_role"));
	                u.setCreated_at(rs.getDate("created_at"));
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return 0;
	    }
	    
	    
	    
	}

	

