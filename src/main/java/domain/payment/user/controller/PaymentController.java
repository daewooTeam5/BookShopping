package domain.payment.user.controller;

import domain.address.entity.Address;
import domain.address.service.AddressService;
import domain.book.user.repository.BookRepository;
import domain.payment.user.dto.PaymentDetailDto;
import domain.payment.user.service.PaymentService;
import domain.shopping_cart.entity.ShoppingCart;
import domain.shopping_cart.repository.ShoppingCartRepository;
import domain.user.repository.UserRepository;
import global.exception.ApiException;

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
import java.util.ArrayList;
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
    @Autowired
    private BookRepository bookRepository; // 의존성 주입 추가
    @Autowired
    private ShoppingCartRepository shoppingCartRepository; // 의존성 주입 추가

    @PostMapping("/addressForm")
    public ModelAndView addressFormForBuyNow(@RequestParam("bookId") Long bookId,
                                            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                                            Authentication authentication ) {
    	if(authentication==null) {
    		throw new ApiException("로그인후 이용해주세요");

    		
    	}
        Long accountId = userMapper.getUserId(authentication.getName());
        List<Address> addresses = addressService.getAddressesByAccountId(accountId);

        // [수정] 구매 상품 정보와 총액 계산
        List<PaymentDetailDto> purchaseItems = new ArrayList<>();
        domain.book.user.dto.Book book = bookRepository.findById(bookId);
        long totalPrice = 0;
        if (book != null) {
            PaymentDetailDto item = PaymentDetailDto.builder()
                    .title(book.getTitle())
                    .image(book.getImage())
                    .price(book.getPrice())
                    .quantity(quantity)
                    .build();
            purchaseItems.add(item);
            totalPrice = (long) book.getPrice() * quantity;
        }

        ModelAndView mav = new ModelAndView("user/addressForm");
        mav.addObject("addresses", addresses);
        mav.addObject("bookId", bookId);
        mav.addObject("quantity", quantity);
        mav.addObject("purchaseType", "buyNow");
        mav.addObject("purchaseItems", purchaseItems); // 모델에 추가
        mav.addObject("totalPrice", totalPrice);       // 모델에 추가
        return mav;
    }

    @PostMapping("/addressFormFromCart")
    public ModelAndView addressFormForCart(@RequestParam(value = "cartIds", required = false) List<Long> cartIds,
                                           Authentication authentication) {
        Long accountId = userMapper.getUserId(authentication.getName());
        List<Address> addresses = addressService.getAddressesByAccountId(accountId);
        
        // [수정] 구매 상품 정보와 총액 계산
        List<PaymentDetailDto> purchaseItems = new ArrayList<>();
        long totalPrice = 0;
        if (cartIds != null && !cartIds.isEmpty()) {
            List<ShoppingCart> cartItems = shoppingCartRepository.findByIds(cartIds);
            for (ShoppingCart cartItem : cartItems) {
                domain.book.user.dto.Book book = bookRepository.findById(cartItem.getBookId());
                if (book != null) {
                    PaymentDetailDto item = PaymentDetailDto.builder()
                            .title(book.getTitle())
                            .image(book.getImage())
                            .price(book.getPrice())
                            .quantity(cartItem.getQuantity())
                            .build();
                    purchaseItems.add(item);
                    totalPrice += (long) book.getPrice() * cartItem.getQuantity();
                }
            }
        }

        ModelAndView mav = new ModelAndView("user/addressForm");
        mav.addObject("addresses", addresses);
        mav.addObject("cartIds", cartIds);
        mav.addObject("purchaseType", "buyFromCart");
        mav.addObject("purchaseItems", purchaseItems); // 모델에 추가
        mav.addObject("totalPrice", totalPrice);       // 모델에 추가
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
    
    @PostMapping("/processPaymentWithNewAddress")
    @Transactional
    public void processPaymentWithNewAddress(
            @RequestParam("purchaseType") String purchaseType,
            @RequestParam(value = "bookId", required = false) Long bookId,
            @RequestParam(value = "quantity", required = false) Integer quantity,
            @RequestParam(value = "cartIds", required = false) List<Long> cartIds,
            @RequestParam("province") String province,
            @RequestParam("city") String city,
            @RequestParam("street") String street,
            @RequestParam("zipcode") String zipcode,
            Authentication authentication,
            HttpServletResponse response) throws IOException {

        Long accountId = userMapper.getUserId(authentication.getName());

        Address newAddress = Address.builder()
                .accountId(accountId).province(province).city(city)
                .street(street).zipcode(zipcode)
                .build();
        addressService.addAddress(newAddress); 

        Long newAddressId = newAddress.getId();
        if (newAddressId == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('주소 저장에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
            return;
        }

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
        
        response.setContentType("text/html; charset=UTF-8");
        if (success) {
            response.getWriter().println("<script>alert('구매가 완료되었습니다.'); location.href='/user/my-page';</script>");
        } else {
            response.getWriter().println("<script>alert('구매에 실패했습니다.'); history.back();</script>");
        }
    }
}