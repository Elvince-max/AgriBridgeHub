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