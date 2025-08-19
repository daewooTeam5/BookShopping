package domain.address.repository;

import domain.address.entity.Address;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface AddressRepository {

    /**
     * 새로운 주소를 저장합니다.
     * (주석: 한글 컬럼명을 DB에 생성된 영문 컬럼명으로 모두 수정했습니다.)
     * @param address 저장할 주소 정보
     * @return 저장 성공 시 1 반환
     */
    @Insert("INSERT INTO ADDRESS (ID, ACCOUNT_ID, PROVINCE, CITY, STREET, ZIPCODE) " +
            "VALUES (SEQ_ADDRESS_ID.nextval, #{accountId}, #{province}, #{city}, #{street}, #{zipcode})")
    @Options(useGeneratedKeys = true, keyProperty = "id", keyColumn = "ID")
    int save(Address address);

    /**
     * 특정 사용자의 모든 주소 목록을 조회합니다.
     * (주석: 한글 컬럼명을 DB에 생성된 영문 컬럼명으로 모두 수정했습니다.)
     * @param accountId 사용자 ID
     * @return 주소 목록
     */
    @Select("SELECT ID as id, ACCOUNT_ID as accountId, PROVINCE as province, CITY as city, STREET as street, ZIPCODE as zipcode " +
            "FROM ADDRESS WHERE ACCOUNT_ID = #{accountId} ORDER BY ID DESC")
    List<Address> findByAccountId(Long accountId);
}
