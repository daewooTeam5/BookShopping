package payment.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
	public ModelAndView list(@RequestParam(value = "userName", required = false) String userName,
			@RequestParam(value = "userId", required = false) String userId,
			@RequestParam(value = "bookTitle", required = false) String bookTitle,
			@RequestParam(value = "publisher", required = false) String publisher,
			@RequestParam(value = "fromDate", required = false) String fromDate,
			@RequestParam(value = "toDate", required = false) String toDate,
			@RequestParam(value = "minPrice", required = false) Integer minPrice,
			@RequestParam(value = "maxPrice", required = false) Integer maxPrice, ModelAndView mv) {
		
		System.out.println(userName+"=======================");
		mv.addObject("paymentList",
				service.search(userName, userId, bookTitle, publisher, fromDate, toDate, minPrice, maxPrice));
	    mv.addObject("totalCount", service.getTotalCount());
	    mv.addObject("totalAmount", service.getTotalAmount());
	    mv.addObject("topBooks", service.getTopBooks(5));
	    mv.addObject("topUsers", service.getTopUsers(5));
		mv.setViewName("/payment/admin/list");
		return mv;
	}
}
