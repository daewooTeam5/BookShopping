package domain.review.admin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import domain.review.admin.dto.TopRatedBook;
import domain.review.admin.entity.Review;
import domain.review.admin.repository.ReviewAdminRepository;

@Service
public class ReviewAdminService {

    private final ReviewAdminRepository repo;

    @Autowired
    public ReviewAdminService(ReviewAdminRepository repo) {
        this.repo = repo;
    }

    public List<Review> findAll() {
        return repo.findAll();
    }

    public List<Review> searchByField(String field, String keyword) {
        if (keyword == null || keyword.isEmpty()) return findAll();
        switch (field) {
            case "content":    return repo.findByContentLike("%" + keyword + "%");
            case "account_id": return safeLong(keyword).map(repo::findByAccountId).orElse(List.of());
            case "book_id":    return safeLong(keyword).map(repo::findByBookId).orElse(List.of());
            case "rating":     return repo.findByRating(keyword);
            default:           return findAll();
        }
    }

    public Review findById(long id) { return repo.findById(id); }

    public List<TopRatedBook> getTop5ByAvgRating() {
        return repo.findTop5ByAvgRating();
    }

    private java.util.Optional<Long> safeLong(String s) {
        try { return java.util.Optional.of(Long.parseLong(s)); }
        catch (NumberFormatException e) { return java.util.Optional.empty(); }
    }
}
