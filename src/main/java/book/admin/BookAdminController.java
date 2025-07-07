package book.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/book/admin")
public class BookAdminController {
	private BookAdminService service;
	
	@Autowired
	public BookAdminController(BookAdminService service) {
		this.service = service;
	}
	
	@RequestMapping("list")
	public ModelAndView list(ModelAndView mv){
		mv.addObject("list", service.findAll());
		mv.setViewName("book/admin/list");
		return mv;
	}
}
