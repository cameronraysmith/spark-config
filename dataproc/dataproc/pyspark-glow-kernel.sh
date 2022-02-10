#!/bin/sh
# https://stackoverflow.com/a/53595397/446907
KERNEL_PATH="pyspark-glow"
cp -r /opt/conda/miniconda3/share/jupyter/kernels/pyspark /opt/conda/miniconda3/share/jupyter/kernels/$KERNEL_PATH
echo '{
  "argv": [
    "bash",
    "-c",
    "PYSPARK_DRIVER_PYTHON_OPTS='"'"'kernel -f {connection_file}'"'"' pyspark --packages io.projectglow:glow-spark3_2.12:1.1.2 --conf spark.hadoop.io.compression.codecs=io.projectglow.sql.util.BGZFCodec"
  ],
  "display_name": "PySpark Glow",
  "language": "python",
  "env": {
    "PYSPARK_DRIVER_PYTHON": "/opt/conda/miniconda3/bin/ipython",
    "PYSPARK_PYTHON": "/opt/conda/miniconda3/bin/python"
  }
}' > /opt/conda/miniconda3/share/jupyter/kernels/$KERNEL_PATH/kernel.json
