public class RecruitTx {
  public string Agent       { get; set; }
  public id ContactId       { get; set; }
  public id RecruitRecId    { get; set; }
  public boolean Attended   { get; set; }
  public string Credit      { get; set; }
  public boolean OkToText   { get; set; }
  public string EthnicGroup { get; set; }

  // courtesy of http://json2apex.herokuapp.com/
  public static RecruitTx parse(String json) {
      return (RecruitTx) System.JSON.deserialize(json, RecruitTx.class);
  }
}