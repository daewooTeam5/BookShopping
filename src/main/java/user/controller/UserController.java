package user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import user.dto.UserRegisterForm;
import user.entity.UserEntity;
import user.service.UserService;

@Controller
public class UserController {

    @Autowired
    private UserService userService;
    @GetMapping("user/login")
    public String loginRedirect() {
        return "redirect:/login"; 
    }
    @GetMapping("/user/my-page")
    public String myPage(Authentication authentication, Model model) {
    	String userId = authentication.getName();
    	UserEntity user = userService.findByUserId(userId);
    	model.addAttribute("user", user);
    	return "user/mypage";
    }

    @GetMapping("/login")
    public String login() {
        return "user/login"; 
    }
  
    @GetMapping("/register")
    public String registerForm() {
        return "user/register";
    }

    @PostMapping("/register")
    public String register(UserRegisterForm user) {
    	System.out.println(user);
        userService.registerUser(user);
        return "redirect:/login"; 
    }
}
