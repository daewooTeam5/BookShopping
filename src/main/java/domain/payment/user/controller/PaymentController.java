package domain.payment.user.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import domain.payment.user.service.PaymentService;
import domain.user.mapper.UserMapper;


@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private UserMapper userMapper; // 사용자 ID를 가져오기 위해 UserMapper를 주입합니다.


    @PostMapping("/buyNow")
    public void buyNow(@RequestParam("bookId") Long bookId,
                       Authentication authentication, // SecurityContext에서 현재 사용자 정보를 가져옵니다.
                       HttpServletResponse response) throws IOException {

        // 1. 현재 로그인한 사용자의 ID(accountId)를 조회합니다.
        String currentUserId = authentication.getName();
        Long accountId = userMapper.getUserId(currentUserId);
        
        // 2. 조회한 accountId를 사용하여 구매를 처리합니다.
        boolean success = paymentService.processSinglePurchase(accountId, bookId);
        
        response.setContentType("text/html; charset=UTF-8");
        if (success) {
            response.getWriter().println("<script>alert('구매가 완료되었습니다.'); location.href='/book/list';</script>");
        } else {
            response.getWriter().println("<script>alert('구매에 실패했습니다.'); history.back();</script>");
        }
    }



    @PostMapping("/buyFromCart")
    public void buyFromCart(Authentication authentication, // SecurityContext에서 현재 사용자 정보를 가져옵니다.
                            HttpServletResponse response) throws IOException {
        
        // 1. 현재 로그인한 사용자의 ID(accountId)를 조회합니다.
        String currentUserId = authentication.getName();
        Long accountId = userMapper.getUserId(currentUserId);

        // 2. 조회한 accountId를 사용하여 장바구니 구매를 처리합니다.
        boolean success = paymentService.processCartPurchase(accountId);
        
        response.setContentType("text/html; charset=UTF-8");
        if (success) {
            response.getWriter().println("<script>alert('장바구니의 모든 상품을 구매했습니다.'); location.href='/book/list';</script>"); // 성공 시 이동할 페이지
        } else {
            response.getWriter().println("<script>alert('구매에 실패했습니다. 장바구니가 비어있을 수 있습니다.'); history.back();</script>");
        }
    }
}