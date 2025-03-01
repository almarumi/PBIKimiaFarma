SELECT DISTINCT -- Agar tidak ada duplikasi data
    t.transaction_id, 
    t.date, 
    b.branch_id, 
    b.branch_name, 
    b.kota, 
    b.provinsi, 
    b.rating AS rating_cabang, -- Membedakan rating cabang dan rating transaksi   
    t.customer_name, 
    p.product_id, 
    p.product_name, 
    t.price, 
    t.discount_percentage, 
    CASE 
        WHEN t.price <= 50000 THEN 0.10 
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15 
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20 
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25 
        ELSE 0.30 
    END AS persentase_gross_laba,
    t.price * (1 - t.discount_percentage / 100) AS nett_sales, 
    (t.price * (1 - t.discount_percentage / 100)) * 
    CASE 
        WHEN t.price <= 50000 THEN 0.10 
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15 
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20 
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25 
        ELSE 0.30 
    END AS nett_profit,
    t.rating AS rating_transaksi  -- Membedakan rating cabang dan rating transaksi
FROM `rakamin-kf-analytics-451302.kf_final_transaction.kf_final_transaction` t -- t sebagai alias untuk memudahkan
LEFT JOIN `rakamin-kf-analytics-451302.kf_kantor_cabang.kf_kantor_cabang` b 
    ON t.branch_id = b.branch_id
LEFT JOIN `rakamin-kf-analytics-451302.kf_inventory.kf_inventory` c 
    ON t.product_id = c.product_id
LEFT JOIN `rakamin-kf-analytics-451302.kf_product.kf_product` p 
    ON t.product_id = p.product_id
LIMIT 1000000;  -- Batasi jumlah hasil karena query terlalu besar