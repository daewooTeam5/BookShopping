package user;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;





@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    UserService service;

    @RequestMapping("login")
    public String login() {
        return "loginform";
    }
    
    @GetMapping("/mypage")
    public String mypage() {
        return "mypage";//my page로 넘기기
    }
    
    @GetMapping("create")
    public String create() {
        return "create";//my page로 넘기기
    }
   
 
}
