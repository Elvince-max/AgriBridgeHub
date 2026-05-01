<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Checkout | Egerton University Dairy</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --green:   #1B5E20;
            --green-dk:#145218;
            --green-lt:#E8F5E9;
            --gold:    #C9A84C;
            --gold-lt: #F5EDD0;
            --red:     #B71C1C;
            --red-lt:  #FDECEC;
            --cream:   #FDF8F0;
            --card:    #FFFFFF;
            --border:  #E8DDD0;
            --text:    #1a1a1a;
            --muted:   #6b6b6b;
        }

        * { box-sizing: border-box; }

        body {
            background-color: var(--cream);
            font-family: 'Inter', sans-serif;
            color: var(--text);
            margin: 0;
        }

        /* ── Navbar ── */
        .top-nav {
            background: var(--green);
            padding: 0 32px;
            display: flex;
            justify-content: space-between;
            align-items: stretch;
            min-height: 60px;
        }
        .brand-block {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 0;
        }
        .brand-crest {
            width: 36px;
            height: 36px;
            background: var(--gold);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
        }
        .brand-text { line-height: 1.2; }
        .brand-name {
            font-size: 0.95rem;
            font-weight: 700;
            color: #fff;
            display: block;
        }
        .brand-sub {
            font-size: 0.65rem;
            color: var(--gold);
            letter-spacing: 1.5px;
            text-transform: uppercase;
            display: block;
        }
        .nav-links {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .nav-links a {
            color: rgba(255,255,255,0.75);
            text-decoration: none;
            font-size: 0.82rem;
            transition: color 0.2s;
        }
        .nav-links a:hover { color: var(--gold); }

        /* ── Gold accent bar ── */
        .accent-bar {
            height: 4px;
            background: linear-gradient(90deg, var(--green) 0%, var(--gold) 50%, var(--red) 100%);
        }

        /* ── Page heading ── */
        .page-heading {
            max-width: 1020px;
            margin: 0 auto;
            padding: 28px 32px 14px;
            border-bottom: 1px solid var(--border);
        }
        .breadcrumb-trail {
            font-size: 0.72rem;
            color: var(--muted);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .breadcrumb-trail span { color: var(--green); font-weight: 600; }
        .page-heading h1 {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--green);
            margin: 0 0 2px;
        }
        .page-heading p {
            color: var(--muted);
            font-size: 0.83rem;
            margin: 0;
        }

        /* ── Layout grid ── */
        .main-grid {
            max-width: 1020px;
            margin: 0 auto;
            padding: 28px 32px 60px;
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 24px;
        }

        /* ── Card ── */
        .card-box {
            background: var(--card);
            border-radius: 12px;
            border: 1px solid var(--border);
            overflow: hidden;
        }
        .card-header-bar {
            background: var(--green);
            padding: 12px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .card-header-bar .card-title {
            color: #fff;
            font-size: 0.88rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .mpesa-badge {
            background: var(--gold);
            color: var(--green-dk);
            font-size: 0.68rem;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 20px;
            letter-spacing: 0.5px;
        }
        .card-body-pad { padding: 24px; }

        /* ── Form ── */
        .field-label {
            font-size: 0.68rem;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 7px;
        }
        .phone-field {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid var(--border);
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            background: #FAFAF8;
            outline: none;
            transition: border-color 0.2s;
        }
        .phone-field:focus { border-color: var(--green); box-shadow: 0 0 0 3px rgba(27,94,32,0.1); }
        .phone-hint { font-size: 0.77rem; color: var(--muted); margin-top: 7px; line-height: 1.5; }

        .btn-pay {
            width: 100%;
            background: var(--green);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px;
            font-size: 0.9rem;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            margin-top: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            transition: background 0.2s, transform 0.1s;
        }
        .btn-pay:hover { background: var(--green-dk); transform: translateY(-1px); }
        .btn-pay:active { transform: translateY(0); }

        /* ── Trust badges ── */
        .trust-row {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid var(--border);
        }
        .trust-item {
            font-size: 0.7rem;
            color: var(--muted);
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .trust-item i { color: var(--green); }

        /* ── Order summary card ── */
        .summary-title {
            font-size: 0.88rem;
            font-weight: 700;
            color: var(--green);
        }
        .order-item-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 14px;
        }
        .item-icon {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            background: var(--gold-lt);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
            border: 1px solid var(--gold);
        }
        .item-details { flex: 1; }
        .item-name { font-size: 0.84rem; font-weight: 600; }
        .item-sub { font-size: 0.73rem; color: var(--muted); }
        .item-price { font-size: 0.88rem; font-weight: 700; color: var(--green); white-space: nowrap; }
        .divider { border-top: 1px solid var(--border); margin: 12px 0; }
        .totals-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.83rem;
            color: var(--muted);
            margin-bottom: 5px;
        }
        .totals-final {
            display: flex;
            justify-content: space-between;
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--green);
            margin-top: 8px;
        }

        /* ── Info box ── */
        .info-box {
            background: var(--green-lt);
            border: 1px solid #A5D6A7;
            border-radius: 8px;
            padding: 12px 14px;
            margin-top: 16px;
            display: flex;
            gap: 10px;
        }
        .info-box i { color: var(--green); flex-shrink: 0; margin-top: 2px; }
        .info-box-text { font-size: 0.75rem; color: #2E7D32; line-height: 1.5; }
        .info-box-text b { color: var(--green-dk); display: block; margin-bottom: 2px; }

        /* ── Back link ── */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: var(--muted);
            text-decoration: none;
            font-size: 0.8rem;
            margin-top: 14px;
            transition: color 0.2s;
        }
        .back-link:hover { color: var(--green); }

        /* ── Alert (errors keep red) ── */
        .error-alert {
            background: var(--red-lt);
            border: 1px solid #f5c6c6;
            border-left: 4px solid var(--red);
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 0.84rem;
            color: var(--red);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* ── Footer ── */
        footer {
            background: var(--green);
            color: rgba(255,255,255,0.6);
            padding: 16px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.73rem;
        }
        footer span { color: var(--gold); font-weight: 500; }
        footer a { color: rgba(255,255,255,0.5); text-decoration: none; margin-left: 16px; }
        footer a:hover { color: var(--gold); }

        @media (max-width: 720px) {
            .main-grid { grid-template-columns: 1fr; padding: 20px 16px 40px; }
            .page-heading { padding: 20px 16px 12px; }
            .top-nav { padding: 0 16px; }
        }
    </style>


</head>
<body>

<nav class="top-nav">
    <div class="brand-block">
        <div class="brand-crest">🐄</div>
        <div class="brand-text">
            <span class="brand-name">Egerton University</span>
            <span class="brand-sub">Dairy Department</span>
        </div>
    </div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/orders.jsp"><i class="bi bi-bag"></i> My Orders</a>
        <a href="#"><i class="bi bi-headset"></i> Support</a>
    </div>
</nav>
<div class="accent-bar"></div>

<div class="page-heading">
    <div class="breadcrumb-trail">
        Shop <i class="bi bi-chevron-right"></i>
        Cart <i class="bi bi-chevron-right"></i>
        <span>Checkout</span>
    </div>
    <h1>Secure Checkout</h1>
    <p>Complete your order using M-Pesa Lipa Na M-Pesa.</p>
</div>

<div class="main-grid">

    <div>
        <c:if test="${not empty errorMessage}">
            <div class="error-alert">
                <i class="bi bi-exclamation-circle-fill"></i>
                ${errorMessage}
            </div>
        </c:if>

        <div class="card-box">
            <div class="card-header-bar">
                <span class="card-title">
                    <i class="bi bi-phone-fill"></i> M-Pesa Payment
                </span>
                <span class="mpesa-badge">M-PESA ●</span>
            </div>
            <div class="card-body-pad">
                <form action="${pageContext.request.contextPath}/pay" method="post">
                    <input type="hidden" name="orderId" value="${payment.orderId}">
                    <input type="hidden" name="amount"  value="${payment.amount}">

                    <div class="field-label">Safaricom Phone Number</div>
                    <input
                        type="tel"
                        class="phone-field"
                        name="phone"
                        placeholder="e.g. 0712 345 678"
                        required
                        pattern="^(0|\+?254)?[7][0-9]{8}$"
                        title="Enter a valid Safaricom number">
                    <p class="phone-hint">
                        Enter the M-Pesa number to charge. You will receive a prompt on your handset — enter your PIN to confirm.
                    </p>

                    <button type="submit" class="btn-pay">
                        <i class="bi bi-lock-fill"></i>
                        Pay Now with Lipa Na M-Pesa &nbsp;→
                    </button>
                </form>

                <div class="trust-row">
                    <span class="trust-item"><i class="bi bi-shield-lock-fill"></i> SECURE SSL</span>
                    <span class="trust-item"><i class="bi bi-patch-check-fill"></i> M-PESA VERIFIED</span>
                    <span class="trust-item"><i class="bi bi-building"></i> EGERTON OFFICIAL</span>
                </div>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/checkout.jsp" class="back-link">
            <i class="bi bi-arrow-left"></i> Back to Cart
        </a>
    </div>

    <!-- Order Summary -->
    <div>
        <div class="card-box">
            <div class="card-header-bar">
                <span class="card-title"><i class="bi bi-receipt"></i> Order Summary</span>
            </div>
            <div class="card-body-pad">
                <div class="order-item-row">
                    <div class="item-icon">🥛</div>
                    <div class="item-details">
                        <div class="item-name">Dairy Products</div>
                        <div class="item-sub">Order #${payment.orderId}</div>
                    </div>
                    <div class="item-price">
                        KES <fmt:formatNumber value="${subtotal}" type="number" minFractionDigits="0" maxFractionDigits="0"/>
                    </div>
                </div>

                <div class="divider"></div>

                <div class="totals-row">
                    <span>Subtotal</span>
                    <span>KES <fmt:formatNumber value="${subtotal}" type="number" minFractionDigits="2"/></span>
                </div>
                <div class="totals-row">
                    <span>Delivery Fee</span>
                    <span>KES <fmt:formatNumber value="${deliveryFee}" type="number" minFractionDigits="2"/></span>
                </div>

                <div class="divider"></div>

                <div class="totals-final">
                    <span>Total</span>
                    <span>KES <fmt:formatNumber value="${payment.amount}" type="number" minFractionDigits="2"/></span>
                </div>

                <div class="info-box">
                    <i class="bi bi-patch-check-fill"></i>
                    <div class="info-box-text">
                        <b>Egerton University Dairy</b>
                        Fresh produce direct from our university farm. All orders are processed through the official Egerton University payment system.
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<footer>
    <span>Egerton University Dairy Department</span>
    <div>
        © 2025 Egerton University &nbsp;|&nbsp;
        <a href="#">Privacy Policy</a>
        <a href="#">Terms of Service</a>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
