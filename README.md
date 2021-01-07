# Shopping_Management

Here we have Shopping Management database which includes all the necessary information about the the products and the details of the customers who wished to buy the products whether it's an electrical , Home utensils , Groceries and Jewelleries etc.

Consider the schema for SHOPPING Database:

CART(Cart_id)


CUSTOMER(Customer_id,Cust_Name,Cust_Add,Cart_id,
Phone_no)


PRODUCT(Product_id,Product_type,Cost,Quantity)


CART_ITEM(Cart_id,Product_id)


PAYMENT(Payment_id,Payment_date, Payment_type,
Customer_id, Total_Amount)
