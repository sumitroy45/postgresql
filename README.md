# Postgresql procedure to download data in csv format and insert into dynamically created table.

### Requirement
- Download csv file from url
- Read the first line of the csv file and create the temporary table based on the header row. 
- update the table with the data from the csv file. 
- update the admin table with the file downloaded with the complete data.

## Steps
- Create the database and user in postgresql 
- create the extensions for plpython3u for that database
- create the admin table in **public** schema
- create the processing schema called **process**
- compile the stored procedure
- execute the stored procedure 

## Create the database and user in postgresql 

- login into postgres user
    - In linux:
    
        $>sudo su root
        
        $>su postgres 
        
        $> psql
        
    - In Windows:
    
        use any postgresql client and login as "postgres" user
    
- Execute the following commands in the psql shell or postgresql client. 

    postgres=# create database data_test ;
    
    postgres=# create user testuser  with encrypted password 'phe8ahkei' ;
    
    postgres=# grant all privileges on database data_test  to testuser  ;
    
    postgres=# ALTER USER testuser  WITH SUPERUSER;
    
    postgres=# \q  *(Exiting from psql shell)*
    
- Login as testuser from your own user

    *$>psql -U testuser -W -d data_test*
    
    data_test=# create extension plpython3u ;
    
    data_test=# create schema process ;
    
    data_test=# CREATE TABLE public.admin_ingestion (
                                    file_name text NULL,
                                    url text NULL,
                                    date_of_ingestion date NULL,
                                    data text NULL);
                                    
    data_test=# \i get_uridata.sql  
    
    
- Now you can execute the stored procedure by 

    - select get_uridata(url) ;
    
- 
