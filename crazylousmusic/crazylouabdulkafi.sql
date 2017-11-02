-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 30, 2017 at 06:29 PM
-- Server version: 10.1.19-MariaDB
-- PHP Version: 7.0.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `crazylouabdulkafi`
--
CREATE DATABASE IF NOT EXISTS `crazylouabdulkafi` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `crazylouabdulkafi`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addresses_insert` (IN `cust_id` INT, IN `street` VARCHAR(300), IN `suite` VARCHAR(200), IN `city` VARCHAR(100), IN `prov` VARCHAR(5), IN `coun` VARCHAR(30), IN `post` VARCHAR(20))  MODIFIES SQL DATA
INSERT INTO 
addresses
( customerid,
 streetaddress,
 suite,
 city,
 province_short,
 country_short,
 postalcode,
 active )
VALUES
(
    cust_id,
    street,
    suite,
    city,
    prov,
    coun,
    post,
    1

)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `address_inactive` (IN `cust_id` INT)  MODIFIES SQL DATA
UPDATE addresses
SET active = 0
WHERE customerid = cust_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `albums_load_by_category` (IN `cat` INT)  READS SQL DATA
SELECT albums.albumid, albums.albumname, albumscategories.categoryid
FROM albumscategories, albums
WHERE albumscategories.categoryid = cat AND
      albums.albumid = albumscategories.albumid AND
      albumscategories.active=1
      
ORDER BY albums.albumname$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `album_load_id` (IN `id` INT)  READS SQL DATA
SELECT albumname, artist, retailprice, songs, active
FROM albums
WHERE albumid = id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cancel_order` (IN `order_id` INT)  MODIFIES SQL DATA
UPDATE orders
SET active = 0
WHERE orderid = order_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cards_load` ()  READS SQL DATA
SELECT *
FROM cards
WHERE status = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `categories_load` ()  READS SQL DATA
SELECT categoryid, category
FROM categories
WHERE active=1
ORDER BY category$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `countries_load` ()  READS SQL DATA
SELECT country, shortvalue
FROM countries
ORDER BY sortorder$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_address_load_by_id` (IN `cust_id` INT)  READS SQL DATA
SELECT customers.customerid, customers.firstname,customers.lastname,customers.email, addresses.streetaddress, addresses.city, addresses.suite, addresses.province_short, addresses.country_short, addresses.postalcode,addresses.addressid
FROM customers, addresses
WHERE customers.active=1 AND addresses.active=1 AND customers.customerid = addresses.customerid AND customers.customerid =cust_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_get_inserted_id` (IN `first` VARCHAR(40), IN `last` VARCHAR(40))  READS SQL DATA
SELECT max(customerid) as customerid
FROM customers
WHERE firstname = first AND lastname = last$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_insert` (IN `fname` VARCHAR(40), IN `lname` VARCHAR(40), IN `email` VARCHAR(255), IN `pswd` VARCHAR(56))  MODIFIES SQL DATA
INSERT INTO 
customers 
(
firstname,lastname, email, password,active

)
VALUES
(
fname,lname ,email,pswd, 1    
)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_max_order` (IN `cust_id` INT)  READS SQL DATA
SELECT max(orderid)
FROM orders
WHERE orders.customerid = cust_id and orders.active = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_update` (IN `cust_id` INT, IN `fname` VARCHAR(40), IN `lname` VARCHAR(40), IN `email_new` VARCHAR(255), IN `pswd` VARCHAR(56))  MODIFIES SQL DATA
UPDATE customers
SET firstname = fname,
    lastname  = lname,
    email     = email_new,
    password  = pswd
    
WHERE customerid = cust_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_verify_login` (IN `email_add` VARCHAR(255), IN `pswd` VARCHAR(56))  READS SQL DATA
SELECT customerid
FROM customers
WHERE email = email_add AND password = pswd AND active=1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `invoice_insert` (IN `cust_id` INT, IN `baddress` INT, IN `ordernum` INT, IN `payment` VARCHAR(20), IN `tax` DECIMAL(2,2))  MODIFIES SQL DATA
INSERT INTO invoices(  
    customerid,
    billingaddress,
    ordernumber, 
    invoicedate, 
    paymentmethod, 
    taxrate) 
VALUES (cust_id,
        baddress,
        ordernum,
       CURRENT_DATE,
       payment,
       tax)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `invoice_load_by_id` (IN `invoice` INT)  READS SQL DATA
SELECT invoicenumber,customerid, billingaddress, ordernumber, invoicedate, paymentmethod,taxrate 

FROM `invoices` 

WHERE invoicenumber =invoice$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `invoice_load_max_record` (IN `cust_id` INT)  READS SQL DATA
SELECT max(invoicenumber)
FROM  invoices
WHERE customerid = cust_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `load_orders_date_by_order_id` (IN `order_id` INT)  READS SQL DATA
SELECT orderdate
FROM orders
WHERE orderid = order_id AND active = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orderdetails_delete` (IN `order_id` INT)  MODIFIES SQL DATA
DELETE 
FROM orderdetails
WHERE orderdetails.orderid = order_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orderdetails_insert` (IN `orderid` INT, IN `album` INT, IN `qty` INT, IN `price` DECIMAL)  MODIFIES SQL DATA
INSERT INTO orderdetails
( orderid, item_albumid, quantity,price_unit, active )
VALUES
( orderid, album, qty, price, 1 )$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orderdetails_last_inserted` (IN `order_id` INT)  READS SQL DATA
SELECT   max( orderdetailid )
FROM orderdetails
WHERE orderid = order_id AND active = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orderdetails_load_by_order_id` (IN `orderid` INT)  READS SQL DATA
SELECT orderdetails.orderid, orderdetails.item_albumid, orderdetails.quantity, orderdetails.price_unit, albums.albumname,
orderdetails.quantity * orderdetails.price_unit as total
FROM orderdetails, albums 
WHERE orderdetails.orderid = orderid AND orderdetails.item_albumid = albums.albumid
ORDER BY orderdetails.orderdetailid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_delete` (IN `order_id` INT)  MODIFIES SQL DATA
DELETE 
FROM orders
WHERE orders.orderid = order_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_insert` (IN `cust_id` INT)  MODIFIES SQL DATA
INSERT INTO orders
(
 customerid, orderdate, active   
)
VALUES
( cust_id, CURRENT_DATE,1 )$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_last_inserted` (IN `cust_id` INT)  READS SQL DATA
SELECT   max( orderid )
FROM orders
WHERE customerid = cust_id AND active = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_load_by_customer_id` (IN `cust_id` INT)  READS SQL DATA
SELECT orderid, orderdate
FROM orders
WHERE orders.customerid = cust_id AND active = 1
ORDER BY orders.orderdate DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `payment_insert` (IN `cust_id` INT, IN `pay_meth` INT, IN `amount` DECIMAL, IN `order_id` INT)  MODIFIES SQL DATA
INSERT INTO 
payments
(
   customerid,paymentmethod,amountpaid,paymentDate,orderid 
)
VALUES
(
  cust_id, pay_meth, amount, CURRENT_DATE,order_id
)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `phonenumbers_insert` (IN `cust_id` INT, IN `phone` VARCHAR(14), IN `ext` VARCHAR(6), IN `type` VARCHAR(2))  MODIFIES SQL DATA
INSERT INTO
phonenumbers
(
 customerid,
    phone,
    ext,
    phonetype,
    active
)
VALUES
(
 cust_id,
    phone,
    ext,
    type,
    1
    
)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `phonenumbers_load_by_id_type` (IN `cust_id` INT, IN `type` VARCHAR(2))  READS SQL DATA
SELECT phone, ext
FROM phonenumbers
WHERE customerid=cust_id AND phonetype=type AND active=1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `phonenumber_inactive` (IN `cust_id` INT, IN `type` VARCHAR(2))  MODIFIES SQL DATA
UPDATE phonenumbers
SET active = 0
WHERE customerid = cust_id AND phonetype = type$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `provinces_load` ()  READS SQL DATA
SELECT province,shortvalue
FROM provinces
ORDER BY sortorder$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `session_insert` (IN `cust_id` INT, IN `sess_val` VARCHAR(255))  MODIFIES SQL DATA
INSERT INTO sessions
(
  userid,
  sessionvalue,
    loggedindate,
    loggedintime,
    isloggedin
 )
               VALUES
(
    cust_id,
    sess_val,
    
    CURRENT_DATE,
    CURRENT_TIME,
    1
 )$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `session_logged_out` (IN `sess_val` VARCHAR(255))  MODIFIES SQL DATA
UPDATE sessions
 SET
 loggedoutdate = CURRENT_DATE(),
    loggedouttime = CURRENT_TIME(),
    isloggedin = 0
    
    WHERE
    sessions.sessionvalue = sess_val$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `session_logout` (IN `cust_id` INT, IN `sess_val` VARCHAR(255))  MODIFIES SQL DATA
UPDATE sessions
SEt isloggedin=0 ,
loggedoutdate = CURRENT_DATE(), 
loggedouttime = CURRENT_TIME()
WHERE userid=cust_id AND sessionvalue = sess_val$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `session_verify_logged_in` (IN `sess_val` VARCHAR(255))  READS SQL DATA
SELECT userid
FROM sessions
WHERE sessionvalue=sess_val AND isloggedin=1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `taxrate_load_active` ()  READS SQL DATA
SELECT taxrateid, taxrate, active
FROM taxrates
WHERE active=1$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `addressid` int(11) NOT NULL,
  `customerid` int(11) NOT NULL,
  `streetaddress` varchar(300) NOT NULL,
  `suite` varchar(200) NOT NULL,
  `city` varchar(100) NOT NULL,
  `province_short` varchar(5) NOT NULL,
  `country_short` varchar(11) NOT NULL,
  `postalcode` varchar(20) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`addressid`, `customerid`, `streetaddress`, `suite`, `city`, `province_short`, `country_short`, `postalcode`, `active`) VALUES
(1, 1, 'kidd', '16', 'North York', '1', '1', 'M33 R66', 1),
(3, 20, 'a', 'a', 'a', '0', '0', 'a', 0),
(4, 21, 'b', 'b', 'b', '0', '0', 'b', 1),
(5, 22, 'ddd', 'ddd', 'ddd', ' O', ' CA', 'ddd', 1),
(6, 23, 'e', 'e', 'e', ' ON', ' CA', 'e', 1),
(7, 24, 'f', 'f', 'f', ' ON', ' CA', 'f', 1),
(8, 20, 's', 's', 's', 's', 's', 's', 0),
(9, 20, 'aa', '', '', '', '', '', 0),
(10, 20, 'aa', 'a', 'a', '', '', 'a', 0),
(11, 20, 'aa', 'a', 'a', '', '', 'a', 0),
(12, 20, 'aam', 'a', 'a', '', '', 'a', 0),
(13, 20, 'aam', 'a', 'a', '', '', 'a', 0),
(14, 20, 'aamb', 'a', 'a', '', '', 'a', 0),
(15, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(16, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(17, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(18, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(19, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(20, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(21, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(22, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(23, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(24, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(25, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(26, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(27, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(28, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(29, 20, 'aambn', 'a', 'a', '', '', 'a', 0),
(30, 20, 'aambn', 'a', 'a', ' ON', ' CA', 'a', 0),
(31, 20, 'A', 'D', 'B', '', '', 'C', 0),
(32, 20, 'A', 'D', 'B', '', '', 'C', 0),
(33, 20, 'A', 'D', 'B', '', '', 'C', 0),
(34, 20, 'A', 'D', 'B', '', '', 'C', 0),
(35, 20, 'A', 'D', 'B', ' PE', ' CA', 'C', 0),
(36, 20, 'A', 'D', 'B', '', '', 'C', 0),
(37, 20, 'A', 'D', 'B', ' ON', ' CA', 'C', 0),
(38, 20, 'A', 'D', 'B', ' ON', ' CA', 'C', 0),
(39, 20, 'A', 'D', 'B', '', '', 'C', 0),
(40, 20, 'A', 'D', 'B', ' ON', ' CA', 'C', 0),
(41, 20, 'A', 'D', 'B', '', '', 'C', 0),
(42, 20, 'A', 'D', 'B', ' ON', ' CA', 'C', 0),
(43, 20, 'A', 'D', 'B', '', '', 'C', 0),
(44, 20, 'A', 'D', 'B', ' ON', ' CA', 'C', 0),
(45, 20, 'A', 'D', 'B', '', '', 'C', 0),
(46, 20, 'A', 'D', 'B', ' ON', ' CA', 'C', 0),
(47, 20, 'A', 'D', 'B', '', '', 'C', 0),
(48, 20, 'A', 'D', 'B', ' ON', ' CA', 'C', 0),
(49, 20, 'A', 'D', 'B', '', '', 'C', 0),
(50, 20, 'A', 'D', 'B', '', '', 'C', 0),
(51, 20, 'A', 'D', 'B', ' ON', ' CA', 'C', 0),
(52, 20, 'A', 'D', 'B', '', '', 'C', 0),
(53, 20, 'A', 'D', 'B', '', '', 'C', 0),
(54, 20, 'A', 'D', 'B', ' SK', ' CA', 'C', 0),
(55, 20, 'A', 'D', 'B', '', '', 'C', 0),
(56, 20, 'A', 'D', 'B', ' AB', ' CA', 'C', 0),
(57, 20, 'A', 'D', 'B', '', '', 'C', 0),
(58, 20, 'A', 'D', 'B', '', '', 'C', 0),
(59, 25, 'd', 'd', 'd', ' ON', ' CA', 'd', 1),
(60, 20, 'A', 'D', 'B', '', '', 'C', 1),
(61, 26, 'q', 'q', 'q', ' QC', ' CA', 'q', 1),
(62, 27, 'o', 'o', 'o', ' ON', ' CA', 'o', 1);

-- --------------------------------------------------------

--
-- Table structure for table `albums`
--

CREATE TABLE `albums` (
  `albumid` int(11) NOT NULL,
  `albumname` varchar(100) NOT NULL,
  `artist` varchar(100) NOT NULL,
  `retailprice` int(11) NOT NULL,
  `active` int(11) NOT NULL,
  `songs` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `albums`
--

INSERT INTO `albums` (`albumid`, `albumname`, `artist`, `retailprice`, `active`, `songs`) VALUES
(1, 'face to face ', 'Westlife ', 20, 1, 'Flying Without Wings, Hit You With The Real Thing, When You''re Looking Like That, Amazing,She''s Back, Uptown Girl\r\n   '),
(2, 'Where Dreams Come True', 'Westlife ', 25, 1, 'Dreams Come True, No No, If I Let You Go, Swear It Again, Somebody Needs You, Seasons in the Sun,I Have A Dream, You Make Me Feel, When You''re Looking Like That, My Love'),
(3, 'Coast to Coast', 'Westlife', 30, 1, 'My Love, What Makes a Man, I Lay My Love on You, I Have a Dream, When You''re Looking Like That'),
(4, 'Where We Are', 'Westlife', 45, 1, 'What About Now, How to Break a Heart, Leaving, Shadows,Talk Me Down.');

-- --------------------------------------------------------

--
-- Table structure for table `albumscategories`
--

CREATE TABLE `albumscategories` (
  `albumid` int(11) NOT NULL,
  `categoryid` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `albumscategories`
--

INSERT INTO `albumscategories` (`albumid`, `categoryid`, `active`) VALUES
(1, 2, 1),
(1, 3, 1),
(2, 1, 1),
(2, 2, 1),
(2, 3, 1),
(3, 1, 1),
(3, 3, 1),
(3, 4, 1),
(4, 2, 1),
(4, 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `cards`
--

CREATE TABLE `cards` (
  `cardid` int(11) NOT NULL,
  `displayvalue` varchar(30) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cards`
--

INSERT INTO `cards` (`cardid`, `displayvalue`, `status`) VALUES
(1, 'Visa', 1),
(2, 'MasterCard', 1);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `categoryid` int(11) NOT NULL,
  `category` varchar(100) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`categoryid`, `category`, `active`) VALUES
(1, 'Rock', 1),
(2, 'Pop', 1),
(3, 'Country ', 1),
(4, 'Hip Hop', 1);

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `countryid` int(11) NOT NULL,
  `country` varchar(100) NOT NULL,
  `shortvalue` varchar(5) NOT NULL,
  `sortorder` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`countryid`, `country`, `shortvalue`, `sortorder`, `active`) VALUES
(1, 'Canada', 'CA', 1, 1),
(2, 'United States', 'US', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customerid` int(11) NOT NULL,
  `firstname` varchar(40) NOT NULL,
  `lastname` varchar(40) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(56) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customerid`, `firstname`, `lastname`, `email`, `password`, `active`) VALUES
(1, 'John', 'Smith', 'jsmith@someplace.com', '123456', 1),
(2, 'Linda', 'Jones', 'ljones@anotherplace.com', '123456', 1),
(3, 'Mohamad', 'Abdulkafi', 'm.kafi@somewhere.com', '123456', 1),
(4, 'Parin', 'Kaoth', 'pk@gmail.com', '123456', 1),
(20, 'd', 'b', 'aa@bb', '', 1),
(21, 'bb', 'cc', 'ccc@ccc', 'e10adc3949ba59abbe56e057f20f883e', 1),
(22, 'dd', 'dd', 'ddd@ddd', 'e10adc3949ba59abbe56e057f20f883e', 1),
(23, 'ee', 'ee', 'eee@ee', 'e10adc3949ba59abbe56e057f20f883e', 1),
(24, 'ff', 'ff', 'fff@ff', 'e10adc3949ba59abbe56e057f20f883e', 1),
(25, 'd', 'dd', 'dd@dd', '202cb962ac59075b964b07152d234b70', 1),
(26, 'qq', 'ww', 'qq@ww', '202cb962ac59075b964b07152d234b70', 1),
(27, 'oo', 'll', 'oo@ll', '202cb962ac59075b964b07152d234b70', 1);

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `invoicenumber` int(11) NOT NULL,
  `customerid` int(11) NOT NULL,
  `billingaddress` int(11) NOT NULL,
  `ordernumber` int(11) NOT NULL,
  `invoicedate` date NOT NULL,
  `paymentmethod` varchar(20) NOT NULL,
  `taxrate` decimal(2,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`invoicenumber`, `customerid`, `billingaddress`, `ordernumber`, `invoicedate`, `paymentmethod`, `taxrate`) VALUES
(1, 20, 58, 17, '2017-04-28', '1', '0.00'),
(2, 20, 58, 17, '2017-04-28', '1', '0.00'),
(3, 20, 58, 17, '2017-04-28', '1', '0.00'),
(4, 20, 58, 17, '2017-04-28', '1', '0.00'),
(5, 26, 61, 20, '2017-04-28', '1', '0.13'),
(6, 26, 61, 20, '2017-04-28', '1', '0.13'),
(7, 26, 61, 21, '2017-04-28', '1', '0.13'),
(8, 26, 61, 21, '2017-04-28', '1', '0.13'),
(9, 26, 61, 22, '2017-04-28', '1', '0.13'),
(10, 27, 62, 23, '2017-04-29', '1', '0.13'),
(11, 25, 59, 31, '2017-04-29', '1', '0.13'),
(12, 25, 59, 45, '2017-04-29', '1', '0.13');

-- --------------------------------------------------------

--
-- Table structure for table `orderdetails`
--

CREATE TABLE `orderdetails` (
  `orderdetailid` int(11) NOT NULL,
  `orderid` int(11) NOT NULL,
  `item_albumid` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price_unit` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orderdetails`
--

INSERT INTO `orderdetails` (`orderdetailid`, `orderid`, `item_albumid`, `quantity`, `price_unit`, `active`) VALUES
(1, 1, 1, 1, 20, 1),
(2, 2, 1, 1, 20, 1),
(3, 2, 2, 1, 25, 1),
(4, 2, 2, 1, 25, 1),
(5, 2, 1, 1, 20, 1),
(6, 3, 1, 1, 20, 1),
(7, 3, 2, 1, 25, 1),
(8, 4, 1, 1, 20, 1),
(9, 5, 1, 1, 20, 1),
(10, 5, 1, 1, 0, 1),
(11, 6, 1, 1, 20, 1),
(12, 7, 1, 1, 20, 1),
(13, 11, 1, 1, 20, 1),
(14, 11, 1, 1, 0, 1),
(15, 11, 1, 1, 0, 1),
(16, 11, 1, 1, 20, 1),
(17, 12, 1, 1, 20, 1),
(18, 13, 1, 1, 20, 1),
(19, 13, 2, 1, 25, 1),
(20, 14, 1, 1, 20, 1),
(21, 15, 1, 1, 20, 1),
(22, 16, 1, 1, 20, 1),
(23, 17, 1, 1, 20, 1),
(24, 18, 1, 1, 20, 1),
(25, 18, 2, 1, 25, 1),
(26, 18, 2, 1, 25, 1),
(27, 19, 1, 1, 20, 1),
(28, 20, 1, 1, 20, 1),
(29, 20, 2, 1, 25, 1),
(30, 21, 1, 1, 20, 1),
(31, 22, 1, 1, 20, 1),
(32, 23, 1, 1, 20, 1),
(33, 24, 2, 1, 25, 1),
(34, 24, 3, 1, 30, 1),
(35, 25, 3, 1, 30, 1),
(36, 26, 3, 1, 30, 1),
(37, 26, 3, 1, 30, 1),
(38, 26, 3, 1, 30, 1),
(39, 26, 3, 1, 30, 1),
(40, 27, 3, 1, 30, 1),
(41, 28, 3, 1, 30, 1),
(42, 29, 3, 1, 30, 1),
(43, 30, 3, 1, 30, 1),
(44, 31, 3, 1, 30, 1),
(45, 32, 3, 1, 30, 1),
(46, 33, 3, 1, 30, 1),
(47, 34, 3, 1, 30, 1),
(48, 35, 3, 1, 30, 1),
(49, 36, 3, 1, 30, 1),
(50, 36, 3, 1, 30, 1),
(51, 37, 3, 1, 30, 1),
(52, 38, 3, 1, 30, 1),
(53, 38, 1, 1, 20, 1),
(54, 39, 3, 1, 30, 1),
(55, 40, 3, 1, 30, 1),
(56, 40, 3, 1, 30, 1),
(57, 40, 3, 1, 30, 1),
(58, 42, 3, 1, 30, 1),
(59, 43, 3, 1, 30, 1),
(60, 44, 3, 1, 30, 1),
(61, 44, 3, 1, 30, 1),
(62, 44, 3, 1, 30, 1),
(63, 45, 3, 1, 30, 1),
(64, 45, 1, 1, 20, 1),
(65, 45, 3, 1, 30, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `orderid` int(11) NOT NULL,
  `customerid` int(11) NOT NULL,
  `orderdate` date NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`orderid`, `customerid`, `orderdate`, `active`) VALUES
(1, 20, '2017-04-26', 0),
(2, 20, '2017-04-26', 1),
(3, 20, '2017-04-26', 1),
(4, 20, '2017-04-26', 1),
(5, 20, '2017-04-26', 1),
(6, 20, '2017-04-26', 1),
(7, 20, '2017-04-26', 1),
(8, 20, '2017-04-26', 1),
(9, 20, '2017-04-26', 1),
(10, 20, '2017-04-26', 1),
(11, 20, '2017-04-26', 1),
(12, 20, '2017-04-26', 1),
(13, 20, '2017-04-26', 1),
(14, 20, '2017-04-26', 1),
(15, 20, '2017-04-26', 1),
(16, 20, '2017-04-27', 1),
(17, 20, '2017-04-27', 1),
(18, 20, '2017-04-28', 1),
(19, 20, '2017-04-28', 1),
(20, 26, '2017-04-28', 1),
(21, 26, '2017-04-28', 1),
(22, 26, '2017-04-28', 1),
(23, 27, '2017-04-29', 1),
(24, 25, '2017-04-29', 1),
(25, 25, '2017-04-29', 0),
(26, 25, '2017-04-29', 1),
(27, 25, '2017-04-29', 1),
(28, 25, '2017-04-29', 1),
(29, 25, '2017-04-29', 1),
(31, 25, '2017-04-29', 1),
(32, 25, '2017-04-29', 1),
(33, 25, '2017-04-29', 1),
(35, 25, '2017-04-29', 1),
(36, 25, '2017-04-29', 1),
(37, 25, '2017-04-29', 1),
(38, 25, '2017-04-29', 1),
(39, 25, '2017-04-29', 1),
(40, 25, '2017-04-29', 1),
(41, 25, '2017-04-29', 1),
(42, 25, '2017-04-29', 1),
(43, 25, '2017-04-29', 1),
(44, 25, '2017-04-29', 1),
(45, 25, '2017-04-29', 1);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `paymentid` int(11) NOT NULL,
  `customerid` int(11) NOT NULL,
  `paymentmethod` int(11) NOT NULL,
  `amountpaid` decimal(10,0) NOT NULL,
  `paymentdate` date NOT NULL,
  `orderid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`paymentid`, `customerid`, `paymentmethod`, `amountpaid`, `paymentdate`, `orderid`) VALUES
(1, 20, 1, '23', '2017-04-27', 17),
(2, 20, 1, '23', '2017-04-27', 17),
(3, 20, 1, '23', '2017-04-27', 17),
(4, 20, 1, '23', '2017-04-27', 17),
(5, 20, 1, '23', '2017-04-27', 17),
(6, 20, 1, '23', '2017-04-28', 17),
(7, 20, 1, '23', '2017-04-28', 17),
(8, 20, 1, '23', '2017-04-28', 17),
(9, 20, 1, '23', '2017-04-28', 17),
(10, 20, 1, '23', '2017-04-28', 17),
(11, 20, 1, '23', '2017-04-28', 17),
(12, 20, 1, '23', '2017-04-28', 17),
(13, 20, 1, '23', '2017-04-28', 17),
(14, 20, 1, '23', '2017-04-28', 17),
(15, 20, 1, '23', '2017-04-28', 17),
(16, 20, 1, '23', '2017-04-28', 17),
(17, 20, 1, '23', '2017-04-28', 17),
(18, 20, 1, '23', '2017-04-28', 17),
(19, 20, 1, '23', '2017-04-28', 17),
(20, 20, 1, '23', '2017-04-28', 19),
(21, 20, 1, '23', '2017-04-28', 19),
(22, 20, 1, '23', '2017-04-28', 19),
(23, 26, 1, '51', '2017-04-28', 20),
(24, 26, 1, '51', '2017-04-28', 20),
(25, 26, 1, '51', '2017-04-28', 20),
(26, 26, 1, '51', '2017-04-28', 20),
(27, 26, 1, '23', '2017-04-28', 21),
(28, 26, 1, '23', '2017-04-28', 21),
(29, 26, 1, '23', '2017-04-28', 22),
(30, 27, 1, '23', '2017-04-29', 23),
(31, 25, 1, '34', '2017-04-29', 31),
(32, 25, 1, '90', '2017-04-29', 45);

-- --------------------------------------------------------

--
-- Table structure for table `phonenumbers`
--

CREATE TABLE `phonenumbers` (
  `phoneid` int(11) NOT NULL,
  `customerid` int(11) NOT NULL,
  `phone` varchar(14) NOT NULL,
  `ext` varchar(6) NOT NULL,
  `phonetype` varchar(25) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `phonenumbers`
--

INSERT INTO `phonenumbers` (`phoneid`, `customerid`, `phone`, `ext`, `phonetype`, `active`) VALUES
(34, 20, '111', 'H', '', 1),
(35, 20, '111', '', 'H', 0),
(36, 20, '111', '', 'H', 0),
(37, 20, '222', '444', 'W', 0),
(38, 20, '333', '', 'C', 0),
(39, 20, '111', '', 'H', 0),
(40, 20, '222', '444', 'W', 0),
(41, 20, '333', '', 'C', 0),
(42, 20, '111', '', 'H', 0),
(43, 20, '222', '444', 'W', 0),
(44, 20, '333', '', 'C', 0),
(45, 20, '111', '', 'H', 0),
(46, 20, '222', '444', 'W', 0),
(47, 20, '333', '', 'C', 0),
(48, 20, '111', '', 'H', 0),
(49, 20, '222', '444', 'W', 0),
(50, 20, '333', '', 'C', 0),
(51, 20, '111', '', 'H', 0),
(52, 20, '222', '444', 'W', 0),
(53, 20, '333', '', 'C', 0),
(54, 20, '111', '', 'H', 0),
(55, 20, '222', '444', 'W', 0),
(56, 20, '333', '', 'C', 0),
(57, 20, '111', '', 'H', 0),
(58, 20, '222', '444', 'W', 0),
(59, 20, '333', '', 'C', 0),
(60, 20, '111', '', 'H', 0),
(61, 20, '222', '444', 'W', 0),
(62, 20, '333', '', 'C', 0),
(63, 20, '111', '', 'H', 0),
(64, 20, '222', '444', 'W', 0),
(65, 20, '333', '', 'C', 0),
(66, 20, '111', '', 'H', 0),
(67, 20, '222', '444', 'W', 0),
(68, 20, '333', '', 'C', 0),
(69, 20, '111', '', 'H', 0),
(70, 20, '222', '444', 'W', 0),
(71, 20, '333', '', 'C', 0),
(72, 20, '111', '', 'H', 0),
(73, 20, '222', '444', 'W', 0),
(74, 20, '333', '', 'C', 0),
(75, 20, '111', '', 'H', 0),
(76, 20, '222', '444', 'W', 0),
(77, 20, '333', '', 'C', 0),
(78, 20, '111', '', 'H', 0),
(79, 20, '222', '444', 'W', 0),
(80, 20, '333', '', 'C', 0),
(81, 20, '111', '', 'H', 0),
(82, 20, '222', '444', 'W', 0),
(83, 20, '333', '', 'C', 0),
(84, 20, '111', '', 'H', 0),
(85, 20, '222', '444', 'W', 0),
(86, 20, '333', '', 'C', 0),
(87, 20, '111', '', 'H', 0),
(88, 20, '222', '444', 'W', 0),
(89, 20, '333', '', 'C', 0),
(90, 20, '111', '', 'H', 0),
(91, 20, '222', '444', 'W', 0),
(92, 20, '333', '', 'C', 0),
(93, 20, '111', '', 'H', 0),
(94, 20, '222', '444', 'W', 0),
(95, 20, '333', '', 'C', 0),
(96, 20, '111', '', 'H', 0),
(97, 20, '222', '444', 'W', 0),
(98, 20, '333', '', 'C', 0),
(99, 20, '111', '', 'H', 0),
(100, 20, '222', '444', 'W', 0),
(101, 20, '333', '', 'C', 0),
(102, 20, '111', '', 'H', 0),
(103, 20, '222', '444', 'W', 0),
(104, 20, '333', '', 'C', 0),
(105, 20, '111', '', 'H', 0),
(106, 20, '222', '444', 'W', 0),
(107, 20, '333', '', 'C', 0),
(108, 20, '111', '', 'H', 0),
(109, 20, '222', '444', 'W', 0),
(110, 20, '333', '', 'C', 0),
(111, 20, '111', '', 'H', 0),
(112, 20, '222', '444', 'W', 0),
(113, 20, '333', '', 'C', 0),
(114, 20, '111', '', 'H', 0),
(115, 20, '222', '444', 'W', 0),
(116, 20, '333', '', 'C', 0),
(117, 20, '111', '', 'H', 0),
(118, 20, '222', '444', 'W', 0),
(119, 20, '333', '', 'C', 0),
(120, 20, '111', '', 'H', 0),
(121, 20, '222', '444', 'W', 0),
(122, 20, '333', '', 'C', 0),
(123, 20, '111', '', 'H', 0),
(124, 20, '222', '444', 'W', 0),
(125, 20, '333', '', 'C', 0),
(126, 20, '111222', '', 'H', 0),
(127, 20, '222', '444', 'W', 0),
(128, 20, '333', '', 'C', 0),
(129, 20, '111222', '', 'H', 0),
(130, 20, '222', '44422', 'W', 0),
(131, 20, '333', '', 'C', 0),
(132, 25, '123', '', 'H', 1),
(133, 25, '12345', '111', 'W', 1),
(134, 25, '12345', '111', 'C', 1),
(135, 20, '111222', '', 'H', 1),
(136, 20, '222', '44422', 'W', 1),
(137, 20, '333', '', 'C', 1),
(138, 26, '111', '', 'H', 1),
(139, 26, '222', '444', 'W', 1),
(140, 26, '222', '444', 'C', 1),
(141, 27, '1112', '', 'H', 1),
(142, 27, '1113', '222', 'W', 1),
(143, 27, '1113', '222', 'C', 1);

-- --------------------------------------------------------

--
-- Table structure for table `provinces`
--

CREATE TABLE `provinces` (
  `provinceid` int(11) NOT NULL,
  `province` varchar(100) NOT NULL,
  `shortvalue` varchar(5) NOT NULL,
  `sortorder` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `provinces`
--

INSERT INTO `provinces` (`provinceid`, `province`, `shortvalue`, `sortorder`, `active`) VALUES
(1, 'Ontario', 'ON', 1, 1),
(2, 'Alberta', 'AB', 2, 1),
(3, 'British Columbia', 'BC', 3, 1),
(4, 'Manitoba', 'MB', 4, 1),
(5, 'New Brunswick', 'NB', 5, 1),
(6, 'Newfoundlad and Labrador', 'NL', 6, 1),
(7, 'Nova Scotia', 'NV', 7, 1),
(8, 'Prince Edward Island', 'PE', 8, 1),
(9, 'Quebec', 'QC', 9, 1),
(10, 'Saskatchewan', 'SK', 10, 1),
(11, 'Yukon', 'YT', 12, 1),
(12, 'Northwest Territories', 'NT', 11, 1);

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `sessionid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `sessionvalue` varchar(255) NOT NULL,
  `loggedindate` date NOT NULL,
  `loggedintime` time NOT NULL,
  `loggedoutdate` date NOT NULL,
  `loggedouttime` time NOT NULL,
  `isloggedin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`sessionid`, `userid`, `sessionvalue`, `loggedindate`, `loggedintime`, `loggedoutdate`, `loggedouttime`, `isloggedin`) VALUES
(5, 26, '5olu9m3qvnvmtrv7gjpputht47', '2017-04-28', '22:16:06', '2017-04-28', '23:58:55', 0),
(6, 26, '5olu9m3qvnvmtrv7gjpputht47', '2017-04-28', '23:55:06', '2017-04-28', '23:58:55', 0),
(7, 27, '5olu9m3qvnvmtrv7gjpputht47', '2017-04-29', '00:01:31', '2017-04-29', '15:05:41', 0),
(8, 25, '5olu9m3qvnvmtrv7gjpputht47', '2017-04-29', '15:15:19', '2017-04-29', '15:52:27', 0),
(9, 25, '5olu9m3qvnvmtrv7gjpputht47', '2017-04-29', '15:52:39', '0000-00-00', '00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `taxrates`
--

CREATE TABLE `taxrates` (
  `taxrateid` int(11) NOT NULL,
  `taxrate` decimal(2,2) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `taxrates`
--

INSERT INTO `taxrates` (`taxrateid`, `taxrate`, `active`) VALUES
(1, '0.13', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`addressid`);

--
-- Indexes for table `albums`
--
ALTER TABLE `albums`
  ADD PRIMARY KEY (`albumid`);

--
-- Indexes for table `albumscategories`
--
ALTER TABLE `albumscategories`
  ADD PRIMARY KEY (`albumid`,`categoryid`);

--
-- Indexes for table `cards`
--
ALTER TABLE `cards`
  ADD PRIMARY KEY (`cardid`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`categoryid`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`countryid`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customerid`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`invoicenumber`);

--
-- Indexes for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD PRIMARY KEY (`orderdetailid`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`orderid`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`paymentid`);

--
-- Indexes for table `phonenumbers`
--
ALTER TABLE `phonenumbers`
  ADD PRIMARY KEY (`phoneid`);

--
-- Indexes for table `provinces`
--
ALTER TABLE `provinces`
  ADD PRIMARY KEY (`provinceid`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`sessionid`);

--
-- Indexes for table `taxrates`
--
ALTER TABLE `taxrates`
  ADD PRIMARY KEY (`taxrateid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `addressid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;
--
-- AUTO_INCREMENT for table `albums`
--
ALTER TABLE `albums`
  MODIFY `albumid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `cards`
--
ALTER TABLE `cards`
  MODIFY `cardid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `categoryid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `countryid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customerid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;
--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `invoicenumber` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `orderdetails`
--
ALTER TABLE `orderdetails`
  MODIFY `orderdetailid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;
--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `orderid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;
--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `paymentid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;
--
-- AUTO_INCREMENT for table `phonenumbers`
--
ALTER TABLE `phonenumbers`
  MODIFY `phoneid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=144;
--
-- AUTO_INCREMENT for table `provinces`
--
ALTER TABLE `provinces`
  MODIFY `provinceid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `sessions`
--
ALTER TABLE `sessions`
  MODIFY `sessionid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `taxrates`
--
ALTER TABLE `taxrates`
  MODIFY `taxrateid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
