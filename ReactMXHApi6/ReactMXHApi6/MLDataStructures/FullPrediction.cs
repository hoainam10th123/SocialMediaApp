namespace ReactMXHApi6.MLDataStructures
{
    public class FullPrediction
    {
        public string PredictedLabel;
        public float Score;
        public int OriginalSchemaIndex;

        public FullPrediction(string predictedLabel, float score, int originalSchemaIndex)
        {
            PredictedLabel = predictedLabel;
            Score = score;
            OriginalSchemaIndex = originalSchemaIndex;
        }
    }
}
