# simple-data-warehouse-implementation-with-snowflake
this project is a data warehouse implementation for a retail store whose data hosted on amazon s3 buckets. the entire ETL processes and automations are done on snowflake.

## Table of Contents
1. [Overview](#overview)
2. [Features](#features)
3. [Dataset Description](#dataset-description)
4. [Technologies Used](#technologies-used)
5. [Project Architecture](#project-architecture)
8. [Challenges Faced](#challenges-faced)
9. [Future Improvements](#future-improvements)
10. [Contact Information](#contact-information)


## Overview
for this project we connected our snowflake to an external stage, on amazon s3. then we staged the data in the staging area and then loaded it to our core area. we did this using stored procedures, scheduled tasks, and snowpipe.

## Features
- Fact and Dimension table design
- external stages and file formats
- ETL
  - snowpipe
  - scheduled tasks
  - stored procedures
    
## Dataset Description
The project uses a publicly available e-commerce dataset containing:
- 'transaction': unique identification for transactions
- 'transactional_date': date transaction was made
- 'product_id': unique indentification for products
- 'customer_id': unique identification for customers
- 'payment': type of payment recieved
- 'credit_card' credit card numnber
- 'loyalty_card': if customer has loyalty card
- 'cost': amount we paid for the product
- 'quantity': number of products purchased
- 'price': selling price of product

## Technologies Used
- **Programming Languages**: SQL, SnowSQL
- **Tools**: AWS S3, Snowflake

## Project Architecture
The project follows the typical data analytics pipeline:
1. connect snowflake to amazon s3
2. create database, schemas, tables, external stages, and file formats
4. load data from external stage to staging area
5. transform and load data from staging area to core area
6. implement snowpipe and other automations for the delta load process

## Challenges Faced
- **Data Cleaning**: Dealt with unwanted characters, and split some columns that were joined together.
- **delta load**: i resolved the issue of automatic data load without loading already loaded data by using snowpipe
- **honorable mention**: at first i tried implementing the datawarehouse's automatic data ingestion by writing complex procedures with javascript on snowflake. i realized it wouldn't work as well as i intended to i resigned myself to snowpipe, and would never try to reinvent the wheel again.

## Future Improvements
- using snowflake streams incase of changes to the tables
- add all the dimesion tables

## Contact Information
For any inquiries, feel free to contact me:
- Email: chinwutemegbuluka@gmail.com
- LinkedIn: https://www.linkedin.com/in/chinwutem-egbuluka-76a870173/
