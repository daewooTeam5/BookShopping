package domain.payment.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import domain.payment.admin.service.PaymentAdminService;

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
			@RequestParam(value = "genre", required = false) String genre,
			@RequestParam(value = "fromDate", required = false) String fromDate,
			@RequestParam(value = "toDate", required = false) String toDate,
			@RequestParam(value = "minPrice", required = false) Integer minPrice,
			@RequestParam(value = "maxPrice", required = false) Integer maxPrice, ModelAndView mv) {
		
		// 검색 조건에 맞는 결제 리스트를 가져옵니다.
		mv.addObject("paymentList",
				service.search(userName, userId, bookTitle, publisher, genre, fromDate, toDate, minPrice, maxPrice));
	    
		// 요약 정보는 서비스에서 직접 가져와 JSP에 추가합니다.
	    mv.addObject("totalCount", service.getTotalCount());
	    mv.addObject("totalAmount", service.getTotalAmount());
	    mv.addObject("topBooks", service.getTopBooks(5));
	    mv.addObject("topUsers", service.getTopUsers(5));
	    
	    mv.addObject("categorySummary", service.getCategorySummary());
	    
		mv.setViewName("/payment/admin/list");
		return mv;
	}
}
