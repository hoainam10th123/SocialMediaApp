using Microsoft.ML;
using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.MLDataStructures;

namespace ReactMXHApi6
{
    public enum MyTrainerStrategy : int { SdcaMultiClassTrainer = 1, OVAAveragedPerceptronTrainer = 2 };

    public class MLStartRun
    {
        public static string DataSetLocation = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Data", "corefx-issues-train.tsv");
        public static string ModelPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "MLModels", "PhanLoaiLabelerModel.zip");

        public static void BuildAndTrainModel(MyTrainerStrategy selectedStrategy)
        {
            // Create MLContext to be shared across the model creation workflow objects 
            // Set a random seed for repeatable/deterministic results across multiple trainings.
            var mlContext = new MLContext(seed: 1);

            // STEP 1: Common data loading configuration
            var trainingDataView = mlContext.Data.LoadFromTextFile<PostData>(DataSetLocation, hasHeader: true, separatorChar: '\t', allowSparse: false);

            // STEP 2: Common data process configuration with pipeline data transformations
            var dataProcessPipeline = mlContext.Transforms.Conversion.MapValueToKey(outputColumnName: "Label", inputColumnName: nameof(PostData.Category))
                            .Append(mlContext.Transforms.Text.FeaturizeText(outputColumnName: "ContentFeaturized", inputColumnName: nameof(PostData.NoiDung)))
                            .Append(mlContext.Transforms.Concatenate(outputColumnName: "Features", "ContentFeaturized"))
                            .AppendCacheCheckpoint(mlContext);
            // Use in-memory cache for small/medium datasets to lower training time. 
            // Do NOT use it (remove .AppendCacheCheckpoint()) when handling very large datasets.

            // (OPTIONAL) Peek data (such as 2 records) in training DataView after applying the ProcessPipeline's transformations into "Features" 
            //CommonA.ConsoleHelper.PeekDataViewInConsole(mlContext, trainingDataView, dataProcessPipeline, 2);

            // STEP 3: Create the selected training algorithm/trainer
            IEstimator<ITransformer> trainer = null;
            switch (selectedStrategy)
            {
                case MyTrainerStrategy.SdcaMultiClassTrainer:
                    trainer = mlContext.MulticlassClassification.Trainers.SdcaMaximumEntropy("Label", "Features");
                    break;
                case MyTrainerStrategy.OVAAveragedPerceptronTrainer:
                    {
                        // Create a binary classification trainer.
                        var averagedPerceptronBinaryTrainer = mlContext.BinaryClassification.Trainers.AveragedPerceptron("Label", "Features", numberOfIterations: 10);
                        // Compose an OVA (One-Versus-All) trainer with the BinaryTrainer.
                        // In this strategy, a binary classification algorithm is used to train one classifier for each class, "
                        // which distinguishes that class from all other classes. Prediction is then performed by running these binary classifiers, "
                        // and choosing the prediction with the highest confidence score.
                        trainer = mlContext.MulticlassClassification.Trainers.OneVersusAll(averagedPerceptronBinaryTrainer);

                        break;
                    }
                default:
                    break;
            }

            //Set the trainer/algorithm and map label to value (original readable state)
            var trainingPipeline = dataProcessPipeline.Append(trainer)
                    .Append(mlContext.Transforms.Conversion.MapKeyToValue("PredictedLabel"));

            // STEP 4: Cross-Validate with single dataset (since we don't have two datasets, one for training and for evaluate)
            // in order to evaluate and get the model's accuracy metrics

            Console.WriteLine("=============== Cross-validating to get model's accuracy metrics ===============");
            var crossValidationResults = mlContext.MulticlassClassification.CrossValidate(data: trainingDataView, estimator: trainingPipeline, numberOfFolds: 6, labelColumnName: "Label");         

            // STEP 5: Train the model fitting to the DataSet
            Console.WriteLine("=============== Training the model ===============");
            var trainedModel = trainingPipeline.Fit(trainingDataView);

            // (OPTIONAL) Try/test a single prediction with the "just-trained model" (Before saving the model)
            var issue = new PostData() { Id = "Any-id", NoiDung = "Selling Phone" };
            // Create prediction engine related to the loaded trained model
            var predEngine = mlContext.Model.CreatePredictionEngine<PostData, PostPrediction>(trainedModel);
            //Score
            var prediction = predEngine.Predict(issue);
            Console.WriteLine($"=============== Single Prediction just-trained-model - Result: {prediction.Area} ===============");
            //

            // STEP 6: Save/persist the trained model to a .ZIP file
            Console.WriteLine("=============== Saving the model to a file ===============");
            mlContext.Model.Save(trainedModel, trainingDataView.Schema, ModelPath);
        }

        public static void TestSingleLabelPrediction(PostData data)
        {
            var labeler = new Labeler(modelPath: ModelPath);
            labeler.TestPredictionForSingleIssue(data);
        }
    }
}
