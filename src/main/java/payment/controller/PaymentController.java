// src/main/java/payment/controller/PaymentController.java
package payment.controller;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import payment.service.PaymentService;


@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;


    @PostMapping("/buyNow")
    public void buyNow(@RequestParam("bookId") Long bookId,
                       @RequestParam(value = "accountId", defaultValue = "1") Long accountId, // 임시로 accountId=1 사용
                       HttpServletResponse response) throws IOException {
        
        boolean success = paymentService.processSinglePurchase(accountId, bookId);
        
        response.setContentType("text/html; charset=UTF-8");
        if (success) {
            response.getWriter().println("<script>alert('구매가 완료되었습니다.'); location.href='/book/list';</script>");
        } else {
            response.getWriter().println("<script>alert('구매에 실패했습니다.'); history.back();</script>");
        }
    }



    @PostMapping("/buyFromCart")
    public void buyFromCart(@RequestParam(value = "accountId", defaultValue = "5") Long accountId, // 임시로 accountId=1 사용

                            HttpServletResponse response) throws IOException {

        boolean success = paymentService.processCartPurchase(accountId);
        
        response.setContentType("text/html; charset=UTF-8");
        if (success) {
            response.getWriter().println("<script>alert('장바구니의 모든 상품을 구매했습니다.'); location.href='/book/list';</script>"); // 성공 시 이동할 페이지
        } else {
            response.getWriter().println("<script>alert('구매에 실패했습니다. 장바구니가 비어있을 수 있습니다.'); history.back();</script>");
        }
    }
}