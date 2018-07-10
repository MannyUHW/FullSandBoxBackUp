(function (exports) {

  /*
   exports.ALL_CONTACT_FIELDS =
   "Id,OtherStreet,OtherCity,OtherState,OtherPostalCode,OtherAddress,OtherPhone," +
   "MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingAddress," +
   "MailingLatFormula__c,MailingLongFormula__c,Email,Gender__c,Zipcode5__c," +
   "County__c,Age__c,Probable_Language__c,LanguagePrimary__c,AccountId,Name," +
   "FirstName,LastName,MobilePhone,HomePhone,Title,Department,OwnerId,Cope_Amount__c," +
   "Leader__c,Division__c,Shift__c,FID__c,COPE_Pledge__c,Worksite__c,BU__c," +
   "GOTV_Assessment__c,GOTV_Board_Challenge__c,GOTV_Challenge_Reason__c," +
   "GOTV_Challenge__c,GOTV_Exact_Vote_Time__c,GOTV_Follow_up_3_touch_system__c," +
   "GOTV_Gettable__c,GOTV_Got_Picture__c,GOTV_Hard_Pull_Reason__c,GOTV_Hard_Pull__c," +
   "GOTV_Inside_Plan_Notes__c,GOTV_Mngt_Challange__c,GOTV_Off_Both_Days__c," +
   "GOTV_Purple_Up__c,GOTV_Shift_Scheduler__c,GOTV_Slip__c,GOTV_Special_Plan_Notes__c," +
   "GOTV_Special_Plan__c,GOTV_Took_Photo__c,GOTV_UHW_Challenge__c,GOTV_Vote_Period__c," +
   "GOTV_Vote_Yes_Petition__c,GOTV_Where_After_Voting__c,GOTV_Where_Before_Voting__c," +
   "GOTV_Works_Eday2__c,GOTV_Works_Eday_1__c,GOTV_Works_Night_Before_Eday1__c," +
   "Vote_Captain__c,Assigned_to_VC__c,Three_Touch_ST__c,Three_Touch_VC__c," +
   "Three_Touch__c,Election_Day_Voted__c,E_Day_Challenge__c,E_Day_Challenge_Reason__c," +
   "Needs_a_ride__c,Voted__c,Post_Election_Petition__c,Sticker_Up_Actions__c,soft2__c," +
   "Works_Night_Before_Eday2__c,Inside_Plan_D2__c,Employee_ID__c,Work_Phone__c," +
   "Work_Email__c,Job_Group__c,AssignedLeader__c,ID_Leaders__c,CrossMatchFacility__c," +
   "Cross_Match_CNA__c,Cross_Match_NUHW__c,Cross_Match_UHW__c,Cross_Match_UNAC__c," +
   "LOA__c,Verbal_Assessment__c,Work_Status__c,X1_1_complete__c,X1_1_set__c," +
   "Previous_Supporter_Target__c,Card_Assessment__c,New_Organizing_Signed_Card_By__c," +
   "New_Organizing_Signed_Date__c,MemberID__c,In_Current_BU__c,Is_Member_Active__c," +
   "Last_Dues_Paid_Date__c,Member_Status__c,EBoard__c,External_Leader__c," +
   "AssistantName,Enrollment_Region__c,Trgt_Home_Care_Census_Tract__c, ";
   */

  exports.init = function(initData) {
      debugger;
      var repGen = new exports.ReportGenerator(initData);
      repGen.runReport();
  };


  exports.ContactSorter = function (sortFields) {
      var self = this;
      this.comparators = sortFields.map(function (field) { return new exports.ContactComparator(field);});
      this.sort = function (a, b, comparators) {
          if (!comparators) comparators = self.comparators;
          var comp = comparators[0].compare(a,b);
          if (comp === 0 && comparators.length > 1) {
              return self.sort(a, b, comparators.slice(1));
          }
          else return comp;
      };
  };

  exports.ContactComparator = function (sortField) {
      var self = this;
      this.fieldName = sortField.Survey_Question__r ? "sq:" + sortField.Survey_Question__r.Survey_Code__c : sortField.Contact_Field_Name__c;
      this.compare = function(a,b) {
          var aVal = a[self.fieldName];
          var bVal = b[self.fieldName];
          if (aVal == bVal) {
              return 0;
          }
          else {
              // nulls go last:
              if (!aVal) {
                  return 1;
              }
              else if (!bVal) {
                  return -1;
              }
              // use natural sorting for non-nulls:
              else if (aVal < bVal) {
                  return -1;
              }
              else { // if (aVal > bVal) {
                  return 1;
              }
          }
      };
  };

// utility function
  exports.isNullOrEmpty = function(s) {
      return s == null || s == "" || s == "null";
  }

  exports.ReportGenerator = function(initData) {
      var self = this;
      var recDtStr;
      var recDt;
      var localDtStr;
      debugger;
      this.config = initData;
      if (!this.config.mapZoom) {
          this.config.mapZoom = 14;
      }
      else {
          this.config.mapZoom = parseInt(this.config.mapZoom, 10);
      }

      //add support for width and height -BB 14 Aug 2015
      if (!this.config.mapWidth) {
          this.config.mapWidth = 300;
      }
      else {
          this.config.mapWidth = parseInt(this.config.mapWidth);
      }
      if (!this.config.mapHeight) {
          this.config.mapHeight = 300;
      }
      else {
          this.config.mapHeight = parseInt(this.config.mapHeight);
      }
      //end width and height


      if (!this.config.mapGamma) {
          this.config.mapGamma = 0.2;
      }
      else {
          this.config.mapGamma = parseFloat(this.config.mapGamma);
      }
      this.conn = new jsforce.Connection({ accessToken: initData.sfSessionId, version: '34.0' });
      this.sortFields = [];
      this.queryFields = [];
      /**
       * Query SFDC for the MCL_Sort_Entry__c objects related to this report.
       */
      this.retrieveSortConfig = function(callback) {
          var query = "Select Id, Name, Contact_Field_Name__c, MCL_Report__c," +
              " Page_Break__c, Header__c, Sort_Order__c, Sort_Level__c, Survey_Question__c, " +
              " Survey_Question__r.Survey_Code__c, Survey_Question__r.Description__c " +
              " from MCL_Sort_Entry__c " +
              " where MCL_Report__c = '" + self.config.mclReportId + "' order by Sort_Level__c asc";
          console.log("sort config query: " + query);
          self.conn.query(query, function (err, result) {
              if (err) {
                  console.error("Error querying for MCL_Sort_Entry__c: " + err);
                  callback(err);
              }
              else {
                  console.debug("received sort config: " + result);
                  // shouldn't be possible, but check for duplicates just in case
                  self.sortFields = result.records;
                  self.sortFields.push({Contact_Field_Name__c : "LastName"});
                  self.sortFields.push({Contact_Field_Name__c : "FirstName"});
                  self.sortFields.push({Contact_Field_Name__c : "MiddleName"});
                  callback(null);
              }
          });
      };

      /**
       * Moves the related survey questions to direct properties of the contact.
       */
      this.transformProperties = function (contact) {
          Object.keys(contact).forEach(function (key) {
              var val = contact[key];
              if (key === "Worksite__c" && exports.isNullOrEmpty(val)) {
                  contact[key] = "Unknown Worksite";
              }
              else if (key === "Department" && exports.isNullOrEmpty(val)) {
                  contact[key] = "Unknown Department";
              }
              else if (key === "Shift__c" && exports.isNullOrEmpty(val)) {
                  contact[key] = "Unknown Shift";
              }
              else if (key === "BU__c" && exports.isNullOrEmpty(val)) {
                  contact[key] = "Unknown BU";
              }
              else if (key === 'Survey_Responses__r' && val && val.records) {
                  val.records.forEach(function (response) {
                      if (response.Response_Value__c && response.Survey_Question__r != null) {
                          contact["sq:" + response.Survey_Question__r.Survey_Code__c] = response.Response_Value__c.substring(0, 1);
                          contact["sq:" + response.Survey_Question__r.Survey_Code__c + ":Add_Info__c"] = response.Add_Info__c;
                          contact["sq:" + response.Survey_Question__r.Survey_Code__c + ":Add_Info_Control__c"] = response.Survey_Question__r.Add_Info_Control__c || '';
                          contact["sq:" + response.Survey_Question__r.Survey_Code__c + ":long"] = response.Response_Value__c;
                          contact["sq:" + response.Survey_Question__r.Survey_Code__c + ":Collected_By_Name__c"] = response.Collected_By_Name__c;
                      }
                  });
              }
              else if (key === "Owner") {
                  // flatten lookup object
                  contact["OwnerName"] = contact.Owner.Name;
              }
              else if (key.indexOf("Phone") > -1) {
                  var extension = ("" + contact[key]).match(/(.*)(x\d+)$/, "");
                  if (extension) {
                      console.log(contact[key] + " has extension: " + extension[2]);
                  }
                  var phoneNum = extension ? extension[1] : contact[key] + "";
                  var s2 = phoneNum.replace(/\D/g, '');
                  var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);
                  contact[key] = (!m) ? contact[key] : "(" + m[1] + ") " + m[2] + "-" + m[3] + (extension ? " " + extension[2] : "");
              }
              else if (key.indexOf("Verbal_Assessment__c") > -1  && !exports.isNullOrEmpty(val)) {
                  contact[key] = contact[key].trim().substring(0,1);
              } else if (key.indexOf("Build_OC_Support__c") > -1  && !exports.isNullOrEmpty(val)) {
                  contact[key] = contact[key].trim().substring(0,1);
              } else if (key == "GOTV_Exact_Vote_Time__c") {
                  if(contact[key]) {
                      recDtStr   = contact[key];
                      recDt      = new Date(recDtStr);
                      localDtStr = recDt.toLocaleString();
                      contact["GOTV_Exact_Vote_Time__c"] = localDtStr;
                  }
              }
              else if (!self.config.csv) {
                  if (val === true) {
                      contact[key] = "<i class='fa fa-check'></i>";
                  }
                  else if (val === false) {
                      contact[key] = "";
                  }
              }

          });
          return contact;
      };

      this.addQueryField = function(field) {
          if ($.inArray(field, self.queryFields) == -1) {
              self.queryFields.push(field);
          }
          return self;
      };

      // found at http://stackoverflow.com/questions/1144783/how-to-replace-all-occurrences-of-a-string-in-javascript
      function replaceAll(str, find, replace) {
          return str.replace(new RegExp(find, 'g'), replace);
      }

      this.executeReport  = function (callback) {
          /*\
           |*|
           |*|  :: cookies.js ::
           |*|
           |*|  A complete cookies reader/writer framework with full unicode support.
           |*|
           |*|  Revision #1 - September 4, 2014
           |*|
           |*|  https://developer.mozilla.org/en-US/docs/Web/API/document.cookie
           |*|  https://developer.mozilla.org/User:fusionchess
           |*|
           |*|  This framework is released under the GNU Public License, version 3 or later.
           |*|  http://www.gnu.org/licenses/gpl-3.0-standalone.html
           |*|
           |*|  Syntaxes:
           |*|
           |*|  * docCookies.setItem(name, value[, end[, path[, domain[, secure]]]])
           |*|  * docCookies.getItem(name)
           |*|  * docCookies.removeItem(name[, path[, domain]])
           |*|  * docCookies.hasItem(name)
           |*|  * docCookies.keys()
           |*|
           \*/

          var docCookies = {
              getItem: function (sKey) {
                  if (!sKey) { return null; }
                  return decodeURIComponent(document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*" + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=\\s*([^;]*).*$)|^.*$"), "$1")) || null;
              },
              setItem: function (sKey, sValue, vEnd, sPath, sDomain, bSecure) {
                  if (!sKey || /^(?:expires|max\-age|path|domain|secure)$/i.test(sKey)) { return false; }
                  var sExpires = "";
                  if (vEnd) {
                      switch (vEnd.constructor) {
                          case Number:
                              sExpires = vEnd === Infinity ? "; expires=Fri, 31 Dec 9999 23:59:59 GMT" : "; max-age=" + vEnd;
                              break;
                          case String:
                              sExpires = "; expires=" + vEnd;
                              break;
                          case Date:
                              sExpires = "; expires=" + vEnd.toUTCString();
                              break;
                      }
                  }
                  document.cookie = encodeURIComponent(sKey) + "=" + encodeURIComponent(sValue) + sExpires + (sDomain ? "; domain=" + sDomain : "") + (sPath ? "; path=" + sPath : "") + (bSecure ? "; secure" : "");
                  return true;
              },
              removeItem: function (sKey, sPath, sDomain) {
                  if (!this.hasItem(sKey)) { return false; }
                  document.cookie = encodeURIComponent(sKey) + "=; expires=Thu, 01 Jan 1970 00:00:00 GMT" + (sDomain ? "; domain=" + sDomain : "") + (sPath ? "; path=" + sPath : "");
                  return true;
              },
              hasItem: function (sKey) {
                  if (!sKey) { return false; }
                  return (new RegExp("(?:^|;\\s*)" + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=")).test(document.cookie);
              },
              keys: function () {
                  var aKeys = document.cookie.replace(/((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g, "").split(/\s*(?:\=[^;]*)?;\s*/);
                  for (var nLen = aKeys.length, nIdx = 0; nIdx < nLen; nIdx++) { aKeys[nIdx] = decodeURIComponent(aKeys[nIdx]); }
                  return aKeys;
              }
          };

          //
          // GS - Change 7/20/16:
          // originally tmplHtml.match(/\{{2,3}[A-Za-z0-9._]*\}{2,3}/g) did not have the space.
          // for some unknown reason (probably pick list related), the {{Work_Days_at_Primary_Worksite__c }} field had an extra space between the braces, causing the regEx to miss it.
          // Add a space to regEx match fixed issue.
          //
          var tmplHtml = $("#contact-template").html();
          // get query fields from bind variables in record template:
          self.queryFields = tmplHtml.match(/\{{2,3}[A-Za-z0-9._ ]*\}{2,3}/g)
              .map(function(field) { return field.replace(/[{}]/g,""); });
          if (tmplHtml.indexOf('map-mailing') > -1) {
              self.config.mailingMap = true;
              self.addQueryField("MailingLatitude").addQueryField("MailingLongitude")
                  .addQueryField('MailingStreet').addQueryField('MailingCity')
                  .addQueryField('MailingState').addQueryField('MailingPostalCode');
          }
          if (tmplHtml.indexOf('map-other') > -1) {
              self.config.otherMap = true;
              self.addQueryField("OtherLatitude").addQueryField("OtherLongitude")
                  .addQueryField('OtherStreet').addQueryField('OtherCity')
                  .addQueryField('OtherState').addQueryField('OtherPostalCode');
          }
          self.addQueryField("Id");
          // add sort fields (except survey questions) to list of query fields if not already included:
          self.sortFields.filter(function(sortField) {
              return !sortField.Survey_Question__c && $.inArray(sortField.Contact_Field_Name__c, self.queryFields) == -1;
          })
              .forEach(function (sortField) {
                  console.log("Adding " + sortField.Contact_Field_Name__c + " to query fields list");
                  self.queryFields.push(sortField.Contact_Field_Name__c);
              });

          //adding fix to eliminate duplication fields, 7th Dec 2015 -BB
          var fieldListSoql = "";
          var addedCount = 0;
          for (var qf = 0; qf < self.queryFields.length; qf++) {
              if (fieldListSoql.toLowerCase().indexOf(" " + self.queryFields[qf].toLowerCase() + ",") < 0) {
                  if (addedCount > 0) {
                      fieldListSoql += ", ";
                  }
                  fieldListSoql += self.queryFields[qf];
                  addedCount++;
              }
          }

          if (self.config.noResponsesChecked == "true") {
              console.log('Need to change SOQL here for ' + self.config.noResponsesList);
              let surveyArray = [];
              let codeList    = self.config.noResponsesList;
              let surveyList  = replaceAll(codeList,  "'", "");
              surveyList      = replaceAll(surveyList, '"', '');
              let codeArray   = surveyList.split(',');
              codeArray.forEach(function(item) {
                  if(item) surveyArray.push(item);
              });

              let surveyCodes = "'" + surveyArray.join("','") + "'";
              var query = `
              SELECT ${fieldListSoql}, 
                 ( SELECT Id, Survey_Question__r.Id, Survey_Question__r.Survey_Code__c, Survey_Question__r.Description__c, Survey_Question__r.Add_Info_Control__c, Response_Value__c, Add_Info__c, Collected_By_Name__c 
                   FROM Survey_Responses__r 
                   WHERE Survey_Question__r.Survey_Code__c NOT IN (${surveyCodes}) ) 
              FROM Contact where Account.Id = '${self.config.employer}' And 
                  Id NOT IN ( SELECT Contact__c FROM Survey_Response__c WHERE Survey_Question__r.Survey_Code__c IN (${surveyCodes}) ) `;
      //
      //  othermode -added by BB
      //
      var othermode = self.config.otherMode;
              if (othermode != null && othermode.toLowerCase().trim() == "eboardcards") {
        query = `
                SELECT ${fieldListSoql}, 
                   ( SELECT Id, Survey_Question__r.Id, Survey_Question__r.Survey_Code__c, Survey_Question__r.Description__c, Survey_Question__r.Add_Info_Control__c, Response_Value__c, Add_Info__c, Collected_By_Name__c 
                     FROM Survey_Responses__r 
                        WHERE Survey_Question__r.Survey_Code__c NOT IN (${surveyCodes}) ) 
                  FROM Contact where Executive_Body_Title__c != null and Stretch_Member_Card_Signed__c = false And 
                      Id NOT IN ( SELECT Contact__c FROM Survey_Response__c WHERE Survey_Question__r.Survey_Code__c IN (${surveyCodes}) ) `;				
      }
          }
          else {
              // same as it was
              var query = "Select " + fieldListSoql +
              ", ( Select Id, Survey_Question__r.Id, Survey_Question__r.Survey_Code__c, " +
              "Survey_Question__r.Description__c, Survey_Question__r.Add_Info_Control__c, Response_Value__c, Add_Info__c, Collected_By_Name__c from Survey_Responses__r ) " +
              " from Contact where Account.Id = '" + self.config.employer + "' ";
              //
      //  othermode -added by BB
      //
      var othermode = self.config.otherMode;
              if (othermode != null && othermode.toLowerCase().trim() == "eboardcards") {
                query = "Select " + fieldListSoql +
                  ", ( Select Id, Survey_Question__r.Id, Survey_Question__r.Survey_Code__c, " +
                  " Survey_Question__r.Description__c, Survey_Question__r.Add_Info_Control__c, Response_Value__c, Add_Info__c, Collected_By_Name__c from Survey_Responses__r ) " +
                  " from Contact where Executive_Body_Title__c != null and Stretch_Member_Card_Signed__c = false ";				
      }				
          }

          console.log("** Contact query so far ** => " + query);

          debugger;
          var printSomeCount = parseInt(docCookies.getItem('MclPrintSomeCount'));
          var printSomeIds   = docCookies.getItem('MclPrintSomeIds');
          if(printSomeCount > 0) {
              query += " And Id in " + printSomeIds ;
              console.log('Amended query: ' + query);
          }
          var whereClause = [];

          //added by BB 17th Aug 2015
          //
          if (self.config.prefilterCurrentBu == "true") {
              whereClause.push("In_Current_BU__c = true");
          }
          //
          //end of addition
          //

          //
          //added by BB 25th Aug 2015
          //
          if (self.config.prefilterReportTags != null && self.config.prefilterReportTags.trim() != "") {
              var tags = self.config.prefilterReportTags.split(",");
              var tagWhereClause = "(";
              for (var xi = 0; xi < tags.length; xi++) {
                  if (xi > 0) {
                      tagWhereClause += " OR ";
                  }
                  var tag = tags[xi].trim();
                  tagWhereClause += " Report_Tags__c like \'%" + tag + "%\' ";
              }
              tagWhereClause += ")";
              whereClause.push(tagWhereClause);
          }
          //
          //end of addition
          //

          if (self.config.selectedBUs.length) {
              whereClause.push("BU__c in (" + self.config.selectedBUs.map(function (bu) { return bu === "null" ? "null" : "'" + bu + "'";}).join(",") + ")");
          }
          if (self.config.selectedJobClasses.length) {
              whereClause.push("Title in (" + self.config.selectedJobClasses.map(function (jc) { return jc === "null" ? "null" : "'" + jc + "'";}).join(",") + ")");
          }
          if (self.config.selectedDepartments.length) {
              whereClause.push("Department in (" + self.config.selectedDepartments.map(function (d) { return d === "null" ? "null" : "'" + d + "'";}).join(",") + ")");
          }
          if (self.config.addSOQLCriteria.length) {
              whereClause.push(" (" + self.config.addSOQLCriteria + ") ");
          }
          // if additional filter fields are added, they must be appended to the where clause with the same syntax as the fields above
          if (whereClause.length) {
              query += " AND " + whereClause.join(" AND ");
          }
          var orderBy = self.sortFields
              .filter( function (sortField) { return !sortField.Survey_Question__c; }) // skip survey questions
              .map(function(sortField) { return sortField.Contact_Field_Name__c; })
              .join(",");
          if (orderBy.length) {
              query += " ORDER BY " + orderBy;
          }
          console.debug("Query = " + query);
          //alert(query);

          var records = [];
          self.conn.query(query).on("record", function(record) {
              var contact = self.transformProperties(record);
              // if a survey question filter is defined, use it to filter contacts
              if (!self.config.selectedSurveyQuestionCode || contact["sq:" + self.config.selectedSurveyQuestionCode] === self.config.selectedSurveyResponse) {
                  records.push(contact);
              }
          })
              .on("end", function(query) {
                  console.log("total in database : " + query.totalSize);
                  console.log("total fetched : " + query.totalFetched);
                  callback(null, records);
              })
              .on("error", function(err) {
                  console.error(err);
                  callback(err);
              })
              .run({ autoFetch : true, maxFetch : 4000 });
      };


      this.runReport = function () {
          $("#report-date").text(new Date().toString());
          if (!self.config.selectedSurveyQuestionId) {
              $(".report-filters-sq").hide();
          }
          async.series([
                  self.retrieveSortConfig,
                  self.executeReport
              ],
              function (err, results) {
                  if (err) {
                      console.error(error);
                  }
                  else {
                      var sorter = new exports.ContactSorter(self.sortFields);
                      console.log("Sorting " + results[1].length + " contacts ...");
                      results[1].sort(sorter.sort);
                      console.log("Sort complete.");
                      if (self.config.csv) {
                          self.generateCSV(results[1]);
                      }
                      else {
                          $("#num-records").text(results[1].length);
                          var renderer = new exports.Renderer(self.config, self.sortFields);
                          console.log("Rendering contacts ... ");
                          results[1].forEach(renderer.render);
                          console.log("Render complete.");
                          if (self.config.mailingMap || self.config.otherMap) {
                              $("#map-spinner").show();
                              renderer.mapInterval = window.setInterval(renderer.renderMaps, 2000);
                          }

                      }
                  }
              });
      };
      this.generateCSV = function (contacts) {
          var csv = Papa.unparse({fields : self.queryFields, data : contacts}, {quotes : true, delimiter : ","} );
          var link = document.createElement('a');
          var blob = new Blob([csv],{type: 'text/csv;charset=utf-8;'});
          var url = URL.createObjectURL(blob);
          link.href = url;
          var filename = "report.csv";
          link.setAttribute('download', filename);
          link.click();
      };
  };

  exports.Renderer = function (config, sortFields) {
      var self = this;
      var pageCount = 0;
      this.config = config;
      this.template = Handlebars.compile($("#contact-template").html());
      this.col = 0;
      this.row = 0;
      this.page = null;
      this.sortFields = !sortFields.length ? [] : sortFields
          .filter(function (f) { return f.Header__c || f.Page_Break__c; })
          .map(function(f) {
              if (f.Contact_Field_Name__c === 'Owner.Name') {
                  f.Contact_Field_Name__c = 'OwnerName';
              }
              return f;
          });
      this.lastRecord = null;
      this.mapQueue = [];
      this.activeGeocodeRequests = 0;
      this.mapInterval = -1;

      /*
       Sort field objects have the following keys:
       Id, Name, Contact_Field_Name__c, Report_Sort_Value__c,
       Page_Break__c, Header__c, Sort_Order__c, Sort_Level__c, Survey_Question__c
       */

      debugger;
      // check if headers need to be rendered
      this.checkHeaders = function(rec) {
          var headers = [];
          self.sortFields.forEach(function (field, i) {
              var test = field;
              var addHeader = false;
              if (!self.lastRecord || headers.length) {
                  // 1st record or higher-level header already added
                  addHeader = true;
              }
              else if (field.Survey_Question__r && rec["sq:" + field.Survey_Question__r.Survey_Code__c] !== self.lastRecord["sq:" + field.Survey_Question__r.Survey_Code__c]) {
                  // different response for a survey question sort field than previous record
                  addHeader = true;
              }
              else if (rec[field.Contact_Field_Name__c] !== self.lastRecord[field.Contact_Field_Name__c]) {
                  // different value for a regular contact field sort field
                  addHeader = true;
              }
              if (addHeader) {
                  headers.push({
                      value : field.Survey_Question__r ? field.Survey_Question__r.Description__c + ": " + rec["sq:"+field.Survey_Question__r.Survey_Code__c] : rec[field.Contact_Field_Name__c],
                      level : i,
                      pageBreak : field.Page_Break__c || false
                  });
              }
          });
          return headers;
      };

      this.renderHeaders = function (headers) {
          if (self.row >= self.config.rows-1) {
              self.newCol();
          }
          headers.forEach(function (header) {
              self.page.children(".col-" + self.col).append($("<div class='header header-" + (header.level+1) + "'>" + header.value + "</div>"));
          });
      };


      this.render = function (contact, index) {
          if (0 === index) {
              self.newPage();
          }
          var headers = self.checkHeaders(contact);
          if (headers.length) {
              if (index > 0 && headers.some(function(header) { return header.pageBreak; })) {
                  self.newPage(true);
              }
              self.renderHeaders(headers);
              var headerRows = headers.length/config.rowHeight; // divide the # of headers by the Row_Height__c property
              // console.log("headers consuming " + headerRows + " rows");
              self.row+= headerRows;
          }

          if (self.row >= self.config.rows) {
              self.newCol();
          }
          var content = $("<div class='record' onclick='javascript:navigateTo(\"/" + contact.Id + "\")' id='" + contact.Id + "'></div>").append(self.template(contact));
          self.page.children(".col-" + self.col).append(content);
          self.row++;
          self.lastRecord = contact;

          if (self.config.mailingMap) {
              self.plotAddress(contact.MailingLatitude, contact.MailingLongitude,
                  contact.MailingStreet, contact.MailingCity, contact.MailingState,
                  contact.MailingPostalCode, $("#" + contact.Id + " .map-mailing")[0]);
          }
          if (self.config.otherMap) {
              self.plotAddress(contact.OtherLatitude, contact.OtherLongitude,
                  contact.OtherStreet, contact.OtherCity, contact.OtherState,
                  contact.OtherPostalCode, $("#" + contact.Id + " .map-other")[0]);
          }
      };

      this.plotAddress = function (lat, longitude, street, city, state, zip, mapDiv, isRetry) {
          if (lat && longitude) {

              var mapUrl = "http://maps.googleapis.com/maps/api/staticmap?center" +
                  lat + "," + longitude + "&zoom=" + self.config.mapZoom + "&size=" + self.config.mapWidth + "x" + self.config.mapHeight +  "&markers=color:purple%7Clabel:S%7C" +
                  lat + "," + longitude + "&style=gamma:" + self.config.mapGamma + "&key=" + self.config.googleMapsAPIKey + "&sensor=false";

              $(mapDiv).html($("<img src='" + mapUrl + "'/>"));
              /*
               console.log("rendering map from lat/long: " + lat + "/" + longitude);
               var mapOptions = {
               zoom: self.config.mapZoom,
               mapTypeId: google.maps.MapTypeId.ROADMAP,
               center: {
               lat : lat,
               lng : longitude
               }
               };
               var map = new google.maps.Map(mapDiv, mapOptions);
               var styles = [
               { stylers : [ {gamma : self.config.mapGamma}] }
               ];
               map.setOptions({styles : styles});
               var marker = new google.maps.Marker({
               map: map,
               position: {
               lat : lat,
               lng : longitude
               }
               });
               */
          }
          else if (street && ((city & state) || zip)) {
              var req = function () {
                  geocoder = new google.maps.Geocoder();
                  var address = street + ' ' +  city + ' ' + state + ' ' + zip;
                  geocoder.geocode({ 'address': address}, function(results, status) {
                      if (status == google.maps.GeocoderStatus.OK) {
                          var mapOptions = {
                              zoom: self.config.mapZoom,
                              mapTypeId: google.maps.MapTypeId.ROADMAP,
                              center : results[0].geometry.location
                          };
                          var map = new google.maps.Map(mapDiv, mapOptions);
                          // map.setCenter(results[0].geometry.location);
                          var styles = [
                              { stylers : [ {gamma : self.config.mapGamma}] }
                          ];
                          map.setOptions({styles : styles});
                          var marker = new google.maps.Marker({
                              map: map,
                              position: results[0].geometry.location
                          });
                      }
                      else {
                          console.log("geocode status (" + address +"): " + status);
                          if (status == google.maps.GeocoderStatus.OVER_QUERY_LIMIT) {
                              // retry
                              console.log("re-trying");
                              self.plotAddress(null, null, street, city, state, zip, mapDiv, true);
                          }
                          else {
                              // remove map div from document
                              // $(mapDiv).remove();
                              $(mapDiv).text(status);
                          }
                      }
                      self.activeGeocodeRequests--;
                  });
              };
              if (isRetry) {
                  self.mapQueue.unshift(req);
              }
              else {
                  self.mapQueue.push(req);
              }
          }
          else {
              // no address info for contact; remove map div from document
              $(mapDiv).remove();
          }
      }

      this.newCol = function () {
          if (self.col === self.config.columns-1) {
              self.newPage(true);
          }
          else {
              self.col++;
              self.row = 0;
          }
      };

      this.newPage = function (hr) {
          self.page = $("<div id='page" + pageCount + "' class='page'></div>");
          for (var i=0;i<self.config.columns;i++) {
              var col = $("<div class='col col-" + i + "'></div>").css("width", (100/self.config.columns) + "%");
              self.page.append(col);
          }
          if (hr) {
              $("#report").append("<hr/>");
          }
          $("#report").append(self.page);
          self.row = 0;
          self.col = 0;
          pageCount++;
      };

      this.renderMaps = function () {
          if (self.mapQueue.length) {
              var i=0;
              while (self.mapQueue.length && i < 3) {
                  self.mapQueue.shift()();
                  i++;
              }
              self.activeGeocodeRequests+= i;
              console.log(self.activeGeocodeRequests + " active requests; " + self.mapQueue.length + " requests queued.");
          }
          else if (self.activeGeocodeRequests == 0) {
              window.clearInterval(self.mapInterval);
              console.log("All maps rendered.");
              $("#map-spinner").hide();
          }
      };

  }

  exports.checkForIE = function () {
// Returns the version of Internet Explorer or a -1
// (indicating the use of another browser).
      var rv = false;
      if (navigator.appName == 'Microsoft Internet Explorer') {
          var ua = navigator.userAgent;
          var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
          if (re.exec(ua) != null) {
              rv = parseFloat( RegExp.$1 );
          }
      }
      return rv;
  }

})(typeof exports === 'undefined'? this['ReportRenderer']={} : exports);

$(document).ready(function () {
  if (ReportRenderer.checkForIE()) {
      alert("You appear to be using MS Internet Explorer.  Please use Google Chrome or Firefox for best results.");
  }
  ReportRenderer.init(initData);
});