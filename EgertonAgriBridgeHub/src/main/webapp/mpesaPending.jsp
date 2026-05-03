<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userType = (String) session.getAttribute("userType");

    if (userType == null || !"CUSTOMER".equals(userType.trim().toUpperCase())) {
        response.sendRedirect("login.jsp");
        return;
    }

    String orderId = request.getParameter("orderId");

    if (orderId == null || orderId.trim().isEmpty()) {
        response.sendRedirect("myOrders.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>M-Pesa Payment Pending - Egerton AgriBridge Hub</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css?v=8">
</head>

<body class="mpesa-pending-body">

<!-- TOP NAV -->
<div class="mpesa-pending-nav">
    <div class="mpesa-pending-logo">EgertonAgriBridgeHub</div>

    <div class="mpesa-pending-links">
        <a href="customerDashboard.jsp">Dashboard</a>
        <a href="index.jsp">Home</a>
        <a href="products.jsp">Marketplace</a>
        <a href="myOrders.jsp">My Orders</a>
        <a href="logout" class="mpesa-logout-link"
           onclick="return confirm('Are you sure you want to logout?');">
            Logout
        </a>
    </div>
</div>

<div class="mpesa-pending-page">

    <div class="mpesa-breadcrumb">
        <a href="customerDashboard.jsp">DASHBOARD</a>
        <span>›</span>
        <a href="myOrders.jsp">MY ORDERS</a>
        <span>›</span>
        <strong>ORDER #<%= orderId %></strong>
    </div>

    <div class="mpesa-pending-card">

        <!-- HEADER -->
        <div class="mpesa-pending-header" id="pendingHeader">
            <p class="eyebrow">M-PESA CHECKOUT</p>
            <h1 id="headerTitle">Payment in Progress</h1>
            <p id="headerSubtitle">
                Please complete the M-Pesa prompt on your phone to confirm Order #<%= orderId %>.
            </p>
        </div>

        <div class="mpesa-pending-content">

            <!-- LEFT VISUAL -->
            <section class="mpesa-visual-panel">

                <div class="mpesa-animation-area">

                    <div class="mpesa-spinner-wrap" id="spinnerWrap">
                        <div class="mpesa-spinner-ring"></div>
                        <div class="mpesa-spinner-core">M</div>
                    </div>

                    <div class="mpesa-success-animation" id="successAnimation">
                        <div class="mpesa-success-check"></div>
                    </div>

                    <div class="mpesa-failed-animation" id="failedAnimation">
                        ×
                    </div>

                </div>

                <div class="mpesa-phone-shell">
                    <div class="mpesa-phone-notch"></div>

                    <div class="mpesa-phone-screen" id="phoneScreen">
                        <p id="phoneText">M-Pesa Request Sent</p>
                        <h3>Order #<%= orderId %></h3>
                        <span id="phoneStatus" class="fade-pulse">
                            Awaiting PIN confirmation...
                        </span>
                    </div>
                </div>

            </section>

            <!-- RIGHT DETAILS -->
            <section class="mpesa-status-panel">

                <div class="mpesa-status-main">
                    <h2 id="mainTitle">Waiting for Payment Confirmation</h2>
                    <p id="mainSubtext">
                        An STK Push has been sent to your Safaricom phone.
                        Enter your M-Pesa PIN on your device to authorize the payment.
                    </p>
                </div>

                <div class="mpesa-meta-row">
                    <div>
                        <span>Order Number</span>
                        <strong>#<%= orderId %></strong>
                    </div>

                    <div>
                        <span>Payment Method</span>
                        <strong>M-Pesa STK Push</strong>
                    </div>

                    <div>
                        <span>Current Status</span>
                        <strong id="statusChip">Pending</strong>
                    </div>
                </div>

                <div class="mpesa-live-box">
                    <h3 id="statusText">Waiting for payment confirmation...</h3>
                    <p id="smallText">
                        Do not close or refresh this page while we verify your payment.
                    </p>
                    <span id="timerText">Elapsed time: 0s</span>
                </div>

                <div class="mpesa-info-box" id="infoBox">
                    <strong>Tip:</strong>
                    If you do not see the prompt immediately, wait a few seconds and confirm
                    that your phone is online and able to receive M-Pesa prompts.
                </div>

                <div class="mpesa-actions">
                    <a id="ordersBtn" class="mpesa-primary-action hidden" href="myOrders.jsp">
                        View My Orders
                    </a>

                    <a id="detailsBtn" class="mpesa-secondary-action hidden" href="orderDetails.jsp?orderId=<%= orderId %>">
                        View Order Details
                    </a>

                    <a id="retryBtn" class="mpesa-warning-action hidden" href="payment.jsp?orderId=<%= orderId %>">
                        Try Again
                    </a>
                </div>

            </section>

        </div>

        <!-- PROGRESS STEPS -->
        <section class="mpesa-progress-section">
            <div class="mpesa-section-title">
                <h2>Payment Progress</h2>
                <p>Your order will update automatically after confirmation.</p>
            </div>

            <div class="mpesa-step-grid">

                <div class="mpesa-step-card done" id="step1">
                    <div class="mpesa-step-number" id="step1Badge">✓</div>
                    <h4>STK Push Sent</h4>
                    <p>A payment request has been sent to your Safaricom number.</p>
                </div>

                <div class="mpesa-step-card active" id="step2">
                    <div class="mpesa-step-number" id="step2Badge">2</div>
                    <h4>Authorize Payment</h4>
                    <p>Enter your M-Pesa PIN on your phone to approve the transaction.</p>
                </div>

                <div class="mpesa-step-card" id="step3">
                    <div class="mpesa-step-number" id="step3Badge">3</div>
                    <h4>Confirming Payment</h4>
                    <p>AgriBridge will verify the transaction and update your order.</p>
                </div>

            </div>
        </section>

    </div>

</div>

<script>
    const orderId = "<%= orderId %>";
    let seconds = 0;
    let finished = false;

    const timerInterval = setInterval(updateTimer, 1000);

    function updateTimer() {
        if (finished) return;

        seconds++;
        document.getElementById("timerText").innerText = "Elapsed time: " + seconds + "s";

        if (seconds === 8) {
            markConfirmingStep();
        }

        if (seconds === 90) {
            showLongWaitMessage();
        }
    }

    function markConfirmingStep() {
        if (finished) return;

        document.getElementById("step2").classList.remove("active");
        document.getElementById("step2").classList.add("done");
        document.getElementById("step2Badge").innerText = "✓";

        document.getElementById("step3").classList.add("active");

        document.getElementById("statusText").innerText = "Confirming transaction...";
        document.getElementById("smallText").innerText = "We are checking the M-Pesa payment response.";
        document.getElementById("phoneStatus").innerText = "Confirming payment...";
    }

    function showLongWaitMessage() {
        if (finished) return;

        document.getElementById("smallText").innerText =
            "This is taking longer than usual. If you completed payment, please wait a little longer or check My Orders.";
    }

    function markSuccess() {
        finished = true;
        clearInterval(timerInterval);

        document.getElementById("spinnerWrap").classList.add("hidden");
        document.getElementById("successAnimation").style.display = "flex";

        document.getElementById("pendingHeader").classList.add("success");
        document.getElementById("headerTitle").innerText = "Payment Successful";
        document.getElementById("headerSubtitle").innerText =
            "Your transaction has been verified and your order has been updated.";

        document.getElementById("mainTitle").innerText = "Payment Confirmed";
        document.getElementById("mainSubtext").innerText =
            "Thank you. Your M-Pesa payment has been confirmed successfully.";

        document.getElementById("statusText").innerText = "Payment successful";
        document.getElementById("statusText").classList.add("status-success");
        document.getElementById("smallText").innerText = "Redirecting you to your order details...";
        document.getElementById("statusChip").innerText = "Paid";

        document.getElementById("phoneText").innerText = "Payment Successful";
        document.getElementById("phoneStatus").innerText = "Transaction confirmed";
        document.getElementById("phoneStatus").classList.remove("fade-pulse");

        document.getElementById("phoneScreen").classList.add("success");

        document.getElementById("step1").classList.add("done");
        document.getElementById("step1Badge").innerText = "✓";

        document.getElementById("step2").classList.remove("active");
        document.getElementById("step2").classList.add("done");
        document.getElementById("step2Badge").innerText = "✓";

        document.getElementById("step3").classList.remove("active");
        document.getElementById("step3").classList.add("done");
        document.getElementById("step3Badge").innerText = "✓";

        document.getElementById("infoBox").innerHTML =
            "<strong>Success:</strong> Your payment has been received. Your order is now ready for processing.";

        document.getElementById("ordersBtn").classList.remove("hidden");
        document.getElementById("detailsBtn").classList.remove("hidden");

        setTimeout(() => {
            window.location.href = "orderDetails.jsp?orderId=" + orderId;
        }, 3500);
    }

    function markFailed() {
        finished = true;
        clearInterval(timerInterval);

        document.getElementById("spinnerWrap").classList.add("hidden");
        document.getElementById("failedAnimation").style.display = "flex";

        document.getElementById("pendingHeader").classList.add("failed");
        document.getElementById("headerTitle").innerText = "Payment Failed";
        document.getElementById("headerSubtitle").innerText =
            "The transaction was cancelled, timed out, or not completed.";

        document.getElementById("mainTitle").innerText = "Payment Not Completed";
        document.getElementById("mainSubtext").innerText =
            "Your M-Pesa payment could not be confirmed. You can retry the payment below.";

        document.getElementById("statusText").innerText = "Payment failed or cancelled";
        document.getElementById("statusText").classList.add("status-failed");
        document.getElementById("smallText").innerText =
            "Please retry the transaction or select another payment option.";
        document.getElementById("statusChip").innerText = "Failed";

        document.getElementById("phoneText").innerText = "Payment Failed";
        document.getElementById("phoneStatus").innerText = "Transaction not completed";
        document.getElementById("phoneStatus").classList.remove("fade-pulse");

        document.getElementById("phoneScreen").classList.add("failed");

        document.getElementById("step2").classList.remove("active");
        document.getElementById("step3").classList.remove("active");
        document.getElementById("step3").classList.add("failed");
        document.getElementById("step3Badge").innerText = "×";

        document.getElementById("infoBox").innerHTML =
            "<strong>Notice:</strong> The payment was not completed. You can send another STK Push request.";

        document.getElementById("retryBtn").classList.remove("hidden");
        document.getElementById("ordersBtn").classList.remove("hidden");
    }

    function checkPaymentStatus() {
        if (finished) return;

        fetch("paymentStatus?orderId=" + orderId)
            .then(response => {
                if (!response.ok) {
                    throw new Error("Could not check payment status");
                }

                return response.json();
            })
            .then(data => {
                const status = (data.status || "PENDING").toUpperCase();

                if (status === "PAID" || status === "COMPLETED") {
                    markSuccess();

                } else if (status === "FAILED" || status === "CANCELLED") {
                    markFailed();

                } else {
                    setTimeout(checkPaymentStatus, 3000);
                }
            })
            .catch(error => {
                console.log("Status check error:", error);
                setTimeout(checkPaymentStatus, 5000);
            });
    }

    checkPaymentStatus();
</script>

</body>
</html>