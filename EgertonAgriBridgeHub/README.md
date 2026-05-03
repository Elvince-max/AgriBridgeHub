# Egerton AgriBridge Hub

Egerton AgriBridge Hub is a Java JSP/Servlet web application for dairy product ordering, customer checkout, M-Pesa payment flow, order tracking, admin management, delivery assignment, product management, customer profile management, and sales reporting.

## Technologies Used

- Java JSP/Servlets
- Apache Tomcat
- MySQL
- JDBC
- HTML, CSS, JavaScript
- M-Pesa Daraja STK Push
- NetBeans IDE

## Main Features

### Customer Side

- Customer registration and login
- Customer dashboard
- Product browsing and product details
- Product reviews
- Shopping cart
- Checkout with delivery zones
- Campus pickup option
- M-Pesa payment flow
- Cash on Delivery option
- Order tracking
- Customer profile management
- Password change using hashed passwords

### Admin/Staff Side

- Admin dashboard
- Product management
- Add, edit, activate, and deactivate products
- Stock status tracking
- Order management
- Order search and filtering
- Delivery assignment
- Sales reports
- PDF report option
- Customer/order visibility

### Delivery Side

- Delivery agent dashboard
- View assigned deliveries
- Update delivery status
- View customer delivery details

## Project Structure

```text
EgertonAgriBridgeHub
├── src
│   └── java
│       └── com
│           └── agribridgef1
│               ├── controller
│               ├── dao
│               ├── model
│               ├── service
│               └── util
├── web
│   ├── assets
│   │   └── css
│   ├── uploads
│   └── JSP pages
├── database
│   └── agribridgef1_db.sql
├── nbproject
├── README.md
└── .gitignore


