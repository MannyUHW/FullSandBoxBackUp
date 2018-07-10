public class UnpaidInternsTx {
    public id ContactId           { get; set; }
    public id InterviewerId       { get; set; }
    public datetime InterviewDate { get; set; }
    public datetime UpdatedDate   { get; set; }
    public boolean Updated        { get; set; }
    public string MemberName      { get; set; }
    public string A1              { get; set; }
    public string A2              { get; set; }
    public string A3              { get; set; }
    public string A4              { get; set; }
    public string A5              { get; set; }
    public string A5_Other        { get; set; }
    public string A6              { get; set; }
    public string A7              { get; set; }
    public string A8              { get; set; }
    public string A9              { get; set; }
    public string A10             { get; set; }
    public string A11             { get; set; }
    public string A12             { get; set; }
    public string A13             { get; set; }
    public string A14             { get; set; }
    public string A15             { get; set; }
    public string EthnicGroup     { get; set; }
    public string PrimaryLanguage { get; set; }
    public string Gender          { get; set; }

    // courtesy of http://json2apex.herokuapp.com/
    public static UnpaidInternsTx parse(String json) {
        return (UnpaidInternsTx) System.JSON.deserialize(json, UnpaidInternsTx.class);
    }
}