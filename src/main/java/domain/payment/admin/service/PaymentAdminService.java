package domain.payment.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import domain.payment.admin.dto.PaymentRank;
import domain.payment.admin.entity.PaymentAdmin;
import domain.payment.admin.repository.PaymentAdminMapper;

@Service("paymentAdminService")
public class PaymentAdminService {

	@Autowired
	PaymentAdminMapper mapper;

	public List<PaymentAdmin> findAll() {
		return mapper.findAll();
	}

	public List<PaymentAdmin> search(String userName, String userId, String bookTitle, String publisher,
			String fromDate, String toDate, Integer minPrice, Integer maxPrice) {
		return mapper.search(userName, userId, bookTitle, publisher, fromDate, toDate, minPrice, maxPrice);
	}

	public int getTotalCount() {
		return mapper.countAll();
	}

	public int getTotalAmount() {
		return mapper.sumAll();
	}

	public List<PaymentRank> getTopBooks(int limit) {
		return mapper.topBooks(limit);
	}

	public List<PaymentRank> getTopUsers(int limit) {
		return mapper.topUsers(limit);
	}
}