package payment.admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("paymentAdminService")
public class PaymentAdminService {

	@Autowired
	PaymentAdminMapper mapper;
	
	public List<AdminPayment> findAll() {
		return mapper.findAll();
	}

}
