package domain.review.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
        mv.addObject("keyword", keyword);
        mv.addObject("top5", service.getTop5ByAvgRating());
        mv.setViewName("review/admin/list");
        return mv;
    }
}
