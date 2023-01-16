using Microsoft.ML.Data;

namespace ReactMXHApi6.MLDataStructures
{
    public class PostPrediction
    {
        [ColumnName("PredictedLabel")]
        public string Area;

        public float[] Score;
    }
}
