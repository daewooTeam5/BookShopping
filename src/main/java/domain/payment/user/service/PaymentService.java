// src/main/java/payment/service/PaymentService.java
package domain.payment.user.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import domain.book.user.repository.BookRepository;
import domain.payment.user.dto.Payment;
import domain.payment.user.dto.PaymentDetailDto;
import domain.payment.user.repository.PaymentRepository;
import domain.shopping_cart.entity.ShoppingCart;
import domain.shopping_cart.repository.ShoppingCartRepository;
import global.exception.ApiException;

@Service
public class PaymentService {

	@Autowired
	private PaymentRepository paymentMapper;

	@Autowired
	private ShoppingCartRepository shoppingCartRepository;

	@Autowired
	private BookRepository bookDao; // 책 정보를 조회하기 위해 BookDao를 주입합니다.

	public boolean processSinglePurchase(Long accountId, Long bookId, int quantity) {
		// 1. DB에서 bookId로 책이 존재하는지 확인합니다.
		if (bookDao.findById(bookId) == null) {
			// 존재하지 않는 책일 경우, 예외를 발생시키거나 false를 반환합니다.
			// ApiException은 전역 예외 처리를 위해 미리 정의된 클래스를 사용합니다.
			throw new ApiException("존재하지 않는 책입니다. bookId: " + bookId);
		}

		// 2. 유효한 책일 경우 결제를 진행합니다.
		Payment payment = Payment.builder().accountId(accountId).bookId(bookId).quantity(quantity)
				.receiptId(UUID.randomUUID().toString()).build();

		return paymentMapper.insertPayment(payment) > 0;
	}

	@Transactional
	public boolean processCartPurchase(Long accountId) {
		List<ShoppingCart> cartItems = shoppingCartRepository.findByAccountId(accountId);
		String receiptId = UUID.randomUUID().toString();
		return processPurchase(accountId, cartItems, receiptId);
	}

	@Transactional
	public boolean processSelectedCartPurchase(Long accountId, List<Long> cartIds) {
		List<ShoppingCart> cartItems = shoppingCartRepository.findByIds(cartIds);
		System.out.println(cartItems);
		// 선택된 장바구니 항목들이 해당 accountId에 속하는지 확인 (보안 강화)
		boolean allBelongToUser = cartItems.stream().allMatch(item -> item.getAccountId().equals(accountId));
		if (!allBelongToUser) {
			throw new ApiException("선택된 장바구니 항목 중 사용자에게 속하지 않는 항목이 있습니다.");
		}
		String receiptId = UUID.randomUUID().toString();
		return processPurchase(accountId, cartItems, receiptId);
	}

	private boolean processPurchase(Long accountId, List<ShoppingCart> cartItems, String receiptId) {
		if (cartItems.isEmpty()) {
			return false;
		}

		for (ShoppingCart item : cartItems) {
			if (bookDao.findById(item.getBookId()) == null) {
				throw new ApiException("장바구니에 존재하지 않는 책이 포함되어 있습니다. bookId: " + item.getBookId());
			}

			Payment payment = Payment.builder().accountId(accountId).bookId(item.getBookId())
					.quantity(item.getQuantity())
					.receiptId(receiptId)
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