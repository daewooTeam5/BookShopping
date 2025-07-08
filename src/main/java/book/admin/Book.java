package book.admin;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@ToString
public class Book {
    private int id;
    private String title;
    private String author;
    private String publisher;
    private String image;
    private int price;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date publishedAt;
    private String genre;
    private int page;
    private String introduction;
}
