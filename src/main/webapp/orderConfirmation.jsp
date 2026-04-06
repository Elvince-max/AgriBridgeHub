<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation | EgertonAgriBridgeHub</title>
    <!-- Bootstrap 5 + Icons + Google Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="css/orderConfirmation.css" rel="stylesheet" type="text/css"/>
</head>
<body>

<div class="container py-5">
    <div class="confirmation-card p-4 p-md-5">
        
        <!-- Logo + header -->
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap">
            <div class="fw-bold fs-5 brand-green">
                <i class="bi bi-tree-fill me-1"></i> EgertonAgriBridgeHub
            </div>
            <div class="text-muted small">#ModernPastoral</div>
        </div>

        <!-- Main success message -->
        <div class="text-center mb-5">
            <div class="checkmark-circle mx-auto">
                <i class="bi bi-check-lg"></i>
            </div>
            <h1 class="display-6 fw-bold brand-green">Order Placed Successfully!</h1>
            <p class="text-secondary">Thank you for supporting modern pastoral excellence.</p>
        </div>

        <!-- Two‑column layout: left = delivery info / right = order summary -->
        <div class="row g-4">
            <!-- LEFT COLUMN: Delivery info + buttons -->
            <div class="col-md-6">
                <div class="delivery-panel h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="mb-4">
                            <div class="text-uppercase small text-muted fw-semibold">Order Number</div>
                            <div class="fs-5 fw-bold">${order.orderNumber}</div>
                        </div>
                        <div class="mb-4">
                            <div class="text-uppercase small text-muted fw-semibold">
                                <i class="bi bi-calendar-event me-1"></i> Estimated Delivery
                            </div>
                            <div class="fs-6">${empty estimatedDelivery ? 'Today, 4:00 PM – 5:00 PM' : estimatedDelivery}</div>
                        </div>
                        <div class="mb-4">
                            <div class="text-uppercase small text-muted fw-semibold">
                                <i class="bi bi-geo-alt me-1"></i> Shipping Address
                            </div>
                            <div class="fs-6">${order.deliveryAddress}</div>
                        </div>
                    </div>
                    <div class="d-flex flex-wrap gap-3 mt-4">
                        <a href="OrderServlet?action=myOrders" class="btn btn-track px-4">
                            <i class="bi bi-truck me-1"></i> Track My Order
                        </a>
                        <a href="index.jsp" class="btn btn-home px-4">
                            <i class="bi bi-house-door me-1"></i> Back to Home
                        </a>
                    </div>
                </div>
            </div>

            <!-- RIGHT COLUMN: Order summary -->
            <div class="col-md-6">
                <div class="bg-white p-3 rounded-4 border" style="background: #fffcf8;">
                    <h5 class="fw-bold brand-green mb-3">Order Summary</h5>
                    <div>
                        <c:forEach var="item" items="${orderItems}">
                            <div class="order-item">
                                <div>
                                    <span class="fw-semibold">${item.productName}</span>
                                    <div class="small text-secondary">${item.quantity} ${item.quantity == 1 ? 'unit' : 'units'}</div>
                                </div>
                                <div class="fw-semibold">KES ${item.subtotal}</div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="mt-3 pt-2">
                        <div class="d-flex justify-content-between mb-1">
                            <span>Subtotal</span>
                            <span>KES <fmt:formatNumber value="${order.totalAmount - order.deliveryFee}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Delivery Fee</span>
                            <span>KES ${order.deliveryFee}</span>
                        </div>
                        <div class="d-flex justify-content-between border-top pt-2 mt-2">
                            <span class="fw-bold fs-6">Total Paid</span>
                            <span class="total-amount">KES ${order.totalAmount}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Support link (centered) -->
        <div class="text-center mt-5 pt-3">
            <i class="bi bi-headset text-secondary me-1"></i>
            <span>Need help with your order? </span>
            <a href="#" class="fw-semibold text-decoration-none brand-green">Contact Support</a>
        </div>

        <!-- Footer links -->
        <hr class="my-4">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>