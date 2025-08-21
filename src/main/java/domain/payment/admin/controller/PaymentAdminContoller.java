package domain.payment.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import domain.payment.admin.service.PaymentAdminService;

@Controller
@RequestMapping("/payment/admin")
public class PaymentAdminContoller {
    private PaymentAdminService service;

    @Autowired
    public PaymentAdminContoller(PaymentAdminService service) {
        this.service = service;
    }

    @RequestMapping("list")
    public ModelAndView list(
            @RequestParam(value = "userName",   required = false) String userName,
            @RequestParam(value = "userId",     required = false) String userId,
            @RequestParam(value = "bookTitle",  required = false) String bookTitle,
            @RequestParam(value = "publisher",  required = false) String publisher,
            @RequestParam(value = "genre",      required = false) String genre,
            @RequestParam(value = "fromDate",   required = false) String fromDate,
            @RequestParam(value = "toDate",     required = false) String toDate,
            @RequestParam(value = "minPrice",   required = false) Integer minPrice,
            @RequestParam(value = "maxPrice",   required = false) Integer maxPrice,
            @RequestParam(value = "page",       required = false, defaultValue = "1") int page, // �� �߰�: ������ �Ķ����
            ModelAndView mv) {

        // ----- ��� ����(���� ����) -----
        mv.addObject("totalCount",  service.getTotalCount());
        mv.addObject("totalAmount", service.getTotalAmount());
        mv.addObject("topBooks",    service.getTopBooks(5));
        mv.addObject("topUsers",    service.getTopUsers(5));
        mv.addObject("categorySummary", service.getCategorySummary());

        // ----- �˻� ���� �Ǵ� -----
        boolean hasFilter =
                notEmpty(userName) || notEmpty(userId) || notEmpty(bookTitle) ||
                notEmpty(publisher) || notEmpty(genre) ||
                notEmpty(fromDate) || notEmpty(toDate) ||
                minPrice != null || maxPrice != null;

        int size = 10;
        int total;
        int totalPages;

        if (hasFilter) {
            // �˻� ���: ǥ = ��ü �˻����(������ ����), ��Ʈ = ��ü �˻����
            var searched = service.search(
                    userName, userId, bookTitle, publisher, genre, fromDate, toDate, minPrice, maxPrice
            );
            mv.addObject("paymentList", searched); // ���̺�
            mv.addObject("chartList",   searched); // �� ��Ʈ ����(��ü)
            total = searched.size();
            totalPages = 1;
            page = 1;
        } else {
            // �⺻ ���: ǥ = ����¡, ��Ʈ = ��ü ���
            total = service.getListCount();
            totalPages = (int) Math.ceil(total / (double) size);
            if (totalPages == 0) totalPages = 1;
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            mv.addObject("paymentList", service.findPage(page, size)); // ���̺�(����¡)
            mv.addObject("chartList",   service.findAll());            // �� ��Ʈ ����(��ü)
        }

        // �˻� �� �� ����
        mv.addObject("userName", userName);
        mv.addObject("userId", userId);
        mv.addObject("bookTitle", bookTitle);
        mv.addObject("publisher", publisher);
        mv.addObject("genre", genre);
        mv.addObject("fromDate", fromDate);
        mv.addObject("toDate", toDate);
        mv.addObject("minPrice", minPrice);
        mv.addObject("maxPrice", maxPrice);

        // ����¡ ��Ÿ������ ����
        mv.addObject("page", page);
        mv.addObject("size", size);
        mv.addObject("total", total);
        mv.addObject("totalPages", totalPages);

        mv.setViewName("/payment/admin/list");
        return mv;
    }

    // ----- ��ƿ -----
    private boolean notEmpty(String s) {
        return s != null && !s.isEmpty();
    }
}
