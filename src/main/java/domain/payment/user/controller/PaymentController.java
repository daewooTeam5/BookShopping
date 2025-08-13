package domain.payment.user.controller;

import domain.address.entity.Address;
import domain.address.service.AddressService;
import domain.payment.user.service.PaymentService;
import domain.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
    
    /**
     * [NEW] 새 주소를 입력받아 저장하고 즉시 결제를 진행하는 메소드
     */
    @PostMapping("/processPaymentWithNewAddress")
    @Transactional // 주소 저장과 결제가 모두 성공해야 하므로 트랜잭션 처리
    public void processPaymentWithNewAddress(
            @RequestParam("purchaseType") String purchaseType,
            @RequestParam(value = "bookId", required = false) Long bookId,
            @RequestParam(value = "quantity", required = false) Integer quantity,
            @RequestParam(value = "cartIds", required = false) List<Long> cartIds,
            // addressId 대신 새 주소 정보를 직접 받음
            @RequestParam("province") String province,
            @RequestParam("city") String city,
            @RequestParam("street") String street,
            @RequestParam("zipcode") String zipcode,
            Authentication authentication,
            HttpServletResponse response) throws IOException {

        // 1. 현재 사용자 ID 가져오기
        Long accountId = userMapper.getUserId(authentication.getName());

        // 2. 새로운 주소 객체를 만들어 DB에 저장
        Address newAddress = Address.builder()
                .accountId(accountId).province(province).city(city)
                .street(street).zipcode(zipcode)
                .build();
        addressService.addAddress(newAddress); // MyBatis의 @Options 덕분에 이 객체에 새로 생성된 ID가 담김

        // 3. 새로 저장된 주소의 ID를 가져오기
        Long newAddressId = newAddress.getId();
        if (newAddressId == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('주소 저장에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
            return;
        }

        // 4. 기존 결제 로직을 재사용하여 결제 진행
        boolean success = false;
        if ("buyNow".equals(purchaseType) && bookId != null && quantity != null) {
            success = paymentService.processSinglePurchase(accountId, bookId, quantity, newAddressId);
        } else if ("buyFromCart".equals(purchaseType)) {
            if (cartIds != null && !cartIds.isEmpty()) {
                success = paymentService.processSelectedCartPurchase(accountId, cartIds, newAddressId);
            } else {
                success = paymentService.processCartPurchase(accountId, newAddressId);
            }
        }
        
        // 5. 결과 알림
        response.setContentType("text/html; charset=UTF-8");
        if (success) {
            response.getWriter().println("<script>alert('구매가 완료되었습니다.'); location.href='/user/my-page';</script>");
        } else {
            response.getWriter().println("<script>alert('구매에 실패했습니다.'); history.back();</script>");
        }
    }
}