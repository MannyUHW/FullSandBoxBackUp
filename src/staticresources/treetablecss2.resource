table.treetable span.indenter {
  display: inline-block;
  margin: 0;
  padding: 0;
  text-align: right;

  /* Disable text selection of nodes (for better D&D UX) */
  user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -o-user-select: none;
  -webkit-user-select: none;

  /* Force content-box box model for indenter (Bootstrap compatibility) */
  -webkit-box-sizing: content-box;
  -moz-box-sizing: content-box;
  box-sizing: content-box;

  width: 19px;
}

table.treetable span.indenter a {
  background-position: left center;
  background-repeat: no-repeat;
  display: inline-block;
  text-decoration: none;
  width: 19px;
}

table.treetable tbody tr {
    border-bottom: 1px solid #95b3d7;
}
  
table.treetable tbody tr:nth-child(odd) {
    background-color: #dbe5f0;
}
  
table.treetable tbody tr:nth-child(even) td {
  border-right: 1px solid #95b3d7;
}
  
table.treetable tr *:nth-child(1), 
table.treetable tr *:nth-child(2)
 {
    text-align: left;
 }
 
#thDivision {
    text-align: Left;
	padding-left: 30px;
}

table#headerrow {
background-color:black;
}

#thDivision {
  width: 120px;
}

#thDues, #thCOPECOUNT, #thPCDues, #thCOPECOUNTTEN , #thPCTen {
  background-color: #E6FFE1;
  width: 50px;
  text-align: Right;
  padding-right: 10px;
}

#thNEWTotal, #thNewCount, #thIncTotal, #thIncCount, #thCOPETotall, #thCOPETotal3, #thCOPETotal6, #thCOPETotal9, #thCOPETotal12 {
  background-color: #CFE5CB;
  width: 60px;
  text-align: Right;
  padding-right: 10px;
}

#thCOPETotal, #thCOPECOUNT {
  background-color: #E6FFE1;
  width: 60px;
  text-align: Right;
  padding-right: 10px;
}

table.treetable  {
	text-align: right;
}

 