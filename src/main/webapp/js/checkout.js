    // Delivery slot selection
    const slots = document.querySelectorAll('.delivery-slot');
    const slotInput = document.getElementById('deliverySlot');
    slots.forEach(slot => {
        slot.addEventListener('click', () => {
            slots.forEach(s => {
                s.classList.remove('selected');
                s.querySelector('.check-icon').style.display = 'none';
            });
            slot.classList.add('selected');
            const checkSpan = slot.querySelector('.check-icon');
            if (checkSpan) checkSpan.style.display = 'inline';
            const slotText = slot.getAttribute('data-slot');
            slotInput.value = slotText;
        });
    });
    // Set initial selected (morning)
    document.querySelector('.delivery-slot').classList.add('selected');
    document.querySelector('.delivery-slot .check-icon').style.display = 'inline';

    // Payment method selection
    const payments = document.querySelectorAll('.payment-method');
    const paymentInput = document.getElementById('paymentMethod');
    payments.forEach(pm => {
        pm.addEventListener('click', () => {
            payments.forEach(p => {
                p.classList.remove('selected');
                p.querySelector('.check-icon').style.display = 'none';
            });
            pm.classList.add('selected');
            pm.querySelector('.check-icon').style.display = 'inline';
            const method = pm.getAttribute('data-payment');
            paymentInput.value = method;
        });
    });

    // Before form submit, copy fullName and phone from visible fields to hidden ones (if you want to keep them in OrderServlet)
    // But we can also modify OrderServlet to read directly from request parameters. 
    // However, the current OrderServlet expects only "address". We'll add the extra fields later.
    // For now, we attach them as additional parameters.
    const form = document.getElementById('checkoutForm');
    form.addEventListener('submit', function(e) {
        const nameInput = document.querySelector('input[name="fullName"]');
        const phoneInput = document.querySelector('input[name="phone"]');
        // Ensure they are not empty (HTML5 required already handles)
        if (!nameInput.value.trim() || !phoneInput.value.trim()) {
            e.preventDefault();
            alert('Please fill in your full name and phone number.');
            return false;
        }
        // The form already has name="fullName" and name="phone", so no need for hidden copies.
        // Also add deliverySlot and paymentMethod (already have hidden inputs)
        return true;
    });

    // Promo code placeholder (simulate)
    document.getElementById('applyPromo').addEventListener('click', function() {
        const code = document.getElementById('promoCode').value;
        const msgDiv = document.getElementById('promoMessage');
        if (code.toLowerCase() === 'fresh10') {
            msgDiv.innerHTML = '<span class="text-success">Promo applied! 10% off (not yet integrated).</span>';
        } else if (code.trim() !== '') {
            msgDiv.innerHTML = '<span class="text-danger">Invalid promo code.</span>';
        } else {
            msgDiv.innerHTML = '<span class="text-muted">Enter a promo code.</span>';
        }
    });