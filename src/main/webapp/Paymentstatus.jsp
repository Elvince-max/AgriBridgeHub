<%@page import="com.agribridge.controller.MpesaCallbackServlet"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String txCode = (String) session.getAttribute("transactionCode");
    if (txCode != null) {
        String callbackResult = com.agribridge.controller.MpesaCallbackServlet.getAndRemoveResult(txCode);
        if (callbackResult != null) {
            if (callbackResult.startsWith("Completed:")) {
                session.setAttribute("paymentStatus", "Completed");
                String receipt = callbackResult.substring("Completed:".length());
                if (!receipt.isEmpty()) session.setAttribute("transactionCode", receipt);
            } else {
                session.setAttribute("paymentStatus", "Failed");
            }
        }
    }
%>

<jsp:useBean id="payment" class="com.agribridge.model.Payment" scope="session" />
<jsp:setProperty name="payment" property="paymentStatus"   value="${sessionScope.paymentStatus}" />
<jsp:setProperty name="payment" property="transactionCode" value="${sessionScope.transactionCode}" />

<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="orderId"     value="${sessionScope.paymentOrderId != null ? sessionScope.paymentOrderId : 0}" />
<c:set var="isCompleted" value="${payment.paymentStatus eq 'Completed'}" />
<c:set var="isFailed"    value="${payment.paymentStatus eq 'Failed' or payment.paymentStatus eq 'Cancelled'}" />
<c:set var="isPending"   value="${payment.paymentStatus eq 'Pending' or empty payment.paymentStatus}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${isCompleted}">Order Confirmed</c:when>
            <c:when test="${isFailed}">Payment Failed</c:when>
            <c:otherwise>Payment Pending</c:otherwise>
        </c:choose>
        | Egerton University Dairy
    </title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <c:if test="${isPending}">
        <meta http-equiv="refresh" content="8">
    </c:if>

    <style>
        :root {
            --red:    #B71C1C;
            --red-dk: #8B0000;
            --gold:   #C9A84C;
            --gold-lt:#F5EDD0;
            --green:  #1B5E20;
            --cream:  #FDF8F0;
            --card:   #FFFFFF;
            --border: #E8DDD0;
            --text:   #1a1a1a;
            --muted:  #6b6b6b;
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
            background: var(--red);
            padding: 0 32px;
            display: flex;
            justify-content: space-between;
            align-items: stretch;
            min-height: 60px;
        }
        .brand-block { display: flex; align-items: center; gap: 12px; padding: 12px 0; }
        .brand-crest {
            width: 36px; height: 36px; background: var(--gold);
            border-radius: 50%; display: flex; align-items: center;
            justify-content: center; font-size: 1.1rem;
        }
        .brand-name  { font-size: 0.95rem; font-weight: 700; color: #fff; display: block; }
        .brand-sub   { font-size: 0.65rem; color: var(--gold); letter-spacing: 1.5px; text-transform: uppercase; display: block; }

        .nav-status {
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            align-self: center;
            padding: 5px 14px;
            border-radius: 20px;
        }
        .status-confirmed { background: var(--gold-lt); color: var(--red-dk); }
        .status-pending   { background: rgba(255,255,255,0.15); color: var(--gold); }
        .status-failed    { background: rgba(0,0,0,0.2); color: #ffaaaa; }

        .accent-bar { height: 4px; background: linear-gradient(90deg, var(--gold) 0%, var(--red) 60%, var(--green) 100%); }

        /* ── Page container ── */
        .page-container { max-width: 820px; margin: 36px auto; padding: 0 24px 60px; }

        /* ── Status icon ── */
        .icon-circle {
            width: 72px; height: 72px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; margin: 0 auto 18px;
        }
        .icon-success { background: var(--green); color: #fff; }
        .icon-pending { background: var(--gold); color: var(--red-dk); }
        .icon-failed  { background: var(--red); color: #fff; }

        .status-heading { text-align: center; margin-bottom: 4px; }
        .status-heading h2 { font-size: 1.6rem; font-weight: 700; color: var(--red); }
        .status-heading p  { color: var(--muted); font-size: 0.84rem; }

        /* ── Card ── */
        .card-box { background: var(--card); border-radius: 12px; border: 1px solid var(--border); overflow: hidden; margin-top: 24px; }
        .card-header-bar {
            background: var(--red); padding: 12px 24px;
            display: flex; align-items: center; gap: 8px;
        }
        .card-header-bar .card-title { color: #fff; font-size: 0.88rem; font-weight: 600; display: flex; align-items: center; gap: 8px; }
        .card-body-pad { padding: 24px; }

        .card-section-title { font-size: 0.78rem; font-weight: 700; color: var(--red); letter-spacing: 0.3px; margin-bottom: 16px; }

        /* ── Info rows ── */
        .info-label { font-size: 0.63rem; text-transform: uppercase; letter-spacing: 1px; color: #aaa; margin-bottom: 3px; }
        .info-value { font-size: 0.88rem; color: var(--text); margin-bottom: 14px; display: flex; align-items: center; gap: 7px; }
        .info-value i { color: var(--green); }

        /* ── Order summary ── */
        .order-item-row { display: flex; align-items: center; gap: 12px; margin-bottom: 12px; }
        .item-icon { width: 42px; height: 42px; border-radius: 7px; background: var(--gold-lt); border: 1px solid var(--gold); display: flex; align-items: center; justify-content: center; font-size: 1.1rem; flex-shrink: 0; }
        .item-name { font-size: 0.84rem; font-weight: 600; flex: 1; }
        .item-sub  { font-size: 0.73rem; color: var(--muted); }
        .item-price { font-size: 0.84rem; font-weight: 700; color: var(--red); white-space: nowrap; }
        .divider   { border-top: 1px solid var(--border); margin: 12px 0; }
        .totals-row   { display: flex; justify-content: space-between; font-size: 0.82rem; color: var(--muted); margin-bottom: 5px; }
        .totals-final { display: flex; justify-content: space-between; font-size: 0.9rem; font-weight: 700; color: var(--red); margin-top: 8px; }

        /* ── Buttons ── */
        .btn-primary-eu {
            background: var(--red); color: white; border: none; border-radius: 8px;
            padding: 12px 20px; font-size: 0.88rem; font-weight: 600;
            font-family: 'Inter', sans-serif; display: inline-flex; align-items: center;
            justify-content: center; gap: 7px; text-decoration: none;
            transition: background 0.2s; width: 100%; margin-bottom: 10px;
        }
        .btn-primary-eu:hover { background: var(--red-dk); color: white; }
        .btn-secondary-eu {
            background: var(--gold-lt); color: var(--red-dk); border: 1px solid var(--gold);
            border-radius: 8px; padding: 11px 20px; font-size: 0.85rem;
            font-family: 'Inter', sans-serif; display: inline-flex; align-items: center;
            justify-content: center; gap: 7px; text-decoration: none;
            transition: background 0.2s; width: 100%;
        }
        .btn-secondary-eu:hover { background: var(--gold); color: var(--red-dk); }

        /* ── Full status card (pending / failed) ── */
        .full-status-card {
            background: var(--card); border-radius: 12px; padding: 48px 32px;
            text-align: center; border: 1px solid var(--border); margin-top: 24px;
        }

        /* ── Pending spinner ── */
        .pending-spinner {
            width: 48px; height: 48px;
            border: 4px solid var(--gold);
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 0.9s linear infinite;
            margin: 20px auto;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        .support-line { text-align: center; margin-top: 24px; font-size: 0.82rem; color: var(--muted); }
        .support-line a { color: var(--red); text-decoration: none; font-weight: 600; }
        .support-line a:hover { color: var(--red-dk); }

        /* ── Footer ── */
        footer {
            background: var(--red); color: rgba(255,255,255,0.6);
            padding: 16px 32px; display: flex;
            justify-content: space-between; align-items: center; font-size: 0.73rem;
        }
        footer span { color: var(--gold); font-weight: 500; }
        footer a { color: rgba(255,255,255,0.5); text-decoration: none; margin-left: 16px; }
        footer a:hover { color: var(--gold); }

        @media (max-width: 620px) {
            .page-container { padding: 0 14px 40px; }
            .top-nav { padding: 0 16px; }
        }
    </style>
</head>
<body>

<nav class="top-nav">
    <div class="brand-block">
        <div class="brand-crest">🐄</div>
        <div>
            <span class="brand-name">Egerton University</span>
            <span class="brand-sub">Dairy Department</span>
        </div>
    </div>
    <c:choose>
        <c:when test="${isCompleted}">
            <span class="nav-status status-confirmed"><i class="bi bi-check-circle-fill"></i> ORDER CONFIRMED</span>
        </c:when>
        <c:when test="${isFailed}">
            <span class="nav-status status-failed"><i class="bi bi-x-circle-fill"></i> PAYMENT FAILED</span>
        </c:when>
        <c:otherwise>
            <span class="nav-status status-pending"><i class="bi bi-hourglass-split"></i> PAYMENT PENDING</span>
        </c:otherwise>
    </c:choose>
</nav>
<div class="accent-bar"></div>

<div class="page-container">

    <c:choose>

        <%-- SUCCESS --%>
        <c:when test="${isCompleted}">

            <div style="text-align:center; margin-bottom:4px; margin-top:12px;">
                <div class="icon-circle icon-success">
                    <i class="bi bi-check-lg"></i>
                </div>
                <div class="status-heading">
                    <h2>Order Placed Successfully!</h2>
                    <p>Thank you. Your payment has been received by Egerton University Dairy.</p>
                </div>
            </div>

            <div class="card-box">
                <div class="card-header-bar">
                    <span class="card-title"><i class="bi bi-receipt-cutoff"></i> Payment Confirmation</span>
                </div>
                <div class="card-body-pad">
                    <div class="info-label">M-Pesa Receipt</div>
                    <div class="info-value"><i class="bi bi-patch-check-fill"></i> ${payment.transactionCode}</div>

                    <div class="info-label">Order Reference</div>
                    <div class="info-value"><i class="bi bi-hash"></i> #${sessionScope.paymentOrderId}</div>

                    <div class="info-label">Phone Charged</div>
                    <div class="info-value"><i class="bi bi-phone-fill"></i> ${sessionScope.paymentPhone}</div>
                </div>
            </div>

            <div class="card-box">
                <div class="card-header-bar">
                    <span class="card-title"><i class="bi bi-basket3-fill"></i> Order Summary</span>
                </div>
                <div class="card-body-pad">
                    <div class="order-item-row">
                        <div class="item-icon">🥛</div>
                        <div style="flex:1;">
                            <div class="item-name">Dairy Products</div>
                            <div class="item-sub">Order #${sessionScope.paymentOrderId}</div>
                        </div>
                        <div class="item-price">
                            KES <fmt:formatNumber value="${sessionScope.paymentAmount}" type="number" minFractionDigits="2"/>
                        </div>
                    </div>

                    <div class="divider"></div>

                    <div class="totals-row">
                        <span>Subtotal</span>
                        <span>KES <fmt:formatNumber value="${sessionScope.paymentAmount}" type="number" minFractionDigits="2"/></span>
                    </div>
                    <div class="totals-row">
                        <span>Delivery Fee</span>
                        <span>KES 150.00</span>
                    </div>

                    <div class="divider"></div>

                    <div class="totals-final">
                        <span>Total Paid</span>
                        <span>KES <fmt:formatNumber value="${sessionScope.paymentAmount + 150}" type="number" minFractionDigits="2"/></span>
                    </div>
                </div>
            </div>

            <div style="margin-top:20px;">
                <a href="${pageContext.request.contextPath}/orders.jsp" class="btn-primary-eu">
                    <i class="bi bi-bag-check-fill"></i> Track My Order
                </a>
                <a href="${pageContext.request.contextPath}/products.jsp" class="btn-secondary-eu">
                    <i class="bi bi-shop"></i> Continue Shopping
                </a>
            </div>

            <div class="support-line">
                Need help? <a href="#">Contact Dairy Support</a>
            </div>

        </c:when>

        <%-- PENDING --%>
        <c:when test="${isPending}">
            <div class="full-status-card">
                <div class="icon-circle icon-pending">
                    <i class="bi bi-hourglass-split"></i>
                </div>
                <h4 style="font-weight:700; color: var(--red); margin-bottom:8px;">Waiting for Payment...</h4>
                <p style="color: var(--muted); font-size:0.88rem; margin-bottom:4px;">
                    A payment prompt has been sent to your M-Pesa number.
                </p>
                <p style="color: var(--text); font-size:0.88rem;">
                    <strong>Enter your PIN on your phone</strong> to complete the payment.
                </p>
                <div class="pending-spinner"></div>
                <p style="font-size:0.77rem; color:#bbb;">
                    This page refreshes automatically every 8 seconds.
                </p>
                <c:if test="${not empty payment.transactionCode}">
                    <p style="font-size:0.72rem; color:#ccc; margin-top:6px;">
                        Ref: ${payment.transactionCode}
                    </p>
                </c:if>
                <a href="${pageContext.request.contextPath}/products.jsp"
                   class="btn-secondary-eu" style="max-width:220px; margin:16px auto 0;">
                    <i class="bi bi-x-circle"></i> Cancel &amp; Go Back
                </a>
            </div>
        </c:when>

        <%-- FAILED --%>
        <c:otherwise>
            <div class="full-status-card">
                <div class="icon-circle icon-failed">
                    <i class="bi bi-x-lg"></i>
                </div>
                <h4 style="font-weight:700; color: var(--red); margin-bottom:8px;">Payment Failed</h4>
                <p style="color: var(--muted); font-size:0.88rem;">
                    The payment was not completed. You may have cancelled or it timed out.
                </p>
                <div style="display:flex; gap:12px; justify-content:center; margin-top:20px; flex-wrap:wrap;">
                    <a href="${pageContext.request.contextPath}/pay?orderId=${orderId}"
                       class="btn-primary-eu" style="max-width:180px;">
                        <i class="bi bi-arrow-repeat"></i> Try Again
                    </a>
                    <a href="${pageContext.request.contextPath}/products.jsp"
                       class="btn-secondary-eu" style="max-width:180px;">
                        <i class="bi bi-house"></i> Back to Shop
                    </a>
                </div>
            </div>
        </c:otherwise>

    </c:choose>

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
