using Microsoft.ML.Data;
using Microsoft.ML;
using ReactMXHApi6.Core.Entities;
using System.Linq.Expressions;


namespace ReactMXHApi6.MLDataStructures
{
    public class Labeler
    {
        private readonly string _modelPath;
        private readonly MLContext _mlContext;

        private readonly PredictionEngine<PostData, PostPrediction> _predEngine;
        private readonly ITransformer _trainedModel;

        private FullPrediction[] _fullPredictions;

        public Labeler(string modelPath)
        {
            _modelPath = modelPath;

            _mlContext = new MLContext();

            // Load model from file.
            _trainedModel = _mlContext.Model.Load(_modelPath, out var modelInputSchema);

            // Create prediction engine related to the loaded trained model.
            _predEngine = _mlContext.Model.CreatePredictionEngine<PostData, PostPrediction>(_trainedModel);
        }

        public Category TestPredictionForSingleIssue(PostData data)
        {
            // Predict labels and scores for single hard-coded issue.
            var prediction = _predEngine.Predict(data);

            _fullPredictions = GetBestThreePredictions(prediction);

            Console.WriteLine($"==== Displaying prediction of Issue with Title = {data.NoiDung} ====");

            Console.WriteLine("1st Label: " + _fullPredictions[0].PredictedLabel + " with score: " + _fullPredictions[0].Score);
            Console.WriteLine("2nd Label: " + _fullPredictions[1].PredictedLabel + " with score: " + _fullPredictions[1].Score);
            Console.WriteLine("3rd Label: " + _fullPredictions[2].PredictedLabel + " with score: " + _fullPredictions[2].Score);

            Console.WriteLine($"=============== Single Prediction - Result: {prediction.Area} ===============");
            Category category = Category.Sell;
            switch (prediction.Area)
            {
                case "Sell":
                    category = Category.Sell;
                    break;
                case "Game":
                    category = Category.Game;
                    break;
                default:
                    category = Category.Video;
                    break;
            }

            return category;
        }

        private FullPrediction[] GetBestThreePredictions(PostPrediction prediction)
        {
            float[] scores = prediction.Score;
            int size = scores.Length;
            int index0, index1, index2 = 0;

            VBuffer<ReadOnlyMemory<char>> slotNames = default;
            _predEngine.OutputSchema[nameof(PostPrediction.Score)].GetSlotNames(ref slotNames);

            GetIndexesOfTopThreeScores(scores, size, out index0, out index1, out index2);

            _fullPredictions = new FullPrediction[]
                {
                    new FullPrediction(slotNames.GetItemOrDefault(index0).ToString(),scores[index0],index0),
                    new FullPrediction(slotNames.GetItemOrDefault(index1).ToString(),scores[index1],index1),
                    new FullPrediction(slotNames.GetItemOrDefault(index2).ToString(),scores[index2],index2)
                };

            return _fullPredictions;
        }

        private void GetIndexesOfTopThreeScores(float[] scores, int n, out int index0, out int index1, out int index2)
        {
            int i;
            float first, second, third;
            index0 = index1 = index2 = 0;
            if (n < 3)
            {
                Console.WriteLine("Invalid Input");
                return;
            }
            third = first = second = 000;
            for (i = 0; i < n; i++)
            {
                // If current element is  
                // smaller than first 
                if (scores[i] > first)
                {
                    third = second;
                    second = first;
                    first = scores[i];
                }
                // If arr[i] is in between first 
                // and second then update second 
                else if (scores[i] > second)
                {
                    third = second;
                    second = scores[i];
                }

                else if (scores[i] > third)
                    third = scores[i];
            }
            var scoresList = scores.ToList();
            index0 = scoresList.IndexOf(first);
            index1 = scoresList.IndexOf(second);
            index2 = scoresList.IndexOf(third);
        }

        public FullPrediction[] Predict(PostData issue)
        {
            var prediction = _predEngine.Predict(issue);

            var fullPredictions = GetBestThreePredictions(prediction);

            return fullPredictions;
        }
    }
}
