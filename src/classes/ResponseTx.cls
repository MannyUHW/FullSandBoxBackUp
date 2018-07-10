public class ResponseTx {

    public string QuestionId { get; set; }
    public string ContactId  { get; set; }
    public string SurveyId   { get; set; }
    public string SurveyCode { get; set; }
    public string Response   { get; set; }
    public string ResponseId { get; set; }
    public string CommitTime { get; set; }

    public static ResponseTx parse(String json) {
      return (ResponseTx) System.JSON.deserialize(json, ResponseTx.class);
    }
}