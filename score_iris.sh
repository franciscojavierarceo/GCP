virtualenv cmle-env
source cmle-env/bin/activate

BUCKET_NAME=myfirstproject-fja-mlengine
JOB_NAME=iris_xgboost_20190216_165955
JOB_DIR=gs://myfirstproject-fja-mlengine/xgboost_job_dir
MAIN_TRAINER_MODULE=iris_xgboost_trainer.iris_training
REGION=us-central1
RUNTIME_VERSION=1.12
PYTHON_VERSION=2.7
SCALE_TIER=BASIC
FRAMEWORK=XGBOOST

gcloud ml-engine jobs submit training $JOB_NAME \
  --job-dir $JOB_DIR \
  --package-path $TRAINING_PACKAGE_PATH \
  --module-name $MAIN_TRAINER_MODULE \
  --region $REGION \
  --runtime-version=$RUNTIME_VERSION \
  --python-version=$PYTHON_VERSION \
  --scale-tier $SCALE_TIER

# You can see the logs using:
gcloud ml-engine jobs stream-logs $JOB_NAME


# And see the *.bst model at:
gsutil ls gs://$BUCKET_NAME/iris_*

# make sure you have the following installed:
pip install joblib xgboost six tensorflow 

# make sure you remove .pyc files from the path below:
rm ~/google-cloud-sdk/lib/googlecloudsdk/command_lib/ml_engine/*.pyc

# Finally score the model
gcloud ml-engine local predict --model-dir=$MODEL_DIR \
    --json-instances=input3.json \
    --verbosity debug \
    --framework=$FRAMEWORK

