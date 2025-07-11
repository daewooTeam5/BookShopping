package payment.admin;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("paymentAdminService")
public class PaymentAdminService {

	@Autowired
	PaymentAdminMapper mapper;
	
	public List<AdminPayment> findAll() {
		return mapper.findAll();
	}

	public List<AdminPayment> search(String userName, String userId, String bookTitle, String publisher, String fromDate, String toDate, Integer minPrice, Integer maxPrice) {
        return mapper.search(userName, userId, bookTitle, publisher, fromDate, toDate, minPrice, maxPrice);
    }
}