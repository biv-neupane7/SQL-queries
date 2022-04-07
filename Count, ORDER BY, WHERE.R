
# Calling the first name, last name and email address of customer from
# dvdrental db


library(DBI)
library(odbc)
library(RODBC)
library(RPostgreSQL)
library(dbplyr)
library(dplyr)

dvdrental<- dbConnect(odbc::odbc(),"Pos")

dbGetQuery(dvdrental, "SELECT *
           FROM customer")

cust_info<- tbl(dvdrental, customer)
cust_info

# converting to a df like structure

cust_df<- collect(cust_info)

cust_df


# Interacting with the dvdrental db from R

count_query<- "SELECT store_id, COUNT(*) 
                FROM customer 
                GROUP BY store_id" 

# This code produces a string that has this query written down in it.
# In the code, the FROM customer coz we are calling the store_id from the
# customer table.

# Now to run this query, we have few options:

                  
##################### 1) Run the DBI package directly #######################


dbGetQuery(dvdrental, count_query)
            
              # OR
            
store_count_df<- dbGetQuery(dvdrental, "SELECT store_id, COUNT(*)
           FROM customer
           GROUP BY store_id")

store_count_df

class(store_count_df) # Store_count is a df

#################### 2) Use dplyr() #########################################


store_count<- tbl(dvdrental, sql(count_query)) # Note that this command
# does not bring the data from the database to R. 

# To bring the data to R, we have to use the collect function:


store_count_df1<- collect(store_count)
store_count_df1


class(store_count_df1) # It is a tibble dataframe
                              
                              # OR

              # use a dplyr pipe %>%

store_count<- tbl(dvdrental, sql(count_query)) %>% 
              collect(store_count)
store_count

#############################################################################

# Working with dplyr continued...............

# First, access a certain table from the database

customer<- tbl(dvdrental, "customer")

# Then, select a specific data or do other things from the table using dplyr
# code. Note that we are not using any SQL query here. 

customer_count<- customer %>% 
  group_by(customer_id) %>%
  summarize(count=n()) %>% collect()

customer_count



###########################################################################


# USING DISTINCT Function


distinct_rates<- dbGetQuery(dvdrental, "SELECT DISTINCT(rental_rate)
           FROM film")

class(distinct_rates)

# USING COUNT FUNCTION

count_rows<- dbGetQuery(dvdrental, "SELECT COUNT(*) 
                        FROM film")
count_rows

##################### USING DISTINCT AND COUNT TOGETHER ##################


dis_duration<- dbGetQuery(dvdrental, "SELECT COUNT(DISTINCT(rental_duration))
                          FROM film")
dis_duration

################### USING WHERE STATEMENT ################################


info_jared<- dbGetQuery(dvdrental, "SELECT *
                        FROM customer
                        WHERE first_name='Jared'")
View(info_jared)

    # Next QNS: Find all the rental rates that are above 4 dollars from 
    # the film table

rates_above4<- dbGetQuery(dvdrental, "SELECT *
                          FROM film
                          WHERE rental_rate>4")

    # But how many movies were there which passed the hurdle?

dbGetQuery(dvdrental, "SELECT COUNT(*)
           FROM film
           WHERE rental_rate>4")


    # Lets add 1 more layer to it. On the top of above condition, 
    # also add replacement costs of 19.99

dbGetQuery(dvdrental, "SELECT COUNT(*)
                       FROM film
                       WHERE rental_rate>4 AND replacement_cost>=19.99")



################### PRACTICE QUESTIONS ####################################


# A customer forgot their wallet at our work store! We need to track down her
# email to inform her. Whats the email of the customer with 
# the name "Nancy Thomas"?


dbGetQuery(dvdrental, "SELECT email
           FROM customer
           WHERE first_name='Nancy' AND last_name='Thomas'")

# A customer wants to know what the movie "Outlaw Hanky" is about. 
# Could you give them the description for the movie "Outlaw Hanky"?

dbGetQuery(dvdrental, "SELECT description
           FROM film
           WHERE title='Outlaw Hanky'")



###################### ORDER BY ########################################

# Ordering the names of customers in either ascending or descending manner

head(dbGetQuery(dvdrental, "SELECT first_name
           FROM customer
           ORDER BY first_name ASC"))






































