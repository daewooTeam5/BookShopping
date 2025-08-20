package domain.review.admin.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import domain.review.admin.service.ReviewAdminService;

@Controller
@RequestMapping("/review/admin")
public class ReviewAdminController {

    private final ReviewAdminService service;

    @Autowired
    public ReviewAdminController(ReviewAdminService service) {
        this.service = service;
    }

    @RequestMapping("list")
    public ModelAndView list(
            @RequestParam(value = "searchField", required = false, defaultValue = "content") String searchField,
            @RequestParam(value = "keyword", required = false) String keyword,
            ModelAndView mv) {

        if (keyword != null && !keyword.isEmpty()) {
            mv.addObject("list", service.searchByField(searchField, keyword));
        } else {
            mv.addObject("list", service.findAll());
        }

        mv.addObject("searchField", searchField);
        mv.addObject("reviewForWeekdays",service.getReviewForWeekday());
        mv.addObject("ratingCount",service.getAllRatingForCount());

        mv.addObject("keyword", keyword);
        mv.addObject("top5", service.getTop5ByAvgRating());
        System.out.println(service.getTopReviewer());
        mv.addObject("top5Review",service.getTopReviewer());

        // Add chart data
        mv.addObject("dailyStats", service.getDailyStats());
        mv.addObject("monthlyStats", service.getMonthlyStats());
        mv.addObject("yearlyStats", service.getYearlyStats());

        mv.setViewName("review/admin/list");
        return mv;
    }
    
    @PostMapping("delete")
    public void delete(@RequestParam("id") long id, HttpServletResponse response) throws IOException {
        boolean success = service.delete(id);

        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (success) {
            response.getOutputStream().write("<script>alert('Delete Success!'); location.href='/review/admin/list';</script>".getBytes());
        } else {
            response.getOutputStream().write("<script>alert('Delete Fail!'); history.back();</script>".getBytes());
        }
    }
}
