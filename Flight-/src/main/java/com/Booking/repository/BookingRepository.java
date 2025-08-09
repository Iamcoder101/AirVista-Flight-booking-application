package com.Booking.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Booking.model.Booking;
import java.util.Optional;

public interface BookingRepository extends JpaRepository<Booking, Long> {
    Optional<Booking> findByBookingReference(String bookingReference);
}
