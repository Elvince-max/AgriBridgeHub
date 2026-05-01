package com.agribridge.services;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class MpesaConfig {

    public static final boolean SIMULATE = false;

    private static final Properties FILE_PROPS = loadFileProperties();

    public static final String CONSUMER_KEY    = get("MPESA_CONSUMER_KEY");
    public static final String CONSUMER_SECRET = get("MPESA_CONSUMER_SECRET");

    public static final String SHORTCODE         = "174379";
    public static final String PASSKEY           = get("MPESA_PASSKEY");
    public static final String TRANSACTION_TYPE  = "CustomerPayBillOnline";
    public static final String ACCOUNT_REFERENCE = "AgriBridgeHub";
    public static final String TRANSACTION_DESC  = "Agricultural Product Purchase";

    public static final String CALLBACK_URL  = get("MPESA_CALLBACK_URL");

    public static final String OAUTH_URL     = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials";
    public static final String STK_PUSH_URL  = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest";

    // Reads a config value from environment variables, JVM properties, or mpesa.properties
    private static String get(String key) {
        String value = System.getenv(key);
        if (isBlank(value)) value = System.getProperty(key);
        if (isBlank(value) && FILE_PROPS != null) value = FILE_PROPS.getProperty(key);

        if (isBlank(value)) {
            if (SIMULATE) return "SIMULATED";
            System.err.println("[MpesaConfig] Missing config: " + key);
            return "";
        }
        return value.trim();
    }

    private static Properties loadFileProperties() {
        Properties props = new Properties();
        // Load from classpath (src/main/resources/mpesa.properties → WEB-INF/classes/)
        try (java.io.InputStream is = MpesaConfig.class.getClassLoader()
                .getResourceAsStream("mpesa.properties")) {
            if (is != null) {
                props.load(is);
                System.out.println("[MpesaConfig] Loaded mpesa.properties from classpath.");
                return props;
            }
        } catch (IOException e) {
            System.err.println("[MpesaConfig] Could not read mpesa.properties: " + e.getMessage());
        }

        // Fallback: try project root relative path (for local IDE run)
        File f = new File("mpesa.properties");
        if (!f.exists()) f = new File("../mpesa.properties");
        if (f.exists()) {
            try (FileInputStream fis = new FileInputStream(f)) {
                props.load(fis);
                System.out.println("[MpesaConfig] Loaded from: " + f.getAbsolutePath());
                return props;
            } catch (IOException e) {
                System.err.println("[MpesaConfig] Could not read mpesa.properties: " + e.getMessage());
            }
        }
        System.err.println("[MpesaConfig] mpesa.properties not found on classpath or disk.");
        return props;
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}