package user.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import user.dto.UserRegisterForm;
import user.entity.UserEntity;

@Mapper
public interface UserMapper {

	@Insert("INSERT INTO users (user_id, name, password, user_role) VALUES (#{userId},#{name}, #{password}, #{userRole})")
	Integer save(UserRegisterForm user);
	
	@Select("SELECT * from users where user_id=#{userId}")
	@Results({
	    @Result(property = "userId", column = "user_id"),
	    @Result(property = "userRole", column = "user_role"),
	    @Result(property = "createdAt", column = "created_at")
	})
	UserEntity findByUserId(String userId);
}
