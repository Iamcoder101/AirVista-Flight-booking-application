package com.Booking.controller;

import com.Booking.dto.BookingRequest;
import com.Booking.model.Booking;
import com.Booking.service.BookingService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/bookings")
public class BookingController {

    @Autowired
    private BookingService bookingService;

    // Create a new booking
    @PostMapping("/book")
    public ResponseEntity<Booking> bookFlight(@RequestBody BookingRequest request) {
        Booking booking = bookingService.createBooking(request);

        // Generate unique booking reference
        String bookingReference = "BOOK" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        booking.setBookingReference(bookingReference);
        booking.setStatus("PENDING");

        // Save updated booking with reference and status
        Booking updatedBooking = bookingService.updateBooking(booking);

        return ResponseEntity.ok(updatedBooking);
    }

    // Get payment verification status using bookingReference
    @GetMapping("/verify/{bookingReference}")
    public ResponseEntity<?> verifyPayment(@PathVariable String bookingReference) {
        try {
            Booking booking = bookingService.getBookingByReference(bookingReference);
            return ResponseEntity.ok(Map.of("paymentVerified", booking.isPaymentVerified()));
        } catch (Exception e) {
            return ResponseEntity.status(404).body("❌ Booking not found");
        }
    }

    @GetMapping("/payment-page/{bookingReference}")
public ResponseEntity<String> showPaymentPage(@PathVariable String bookingReference) {
    String html = "<html><body style='font-family:sans-serif; text-align:center; padding-top:50px;'>"
        + "<h2>Confirm Payment</h2>"
        + "<form method='POST' action='/api/bookings/update-payment-status/" + bookingReference + "?paymentVerified=true'>"
        + "<button type='submit' style='padding: 10px 20px; font-size: 16px;'>Confirm Payment ✅</button>"
        + "</form></body></html>";
    return ResponseEntity.ok().header("Content-Type", "text/html").body(html);
}
    // Simulate QR scan: update payment status
    @PostMapping("/update-payment-status/{bookingReference}")
    public ResponseEntity<?> updatePaymentStatus(
            @PathVariable String bookingReference,
            @RequestParam boolean paymentVerified) {
        try {
            bookingService.updatePaymentStatus(bookingReference, paymentVerified);
            return ResponseEntity.ok("✅ Payment status updated.");
        } catch (Exception e) {
            return ResponseEntity.status(404).body("❌ Booking not found");
        }
    }
}



/*package com.Booking.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Service;

//import org.springframework.web.bind.annotation.CrossOrigin;

import com.Booking.dto.BookingRequest;
import com.Booking.model.Booking;
//import com.Booking.repository.BookingRepository;
import com.Booking.service.BookingService;

//import jakarta.persistence.EntityManager;

@RestController
@CrossOrigin("*")

@RequestMapping("/api/bookings")
public class BookingController {

    @Autowired
    private BookingService bookingService;
    @PersistenceContext
     private EntityManager entityManager;


	/*
	 * @PostMapping("/create") public ResponseEntity<String> bookFlight(@RequestBody
	 * BookingRequest request) { Booking booking =
	 * bookingService.bookFlight(request); return
	 * ResponseEntity.ok("Booking confirmed for " + booking.getPassengerName() +
	 * " with Booking ID: " + booking.getId()); }
	 */
    
   /* @PostMapping("/book")
    public ResponseEntity<Booking> bookFlight(@RequestBody BookingRequest request) {
        Booking booking = bookingService.createBooking(request);
        // Endpoint: Poll booking status by booking reference (for Flutter)
@GetMapping("/verify/{bookingReference}")
public ResponseEntity<?> verifyPayment(@PathVariable String bookingReference) {
    try {
        Booking booking = entityManager
            .createQuery("SELECT b FROM Booking b WHERE b.bookingReference = :ref", Booking.class)
            .setParameter("ref", bookingReference)
            .getSingleResult();

        return ResponseEntity.ok(Map.of("paymentVerified", booking.isPaymentVerified()));
    } catch (Exception e) {
        return ResponseEntity.status(404).body("Booking not found");
    }
}

// Endpoint: Simulate QR scan and update payment status
@PostMapping("/update-payment-status/{bookingReference}")
public ResponseEntity<?> updatePaymentStatus(
        @PathVariable String bookingReference,
        @RequestParam boolean paymentVerified) {

    try {
        Booking booking = entityManager
            .createQuery("SELECT b FROM Booking b WHERE b.bookingReference = :ref", Booking.class)
            .setParameter("ref", bookingReference)
            .getSingleResult();

        booking.setPaymentVerified(paymentVerified);
        booking.setStatus(paymentVerified ? "PAID" : "PENDING");
        entityManager.merge(booking);

        return ResponseEntity.ok("Payment status updated.");
    } catch (Exception e) {
        return ResponseEntity.status(404).body("Booking not found");
    }
}
        return ResponseEntity.ok(booking);
    }

    // Simulate payment verification via QR scan

    public Booking getBookingById(Long id) {
        return entityManager.find(Booking.class, id);
    }

    public void updatePaymentStatus(Long id, boolean paymentVerified) {
        Booking booking = entityManager.find(Booking.class, id);
        if (booking != null) {
            booking.setPaymentVerified(paymentVerified);
            booking.setStatus(paymentVerified ? "PAID" : "PENDING");
            entityManager.merge(booking);
        }
    }

}
*/

