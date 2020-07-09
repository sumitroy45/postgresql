CREATE OR REPLACE FUNCTION public.get_uridata(uri text)
 RETURNS text
 LANGUAGE plpython3u
AS $function$
  import requests 
  import base64
  import time 
  filename = filename = uri.split('/')[-1].split('.')[0] 
  today = time.strftime('%Y-%m-%d', time.localtime())
  stoday = time.strftime('%Y_%m_%d',time.localtime())
  data = requests.get(uri) 
  if (data.status_code == 200):
  	rdata = data.content
  	sdata = rdata.splitlines()
  	hdata = sdata[0].decode('ascii')
  	hcolumns = hdata.split(',')
  	table_name = filename.replace('%20','') + stoday 

  	""" Dropping the table if it exists in the process schema """
  	query1 = 'drop table if exists process.%s ' % (table_name)
  	res = plpy.execute(query1)
  	
  	"""Creating the table in the process schema"""
  	query = 'create table if not exists process.%s (' % (table_name)
  	for rd in hcolumns:
  		query += '%s    text,' % rd 
  	query = query[:-1] +  ')'
  	res = plpy.execute(query)
  	
  	"""Creating the insert statement for inserting data in the table"""
  	bdata = sdata[1:]
  	for rows in bdata:
  		query_ins = 'insert into process.%s values(' % table_name
  		for col in rows.decode('ascii').split(','):
  			query_ins += """ '%s',""" % col 
  		query_ins = query_ins[:-1] + ')'
  		res = plpy.execute(query_ins)
  	admn_query = """insert into admin_ingestion (file_name,url,date_of_ingestion,data) values ('%s','%s','%s','%s')""" % (filename,uri,today,rdata.decode('ascii'))
  	res = plpy.execute(admn_query)
  	
  	return rdata
$function$
;
