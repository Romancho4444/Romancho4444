CREATE SCHEMA dannys_diner;
USE dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

 1. /*Для нахождения общей суммы, которую каждый клиент потратил в ресторане нужно:
- обратится к таблицам sales или menu
- объеденить обе таблицы по ключу product_id
- сгрупировать по идентификатору клиента customer_id
- упорядочить по агрегированному столбцу в порядке убывания, чтобы получить наибольшую потраченную сумму*/

select customer_id, sum(price) amount
from sales s
join menu m on m.product_id = s.product_id
group by s.customer_id
order by amount;

2. /* Для нахождения общего количества дней, которых клиент потратил посещая ресторан необходимо:
  - использовать DISTINCT, поскольку клиент мог посетить ресторан более одного раза в день
  - использовать функцию COUNT() перед группировкой по customer_id.
*/
select customer_id, count(distinct order_date) attendance
from sales
group by customer_id;

3. /* Для нахождения первого пункта меню,которого заказал каждый клиент необходимо:
  - создать временную таблицу при помощи оператора with, где будет хранится первая дата заказа
  - присоеденить к временной таблице таблицу продаж, используя поле customer_id и date
  - присоеденить таблицу menu
  - отсортировать полученные данные*/
  
  WITH first_purchase AS (
    SELECT customer_id, MIN(order_date) AS first_purchase_date
    FROM sales
    GROUP BY 1
    )

  SELECT DISTINCT f.customer_id, 
        s.product_id, 
        m.product_name, 
        f.first_purchase_date
  FROM first_purchase f
  LEFT JOIN sales s
  ON f.customer_id = s.customer_id
  AND f.first_purchase_date = s.order_date
  LEFT JOIN menu m
  USING(product_id)
  ORDER BY customer_id

4. /* Для поиска самого покупаемого товара и нахождения количества покупок клиентов необходимо:
  - таблицу sales необходимо присоединить к таблице menu, чтобы получить product_name
  - сгрупировать по product_name и использовать в запросе count*/
select product_name, count(*) as count
from sales
join menu on menu.product_id = sales.product_id
group by product_name
order by count desc;

/* Ответы с 5-10 Впроцессе написания */
