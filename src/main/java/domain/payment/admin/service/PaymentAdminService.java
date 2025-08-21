package domain.payment.admin.service;

import java.util.List;
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

    public List<PaymentAdmin> search(String userName, String userId, String bookTitle, String publisher, String genre,
                                     String fromDate, String toDate, Integer minPrice, Integer maxPrice) {
        return mapper.search(userName, userId, bookTitle, publisher, genre, fromDate, toDate, minPrice, maxPrice);
    }

    // KPI: 전체 결제 "건수"(수량 합계) - 기존 유지
    public int getTotalCount() {
        return mapper.countAll();
    }

    // KPI: 전체 결제 금액 - 기존 유지
    public int getTotalAmount() {
        return mapper.sumAll();
    }

    public List<PaymentRank> getTopBooks(int limit) {
        return mapper.topBooks(limit);
    }

    public List<PaymentRank> getTopUsers(int limit) {
        return mapper.topUsers(limit);
    }

    public List<PaymentRank> getCategorySummary() {
        return mapper.categorySummary();
    }

    // =========================
    // 추가: 페이징 지원
    // =========================

    // 페이지네이션용: 리스트 총 "행 수"
    public int getListCount() {
        return mapper.listCount();
    }

    // page는 1부터, size는 1 이상
    public List<PaymentAdmin> findPage(int page, int size) {
        if (page < 1) page = 1;
        if (size < 1) size = 10;
        int startRow = (page - 1) * size + 1; // 1, 11, 21 ...
        int endRow   = page * size;           // 10, 20, 30 ...
        return mapper.findPage(startRow, endRow);
    }

    // 편의 메서드: 기본 10개씩
    public List<PaymentAdmin> findPage(int page) {
        return findPage(page, 10);
    }
}
