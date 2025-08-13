package domain.address.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 주소 정보를 담는 DTO 클래스.
 * DB의 한글 컬럼명과 Java의 영어 필드명을 매핑합니다.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Address {
    private Long id;            // 아이디 (PK)
    private Long accountId;     // 유저 아이디 (FK)
    private String province;      // 광역구
    private String city;          // 기초자치단체
    private String street;        // 하위 행정 구역 (상세주소 포함)
    private String zipcode;       // 우편번호
}
