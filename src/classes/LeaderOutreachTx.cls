public class LeaderOutreachTx {

    public string LeaderFirstName  { get; set; }
    public string LeaderLastName   { get; set; }
    public string MemberFirstName  { get; set; }
    public string MemberLastName   { get; set; }
    public string EmpId            { get; set; }
    public string Answer1          { get; set; }
    public string Answer2          { get; set; }
    public string Answer3          { get; set; }
    public string Answer4          { get; set; }
    public string MemberEmail      { get; set; }
    public string MemberDepartment { get; set; }
    public string MemberCellPhone  { get; set; }
    public string MemberEmpId      { get; set; }

    public static LeaderOutreachTx parse(String json) {
      return (LeaderOutreachTx) System.JSON.deserialize(json, LeaderOutreachTx.class);
    }
}