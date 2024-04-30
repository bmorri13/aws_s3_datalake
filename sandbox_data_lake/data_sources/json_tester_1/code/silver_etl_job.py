import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job


# Comment
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated for node convert_bronze
convert_bronze_node1712719750307 = glueContext.create_dynamic_frame.from_catalog(
    database="bronze-sandbox", table_name="csv_tester_1", transformation_ctx="convert_bronze_node1712719750307")

# Script generated for node Change Schema
ChangeSchema_node1712725809626 = ApplyMapping.apply(
    frame=convert_bronze_node1712719750307, 
    mappings=[("firstname", "string", "firstname", "string"), ("lastname", "string", "lastname", "string"), ("id", "long", "id", "long"), ("ip", "string", "ip", "string"), ("year", "string", "year", "string"), ("month", "string", "month", "string"), ("day", "string", "day", "string"), ("hour", "string", "hour", "string")], 
    transformation_ctx="ChangeSchema_node1712725809626")

# Script generated for node Amazon S3
AmazonS3_node1712719773884 = glueContext.write_dynamic_frame.from_options(
    frame=ChangeSchema_node1712725809626, 
    connection_type="s3", format="glueparquet", 
    connection_options={"path": "s3://cointhieves-datalake-sandbox/silver/json_tester_1/partitioned/", "partitionKeys": ["year", "month", "day", "hour"]}, 
    format_options={"compression": "snappy"}, transformation_ctx="AmazonS3_node1712719773884")

job.commit()