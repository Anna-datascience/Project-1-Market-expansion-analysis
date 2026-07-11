/*=========================================================================================================================================================================================
*/

                                                                   -- DATA EXPLORATION MAGIST DB --
                                                                   -- Project Market Expansion by ENIAC--

/*=========================================================================================================================================================================================
*/


use magist;

SELECT 
    *
FROM
    customers;
    
SELECT 
    *
FROM
    geo;

SELECT 
    *
FROM
    order_items;
    
SELECT 
    *
FROM
    order_payments;
    
SELECT 
    *
FROM
    orders;
    
SELECT 
    *
FROM
    product_category_name_translation;
    
SELECT 
    *
FROM
    products;
    
SELECT 
    *
FROM
    sellers;


/* 1.How many orders are there in the dataset?  

Answer: 99,441 orders  */

SELECT 
    COUNT(*) AS orders_count
FROM
    orders;
 -- ----------------------------------------------------------------------------------------
 
SELECT 
    order_status, COUNT(*) AS 'total'
FROM
    orders
GROUP BY order_status
ORDER BY 'total' DESC;
-- -------------------------------------------------------------------------------------------------

SELECT 
    *
FROM
    customers;
SELECT 
    *
FROM
    geo;

SELECT 
    *
FROM
    orders;


SELECT 
    YEAR(order_purchase_timestamp) AS Year,
    MONTH(order_purchase_timestamp) AS Month,
    COUNT(customer_id)
FROM
    orders
GROUP BY Year , Month
ORDER BY Year , Month;

-- -------------------------------------------------------------------------------------------------------------------------------

SELECT 
    COUNT(DISTINCT product_id)
FROM
    products;


SELECT 
    product_category_name,
    COUNT(DISTINCT product_id) AS 'total products'
FROM
    products
GROUP BY product_category_name
ORDER BY 'total products';

SELECT 
    COUNT(DISTINCT product_id) AS products_count
FROM
    products;

-- ------------------------------------------------------------------------------------------------------------------

SELECT 
    *
FROM
    products
ORDER BY product_photos_qty DESC;

SELECT 
    product_category_name_english,
    COUNT(product_category_name_english) AS 'Number of products'
FROM
    products p
        LEFT JOIN
    product_category_name_translation pr ON p.product_category_name = pr.product_category_name
GROUP BY product_category_name_english
ORDER BY COUNT('number of products') DESC
;



SELECT 
    *
FROM
    products p
        LEFT JOIN
    product_category_name_translation pr ON p.product_category_name = pr.product_category_name
;


-- ---------------------------------------------------------------------------------------------------

SELECT 
    *
FROM
    orders;
SELECT 
    *
FROM
    order_items;
SELECT 
    *
FROM
    order_payments;

SELECT 
    COUNT(DISTINCT product_id)
FROM
    order_items;
-- -----------------------------------------------------------------------------------------------------------

SELECT 
    MIN(price) AS cheapest, MAX(price) AS most_expensive
FROM
    order_items;

-- ---------------------------------------------------------------------------------------------------------------------------------
/* 8.What are the highest and lowest payment values?   

Answer:
Highest payment value = 13,664.1 (fixed telephone 7 nos at 1708 each incl freight ,unit price 1680 )
Lowest payment value = 0


*/

SELECT 
    MAX(payment_value) AS highest, MIN(payment_value) AS lowest
FROM
    order_payments;
SELECT
    SUM(payment_value) AS highest_order
FROM
    order_payments
GROUP BY
    order_id
ORDER BY
    highest_order DESC
LIMIT
    1;
 
    /*select * from order_payments
order by payment_value desc limit 1 ;

select * from order_payments
order by payment_value asc
;

select * from order_payments o  left join order_items oi on o.order_id = oi.order_id
order by payment_value desc limit 1;

select * from order_items where product_id = '5769ef0a239114ac3a854af00df129e4';
select * from products where product_id = '5769ef0a239114ac3a854af00df129e4';
*/
SELECT 
    COUNT(*)
FROM
    orders;

SELECT 
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    DATEDIFF(order_delivered_customer_date,
            order_purchase_timestamp) AS order_fulfillment_time
FROM
    orders;

-- ------------------------------------------------------------------------------------------------------------------
/* 10.Customer review score
Answer :
5	56593
4	18929
1	11571
3	8120
2	3158
98371
 */

SELECT 
    *
FROM
    order_reviews;

SELECT 
    review_score, COUNT(review_score)
FROM
    order_reviews
GROUP BY review_score;

-- ------------------------------------------------------------------------------------------------------------------
/* 11.Does magist have good seller base?
No of sellers = 3095 */

SELECT 
    COUNT(seller_id) AS No_of_sellers
FROM
    sellers;


-- ------------------------------------------------------------------------------------------------------------------

SELECT 
    *
FROM
    order_items o
        INNER JOIN
    products p ON o.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation pr ON p.product_category_name = pr.product_category_name;

-- ------------------------------------------------------------------------------------------------------------------


SELECT 
    *
FROM
    orders;
SELECT 
    COUNT(order_id)
FROM
    orders
WHERE
    order_status = 'delivered';

SELECT 
    order_id,
    order_estimated_delivery_date,
    order_delivered_customer_date,
    DATEDIFF(order_delivered_customer_date,
            order_estimated_delivery_date) AS Delivery_Variance
FROM
    orders
ORDER BY delivery_variance DESC;

SELECT 
    COUNT(order_id) AS No_of_late_deliveries
FROM
    orders
WHERE
    DATEDIFF(order_delivered_customer_date,
            order_estimated_delivery_date) > 0;

SELECT 
    COUNT(order_id) AS Delivered_on_time
FROM
    orders
WHERE
    DATEDIFF(order_delivered_customer_date,
            order_estimated_delivery_date) = 0;

SELECT 
    COUNT(order_id) AS Delivered_early
FROM
    orders
WHERE
    DATEDIFF(order_delivered_customer_date,
            order_estimated_delivery_date) < 0;

-- ------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT
    pt.product_category_name_english,
    CASE
        WHEN
            pt.product_category_name_english IN ('audio' , 'cine_photo',
                'consoles_games',
                'computers',
                'computers_accessories',
                'electronics',
                'musical_instruments',
                'pc_gamer',
                'tablets_printing_image',
                'telephony',
                'fixed_telephony')
        THEN
            'Core Tech'
        WHEN
            pt.product_category_name_english IN ('air_conditioning' , 'home_appliances',
                'home_appliances_2',
                'small_appliances',
                'small_appliances_home_oven_and_coffee',
                'portable_kitchen_food_processors')
        THEN
            'Home Electronics / Appliances'
        WHEN
            pt.product_category_name_english IN ('auto' , 'cool_stuff',
                'security_and_services',
                'signaling_and_security')
        THEN
            'Tech-Adjacent'
        WHEN
            pt.product_category_name_english IN ('health_beauty' , 'toys',
                'food',
                'drinks',
                'bed_bath_table',
                'housewares',
                'pet_shop',
                'flowers')
                OR pt.product_category_name_english LIKE 'fashion_%'
                OR pt.product_category_name_english LIKE 'books_%'
                OR pt.product_category_name_english LIKE 'furniture_%'
        THEN
            'NOT Tech'
        ELSE 'Unclassified'
    END AS category_group
FROM
    products p
        LEFT JOIN
    product_category_name_translation pt ON p.product_category_name = pt.product_category_name;

/* 	Answer: 

Core Tech Categories:
'audio'
'cine_photo'
'consoles_games'
'computers'
'computers_accessories'
'electronics'
'musical_instruments'
'pc_gamer'
'tablets_printing_image'
'telephony'
'fixed_telephony'

Home Electronics / Appliances:
'air_conditioning'
'home_appliances'
'home_appliances_2'
'small_appliances'
'small_appliances_home_oven_and_coffee'
'portable_kitchen_food_processors'

Tech-Adjacent Categories:
'auto'                    -- car electronics, GPS, accessories
'cool_stuff'              -- often gadgets and novelty electronics
'security_and_services'   -- alarms, surveillance systems
'signaling_and_security'  -- security devices

Not Usually Considered Tech:
'health_beauty'
'toys'
'fashion_*'
'food'
'drinks'
'books_*'
'bed_bath_table'
'furniture_*'
'housewares'
'pet_shop'
'flowers'
*/

SELECT 
    *
FROM
    order_items;
SELECT * FROM products;
SELECT * FROM product_category_name_translation;

SELECT 
    pt.product_category_name_english,
    COUNT(*),
    ROUND((COUNT(*) / (SELECT 
                    COUNT(*)
                FROM
                    order_items) * 100),
            2) AS percentage
FROM
    order_items oi
        LEFT JOIN
    products p ON oi.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE
    pt.product_category_name_english IN ('audio' , 'cine_photo',
        'consoles_games',
        'computers',
        'computers_accessories',
        'electronics',
        'musical_instruments',
        'pc_gamer',
        'tablets_printing_image',
        'telephony',
        'fixed_telephony')
GROUP BY pt.product_category_name_english
ORDER BY pt.product_category_name_english ASC;

/* Answer:

audio	364	0.32
cine_photo	72	0.06
computers	203	0.18
computers_accessories	7827	6.95
consoles_games	1137	1.01
electronics	2767	2.46
fixed_telephony	264	0.23
musical_instruments	680	0.60
pc_gamer	9	0.01
tablets_printing_image	83	0.07
telephony	4545	4.03



-- ------------------------------------------------------------------------------------------------------------------

/*16.What’s the average price of the products being sold? */

-- All products
SELECT 
    ROUND(AVG(price)) AS average_price
FROM
    order_items;
    
    
    -- Average price of Tech products sold;

SELECT 
    pt.product_category_name_english AS products,
    ROUND(AVG(oi.price), 2) AS average_prices
FROM
    order_items oi
        LEFT JOIN
    products p ON oi.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE
    pt.product_category_name_english IN ('audio' , 'cine_photo',
        'consoles_games',
        'computers',
        'computers_accessories',
        'electronics',
        'musical_instruments',
        'pc_gamer',
        'tablets_printing_image',
        'telephony',
        'fixed_telephony')
GROUP BY pt.product_category_name_english
ORDER BY pt.product_category_name_english ASC
;
 
 /* Answers :
 Products                average_prices (€)
audio-----------------------139.25
cine_photo------------------96.3
computers-------------------1098.34
computers_accessories-------116.51
consoles_games--------------138.49
electronics-----------------57.91
fixed_telephony	------------225.69
musical_instruments---------281.62
pc_gamer--------------------171.77
tablets_printing_image-------90.7
telephony--------------------71.21
*/

-- ------------------------------------------------------------------------------------------------------------------

/*17.Are expensive tech products popular? 

)*/

WITH price_groups AS (
	SELECT 
		*, 
        NTILE(3) OVER (ORDER BY price) AS price_tile
    FROM order_items
)
SELECT 
	-- pt.product_category_name_english,
    CASE
        WHEN price_tile = 1 THEN 'cheap'
        WHEN price_tile = 2 THEN 'medium'
        WHEN price_tile = 3 THEN 'expensive'
    END AS price_category,
    COUNT(*) as num_items
FROM price_groups pg -- equals order_items appended by price_tile
        LEFT JOIN
    products p ON pg.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE
    pt.product_category_name_english IN ('audio' , 'cine_photo',
        'consoles_games',
        'computers',
        'computers_accessories',
        'electronics',
        'musical_instruments',
        'pc_gamer',
        'tablets_printing_image',
        'telephony',
        'fixed_telephony')
GROUP BY price_category -- , product_category_name_english
ORDER BY price_category; -- , product_category_name_english




/* Answer: Looking at all product categories of tech core products and assigning a price category acc. to the tritile of the prices (1, 2, 3), 
			one can see that there is no tendency in general that the cheaper products are bought more often than the expensive ones.
	
    price_category	num_items
	cheap			8874
	medium			4094
    expensive		4983
	
    GROUPED BY product_category:
    
	product_category_name_english	price_category	num_items
	audio							cheap			127
	audio							medium			94
    audio							expensive		143
	cine_photo						cheap			27
	cine_photo						medium			28    
    cine_photo						expensive		17
	computers						cheap			1
	computers						expensive		202
	computers_accessories			cheap			2441
	computers_accessories			medium			2582
    computers_accessories			expensive		2804
    consoles_games					cheap			512
    consoles_games					medium			292
	consoles_games					expensive		333
	electronics						cheap			2043
	electronics						medium			375
    electronics						expensive		349
	fixed_telephony					cheap			129
	fixed_telephony					medium			33
    fixed_telephony					expensive		102
	musical_instruments				cheap			149
	musical_instruments				medium			219
    musical_instruments				expensive		312
	pc_gamer						expensive		9
	tablets_printing_image			cheap			7
	tablets_printing_image			medium			72
    tablets_printing_image			expensive		4
	telephony						cheap			3438
	telephony						medium			399
    telephony						expensive		708
	*/

/*=========================================================================================================================================================================================
*/


###In relation to the sellers:

/*=========================================================================================================================================================================================
*/


/*18.How many months of data are included in the magist database? */

SELECT MIN(order_purchase_timestamp), MAX(order_purchase_timestamp) FROM orders;
 SELECT 
    (YEAR(MAX(order_purchase_timestamp)) - YEAR(MIN(order_purchase_timestamp))) * 12 + (MONTH(MAX(order_purchase_timestamp)) - MONTH(MIN(order_purchase_timestamp))) AS MONTHS_IN_DATA
FROM
    orders;
    
-- Answer: 25 months
-- ------------------------------------------------------------------------------------------------------------------

/* 19.How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers? */

SELECT * FROM sellers;
SELECT * FROM order_items;
SELECT * FROM products;
SELECT * FROM product_category_name_translation;

SELECT Count(DISTINCT seller_id) AS number_of_sellers FROM sellers;

SELECT 
    pt.product_category_name_english AS product_category, COUNT(DISTINCT s.seller_id) AS number_of_sellers, ROUND(COUNT(DISTINCT s.seller_id)/(SELECT Count(DISTINCT seller_id) FROM sellers)*100,2) AS percentage
FROM
    order_items oi
LEFT JOIN sellers s ON s.seller_id = oi.seller_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pt ON pt.product_category_name = p.product_category_name
WHERE
    pt.product_category_name_english IN (
		'audio' , 
        'cine_photo',
        'consoles_games',
        'computers',
        'computers_accessories',
        'electronics',
        'musical_instruments',
        'pc_gamer',
        'tablets_printing_image',
        'telephony',
        'fixed_telephony')
GROUP BY product_category
ORDER BY number_of_sellers;

-- ------------------------------------------------------------------------------------------------------------------
/* 20.What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?*/

SELECT ROUND(SUM(price), 2) AS total_earned_all_sellers FROM order_items; 

SELECT 
     pt.product_category_name_english as product_category, ROUND(SUM(oi.price), 2) AS total_earned_by_tech_category
FROM
    order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE
    pt.product_category_name_english IN ('audio' , 'cine_photo',
        'consoles_games',
        'computers',
        'computers_accessories',
        'electronics',
        'musical_instruments',
        'pc_gamer',
        'tablets_printing_image',
        'telephony',
        'fixed_telephony')
GROUP BY product_category;

/*	Answer: 
	The total amount earned by all sellers: €13,591,643.7
    The total amount earned by all TECH sellers: €2,094,075.14
	
    split in tech categories:
	product_category		total_earned_by_tech_category in Euros (€)

	audio					50,688.50
	cine_photo				6,933.46
	consoles_games			157,465.22
	electronics				160,246.74
	computers_accessories	911,954.32
	musical_instruments		191,498.88
	pc_gamer				1,545.95
	computers			    222,963.13
	tablets_printing_image	7,528.41
	telephony				323,667.53
	fixed_telephony			59,583.00
*/

-- ------------------------------------------------------------------------------------------------------------------
/* 21.Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?*/

SELECT 
    ROUND(SUM(price) / (SELECT 
            (YEAR(MAX(order_purchase_timestamp)) - YEAR(MIN(order_purchase_timestamp))) * 12 + (MONTH(MAX(order_purchase_timestamp)) - MONTH(MIN(order_purchase_timestamp))) AS MONTHS_IN_DATA
        FROM
            orders),2) AS monthly_income_all_sellers
FROM
    order_items;

SELECT 
     ROUND(SUM(oi.price) / (SELECT 
            (YEAR(MAX(order_purchase_timestamp)) - YEAR(MIN(order_purchase_timestamp))) * 12 + (MONTH(MAX(order_purchase_timestamp)) - MONTH(MIN(order_purchase_timestamp))) AS MONTHS_IN_DATA
        FROM
            orders),2) AS monthyl_income_tech_sellers
FROM
    order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE
    pt.product_category_name_english IN ('audio' , 'cine_photo',
        'consoles_games',
        'computers',
        'computers_accessories',
        'electronics',
        'musical_instruments',
        'pc_gamer',
        'tablets_printing_image',
        'telephony',
        'fixed_telephony')
        ;

/*	Answer:
		The average monthly income of all sellers: €543,665.75
		The average monthly income of Tech sellers: €83,763.01
        */

/*=========================================================================================================================================================================================
*/

###In relation to the delivery time:

/*=========================================================================================================================================================================================
*/

/*22.What’s the average time between the order being placed and the product being delivered?*/

SELECT 
    ROUND(AVG(TIMESTAMPDIFF(DAY,
                order_purchase_timestamp,
                order_delivered_customer_date)),
            0) AS avg_time_between_purchase_and_delivery_in_days
FROM
    orders;

/*	Answer:	The average time between the order being placed and the product being delivered is 12 days.
*/
-- ------------------------------------------------------------------------------------------------------------------

/*23.How many orders are delivered on time vs orders delivered with a delay?*/


SELECT 
    COUNT(*)
FROM
    (SELECT 
        ABS(TIMESTAMPDIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date)) AS delay
    FROM
        orders
    WHERE
        order_status = 'delivered') AS subquery
WHERE
    delay != 0;

/*	Answer: Orders delivered on time: 2.754 vs, orders delivered with delay: 93.716.
*/

-- ------------------------------------------------------------------------------------------------------------------

/*24. Is there any pattern for delayed orders, e.g. big products being delayed more often?*/

SELECT * FROM orders;			-- main tables for JOINs
SELECT * FROM order_payments; 	-- delayed payments?											No
SELECT * FROM sellers;			-- delays with specific sellers?
SELECT * FROM customers;		-- delays with specific customers?
SELECT * FROM geo;			  	-- delays with specific locations? far from storages?
SELECT * FROM order_items;		-- delays with specific items? via products table

SELECT 
    s.seller_id, s.seller_zip_code_prefix, count(*) AS num_delayed_orders
FROM
    (SELECT 
        *,
            ABS(TIMESTAMPDIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date)) AS delay
    FROM
        orders
    WHERE
        order_status = 'delivered') AS subquery
        LEFT JOIN
    order_items oi ON oi.order_id = subquery.order_id
        LEFT JOIN
    sellers s ON s.seller_id = oi.seller_id
WHERE
    delay != 0
GROUP BY s.seller_id, s.seller_zip_code_prefix
ORDER BY num_delayed_orders DESC;

-- Answer: There seems to be issues with a lot of sellers, but mainly the same sellers. 
-- 				---> looking into customers data and geo next.

SELECT 
    delay,
    c.customer_zip_code_prefix AS customer_location,
    gc.city AS city_customer,
    gc.state AS state_customer,
    gc.lat AS lat_customer,
    gc.lng AS long_customer,
    s.seller_zip_code_prefix AS seller_location,
    gs.city AS city_seller,
    gs.state AS state_seller,
    gs.lat as lat_seller,
    gs.lng AS long_seller,
    ROUND(6371 * 2 * ASIN(SQRT(
        POW(SIN(RADIANS(gc.lat - gs.lat) / 2), 2) +
        COS(RADIANS(gs.lat)) * COS(RADIANS(gc.lat)) *
        POW(SIN(RADIANS(gc.lng - gs.lng) / 2), 2)
    )),3) AS distance_km
FROM
    (SELECT 
        *,
            ABS(TIMESTAMPDIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date)) AS delay
    FROM
        orders
    WHERE
        order_status = 'delivered') AS subquery
        LEFT JOIN
    customers c ON c.customer_id = subquery.customer_id
        LEFT JOIN
    geo gc ON gc.zip_code_prefix = c.customer_zip_code_prefix
        LEFT JOIN
    order_items oi ON oi.order_id = subquery.order_id
        LEFT JOIN
    sellers s ON s.seller_id = oi.seller_id
        LEFT JOIN
    geo gs ON s.seller_zip_code_prefix = gs.zip_code_prefix
WHERE
    delay != 0;
    
-- Product size/weight: TO DO: Compare the number of heavy or big products with delay to the ones without delay by changing delay != 0 to delay = 0

SELECT * FROM products;

SELECT 
       COUNT(*) AS num_delayed_orders
FROM
    (SELECT 
        *,
            ABS(TIMESTAMPDIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date)) AS delay
    FROM
        orders
    WHERE
        order_status = 'delivered') AS subquery
        LEFT JOIN 
	order_items oi ON oi.order_id = subquery.order_id
        LEFT JOIN
    products p ON p.product_id = oi.product_id
WHERE
    delay != 0 and p.product_weight_g > 10000;
    
    -- delay = 0 and (p.product_height_cm * p.product_length_cm * p.product_width_cm) / 1000000 > 0.05;

-- there are 7059 orders delayed with a product volume of more than 0.05 m³    
-- there are 165 orders delievered on time with a product volume of more than 0.05 m³    

-- there are 5016 orders delayed with a product weight over 10.0 kg 
-- there are 139 orders delievered on time with a product weight over 10.0 kg 