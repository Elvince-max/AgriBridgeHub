<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.agribridge.model.Cart" %>
<%
    HttpSession sessionCheck = request.getSession(false);
    if (sessionCheck == null || sessionCheck.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp?error=Please login to proceed to checkout");
        return;
    }
    Cart cart = (Cart) sessionCheck.getAttribute("cart");
    if (cart == null || cart.getItems().isEmpty()) {
        response.sendRedirect("cart.jsp?error=Your cart is empty");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Checkout | EgertonAgriBridgeHub</title>
    <!-- Bootstrap 5 + Icons + Google Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="css/checkout.css" rel="stylesheet" type="text/css"/>
</head>
<body>

<div class="container py-4 py-md-5">
    <div class="checkout-card p-4 p-md-5">
        
        <!-- Header with navigation -->
        <div class="d-flex justify-content-between align-items-center flex-wrap mb-4">
            <div class="d-flex gap-4 align-items-center">
                <div class="fw-bold fs-5 brand-green">
                    <i class="bi bi-tree-fill me-1"></i> EgertonAgriBridgeHub
                </div>
                <div class="d-flex gap-3">
                    <a href="OrderServlet?action=myOrders" class="text-decoration-none text-secondary">My Orders</a>
                    <a href="#" class="text-decoration-none text-secondary">Support</a>
                </div>
            </div>
            <!-- ✅ Functional cart icon with badge -->
            <a href="cart.jsp" class="text-decoration-none text-secondary position-relative">
                <i class="bi bi-cart3 fs-5"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.7rem;">
                    ${not empty cart ? cart.items.size() : 0}
                </span>
            </a>
        </div>

        <!-- Main heading -->
        <div class="text-center mb-4">
            <h1 class="display-6 fw-bold brand-green">Secure Checkout</h1>
            <p class="text-secondary">Complete your order from the pastoral heartlands of Njoro.</p>
        </div>

        <!-- Two columns: left (forms) / right (order summary) -->
        <div class="row g-4">
            <!-- LEFT COLUMN: Delivery + Payment -->
            <div class="col-lg-7">
                <form id="checkoutForm" action="OrderServlet" method="post">
                    <input type="hidden" name="action" value="placeOrder">

                    <!-- Delivery details card -->
                    <div class="card border-0 shadow-sm mb-4 p-3">
                        <h5 class="fw-bold brand-green">Delivery Details</h5>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Full Name</label>
                                <input type="text" class="form-control" name="fullName" placeholder="John Doe" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" name="phone" placeholder="+254 712 345678" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Delivery Address</label>
                                <textarea class="form-control" name="address" rows="3" placeholder="Apartment, street, landmark (e.g., Main Campus, Block B, Room 402)" required></textarea>
                            </div>
                        </div>

                        <!-- Preferred delivery time slots -->
                        <div class="mt-3">
                            <label class="form-label fw-semibold">Preferred Delivery Time</label>
                            <div class="d-flex flex-wrap gap-3 mt-2">
                                <div class="delivery-slot flex-grow-1 text-center" data-slot="Morning (8 AM - 12 PM)">
                                    Morning (8 AM - 12 PM)
                                    <span class="check-icon ms-1" style="display: none;">✓</span>
                                </div>
                                <div class="delivery-slot flex-grow-1 text-center" data-slot="Afternoon (1 PM - 5 PM)">
                                    Afternoon (1 PM - 5 PM)
                                    <span class="check-icon ms-1" style="display: none;">✓</span>
                                </div>
                                <div class="delivery-slot flex-grow-1 text-center" data-slot="Evening (6 PM - 8 PM)">
                                    Evening (6 PM - 8 PM)
                                    <span class="check-icon ms-1" style="display: none;">✓</span>
                                </div>
                            </div>
                            <input type="hidden" name="deliverySlot" id="deliverySlot" value="Morning (8 AM - 12 PM)">
                        </div>
                    </div>

                    <!-- Payment method card -->
                    <div class="card border-0 shadow-sm mb-4 p-3">
                        <h5 class="fw-bold brand-green">Payment Method</h5>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="payment-method d-flex align-items-center gap-2 selected" data-payment="mpesa">
                                    <i class="bi bi-phone fs-4"></i>
                                    <div>
                                        <div class="fw-semibold">M-Pesa</div>
                                        <small class="text-muted">Pay instantly with M-Pesa</small>
                                    </div>
                                    <span class="check-icon ms-auto" style="display: inline;">✓</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="payment-method d-flex align-items-center gap-2" data-payment="cod">
                                    <i class="bi bi-cash-stack fs-4"></i>
                                    <div>
                                        <div class="fw-semibold">Cash on Delivery</div>
                                        <small class="text-muted">Pay at your doorstep</small>
                                    </div>
                                    <span class="check-icon ms-auto" style="display: none;">✓</span>
                                </div>
                            </div>
                        </div>
                        <input type="hidden" name="paymentMethod" id="paymentMethod" value="mpesa">
                        <div class="mt-3 d-flex gap-3 small text-secondary">
                            <span><i class="bi bi-shield-lock"></i> SECURE SSL</span>
                            <span><i class="bi bi-check-circle"></i> SAFE CHECKOUT</span>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary-custom w-100 mt-2">Place Order</button>
                </form>
            </div>

            <!-- RIGHT COLUMN: Order Summary -->
            <div class="col-lg-5">
                <div class="bg-white p-3 rounded-4 border" style="background: #fefcf8;">
                    <h5 class="fw-bold brand-green mb-3">Order Summary</h5>
                    
                    <c:choose>
                        <c:when test="${empty cart or empty cart.items}">
                            <div class="alert alert-warning">Your cart is empty. <a href="products">Continue shopping</a></div>
                        </c:when>
                        <c:otherwise>
                            <div>
                                <c:forEach var="item" items="${cart.items}">
                                    <div class="order-item">
                                        <div>
                                            <span class="fw-semibold">${item.name}</span>
                                            <div class="small text-secondary">Quantity: ${item.quantity}</div>
                                        </div>
                                        <div class="fw-semibold">KES ${item.price * item.quantity}</div>
                                    </div>
                                </c:forEach>
                            </div>
                            <div class="mt-3 pt-2">
                                <div class="d-flex justify-content-between mb-1">
                                    <span>Subtotal</span>
                                    <span>KES <fmt:formatNumber value="${cart.total}" pattern="#,##0.00"/></span>
                                </div>
                                <div class="d-flex justify-content-between border-top pt-2 mt-2">
                                    <span class="fw-bold fs-6">Total</span>
                                    <span class="total-amount">KES <fmt:formatNumber value="${cart.total}" pattern="#,##0.00"/></span>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Promo code -->
                    <div class="mt-4">
                        <div class="input-group">
                            <input type="text" class="form-control promo-input" placeholder="Promo code" id="promoCode">
                            <button class="btn promo-btn" type="button" id="applyPromo">Apply</button>
                        </div>
                        <div id="promoMessage" class="small text-muted mt-1"></div>
                    </div>

                    <!-- Guaranteed freshness badge -->
                    <div class="mt-4 text-center">
                        <div class="guarantee-badge">
                            <i class="bi bi-flower1"></i> Guaranteed Freshness – harvested & delivered within 24h from Egerton farms
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <hr class="my-5">
        <div class="d-flex flex-wrap justify-content-center gap-3 gap-md-4 small">
            <a href="#" class="footer-link">Privacy Policy</a>
            <a href="#" class="footer-link">Terms of Service</a>
            <a href="#" class="footer-link">Shipping Info</a>
            <a href="#" class="footer-link">Farmer Directory</a>
        </div>
        <div class="text-center text-muted small mt-3">
            © 2024 EgertonAgriBridgeHub. Modern Pastoral Excellence.
        </div>
    </div>
</div>

<script src="js/checkout.js" type="text/javascript"></script>
</body>
</html>