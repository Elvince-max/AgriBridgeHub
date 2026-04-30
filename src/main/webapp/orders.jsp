<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Harvest Journey | EgertonAgriBridgeHub</title>
    <!-- Bootstrap 5 + Icons + Google Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            background: #f9f7f3;
            font-family: 'Segoe UI', Roboto, system-ui, sans-serif;
        }
        .brand-green {
            color: #1e4a2f;
        }
        .bg-brand-green {
            background-color: #1e4a2f;
        }
        .btn-brown {
            background-color: #8b5a2b;
            border: none;
            color: white;
            border-radius: 40px;
            padding: 8px 24px;
            font-weight: 500;
        }
        .btn-brown:hover {
            background-color: #6e451f;
            color: white;
        }
        .status-out-for-delivery {
            background-color: #f57c00;
            color: white;
            padding: 4px 12px;
            border-radius: 30px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }
        .progress-step {
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
        }
        .step {
            text-align: center;
            flex: 1;
            font-size: 0.75rem;
            font-weight: 500;
            color: #aaa;
        }
        .step.active {
            color: #1e4a2f;
            font-weight: bold;
        }
        .step.completed {
            color: #1e4a2f;
        }
        .progress-bar-custom {
            background-color: #e9ecef;
            border-radius: 20px;
            height: 6px;
            width: 100%;
            margin: 10px 0;
        }
        .progress-fill {
            background-color: #1e4a2f;
            width: 75%;
            height: 6px;
            border-radius: 20px;
        }
        .order-history-table th {
            background-color: #1e4a2f;
            color: white;
        }
        .filter-btn {
            border-radius: 30px;
            border: 1px solid #ced4da;
            padding: 5px 15px;
            background: white;
        }
        .filter-btn.active {
            background-color: #1e4a2f;
            color: white;
            border-color: #1e4a2f;
        }
        .pagination .page-item.active .page-link {
            background-color: #1e4a2f;
            border-color: #1e4a2f;
        }
        .support-card {
            background-color: #1e4a2f;
            border-radius: 20px;
            padding: 20px;
            color: white;
        }
        .footer-link {
            text-decoration: none;
            font-size: 0.8rem;
            color: #6c757d;
        }
        .footer-link:hover {
            color: #1e4a2f;
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container py-4">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center flex-wrap mb-4">
        <div class="d-flex align-items-center gap-4">
            <div class="fw-bold fs-5 brand-green">
                <i class="bi bi-tree-fill me-1"></i> EgertonAgriBridgeHub
            </div>
            <div class="d-flex gap-3">
                <a href="products.jsp" class="text-decoration-none text-secondary">Shop</a>
                <a href="#" class="text-decoration-none text-secondary">Our Story</a>
                <a href="#" class="text-decoration-none text-secondary">Process</a>
            </div>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <a href="cart.jsp" class="text-decoration-none text-secondary">
                <i class="bi bi-cart3 fs-5"></i>
            </a>
            <a href="profile.jsp" class="text-decoration-none text-secondary">
                <i class="bi bi-person-circle fs-5"></i> Account
            </a>
        </div>
    </div>

    <!-- Page Title -->
    <div class="mb-4">
        <h1 class="display-6 fw-bold brand-green">Your Harvest Journey</h1>
        <p class="text-secondary">Manage dairy subscriptions and historical orders from Egerton farms.</p>
    </div>

    <!-- Active Order Tracking (only if there is an order with status 'Out for Delivery') -->
    <c:set var="activeOrder" value="${null}" />
    <c:forEach var="order" items="${orders}">
        <c:if test="${order.status == 'Out for Delivery' || order.status == 'shipped'}">
            <c:set var="activeOrder" value="${order}" />
        </c:if>
    </c:forEach>

    <c:if test="${not empty activeOrder}">
        <div class="card border-0 shadow-sm mb-5 p-4">
            <div class="d-flex justify-content-between align-items-center flex-wrap">
                <div>
                    <span class="status-out-for-delivery">OUT FOR DELIVERY</span>
                    <h4 class="mt-2">Order #${activeOrder.orderNumber}</h4>
                    <p class="text-secondary">Expected delivery: Today, 10:00 AM – 12:30 PM</p>
                </div>
                <button class="btn btn-brown" onclick="alert('Map tracking coming soon')">
                    <i class="bi bi-geo-alt-fill me-1"></i> Track on Map
                </button>
            </div>
            <!-- Progress bar: stages: Pending → Confirmed → Out for Delivery → Delivered -->
            <div class="mt-3">
                <div class="progress-step">
                    <div class="step completed">Order Placed</div>
                    <div class="step completed">Confirmed</div>
                    <div class="step active">Out for Delivery</div>
                    <div class="step">Delivered</div>
                </div>
                <div class="progress-bar-custom">
                    <div class="progress-fill" style="width: 75%;"></div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Order History Section -->
    <div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
        <h3 class="fw-bold brand-green">Order History</h3>
        <div>
            <button class="filter-btn me-2" onclick="filterOrders('all')">All</button>
            <button class="filter-btn" onclick="filterOrders('delivered')">Delivered</button>
            <button class="filter-btn" onclick="filterOrders('cancelled')">Cancelled</button>
            <button class="btn btn-outline-secondary ms-2" onclick="exportOrders()">
                <i class="bi bi-download"></i> Export
            </button>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-hover order-history-table align-middle" id="ordersTable">
            <thead>
                <tr>
                    <th>Order Details</th>
                    <th>Summary</th>
                    <th>Investment (KES)</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr data-status="${order.status}">
                        <td>
                            <strong>#${order.orderNumber}</strong><br>
                            <small class="text-muted"><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy"/></small>
                        </td>
                        <td>${order.itemCount} item(s)</td>
                        <td><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status == 'delivered'}">
                                    <span class="badge bg-success">DELIVERED</span>
                                </c:when>
                                <c:when test="${order.status == 'cancelled'}">
                                    <span class="badge bg-danger">CANCELLED</span>
                                </c:when>
                                <c:when test="${order.status == 'pending'}">
                                    <span class="badge bg-warning text-dark">PENDING</span>
                                </c:when>
                                <c:when test="${order.status == 'confirmed'}">
                                    <span class="badge bg-info">CONFIRMED</span>
                                </c:when>
                                <c:when test="${order.status == 'shipped' || order.status == 'Out for Delivery'}">
                                    <span class="badge bg-orange" style="background-color: #f57c00;">OUT FOR DELIVERY</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">${order.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="OrderServlet?action=view&orderId=${order.orderId}" class="btn btn-sm btn-outline-brand">
                                View Details
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr><td colspan="5" class="text-center text-muted">No orders found.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Pagination (static example, you can implement dynamic later) -->
    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item disabled"><span class="page-link">Previous</span></li>
            <li class="page-item active"><span class="page-link">1</span></li>
            <li class="page-item"><a class="page-link" href="#">2</a></li>
            <li class="page-item"><a class="page-link" href="#">3</a></li>
            <li class="page-item"><a class="page-link" href="#">Next</a></li>
        </ul>
    </nav>

    <!-- Bottom Cards -->
    <div class="row g-4 mt-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100 text-center p-3">
                <i class="bi bi-calendar-repeat fs-1 brand-green"></i>
                <h5 class="mt-2">Automate Your Harvest</h5>
                <p class="text-muted small">Set up weekly recurring orders and save up to 10%.</p>
                <a href="#" class="btn btn-outline-brand btn-sm">Learn More</a>
            </div>
        </div>
        <div class="col-md-4">
            <div class="support-card h-100 text-center">
                <i class="bi bi-headset fs-1"></i>
                <h5 class="mt-2">Need Assistance?</h5>
                <p class="small">Help with recent orders or delivery issues.</p>
                <button class="btn btn-light mt-2" onclick="alert('Contact support: support@egertonagribridge.com')">Contact Support</button>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100 text-center p-3">
                <i class="bi bi-receipt fs-1 brand-green"></i>
                <h5 class="mt-2">Billing Statements</h5>
                <p class="text-muted small">Download invoices and monthly reports.</p>
                <a href="#" class="btn btn-outline-brand btn-sm">View Statements</a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <hr class="my-5">
    <div class="d-flex flex-wrap justify-content-center gap-3 gap-md-4 small">
        <a href="#" class="footer-link">Support</a>
        <a href="#" class="footer-link">Shipping Policy</a>
        <a href="#" class="footer-link">Terms of Service</a>
        <a href="#" class="footer-link">Farmer Spotlights</a>
    </div>
    <div class="text-center text-muted small mt-3">
        © 2024 EgertonAgriBridgeHub. Modern Pastoral Excellence.
    </div>
</div>

<script>
    // Simple client-side filtering for demo
    function filterOrders(status) {
        const rows = document.querySelectorAll('#ordersTable tbody tr');
        rows.forEach(row => {
            if (status === 'all') {
                row.style.display = '';
            } else {
                const rowStatus = row.getAttribute('data-status');
                if (rowStatus === status) row.style.display = '';
                else row.style.display = 'none';
            }
        });
        // Update active class on filter buttons
        document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');
    }

    function exportOrders() {
        alert('Export to CSV – coming soon');
    }
</script>

<style>
    .btn-outline-brand {
        border: 1px solid #1e4a2f;
        color: #1e4a2f;
        border-radius: 30px;
    }
    .btn-outline-brand:hover {
        background-color: #1e4a2f;
        color: white;
    }
    .badge.bg-orange {
        background-color: #f57c00;
        color: white;
    }
</style>

</body>
</html>