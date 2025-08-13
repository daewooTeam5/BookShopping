package domain.payment.user.controller;

import domain.address.entity.Address;
import domain.address.service.AddressService;
import domain.payment.user.service.PaymentService;
import domain.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;
    @Autowired
    private UserRepository userMapper;
    @Autowired
    private AddressService addressService;

    @PostMapping("/addressForm")
    public ModelAndView addressFormForBuyNow(@RequestParam("bookId") Long bookId,
                                            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                                            Authentication authentication) {
        Long accountId = userMapper.getUserId(authentication.getName());
        List<Address> addresses = addressService.getAddressesByAccountId(accountId);

        ModelAndView mav = new ModelAndView("user/addressForm");
        mav.addObject("addresses", addresses);
        mav.addObject("bookId", bookId);
        mav.addObject("quantity", quantity);
        mav.addObject("purchaseType", "buyNow");
        return mav;
    }

    @PostMapping("/addressFormFromCart")
    public ModelAndView addressFormForCart(@RequestParam(value = "cartIds", required = false) List<Long> cartIds,
                                           Authentication authentication) {
        Long accountId = userMapper.getUserId(authentication.getName());
        List<Address> addresses = addressService.getAddressesByAccountId(accountId);

        ModelAndView mav = new ModelAndView("user/addressForm");
        mav.addObject("addresses", addresses);
        mav.addObject("cartIds", cartIds);
        mav.addObject("purchaseType", "buyFromCart");
        return mav;
    }

    @PostMapping("/processPayment")
    public void processPayment(@RequestParam("purchaseType") String purchaseType,
                               @RequestParam(value = "bookId", required = false) Long bookId,
                               @RequestParam(value = "quantity", required = false) Integer quantity,
                               @RequestParam(value = "cartIds", required = false) List<Long> cartIds,
                               @RequestParam("addressId") Long addressId, // 주소 ID를 받음
                               Authentication authentication,
                               HttpServletResponse response) throws IOException {

        Long accountId = userMapper.getUserId(authentication.getName());
        boolean success = false;

        if ("buyNow".equals(purchaseType) && bookId != null && quantity != null) {
            success = paymentService.processSinglePurchase(accountId, bookId, quantity, addressId);
        } else if ("buyFromCart".equals(purchaseType)) {
            if (cartIds != null && !cartIds.isEmpty()) {
                success = paymentService.processSelectedCartPurchase(accountId, cartIds, addressId);
            } else {
                success = paymentService.processCartPurchase(accountId, addressId);
            }
        }

        response.setContentType("text/html; charset=UTF-8");
        if (success) {
            response.getWriter().println("<script>alert('구매가 완료되었습니다.'); location.href='/user/my-page';</script>");
        } else {
            response.getWriter().println("<script>alert('구매에 실패했습니다.'); history.back();</script>");
        }
    }
}
