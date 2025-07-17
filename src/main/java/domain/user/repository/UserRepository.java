package domain.user.repository;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import domain.user.dto.UserRegisterForm;
import domain.user.entity.UserEntity;

@Mapper
public interface UserRepository {

	@Insert("INSERT INTO account (user_id, name, password, user_role) VALUES (#{userId},#{name}, #{password}, #{userRole})")
	Integer save(UserRegisterForm user);
	
	@Select("SELECT * from account where user_id=#{userId}")
	@Results({
	    @Result(property = "userId", column = "user_id"),
	    @Result(property = "userRole", column = "user_role"),
	    @Result(property = "createdAt", column = "created_at")
	})
	UserEntity findByUserId(String userId);
	
	@Select("SELECT id FROM account WHERE user_id=#{userId}")
	Long getUserId(String userId);
	
}
