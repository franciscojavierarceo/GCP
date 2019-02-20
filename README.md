# Google Cloud Project

This is a test application using Google Cloud. Much of the documentation for this demo can be found at 

    1. https://cloud.google.com/ml-engine/docs/scikit/getting-started-training
    2. https://cloud.google.com/ml-engine/docs/scikit/getting-predictions-xgboost
    3. https://stackoverflow.com

I decided to make this demo because, while the GCP documentation is great, it didn't have the example for pushing the Iris Xgboost model to production.


First make sure you have virtualenv installed
    
    pip install --user --upgrade virtualenv

Then source the virtual environment by executing:

    virtualenv cmle-env
    source cmle-env/bin/activate


Then to run the model simply execute:

    # Note that you should change most of these according to the documentation in the steps outliend in (1)
    BUCKET_NAME=myfirstproject-fja-mlengine
    JOB_NAME=iris_xgboost_20190216_165955
    JOB_DIR=gs://myfirstproject-fja-mlengine/xgboost_job_dir
    MAIN_TRAINER_MODULE=iris_xgboost_trainer.iris_training
    REGION=us-central1
    RUNTIME_VERSION=1.12
    PYTHON_VERSION=2.7
    SCALE_TIER=BASIC
    FRAMEWORK=XGBOOST

    # Submitting the job to train the model 
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
    
    # Create a test input file that you can use to try and score the live model
        (cmle-env) franciscojavierarceo$ cat input.json 
        [5.1, 3.5, 1.4, 0.2] 
        [4.9, 3.0, 1.4, 0.2]
        [4.7, 3.2, 1.3, 0.2]
        [4.6, 3.1, 1.5, 0.2]
        [5.0, 3.6, 1.4, 0.2]
        [5.4, 3.9, 1.7, 0.4]
        [4.6, 3.4, 1.4, 0.3]
        [5.0, 3.4, 1.5, 0.2]
        [4.4, 2.9, 1.4, 0.2]


    # Finally score the test sample with the input.json file
    gcloud ml-engine local predict --model-dir=$MODEL_DIR \
        --json-instances=input.json \
        --verbosity debug \
        --framework=$FRAMEWORK


