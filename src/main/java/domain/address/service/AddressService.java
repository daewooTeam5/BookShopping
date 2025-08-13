package domain.address.service;

import domain.address.entity.Address;
import domain.address.repository.AddressRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AddressService {

    private final AddressRepository addressRepository;

    public int addAddress(Address address) {
        return addressRepository.save(address);
    }

    public List<Address> getAddressesByAccountId(Long accountId) {
        return addressRepository.findByAccountId(accountId);
    }
}
