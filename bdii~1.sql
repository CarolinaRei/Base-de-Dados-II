CREATE TABLE date_dw
(
dateid NUMBER PRIMARY KEY,
dateformat DATE NOT NULL,
daydw NUMBER(2) NOT NULL,
monthdw NUMBER(2) NOT NULL,
yeardw NUMBER(2) NOT NULL,
dayofweek VARCHAR2(10) NOT NULL,
dayofyear NUMBER(3) NOT NULL,
weekend VARCHAR2(3) NOT NULL,
weekofyear NUMBER(2) NOT NULL,
weekofthemonth NUMBER(1) NOT NULL,
monthname VARCHAR2(20) NOT NULL,
quarter NUMBER(1) NOT NULL,
quartername VARCHAR2(10) NOT NULL,
firstquarter DATE NOT NULL,
lastquarter DATE NOT NULL,
holiday VARCHAR2(20)
);