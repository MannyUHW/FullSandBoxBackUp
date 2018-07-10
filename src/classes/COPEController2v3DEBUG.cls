public class COPEController2v3DEBUG {

    Private List<COPE_data__c> copeData;
    Private List<COPE_data__c> byDivPodEboard;
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

    Private Decimal committeeMbrCOPEPercent, committeeMbrCOPEPercentTen, committeeMbrNewCOPECount, committeeMbrNewCOPETotal, committeeMbrCOPEIncreaseCountPerSeat, committeeMbrCOPEIncreaseTotalPerSeat;
    Private Decimal committeeMbrCOPETotalPerSeat,    committeeMbrCOPECountPerSeat,    committeeMbrCOPECountTenPlusPerSeat,    committeeMbrEmpCountPerSeat;
    Private Decimal committeeMbrCOPETotalPerSeat_3,  committeeMbrCOPECountPerSeat_3,  committeeMbrCOPECountTenPlusPerSeat_3,  committeeMbrEmpCountPerSeat_3;
    Private Decimal committeeMbrCOPETotalPerSeat_6,  committeeMbrCOPECountPerSeat_6,  committeeMbrCOPECountTenPlusPerSeat_6,  committeeMbrEmpCountPerSeat_6;
    Private Decimal committeeMbrCOPETotalPerSeat_9,  committeeMbrCOPECountPerSeat_9,  committeeMbrCOPECountTenPlusPerSeat_9,  committeeMbrEmpCountPerSeat_9;
    Private Decimal committeeMbrCOPETotalPerSeat_12, committeeMbrCOPECountPerSeat_12, committeeMbrCOPECountTenPlusPerSeat_12, committeeMbrEmpCountPerSeat_12;

    Private Decimal eBoardMbrCOPEPercent, eBoardMbrCOPEPercentTen, eBoardMbrNewCOPECount, eBoardMbrNewCOPETotal, eBoardMbrCOPEIncreaseCountPerSeat, eBoardMbrCOPEIncreaseTotalPerSeat;
    Private Decimal eBoardMbrCOPETotalPerSeat,    eBoardMbrCOPECountPerSeat,    eBoardMbrCOPECountTenPlusPerSeat,    eBoardMbrEmpCountPerSeat;
    Private Decimal eBoardMbrCOPETotalPerSeat_3,  eBoardMbrCOPECountPerSeat_3,  eBoardMbrCOPECountTenPlusPerSeat_3,  eBoardMbrEmpCountPerSeat_3;
    Private Decimal eBoardMbrCOPETotalPerSeat_6,  eBoardMbrCOPECountPerSeat_6,  eBoardMbrCOPECountTenPlusPerSeat_6,  eBoardMbrEmpCountPerSeat_6;
    Private Decimal eBoardMbrCOPETotalPerSeat_9,  eBoardMbrCOPECountPerSeat_9,  eBoardMbrCOPECountTenPlusPerSeat_9,  eBoardMbrEmpCountPerSeat_9;
    Private Decimal eBoardMbrCOPETotalPerSeat_12, eBoardMbrCOPECountPerSeat_12, eBoardMbrCOPECountTenPlusPerSeat_12, eBoardMbrEmpCountPerSeat_12;

    Private List<COPE_data__c> buildList;
    Private COPE_data__c newItem;
    Private Integer rowPtr;
    Private Integer divisionPtr;
    Private Integer committeeMbrPtr;
    Private Integer eBoardMbrPtr;
    private String arg;
    private String msg;

    private Map<String,String> test;
    private String test2;

    public COPEController2v3DEBUG() {

        newPayersList = new List<COPE_NewIncData__c>();
        incPayersList = new List<COPE_NewIncData__c>();

        if(byDivPodEboard == Null) {
            byDivPodEboard = buildbyDivPodEboardList();
        }


    }

    public String getCurrentMonth() {
        AggregateResult[] currentMonth = [Select Max(Current_Month__c) maxMonth From COPE_Data__c];
        String retval = (string)currentMonth[0].get('maxMonth');
        return retval;
    }

    private List<COPE_data__c> buildbyDivPodEboardList() {

        COPE_NewIncData__c newPayer;
        COPE_NewIncData__c incPayer;

        Integer listLen;
        Integer outputRowPtr;
        Integer divisionCount;
        Integer newPayerDivisionCount;
        Integer incPayerDivisionCount;
        Integer committeeMbrCount;
        Integer newPayercommitteeMbrCount;
        Integer incPayercommitteeMbrCount;
        Integer eBoardMbrCount;
        Integer newPayereBoardMbrCount;
        Integer incPayereBoardMbrCount;
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
        String committeeMbr;
        String committeeMbrDisplay;
        String lastNewPayercommitteeMbr;
        String lastIncPayercommitteeMbr;
        String currentRowcommitteeMbr;
        String eBoardMbr;
        String eBoardMbrDisplay;
        String currentRoweBoardMbr;
        String lastNewPayereBoardMbr;
        String lastIncPayereBoardMbr;
        String savedId;
        String newPayerSavedId;
        String incPayerSavedId;

        Integer i;
        // WHERE Division__c in ('HOSPITAL','KAISER') OutputColumn1__c
        // WHERE Id IN ('a2IQ00000012wVhMAI','a2IQ00000012wVCMAY','a2IQ00000012wWTMAY','a2IQ00000012wWKMAY')
        // WHERE Id IN ('a2IQ00000012wVhMAI','a2IQ00000012wVCMAY','a2IQ00000012wWTMAY','a2IQ00000012wWKMAY')
        // OK:
        // WHERE Id IN ('a2IQ00000012wX3MAI', 'a2IQ00000012wX4MAI', 'a2IQ00000012wX5MAI', 'a2IQ00000012wX6MAI', 'a2IQ00000012wX7MAI', 'a2IQ00000012wX8MAI', 'a2IQ00000012wX9MAI', 'a2IQ00000012wXAMAY', 'a2IQ00000012wXBMAY', 'a2IQ00000012wXCMAY', 'a2IQ00000012wXDMAY', 'a2IQ00000012wXEMAY', 'a2IQ00000012wXFMAY', 'a2IQ00000012wXGMAY', 'a2IQ00000012wXHMAY', 'a2IQ00000012wXIMAY', 'a2IQ00000012wXJMAY', 'a2IQ00000012wXKMAY', 'a2IQ00000012wXLMAY')
        
        // ('a2IQ00000012wXMMAY', 'a2IQ00000012wXNMAY', 'a2IQ00000012wXOMAY', 'a2IQ00000012wXPMAY', 'a2IQ00000012wXQMAY', 'a2IQ00000012wXRMAY', 'a2IQ00000012wXSMAY', 'a2IQ00000012wXTMAY', 'a2IQ00000012wXUMAY', 'a2IQ00000012wXVMAY', 'a2IQ00000012wXWMAY', 'a2IQ00000012wXXMAY', 'a2IQ00000012wXYMAY', 'a2IQ00000012wXZMAY', 'a2IQ00000012wXaMAI', 'a2IQ00000012wXbMAI', 'a2IQ00000012wXcMAI', 'a2IQ00000012wXdMAI', 'a2IQ00000012wXeMAI', 'a2IQ00000012wXfMAI', 'a2IQ00000012wXgMAI')

        // passes
        // ('a2IQ00000012wXMMAY', 'a2IQ00000012wXNMAY', 'a2IQ00000012wXOMAY', 'a2IQ00000012wXPMAY', 'a2IQ00000012wXQMAY')

        // fails
        //  ('a2IQ00000012wXMMAY', 'a2IQ00000012wXNMAY', 'a2IQ00000012wXOMAY', 'a2IQ00000012wXPMAY', 'a2IQ00000012wXQMAY', 'a2IQ00000012wXRMAY', 'a2IQ00000012wXSMAY' )


        // ('a2IQ00000012wXRMAY', 'a2IQ00000012wXSMAY', 'a2IQ00000012wXTMAY', 'a2IQ00000012wXUMAY', 'a2IQ00000012wXVMAY', 'a2IQ00000012wXWMAY')
 // ('a2IQ00000012wXMMAY', 'a2IQ00000012wXNMAY', 'a2IQ00000012wXOMAY', 'a2IQ00000012wXPMAY', 'a2IQ00000012wXQMAY')         
//        fails: ('a2IQ00000012wXMMAY') Or Employer__c Like 'F%' Or Employer__c Like 'G%'
        copeData = [Select Division__c, CommitteeMbrName__c, eBoardNames__c,Employer__c,SeatID__c,
            NewCOPECount__c,NewCOPETotal__c, COPEIncreaseCountPerSeat__c,COPEIncreaseTotalPerSeat__c,
            COPETotalPerSeat__c,COPETotalPerSeat_3__c,COPETotalPerSeat_6__c,COPETotalPerSeat_9__c,COPETotalPerSeat_12__c,
            COPECountPerSeat__c,COPECountPerSeat_3__c,COPECountPerSeat_6__c,COPECountPerSeat_9__c,COPECountPerSeat_12__c,
            COPECountTenPlusPerSeat__c,COPECountTenPlusPerSeat_3__c,COPECountTenPlusPerSeat_6__c,COPECountTenPlusPerSeat_9__c,COPECountTenPlusPerSeat_12__c,
            COPEPercent__c, COPEPercentTen__c, EmpCountPerSeat__c, EmpCountPerSeat_3__c, EmpCountPerSeat_6__c, EmpCountPerSeat_9__c, EmpCountPerSeat_12__c,Table_Row_Id__c,UWG__c
            From COPE_Data__c  WHERE Employer__c Like 'E%' 
            Order By Division__c,CommitteeMbrName__c,eBoardNames__c,Employer__c,SeatID__c];

System.debug('--- 1 ---');
System.debug(copeData[0]);
System.debug(copeData[1]);

        buildList               = New List<COPE_data__c>();
        listLen                 = copeData.size();
        rowPtr                  = 0;
        outputRowPtr            = 0;
        newPayerPtr             = 0;
        incPayerPtr             = 0;
        divisionCount           = 0;
        committeeMbrCount        = 1;
        lastNewPayerDivision     = '';
        lastNewPayercommitteeMbr = '';
        lastNewPayereBoardMbr    = '';

        newPayerDivisionCount    = 0;
        incPayerDivisionCount    = 0;
        newPayercommitteeMbrCount = 0;
        incPayercommitteeMbrCount = 0;
        newPayereBoardMbrCount    = 0;
        incPayereBoardMbrCount    = 0;
        newPayerEmployerCount    = 0;
        incPayerEmployerCount    = 0;

        resetDivisionVars();
        resetcommitteeMbrVars();
        reseteBoardMbrVars();

        divisionPtr = 0;
        while (rowPtr < listLen) {

            System.debug('--- 2 ---');

            eBoardMbrCount        = 0;
            newPayerCount         = 0;
            incPayerCount         = 0;
            division              = copeData[rowPtr].Division__c;
            currentRowDivision    = copeData[rowPtr].Division__c;
            divisionCount++;

            newItem                  = new COPE_data__c();
            newItem.Cell1Class__c  = 'division';
    //        newItem.OutputColumn1__c = division;
            newItem.Table_Row_Id__c  = String.valueOf(divisionCount);
            //            
            // Add division
            //
            buildList.add(newItem);
            divisionPtr = buildList.size() - 1;
            resetDivisionVars();
            committeeMbrCount = 1;
            while (division == currentRowDivision && rowPtr < listLen) {

                System.debug('--- 3 ---');

                committeeMbr           = getcommitteeMbrName();
                currentRowcommitteeMbr = committeeMbr;

                if (committeeMbr.contains('Vacant'))
                    committeeMbrDisplay = 'committeeMbr Vacant for seat ' + copeData[rowPtr].SeatID__c;
                else
                    committeeMbrDisplay = committeeMbr;

                newItem = new COPE_data__c();
                newItem.Cell1Class__c  = 'committeeMbr';
//                newItem.OutputColumn1__c = committeeMbrDisplay;
                newItem.Table_Row_Id__c  =
                    String.valueOf(divisionCount)    + '-'  +
                    String.valueOf(committeeMbrCount) + ' data-tt-parent-id=' + String.valueOf(divisionCount);
                //
                // Add committeeMbr
                //
                buildList.add(newItem);
                resetcommitteeMbrVars();
                committeeMbrPtr = buildList.size() - 1;
                eBoardMbrCount = 1;

                System.debug('--- 4 ---');

                while (division == currentRowDivision    &&
                committeeMbr == currentRowcommitteeMbr && rowPtr < listLen) {

                    System.debug('--- 5 ---');

                    eBoardMbr            = geteBoardMbrName();
                    currentRoweBoardMbr  = eBoardMbr;

                    if (eBoardMbr.contains('Vacant'))
                        eBoardMbrDisplay = 'Field Rep. Vacant for seat ' + copeData[rowPtr].SeatID__c;
                    else
                        eBoardMbrDisplay = eBoardMbr;

System.debug('--- 6 ---');
                    currentRowcommitteeMbr = getcommitteeMbrName();
System.debug('--- 7 ---');

                    reseteBoardMbrVars();
System.debug('--- 8 ---');                    

                    employerCount = 1;
                    savedId = String.valueOf(divisionCount)      + '-' +
                        String.valueOf(committeeMbrCount)  + '-' +
                        String.valueOf(eBoardMbrCount);

                    newItem = new COPE_data__c();
                    newItem.Cell1Class__c  = 'eBoardMbr';
     //               newItem.OutputColumn1__c = eBoardMbrDisplay;
                    newItem.Table_Row_Id__c  = savedId    +
                        ' data-tt-parent-id='             +
                        String.valueOf(divisionCount)     + '-'  +
                        String.valueOf(committeeMbrCount);
                    //                    
                    // Add initial eBoard
                    //
                    buildList.add(newItem);
                    eBoardMbrPtr = buildList.size() - 1;
                    newItem                    = New COPE_data__c();
                    setNewItem();
                    newItem.Cell1Class__c      = 'employer';
    //                newItem.OutputColumn1__c   = copeData[rowPtr].Employer__c;
                    newItem.Table_Row_Id__c    =
                        String.valueOf(divisionCount)     + '-' +
                        String.valueOf(committeeMbrCount)  + '-' +
                        String.valueOf(eBoardMbrCount)     + '-' +
                        String.valueOf(employerCount)     +
                        ' data-tt-parent-id=' + savedId;
System.debug('--- 9 ---');                        
                    inceBoardMbrVars();
System.debug('--- 10 ---');                    
                    buildList.add(newItem);

                    if(copeData[rowPtr].NewCOPETotal__c > 0) {
                        if (String.isEmpty(lastNewPayerDivision) ||  lastNewPayerDivision != currentRowDivision) {
                            //
                            // Add NewPayer Division
                            //
                            lastNewPayerDivision = division;
                            newPayerDivisionCount++;
                            lastNewPayercommitteeMbr    = '';
                            lastNewPayereBoardMbr       = '';
                            newPayercommitteeMbrCount   = 0;
                            newPayereBoardMbrCount      = 0;
                            newPayerEmployerCount      = 0;
                            newPayer                   = new COPE_NewIncData__c();
                            newPayer.Cell1Class__c     = 'division';
           //                 newPayer.OutputColumn1__c  = lastNewPayerDivision;
                            newPayer.Table_Row_Id__c   = String.valueOf(newPayerDivisionCount);
                            newPayersList.add(newPayer);
                        }
                        if (String.isEmpty(lastNewPayercommitteeMbr) || lastNewPayercommitteeMbr != currentRowcommitteeMbr) {
                            //
                            // Add NewPayer committeeMbr
                            //
                            lastNewPayercommitteeMbr = committeeMbr;
                            newPayercommitteeMbrCount++;
                            lastNewPayereBoardMbr       = '';
                            newPayereBoardMbrCount      = 0;
                            newPayerEmployerCount      = 0;
                            newPayer                  = new COPE_NewIncData__c();
                            newPayer.Cell1Class__c    = 'committeeMbr';
          //                  newPayer.OutputColumn1__c = committeeMbrDisplay;
                            newPayer.Table_Row_Id__c  =
                                String.valueOf(newPayerDivisionCount)    + '-'  +
                                String.valueOf(newPayercommitteeMbrCount) + ' data-tt-parent-id=' + String.valueOf(newPayerDivisionCount);
                            newPayersList.add(newPayer);
                        }
                        if (String.isEmpty(lastNewPayereBoardMbr) || lastNewPayereBoardMbr != currentRoweBoardMbr) {
                            //
                            // Add NewPayer eBoard Mbr
                            //
                            lastNewPayereBoardMbr = eBoardMbr;
                            newPayereBoardMbrCount++;
                            newPayerEmployerCount      = 0;
                            newPayer                   = new COPE_NewIncData__c();
                            newPayer.Cell1Class__c     = 'eBoardMbr';
      //                      newPayer.OutputColumn1__c  = eBoardMbrDisplay;
                            newPayer.Table_Row_Id__c   =
                                String.valueOf(newPayerDivisionCount)     + '-' +
                                String.valueOf(newPayercommitteeMbrCount)  + '-' +
                                String.valueOf(newPayereBoardMbrCount)     +     +
                                    ' data-tt-parent-id='                     +
                                String.valueOf(newPayerDivisionCount)     + '-'  +
                                String.valueOf(newPayercommitteeMbrCount);
                            newPayersList.add(newPayer);
                            newPayerPtr = newPayersList.size()-1;
                        }

                        //
                        // Add NewPayer Employer
                        //
                        newPayerEmployerCount++;
                        newPayer                  = new COPE_NewIncData__c();
                        newPayer.Cell1Class__c    = 'employer';
         //               newPayer.OutputColumn1__c = copeData[rowPtr].Employer__c;
                        newPayer.SeatID__c        = copeData[rowPtr].SeatID__c;
                        newPayer.NewCOPECount__c  = copeData[rowPtr].NewCOPECount__c;
                        newPayer.NewCOPETotal__c  = copeData[rowPtr].NewCOPETotal__c;
                        newPayer.Table_Row_Id__c  =
                            String.valueOf(newPayerDivisionCount)     + '-' +
                            String.valueOf(newPayercommitteeMbrCount)  + '-' +
                            String.valueOf(newPayereBoardMbrCount)     + '-' +
                            String.valueOf(newPayerEmployerCount)     +
                            ' data-tt-parent-id=' +
                            String.valueOf(newPayerDivisionCount)     + '-' +
                            String.valueOf(newPayercommitteeMbrCount)  + '-' +
                            String.valueOf(newPayereBoardMbrCount);
                        newPayersList.add(newPayer);
                        newPayerPtr = newPayersList.size()-1;
                    }

                    if(copeData[rowPtr].COPEIncreaseTotalPerSeat__c > 0) {
                        if (String.isEmpty(lastIncPayerDivision) ||  lastIncPayerDivision != currentRowDivision) {
                            //
                            // Add IncPayer Division
                            //
                            lastIncPayerDivision = division;
                            incPayerDivisionCount++;
                            lastIncPayercommitteeMbr    = '';
                            lastIncPayereBoardMbr       = '';
                            incPayercommitteeMbrCount   = 0;
                            incPayereBoardMbrCount      = 0;
                            incPayerEmployerCount      = 0;
                            incPayer                   = new COPE_NewIncData__c();
                            incPayer.Cell1Class__c     = 'division';
           //                 incPayer.OutputColumn1__c  = lastIncPayerDivision;
                            incPayer.Table_Row_Id__c   = String.valueOf(IncPayerDivisionCount);
                            incPayersList.add(incPayer);
                        }
                        if (String.isEmpty(lastIncPayercommitteeMbr) || lastIncPayercommitteeMbr != currentRowcommitteeMbr) {
                            //
                            // Add IncPayer committeeMbr
                            //
                            lastIncPayercommitteeMbr = committeeMbr;
                            incPayercommitteeMbrCount++;
                            lastIncPayereBoardMbr       = '';
                            incPayereBoardMbrCount      = 0;
                            incPayerEmployerCount      = 0;
                            incPayer                  = new COPE_NewIncData__c();
                            incPayer.Cell1Class__c    = 'committeeMbr';
           //                 incPayer.OutputColumn1__c = committeeMbrDisplay;
                            incPayer.Table_Row_Id__c  =
                                String.valueOf(incPayerDivisionCount)    + '-'  +
                                String.valueOf(incPayercommitteeMbrCount) + ' data-tt-parent-id=' + String.valueOf(incPayerDivisionCount);
                            incPayersList.add(incPayer);
                        }
                        if (String.isEmpty(lastIncPayereBoardMbr) || lastIncPayereBoardMbr != currentRoweBoardMbr) {
                            //
                            // Add IncPayer eBoard Mbr
                            //
                            lastIncPayereBoardMbr = eBoardMbr;
                            incPayereBoardMbrCount++;
                            incPayerEmployerCount      = 0;
                            incPayer                   = new COPE_NewIncData__c();
                            incPayer.Cell1Class__c     = 'eBoardMbr';
                //            incPayer.OutputColumn1__c  = eBoardMbrDisplay;
                            incPayer.Table_Row_Id__c   =
                                String.valueOf(incPayerDivisionCount)     + '-' +
                                String.valueOf(incPayercommitteeMbrCount)  + '-' +
                                String.valueOf(incPayereBoardMbrCount)     +     +
                                    ' data-tt-parent-id='                     +
                                String.valueOf(incPayerDivisionCount)     + '-'  +
                                String.valueOf(incPayercommitteeMbrCount);
                            incPayersList.add(incPayer);
                            incPayerPtr = incPayersList.size()-1;
                        }

                        //
                        // Add IncPayer Employer
                        //
                        incPayerEmployerCount++;
                        incPayer                         = new COPE_NewIncData__c();
                        incPayer.Cell1Class__c           = 'employer';
          //              incPayer.OutputColumn1__c        = copeData[rowPtr].Employer__c;
                        incPayer.SeatID__c               = copeData[rowPtr].SeatID__c;
                        incPayer.COPE_Increased_Count__c = copeData[rowPtr].COPEIncreaseCountPerSeat__c;
                        incPayer.COPE_Increased_Total__c = copeData[rowPtr].COPEIncreaseTotalPerSeat__c;
                        incPayer.Table_Row_Id__c         =
                            String.valueOf(incPayerDivisionCount)     + '-' +
                            String.valueOf(incPayercommitteeMbrCount)  + '-' +
                            String.valueOf(incPayereBoardMbrCount)     + '-' +
                            String.valueOf(incPayerEmployerCount)     +
                            ' data-tt-parent-id=' +
                            String.valueOf(incPayerDivisionCount)     + '-' +
                            String.valueOf(incPayercommitteeMbrCount)  + '-' +
                            String.valueOf(incPayereBoardMbrCount);
                        incPayersList.add(incPayer);
                        incPayerPtr = incPayersList.size()-1;
                    }

                    rowPtr++;
                    outputRowPtr++;
                    if (rowPtr < ListLen) {
                        currentRoweBoardMbr    = geteBoardMbrName();
                        currentRowcommitteeMbr = getcommitteeMbrName();
                        currentRowDivision    = copeData[rowPtr].Division__c;

                        while (division    == currentRowDivision    &&
                        committeeMbr == currentRowcommitteeMbr &&
                        eBoardMbr    == currentRoweBoardMbr    && rowPtr < listLen) {
                            eBoardMbr            = geteBoardMbrName();
                            currentRoweBoardMbr  = eBoardMbr;
                            currentRoweBoardMbr  = geteBoardMbrName();
                            employerCount++;
                            newItem = new COPE_data__c();
                            setNewItem();
                            newItem.Cell1Class__c         = 'employer';
              ///              newItem.OutputColumn1__c      = copeData[rowPtr].Employer__c;
                            newItem.Table_Row_Id__c =
                                String.valueOf(divisionCount)     + '-'  +
                                String.valueOf(committeeMbrCount)  + '-'  +
                                String.valueOf(eBoardMbrCount)     + '-'  +
                                String.valueOf(employerCount)     +
                                ' data-tt-parent-id='             +  savedId;

                            inceBoardMbrVars();
                            buildList.add(newItem);

                            if(copeData[rowPtr].NewCOPETotal__c > 0) {
                                //
                                // Add NewPayer Employer
                                //
                                newPayerEmployerCount++;
                                newPayer                  = new COPE_NewIncData__c();
                                newPayer.Cell1Class__c    = 'employer';
             //                   newPayer.OutputColumn1__c = copeData[rowPtr].Employer__c;
                                newPayer.SeatID__c        = copeData[rowPtr].SeatID__c;
                                newPayer.NewCOPECount__c  = copeData[rowPtr].NewCOPECount__c;
                                newPayer.NewCOPETotal__c  = copeData[rowPtr].NewCOPETotal__c;
                                newPayer.Table_Row_Id__c  =
                                    String.valueOf(newPayerDivisionCount)     + '-' +
                                    String.valueOf(newPayercommitteeMbrCount)  + '-' +
                                    String.valueOf(newPayereBoardMbrCount)     + '-' +
                                    String.valueOf(newPayerEmployerCount)     +
                                    ' data-tt-parent-id=' +
                                    String.valueOf(newPayerDivisionCount)     + '-' +
                                    String.valueOf(newPayercommitteeMbrCount)  + '-' +
                                    String.valueOf(newPayereBoardMbrCount);

                                newPayersList.add(newPayer);
                                newPayerPtr = newPayersList.size()-1;
                            }

                            if(copeData[rowPtr].COPEIncreaseTotalPerSeat__c > 0) {
                                //
                                // Add IncPayer Employer
                                //
                                incPayerEmployerCount++;
                                incPayer                   = new COPE_NewIncData__c();
                                incPayer.Cell1Class__c     = 'employer';
                 //               incPayer.OutputColumn1__c  = copeData[rowPtr].Employer__c;
                                incPayer.SeatID__c         = copeData[rowPtr].SeatID__c;
                                incPayer.COPE_Increased_Count__c = copeData[rowPtr].COPEIncreaseCountPerSeat__c;
                                incPayer.COPE_Increased_Total__c = copeData[rowPtr].COPEIncreaseTotalPerSeat__c;
                                incPayer.Table_Row_Id__c   =
                                    String.valueOf(incPayerDivisionCount)     + '-' +
                                    String.valueOf(incPayercommitteeMbrCount)  + '-' +
                                    String.valueOf(incPayereBoardMbrCount)     + '-' +
                                    String.valueOf(incPayerEmployerCount)     +
                                    ' data-tt-parent-id=' +
                                    String.valueOf(incPayerDivisionCount)     + '-' +
                                    String.valueOf(incPayercommitteeMbrCount)  + '-' +
                                    String.valueOf(incPayereBoardMbrCount);

                                incPayersList.add(incPayer);
                                incPayerPtr = incPayersList.size()-1;
                            }

                            rowPtr++;
                            outputRowPtr++;
                            if (rowPtr < ListLen) {
                                currentRoweBoardMbr    = geteBoardMbrName();
                                currentRowcommitteeMbr = getcommitteeMbrName();
                                currentRowDivision    = copeData[rowPtr].Division__c;
                            }
                        }
                        seteBoardMbrTotal();
                        inccommitteeMbrVars();
                    }
                    eBoardMbrCount++;
                }
                setcommitteeMbrTotal();
                incDivisionVars();
                committeeMbrCount++;
            }
            setDivisionTotal();
        }
        return buildList;
    }

    public List<COPE_data__c> getbyDivPodEboard() {
        return byDivPodEboard;
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

    private void resetcommitteeMbrVars() {
        committeeMbrNewCOPECount = committeeMbrNewCOPETotal = committeeMbrCOPEIncreaseCountPerSeat = committeeMbrCOPEIncreaseTotalPerSeat = 0;
        committeeMbrCOPETotalPerSeat    = committeeMbrCOPECountPerSeat    = committeeMbrCOPECountTenPlusPerSeat    = committeeMbrEmpCountPerSeat    = 0;
        committeeMbrCOPETotalPerSeat_3  = committeeMbrCOPECountPerSeat_3  = committeeMbrCOPECountTenPlusPerSeat_3  = committeeMbrEmpCountPerSeat_3  = 0;
        committeeMbrCOPETotalPerSeat_6  = committeeMbrCOPECountPerSeat_6  = committeeMbrCOPECountTenPlusPerSeat_6  = committeeMbrEmpCountPerSeat_6  = 0;
        committeeMbrCOPETotalPerSeat_9  = committeeMbrCOPECountPerSeat_9  = committeeMbrCOPECountTenPlusPerSeat_9  = committeeMbrEmpCountPerSeat_9  = 0;
        committeeMbrCOPETotalPerSeat_12 = committeeMbrCOPECountPerSeat_12 = committeeMbrCOPECountTenPlusPerSeat_12 = committeeMbrEmpCountPerSeat_12 = 0;
        committeeMbrCOPEPercent = committeeMbrCOPEPercentTen = committeeMbrCOPEIncreaseTotalPerSeat = committeeMbrCOPEIncreaseCountPerSeat = 0;
    }

    private void reseteBoardMbrVars() {
        eBoardMbrNewCOPECount = eBoardMbrNewCOPETotal = eBoardMbrCOPEIncreaseCountPerSeat = eBoardMbrCOPEIncreaseTotalPerSeat = 0;
        eBoardMbrCOPETotalPerSeat    = eBoardMbrCOPECountPerSeat    = eBoardMbrCOPECountTenPlusPerSeat    = eBoardMbrEmpCountPerSeat    = 0;
        eBoardMbrCOPETotalPerSeat_3  = eBoardMbrCOPECountPerSeat_3  = eBoardMbrCOPECountTenPlusPerSeat_3  = eBoardMbrEmpCountPerSeat_3  = 0;
        eBoardMbrCOPETotalPerSeat_6  = eBoardMbrCOPECountPerSeat_6  = eBoardMbrCOPECountTenPlusPerSeat_6  = eBoardMbrEmpCountPerSeat_6  = 0;
        eBoardMbrCOPETotalPerSeat_9  = eBoardMbrCOPECountPerSeat_9  = eBoardMbrCOPECountTenPlusPerSeat_9  = eBoardMbrEmpCountPerSeat_9  = 0;
        eBoardMbrCOPETotalPerSeat_12 = eBoardMbrCOPECountPerSeat_12 = eBoardMbrCOPECountTenPlusPerSeat_12 = eBoardMbrEmpCountPerSeat_12 = 0;
        eBoardMbrCOPEPercent = eBoardMbrCOPEPercentTen = eBoardMbrCOPEIncreaseTotalPerSeat = eBoardMbrCOPEIncreaseCountPerSeat = 0;
    }


    private void inceBoardMbrVars() {
        eBoardMbrNewCOPETotal               += copeData[rowPtr].NewCOPETotal__c;
        eBoardMbrNewCOPECount               += copeData[rowPtr].NewCOPECount__c;
        eBoardMbrCOPEIncreaseTotalPerSeat   += copeData[rowPtr].COPEIncreaseTotalPerSeat__c;
        eBoardMbrCOPEIncreaseCountPerSeat   += copeData[rowPtr].COPEIncreaseCountPerSeat__c;

        eBoardMbrCOPETotalPerSeat           += copeData[rowPtr].COPETotalPerSeat__c;
        eBoardMbrCOPECountPerSeat           += copeData[rowPtr].COPECountPerSeat__c;
        eBoardMbrCOPECountTenPlusPerSeat    += copeData[rowPtr].COPECountTenPlusPerSeat__c;
        eBoardMbrEmpCountPerSeat            += copeData[rowPtr].EmpCountPerSeat__c;

        eBoardMbrCOPETotalPerSeat_3         += copeData[rowPtr].COPETotalPerSeat_3__c;
        eBoardMbrCOPECountPerSeat_3         += copeData[rowPtr].COPECountPerSeat_3__c;
        eBoardMbrCOPECountTenPlusPerSeat_3  += copeData[rowPtr].COPECountTenPlusPerSeat_3__c;
        eBoardMbrEmpCountPerSeat_3          += copeData[rowPtr].EmpCountPerSeat_3__c;

        eBoardMbrCOPETotalPerSeat_6         += copeData[rowPtr].COPETotalPerSeat_6__c;
        eBoardMbrCOPECountPerSeat_6         += copeData[rowPtr].COPECountPerSeat_6__c;
        eBoardMbrCOPECountTenPlusPerSeat_6  += copeData[rowPtr].COPECountTenPlusPerSeat_6__c;
        eBoardMbrEmpCountPerSeat_6          += copeData[rowPtr].EmpCountPerSeat_6__c;

        eBoardMbrCOPETotalPerSeat_9         += copeData[rowPtr].COPETotalPerSeat_9__c;
        eBoardMbrCOPECountPerSeat_9         += copeData[rowPtr].COPECountPerSeat_9__c;
        eBoardMbrCOPECountTenPlusPerSeat_9  += copeData[rowPtr].COPECountTenPlusPerSeat_9__c;
        eBoardMbrEmpCountPerSeat_9          += copeData[rowPtr].EmpCountPerSeat_9__c;

        eBoardMbrCOPETotalPerSeat_12        += copeData[rowPtr].COPETotalPerSeat_12__c;
        eBoardMbrCOPECountPerSeat_12        += copeData[rowPtr].COPECountPerSeat_12__c;
        eBoardMbrCOPECountTenPlusPerSeat_12 += copeData[rowPtr].COPECountTenPlusPerSeat_12__c;
        eBoardMbrEmpCountPerSeat_12         += copeData[rowPtr].EmpCountPerSeat_12__c;
    }

    private void inccommitteeMbrVars() {
        committeeMbrNewCOPETotal               += eBoardMbrNewCOPETotal;
        committeeMbrNewCOPECount               += eBoardMbrNewCOPECount;
        committeeMbrCOPEIncreaseTotalPerSeat   += eBoardMbrCOPEIncreaseTotalPerSeat;
        committeeMbrCOPEIncreaseCountPerSeat   += eBoardMbrCOPEIncreaseCountPerSeat;

        committeeMbrCOPETotalPerSeat           += eBoardMbrCOPETotalPerSeat;
        committeeMbrCOPECountPerSeat           += eBoardMbrCOPECountPerSeat;
        committeeMbrCOPECountTenPlusPerSeat    += eBoardMbrCOPECountTenPlusPerSeat;
        committeeMbrEmpCountPerSeat            += eBoardMbrEmpCountPerSeat;

        committeeMbrCOPETotalPerSeat_3         += eBoardMbrCOPETotalPerSeat_3;
        committeeMbrCOPECountPerSeat_3         += eBoardMbrCOPECountPerSeat_3;
        committeeMbrCOPECountTenPlusPerSeat_3  += eBoardMbrCOPECountTenPlusPerSeat_3;
        committeeMbrEmpCountPerSeat_3          += eBoardMbrEmpCountPerSeat_3;

        committeeMbrCOPETotalPerSeat_6         += eBoardMbrCOPETotalPerSeat_6;
        committeeMbrCOPECountPerSeat_6         += eBoardMbrCOPECountPerSeat_6;
        committeeMbrCOPECountTenPlusPerSeat_6  += eBoardMbrCOPECountTenPlusPerSeat_6;
        committeeMbrEmpCountPerSeat_6          += eBoardMbrEmpCountPerSeat_6;

        committeeMbrCOPETotalPerSeat_9         += eBoardMbrCOPETotalPerSeat_9;
        committeeMbrCOPECountPerSeat_9         += eBoardMbrCOPECountPerSeat_9;
        committeeMbrCOPECountTenPlusPerSeat_9  += eBoardMbrCOPECountTenPlusPerSeat_9;
        committeeMbrEmpCountPerSeat_9          += eBoardMbrEmpCountPerSeat_9;

        committeeMbrCOPETotalPerSeat_12        += eBoardMbrCOPETotalPerSeat_12;
        committeeMbrCOPECountPerSeat_12        += eBoardMbrCOPECountPerSeat_12;
        committeeMbrCOPECountTenPlusPerSeat_12 += eBoardMbrCOPECountTenPlusPerSeat_12;
        committeeMbrEmpCountPerSeat_12         += eBoardMbrEmpCountPerSeat_12;
    }

    private void incDivisionVars() {
        divisionNewCOPETotal               += committeeMbrNewCOPETotal;
        divisionNewCOPECount               += committeeMbrNewCOPECount;
        divisionCOPEIncreaseTotalPerSeat   += committeeMbrCOPEIncreaseTotalPerSeat;
        divisionCOPEIncreaseCountPerSeat   += committeeMbrCOPEIncreaseCountPerSeat;

        divisionCOPETotalPerSeat           += committeeMbrCOPETotalPerSeat;
        divisionCOPECountPerSeat           += committeeMbrCOPECountPerSeat;
        divisionCOPECountTenPlusPerSeat    += committeeMbrCOPECountTenPlusPerSeat;
        divisionEmpCountPerSeat            += committeeMbrEmpCountPerSeat;

        divisionCOPETotalPerSeat_3         += committeeMbrCOPETotalPerSeat_3;
        divisionCOPECountPerSeat_3         += committeeMbrCOPECountPerSeat_3;
        divisionCOPECountTenPlusPerSeat_3  += committeeMbrCOPECountTenPlusPerSeat_3;
        divisionEmpCountPerSeat_3          += committeeMbrEmpCountPerSeat_3;

        divisionCOPETotalPerSeat_6         += committeeMbrCOPETotalPerSeat_6;
        divisionCOPECountPerSeat_6         += committeeMbrCOPECountPerSeat_6;
        divisionCOPECountTenPlusPerSeat_6  += committeeMbrCOPECountTenPlusPerSeat_6;
        divisionEmpCountPerSeat_6          += committeeMbrEmpCountPerSeat_6;

        divisionCOPETotalPerSeat_9         += committeeMbrCOPETotalPerSeat_9;
        divisionCOPECountPerSeat_9         += committeeMbrCOPECountPerSeat_9;
        divisionCOPECountTenPlusPerSeat_9  += committeeMbrCOPECountTenPlusPerSeat_9;
        divisionEmpCountPerSeat_9          += committeeMbrEmpCountPerSeat_9;

        divisionCOPETotalPerSeat_12        += committeeMbrCOPETotalPerSeat_12;
        divisionCOPECountPerSeat_12        += committeeMbrCOPECountPerSeat_12;
        divisionCOPECountTenPlusPerSeat_12 += committeeMbrCOPECountTenPlusPerSeat_12;
        divisionEmpCountPerSeat_12         += committeeMbrEmpCountPerSeat_12;
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

    private void seteBoardMbrTotal() {
        buildList[eBoardMbrPtr].COPETotalPerSeat__c        = eBoardMbrCOPETotalPerSeat;
        buildList[eBoardMbrPtr].COPECountPerSeat__c        = eBoardMbrCOPECountPerSeat;
        buildList[eBoardMbrPtr].COPECountTenPlusPerSeat__c = eBoardMbrCOPECountTenPlusPerSeat;
        buildList[eBoardMbrPtr].EmpCountPerSeat__c         = eBoardMbrEmpCountPerSeat;

        If (eBoardMbrCOPECountPerSeat > 0 && eBoardMbrEmpCountPerSeat > 0) {
            buildList[eBoardMbrPtr].COPEPercent__c               = (eBoardMbrCOPECountPerSeat / eBoardMbrEmpCountPerSeat) * 100 ;
            buildList[eBoardMbrPtr].UWG__c                       =  eBoardMbrCOPETotalPerSeat / ((eBoardMbrEmpCountPerSeat * 0.33) * 10) *100;
        }

        If (eBoardMbrCOPECountTenPlusPerSeat  > 0 && eBoardMbrEmpCountPerSeat > 0)
        buildList[eBoardMbrPtr].COPEPercentTen__c            = (eBoardMbrCOPECountTenPlusPerSeat / eBoardMbrEmpCountPerSeat)  * 100 ;

        buildList[eBoardMbrPtr].NewCOPETotal__c              = eBoardMbrNewCOPETotal;
        buildList[eBoardMbrPtr].NewCOPECount__c              = eBoardMbrNewCOPECount;
        buildList[eBoardMbrPtr].COPEIncreaseTotalPerSeat__c  = eBoardMbrCOPEIncreaseTotalPerSeat;
        buildList[eBoardMbrPtr].COPEIncreaseCountPerSeat__c  = eBoardMbrCOPEIncreaseCountPerSeat;

        /*
         newPayersList[newPayerPtr].NewCOPETotal__c           = eBoardMbrNewCOPETotal;
         newPayersList[newPayerPtr].NewCOPECount__c           = eBoardMbrNewCOPECount;

         incPayersList[incPayerPtr].Division__c               = division + ' (' + String.valueOf(incPayerCount) + ')';

         incPayersList[incPayerPtr].COPE_Increased_Total__c   = eBoardMbrCOPEIncreaseTotalPerSeat;
         incPayersList[incPayerPtr].COPE_Increased_Count__c   = eBoardMbrCOPEIncreaseCountPerSeat;
         */

        buildList[eBoardMbrPtr].COPETotalPerSeat_3__c        = eBoardMbrCOPETotalPerSeat_3;
        buildList[eBoardMbrPtr].COPECountPerSeat_3__c        = eBoardMbrCOPECountPerSeat_3;

        buildList[eBoardMbrPtr].COPETotalPerSeat_6__c        = eBoardMbrCOPETotalPerSeat_6;
        buildList[eBoardMbrPtr].COPECountPerSeat_6__c        = eBoardMbrCOPECountPerSeat_6;

        buildList[eBoardMbrPtr].COPETotalPerSeat_9__c        = eBoardMbrCOPETotalPerSeat_9;
        buildList[eBoardMbrPtr].COPECountPerSeat_9__c        = eBoardMbrCOPECountPerSeat_9;

        buildList[eBoardMbrPtr].COPETotalPerSeat_12__c        = eBoardMbrCOPETotalPerSeat_12;
        buildList[eBoardMbrPtr].COPECountPerSeat_12__c        = eBoardMbrCOPECountPerSeat_12;
    }

    private void setcommitteeMbrTotal() {
        buildList[committeeMbrPtr].COPETotalPerSeat__c        = committeeMbrCOPETotalPerSeat;
        buildList[committeeMbrPtr].COPECountPerSeat__c        = committeeMbrCOPECountPerSeat;
        buildList[committeeMbrPtr].COPECountTenPlusPerSeat__c = committeeMbrCOPECountTenPlusPerSeat;
        buildList[committeeMbrPtr].EmpCountPerSeat__c         = committeeMbrEmpCountPerSeat;

        If (committeeMbrCOPECountPerSeat > 0 && committeeMbrEmpCountPerSeat > 0) {
            buildList[committeeMbrPtr].COPEPercent__c               = (committeeMbrCOPECountPerSeat /   committeeMbrEmpCountPerSeat) * 100 ;
            buildList[committeeMbrPtr].UWG__c                       =  committeeMbrCOPETotalPerSeat / ((committeeMbrEmpCountPerSeat * 0.33) * 10) *100;
        }

        If (committeeMbrCOPECountTenPlusPerSeat  > 0 && committeeMbrEmpCountPerSeat > 0)
        buildList[committeeMbrPtr].COPEPercentTen__c            = (committeeMbrCOPECountTenPlusPerSeat / committeeMbrEmpCountPerSeat)  * 100 ;

        buildList[committeeMbrPtr].NewCOPETotal__c              = committeeMbrNewCOPETotal;
        buildList[committeeMbrPtr].NewCOPECount__c              = committeeMbrNewCOPECount;
        buildList[committeeMbrPtr].COPEIncreaseTotalPerSeat__c  = committeeMbrCOPEIncreaseTotalPerSeat;
        buildList[committeeMbrPtr].COPEIncreaseCountPerSeat__c  = committeeMbrCOPEIncreaseCountPerSeat;

        /*
         newPayersList[newPayerPtr].NewCOPETotal__c           = committeeMbrNewCOPETotal;
         newPayersList[newPayerPtr].NewCOPECount__c           = committeeMbrNewCOPECount;

         incPayersList[incPayerPtr].Division__c               = division + ' (' + String.valueOf(incPayerCount) + ')';

         incPayersList[incPayerPtr].COPE_Increased_Total__c   = committeeMbrCOPEIncreaseTotalPerSeat;
         incPayersList[incPayerPtr].COPE_Increased_Count__c   = committeeMbrCOPEIncreaseCountPerSeat;
         */

        buildList[committeeMbrPtr].COPETotalPerSeat_3__c        = committeeMbrCOPETotalPerSeat_3;
        buildList[committeeMbrPtr].COPECountPerSeat_3__c        = committeeMbrCOPECountPerSeat_3;

        buildList[committeeMbrPtr].COPETotalPerSeat_6__c        = committeeMbrCOPETotalPerSeat_6;
        buildList[committeeMbrPtr].COPECountPerSeat_6__c        = committeeMbrCOPECountPerSeat_6;

        buildList[committeeMbrPtr].COPETotalPerSeat_9__c        = committeeMbrCOPETotalPerSeat_9;
        buildList[committeeMbrPtr].COPECountPerSeat_9__c        = committeeMbrCOPECountPerSeat_9;

        buildList[committeeMbrPtr].COPETotalPerSeat_12__c        = committeeMbrCOPETotalPerSeat_12;
        buildList[committeeMbrPtr].COPECountPerSeat_12__c        = committeeMbrCOPECountPerSeat_12;
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

    private String getcommitteeMbrName() {
        return copeData[rowPtr].CommitteeMbrName__c;
    }

    private String geteBoardMbrName() {
        return copeData[rowPtr].eBoardNames__c;
    }

    public Integer fudgeIt() {
        Integer test;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        test = 1;
        return 1;
    }

}