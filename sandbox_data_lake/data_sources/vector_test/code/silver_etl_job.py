import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import col
from pyspark.sql.types import StructType, ArrayType
from awsglue.dynamicframe import DynamicFrame

# Comments here
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Read data from the catalog
dynamic_frame = glueContext.create_dynamic_frame.from_catalog(
    database="bronze-sandbox", 
    table_name="vector_test", 
    transformation_ctx="dynamic_frame"
)

# Drop the specified fields using DropFields
dropped_fields_df = DropFields.apply(
    frame=dynamic_frame,
    paths=["partition_0"],
    transformation_ctx="dropped_fields_df"
)

# Convert to DataFrame for schema manipulation
df = dropped_fields_df.toDF()

# Function to flatten DataFrame schema
def flatten_df(nested_df, layers=[]):
    flat_cols = []
    complex_cols = []

    # Identify flat and complex columns
    for field in nested_df.schema.fields:
        if isinstance(field.dataType, StructType) or isinstance(field.dataType, ArrayType):
            complex_cols.append(field.name)
        else:
            flat_cols.append(col(".".join(layers + [field.name])).alias("_".join(layers + [field.name])))

    # Recursively handle complex columns
    for col_name in complex_cols:
        field = nested_df.schema[col_name]
        if isinstance(field.dataType, StructType):
            flat_cols += flatten_df(nested_df.select(col_name + ".*"), layers=layers + [col_name])
        elif isinstance(field.dataType, ArrayType) and isinstance(field.dataType.elementType, StructType):
            flat_cols += flatten_df(nested_df.select(col(".".join([col_name, "element.*"]))), layers=layers + [col_name])

    return flat_cols

# Use the function to flatten the DataFrame
flattened_columns = flatten_df(df)
flattened_df = df.select(flattened_columns)

# Convert the flattened DataFrame back to DynamicFrame
flattened_dynamic_frame = DynamicFrame.fromDF(flattened_df, glueContext, "flattened_dynamic_frame")

# Write the flattened data to S3
sink_node = glueContext.write_dynamic_frame.from_options(
    frame=flattened_dynamic_frame,
    connection_type="s3",
    format="glueparquet",
    connection_options={
        "path": "s3://cointhieves-datalake-sandbox/silver/vector_test/partitioned/",
        "partitionKeys": ["year", "month", "day", "hour", "minute"]
    },
    format_options={"compression": "snappy"},
    transformation_ctx="sink_node"
)

job.commit()
