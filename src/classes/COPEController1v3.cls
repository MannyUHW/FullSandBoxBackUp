public class COPEController1v3 {

    Private List<COPE_data__c> copeData;
    Private List<COPE_data__c> byDivEmp;
    Private List<COPE_NewIncData__c> byNewPayers;
    Private List<COPE_NewIncData__c> byIncPayers;

    Private List<COPE_NewIncData__c> newPayersList;
    Private List<COPE_NewIncData__c> incPayersList;

    Private Decimal divisionCOPEPercent, divisionCOPEPercentTen, divisionNewCOPECount, divisionNewCOPETotal, divisionCOPEIncreaseCountPerSeat, divisionCOPEIncreaseTotalPerSeat;
    Private Decimal divisionCOPETotalPerSeat,    divisionCOPECountPerSeat,    divisionCOPECountTenPlusPerSeat,    divisionEmpCountPerSeat;
    Private Decimal divisionCOPETotalPerSeat_3,  divisionCOPECountPerSeat_3,  divisionCOPECountTenPlusPerSeat_3,  divisionEmpCountPerSeat_3;
    Private Decimal divisionCOPETotalPerSeat_6,  divisionCOPECountPerSeat_6,  divisionCOPECountTenPlusPerSeat_6,  divisionEmpCountPerSeat_6;
    Private Decimal divisionCOPETotalPerSeat_9,  divisionCOPECountPerSeat_9,  divisionCOPECountTenPlusPerSeat_9,  divisionEmpCountPerSeat_9;
    Private Decimal divisionCOPETotalPerSeat_12, divisionCOPECountPerSeat_12, divisionCOPECountTenPlusPerSeat_12, divisionEmpCountPerSeat_12;

    Private List<COPE_data__c> buildList;
    Private COPE_data__c newItem;
    Private Integer rowPtr;
    Private Integer divisionPtr;
    private String arg;
    private String msg;

    Private List<chartData> chartData;

    public COPEController1v3() {

        newPayersList = new List<COPE_NewIncData__c>();
        incPayersList = new List<COPE_NewIncData__c>();

        if(byDivEmp == Null) {
            byDivEmp = buildbyDivEmpList();
        }


        if(byNewPayers == Null) {
            byNewPayers = buildbyDivEmpNewPayersList();
        }

        if(byIncPayers == Null) {
            byIncPayers = buildbyDivEmpIncPayersList();
        }

        if(chartData == Null) {
            chartData = buildChartData();
        }

    }

    public String getCurrentMonth() {
        AggregateResult[] currentMonth = [Select Max(Current_Month__c) maxMonth From COPE_Data__c];
        String retval = (string)currentMonth[0].get('maxMonth');
        return retval;
    }

    private List<COPE_NewIncData__c> buildbyDivEmpNewPayersList() {
        return newPayersList;
    }

    private List<COPE_NewIncData__c> buildbyDivEmpIncPayersList() {
        return incPayersList;
    }

    private List<COPE_data__c> buildbyDivEmpList() {

        COPE_NewIncData__c newPayer;
        COPE_NewIncData__c incPayer;

        Integer listLen;
        Integer outputRowPtr;
        Integer divisionCount;
        Integer newPayerDivisionCount;
        Integer incPayerDivisionCount;
        Integer employerCount;
        Integer newPayerEmployerCount;
        Integer incPayerEmployerCount;
        Integer newPayerPtr;
        Integer incPayerPtr;
        Integer newPayerCount;
        Integer incPayerCount;

        String division;
        String lastNewPayerDivision;
        String lastIncPayerDivision;
        String currentRowDivision;
        String employer;
        String currentRowEmployer;
        String lastNewPayerEmployer;
        String lastIncPayerEmployer;
        String savedId;
        String newPayerSavedId;
        String incPayerSavedId;

        Integer i;

        copeData = [Select Division__c,CommitteeMbrName__c,EboardNames__c,Employer__c,SeatID__c,
            NewCOPECount__c,NewCOPETotal__c, COPEIncreaseCountPerSeat__c,COPEIncreaseTotalPerSeat__c,
            COPETotalPerSeat__c,COPETotalPerSeat_3__c,COPETotalPerSeat_6__c,COPETotalPerSeat_9__c,COPETotalPerSeat_12__c,
            COPECountPerSeat__c,COPECountPerSeat_3__c,COPECountPerSeat_6__c,COPECountPerSeat_9__c,COPECountPerSeat_12__c,
            COPECountTenPlusPerSeat__c,COPECountTenPlusPerSeat_3__c,COPECountTenPlusPerSeat_6__c,COPECountTenPlusPerSeat_9__c,COPECountTenPlusPerSeat_12__c,
            COPEPercent__c, COPEPercentTen__c, EmpCountPerSeat__c, EmpCountPerSeat_3__c, EmpCountPerSeat_6__c, EmpCountPerSeat_9__c, EmpCountPerSeat_12__c,Table_Row_Id__c,OutputColumn1__c,UWG__c
            From COPE_Data__c
            Order By Division__c,Employer__c];

        buildList               = New List<COPE_data__c>();
        listLen                 = copeData.size();
        rowPtr                  = 0;
        outputRowPtr            = 0;
        newPayerPtr             = 0;
        incPayerPtr             = 0;
        divisionCount           = 0;
        employerCount           = 0;
        lastNewPayerDivision    = '';
        newPayerDivisionCount   = 0;
        incPayerDivisionCount   = 0;
        newPayerEmployerCount   = 0;
        incPayerEmployerCount   = 0;

        resetDivisionVars();

        // For testing:
        this.arg = ApexPages.currentPage().getParameters().get('arg');
        if(this.arg != null)
            listLen = Integer.valueOf(this.arg);

        divisionPtr = 0;
        while (rowPtr < listLen) {
            newPayerCount         = 0;
            incPayerCount         = 0;
            division              = copeData[rowPtr].Division__c;
            currentRowDivision    = copeData[rowPtr].Division__c;
            divisionCount++;

            newItem                  = new COPE_data__c();
            newItem.Cell1Class__c    = 'division';
            newItem.OutputColumn1__c =  division;
            newItem.Table_Row_Id__c  = String.valueOf(divisionCount);
            //
            // Add Division
            //
            buildList.add(newItem);
            divisionPtr = buildList.size() - 1;
            resetDivisionVars();
            employerCount = 1;
            while (division == currentRowDivision && rowPtr < listLen) {
                employerCount++;
                //
                // Add Employer
                //
                employer = copeData[rowPtr].Employer__c;
                newItem  = new COPE_data__c();
                setNewItem();
                newItem.Cell1Class__c   = 'employer';
                newItem.OutputColumn1__c = employer;
                newItem.Table_Row_Id__c  =
                    String.valueOf(divisionCount) + '-' +
                    String.valueOf(employerCount) +
                    'data-tt-parent-id=' + String.valueOf(divisionCount);
                buildList.add(newItem);
                incDivisionVars();

                savedId = String.valueOf(divisionCount);
                if(copeData[rowPtr].NewCOPETotal__c > 0) {
                    if (String.isEmpty(lastNewPayerDivision) ||  lastNewPayerDivision <> currentRowDivision) {
                        //
                        // Add NewPayer Division
                        //
                        lastNewPayerDivision = division;
                        newPayerDivisionCount++;
                        newPayerEmployerCount      = 0;
                        newPayer                   = new COPE_NewIncData__c();
                        newPayer.Cell1Class__c     = 'division';
                        newPayer.OutputColumn1__c  = lastNewPayerDivision;
                        newPayer.Table_Row_Id__c   = String.valueOf(newPayerDivisionCount);
                        newPayersList.add(newPayer);
                    }

                    //
                    // Add newPayer Employer
                    //
                    newPayerEmployerCount++;
                    newPayer                  = new COPE_NewIncData__c();
                    newPayer.Cell1Class__c    = 'employer';
                    newPayer.OutputColumn1__c = copeData[rowPtr].Employer__c;
                    newPayer.SeatID__c        = copeData[rowPtr].SeatID__c;
                    newPayer.NewCOPECount__c  = copeData[rowPtr].NewCOPECount__c;
                    newPayer.NewCOPETotal__c  = copeData[rowPtr].NewCOPETotal__c;
                    newPayer.Table_Row_Id__c  =
                        String.valueOf(newPayerDivisionCount)     + '-' +
                        String.valueOf(newPayerEmployerCount)     +
                        'data-tt-parent-id=' + String.valueOf(newPayerDivisionCount);
                    newPayersList.add(newPayer);
                    newPayerPtr = newPayersList.size()-1;
                }

                if(copeData[rowPtr].COPEIncreaseCountPerSeat__c > 0) {
                    if (String.isEmpty(lastIncPayerDivision) ||  lastIncPayerDivision <> currentRowDivision) {
                        //
                        // Add IncPayer Division
                        //
                        lastIncPayerDivision = division;
                        incPayerDivisionCount++;
                        incPayerEmployerCount      = 0;
                        incPayer                   = new COPE_NewIncData__c();
                        incPayer.Cell1Class__c     = 'division';
                        incPayer.OutputColumn1__c  = lastIncPayerDivision;
                        incPayer.Table_Row_Id__c   = String.valueOf(incPayerDivisionCount);
                        incPayersList.add(incPayer);
                    }

                    //
                    // Add IncPayer Employer
                    //
                    incPayerEmployerCount++;
                    incPayer                  = new COPE_NewIncData__c();
                    incPayer.Cell1Class__c    = 'employer';
                    incPayer.OutputColumn1__c = copeData[rowPtr].Employer__c;
                    incPayer.SeatID__c        = copeData[rowPtr].SeatID__c;
                    incPayer.COPE_Increased_Count__c = copeData[rowPtr].COPEIncreaseCountPerSeat__c;
                    incPayer.COPE_Increased_Total__c = copeData[rowPtr].COPEIncreaseTotalPerSeat__c;

                    incPayer.Table_Row_Id__c  =
                        String.valueOf(incPayerDivisionCount)     + '-' +
                        String.valueOf(incPayerEmployerCount)     +
                        'data-tt-parent-id=' + String.valueOf(incPayerDivisionCount);
                    incPayersList.add(incPayer);
                    incPayerPtr = incPayersList.size()-1;
                }

                rowPtr++;
                outputRowPtr++;
                if(rowPtr < ListLen)
                    currentRowDivision = copeData[rowPtr].Division__c;
            }
            setDivisionTotal();
        }
        return buildList;
    }

    public List<COPE_data__c> getbyDivEmp() {
        return byDivEmp;
    }
    public List<COPE_NewIncData__c> getNewPayers() {
        return byNewPayers;
    }

    public List<COPE_NewIncData__c> getIncPayers() {
        return byIncPayers;
    }

    private void resetDivisionVars() {
        divisionNewCOPECount = divisionNewCOPETotal = divisionCOPEIncreaseCountPerSeat = divisionCOPEIncreaseTotalPerSeat = 0;
        divisionCOPETotalPerSeat    = divisionCOPECountPerSeat    = divisionCOPECountTenPlusPerSeat    = divisionEmpCountPerSeat    = 0;
        divisionCOPETotalPerSeat_3  = divisionCOPECountPerSeat_3  = divisionCOPECountTenPlusPerSeat_3  = divisionEmpCountPerSeat_3  = 0;
        divisionCOPETotalPerSeat_6  = divisionCOPECountPerSeat_6  = divisionCOPECountTenPlusPerSeat_6  = divisionEmpCountPerSeat_6  = 0;
        divisionCOPETotalPerSeat_9  = divisionCOPECountPerSeat_9  = divisionCOPECountTenPlusPerSeat_9  = divisionEmpCountPerSeat_9  = 0;
        divisionCOPETotalPerSeat_12 = divisionCOPECountPerSeat_12 = divisionCOPECountTenPlusPerSeat_12 = divisionEmpCountPerSeat_12 = 0;
        divisionCOPEPercent = divisionCOPEPercentTen = divisionCOPEIncreaseTotalPerSeat = divisionCOPEIncreaseCountPerSeat = 0;
    }

    private void incDivisionVars() {
        divisionNewCOPETotal               += copeData[rowPtr].NewCOPETotal__c;
        divisionNewCOPECount               += copeData[rowPtr].NewCOPECount__c;
        divisionCOPEIncreaseTotalPerSeat   += copeData[rowPtr].COPEIncreaseTotalPerSeat__c;
        divisionCOPEIncreaseCountPerSeat   += copeData[rowPtr].COPEIncreaseCountPerSeat__c;

        divisionCOPETotalPerSeat           += copeData[rowPtr].COPETotalPerSeat__c;
        divisionCOPECountPerSeat           += copeData[rowPtr].COPECountPerSeat__c;
        divisionCOPECountTenPlusPerSeat    += copeData[rowPtr].COPECountTenPlusPerSeat__c;
        divisionEmpCountPerSeat            += copeData[rowPtr].EmpCountPerSeat__c;

        divisionCOPETotalPerSeat_3         += copeData[rowPtr].COPETotalPerSeat_3__c;
        divisionCOPECountPerSeat_3         += copeData[rowPtr].COPECountPerSeat_3__c;
        divisionCOPECountTenPlusPerSeat_3  += copeData[rowPtr].COPECountTenPlusPerSeat_3__c;
        divisionEmpCountPerSeat_3          += copeData[rowPtr].EmpCountPerSeat_3__c;

        divisionCOPETotalPerSeat_6         += copeData[rowPtr].COPETotalPerSeat_6__c;
        divisionCOPECountPerSeat_6         += copeData[rowPtr].COPECountPerSeat_6__c;
        divisionCOPECountTenPlusPerSeat_6  += copeData[rowPtr].COPECountTenPlusPerSeat_6__c;
        divisionEmpCountPerSeat_6          += copeData[rowPtr].EmpCountPerSeat_6__c;

        divisionCOPETotalPerSeat_9         += copeData[rowPtr].COPETotalPerSeat_9__c;
        divisionCOPECountPerSeat_9         += copeData[rowPtr].COPECountPerSeat_9__c;
        divisionCOPECountTenPlusPerSeat_9  += copeData[rowPtr].COPECountTenPlusPerSeat_9__c;
        divisionEmpCountPerSeat_9          += copeData[rowPtr].EmpCountPerSeat_9__c;

        divisionCOPETotalPerSeat_12        += copeData[rowPtr].COPETotalPerSeat_12__c;
        divisionCOPECountPerSeat_12        += copeData[rowPtr].COPECountPerSeat_12__c;
        divisionCOPECountTenPlusPerSeat_12 += copeData[rowPtr].COPECountTenPlusPerSeat_12__c;
        divisionEmpCountPerSeat_12         += copeData[rowPtr].EmpCountPerSeat_12__c;
    }

    private void setNewItem() {
        newItem.Division__c                   = copeData[rowPtr].Division__c;
        newItem.Employer__c                   = copeData[rowPtr].Employer__c;
        newItem.SeatID__c                     = copeData[rowPtr].SeatID__c;

        newItem.COPEPercent__c                = copeData[rowPtr].COPEPercent__c;
        newItem.COPEPercentTen__c             = copeData[rowPtr].COPEPercentTen__c;

        newItem.NewCOPETotal__c               = copeData[rowPtr].NewCOPETotal__c;
        newItem.NewCOPECount__c               = copeData[rowPtr].NewCOPECount__c;
        newItem.COPEIncreaseTotalPerSeat__c   = copeData[rowPtr].COPEIncreaseTotalPerSeat__c;
        newItem.COPEIncreaseCountPerSeat__c   = copeData[rowPtr].COPEIncreaseCountPerSeat__c;

        newItem.COPETotalPerSeat__c           = copeData[rowPtr].COPETotalPerSeat__c;
        newItem.COPECountPerSeat__c           = copeData[rowPtr].COPECountPerSeat__c;
        newItem.COPECountTenPlusPerSeat__c    = copeData[rowPtr].COPECountTenPlusPerSeat__c;
        newItem.EmpCountPerSeat__c            = copeData[rowPtr].EmpCountPerSeat__c;

        newItem.COPETotalPerSeat_3__c         = copeData[rowPtr].COPETotalPerSeat_3__c;
        newItem.COPECountPerSeat_3__c         = copeData[rowPtr].COPECountPerSeat_3__c;
        newItem.COPECountTenPlusPerSeat_3__c  = copeData[rowPtr].COPECountTenPlusPerSeat_3__c;
        newItem.EmpCountPerSeat_3__c          = copeData[rowPtr].EmpCountPerSeat_3__c;

        newItem.COPETotalPerSeat_6__c         = copeData[rowPtr].COPETotalPerSeat_6__c;
        newItem.COPECountPerSeat_6__c         = copeData[rowPtr].COPECountPerSeat_6__c;
        newItem.COPECountTenPlusPerSeat_6__c  = copeData[rowPtr].COPECountTenPlusPerSeat_6__c;
        newItem.EmpCountPerSeat_6__c          = copeData[rowPtr].EmpCountPerSeat_6__c;

        newItem.COPETotalPerSeat_9__c         = copeData[rowPtr].COPETotalPerSeat_9__c;
        newItem.COPECountPerSeat_9__c         = copeData[rowPtr].COPECountPerSeat_9__c;
        newItem.COPECountTenPlusPerSeat_9__c  = copeData[rowPtr].COPECountTenPlusPerSeat_9__c;
        newItem.EmpCountPerSeat_9__c          = copeData[rowPtr].EmpCountPerSeat_9__c;

        newItem.COPETotalPerSeat_12__c        = copeData[rowPtr].COPETotalPerSeat_12__c;
        newItem.COPECountPerSeat_12__c        = copeData[rowPtr].COPECountPerSeat_12__c;
        newItem.COPECountTenPlusPerSeat_12__c = copeData[rowPtr].COPECountTenPlusPerSeat_12__c;
        newItem.EmpCountPerSeat_12__c         = copeData[rowPtr].EmpCountPerSeat_12__c;

        newItem.UWG__c = copeData[rowPtr].UWG__c;
    }

    private void setDivisionTotal() {
        buildList[divisionPtr].COPETotalPerSeat__c        = divisionCOPETotalPerSeat;
        buildList[divisionPtr].COPECountPerSeat__c        = divisionCOPECountPerSeat;
        buildList[divisionPtr].COPECountTenPlusPerSeat__c = divisionCOPECountTenPlusPerSeat;
        buildList[divisionPtr].EmpCountPerSeat__c         = divisionEmpCountPerSeat;

        buildList[divisionPtr].UWG__c = 0.0;

        If (divisionCOPECountPerSeat > 0 && divisionEmpCountPerSeat > 0) {
            buildList[divisionPtr].COPEPercent__c               = (divisionCOPECountPerSeat        / divisionEmpCountPerSeat) * 100 ;
            buildList[divisionPtr].UWG__c = divisionCOPETotalPerSeat / ((divisionEmpCountPerSeat * 0.33) * 10) *100;
        }

        If (divisionCOPECountTenPlusPerSeat  > 0 && divisionEmpCountPerSeat > 0)
        buildList[divisionPtr].COPEPercentTen__c            = (divisionCOPECountTenPlusPerSeat / divisionEmpCountPerSeat)  * 100 ;

        buildList[divisionPtr].NewCOPETotal__c              = divisionNewCOPETotal;
        buildList[divisionPtr].NewCOPECount__c              = divisionNewCOPECount;
        buildList[divisionPtr].COPEIncreaseTotalPerSeat__c  = divisionCOPEIncreaseTotalPerSeat;
        buildList[divisionPtr].COPEIncreaseCountPerSeat__c  = divisionCOPEIncreaseCountPerSeat;

        /*
         newPayersList[newPayerPtr].NewCOPETotal__c           = divisionNewCOPETotal;
         newPayersList[newPayerPtr].NewCOPECount__c           = divisionNewCOPECount;

         incPayersList[incPayerPtr].Division__c               = division + ' (' + String.valueOf(incPayerCount) + ')';

         incPayersList[incPayerPtr].COPE_Increased_Total__c   = divisionCOPEIncreaseTotalPerSeat;
         incPayersList[incPayerPtr].COPE_Increased_Count__c   = divisionCOPEIncreaseCountPerSeat;
         */

        buildList[divisionPtr].COPETotalPerSeat_3__c        = divisionCOPETotalPerSeat_3;
        buildList[divisionPtr].COPECountPerSeat_3__c        = divisionCOPECountPerSeat_3;

        buildList[divisionPtr].COPETotalPerSeat_6__c        = divisionCOPETotalPerSeat_6;
        buildList[divisionPtr].COPECountPerSeat_6__c        = divisionCOPECountPerSeat_6;

        buildList[divisionPtr].COPETotalPerSeat_9__c        = divisionCOPETotalPerSeat_9;
        buildList[divisionPtr].COPECountPerSeat_9__c        = divisionCOPECountPerSeat_9;

        buildList[divisionPtr].COPETotalPerSeat_12__c        = divisionCOPETotalPerSeat_12;
        buildList[divisionPtr].COPECountPerSeat_12__c        = divisionCOPECountPerSeat_12;
    }

    private List<chartData> buildChartData() {
        List<chartData> data = new List<chartData>();
        List<AggregateResult> copeData;

        String division;
        Decimal currentTotal;
        Decimal Total3;
        Decimal Total6;
        Decimal Total9;
        Decimal Total12;

        copeData = [Select Division__c Division, Count(Employer__c) EmpCount, Sum(COPETotalPerSeat__C) CurrentTotal, Sum(COPETotalPerSeat_3__c) Total3 , Sum(COPETotalPerSeat_6__c) Total6, Sum(COPETotalPerSeat_9__c) Total9, Sum(COPETotalPerSeat_12__c) Total12 From COPE_Data__c Group By Division__c];
        for (AggregateResult result : copeData) {

            division     = (String) result.get('Division');
            currentTotal = (Decimal) result.get('CurrentTotal');
            total3       = (Decimal) result.get('Total3');
            total6       = (Decimal) result.get('Total6');
            total9       = (Decimal) result.get('Total9');
            total12      = (Decimal) result.get('Total12');

            data.add(new chartData(division, currentTotal, total3,total6,total9,total12));
        }

        return data;
    }

    public List<chartData> getChartData() {
        return chartData;
    }

    // Wrapper class
    public class chartData {

    public String  division     { get; set; }
public Decimal currentTotal { get; set; }
public Decimal total3       { get; set; }
public Decimal total6       { get; set; }
public Decimal total9       { get; set; }
public Decimal total12      { get; set; }

public chartData(String Division, Decimal CurrentTotal, Decimal Total3,Decimal Total6,Decimal Total9,Decimal Total12) {
    this.division     = Division;
    this.currentTotal = CurrentTotal;
    this.total3       = Total3;
    this.total6       = Total6;
    this.total9       = Total9;
    this.total12      = Total12;
}
}

}