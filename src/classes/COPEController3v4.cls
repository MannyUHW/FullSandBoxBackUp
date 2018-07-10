public class COPEController3v4 {

    Private List<COPE_data__c> copeData;
    Private List<COPE_data__c> byDivOrgRep;
    
    Private List<COPE_data__c> divOrgRepList;
    
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

    Private Decimal coordinatorCOPEPercent, coordinatorCOPEPercentTen, coordinatorNewCOPECount, coordinatorNewCOPETotal, coordinatorCOPEIncreaseCountPerSeat, coordinatorCOPEIncreaseTotalPerSeat;
    Private Decimal coordinatorCOPETotalPerSeat,    coordinatorCOPECountPerSeat,    coordinatorCOPECountTenPlusPerSeat,    coordinatorEmpCountPerSeat;
    Private Decimal coordinatorCOPETotalPerSeat_3,  coordinatorCOPECountPerSeat_3,  coordinatorCOPECountTenPlusPerSeat_3,  coordinatorEmpCountPerSeat_3;
    Private Decimal coordinatorCOPETotalPerSeat_6,  coordinatorCOPECountPerSeat_6,  coordinatorCOPECountTenPlusPerSeat_6,  coordinatorEmpCountPerSeat_6;
    Private Decimal coordinatorCOPETotalPerSeat_9,  coordinatorCOPECountPerSeat_9,  coordinatorCOPECountTenPlusPerSeat_9,  coordinatorEmpCountPerSeat_9;
    Private Decimal coordinatorCOPETotalPerSeat_12, coordinatorCOPECountPerSeat_12, coordinatorCOPECountTenPlusPerSeat_12, coordinatorEmpCountPerSeat_12;

    Private Decimal fieldRepCOPEPercent, fieldRepCOPEPercentTen, fieldRepNewCOPECount, fieldRepNewCOPETotal, fieldRepCOPEIncreaseCountPerSeat, fieldRepCOPEIncreaseTotalPerSeat;
    Private Decimal fieldRepCOPETotalPerSeat,    fieldRepCOPECountPerSeat,    fieldRepCOPECountTenPlusPerSeat,    fieldRepEmpCountPerSeat;
    Private Decimal fieldRepCOPETotalPerSeat_3,  fieldRepCOPECountPerSeat_3,  fieldRepCOPECountTenPlusPerSeat_3,  fieldRepEmpCountPerSeat_3;
    Private Decimal fieldRepCOPETotalPerSeat_6,  fieldRepCOPECountPerSeat_6,  fieldRepCOPECountTenPlusPerSeat_6,  fieldRepEmpCountPerSeat_6;
    Private Decimal fieldRepCOPETotalPerSeat_9,  fieldRepCOPECountPerSeat_9,  fieldRepCOPECountTenPlusPerSeat_9,  fieldRepEmpCountPerSeat_9;
    Private Decimal fieldRepCOPETotalPerSeat_12, fieldRepCOPECountPerSeat_12, fieldRepCOPECountTenPlusPerSeat_12, fieldRepEmpCountPerSeat_12;

    Private List<COPE_data__c> buildList;
    Private COPE_data__c newItem;
    Private Integer rowPtr;
    Private Integer divisionPtr;
    Private Integer coordinatorPtr;
    Private Integer fieldRepPtr;
    private String arg;
    private String msg;

    public COPEController3v4() {

            divOrgRepList = new List<COPE_data__c>(); 
            newPayersList = new List<COPE_NewIncData__c>();
            incPayersList = new List<COPE_NewIncData__c>();

        if(byDivOrgRep== Null) {
            byDivOrgRep= buildByDivOrgRepList();
        }

         if(byNewPayers == Null) {
             byNewPayers = buildByDivOrgRepNewPayersList();
         }

         if(byIncPayers == Null) {
             byIncPayers = buildByDivOrgRepIncPayersList();
         }

    }

    public String getTest() {
        return 'This is my string!';
    }
    
    public List<COPE_data__c> getbyDivOrgRep() {
        return byDivOrgRep;
    }

     public List<COPE_NewIncData__c> getNewPayers() {
         return byNewPayers;
     }

     public List<COPE_NewIncData__c> getIncPayers() {
         return byIncPayers;
     }
     
     private List<COPE_NewIncData__c> buildByDivOrgRepNewPayersList() {
         return newPayersList;
     }

     private List<COPE_NewIncData__c> buildByDivOrgRepIncPayersList() {
         return incPayersList;
     }
     
     public String getCurrentMonth() {
         AggregateResult[] currentMonth = [Select Max(Current_Month__c) maxMonth From COPE_Data__c];
         String retval = (string)currentMonth[0].get('maxMonth');
         return retval;
     }
     
    private List<COPE_data__c> buildByDivOrgRepList() {

        COPE_NewIncData__c newPayer;
        COPE_NewIncData__c incPayer;

        Integer listLen;
        Integer outputRowPtr;
        Integer divisionCount;
        Integer newPayerDivisionCount;
        Integer incPayerDivisionCount;        
        Integer coordinatorCount;
        Integer newPayerCoordinatorCount;
        Integer incPayerCoordinatorCount;        
        Integer fieldRepCount;
        Integer newPayerFieldRepCount;        
        Integer incPayerFieldRepCount;        
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
        String coordinator;
        String coordinatorDisplay;
        String lastNewPayerCoordinator;        
        String lastIncPayerCoordinator;        
        String currentRowCoordinator;
        String fieldRep;
        String fieldRepDisplay;
        String currentRowFieldRep;
        String lastNewPayerFieldRep;
        String lastIncPayerFieldRep;        
        String savedId;
        String newPayerSavedId;
        String incPayerSavedId;
        
        Integer i;

        copeData = [Select Division__c,CoordinatorLastName__c,CoordinatorFirstName__c,FieldRepLastName__c,FieldRepFirstName__c,Employer__c,SeatID__c,
            NewCOPECount__c,NewCOPETotal__c, COPEIncreaseCountPerSeat__c,COPEIncreaseTotalPerSeat__c,
            COPETotalPerSeat__c,COPETotalPerSeat_3__c,COPETotalPerSeat_6__c,COPETotalPerSeat_9__c,COPETotalPerSeat_12__c,
            COPECountPerSeat__c,COPECountPerSeat_3__c,COPECountPerSeat_6__c,COPECountPerSeat_9__c,COPECountPerSeat_12__c,
            COPECountTenPlusPerSeat__c,COPECountTenPlusPerSeat_3__c,COPECountTenPlusPerSeat_6__c,COPECountTenPlusPerSeat_9__c,COPECountTenPlusPerSeat_12__c,
            COPEPercent__c, COPEPercentTen__c, EmpCountPerSeat__c, EmpCountPerSeat_3__c, EmpCountPerSeat_6__c, EmpCountPerSeat_9__c, EmpCountPerSeat_12__c,Table_Row_Id__c,OutputColumn1__c,UWG__c
            From COPE_Data__c
            Order By Division__c,CoordinatorLastName__c,CoordinatorFirstName__c,FieldRepLastName__c,FieldRepFirstName__c,Employer__c,SeatID__c];

        divOrgRepList               = New List<COPE_data__c>();
        listLen                 = copeData.size();
        rowPtr                  = 0;
        outputRowPtr            = 0;
        newPayerPtr             = 0;
        incPayerPtr             = 0;
        divisionCount           = 0;
        coordinatorCount        = 1;
        lastNewPayerDivision    = '';
        lastNewPayerCoordinator = '';
        lastNewPayerFieldRep    = '';

        newPayerDivisionCount    = 0;
        incPayerDivisionCount    = 0;
        newPayerCoordinatorCount = 0;
        incPayerCoordinatorCount = 0;        
        newPayerFieldRepCount    = 0;        
        incPayerFieldRepCount    = 0;        
        newPayerEmployerCount    = 0;        
        incPayerEmployerCount    = 0;        

        resetDivisionVars();
        resetCoordinatorVars();
        resetFieldRepVars();

        divisionPtr = 0;
        
        // For testing:
        this.arg = ApexPages.currentPage().getParameters().get('arg');
        if(this.arg != null)
            listLen = Integer.valueOf(this.arg);
            
        while (rowPtr < listLen) {
            fieldRepCount         = 0;
            newPayerCount         = 0;
            incPayerCount         = 0;
            division              = copeData[rowPtr].Division__c;
            currentRowDivision    = copeData[rowPtr].Division__c;
            divisionCount++;

            newItem                  = new COPE_data__c();
            newItem.Cell1Class__c  = 'division';
            newItem.OutputColumn1__c = division;
            newItem.Table_Row_Id__c  = String.valueOf(divisionCount);
            divOrgRepList.add(newItem);
            divisionPtr = divOrgRepList.size() - 1;
// Add division
        
            resetDivisionVars();
            coordinatorCount = 1;
            while (division == currentRowDivision && rowPtr < listLen) {
                coordinator           = getCoordinatorName();
                currentRowCoordinator = coordinator;

                if (coordinator.contains('Vacant'))
                    coordinatorDisplay = 'Coordinator Vacant for seat ' + + copeData[rowPtr].SeatID__c;
                else
                    coordinatorDisplay = coordinator;

                newItem = new COPE_data__c();
                newItem.Cell1Class__c  = 'coordinator';
                newItem.OutputColumn1__c = coordinatorDisplay;
                newItem.Table_Row_Id__c  =
                    String.valueOf(divisionCount)    + '-'  +
                    String.valueOf(coordinatorCount) + ' data-tt-parent-id=' + String.valueOf(divisionCount);
// Add coordinator
                divOrgRepList.add(newItem);
                resetCoordinatorVars();
                coordinatorPtr = divOrgRepList.size() - 1;
                fieldRepCount = 1;
                while (division == currentRowDivision    &&
                coordinator == currentRowCoordinator && rowPtr < listLen) {
                    fieldRep            = getFieldRepName();
                    currentRowFieldRep  = fieldRep;

                    if (fieldRep.contains('Vacant'))                    
                        fieldRepDisplay = 'Field Rep. Vacant for seat ' + copeData[rowPtr].SeatID__c;
                    else
                        fieldRepDisplay = fieldRep;

                    currentRowCoordinator = getCoordinatorName();

                    resetFieldRepVars();
                    employerCount = 1;
                    savedId =
                        String.valueOf(divisionCount)     + '-' +
                        String.valueOf(coordinatorCount)  + '-' +
                        String.valueOf(fieldRepCount);
                        
                    newItem = new COPE_data__c();
                    newItem.Cell1Class__c  = 'fieldRep';
                    newItem.OutputColumn1__c = fieldRepDisplay;
                    newItem.Table_Row_Id__c  =
                        savedId                           +
                        ' data-tt-parent-id='             +
                        String.valueOf(divisionCount)     + '-'  +
                        String.valueOf(coordinatorCount);

                    divOrgRepList.add(newItem);
                    fieldRepPtr = divOrgRepList.size() - 1;
// Add initial Rep
                    
                    newItem                    = New COPE_data__c();
                    setNewItem();
                    newItem.Cell1Class__c      = 'employer';
                    newItem.OutputColumn1__c   = copeData[rowPtr].Employer__c;
                    newItem.Table_Row_Id__c    =
                        String.valueOf(divisionCount)     + '-' +
                        String.valueOf(coordinatorCount)  + '-' +
                        String.valueOf(fieldRepCount)     + '-' +
                        String.valueOf(employerCount)     +
                        ' data-tt-parent-id=' + savedId;
                    incFieldRepVars();
                    divOrgRepList.add(newItem);

                    if(copeData[rowPtr].NewCOPETotal__c > 0) {
                        if (String.isEmpty(lastNewPayerDivision) ||  lastNewPayerDivision <> currentRowDivision) {
                            //
                            // Add NewPayer Division
                            //
                            lastNewPayerDivision = division;
                            newPayerDivisionCount++;
                            lastNewPayerCoordinator    = '';
                            lastNewPayerFieldRep       = '';
                            newPayerCoordinatorCount   = 0;
                            newPayerFieldRepCount      = 0;
                            newPayerEmployerCount      = 0;
                            newPayer                   = new COPE_NewIncData__c();
                            newPayer.Cell1Class__c     = 'division';
                            newPayer.OutputColumn1__c  = lastNewPayerDivision;
                            newPayer.Table_Row_Id__c   = String.valueOf(newPayerDivisionCount);
                            newPayersList.add(newPayer);
                        }
                        if (String.isEmpty(lastNewPayerCoordinator) || lastNewPayerCoordinator <> currentRowCoordinator) {
                            //
                            // Add NewPayer Coordinator
                            //
                            lastNewPayerCoordinator = coordinator;
                            newPayerCoordinatorCount++;
                            lastNewPayerFieldRep       = '';
                            newPayerFieldRepCount      = 0;
                            newPayerEmployerCount      = 0;
                            newPayer                  = new COPE_NewIncData__c();
                            newPayer.Cell1Class__c    = 'coordinator';
                            newPayer.OutputColumn1__c = coordinatorDisplay;
                            newPayer.Table_Row_Id__c  =
                                String.valueOf(newPayerDivisionCount)    + '-'  +
                                String.valueOf(newPayerCoordinatorCount) + ' data-tt-parent-id=' + String.valueOf(newPayerDivisionCount);
                            newPayersList.add(newPayer);
                        }
                        if (String.isEmpty(lastNewPayerFieldRep) || lastNewPayerFieldRep <> currentRowFieldRep) {
                            //
                            // Add NewPayer Field Rep
                            //
                            lastNewPayerFieldRep = fieldRep;
                            newPayerFieldRepCount++;
                            newPayerEmployerCount      = 0;
                            newPayer                   = new COPE_NewIncData__c();
                            newPayer.Cell1Class__c     = 'fieldRep';
                            newPayer.OutputColumn1__c  = fieldRepDisplay;
                            newPayer.Table_Row_Id__c   =
                                String.valueOf(newPayerDivisionCount)     + '-' +
                                String.valueOf(newPayerCoordinatorCount)  + '-' +
                                String.valueOf(newPayerFieldRepCount)     +     +
                                ' data-tt-parent-id='                     +
                                String.valueOf(newPayerDivisionCount)     + '-'  +
                                String.valueOf(newPayerCoordinatorCount);
                            newPayersList.add(newPayer);
                            newPayerPtr = newPayersList.size()-1;
                        }                               

                        //
                        // Add NewPayer Employer
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
                            String.valueOf(newPayerCoordinatorCount)  + '-' +
                            String.valueOf(newPayerFieldRepCount)     + '-' +
                            String.valueOf(newPayerEmployerCount)     +
                                                ' data-tt-parent-id=' + 
                            String.valueOf(newPayerDivisionCount)     + '-' +
                            String.valueOf(newPayerCoordinatorCount)  + '-' +
                            String.valueOf(newPayerFieldRepCount);
                        newPayersList.add(newPayer);
                        newPayerPtr = newPayersList.size()-1;
                    }

                    if(copeData[rowPtr].COPEIncreaseTotalPerSeat__c > 0) {
                        if (String.isEmpty(lastIncPayerDivision) ||  lastIncPayerDivision <> currentRowDivision) {
                            //
                            // Add IncPayer Division
                            //
                            lastIncPayerDivision = division;
                            incPayerDivisionCount++;
                            lastIncPayerCoordinator    = '';
                            lastIncPayerFieldRep       = '';
                            incPayerCoordinatorCount   = 0;
                            incPayerFieldRepCount      = 0;
                            incPayerEmployerCount      = 0;
                            incPayer                   = new COPE_NewIncData__c();
                            incPayer.Cell1Class__c     = 'division';
                            incPayer.OutputColumn1__c  = lastIncPayerDivision;
                            incPayer.Table_Row_Id__c   = String.valueOf(IncPayerDivisionCount);
                            incPayersList.add(incPayer);
                        }
                        if (String.isEmpty(lastIncPayerCoordinator) || lastIncPayerCoordinator <> currentRowCoordinator) {
                            //
                            // Add IncPayer Coordinator
                            //
                            lastIncPayerCoordinator = coordinator;
                            incPayerCoordinatorCount++;
                            lastIncPayerFieldRep       = '';
                            incPayerFieldRepCount      = 0;
                            incPayerEmployerCount      = 0;
                            incPayer                  = new COPE_NewIncData__c();
                            incPayer.Cell1Class__c    = 'coordinator';
                            incPayer.OutputColumn1__c = coordinatorDisplay;
                            incPayer.Table_Row_Id__c  =
                                String.valueOf(incPayerDivisionCount)    + '-'  +
                                String.valueOf(incPayerCoordinatorCount) + ' data-tt-parent-id=' + String.valueOf(incPayerDivisionCount);
                            incPayersList.add(incPayer);
                        }
                        if (String.isEmpty(lastIncPayerFieldRep) || lastIncPayerFieldRep <> currentRowFieldRep) {
                            //
                            // Add IncPayer Field Rep
                            //
                            lastIncPayerFieldRep = fieldRep;
                            incPayerFieldRepCount++;
                            incPayerEmployerCount      = 0;
                            incPayer                   = new COPE_NewIncData__c();
                            incPayer.Cell1Class__c     = 'fieldRep';
                            incPayer.OutputColumn1__c  = fieldRepDisplay;
                            incPayer.Table_Row_Id__c   =
                                String.valueOf(incPayerDivisionCount)     + '-' +
                                String.valueOf(incPayerCoordinatorCount)  + '-' +
                                String.valueOf(incPayerFieldRepCount)     +     +
                                ' data-tt-parent-id='                     +
                                String.valueOf(incPayerDivisionCount)     + '-'  +
                                String.valueOf(incPayerCoordinatorCount);
                            incPayersList.add(incPayer);
                            incPayerPtr = incPayersList.size()-1;
                        }                               

                        //
                        // Add IncPayer Employer
                        //
                        incPayerEmployerCount++;
                        incPayer                         = new COPE_NewIncData__c();
                        incPayer.Cell1Class__c           = 'employer';
                        incPayer.OutputColumn1__c        = copeData[rowPtr].Employer__c;
                        incPayer.SeatID__c               = copeData[rowPtr].SeatID__c;
                        incPayer.COPE_Increased_Count__c = copeData[rowPtr].COPEIncreaseCountPerSeat__c;
                        incPayer.COPE_Increased_Total__c = copeData[rowPtr].COPEIncreaseTotalPerSeat__c;
                        incPayer.Table_Row_Id__c         =  
                            String.valueOf(incPayerDivisionCount)     + '-' +
                            String.valueOf(incPayerCoordinatorCount)  + '-' +
                            String.valueOf(incPayerFieldRepCount)     + '-' +
                            String.valueOf(incPayerEmployerCount)     +
                                                ' data-tt-parent-id=' + 
                            String.valueOf(incPayerDivisionCount)     + '-' +
                            String.valueOf(incPayerCoordinatorCount)  + '-' +
                            String.valueOf(incPayerFieldRepCount);
                        incPayersList.add(incPayer);
                        incPayerPtr = incPayersList.size()-1;
                    }
                                        
                    rowPtr++;
                    outputRowPtr++;
                    if (rowPtr < ListLen) {
                        currentRowFieldRep    = getFieldRepName();
                        currentRowCoordinator = getCoordinatorName();
                        currentRowDivision    = copeData[rowPtr].Division__c;

                        while (division    == currentRowDivision    &&
                               coordinator == currentRowCoordinator &&
                               fieldRep    == currentRowFieldRep    && rowPtr < listLen) {
                            fieldRep            = getFieldRepName();
                            currentRowFieldRep  = fieldRep;
                            currentRowFieldRep  = getFieldRepName();
                            employerCount++;
                            newItem = new COPE_data__c();
                            setNewItem();
                            newItem.Cell1Class__c         = 'employer';
                            newItem.OutputColumn1__c        = copeData[rowPtr].Employer__c;
                            newItem.Table_Row_Id__c =
                                String.valueOf(divisionCount)     + '-'  +
                                String.valueOf(coordinatorCount)  + '-'  +
                                String.valueOf(fieldRepCount)     + '-'  +
                                String.valueOf(employerCount)     +
                                ' data-tt-parent-id='             +  savedId;

                            incFieldRepVars();
                            divOrgRepList.add(newItem);

                            if(copeData[rowPtr].NewCOPETotal__c > 0) {
                               //
                               // Add NewPayer Employer
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
                                    String.valueOf(newPayerCoordinatorCount)  + '-' +
                                    String.valueOf(newPayerFieldRepCount)     + '-' +
                                    String.valueOf(newPayerEmployerCount)     +
                                                        ' data-tt-parent-id=' + 
                                    String.valueOf(newPayerDivisionCount)     + '-' +
                                    String.valueOf(newPayerCoordinatorCount)  + '-' +
                                    String.valueOf(newPayerFieldRepCount);

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
                               incPayer.OutputColumn1__c  = copeData[rowPtr].Employer__c;
                               incPayer.SeatID__c         = copeData[rowPtr].SeatID__c;
                               incPayer.COPE_Increased_Count__c = copeData[rowPtr].COPEIncreaseCountPerSeat__c;
                               incPayer.COPE_Increased_Total__c = copeData[rowPtr].COPEIncreaseTotalPerSeat__c;
                               incPayer.Table_Row_Id__c   =  
                                    String.valueOf(incPayerDivisionCount)     + '-' +
                                    String.valueOf(incPayerCoordinatorCount)  + '-' +
                                    String.valueOf(incPayerFieldRepCount)     + '-' +
                                    String.valueOf(incPayerEmployerCount)     +
                                                        ' data-tt-parent-id=' + 
                                    String.valueOf(incPayerDivisionCount)     + '-' +
                                    String.valueOf(incPayerCoordinatorCount)  + '-' +
                                    String.valueOf(incPayerFieldRepCount);

                               incPayersList.add(incPayer);
                               incPayerPtr = incPayersList.size()-1;
                            }
                            
                            rowPtr++;
                            outputRowPtr++;
                            if (rowPtr < ListLen) {
                                currentRowFieldRep    = getFieldRepName();
                                currentRowCoordinator = getCoordinatorName();
                                currentRowDivision    = copeData[rowPtr].Division__c;
                            }
                        }
                        setFieldRepTotal();
                        incCoordinatorVars();
                    }
                    fieldRepCount++;
                }
                setCoordinatorTotal();
                incDivisionVars();
                coordinatorCount++;
            }
            setDivisionTotal();
        }
        return divOrgRepList;
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

    private void resetCoordinatorVars() {
        coordinatorNewCOPECount = coordinatorNewCOPETotal = coordinatorCOPEIncreaseCountPerSeat = coordinatorCOPEIncreaseTotalPerSeat = 0;
        coordinatorCOPETotalPerSeat    = coordinatorCOPECountPerSeat    = coordinatorCOPECountTenPlusPerSeat    = coordinatorEmpCountPerSeat    = 0;
        coordinatorCOPETotalPerSeat_3  = coordinatorCOPECountPerSeat_3  = coordinatorCOPECountTenPlusPerSeat_3  = coordinatorEmpCountPerSeat_3  = 0;
        coordinatorCOPETotalPerSeat_6  = coordinatorCOPECountPerSeat_6  = coordinatorCOPECountTenPlusPerSeat_6  = coordinatorEmpCountPerSeat_6  = 0;
        coordinatorCOPETotalPerSeat_9  = coordinatorCOPECountPerSeat_9  = coordinatorCOPECountTenPlusPerSeat_9  = coordinatorEmpCountPerSeat_9  = 0;
        coordinatorCOPETotalPerSeat_12 = coordinatorCOPECountPerSeat_12 = coordinatorCOPECountTenPlusPerSeat_12 = coordinatorEmpCountPerSeat_12 = 0;
        coordinatorCOPEPercent = coordinatorCOPEPercentTen = coordinatorCOPEIncreaseTotalPerSeat = coordinatorCOPEIncreaseCountPerSeat = 0;
    }

    private void resetFieldRepVars() {
        fieldRepNewCOPECount = fieldRepNewCOPETotal = fieldRepCOPEIncreaseCountPerSeat = fieldRepCOPEIncreaseTotalPerSeat = 0;
        fieldRepCOPETotalPerSeat    = fieldRepCOPECountPerSeat    = fieldRepCOPECountTenPlusPerSeat    = fieldRepEmpCountPerSeat    = 0;
        fieldRepCOPETotalPerSeat_3  = fieldRepCOPECountPerSeat_3  = fieldRepCOPECountTenPlusPerSeat_3  = fieldRepEmpCountPerSeat_3  = 0;
        fieldRepCOPETotalPerSeat_6  = fieldRepCOPECountPerSeat_6  = fieldRepCOPECountTenPlusPerSeat_6  = fieldRepEmpCountPerSeat_6  = 0;
        fieldRepCOPETotalPerSeat_9  = fieldRepCOPECountPerSeat_9  = fieldRepCOPECountTenPlusPerSeat_9  = fieldRepEmpCountPerSeat_9  = 0;
        fieldRepCOPETotalPerSeat_12 = fieldRepCOPECountPerSeat_12 = fieldRepCOPECountTenPlusPerSeat_12 = fieldRepEmpCountPerSeat_12 = 0;
        fieldRepCOPEPercent = fieldRepCOPEPercentTen = fieldRepCOPEIncreaseTotalPerSeat = fieldRepCOPEIncreaseCountPerSeat = 0;
    }


    private void incFieldRepVars() {
        fieldRepNewCOPETotal               += copeData[rowPtr].NewCOPETotal__c;
        fieldRepNewCOPECount               += copeData[rowPtr].NewCOPECount__c;
        fieldRepCOPEIncreaseTotalPerSeat   += copeData[rowPtr].COPEIncreaseTotalPerSeat__c;
        fieldRepCOPEIncreaseCountPerSeat   += copeData[rowPtr].COPEIncreaseCountPerSeat__c;

        fieldRepCOPETotalPerSeat           += copeData[rowPtr].COPETotalPerSeat__c;
        fieldRepCOPECountPerSeat           += copeData[rowPtr].COPECountPerSeat__c;
        fieldRepCOPECountTenPlusPerSeat    += copeData[rowPtr].COPECountTenPlusPerSeat__c;
        fieldRepEmpCountPerSeat            += copeData[rowPtr].EmpCountPerSeat__c;

        fieldRepCOPETotalPerSeat_3         += copeData[rowPtr].COPETotalPerSeat_3__c;
        fieldRepCOPECountPerSeat_3         += copeData[rowPtr].COPECountPerSeat_3__c;
        fieldRepCOPECountTenPlusPerSeat_3  += copeData[rowPtr].COPECountTenPlusPerSeat_3__c;
        fieldRepEmpCountPerSeat_3          += copeData[rowPtr].EmpCountPerSeat_3__c;

        fieldRepCOPETotalPerSeat_6         += copeData[rowPtr].COPETotalPerSeat_6__c;
        fieldRepCOPECountPerSeat_6         += copeData[rowPtr].COPECountPerSeat_6__c;
        fieldRepCOPECountTenPlusPerSeat_6  += copeData[rowPtr].COPECountTenPlusPerSeat_6__c;
        fieldRepEmpCountPerSeat_6          += copeData[rowPtr].EmpCountPerSeat_6__c;

        fieldRepCOPETotalPerSeat_9         += copeData[rowPtr].COPETotalPerSeat_9__c;
        fieldRepCOPECountPerSeat_9         += copeData[rowPtr].COPECountPerSeat_9__c;
        fieldRepCOPECountTenPlusPerSeat_9  += copeData[rowPtr].COPECountTenPlusPerSeat_9__c;
        fieldRepEmpCountPerSeat_9          += copeData[rowPtr].EmpCountPerSeat_9__c;

        fieldRepCOPETotalPerSeat_12        += copeData[rowPtr].COPETotalPerSeat_12__c;
        fieldRepCOPECountPerSeat_12        += copeData[rowPtr].COPECountPerSeat_12__c;
        fieldRepCOPECountTenPlusPerSeat_12 += copeData[rowPtr].COPECountTenPlusPerSeat_12__c;
        fieldRepEmpCountPerSeat_12         += copeData[rowPtr].EmpCountPerSeat_12__c;
    }

    private void incCoordinatorVars() {
        coordinatorNewCOPETotal               += fieldRepNewCOPETotal;
        coordinatorNewCOPECount               += fieldRepNewCOPECount;
        coordinatorCOPEIncreaseTotalPerSeat   += fieldRepCOPEIncreaseTotalPerSeat;
        coordinatorCOPEIncreaseCountPerSeat   += fieldRepCOPEIncreaseCountPerSeat;

        coordinatorCOPETotalPerSeat           += fieldRepCOPETotalPerSeat;
        coordinatorCOPECountPerSeat           += fieldRepCOPECountPerSeat;
        coordinatorCOPECountTenPlusPerSeat    += fieldRepCOPECountTenPlusPerSeat;
        coordinatorEmpCountPerSeat            += fieldRepEmpCountPerSeat;

        coordinatorCOPETotalPerSeat_3         += fieldRepCOPETotalPerSeat_3;
        coordinatorCOPECountPerSeat_3         += fieldRepCOPECountPerSeat_3;
        coordinatorCOPECountTenPlusPerSeat_3  += fieldRepCOPECountTenPlusPerSeat_3;
        coordinatorEmpCountPerSeat_3          += fieldRepEmpCountPerSeat_3;

        coordinatorCOPETotalPerSeat_6         += fieldRepCOPETotalPerSeat_6;
        coordinatorCOPECountPerSeat_6         += fieldRepCOPECountPerSeat_6;
        coordinatorCOPECountTenPlusPerSeat_6  += fieldRepCOPECountTenPlusPerSeat_6;
        coordinatorEmpCountPerSeat_6          += fieldRepEmpCountPerSeat_6;

        coordinatorCOPETotalPerSeat_9         += fieldRepCOPETotalPerSeat_9;
        coordinatorCOPECountPerSeat_9         += fieldRepCOPECountPerSeat_9;
        coordinatorCOPECountTenPlusPerSeat_9  += fieldRepCOPECountTenPlusPerSeat_9;
        coordinatorEmpCountPerSeat_9          += fieldRepEmpCountPerSeat_9;

        coordinatorCOPETotalPerSeat_12        += fieldRepCOPETotalPerSeat_12;
        coordinatorCOPECountPerSeat_12        += fieldRepCOPECountPerSeat_12;
        coordinatorCOPECountTenPlusPerSeat_12 += fieldRepCOPECountTenPlusPerSeat_12;
        coordinatorEmpCountPerSeat_12         += fieldRepEmpCountPerSeat_12;
    }

    private void incDivisionVars() {
        divisionNewCOPETotal               += coordinatorNewCOPETotal;
        divisionNewCOPECount               += coordinatorNewCOPECount;
        divisionCOPEIncreaseTotalPerSeat   += coordinatorCOPEIncreaseTotalPerSeat;
        divisionCOPEIncreaseCountPerSeat   += coordinatorCOPEIncreaseCountPerSeat;

        divisionCOPETotalPerSeat           += coordinatorCOPETotalPerSeat;
        divisionCOPECountPerSeat           += coordinatorCOPECountPerSeat;
        divisionCOPECountTenPlusPerSeat    += coordinatorCOPECountTenPlusPerSeat;
        divisionEmpCountPerSeat            += coordinatorEmpCountPerSeat;

        divisionCOPETotalPerSeat_3         += coordinatorCOPETotalPerSeat_3;
        divisionCOPECountPerSeat_3         += coordinatorCOPECountPerSeat_3;
        divisionCOPECountTenPlusPerSeat_3  += coordinatorCOPECountTenPlusPerSeat_3;
        divisionEmpCountPerSeat_3          += coordinatorEmpCountPerSeat_3;

        divisionCOPETotalPerSeat_6         += coordinatorCOPETotalPerSeat_6;
        divisionCOPECountPerSeat_6         += coordinatorCOPECountPerSeat_6;
        divisionCOPECountTenPlusPerSeat_6  += coordinatorCOPECountTenPlusPerSeat_6;
        divisionEmpCountPerSeat_6          += coordinatorEmpCountPerSeat_6;

        divisionCOPETotalPerSeat_9         += coordinatorCOPETotalPerSeat_9;
        divisionCOPECountPerSeat_9         += coordinatorCOPECountPerSeat_9;
        divisionCOPECountTenPlusPerSeat_9  += coordinatorCOPECountTenPlusPerSeat_9;
        divisionEmpCountPerSeat_9          += coordinatorEmpCountPerSeat_9;

        divisionCOPETotalPerSeat_12        += coordinatorCOPETotalPerSeat_12;
        divisionCOPECountPerSeat_12        += coordinatorCOPECountPerSeat_12;
        divisionCOPECountTenPlusPerSeat_12 += coordinatorCOPECountTenPlusPerSeat_12;
        divisionEmpCountPerSeat_12         += coordinatorEmpCountPerSeat_12;
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

    private void setFieldRepTotal() {
        divOrgRepList[fieldRepPtr].COPETotalPerSeat__c        = fieldRepCOPETotalPerSeat;
        divOrgRepList[fieldRepPtr].COPECountPerSeat__c        = fieldRepCOPECountPerSeat;
        divOrgRepList[fieldRepPtr].COPECountTenPlusPerSeat__c = fieldRepCOPECountTenPlusPerSeat;
        divOrgRepList[fieldRepPtr].EmpCountPerSeat__c         = fieldRepEmpCountPerSeat;

        If (fieldRepCOPECountPerSeat > 0 && fieldRepEmpCountPerSeat > 0) {
        	divOrgRepList[fieldRepPtr].COPEPercent__c               = (fieldRepCOPECountPerSeat / fieldRepEmpCountPerSeat) * 100 ;
        	divOrgRepList[fieldRepPtr].UWG__c                       =  fieldRepCOPETotalPerSeat / ((fieldRepEmpCountPerSeat * 0.33) * 10) *100;
        }

        If (fieldRepCOPECountTenPlusPerSeat  > 0 && fieldRepEmpCountPerSeat > 0)
        divOrgRepList[fieldRepPtr].COPEPercentTen__c            = (fieldRepCOPECountTenPlusPerSeat / fieldRepEmpCountPerSeat)  * 100 ;

        divOrgRepList[fieldRepPtr].NewCOPETotal__c              = fieldRepNewCOPETotal;
        divOrgRepList[fieldRepPtr].NewCOPECount__c              = fieldRepNewCOPECount;
        divOrgRepList[fieldRepPtr].COPEIncreaseTotalPerSeat__c  = fieldRepCOPEIncreaseTotalPerSeat;
        divOrgRepList[fieldRepPtr].COPEIncreaseCountPerSeat__c  = fieldRepCOPEIncreaseCountPerSeat;

        /*
         newPayersList[newPayerPtr].NewCOPETotal__c           = fieldRepNewCOPETotal;
         newPayersList[newPayerPtr].NewCOPECount__c           = fieldRepNewCOPECount;

         incPayersList[incPayerPtr].Division__c               = division + ' (' + String.valueOf(incPayerCount) + ')';

         incPayersList[incPayerPtr].COPE_Increased_Total__c   = fieldRepCOPEIncreaseTotalPerSeat;
         incPayersList[incPayerPtr].COPE_Increased_Count__c   = fieldRepCOPEIncreaseCountPerSeat;
         */

        divOrgRepList[fieldRepPtr].COPETotalPerSeat_3__c        = fieldRepCOPETotalPerSeat_3;
        divOrgRepList[fieldRepPtr].COPECountPerSeat_3__c        = fieldRepCOPECountPerSeat_3;

        divOrgRepList[fieldRepPtr].COPETotalPerSeat_6__c        = fieldRepCOPETotalPerSeat_6;
        divOrgRepList[fieldRepPtr].COPECountPerSeat_6__c        = fieldRepCOPECountPerSeat_6;

        divOrgRepList[fieldRepPtr].COPETotalPerSeat_9__c        = fieldRepCOPETotalPerSeat_9;
        divOrgRepList[fieldRepPtr].COPECountPerSeat_9__c        = fieldRepCOPECountPerSeat_9;

        divOrgRepList[fieldRepPtr].COPETotalPerSeat_12__c        = fieldRepCOPETotalPerSeat_12;
        divOrgRepList[fieldRepPtr].COPECountPerSeat_12__c        = fieldRepCOPECountPerSeat_12;
    }

    private void setCoordinatorTotal() {
        divOrgRepList[coordinatorPtr].COPETotalPerSeat__c        = coordinatorCOPETotalPerSeat;
        divOrgRepList[coordinatorPtr].COPECountPerSeat__c        = coordinatorCOPECountPerSeat;
        divOrgRepList[coordinatorPtr].COPECountTenPlusPerSeat__c = coordinatorCOPECountTenPlusPerSeat;
        divOrgRepList[coordinatorPtr].EmpCountPerSeat__c         = coordinatorEmpCountPerSeat;

        If (coordinatorCOPECountPerSeat > 0 && coordinatorEmpCountPerSeat > 0) {
        	divOrgRepList[coordinatorPtr].COPEPercent__c         = (coordinatorCOPECountPerSeat / coordinatorEmpCountPerSeat)  * 100 ;
        	divOrgRepList[coordinatorPtr].UWG__c                 =  coordinatorCOPETotalPerSeat / ((coordinatorEmpCountPerSeat * 0.33) * 10) *100;
        }

        If (coordinatorCOPECountTenPlusPerSeat  > 0 && coordinatorEmpCountPerSeat > 0)
        divOrgRepList[coordinatorPtr].COPEPercentTen__c            = (coordinatorCOPECountTenPlusPerSeat / coordinatorEmpCountPerSeat)  * 100 ;

        divOrgRepList[coordinatorPtr].NewCOPETotal__c              = coordinatorNewCOPETotal;
        divOrgRepList[coordinatorPtr].NewCOPECount__c              = coordinatorNewCOPECount;
        divOrgRepList[coordinatorPtr].COPEIncreaseTotalPerSeat__c  = coordinatorCOPEIncreaseTotalPerSeat;
        divOrgRepList[coordinatorPtr].COPEIncreaseCountPerSeat__c  = coordinatorCOPEIncreaseCountPerSeat;

        /*
         newPayersList[newPayerPtr].NewCOPETotal__c           = coordinatorNewCOPETotal;
         newPayersList[newPayerPtr].NewCOPECount__c           = coordinatorNewCOPECount;

         incPayersList[incPayerPtr].Division__c               = division + ' (' + String.valueOf(incPayerCount) + ')';

         incPayersList[incPayerPtr].COPE_Increased_Total__c   = coordinatorCOPEIncreaseTotalPerSeat;
         incPayersList[incPayerPtr].COPE_Increased_Count__c   = coordinatorCOPEIncreaseCountPerSeat;
         */

        divOrgRepList[coordinatorPtr].COPETotalPerSeat_3__c        = coordinatorCOPETotalPerSeat_3;
        divOrgRepList[coordinatorPtr].COPECountPerSeat_3__c        = coordinatorCOPECountPerSeat_3;

        divOrgRepList[coordinatorPtr].COPETotalPerSeat_6__c        = coordinatorCOPETotalPerSeat_6;
        divOrgRepList[coordinatorPtr].COPECountPerSeat_6__c        = coordinatorCOPECountPerSeat_6;

        divOrgRepList[coordinatorPtr].COPETotalPerSeat_9__c        = coordinatorCOPETotalPerSeat_9;
        divOrgRepList[coordinatorPtr].COPECountPerSeat_9__c        = coordinatorCOPECountPerSeat_9;

        divOrgRepList[coordinatorPtr].COPETotalPerSeat_12__c        = coordinatorCOPETotalPerSeat_12;
        divOrgRepList[coordinatorPtr].COPECountPerSeat_12__c        = coordinatorCOPECountPerSeat_12;
    }

    private void setDivisionTotal() {
        divOrgRepList[divisionPtr].COPETotalPerSeat__c        = divisionCOPETotalPerSeat;
        divOrgRepList[divisionPtr].COPECountPerSeat__c        = divisionCOPECountPerSeat;
        divOrgRepList[divisionPtr].COPECountTenPlusPerSeat__c = divisionCOPECountTenPlusPerSeat;
        divOrgRepList[divisionPtr].EmpCountPerSeat__c         = divisionEmpCountPerSeat;

        If (divisionCOPECountPerSeat > 0 && divisionEmpCountPerSeat > 0) {
        	divOrgRepList[divisionPtr].COPEPercent__c           = (divisionCOPECountPerSeat / divisionEmpCountPerSeat) * 100 ;
        	divOrgRepList[divisionPtr].UWG__c                   = divisionCOPETotalPerSeat  / ((divisionEmpCountPerSeat * 0.33) * 10) *100;
        }

        If (divisionCOPECountTenPlusPerSeat  > 0 && divisionEmpCountPerSeat > 0)
        divOrgRepList[divisionPtr].COPEPercentTen__c            = (divisionCOPECountTenPlusPerSeat / divisionEmpCountPerSeat)  * 100 ;

        divOrgRepList[divisionPtr].NewCOPETotal__c              = divisionNewCOPETotal;
        divOrgRepList[divisionPtr].NewCOPECount__c              = divisionNewCOPECount;
        divOrgRepList[divisionPtr].COPEIncreaseTotalPerSeat__c  = divisionCOPEIncreaseTotalPerSeat;
        divOrgRepList[divisionPtr].COPEIncreaseCountPerSeat__c  = divisionCOPEIncreaseCountPerSeat;

        /*
         newPayersList[newPayerPtr].NewCOPETotal__c           = divisionNewCOPETotal;
         newPayersList[newPayerPtr].NewCOPECount__c           = divisionNewCOPECount;

         incPayersList[incPayerPtr].Division__c               = division + ' (' + String.valueOf(incPayerCount) + ')';

         incPayersList[incPayerPtr].COPE_Increased_Total__c   = divisionCOPEIncreaseTotalPerSeat;
         incPayersList[incPayerPtr].COPE_Increased_Count__c   = divisionCOPEIncreaseCountPerSeat;
         */

        divOrgRepList[divisionPtr].COPETotalPerSeat_3__c        = divisionCOPETotalPerSeat_3;
        divOrgRepList[divisionPtr].COPECountPerSeat_3__c        = divisionCOPECountPerSeat_3;

        divOrgRepList[divisionPtr].COPETotalPerSeat_6__c        = divisionCOPETotalPerSeat_6;
        divOrgRepList[divisionPtr].COPECountPerSeat_6__c        = divisionCOPECountPerSeat_6;

        divOrgRepList[divisionPtr].COPETotalPerSeat_9__c        = divisionCOPETotalPerSeat_9;
        divOrgRepList[divisionPtr].COPECountPerSeat_9__c        = divisionCOPECountPerSeat_9;

        divOrgRepList[divisionPtr].COPETotalPerSeat_12__c        = divisionCOPETotalPerSeat_12;
        divOrgRepList[divisionPtr].COPECountPerSeat_12__c        = divisionCOPECountPerSeat_12;
    }

    private String getCoordinatorName() {
        String coFn, coLn;
        coFn = copeData[rowPtr].CoordinatorFirstName__c;
        coLn = copeData[rowPtr].CoordinatorLastName__c;
        if (String.isEmpty(coFn)) coFn = '';
        if (String.isEmpty(coLn)) coLn = '';
        return coFn.trim() + ' ' + coLn.trim();
    }

    private String getFieldRepName() {
        String frFn, frLn;
        frFn = copeData[rowPtr].FieldRepFirstName__c;
        frLn = copeData[rowPtr].FieldRepLastName__c;
        if (String.isEmpty(frFn)) frFn = '';
        if (String.isEmpty(frLn)) frLn = '';
        return frFn.trim() + ' ' + frLn.trim();
    }

}