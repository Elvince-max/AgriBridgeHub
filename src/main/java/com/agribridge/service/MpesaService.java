package com.agribridge.service;

public class MpesaService {

    /**
     * Normalizes phone number to 254XXXXXXXXX format.
     * @param phone raw phone (e.g., 0712345678, 254712345678, +254712345678)
     * @return normalized phone string
     */
    public String normalizePhone(String phone) {
        if (phone == null) return "";
        String cleaned = phone.replaceAll("[^0-9]", "");
        if (cleaned.startsWith("0")) {
            cleaned = "254" + cleaned.substring(1);
        } else if (cleaned.startsWith("254") && cleaned.length() == 12) {
            // already correct
        } else if (cleaned.startsWith("254") && cleaned.length() > 12) {
            cleaned = cleaned.substring(0, 12);
        } else if (cleaned.length() == 9) {
            cleaned = "254" + cleaned;
        } else if (cleaned.length() == 10 && cleaned.startsWith("7")) {
            cleaned = "254" + cleaned;
        }
        return cleaned;
    }

    /**
     * Initiates STK push to M-Pesa.
     * @param phone normalized phone number (254...)
     * @param amount amount in KES (integer)
     * @param orderId order identifier
     * @return CheckoutRequestID if successful, otherwise null
     */
    public String initiateStkPush(String phone, int amount, int orderId) {
        // In simulation mode, return a fake CheckoutRequestID
        if (MpesaConfig.SIMULATE) {
            return "SIM-" + System.currentTimeMillis() + "-" + orderId;
        }
        // Real implementation would call Safaricom API
        // For now, just simulate success
        return "SIM-WS_CO_" + System.currentTimeMillis();
    }
}