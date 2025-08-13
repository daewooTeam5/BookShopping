package domain.payment.user.service;

import domain.book.user.repository.BookRepository;
import domain.payment.user.dto.Payment;
import domain.payment.user.dto.PaymentDetailDto;
import domain.payment.user.repository.PaymentRepository;
import domain.shopping_cart.entity.ShoppingCart;
import domain.shopping_cart.repository.ShoppingCartRepository;
import global.exception.ApiException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentMapper;

    @Autowired
    private ShoppingCartRepository shoppingCartRepository;
    @Autowired
    private BookRepository bookDao;

    public boolean processSinglePurchase(Long accountId, Long bookId, int quantity, Long addressId) {
        if (bookDao.findById(bookId) == null) {
            throw new ApiException("존재하지 않는 책입니다. bookId: " + bookId);
        }
        Payment payment = Payment.builder()
                .accountId(accountId).bookId(bookId).quantity(quantity)
                .receiptId(UUID.randomUUID().toString()).addressId(addressId)
                .build();
        return paymentMapper.insertPayment(payment) > 0;
    }

    @Transactional
    public boolean processCartPurchase(Long accountId, Long addressId) {
        List<ShoppingCart> cartItems = shoppingCartRepository.findByAccountId(accountId);
        String receiptId = UUID.randomUUID().toString();
        return processPurchase(accountId, cartItems, receiptId, addressId);
    }

    @Transactional
    public boolean processSelectedCartPurchase(Long accountId, List<Long> cartIds, Long addressId) {
        List<ShoppingCart> cartItems = shoppingCartRepository.findByIds(cartIds);
        boolean allBelongToUser = cartItems.stream().allMatch(item -> item.getAccountId().equals(accountId));
        if (!allBelongToUser) {
            throw new ApiException("선택된 장바구니 항목 중 사용자에게 속하지 않는 항목이 있습니다.");
        }
        String receiptId = UUID.randomUUID().toString();
        return processPurchase(accountId, cartItems, receiptId, addressId);
    }

    private boolean processPurchase(Long accountId, List<ShoppingCart> cartItems, String receiptId, Long addressId) {
        if (cartItems.isEmpty()) {
            return false;
        }
        for (ShoppingCart item : cartItems) {
            if (bookDao.findById(item.getBookId()) == null) {
                throw new ApiException("장바구니에 존재하지 않는 책이 포함되어 있습니다. bookId: " + item.getBookId());
            }
            Payment payment = Payment.builder()
                    .accountId(accountId).bookId(item.getBookId()).quantity(item.getQuantity())
                    .receiptId(receiptId).addressId(addressId)
                    .build();
            paymentMapper.insertPayment(payment);

            shoppingCartRepository.removeFromCart(item.getId());
        }
        return true;
    }

    public List<PaymentDetailDto> getPaymentDetailsByAccountId(Long accountId) {
        return paymentMapper.findPaymentDetailsByAccountId(accountId);
    }

    public Integer getTotalPaymentAmountByAccountId(Long accountId) {
        return paymentMapper.getTotalPaymentAmountByAccountId(accountId);
    }

}