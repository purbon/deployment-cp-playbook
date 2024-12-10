CREATE STREAM orders (
    ordertime BIGINT,
    orderid INT,
    itemid VARCHAR,
    ordersunits DOUBLE,
    address STRUCT<city STRING, state STRING, zipcode INT>
  ) WITH (
    KAFKA_TOPIC = 'orders',
    VALUE_FORMAT = 'JSON'
  );


# INSURANCEs

CREATE TABLE customers (
    customer_id VARCHAR PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR,
    gender VARCHAR,
    income BIGINT,
    fico INT,
    years_active INT
  ) WITH (
    KAFKA_TOPIC = 'insurance_customers',
    VALUE_FORMAT = 'JSON'
  );

  CREATE TABLE offers (
    offer_id VARCHAR PRIMARY KEY,
    offer_name VARCHAR,
    offer_url VARCHAR
  ) WITH (
    KAFKA_TOPIC = 'insurance_offers',
    VALUE_FORMAT = 'JSON'
  );

   CREATE STREAM activity (
    activity_id VARCHAR,
    customer_id VARCHAR,
    activity_type VARCHAR,
    propensity_to_churn DOUBLE,
    ip_address VARCHAR
  ) WITH (
    KAFKA_TOPIC = 'insurance_customer_activity',
    VALUE_FORMAT = 'JSON'
  );

CREATE OR REPLACE STREAM CUSTOMER_ACTIVITY AS
  SELECT A.activity_id, A.customer_id, A.activity_type, A.propensity_to_churn, A.ip_address, C.email, C.gender, C.income, C.fico, C.years_active
  FROM activity as A INNER JOIN customers as C ON A.customer_id = C.customer_id;


CREATE OR REPLACE TABLE CHURN_BY_GENDER_INCOME_YEARS AS
  SELECT gender, AVG(income) AS AVG_INCOME, AVG(years_active) AS AVG_YEARS
  FROM CUSTOMER_ACTIVITY
  WHERE propensity_to_churn > 0.75
  GROUP BY gender;

CREATE OR REPLACE TABLE KEEP_BY_GENDER_INCOME_YEARS AS
  SELECT gender, AVG(income) AS AVG_INCOME, AVG(years_active) AS AVG_YEARS
  FROM CUSTOMER_ACTIVITY
  WHERE propensity_to_churn < 0.15
  GROUP BY gender;