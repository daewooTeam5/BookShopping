package payment.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/payment/admin")
public class PaymentAdminContoller {
	private PaymentAdminService service;
	
	@Autowired
	public PaymentAdminContoller(PaymentAdminService service) {
		this.service = service;
	}
	
	@RequestMapping("list")
	public ModelAndView list(ModelAndView mv) {
		mv.addObject("paymentList", service.findAll());
		mv.setViewName("/payment/admin/list");
		return mv;
	}
}
