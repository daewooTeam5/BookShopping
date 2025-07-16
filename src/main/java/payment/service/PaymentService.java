// src/main/java/payment/service/PaymentService.java
package payment.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import book.user.dao.BookDao;
import global.exception.ApiException;
import payment.dto.Payment;
import payment.mapper.PaymentMapper;
import shopping_cart.entity.ShoppingCart;
import shopping_cart.repository.ShoppingCartRepository;

@Service
public class PaymentService {

    @Autowired
    private PaymentMapper paymentMapper;

    @Autowired
    private ShoppingCartRepository shoppingCartRepository;

    @Autowired
    private BookDao bookDao; // 책 정보를 조회하기 위해 BookDao를 주입합니다.

    
    public boolean processSinglePurchase(Long accountId, Long bookId) {
        // 1. DB에서 bookId로 책이 존재하는지 확인합니다.
        if (bookDao.findById(bookId) == null) {
            // 존재하지 않는 책일 경우, 예외를 발생시키거나 false를 반환합니다.
            // ApiException은 전역 예외 처리를 위해 미리 정의된 클래스를 사용합니다.
            throw new ApiException("존재하지 않는 책입니다. bookId: " + bookId);
        }

        // 2. 유효한 책일 경우 결제를 진행합니다.
        Payment payment = Payment.builder()
                .accountId(accountId)
                .bookId(bookId)
                .build();
        
        return paymentMapper.insertPayment(payment) > 0;
    }

   
    @Transactional
    public boolean processCartPurchase(Long accountId) {
        // 1. 해당 유저의 장바구니 목록을 가져옵니다.
        List<ShoppingCart> cartItems = shoppingCartRepository.findByAccountId(accountId);

        if (cartItems.isEmpty()) {
            // 장바구니가 비어있으면 처리하지 않음
            return false;
        }

        // 2. 장바구니의 각 상품에 대해 결제 내역을 생성합니다.
        for (ShoppingCart item : cartItems) {
            // (선택) 여기서도 각 bookId의 유효성을 한번 더 확인할 수 있습니다.
            if (bookDao.findById(item.getBookId()) == null) {
                 throw new ApiException("장바구니에 존재하지 않는 책이 포함되어 있습니다. bookId: " + item.getBookId());
            }

            Payment payment = Payment.builder()
                    .accountId(accountId)
                    .bookId(item.getBookId())
                    .build();
            paymentMapper.insertPayment(payment);

            // 3. 결제가 완료된 상품을 장바구니에서 삭제합니다.
            shoppingCartRepository.removeFromCart(item.getId());
        }

        return true;
    }
}