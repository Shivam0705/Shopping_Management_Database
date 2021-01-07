create database shopping_management

use shopping_management

CREATE TABLE CART
(
	Cart_id VARCHAR(7) NOT NULL,
	PRIMARY KEY(Cart_id)
)

CREATE TABLE CUSTOMER
(
	Customer_id VARCHAR(6) NOT NULL,
	cust_name VARCHAR(20) NOT NULL,
	cust_add VARCHAR(20) NOT NULL,
	PRIMARY KEY (Customer_id),
	Cart_id VARCHAR(7) NOT NULL,
	Ph_no varchar(10) NOT NULL,
	FOREIGN KEY(Cart_id) REFERENCES cart(Cart_id)
)


CREATE TABLE Product
(
	Product_id VARCHAR(10) NOT NULL,
	product_type VARCHAR(20) NOT NULL,
	Cost float NOT NULL,
	Quantity int NOT NULL,
	PRIMARY KEY (Product_id)
)


CREATE TABLE Cart_item
(
	Cart_id VARCHAR(7) NOT NULL,
	Product_id VARCHAR(10) NOT NULL,
	FOREIGN KEY (Cart_id) REFERENCES Cart(Cart_id),
	FOREIGN KEY (Product_id) REFERENCES Product(Product_id),
	Primary key(Cart_id,Product_id)
)


CREATE TABLE Payment
(
	payment_id VARCHAR(7) NOT NULL,
	payment_date DATE NOT NULL,
	Payment_type VARCHAR(10) NOT NULL,
	Customer_id VARCHAR(6) NOT NULL,
	Cart_id VARCHAR(7) NOT NULL,
	PRIMARY KEY (payment_id),
	FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id),
	FOREIGN KEY (Cart_id) REFERENCES Cart(Cart_id),
	total_amount float
)


/*TRIGGER ON PAYMENT TABLE*/

create trigger trg1 on payment
after insert
as
update Payment
set total_amount =
(select sum(p.cost)
from Product as p,Cart_item as c,inserted as i
where p.Product_id=c.Product_id and c.Cart_id=i.Cart_id )
where Cart_id in (select Cart_id
from inserted )

/*INSERT STATEMENTS*/

insert into Cart values('SS1')
insert into Cart values('SS2')
insert into Cart values('SS3')
insert into Cart values('SS4')
insert into Cart values('SS5')
insert into Cart values('SS6')
insert into Cart values('SS7')


insert into Customer
values('cust1','Rahul','Gurgaon','SS1','7677676767')
insert into Customer
values('cust2','Tyagi','Lucknow','SS2','9191991911')
insert into Customer
values('cust3','Roshan','Mangalore','SS3','8282828828')
insert into Customer
values('cust4','Neha','Bangalore','SS4','7642632467')
insert into Customer
values('cust5','Ravi','Faridabad','SS5','6753246838')
insert into Customer
values('cust6','Binod','Chandigarh','SS6','9876543210')
insert into Customer
values('cust7','Debasmita','Mirzapur','SS7','9800264315')


insert into Product values('pid1','Grocery',500,5)
insert into Product values('pid2','Electronic Gadgets',89000,1)
insert into Product values('pid3','Home and Kitchen',10000,8)
insert into Product values('pid4','Stationaries',1000,4)
insert into Product values('pid5','Skin care prodcuts',2500,3)
insert into Product values('pid6','Baby products',4000,6)
insert into Product values('pid7','Medicines',700,2)
insert into Product values('pid8','Wooden items',6000,2)
insert into Product values('pid9','Hardware parts',1500,7)
insert into Product values('pid10','Jwellery',5000,1)


insert into Cart_item values('SS1','pid1')
insert into Cart_item values('SS1','pid3')
insert into Cart_item values('SS1','pid6')
insert into Cart_item values('SS2','pid1')
insert into Cart_item values('SS2','pid8')
insert into Cart_item values('SS3','pid9')
insert into Cart_item values('SS4','pid4')
insert into Cart_item values('SS4','pid7')
insert into Cart_item values('SS4','pid5')
insert into Cart_item values('SS4','pid1')
insert into Cart_item values('SS7','pid1')
insert into Cart_item values('SS7','pid8')


insert into Payment values('PID1','2020-09-
25','Cash','cust1','SS1',NULL)
insert into Payment values('PID2','2019-07-
02','Card','cust2','SS2',NULL)
insert into Payment values('PID3','2010-10-01','Gpay','
cust3','SS3',NULL)
insert into Payment values('PID4','2011-05-
10','EBanking','cust4','SS4',NULL)
insert into Payment values('PID5','2008-03-
09','Cash','cust5','SS5',NULL)
insert into Payment values('PID6','2019-07-
02','Card','cust6','SS6',NULL)
insert into Payment values('PID7','2018-02-
22','Ewallet','cust7','SS7',NULL)


/* Queries related to the given database */

QUERY1:
/*1.) Retrieve the customer details with the maximum shopping
amount*/

select cust_name,cust_add,Ph_no
from Customer
where Customer_id In(
select Customer_id
from Payment
where total_amount in ( select MAX(total_amount) as Total_amount
from Payment
))

QUERY2:
/*2.) Retrieve the customer details who bought maximum number of
products*/

create view V1 as
select Cart_id,count(*) as no_of_products
from Cart_item
group by Cart_id


select cust_name,cust_add,Ph_no
from Customer
where Cart_id In(
select Cart_id
from V1
where no_of_products IN (select MAX(no_of_products) as products
from V1
))


QUERY3:
/*3.)Retrive the customer details who doesn't have anything in there
carts*/
select c.cust_name,c.cust_add,c.Ph_no, c.Cart_id
from Customer as c
where Cart_id NOT IN (select distinct cart_id
from Cart_item as C
)



QUERY4:
/*4.)List the customers who bought more than two products using
stored procedure*/
create proc nop1
as
begin
select c.cust_name,ci.Cart_id,count(*) no_of_products
from Customer as c,Cart_item as ci
where c.Cart_id=ci.Cart_id
group by c.cust_name,ci.Cart_id
having count(*)>2
end


exec nop1


QUERY5:
/*5.)Find the product that sold out maximum in the year '2019'*/
create view vv2 as
select c.Product_id,count(*) as no_of_purchases
from Cart_item as c,Payment as p
where c.Cart_id=p.Cart_id and year(p.payment_date)='2019'
group by Product_id


select p.Product_id,p.product_type,p.Quantity
from vv2 as v,Product as p
where v.Product_id=p.Product_id and v.no_of_purchases in
(
select max(no_of_purchases) as noa
from vv2
)


QUERY6:
/*6.)Give 10% discount to the customers who have purchased more than
Rs.5000*/


select * from Payment
select c.cust_name,c.cust_add, 0.9*total_amount as
Discounted_amount
from Payment as p, Customer as c
where total_amount>5000 and p.Customer_id=c.Customer_id