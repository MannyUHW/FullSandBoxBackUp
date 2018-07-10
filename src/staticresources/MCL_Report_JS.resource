(function (exports) {

    // constants:
    exports.DFLT_MAP_WIDTH = "400px";
    exports.DFLT_MAP_HEIGHT = "500px";
  
    // SFDC connection
    exports.conn = null;
  
    exports.sortFields = [
  
      {
        name: 'BU__c',
        label: 'Bargaining Unit',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Card_Assessment__c',
        label: 'Card Assessment',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Department',
        label: 'Department',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Dialysis_Employer__c',
        label: 'Dialysis Employer',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Dignity_Region__c',
        label: 'Dignity Region',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Dignity_Sub_Region__c',
        label: 'Dignity Sub Region',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Facility_Cluster__c',
        label: 'Facility Cluster',
        disabled: ko.observable(false)
      },
  
      {
        name: 'GOTV_Assess__c',
        label: 'GOTV Assessment (short)',
        disabled: ko.observable(false)
      },
  
      {
        name: 'GOTV_Assessment__c',
        label: 'GOTV Assessment',
        disabled: ko.observable(false)
      },
  
      {
        name: 'GOTVCollectedBy__c',
        label: 'GOTV Collected By',
        disabled: ko.observable(false)
      },
  
      {
        name: 'GOTV_Plan_Type__c',
        label: 'GOTV Plan Type',
        disabled: ko.observable(false)
      },
  
      {
        name: 'GOTV_Vote_Block_Time__c',
        label: 'GOTV Vote Block Time',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Hire_Date__c',
        label: 'Hire Date',
        disabled: ko.observable(false)
      },
  
      {
        name: 'ID_Leaders__c',
        label: 'Leader',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Leader_UHW_fix__c',
        label: 'Leader_UHW (fix)',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Title',
        label: 'Job Class',
        disabled: ko.observable(false)
      },
  
      {
        name: 'MailingPostalCode',
        label: 'Mailing Zip',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Owner_Name__c',
        label: 'Organizer',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Report_Sort_Value__c',
        label: 'Report Custom Sort Value',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Report_Tags__c',
        label: 'Report Tags',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Shift__c',
        label: 'Shift',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Staffing17CollectedBy__c',
        label: 'Staffing 17',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Stretch_EBoard_Leader_Name__c',
        label: 'Stretch EBoard Leader Name',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Stretch_Leader_Name__c',
        label: 'Stretch Leader Name',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Tier_1_Leader_Name__c',
        label: 'Tier 1 Leader Name',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Verbal_Assessment__c',
        label: 'Verbal Assessment',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Assigned_to_VC_Name__c',
        label: 'Vote Captain Assigned',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Worksite__c',
        label: 'Worksite',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Worksite_Add_Info__c',
        label: 'Worksite Additional Info',
        disabled: ko.observable(false)
      },
  
      {
        name: 'Vote_Captain__c',
        label: 'Vote Captain',
        disabled: ko.observable(false)
      }
  
      // {
      //     name : 'Catalist_Mailing_Zip__c',
      //     label : 'Catalist Mailing Zip',
      //     disabled : ko.observable(false)
      // },
  
    ];
  
    exports.init = function (initData) {
      exports.conn = new jsforce.Connection({ accessToken: initData.sfSessionId, version: '34.0' });
      var root = new exports.RootViewModel(initData);
      root.init(function (error) {
        if (error) {
          console.error("Error initializing: " + error);
        }
        else {
          console.log("Applying bindings");
          ko.applyBindings(root);
        }
      });
      return root;
    };
  
    exports.RootViewModel = function (initData) {
      debugger;
      var self = this;
      this.initData = initData;
      self.templateVm = new exports.TinyMCETemplateViewModel('textarea.templateEditor', initData.surveyQuestions);
      self.sortingVm = new exports.SortingViewModel(initData.mclReportId, initData.surveyQuestions, initData.sortFields);
  
      // deprecated.  survey questions are initialized from a JSON object in the HTML page
      this.retrieveSurveyQuestions = function (callback) {
        exports.conn.query("SELECT Id, Name, Survey_Code__c, Description__c, Allowed_Responses__c FROM Survey_Question__c " +
          " WHERE UHW_Campaign__c = '" + initData.campaignId + "'", function (err, result) {
            if (err) {
              console.error("Error querying for survey questions: " + err);
              callback(err);
            }
            else {
              callback(null, result.records);
            }
          });
      };
      this.init = function (callback) {
        self.filtersVm = new exports.FiltersViewModel(self.initData);
        self.filtersVm.init(callback);
      };
    };
  
    exports.FiltersViewModel = function (config) {
      var self = this;
      this.config = config;
      ko.components.register('filter-field', {
        viewModel: function (params) {
          this.error = ko.observable();
          this.label = ko.observable(params && params.label || '');
          this.options = ko.observableArray(params && params.options || []);
          this.selectedOptions = ko.observableArray(params && params.selectedOptions || []);
          this.numberDisplayed = params && params.numberDisplayed || 3;
          this.includeSelectAllOption = params && params.includeSelectAllOption || true;
          this.allSelectedText = params && params.allSelectedText || 'All';
          this.selectAllValue = params && params.selectAllValue || '_all';
          self["selected" + params.sfdcFieldName] = this.selectedOptions;
        },
        template: '<div class="form-group"> '
          + '<div data-bind="if : error()"><span data-bind="text : error"/></div>'
          + '<div data-bind="if : !error()">'
          + '<label><span data-bind="text: label"/>: </label>'
          + '<select multiple="multiple" '
          + ' data-bind="options: options, '
          + ' selectedOptions: selectedOptions, '
          + ' multiselect: { '
          + '     numberDisplayed: numberDisplayed, '
          + '     includeSelectAllOption: includeSelectAllOption, '
          + '     allSelectedText: allSelectedText, '
          + '     selectAllValue: selectAllValue, '
          + '     enableCaseInsensitiveFiltering: true '
          + '}">'
          + '</select>'
          + '</div>'
          + '</div>'
      });
      this.retrieveFilterOptions = function (fieldName, callback) {
        var opts = ["null"];
        exports.conn.query("Select " + fieldName + " from Contact where AccountId = '" + self.config.employerId +
          "' and " + fieldName + " != null GROUP BY " + fieldName)
          .on("record", function (record) {
            opts.push(record[fieldName]);
          })
          .on("error", function (error) {
            console.error("Error querying for " + fieldName + ": " + error);
            callback(error);
          })
          .on("end", function (results) {
            callback(null, opts);
          })
          .run({ autoFetch: true, maxFetch: 4000 });
      };
      /**
       * Add additional filter fields to this array to add more filter fields to the filters tab.
       * An additional argument for each new filter field will also need to be passed to the saveFilters controller method
       */
      this.filterFields = [
        {
          sfdcFieldName: "BU__c",
          label: "Bargaining Units",
          options: [],
          numberDisplayed: 2, // the number of selected options displayed in the control before it just says "n selected"
          selectedOptions: self.config.selectedBUs,
          includeSelectAllOption: true,
          allSelectedText: "All Bargaining Units",
          selectAllValue: "_all",
          enableCaseInsensitiveFiltering: true
        },
        {
          sfdcFieldName: "Title",
          label: "Job Classes",
          options: [],
          numberDisplayed: 2,
          selectedOptions: self.config.selectedJobClasses,
          includeSelectAllOption: true,
          allSelectedText: "All Job Classes",
          selectAllValue: "_all",
          enableCaseInsensitiveFiltering: true
        },
        {
          sfdcFieldName: "Department",
          label: "Departments",
          options: [],
          numberDisplayed: 2,
          selectedOptions: self.config.selectedDepartments,
          includeSelectAllOption: true,
          allSelectedText: "All Departments",
          selectAllValue: "_all",
          enableCaseInsensitiveFiltering: true
        }
      ];
      this.surveyQuestions = ko.observableArray(self.config.surveyQuestions);
      this.filterSurveyQuestion = ko.observable();
      this.surveyQuestions().forEach(function (q) {
        if (q.id === self.config.selectedSurveyQuestionId) {
          self.filterSurveyQuestion(q);
        }
      });
      this.filterSurveyResponse = ko.observable(self.config.selectedSurveyResponse);
      this.filterSurveyQuestion.subscribe(function (newVal) {
        if (!newVal) {
          self.filterSurveyResponse(null);
        }
      });
      this.allowedSurveyResponses = ko.computed(function () {
        if (self.filterSurveyQuestion()) {
          return self.filterSurveyQuestion().allowedResponses;
        }
        else return [];
      });
      this.saveFilters = function () {
        var toFilteredEscapedString = function (iterable) {
          return iterable.filter(function (s) { return s != "_all"; }).map(function (s) { return s.replace(",", "\,"); }).join(",");
        };
        // When adding new filter fields, the selected options need to be passed to the sfdcSaveFilters call below
        var buStr = toFilteredEscapedString(self.selectedBU__c());
        var jcStr = toFilteredEscapedString(self.selectedTitle());
        var deptStr = toFilteredEscapedString(self.selectedDepartment());
        var surveyQuestion = self.filterSurveyQuestion() ? self.filterSurveyQuestion().id : null;
        var surveyResponse = surveyQuestion ? self.filterSurveyResponse() : null;
        sfdcSaveFilters(buStr, jcStr, deptStr, surveyQuestion, surveyResponse);
      };
      this.saveFiltersCallback = function () {
        console.debug("Filters saved!");
      }
      this.init = function (callback) {
        // insert filter components into the filters tab for each of the filters in the self.filterFields array
        self.filterFields.forEach(function (field, index) {
          $("#filter-fields").append("<div data-bind=\"component: { " +
            "name: 'filter-field', params: filterFields[" + index + "]}\"></div>");
        });
        // query SFDC for the list of available values for each of the filter fields
        async.parallel(self.filterFields.map(function (filterField) {
          return function (callback) {
            self.retrieveFilterOptions(filterField.sfdcFieldName, function (error, options) {
              if (error) {
                filterField.error(error);
              }
              else {
                options.forEach(function (opt) { filterField.options.push(opt); });
              }
              callback();
            });
          }
        }), callback);
      };
    };
  
    exports.SortField = function (id, label, fieldName, questionId, sortOrder, header, pageBreak) {
      this.id = ko.observable(id);
      this.label = ko.observable(label);
      this.fieldName = ko.observable(fieldName);
      this.questionId = ko.observable(questionId);
      this.sortOrder = ko.observable(sortOrder);
      this.header = ko.observable(header);
      this.pageBreak = ko.observable(pageBreak);
      this.disableControls = ko.observable(false);
    };
  
    exports.SortingViewModel = function (mclReportId, surveyQuestions, sortFields) {
      var self = this;
      this.mclReportId = mclReportId;
      this.statusMessage = ko.observable();
      this.errorMessage = ko.observable();
      this.availableSortFields = ko.observableArray(exports.sortFields);
      this.sortFields = ko.observableArray();
      surveyQuestions.forEach(function (q) {
        self.availableSortFields.push({
          label: 'Q:' + q.question,
          name: q.id,
          isSurveyQuestion: true,
          disabled: ko.observable(false)
        });
      });
      this.findAvailableField = function (fieldName) {
        return self.availableSortFields().filter(function (f) { return f.name === fieldName; })[0];
      };
      sortFields.forEach(function (rec) {
        var sf;
  
        console.log('Sort Field [1] found: ' + rec.Contact_Field_Name__c);
  
        if (rec.Survey_Question__c) {
          var availableField = self.findAvailableField(rec.Survey_Question__c);
          sf = new exports.SortField(rec.Id, availableField.label, null,
            rec.Survey_Question__c, rec.Sort_Order__c, rec.Header__c, rec.Page_Break__c);
          availableField.disabled(true);
        }
        else {
          var availableField = self.findAvailableField(rec.Contact_Field_Name__c);
  
          console.log('Sort Field [2] found: ' + availableField);
  
          sf = new exports.SortField(rec.Id, availableField.label, rec.Contact_Field_Name__c,
            null, rec.Sort_Order__c, rec.Header__c, rec.Page_Break__c);
          availableField.disabled(true);
        }
        self.sortFields.push(sf);
      });
      this.setOptionDisabled = function (option, item) {
        if (item && item.name) {
          ko.applyBindingsToNode(option, { disable: item.disabled }, item);
        }
      }
      this.deletedSortFields = ko.observableArray();
      /*
       this.conn.query("Select Id, Name, Contact_Field_Name__c, MCL_Report__c," +
       " Page_Break__c, Header__c, Sort_Order__c, Sort_Level__c, Survey_Question__c " +
       " from MCL_Sort_Entry__c " +
       " where MCL_Report__c = '" + mclReportId + "' order by Sort_Level__c asc", function (err, result) {
       if (err) {
       // TODO: show error
       console.error("Error querying for MCL_Sort_Entry__c: " + err);
       }
       else {
       console.debug("received sort config: " + result);
       if (result.records) {
       result.records.forEach(function (rec) {
       var sf;
       if (rec.Survey_Question__c) {
       var availableField = self.findAvailableField(rec.Survey_Question__c);
       sf = new exports.SortField(rec.Id, availableField.label, null,
       rec.Survey_Question__c, rec.Sort_Order__c, rec.Header__c, rec.Page_Break__c);
       availableField.disabled(true);
       }
       else {
       var availableField = self.findAvailableField(rec.Contact_Field_Name__c);
       sf = new exports.SortField(rec.Id, availableField.label, rec.Contact_Field_Name__c,
       null, rec.Sort_Order__c, rec.Header__c, rec.Page_Break__c);
       availableField.disabled(true);
       }
       self.sortFields.push(sf);
       });
       }
       }
       });
       */
      this.newSortField = ko.observable(); // the selected sort field in the "add" field control section
      this.addFieldSortOrder = ko.observable();
      this.addFieldPageBreak = ko.observable();
      this.addFieldHeader = ko.observable();
      self.selectedField = ko.observable();
      this.selectField = function (data, event) {
        self.selectedField(data);
      };
      this.addField = function () {
        if (!self.newSortField()) return;
        var field;
        if (self.newSortField().isSurveyQuestion) {
          field = new exports.SortField(null, self.newSortField().label, null,
            self.newSortField().name, self.addFieldSortOrder(), self.addFieldHeader(), self.addFieldPageBreak());
        }
        else {
          field = new exports.SortField(null, self.newSortField().label, self.newSortField().name,
            null, self.addFieldSortOrder(), self.addFieldHeader(), self.addFieldPageBreak());
        }
        self.selectedField(null);
        self.sortFields.push(field);
        self.newSortField().disabled(true);
      };
      this.moveFieldUp = function () {
        var sField = self.selectedField();
        if (sField && self.sortFields.indexOf(sField) > 0) {
          var pos = self.sortFields.indexOf(sField);
          var delField = self.sortFields.splice(pos, 1)
          self.sortFields.splice(pos - 1, 0, delField[0]);
        }
      };
      this.moveFieldDown = function () {
        var sField = self.selectedField();
        if (sField && self.sortFields.indexOf(sField) < self.sortFields().length - 1) {
          var pos = self.sortFields.indexOf(self.selectedField());
          var delField = self.sortFields.splice(pos, 1)
          self.sortFields.splice(pos + 1, 0, delField[0]);
        }
      };
      this.deleteField = function () {
        var sField = self.selectedField();
        if (sField) {
          self.selectedField(null);
          self.sortFields.remove(sField);
          if (sField.id()) {
            self.deletedSortFields.push(sField);
          }
          self.findAvailableField(sField.questionId() || sField.fieldName()).disabled(false);
        }
      };
      this.saveSortConfig = function () {
        var updatedFields = [];
        var newFields = [];
        self.sortFields().forEach(function (f, i) {
          var sfdcField = {
            Contact_Field_Name__c: f.fieldName(),
            Survey_Question__c: f.questionId(),
            Page_Break__c: f.pageBreak(),
            Header__c: f.header(),
            Sort_Order__c: f.sortOrder(),
            Sort_Level__c: (i + 1)
          };
          if (f.id()) {
            // existing field to be updated
            sfdcField.Id = f.id();
            updatedFields.push(sfdcField);
          }
          else {
            // new field to be inserted
            sfdcField.MCL_Report__c = self.mclReportId;
            newFields.push(sfdcField);
          }
        });
        self.statusMessage("Saving ...");
        async.series([
          function (callback) {
            // first delete deleted fields:
            if (self.deletedSortFields().length > 0) {
              var delFields = self.deletedSortFields().map(function (f) { return f.id(); });
              exports.conn.sobject("MCL_Sort_Entry__c").destroy(delFields,
                function (err, ret) {
                  if (err) {
                    console.error("Error deleting sort fields: " + err);
                    callback(err);
                  }
                  else {
                    console.debug(delFields.length + " sort fields deleted");
                    self.deletedSortFields.removeAll();
                    callback();
                  }
                });
            }
            else callback();
          },
          function (callback) {
            // update existing fields:
            if (updatedFields.length) {
              exports.conn.sobject("MCL_Sort_Entry__c").update(updatedFields, function (err, rets) {
                if (err) {
                  console.error("Error updating sort fields: " + err);
                  callback(err);
                }
                else {
                  console.log(updatedFields.length + " sort fields updated");
                  callback();
                }
              });
            }
            else {
              callback();
            }
          },
          function (callback) {
            // insert new fields:
            if (newFields.length > 0) {
              exports.conn.sobject("MCL_Sort_Entry__c").create(newFields, function (err, rets) {
                exports
                if (err) {
                  console.error("Error inserting sort fields: " + err);
                  callback(err);
                }
                else {
                  console.debug(rets.length + " sort fields inserted");
                  // set the IDs of inserted fields
                  for (var i = 0; i < rets.length; i++) {
                    if (!rets[i].success) {
                      // TODO: show error message for failed insert record
                    }
                    else {
                      var newField = newFields[i];
                      var sortField = self.sortFields().filter(function (f) {
                        return newField.Survey_Question__c && newField.Survey_Question__c == f.questionId() ||
                          newField.Contact_Field_Name__c && newField.Contact_Field_Name__c == f.fieldName()
                      })[0];
                      sortField.id(rets[i].id);
                    }
                  }
                  callback();
                }
              });
            }
            else {
              callback();
            }
          },
        ], function (err, results) {
          self.statusMessage(undefined);
          if (err) {
            console.debug("Error saving sort config: " + err);
            self.errorMessage("Error saving sort config: " + err);
          }
          else {
            console.debug("Sort config successfully saved.");
          }
        });
  
        // sfdcSaveSortConfig(ko.toJSON(self.sortFields()));
      };
      this.saveSortCallback = function () {
        console.debug('Sort config saved');
      };
    };
  
    exports.sampleContact = {
      FirstName: 'Ted',
      LastName: 'Tester'
    };
  
    exports.TinyMCETemplateViewModel = function (textareaId, surveyQuestions) {
      var self = this;
      this.preview = ko.observable();
      this.fieldNames = {};
      this.templateErrors = ko.observableArray();
      self.updatePreview = function () {
        var templateSource = tinyMCE.activeEditor.getContent();
        var template = Handlebars.compile(templateSource);
        var html = template(exports.sampleContact);
        self.preview(html);
      };
      this.saveTemplate = function () {
        self.validateTemplate();
        if (self.templateErrors().length == 0) {
          // get editor contents with:
          tinymce.activeEditor.setProgressState(true);
          var templateContents = tinyMCE.activeEditor.getContent();
  
          //
          //start post-processing - BB Aug 14 2015
          //replace <p></p> tags with <br></br>
          templateContents = templateContents.replace(/<p>/g, "<br>");
          templateContents = templateContents.replace(/<\/p>/g, "</br>");
          tinyMCE.activeEditor.setContent(templateContents);
          //
          //end post processing
          //
  
          sfdcSaveTemplate(templateContents);
        }
      };
      this.saveTemplateCallback = function () {
        tinymce.activeEditor.setProgressState(false);
        var status = $("input.saveTemplateStatus").val();
        console.debug("status = " + status);
        if (!status) {
          console.error("template save failed");
          // TODO: figure out how to show an error in tinyMCE
        }
        else {
          console.debug("template saved");
        }
      }
      this.validateTemplate = function () {
        var content = tinyMCE.activeEditor.getContent();
        var re = /\{{2,3}([A-Za-z0-9._]*)\}{2,3}/g;
        var match;
        self.templateErrors.removeAll();
        var fixedContent = '';
        while ((match = re.exec(content)) !== null) {
          var bindVar = match[1];
          console.debug("found bind var: " + bindVar);
          var mixedCaseVar = self.fieldNames[bindVar.toLowerCase()];
          if (!mixedCaseVar) {
            // invalid field
            self.templateErrors.push("Invalid field: " + bindVar);
          }
          else if (mixedCaseVar !== bindVar) {
            // fix case
            console.debug("fixing var " + bindVar + " -> " + mixedCaseVar);
            content = content.replace(match[0], match[0].replace(bindVar, mixedCaseVar));
          }
        }
        tinyMCE.activeEditor.setContent(content);
      };
      this.makeButton = function (editor, fieldName, fieldLabel, isCheckbox) {
        self.fieldNames[fieldName.toLowerCase()] = fieldName;
        return {
          text: fieldLabel || fieldName,
          onclick: function () {
            editor.insertContent("{{" + (isCheckbox ? "{" : "") + fieldName + (isCheckbox ? "}" : "") + "}}");
          }
        };
      };
      tinymce.init({
        selector: textareaId,
        /* width : 533, */
        height: 400,
        plugins: 'table preview nonbreaking textcolor code',
        toolbar: "insertSFDCField fontsizeselect forecolor save contactPreview",
        fontsize_formats: "6pt 8pt 9pt 10pt 12pt 14pt 18pt 24pt 36pt",
        init_instance_callback: function (editor) {
          self.updatePreview();
        },
        setup: function (editor) {
          editor.addButton('insertSFDCField', {
            type: 'menubutton',
            text: 'Insert Field',
            icon: false,
            menu: [
              {
                text: 'Contact Info',
                menu: [
                  self.makeButton(editor, 'AccountId'),
                  self.makeButton(editor, 'Age__c', 'Age'),
                  self.makeButton(editor, 'ID', 'Contact Id'),
                  self.makeButton(editor, 'Email'),
                  self.makeButton(editor, 'Ethnicity__c', 'Ethnicity'),
                  self.makeButton(editor, 'FirstName'),
                  self.makeButton(editor, 'Gender__c', 'Gender'),
                  self.makeButton(editor, 'DoNotCall', 'Do Not Call', true),
                  self.makeButton(editor, 'HomePhone'),
                  self.makeButton(editor, 'Elist_Street__c', 'Elist Street'),
                  self.makeButton(editor, 'Elist_City__c', 'Elist City'),
                  self.makeButton(editor, 'Elist_State__c', 'Elist State'),
                  self.makeButton(editor, 'Elist_Zip__c', 'Elist Zip'),
                  self.makeButton(editor, 'Elist_Email__c', 'Elist Email'),
                  self.makeButton(editor, 'Elist_Phone__c', 'Elist Phone'),
                  self.makeButton(editor, 'LanguagePrimary__c', 'LanguagePrimary'),
                  self.makeButton(editor, 'LastName'),
                  self.makeButton(editor, 'MailingCity'),
                  self.makeButton(editor, 'MailingLatFormula__c', 'MailingLatFormula'),
                  self.makeButton(editor, 'MailingLongFormula__c', 'MailingLongFormula'),
                  self.makeButton(editor, 'MailingPostalCode'),
                  self.makeButton(editor, 'MailingState'),
                  self.makeButton(editor, 'MailingStreet'),
                  {
                    text: 'Map: Mailing Address',
                    onclick: function () {
                      editor.insertContent("<div class='map map-mailing' style='width: "
                        + exports.DFLT_MAP_WIDTH + ";height: " + exports.DFLT_MAP_HEIGHT + "'>[map : MailingAddress]</div>");
                    }
                  },
                  {
                    text: 'Map: Other Address',
                    onclick: function () {
                      editor.insertContent("<div class='map map-other' style='width: "
                        + exports.DFLT_MAP_WIDTH + ";height: " + exports.DFLT_MAP_HEIGHT + "'>[map: OtherAddress]</div>");
                    }
                  },
                  self.makeButton(editor, 'MiddleName'),
                  self.makeButton(editor, 'MobilePhone'),
                  self.makeButton(editor, 'Name'),
                  self.makeButton(editor, 'OtherPhone'),
                  self.makeButton(editor, 'Owner_Name__c', 'Owner Name'),
                  self.makeButton(editor, 'OwnerId'),
                  self.makeButton(editor, 'Division__c', 'Parent Account'),
                  self.makeButton(editor, 'Phone'),
                  self.makeButton(editor, 'Probable_Language__c', 'Probable Language'),
                  self.makeButton(editor, 'Report_Sort_Value__c', 'Report Custom Sort Value')
                ]
              },
              {
                text: 'GOTV',
                menu: [
                  self.makeButton(editor, 'Assigned_to_VC__r.Name', 'Assigned to VC'),
                  self.makeButton(editor, 'GOTV_Board_Challenge__c', 'Board Challenge', true),
                  self.makeButton(editor, 'GOTVCollectedBy__c', 'GOTV Collected By'),
                  self.makeButton(editor, 'E_Day_Challenge__c', 'E Day Challenge'),
                  self.makeButton(editor, 'E_Day_Challenge_Reason__c', 'E-Day Challenge Reason'),
                  self.makeButton(editor, 'Election_Day_Voted__c', 'Election Day: Voted', true),
                  self.makeButton(editor, 'GOTV_Exact_Vote_Local_Time__c', 'Exact Vote Local-Time'),
                  self.makeButton(editor, 'GOTV_Exact_Vote_Time__c', 'Exact Vote Time'),
                  self.makeButton(editor, 'GOTV_Follow_up_3_touch_system__c', 'Follow up 3 touch system'),
                  self.makeButton(editor, 'GOTV_Gettable__c', 'Gettable', true),
                  self.makeButton(editor, 'GOTV_Assessment__c', 'GOTV Assessment'),
                  self.makeButton(editor, 'GOTV_Assess__c', 'GOTV Assessment (short)'),
                  self.makeButton(editor, 'GOTV_Card_Signed_Date__c', 'GOTV Card Signed Date'),
                  self.makeButton(editor, 'GOTV_Challenge__c', 'GOTV Challenge'),
                  self.makeButton(editor, 'GOTV_Challenge_Reason__c', 'GOTV Challenge Reason'),
                  self.makeButton(editor, 'GOTV_Got_Picture__c', 'GOTV Got Picture', true),
                  self.makeButton(editor, 'GOTV_Purple_Up__c', 'GOTV Purple Up', true),
                  self.makeButton(editor, 'Reconfirmed_GOTV__c', 'GOTV Reconfirmed', true),
                  self.makeButton(editor, 'GOTV_Vote_Block_Time__c', 'GOTV Vote Block Time', true),
                  self.makeButton(editor, 'GOTV_Hard_Pull__c', 'Hard Pull', true),
                  self.makeButton(editor, 'GOTV_Hard_Pull_Reason__c', 'Hard Pull Reason'),
                  self.makeButton(editor, 'Plan_Type_Notes__c', 'Plan Type Notes'),
                  self.makeButton(editor, 'GOTV_Inside_Plan_Notes__c', 'Inside Plan D1'),
                  self.makeButton(editor, 'Inside_Plan_D2__c', 'Inside Plan D2'),
                  self.makeButton(editor, 'GOTV_Mngt_Challange__c', 'Mngt Challange', true),
                  self.makeButton(editor, 'Needs_a_ride__c', 'Needs a ride', true),
                  self.makeButton(editor, 'GOTV_Off_Both_Days__c', 'Off Both Days', true),
                  self.makeButton(editor, 'GOTV_Outside_Plan__c', 'Outside Plan'),
                  self.makeButton(editor, 'GOTV_Plan_Type__c', 'Plan Type'),
                  self.makeButton(editor, 'Post_Election_Petition__c', 'Post Election Petition'),
                  self.makeButton(editor, 'Power_Party__c', 'Power Party', true),
                  self.makeButton(editor, 'GOTV_Shift_Scheduler__c', 'Shift Scheduler'),
                  self.makeButton(editor, 'GOTV_Slip__c', 'Slip', true),
                  self.makeButton(editor, 'GOTV_Special_Plan__c', 'Special Plan', true),
                  self.makeButton(editor, 'GOTV_Special_Plan_Notes__c', 'Special Plan Notes'),
                  self.makeButton(editor, 'Sticker_Up_Actions__c', 'Sticker Up Actions'),
                  self.makeButton(editor, 'Three_Touch__c', 'Three Touch: OB', true),
                  self.makeButton(editor, 'Three_Touch_ST__c', 'Three Touch:  ST', true),
                  self.makeButton(editor, 'Three_Touch_VC__c', 'Three Touch :VC', true),
                  self.makeButton(editor, 'GOTV_Took_Photo__c', 'Took Photo', true),
                  self.makeButton(editor, 'GOTV_UHW_Challenge__c', 'UHW Challenge', true),
                  self.makeButton(editor, 'Vote_Captain__c', 'Vote Captain', true),
                  self.makeButton(editor, 'GOTV_Vote_Period__c', 'Vote Period'),
                  self.makeButton(editor, 'GOTV_Vote_Yes_Petition__c', 'Vote Yes Petition'),
                  self.makeButton(editor, 'Voted__c', 'Voted', true),
                  self.makeButton(editor, 'GOTV_Where_After_Voting__c', 'Where After Voting'),
                  self.makeButton(editor, 'GOTV_Where_Before_Voting__c', 'Where Before Voting'),
                  self.makeButton(editor, 'GOTV_Works_Eday_1__c', 'Works Eday 1', true),
                  self.makeButton(editor, 'GOTV_Works_Eday2__c', 'Works Eday2', true),
                  self.makeButton(editor, 'GOTV_Works_Night_Before_Eday1__c', 'Works Night Before Eday1', true),
                  self.makeButton(editor, 'Works_Night_Before_Eday2__c', 'Works Night Before Eday2', true),
                  self.makeButton(editor, 'Worksite_Add_Info__c', 'Worksite Additional Info')
                ]
              },
              {
                text: 'Job Info',
                menu: [
                  self.makeButton(editor, 'Employer_ID__c', '4 Digit Employer Id'),
                  self.makeButton(editor, 'BU__c', 'BU_UHW'),
                  self.makeButton(editor, 'Department'),
                  self.makeButton(editor, 'Employee_ID__c', 'Employee ID'),
                  self.makeButton(editor, 'Hire_Date__c', 'Hire Date'),
                  self.makeButton(editor, 'Job_Group__c', 'Job Group'),
                  self.makeButton(editor, 'JobScheduling__c', 'Job Scheduling'),
                  self.makeButton(editor, 'Account.Phase_6_Picket__c', 'Phase 6 Picket'),
                  self.makeButton(editor, 'Shift__c', 'Shift'),
                  self.makeButton(editor, 'Title'),
                  self.makeButton(editor, 'Work_Days_at_Primary_Worksite__c', 'Work days'),
                  self.makeButton(editor, 'Work_Email__c', 'Work Email'),
                  self.makeButton(editor, 'Work_Phone__c', 'Work Phone'),
                  self.makeButton(editor, 'Worksite__c', 'Worksite'),
                  self.makeButton(editor, 'Worksite_Add_Info__c', 'Worksite Additional Info'),
                  self.makeButton(editor, 'Worksite__c', 'Worksite_UHW')
                ]
              },
              {
                text: 'Community ',
                menu: [
                  self.makeButton(editor, 'Car_Has_Access__c', 'Car has access', true),
                  self.makeButton(editor, 'Car_Has_License__c', 'Car has license', true),
                  self.makeButton(editor, 'Coming_to_Meeting__c', 'Coming to Meeting'),
                  self.makeButton(editor, 'Community_Contact_Source__c', 'Community Contact Source'),
                  self.makeButton(editor, 'Community_Employer_Name__c', 'Community Employer Name'),
                  self.makeButton(editor, 'Community_Ethnicity__c', 'Community Ethnicity'),
                  self.makeButton(editor, 'Community_Former_Home_Care__c', 'Community Former Home Care', true),
                  self.makeButton(editor, 'Community_Former_Home_Care_Id__c', 'Community Former Home Care Id'),
                  self.makeButton(editor, 'Community_Leader_Id__c', 'Community Leader Id'),
                  self.makeButton(editor, 'Community_No_Email__c', 'Community No Email', true),
                  self.makeButton(editor, 'Community_Region__c', 'Community Region'),
                  self.makeButton(editor, 'Coordinator__c', 'Coordinator'),
                  self.makeButton(editor, 'Organizer_1__c', 'Organizer 1'),
                  self.makeButton(editor, 'Devices_Owns__c', 'Owns Devices'),
                  self.makeButton(editor, 'Regional_Director__c', 'Regional Director'),
                  self.makeButton(editor, 'Related_Contact__c', 'Related Contact'),
                  self.makeButton(editor, 'Related_Contact_How__c', 'Related Contact How')
                ]
              },
              {
                text: 'New Organizing',
                menu: [
                  self.makeButton(editor, 'X1_1_complete__c', '1:1 complete', true),
                  self.makeButton(editor, 'X1_1_set__c', '1:1 set'),
                  self.makeButton(editor, 'Argue_Out_Reason__c', 'Argue Out Reason'),
                  self.makeButton(editor, 'Assignment_Given__c', 'Assignment Given', true),
                  self.makeButton(editor, 'Attended_Auth_Launch__c', 'Attended Auth Launch', true),
                  self.makeButton(editor, 'Bargaining_Survey__c', 'Bargaining Survey', true),
                  self.makeButton(editor, 'Build_OC_Support__c', 'Build OC Support'),
                  self.makeButton(editor, 'Captain__c', 'Captain', true),
                  self.makeButton(editor, 'Card_Assessment__c', 'Card Assessment'),
                  self.makeButton(editor, 'Card_Assess__c', 'Card Assessment (Short)'),
                  self.makeButton(editor, 'New_Org_Card_Signed_By__r.Name', 'Card Signed By'),
                  self.makeButton(editor, 'Card_Type__c', 'Card Type'),
                  self.makeButton(editor, 'Coworker_IDd_as_Leader__c', 'Coworker IDd as Leader', true),
                  self.makeButton(editor, 'Coworker_Name__r.Name', 'Coworker Name'),
                  self.makeButton(editor, 'Cross_Match_CNA__c', 'Cross-Match CNA', true),
                  self.makeButton(editor, 'Cross_Match_NUHW__c', 'Cross-Match NUHW', true),
                  self.makeButton(editor, 'Cross_Match_UHW__c', 'Cross-Match UHW', true),
                  self.makeButton(editor, 'Cross_Match_UNAC__c', 'Cross-Match UNAC', true),
                  self.makeButton(editor, 'CrossMatchFacility__c', 'CrossMatchFacility'),
                  self.makeButton(editor, 'Dialysis_Build_OC__c', 'Dialysis Build OC Support'),
                  self.makeButton(editor, 'Dialysis_Employer__c', 'Dialysis Employer'),
                  self.makeButton(editor, 'Division__c', 'Division', true),
                  self.makeButton(editor, 'Dialysis_Phases__c', 'Dialysis Phases'),
                  self.makeButton(editor, 'Funding_17__c', 'Funding 17'),
                  self.makeButton(editor, 'ID_Leaders__c', 'ID Leaders_UHW', true),
                  self.makeButton(editor, 'Inoculated__c', 'Inoculated', true),
                  self.makeButton(editor, 'Leader__c', 'Leader', true),
                  self.makeButton(editor, 'AssignedLeader__r.Name', 'Leader_UHW'),
                  self.makeButton(editor, 'Lic_List_Phone__c', 'License List Phone'),
                  self.makeButton(editor, 'LOA__c', 'LOA', true),
                  self.makeButton(editor, 'New_Organizing_Signed_Card_By__c', 'New Organizing Signed Card By'),
                  self.makeButton(editor, 'New_Organizing_Signed_Date__c', 'New Organizing Signed Date'),
                  self.makeButton(editor, 'OC_Member__c', 'OC Member', true),
                  self.makeButton(editor, 'Photo_Release_Signed__c', 'Photo Release Signed', true),
                  self.makeButton(editor, 'Previous_Supporter_Target__c', 'Previous Supporter - Target', true),
                  self.makeButton(editor, 'Purple_UP__c', 'Purple Up'),
                  self.makeButton(editor, 'Dignity_Region__c', 'Region'),
                  self.makeButton(editor, 'Schedule_In_Hand__c', 'Schedule In Hand', true),
                  self.makeButton(editor, 'Spot_Check__c', 'Spot Check'),
                  self.makeButton(editor, 'Dignity_Sub_Region__c', 'Sub Region'),
                  self.makeButton(editor, 'Staffing_17__c', 'Staffing 17'),
                  self.makeButton(editor, 'Testimonial_ST_17__c', 'Testimonial ST 17'),
                  self.makeButton(editor, 'Time_Date_per_OC__c', 'Time Date per OC'),
                  self.makeButton(editor, 'Verbal_Assessment__c', 'Verbal Assessment_UHW'),
                  self.makeButton(editor, 'Work_Days_at_Primary_Worksite__c', 'Work Days at Primary Worksite'),
                  self.makeButton(editor, 'Work_Status__c', 'Work Status')
                ]
              },
              {
                text: 'Membership',
                menu: [
                  self.makeButton(editor, 'COPE_Pledge__c', 'COPE Pledge'),
                  self.makeButton(editor, 'CopePledgeDate__c', 'COPE Pledge Date'),
                  self.makeButton(editor, 'In_Current_BU__c', 'In Current BU', true),
                  self.makeButton(editor, 'Job_Paid_Status__c', 'Job Paid Status'),
                  self.makeButton(editor, 'Cope_Payment_Date__c', 'Last COPE Date'),
                  self.makeButton(editor, 'Cope_Amount__c', 'Last COPE Payment'),
                  self.makeButton(editor, 'Last_Dues_Paid_Date__c', 'Last Dues Paid Date'),
                  self.makeButton(editor, 'Member_Status__c', 'Member Status'),
                  self.makeButton(editor, 'MemberID__c', 'MemberID'),
                  self.makeButton(editor, 'Verified_Membership_Card_Date__c', 'Verified Date MC')
                ]
              },
              {
                text: 'Leadership',
                menu: [
                  self.makeButton(editor, 'EBoard__c', 'EBoard'),
                  self.makeButton(editor, 'External_Leader__c', 'External Leader_UHW'),
                  self.makeButton(editor, 'Stretch_EBoard_Leader_Name__c', 'Stretch EBoard Leader Name'),
                  self.makeButton(editor, 'Stretch_Leader_Name__c', 'Stretch Leader Name'),
                  self.makeButton(editor, 'Stretch_Leader__r.Name', 'Leader Name only'),
                  self.makeButton(editor, 'Tier_1_Leader_Name__c', 'Tier 1 Leader Name')
                ]
              },
              {
                text: 'E-Signed Card ',
                menu: [
                  self.makeButton(editor, 'Received_eCard_From__c', 'Received From'),
                  self.makeButton(editor, 'E_Signed_Card__r.Added_To_Contact__c', 'Added To Contact', true),
                  self.makeButton(editor, 'E_Signed_Card__r.Agree__c', 'Agree', true),
                  self.makeButton(editor, 'E_Signed_Card__r.Agreed_To__c', 'Agreed To'),
                  self.makeButton(editor, 'E_Signed_Card__r.Cell_Phone__c', 'Cell Phone', true),
                  self.makeButton(editor, 'E_Signed_Card__r.City__c', 'City'),
                  self.makeButton(editor, 'E_Signed_Card__r.CP__c', 'CP'),
                  self.makeButton(editor, 'E_Signed_Card__r.Date_of_Hire__c', 'Date of Hire'),
                  self.makeButton(editor, 'E_Signed_Card__r.Date_Union_Authorization_Submitted__c', 'Date Union Authorization Submitted'),
                  self.makeButton(editor, 'E_Signed_Card__r.Department__c', 'Department'),
                  self.makeButton(editor, 'E_Signed_Card__r.Name', 'ECard Name'),
                  self.makeButton(editor, 'E_Signed_Card__r.Email__c', 'Email'),
                  self.makeButton(editor, 'E_Signed_Card__r.Employer__c', 'Employer'),
                  self.makeButton(editor, 'E_Signed_Card__r.E_Signed_Card_Notes__c', 'E-Signed Card Notes'),
                  self.makeButton(editor, 'E_Signed_Card__r.First_Name__c', 'First Name'),
                  self.makeButton(editor, 'E_Signed_Card__r.Home_Phone__c', 'Home Phone', true),
                  self.makeButton(editor, 'E_Signed_Card__r.Hourly_Wage__c', 'Hourly Wage'),
                  self.makeButton(editor, 'E_Signed_Card__r.HP__c', 'HP'),
                  self.makeButton(editor, 'E_Signed_Card__r.Job_Title__c', 'Job Title'),
                  self.makeButton(editor, 'E_Signed_Card__r.Last_Name__c', 'Last Name'),
                  self.makeButton(editor, 'E_Signed_Card__r.Lead__c', 'Lead'),
                  self.makeButton(editor, 'E_Signed_Card__r.Lead_Id__c', 'Lead Id'),
                  self.makeButton(editor, 'E_Signed_Card__r.Lead_Source__c', 'Lead Source'),
                  self.makeButton(editor, 'E_Signed_Card__r.Leads_Record_Link__c', 'Leads Record Link'),
                  self.makeButton(editor, 'E_Signed_Card__r.Mobile__c', 'Mobile'),
                  self.makeButton(editor, 'E_Signed_Card__r.Notify_Email_Address__c', 'Notify Email Address'),
                  self.makeButton(editor, 'E_Signed_Card__r.Other_Department__c', 'Other Department'),
                  self.makeButton(editor, 'E_Signed_Card__r.Phone__c', 'Phone'),
                  self.makeButton(editor, 'E_Signed_Card__r.Record_Link__c', 'Record Link'),
                  self.makeButton(editor, 'E_Signed_Card__r.State__c', 'State'),
                  self.makeButton(editor, 'E_Signed_Card__r.Street__c', 'Street'),
                  self.makeButton(editor, 'E_Signed_Card__r.Work_Shift__c', 'Work Shift'),
                  self.makeButton(editor, 'E_Signed_Card__r.Zip_Code__c', 'Zip Code')
                ]
              },
              {
                text: 'Stretch',
                menu: [
                  self.makeButton(editor, 'Stretch_Dept_Ldr_Nominee_P4__c', 'Dept Ldr Nominee P4'),
                  self.makeButton(editor, 'Stretch_EBoard_Leader_Name__c', 'R&S EBoard Name'),
                  self.makeButton(editor, 'Stretch_Ldr_Promotion_Status__c', 'R&S Ldr Promotion Status'),
                  self.makeButton(editor, 'Stretch_Ldr_Run_By_EBoard__c', 'R&S Ldr Run By EBoard', true),
                  self.makeButton(editor, 'Stretch_Leader__c', 'R&S Leader'),
                  self.makeButton(editor, 'Stretch_Leader_Employer_Name__c', 'R&S Leader Employer Name'),
                  self.makeButton(editor, 'Stretch_Leader_Name__c', 'R&S Leader Name'),
                  self.makeButton(editor, 'Stretch_Member_Card_Signed__c', 'R&S Member Card Signed', true),
                  self.makeButton(editor, 'Stretch_Member_Card_Upload_Date__c', 'R&S Member Card Upload Date'),
                  self.makeButton(editor, 'Stretch_Same_Facility__c', 'R&S Same Facility', true),
                  self.makeButton(editor, 'Stretch_Team_Intake_Phase__c', 'R&S Team Intake Phase'),
                  self.makeButton(editor, 'Stretch_Team_Participation__c', 'R&S Team Participation')
                ]
              },
              {
                text: 'Other',
                menu: [
                  self.makeButton(editor, 'Activist__c', 'Activist', true),
                  self.makeButton(editor, 'AssistantName'),
                  self.makeButton(editor, 'DoNotCall', 'Do Not Call', true),
                  self.makeButton(editor, 'Enrollment_Region__c', 'Enrollment Region'),
                  self.makeButton(editor, 'Facility_Cluster__c', 'Facility Cluster'),
                  self.makeButton(editor, 'Notes_Consolidated__c', 'Notes (Consolidated)'),
                  self.makeButton(editor, 'Field_Work_Notes__c', 'Notes (UHW/Field Work)'),
                  self.makeButton(editor, 'Report_Tags__c', 'Report Tags'),
                  self.makeButton(editor, 'Trgt_Home_Care_Census_Tract__c', 'Trgt Home Care Census Tract'),
                  self.makeButton(editor, 'Collected_By__r.Name', 'Collected By')
                ]
              },
              {
                text: 'Survey Questions',
                menu: !surveyQuestions ? [] : surveyQuestions.map(function (q) {
                  return self.makeButton(editor, "sq:" + q.code, q.question + " [" + q.code + "]");
                })
              },
              {
                text: 'To Be Removed',
                menu: [
                  self.makeButton(editor, 'Catalist_Mailing_Street__c'),
                  self.makeButton(editor, 'Catalist_Mailing_City__c'),
                  self.makeButton(editor, 'Catalist_Mailing_State__c'),
                  self.makeButton(editor, 'Catalist_Mailing_Zip__c'),
                  self.makeButton(editor, 'Catalist_Voting_Street__c'),
                  self.makeButton(editor, 'Catalist_Voting_City__c'),
                  self.makeButton(editor, 'Catalist_Voting_State__c'),
                  self.makeButton(editor, 'Catalist_Voting_Zip__c'),
                  self.makeButton(editor, 'Catalist_Phone__c'),
                  self.makeButton(editor, 'Chapman_Vote_Blocks__c', 'Chapman Vote Blocks'),
                  self.makeButton(editor, 'Children_s_Vote_Block__c', 'Childrens Hosp Vote Block'),
                  self.makeButton(editor, 'Addresses_Consolidated__c', 'Consolidated Addresses'),
                  self.makeButton(editor, 'County__c', 'County'),
                  self.makeButton(editor, 'Elist_Street__c', 'Elist Street'),
                  self.makeButton(editor, 'Elist_City__c', 'Elist City'),
                  self.makeButton(editor, 'Elist_State__c', 'Elist State'),
                  self.makeButton(editor, 'Elist_Zip__c', 'Elist Zip'),
                  self.makeButton(editor, 'Elist_Email__c', 'Elist Email'),
                  self.makeButton(editor, 'Elist_Phone__c', 'Elist Phone'),
                  self.makeButton(editor, 'OtherStreet'),
                  self.makeButton(editor, 'OtherCity'),
                  self.makeButton(editor, 'OtherState'),
                  self.makeButton(editor, 'OtherPostalCode'),
                  self.makeButton(editor, 'soft2__c', 'Soft 2', true),
                  self.makeButton(editor, 'Zipcode5__c', 'Zipcode5')
                ]
              }
            ]
          });
          editor.addButton('contactPreview', {
            text: 'Preview Contact',
            icon: false,
            onclick: self.updatePreview
          });
          editor.addButton('save', {
            text: 'Save',
            icon: false,
            onclick: self.saveTemplate
          });
        }
      });
    };
  
    // deprecated.  use TinyMCETemplateViewModel instead
    exports.TableTemplateViewModel = function () {
      var table = [];
      var self = this;
      var nCols = 1; // TODO: init nCols from template data
      this.makeDroppableColumn = function () {
        var td = $("<td></td>").droppable({
          drop: function (event, ui) {
            console.debug("drop!");
            $(this).append(ui.draggable);
          }
        });
        return td;
      };
      this.addRow = function () {
        var row = [];
        var tr = $("<tr></tr>");
        for (var i = 0; i < nCols; i++) {
          row.push([]);
          var td = self.makeDroppableColumn();
          tr.append(td);
        }
        $("#template-table tbody").append(tr);
      };
      this.addColumn = function () {
        nCols++;
        $("#template-table > tbody > tr").append(self.makeDroppableColumn());
        table.forEach(function (row) { row.push([]); });
      };
      this.init = function () {
        // TODO: should initialize template-table with needed rows/cols
        $(".field-container").droppable({
          drop: function (event, ui) {
            $(this).append(ui.draggable);
          }
        });
        $(".template-field").draggable({
          containment: "#template-container",
          helper: "clone"
        });
      };
    };
  
    exports.debugContactFields = function () {
      exports.conn.metadata.read('CustomObject', 'Contact', function (err, metadata) {
        if (err) {
          console.error(err);
        }
        else {
          metadata.fields.forEach(function (field) {
            console.log("self.makeButton(editor, '" + field.fullName + "'" + (field.label ? ", '" + field.label + "'" : "") + "),");
          });
        }
      });
    };
  
  })(typeof exports === 'undefined' ? this['ReportConfigurator'] = {} : exports);
  
  var root;
  $(document).ready(function () {
    root = ReportConfigurator.init(initData);
  });
  