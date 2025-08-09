
# ✈️ AirVista – Flight Booking System


<p align="center">
  <img src="https://img.shields.io/badge/Java-Spring%20Boot-blue?style=for-the-badge&logo=java" />
  <img src="https://img.shields.io/badge/Database-MySQL-orange?style=for-the-badge&logo=mysql" />
  <img src="https://img.shields.io/badge/API-Amadeus-lightblue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Frontend-Thymeleaf%20|%20Flutter-green?style=for-the-badge&logo=flutter" />
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" />
</p>

AirVista is a **full-stack flight booking system** built with **Java Spring Boot**.  
It enables users to search flights, view details, book tickets, make payments, and receive email confirmations with **PDF tickets**.  
The system integrates **Amadeus Flight Offers API** for real-time flight data.

---

## 📌 Features
- 🔍 Search flights by origin, destination, date, and passenger count  
- 📦 Real-time data from **Amadeus API**  
- 💳 Payment integration  
- 📧 Email confirmation with **PDF ticket attachment**  
- 📱 Flutter app version (in progress)  

---

## 🛠 Tech Stack

| Layer          | Technology |
|----------------|------------|
| **Backend**    | Java, Spring Boot, Spring MVC |
| **Database**   | MySQL, JPA/Hibernate |
| **API**        | Amadeus API |
| **PDF & Email**| iText, JavaMailSender |
| **Frontend**   | Thymeleaf / Flutter |
| **Tools**      | Postman, Maven, Git |

---

## 📷 Screenshots

### Flight Search UI
(<img width="496" height="322" alt="image" src="https://github.com/user-attachments/assets/10cbaf75-9357-4c98-ac89-eb33ba79fac6" />
<img width="495" height="635" alt="image" src="https://github.com/user-attachments/assets/05cc2818-87b9-492b-8280-147343d52b79" />
)

### Booking Confirmation
output_photos/7.jpg
### PDF Ticket
<img width="1000" height="324" alt="image" src="https://github.com/user-attachments/assets/f663f162-69dc-40a8-b241-c696b98d75f3" />

### Email Notification
<img width="1513" height="698" alt="image" src="https://github.com/user-attachments/assets/1b8c74c0-2eca-4f17-b596-f56a036091c4" />


---

## 🔐 Environment Variables (`application.properties`)

```properties
spring.application.name=Flight-
spring.datasource.url=jdbc:mysql://localhost:3306/airvista
spring.datasource.username=root
spring.datasource.password=your_db_password
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# API Keys
amadeus.api.key=YOUR_API_KEY
amadeus.api.secret=YOUR_SECRET

# Email Config
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=youremail@example.com
spring.mail.password=yourpassword
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
````

---

## 📄 PDF Ticket Sample

Each successful booking sends a downloadable PDF ticket containing:

* Passenger details
* Flight details
* QR code with encoded passenger info

---

## 🚀 Future Enhancements

* 📱 Complete Flutter mobile app
* 🧾 Invoice generation
* 🌐 Multi-language support
* 📊 Admin dashboard with analytics

---

## 🤝 Contributing

Contributions are welcome! Fork the repo, create a branch, and submit a pull request.

---

## 📧 Contact

**Ayesha**
📧 Email: [itsayesha66@gmail.com](mailto:itsayesha66@gmail.com)

---

```

---

I can also make **custom icons, banners, and badges** for "AirVista" so the README looks like a **real airline product page** instead of just a GitHub project.  
That way, it will have your own branding rather than placeholder images.  

Do you want me to design that branding too?
```
