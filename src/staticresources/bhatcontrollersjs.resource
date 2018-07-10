
/* Controllers */

var bhatModule = angular.module('bhat.controllers', []);

bhatModule
  .controller('MyCtrl1', ['$scope', 'doubleMe', function($scope, doubleMe) {

  	$scope.sfdcResult = '_____';

  	doubleMe(10).then(function(result) {$scope.example1 = result;})
  	doubleMe('ten').then(function(result) {$scope.example2 = result;})


  	$scope.askSFDC = function(input){
  		doubleMe(input).then(function(result) {$scope.sfdcResult = result;},
                           function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;}
  							          )
  	};
 

 	
  }])


  .controller('MainCtrl', ['$scope', '$rootScope', 'getActivityList', 'setrootScopoeVariables', 'GetBhatGlobalData', function($scope, $rootScope, getActivityList, setrootScopoeVariables, GetBhatGlobalData) {

 		setrootScopoeVariables();
 		$rootScope.rsv_BhatGlobalData= [];
 		$rootScope.rsv_isActivitySingle= false;
 		$rootScope.rsv_SelectedActivityAtMView=[] ;
 		$rootScope.rsv_BhatActivityCount = 12;
 		$rootScope.rsv_BhatActivityNewCount = 12;
		$rootScope.rsv_DailyEntryCurrentACItem = [];

 		GetBhatGlobalData().then(function(result) {
 							$rootScope.rsv_BhatGlobalData = JSON.parse(result.replace(/&quot;/g,'"'));
 							
 						   $rootScope.rsv_DailyEntryCurrentACItem =  $rootScope.rsv_BhatGlobalData.BHATActivityCodeList[0];
 						   
							for (var i = 0; i < $rootScope.rsv_BhatGlobalData.BHATActivityNotesList.length; i++) 
			 				{
			 					if ($rootScope.rsv_BhatGlobalData.BHATActivityNotesList[i].Activity_Note_Description == 'None')
			 					{
			 						$rootScope.rsv_BhatGlobalData.BHATActivityNotesList[i].Id ='';
			 					}	
			 				}					 			 				
 						
 						},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
 		
 		
  		$rootScope.activityList1 =[];
 	
 		/*getActivityList().then(function(result) {$rootScope.activityList1 = JSON.parse(result.replace(/&quot;/g,'"'));},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
                         */
 	
  }])
  
  

.controller('ctrlActivitySummary', ['$scope', '$rootScope', '$filter', '$location', '$http', '$log', 'doubleMe', 'GetActivitySummary', 'setrootScopoeVariables',

    function ($scope, $rootScope, $filter, $location, $http, $log, doubleMe, GetActivitySummary, setrootScopoeVariables) {
        // init
        $scope.sortingOrder = sortingOrder;
        $scope.reverse = false;
        $scope.filteredItems = [];
        $scope.groupedItems = [];
        $scope.itemsPerPage = 7;
        $scope.pagedItems = [];
        $scope.currentPage = 0;
        $scope.sv_activitySummaryList =[];
        //alert('1');
        
        $scope.sfdcResult = '_____';
        
        //alert($scope.sfdcResult);
        
        setrootScopoeVariables();
        
        
        
 		$scope.askSFDC = function(input){
  				doubleMe(input).then(function(result) {$scope.sfdcResult = result;},
                           function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;}
  							          )
  		};
 
 		GetActivitySummary($rootScope.SelectedweekStartDate.toUTCString﻿()).then(function(result) {$scope.sv_activitySummaryList = JSON.parse(result.replace(/&quot;/g,'"'));},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})

  		
 
         //alert('after controller call');
        
        $scope.items = [
            { "id": "1", "WeekRange": "Sep 23 - Sep 29", "userName": "Chris Bennet", "activityday": "Monday", "activitydate": "Sep 23 2013", "totalwkhours": "40.00", "totalhours": "8.00", "submitted": "Yes", "reviewed": "Rejected", "field5 ": "field5 1" },
            { "id": "3", "WeekRange": "Sep 17 - Sep 22", "userName": "Chris Bennet", "activityday": "Wednesday", "activitydate": "Sep 25 2013", "totalwkhours": "38.00", "totalhours": "4.00", "submitted": "Yes", "reviewed": "Rejected", "field5 ": "field5 2" },
            { "id": "5", "WeekRange": "Sep 09 - Sep 16", "userName": "Chris Bennet", "activityday": "Friday", "activitydate": "Sep 27 2013", "totalwkhours": "40.00", "totalhours": "2.00", "submitted": "No", "reviewed": "Pending", "field5 ": "field5 2" },
            { "id": "7", "WeekRange": "Sep 02 - Sep 08", "userName": "Chris Bennet", "activityday": "Sunday", "activitydate": "Sep 29 2013", "totalwkhours": "38.00", "totalhours": "8.00", "submitted": "No", "reviewed": "Pending", "field5 ": "field5 2" },
        ];
        

        //alert('at controller');
		
		//doubleMe('10').then(function(result) {$scope.example1 = result;})
		
		
		


        $scope.items2 = [
        { "id": "2", "activitydate": "Wed Sep 25 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 2" },
        { "id": "2", "activitydate": "Tue Sep 24 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 2" },
        { "id": "1", "activitydate": "Mon Sep 23 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 22 2013", "totalhours": "3.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Sep 21 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Sep 20 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Sep 19 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Sep 18 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Sep 17 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" },
        { "id": "1", "activitydate": "Mon Sep 16 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 15 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Sep 14 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Sep 13 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Sep 12 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Sep 11 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Sep 10 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" },
        { "id": "1", "activitydate": "Mon Sep 09 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 08 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Sep 07 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Sep 06 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Sep 05 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Sep 04 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Sep 03 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" },
        { "id": "1", "activitydate": "Mon Sep 02 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 01 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Aug 31 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Aug 30 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Aug 26 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Aug 26 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Aug 27 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" }
        ];

	
	
	    var searchMatch = function (haystack, needle) {
	        if (!needle) {
	            return true;
	        }
	        return haystack.toLowerCase().indexOf(needle.toLowerCase()) !== -1;
	    };
	
	    // init the filtered items
	    $scope.search = function () {
	        $scope.filteredItems = $filter('filter')($scope.items, function (item) {
	            for (var attr in item) {
	                if (searchMatch(item[attr], $scope.query))
	                    return true;
	            }
	            return false;
	        });
	        // take care of the sorting order
	        if ($scope.sortingOrder !== '') {
	            $scope.filteredItems = $filter('orderBy')($scope.filteredItems, $scope.sortingOrder, $scope.reverse);
	        }
	        $scope.currentPage = 0;
	        // now group by pages
	        $scope.groupToPages();
	    };
	
	    // calculate page in place
	    $scope.groupToPages = function () {
	        $scope.pagedItems = [];
	
	        for (var i = 0; i < $scope.filteredItems.length; i++) {
	            if (i % $scope.itemsPerPage === 0) {
	                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)] = [$scope.filteredItems[i]];
	            } else {
	                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)].push($scope.filteredItems[i]);
	            }
	        }
	    };
	
	    $scope.range = function (start, end) {
	        var ret = [];
	        if (!end) {
	            end = start;
	            start = 0;
	        }
	        for (var i = start; i < end; i++) {
	            ret.push(i);
	        }
	        return ret;
	    };


	    $scope.prevPage = function () {
	    
	    	$rootScope.SelectedweekStartDate.SubtractDays(7 * 8);
	    	GetActivitySummary($rootScope.SelectedweekStartDate.toUTCString﻿()).then(function(result) {$scope.sv_activitySummaryList = JSON.parse(result.replace(/&quot;/g,'"'));},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
	    
	        if ($scope.currentPage > 0) {
	            $scope.currentPage--;
	        }
	    };
	
		 $scope.navigateToWeekly = function (summaryWeekStartDate ) {
	    
	    	$rootScope.SelectedweekStartDate = parseDate(summaryWeekStartDate);
	    	$location.path('/activitylist');
	    };
	    
	
	    $scope.nextPage = function () {
	    	$rootScope.SelectedweekStartDate.addDays(7 * 8);
 		GetActivitySummary($rootScope.SelectedweekStartDate.toUTCString﻿()).then(function(result) {$scope.sv_activitySummaryList = JSON.parse(result.replace(/&quot;/g,'"'));},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
	    	
	        if ($scope.currentPage < $scope.pagedItems.length - 1) {
	            $scope.currentPage++;
	        }
	    };

	    $scope.SetThisWeekPage = function () {
	    
 		GetActivitySummary(getMonday(new Date()).toUTCString﻿()).then(function(result) {$scope.sv_activitySummaryList = JSON.parse(result.replace(/&quot;/g,'"'));},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
	    	
	        if ($scope.currentPage < $scope.pagedItems.length - 1) {
	            $scope.currentPage++;
	        }
	    };
	    
	    

	    
	/*
	    $scope.prevPage = function () {
	        if ($scope.currentPage > 0) {
	            $scope.currentPage--;
	        }
	    };
	
	    $scope.nextPage = function () {
	        if ($scope.currentPage < $scope.pagedItems.length - 1) {
	            $scope.currentPage++;
	        }
	    };
	
		*/
	    $scope.setPage = function () {
	        $scope.currentPage = this.n;
	    };
	
	    // functions have been describe process the data for display
	    $scope.search();
	
	    // change sorting order
	    $scope.sort_by = function (newSortingOrder) {
	        if ($scope.sortingOrder == newSortingOrder)
	            $scope.reverse = !$scope.reverse;
	
	        $scope.sortingOrder = newSortingOrder;
	
	        // icon setup
	        $('th i').each(function () {
	            // icon reset
	            $(this).removeClass().addClass('icon-sort');
	        });
	        if ($scope.reverse)
	            $('th.' + new_sorting_order + ' i').removeClass().addClass('icon-chevron-up');
	        else
	            $('th.' + new_sorting_order + ' i').removeClass().addClass('icon-chevron-down');
	    };
	
	    $scope.DoDailyView = function () {
	        $location.path('/activitydaily');
	    };




        $scope.navigateto = function (navigateurl) {
            $location.path(navigateurl);
        }






    }


    
])  /* end of ctrlActivitySummary*/




.controller('ctrlactivitylist', ['$scope', '$rootScope', '$filter', '$location', '$http', '$log', 'doubleMe', 'getActivityList', 'setrootScopoeVariables',

    function ($scope, $rootScope, $filter, $location, $http, $log, doubleMe, getActivityList, setrootScopoeVariables) {
        // init
        $scope.sortingOrder = sortingOrder;
        $scope.reverse = false;
        $scope.filteredItems = [];
        $scope.groupedItems = [];
        $scope.itemsPerPage = 7;
        $scope.pagedItems = [];
        $scope.currentPage = 0;
        
        //alert('1');
        
        $scope.sfdcResult = '_____';
        
        //alert($scope.sfdcResult);
        
        setrootScopoeVariables();
        
        
        
 		$scope.askSFDC = function(input){
  				doubleMe(input).then(function(result) {$scope.sfdcResult = result;},
                           function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;}
  							          )
  		};
 
 		getActivityList($rootScope.SelectedweekStartDate.toUTCString﻿()).then(function(result) {$scope.activityList1 = JSON.parse(result.replace(/&quot;/g,'"'));},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})

  		
 
         //alert('after controller call');
        
        $scope.items = [
            { "id": "1", "WeekRange": "Sep 23 - Sep 29", "userName": "Chris Bennet", "activityday": "Monday", "activitydate": "Sep 23 2013", "totalwkhours": "40.00", "totalhours": "8.00", "submitted": "Yes", "reviewed": "Rejected", "field5 ": "field5 1" },
            { "id": "3", "WeekRange": "Sep 17 - Sep 22", "userName": "Chris Bennet", "activityday": "Wednesday", "activitydate": "Sep 25 2013", "totalwkhours": "38.00", "totalhours": "4.00", "submitted": "Yes", "reviewed": "Rejected", "field5 ": "field5 2" },
            { "id": "5", "WeekRange": "Sep 09 - Sep 16", "userName": "Chris Bennet", "activityday": "Friday", "activitydate": "Sep 27 2013", "totalwkhours": "40.00", "totalhours": "2.00", "submitted": "No", "reviewed": "Pending", "field5 ": "field5 2" },
            { "id": "7", "WeekRange": "Sep 02 - Sep 08", "userName": "Chris Bennet", "activityday": "Sunday", "activitydate": "Sep 29 2013", "totalwkhours": "38.00", "totalhours": "8.00", "submitted": "No", "reviewed": "Pending", "field5 ": "field5 2" },
        ];
        

        //alert('at controller');
		
		//doubleMe('10').then(function(result) {$scope.example1 = result;})
		
		
	   $scope.navigateToDaily = function (summaryWeekStartDate ) {
	    
	    	//alert('summaryWeekStartDate: ' + summaryWeekStartDate);
	    	$rootScope.SelectedweekStartDate = parseDate(summaryWeekStartDate);
	    	$location.path('/activitydaily');
	    };
	 		


        $scope.items2 = [
        { "id": "2", "activitydate": "Wed Sep 25 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 2" },
        { "id": "2", "activitydate": "Tue Sep 24 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 2" },
        { "id": "1", "activitydate": "Mon Sep 23 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 22 2013", "totalhours": "3.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Sep 21 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Sep 20 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Sep 19 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Sep 18 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Sep 17 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" },
        { "id": "1", "activitydate": "Mon Sep 16 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 15 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Sep 14 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Sep 13 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Sep 12 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Sep 11 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Sep 10 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" },
        { "id": "1", "activitydate": "Mon Sep 09 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 08 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Sep 07 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Sep 06 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Sep 05 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Sep 04 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Sep 03 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" },
        { "id": "1", "activitydate": "Mon Sep 02 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 01 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Aug 31 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Aug 30 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Aug 26 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Aug 26 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Aug 27 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" }
        ];

	
	
	    var searchMatch = function (haystack, needle) {
	        if (!needle) {
	            return true;
	        }
	        return haystack.toLowerCase().indexOf(needle.toLowerCase()) !== -1;
	    };
	
	    // init the filtered items
	    $scope.search = function () {
	        $scope.filteredItems = $filter('filter')($scope.items, function (item) {
	            for (var attr in item) {
	                if (searchMatch(item[attr], $scope.query))
	                    return true;
	            }
	            return false;
	        });
	        // take care of the sorting order
	        if ($scope.sortingOrder !== '') {
	            $scope.filteredItems = $filter('orderBy')($scope.filteredItems, $scope.sortingOrder, $scope.reverse);
	        }
	        $scope.currentPage = 0;
	        // now group by pages
	        $scope.groupToPages();
	    };
	
	    // calculate page in place
	    $scope.groupToPages = function () {
	        $scope.pagedItems = [];
	
	        for (var i = 0; i < $scope.filteredItems.length; i++) {
	            if (i % $scope.itemsPerPage === 0) {
	                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)] = [$scope.filteredItems[i]];
	            } else {
	                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)].push($scope.filteredItems[i]);
	            }
	        }
	    };
	
	    $scope.range = function (start, end) {
	        var ret = [];
	        if (!end) {
	            end = start;
	            start = 0;
	        }
	        for (var i = start; i < end; i++) {
	            ret.push(i);
	        }
	        return ret;
	    };


	    $scope.prevPage = function () {
	    
	    	$rootScope.SelectedweekStartDate.SubtractDays(7);
	    	getActivityList($rootScope.SelectedweekStartDate.toUTCString﻿()).then(function(result) {$scope.activityList1 = JSON.parse(result.replace(/&quot;/g,'"'));},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
	    
	        if ($scope.currentPage > 0) {
	            $scope.currentPage--;
	        }
	    };
	
	    $scope.nextPage = function () {
	    	$rootScope.SelectedweekStartDate.addDays(7);
 		getActivityList($rootScope.SelectedweekStartDate.toUTCString﻿()).then(function(result) {$scope.activityList1 = JSON.parse(result.replace(/&quot;/g,'"'));},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
	    	
	        if ($scope.currentPage < $scope.pagedItems.length - 1) {
	            $scope.currentPage++;
	        }
	    };

	    $scope.SetThisWeekPage = function () {
	    
 		getActivityList(getMonday(new Date()).toUTCString﻿()).then(function(result) {$scope.activityList1 = JSON.parse(result.replace(/&quot;/g,'"'));},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
	    	
	        if ($scope.currentPage < $scope.pagedItems.length - 1) {
	            $scope.currentPage++;
	        }
	    };
	    
	    

	    
	/*
	    $scope.prevPage = function () {
	        if ($scope.currentPage > 0) {
	            $scope.currentPage--;
	        }
	    };
	
	    $scope.nextPage = function () {
	        if ($scope.currentPage < $scope.pagedItems.length - 1) {
	            $scope.currentPage++;
	        }
	    };
	
		*/
	    $scope.setPage = function () {
	        $scope.currentPage = this.n;
	    };
	
	    // functions have been describe process the data for display
	    $scope.search();
	
	    // change sorting order
	    $scope.sort_by = function (newSortingOrder) {
	        if ($scope.sortingOrder == newSortingOrder)
	            $scope.reverse = !$scope.reverse;
	
	        $scope.sortingOrder = newSortingOrder;
	
	        // icon setup
	        $('th i').each(function () {
	            // icon reset
	            $(this).removeClass().addClass('icon-sort');
	        });
	        if ($scope.reverse)
	            $('th.' + new_sorting_order + ' i').removeClass().addClass('icon-chevron-up');
	        else
	            $('th.' + new_sorting_order + ' i').removeClass().addClass('icon-chevron-down');
	    };
	
	    $scope.DoDailyView = function () {
	        $location.path('/activitydaily');
	    };




        $scope.navigateto = function (navigateurl) {
            $location.path(navigateurl);
        }






    }


    
])  /* end of ctrlactivitylist*/



.controller('ActivitydailyCtrl', ['$scope', '$location', '$http', '$log', '$rootScope', 'GetBHATActivityByDate', 'GetBHATActivityLookupData', 'UpdateBhatActivity', 'GetBHATPreviousActivityByDate', 'DeleteSelectedActivities',

    function ($scope, $location, $http, $log, $rootScope, GetBHATActivityByDate, GetBHATActivityLookupData, UpdateBhatActivity, GetBHATPreviousActivityByDate, DeleteSelectedActivities) {


 		$scope.sv_BhatActivityDailyList = [];
 		$scope.sv_UpdateBhatActivityResult=[];
 		$scope.sv_currentActivityItem = [];        
		$scope.sv_currentSubCategoryItem = [];
		$scope.sv_DailyEntryCurrentAC = [];
		$scope.sv_DailyEntryCurrentANList = [];

		$scope.SetEmptyIfSubcategoryIdIsNull = function(ActivityDailyList)
		{
			// make subcategory id to '' if it is null to remove blank option in the dropdown
				for (var i = 0; i < ActivityDailyList.ActivityDtoList.length; i++) 
				{
					if (ActivityDailyList.ActivityDtoList[i].SubCategoryID == null)
					{
						ActivityDailyList.ActivityDtoList[i].SubCategoryID ='';
					}	
				}					 			 				
		
		}

			//alert('date :' + $rootScope.SelectedweekStartDate);
			//alert('string Date:' + getDateString($rootScope.SelectedweekStartDate));
			
 			GetBHATActivityByDate(getDateString($rootScope.SelectedweekStartDate)).then(function(result) {
 			 				$scope.sv_BhatActivityDailyList = JSON.parse(result.replace(/&quot;/g,'"'));
 			 				
 			 					$rootScope.rsv_BhatActivityCount = $scope.sv_BhatActivityDailyList.ActivityDtoList.length;
								$scope.SetEmptyIfSubcategoryIdIsNull($scope.sv_BhatActivityDailyList);

								if ($rootScope.rsv_isActivitySingle == false)
								{
		 			 				$scope.sv_currentActivityItem = $scope.sv_BhatActivityDailyList.ActivityDtoList[0];
		 			 				
		 			 			}
		 			 			else
		 			 			{
		 			 				for (var i = 0; i < $scope.sv_BhatActivityDailyList.ActivityDtoList.length; i++) 
		 			 				{
		 			 					if ($scope.sv_BhatActivityDailyList.ActivityDtoList[i].ActivityCode  == $rootScope.rsv_SelectedActivityAtMView.ActivityCode )
		 			 					{
		 			 						$scope.sv_currentActivityItem = $scope.sv_BhatActivityDailyList.ActivityDtoList[i];
		 			 					}
		 			 				}
		 			 			
		 			 				//alert(JSON.stringify($rootScope.rsv_SelectedActivityAtMView))
		 			 			}
		 			 				        
 			 				},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})


 			GetBHATActivityLookupData().then(function(result) {$scope.sv_BHATActivityLookupData = JSON.parse(result.replace(/&quot;/g,'"'));},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})


        $scope.contacts = [];




        $scope.searchTerm = '';
        $scope.working = false;

     
        $scope.doCreate = function () {
            $location.path('/new');
        }


        $scope.navigateto = function (navigateurl) {
            $location.path(navigateurl);
        }

   		$scope.navigateto = function (navigateurl) {
            $location.path(navigateurl);
        }

   		$scope.navigatetoSingle = function (item) {
   		
   			$rootScope.rsv_SelectedActivityAtMView = item;
   			$scope.sv_currentActivityItem = item;
   			$rootScope.rsv_isActivitySingle = true;
            $location.path('/activitysingle');
        }


		$scope.DailyEntryCurrentACItemChanged = function (sv_ad, currentItem)
		{
			alert(JSON.stringify(currentItem));
			sv_ad.ActivityCode =  currentItem.Name;
			
			/*
			if (currentItem.BHAT_Activity_Notes__r)
			{
				$scope.sv_DailyEntryCurrentANList = currentItem.BHAT_Activity_Notes__r.records;
			}
			else
			{
				$scope.sv_DailyEntryCurrentANList = null;
			}
			
			$scope.sv_DailyEntryCurrentAC = sv_ad.ActivityCode;
			
	 		$scope.sv_BhatActivityDailyList = [];
	 		
	 		alert(JSON.stringify($rootScope.rsv_BhatGlobalData.BHATActivityCodeList));
	 		
	 		var filteredCodeItem =  jQuery.grep( $rootScope.rsv_BhatGlobalData.BHATActivityCodeList, function (activitycode, index) {

               return activitycode.Name == sv_ad.ActivityCode;
            });
	 		
	 		if (filteredCodeItem)
	 		{
	 			console.log(JSON.stringify(filteredCodeItem));
				//$scope.sv_DailyEntryCurrentANList = filteredCodeItem.BHAT_Activity_Notes__r.records;
			}
				
				*/	 
			 
			 
		}	




  		$scope.$watch('rsv_BhatActivityCount', function(value, oldValue){
				$rootScope.rsv_BhatActivityNewCount = value;
    	});


	   $scope.GoPreviousDay = function (formName) {
	    
	    	
           if (formName != null && formName.$valid == false)
           {
           		return false;
           }
	    
	    	$scope.saveActivity();
	    
	    	$rootScope.SelectedweekStartDate.setDate($rootScope.SelectedweekStartDate.getDate()- 1) 
	    	
	 		GetBHATActivityByDate(getDateString($rootScope.SelectedweekStartDate)).then(function(result) {
 			 				$scope.sv_BhatActivityDailyList = JSON.parse(result.replace(/&quot;/g,'"'));
 			 				$scope.SetEmptyIfSubcategoryIdIsNull($scope.sv_BhatActivityDailyList);
 			 				
 			 				
 			 				
 			 				$rootScope.rsv_BhatActivityCount = $scope.sv_BhatActivityDailyList.ActivityDtoList.length;
 			 				$scope.sv_currentActivityItem = $scope.sv_BhatActivityDailyList.ActivityDtoList[0];
 			 				},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
	    };
	 		

	   $scope.GoPreviousDayNoSave = function (formName) {
	    

	    
	    
	    	if ($scope.sv_BhatActivityDailyList.IsCopyPrevious)
	    	{
	    			if (formName != null && formName.$valid == false)
            		{
           				return false;
            		}
	    	    	
	    		$scope.saveActivity();
	    	}
	    
	    	$rootScope.SelectedweekStartDate.setDate($rootScope.SelectedweekStartDate.getDate()- 1) 
	    	
	 		GetBHATActivityByDate(getDateString($rootScope.SelectedweekStartDate)).then(function(result) {
 			 				$scope.sv_BhatActivityDailyList = JSON.parse(result.replace(/&quot;/g,'"'));
 			 				$scope.SetEmptyIfSubcategoryIdIsNull($scope.sv_BhatActivityDailyList);
 			 				$rootScope.rsv_BhatActivityCount = $scope.sv_BhatActivityDailyList.ActivityDtoList.length;
 			 				$scope.sv_currentActivityItem = $scope.sv_BhatActivityDailyList.ActivityDtoList[0];
 			 				},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
	    };
	 		


	   $scope.GoNextDay = function (formName) {
	    
	       if (formName != null && formName.$valid == false)
           {
           		return false;
           }
	    	
	    	$scope.saveActivity();
	    	
	    	$rootScope.SelectedweekStartDate.setDate($rootScope.SelectedweekStartDate.getDate()+ 1) 
	    	
	 		GetBHATActivityByDate(getDateString($rootScope.SelectedweekStartDate)).then(function(result) {
 			 				$scope.sv_BhatActivityDailyList = JSON.parse(result.replace(/&quot;/g,'"'));
 			 				$scope.SetEmptyIfSubcategoryIdIsNull($scope.sv_BhatActivityDailyList);
 			 				$rootScope.rsv_BhatActivityCount = $scope.sv_BhatActivityDailyList.ActivityDtoList.length;
 			 				$scope.sv_currentActivityItem = $scope.sv_BhatActivityDailyList.ActivityDtoList[0];
 			 				},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
	    };
	 		

		 			
	   $scope.GoNextDayNoSave = function (formName) {
	    
	    	
	    
	    	if ($scope.sv_BhatActivityDailyList.IsCopyPrevious)
	    	{
					if (formName != null && formName.$valid == false)
           			{
           				return false;
           			}
	    		
	    	
	    		$scope.saveActivity();
	    	}
	    	
	    	$rootScope.SelectedweekStartDate.setDate($rootScope.SelectedweekStartDate.getDate()+ 1) 
	    	
	 		GetBHATActivityByDate(getDateString($rootScope.SelectedweekStartDate)).then(function(result) {
 			 				$scope.sv_BhatActivityDailyList = JSON.parse(result.replace(/&quot;/g,'"'));
 			 				$scope.SetEmptyIfSubcategoryIdIsNull($scope.sv_BhatActivityDailyList);
 			 				$rootScope.rsv_BhatActivityCount = $scope.sv_BhatActivityDailyList.ActivityDtoList.length;
 			 				$scope.sv_currentActivityItem = $scope.sv_BhatActivityDailyList.ActivityDtoList[0];
 			 				},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
	    };
	 		




        $scope.addNewActivity = function () {

			//var emptyActivityObject =[];
			
			
			var emptyActivityObject = jQuery.extend(true, {}, $scope.sv_BhatActivityDailyList.ActivityDtoList[0]);

			$rootScope.rsv_BhatActivityNewCount =  $rootScope.rsv_BhatActivityNewCount + 1
			emptyActivityObject.SortSequence = $rootScope.rsv_BhatActivityNewCount;
			emptyActivityObject.UniqueId  =  $rootScope.rsv_BhatActivityNewCount;
			emptyActivityObject.ActivityID = null;
			emptyActivityObject.ActivityCode = $rootScope.rsv_BhatGlobalData.BHATActivityCodeList[0].name;
			emptyActivityObject.ActivityCodeID =  $rootScope.rsv_BhatGlobalData.BHATActivityCodeList[0].Id; 
			emptyActivityObject.SubCategoryID= '';
			emptyActivityObject.SubCategory= null;
			emptyActivityObject.IsDelete = false;
			emptyActivityObject.Hours = 0;
			emptyActivityObject.Description = null;
            $scope.sv_BhatActivityDailyList.ActivityDtoList.push(emptyActivityObject);
            $rootScope.rsv_DailyEntryCurrentACItem = $rootScope.rsv_BhatGlobalData.BHATActivityCodeList[0];
            
          
            

        };


        $scope.clearAll = function () {

				$scope.sv_BhatActivityDailyList.ActivityDtoList


				for(var i =0;i < $scope.sv_BhatActivityDailyList.ActivityDtoList.length;i++)
				{
				  
				  $scope.sv_BhatActivityDailyList.ActivityDtoList[i].SubCategoryID ="";
				  $scope.sv_BhatActivityDailyList.ActivityDtoList[i].Description ="";
				  $scope.sv_BhatActivityDailyList.ActivityDtoList[i].Hours =0;
				  
				}
				

        };



        $scope.copyPrevious = function () {

 				GetBHATPreviousActivityByDate(getDateString($rootScope.SelectedweekStartDate)).then(function(result) {
 				
 							var copypreviousresultdata = JSON.parse(result.replace(/&quot;/g,'"'));
 							
 							if (copypreviousresultdata.IsCopyPrevious)
 							{
		 			 				$scope.sv_BhatActivityDailyList = copypreviousresultdata;
		 			 				$rootScope.rsv_BhatActivityCount = $scope.sv_BhatActivityDailyList.ActivityDtoList.length;
 			 						$scope.sv_currentActivityItem = $scope.sv_BhatActivityDailyList.ActivityDtoList[0];
 			 				
 			 						if(!$scope.$$phase) 
 			 						{
 			 							$scope.$apply();
									}	
 			 				}
 			 				else
 			 				{
 			 					alert('no previously entered data.');
 			 				}
 			 			},
                        function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})

        };


        $scope.copyPreviousMobile = function () {

				
 				GetBHATPreviousActivityByDate(getDateString($rootScope.SelectedweekStartDate)).then(function(result) {
 				
 							var copypreviousresultdata = JSON.parse(result.replace(/&quot;/g,'"'));
 							
 							
 							if (copypreviousresultdata.IsCopyPrevious)
 							{
		 			 				$scope.sv_BhatActivityDailyList = copypreviousresultdata;
		 			 				$rootScope.rsv_BhatActivityCount = $scope.sv_BhatActivityDailyList.ActivityDtoList.length;
 			 						$scope.sv_currentActivityItem = $scope.sv_BhatActivityDailyList.ActivityDtoList[0];
 			 				
 			 						if(!$scope.$$phase) 
 			 						{
 			 							$scope.$apply();
									}	
									
									$scope.saveActivity();
											
 			 				}
 			 				else
 			 				{
 			 					alert('no previously entered data.');
 			 				}
 			 			},
                        function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})

        };






        $scope.removeActivity = function (index) {
        	 $scope.sv_BhatActivityDailyList.ActivityDtoList.splice(index - 1, 1);
        };


        $scope.DeleteActivities = function () {
        	
        	var activitiesIds = [];
        			
	        for (var i = 0; i < $scope.sv_BhatActivityDailyList.ActivityDtoList.length; i++) 
	        {
	            if ($scope.sv_BhatActivityDailyList.ActivityDtoList[i].IsDelete == true) 
	            {
	            	activitiesIds.push({"ItemValue": $scope.sv_BhatActivityDailyList.ActivityDtoList[i].ActivityID});
	            }
	        }
	        
	        
	        // call server side function if the array is greater than 0
	        
	        if (activitiesIds.length > 0 )
	        {
			 // start	        	
            DeleteSelectedActivities(activitiesIds).then(function (result) {
                alert(result);
                // Refresh the  data from server.

                GetBHATActivityByDate(getDateString($rootScope.SelectedweekStartDate)).then(function (result) {
                    $scope.sv_BhatActivityDailyList = JSON.parse(result.replace(/&quot;/g, '"'));
                    $scope.SetEmptyIfSubcategoryIdIsNull($scope.sv_BhatActivityDailyList);
                    $rootScope.rsv_BhatActivityCount = $scope.sv_BhatActivityDailyList.ActivityDtoList.length;
                    $scope.sv_currentActivityItem = $scope.sv_BhatActivityDailyList.ActivityDtoList[0];
                    
                }, function (error) { $scope.sfdcResult = 'ERROR: ' + error.message; })

            }, function (error) { $scope.sfdcResult = 'ERROR: ' + error.message; })
	        //end..	
	        	
				        	
	        }
	        
	        
        };



		// $scope.$watch('sv_currentActivityItem', function(value, oldValue){
		 
       		//$scope.sv_currentSubCategoryItem = value.BHATActivityNotesList[0];
       	//	var x = '1';
    	//});
    
    
    	
    
    	$scope.filterActivityNotes = function(o,ActivityCodeID)
    	{
    	
    		/*alert('BHAT_Activity_Code__c: ' + BHAT_Activity_Code__c + 'ActivityCodeID: ' +  ActivityCodeID + 'Activity_Note_Description__c: ' + Activity_Note_Description__c);
    	
    		if (BHAT_Activity_Code__c == ActivityCodeID || Activity_Note_Description__c == 'None')
    		{
    			return true;
    		}
    		else
    		{
    			return false;
    		}
    		*/
    	
    		return true;
    	}
    	
    	$scope.IsActivitySubCategoryDropdownRequired = function(uniqueid, hours)
    	{
    	
    		 if ( $("#ActivitySubCategoryDropdown_" + uniqueid + " option").length > 1 && hours > 0 )
    		 {
    		 	return true;
    		 }
    		 else
    		 {
    		 	return false;
    		 }
    	
    	}


    	$scope.IsActivitySubCategoryDropdownRequired4Single = function(hours)
    	{
    		
    	
    		 if ( $("#ActivitySubCategoryDropdownSingle option").length > 1 && hours > 0 )
    		 {
    		 	return true;
    		 }
    		 else
    		 {
    		 	return false;
    		 }
    	
    	}
    	
    	
    	

    	/*$scope.IsStartEndTimeValid = function(WorkHourStartTime,WorkHourEndTime)
    	{  
		    if( (typeof WorkHourStartTime !== 'undefined'  && WorkHourStartTime != null &&  (typeof WorkHourEndTime !== 'undefined'  && WorkHourEndTime != null)
		    {
		           //convert both time into timestamp
		            var stt = new Date("November 13, 2013 " + WorkHourStartTime);
		            stt = stt.getTime();
		
		            var endt = new Date("November 13, 2013 " + WorkHourEndTime);
		            endt = endt.getTime();
		            
		            //alert(WorkHourStartTime+" TESTing "+WorkHourEndTime);
		
		            if(stt > endt){
		                $("#WorkHourStartTime").css('border', '1px solid red');
		                $("#WorkHourEndTime").css('border', '1px solid red');
		              //  $('#error_WorkHourStartEndTime').removeClass('errorHide').addClass('error');
		               return false;
		            }
		            else{	
		                $("#WorkHourStartTime").css('border', '1px solid black');
		                $("#WorkHourEndTime").css('border', '1px solid black');
		                // $('#error_WorkHourStartEndTime').removeClass('error').addClass('errorHide');
		                return true;
		           }
		     }
		}
		*/
    
		$scope.IsNoteDescriptionRequired = function(currentindex)
		{
		   var subcategoryText = $("#ActivitySubCategoryDropdown_" + currentindex + " option:selected").text();
		   
			 
			    //alert(subcategoryText);
			    
				if (subcategoryText != null && subcategoryText.substring(0, 5).toLowerCase() == "other") 
				{
					
					//alert(subcategoryText + ' true: ' + subcategoryText.substring(0, 6).toLowerCase());
					
					return true;
				}	
				else
				{
					//alert(subcategoryText + ' false: ' + subcategoryText.substring(0, 6).toLowerCase());
					//console.log('false');
					return false;
				}
		}

		$scope.IsNoteDescriptionRequired4Single = function()
		{
		   var subcategoryText = $("#ActivitySubCategoryDropdownSingle option:selected").text();
		   
			 
			    //alert(subcategoryText);
			    
				if (subcategoryText != null && subcategoryText.substring(0, 5).toLowerCase() == "other") 
				{
					
					//alert(subcategoryText + ' true: ' + subcategoryText.substring(0, 6).toLowerCase());
					
					return true;
				}	
				else
				{
					//alert(subcategoryText + ' false: ' + subcategoryText.substring(0, 6).toLowerCase());
					//console.log('false');
					return false;
				}
		}



        $scope.isWorking = function () {
            return $scope.working;
        };


        $scope.saveDailyActivity = function (formName) {
	
	       if (formName != null && formName.$valid == false)
           {
           		return false;
           }
	
			$scope.saveActivity();
	
		}

        $scope.saveSingleActivity = function (formName) {
	
	       if (formName != null && formName.$valid == false)
           {
           		return false;
           }
	
			$scope.saveActivity();
	
		}



        $scope.saveActivity = function () {
           
        	// validate         	
        	//$scope.sv_BhatActivityDailyList
        	
        	 var Hours_without_ID_And_Subcategory = 0;
        	 var HoursLengthExceeded = 0;
        	 var DescriptionLengthExceeded = 0;
        	 var Error_found = false;
        
        	//activitiesIds
        			
           // alert(JSON.stringify($scope.sv_BhatActivityDailyList));			
        
         /*			
	        for (var i = 0; i < $scope.sv_BhatActivityDailyList.ActivityDtoList.length; i++) 
	        {
	            //var hours = $scope.sv_BhatActivityDailyList.ActivityDtoList[i].Hours;
	        	if ($scope.sv_BhatActivityDailyList.ActivityDtoList[i].Hours > 0 && $scope.sv_BhatActivityDailyList.ActivityDtoList[i].BHATActivityNotesList.length > 1 && $scope.sv_BhatActivityDailyList.ActivityDtoList[i].SubCategoryID == '' ) 
	            {
	            	Hours_without_ID_And_Subcategory = Hours_without_ID_And_Subcategory + 1;
	            }
	            if ($scope.sv_BhatActivityDailyList.ActivityDtoList[i].Hours == null ) 
	            {
	            	HoursLengthExceeded = HoursLengthExceeded + 1;
	            }
	            if ($scope.sv_BhatActivityDailyList.ActivityDtoList[i].Description != null && $scope.sv_BhatActivityDailyList.ActivityDtoList[i].Description.length > 100  ) 
	            {
	            	DescriptionLengthExceeded = DescriptionLengthExceeded + 1;
	            	$scope.sv_BhatActivityDailyList.ActivityDtoList[i].DescriptionLengthExceeded = true;
	            }
	            else
	            {
	            	$scope.sv_BhatActivityDailyList.ActivityDtoList[i].DescriptionLengthExceeded = false;
	            }
	        }
	        
	        
	        if(Hours_without_ID_And_Subcategory > 0 || HoursLengthExceeded > 0 || DescriptionLengthExceeded > 0){
	              Error_found = true; 
	        }
	       
	       */
	        
	       // alert('Error found = " '+ Error_found + ' ", for the following.......!!!  \n HoursWithoutID : ' + Hours_without_ID_And_Subcategory + ', HoursLengthExceeded : '+ HoursLengthExceeded+', DescriptionMorethan100digits : '+ DescriptionLengthExceeded);
        
          if (Error_found == true)
          {
          	return false;
          }	
           
        	// Get Date differences
        	
        	var timeDiff = GetTimeDifference($scope.sv_BhatActivityDailyList.WorkHourStartTime, $scope.sv_BhatActivityDailyList.WorkHourEndTime);
        	
        	var timeDiffArray = timeDiff.split(':');
        	
        	if (timeDiffArray.length > 1);
        	{
	        	$scope.sv_BhatActivityDailyList.HoursWorked  = timeDiffArray[0];
	        	$scope.sv_BhatActivityDailyList.MinutesWorked = timeDiffArray[1];
	        	
	        	//alert('HoursWorked: ' + $scope.sv_BhatActivityDailyList.HoursWorked );
	        	//alert('MinutesWorked :' + $scope.sv_BhatActivityDailyList.MinutesWorked);
	        	
	        	if ($scope.sv_BhatActivityDailyList.MinutesWorked != 0 )
	        	{
	        		$scope.sv_BhatActivityDailyList.MinutesWorked  = Math.round(($scope.sv_BhatActivityDailyList.MinutesWorked/60) * 100 )
	        	}
	        	
	        	//alert('after converted :' + $scope.sv_BhatActivityDailyList.MinutesWorked);
	        	
        	}
        	
			UpdateBhatActivity($scope.sv_BhatActivityDailyList).then(function(result) 
			{
				$scope.sv_UpdateBhatActivityResult = result;
				
					if ($scope.sv_UpdateBhatActivityResult != 'No Data')
					{
						alert($scope.sv_UpdateBhatActivityResult);
					}
					// Refresh the  data from server.
					
 								GetBHATActivityByDate(getDateString($rootScope.SelectedweekStartDate)).then(function(result) 
 								{
 			 						$scope.sv_BhatActivityDailyList = JSON.parse(result.replace(/&quot;/g,'"'));
 			 						$scope.SetEmptyIfSubcategoryIdIsNull($scope.sv_BhatActivityDailyList);
 			 						$rootScope.rsv_BhatActivityCount = $scope.sv_BhatActivityDailyList.ActivityDtoList.length;
 			 						$scope.sv_currentActivityItem = $scope.sv_BhatActivityDailyList.ActivityDtoList[0];
 			 				},
                         		function(error)  {
                         			$scope.sfdcResult = 'ERROR: ' + error.message;
                         			}
                         		)
					
					
					
				},
                         function(error)  {$scope.sfdcResult = 'ERROR: ' + error.message;})
              
                return true;          
            
                         
        };


        
        

        $scope.doView = function (contactId) {
            console.log('doView');
            $location.path('/view/' + contactId);
        };

        $scope.doCreate = function () {
            $location.path('/new');
        }
    }






])






.controller('ctrlRead', ['$scope', '$filter', '$location', '$http', '$log', 




    function ($scope, $filter, $location, $http, $log) {
        // init
        $scope.sortingOrder = sortingOrder;
        $scope.reverse = false;
        $scope.filteredItems = [];
        $scope.groupedItems = [];
        $scope.itemsPerPage = 7;
        $scope.pagedItems = [];
        $scope.currentPage = 0;
        $scope.activitylist =[];

        $scope.items = [
            { "id": "1", "WeekRange": "Sep 23 - Sep 29", "userName": "Chris Bennet", "activityday": "Monday", "activitydate": "Sep 23 2013", "totalwkhours": "40.00", "totalhours": "8.00", "submitted": "Yes", "reviewed": "Approved", "division": "Kaiser", "manager": "Bryan Wheeler" },
            { "id": "2", "WeekRange": "Sep 23 - Sep 29", "userName": "Paul Reed", "activityday": "Tuesday", "activitydate": "Sep 24 2013", "totalwkhours": "40.00", "totalhours": "3.00", "submitted": "Yes", "reviewed": "Approved", "division": "Nursing Homes", "manager": "Justin Roody" },
            { "id": "3", "WeekRange": "Sep 17 - Sep 22", "userName": "Chris Bennet", "activityday": "Wednesday", "activitydate": "Sep 25 2013", "totalwkhours": "42.00", "totalhours": "4.00", "submitted": "Yes", "reviewed": "Rejected", "division": "Kaiser", "manager": "Bryan Wheeler" },
            { "id": "4", "WeekRange": "Sep 17 - Sep 22", "userName": "Paul Reed", "activityday": "Thursday", "activitydate": "Sep 26 2013", "totalwkhours": "40.00", "totalhours": "7.00", "submitted": "Yes", "reviewed": "Pending", "division": "Nursing Homes", "manager": "Justin Roody" },
            { "id": "5", "WeekRange": "Sep 09 - Sep 16", "userName": "Chris Bennet", "activityday": "Friday", "activitydate": "Sep 27 2013", "totalwkhours": "39.00", "totalhours": "2.00", "submitted": "No", "reviewed": "Pending", "division": "Kaiser", "manager": "Bryan Wheeler" },
            { "id": "6", "WeekRange": "Sep 09 - Sep 16", "userName": "Paul Reed", "activityday": "Saturday", "activitydate": "Sep 28 2013", "totalwkhours": "40.00", "totalhours": "8.00", "submitted": "No", "reviewed": "Pending", "division": "Nursing Homes", "manager": "Justin Roody" },
            { "id": "7", "WeekRange": "Sep 02 - Sep 08", "userName": "Chris Bennet", "activityday": "Sunday", "activitydate": "Sep 29 2013", "totalwkhours": "40.00", "totalhours": "8.00", "submitted": "No", "reviewed": "Pending", "division": "Kaiser", "manager": "Bryan Wheeler" },
            { "id": "8", "WeekRange": "Sep 02 - Sep 08", "userName": "Paul Reed", "activityday": "Monday", "activitydate": "Sep 30 2013", "totalwkhours": "40.00", "totalhours": "8.00", "submitted": "No", "reviewed": "Pending", "division": "Nursing Homes", "manager": "Justin Roody" },
        ];

         

        $scope.items2 = [
        { "id": "2", "activitydate": "Wed Sep 25 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 2" },
        { "id": "2", "activitydate": "Tue Sep 24 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 2" },
        { "id": "1", "activitydate": "Mon Sep 23 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 22 2013", "totalhours": "3.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Sep 21 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Sep 20 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Sep 19 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Sep 18 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Sep 17 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" },
        { "id": "1", "activitydate": "Mon Sep 16 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 15 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Sep 14 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Sep 13 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Sep 12 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Sep 11 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Sep 10 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" },
        { "id": "1", "activitydate": "Mon Sep 09 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 08 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Sep 07 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Sep 06 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Sep 05 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Sep 04 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Sep 03 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" },
        { "id": "1", "activitydate": "Mon Sep 02 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 1" },
        { "id": "3", "activitydate": "Sun Sep 01 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 3" },
        { "id": "4", "activitydate": "Sat Aug 31 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 4" },
        { "id": "5", "activitydate": "Fri Aug 30 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 5" },
        { "id": "6", "activitydate": "Thu Aug 26 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 6" },
        { "id": "7", "activitydate": "Wed Aug 26 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 7" },
        { "id": "8", "activitydate": "Tue Aug 27 2013", "totalhours": "2.00", "submitted": "Yes", "reviewed": "Yes", "field5 ": "field5 8" }
        ];


        $scope.navigateto = function (navigateurl) {
            $location.path(navigateurl);
        }

    var searchMatch = function(haystack, needle) {
        if (!needle) {
            return true;
        }
        return haystack.toLowerCase().indexOf(needle.toLowerCase()) !== -1;
    };


        // init the filtered items
        $scope.search = function() {
            $scope.filteredItems = $filter('filter')($scope.items, function(item) {
                for (var attr in item) {
                    if (searchMatch(item[attr], $scope.query))
                        return true;
                }
                return false;
            });
            // take care of the sorting order
            if ($scope.sortingOrder !== '') {
                $scope.filteredItems = $filter('orderBy')($scope.filteredItems, $scope.sortingOrder, $scope.reverse);
            }
            $scope.currentPage = 0;
            // now group by pages
            $scope.groupToPages();
        };

        // calculate page in place
        $scope.groupToPages = function() {
            $scope.pagedItems = [];

            for (var i = 0; i < $scope.filteredItems.length; i++) {
                if (i % $scope.itemsPerPage === 0) {
                    $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)] = [$scope.filteredItems[i]];
                } else {
                    $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)].push($scope.filteredItems[i]);
                }
            }
        };

        $scope.range = function(start, end) {
            var ret = [];
            if (!end) {
                end = start;
                start = 0;
            }
            for (var i = start; i < end; i++) {
                ret.push(i);
            }
            return ret;
        };

        $scope.prevPage = function() {
            if ($scope.currentPage > 0) {
                $scope.currentPage--;
            }
        };

        $scope.nextPage = function() {
            if ($scope.currentPage < $scope.pagedItems.length - 1) {
                $scope.currentPage++;
            }
        };

        $scope.setPage = function() {
            $scope.currentPage = this.n;
        };

        // functions have been describe process the data for display
        $scope.search();

        // change sorting order
        $scope.sort_by = function(newSortingOrder) {
            if ($scope.sortingOrder == newSortingOrder)
                $scope.reverse = !$scope.reverse;

            $scope.sortingOrder = newSortingOrder;

            // icon setup
            $('th i').each(function() {
                // icon reset
                $(this).removeClass().addClass('icon-sort');
            });
            if ($scope.reverse)
                $('th.' + new_sorting_order + ' i').removeClass().addClass('icon-chevron-up');
            else
                $('th.' + new_sorting_order + ' i').removeClass().addClass('icon-chevron-down');
        };

        $scope.DoDailyView = function() {
            $location.path('/activitydaily');
        };

    }


])






.controller('ContactDetailCtrl', ['$scope', '$location', '$routeParams',

    function ($scope,$location, $routeParams) {
        var self = this;

        if ($routeParams.contactId) {
            AngularForce.login(function () {
                Contact.get({ id: $routeParams.contactId },
                    function (contact) {
                        self.original = contact;
                        $scope.contact = new Contact(self.original);
                        $scope.$apply();//Required coz sfdc uses jquery.ajax
                    });
            });
        } else {
            $scope.contact = new Contact();
            //$scope.$apply();
        }

        $scope.isClean = function () {
            return angular.equals(self.original, $scope.contact);
        }

        $scope.destroy = function () {
            self.original.destroy(
                function () {
                    $scope.$apply(function () {
                        $location.path('/contacts');
                    });
                },
                function (errors) {
                    alert("Could not delete contact!\n" + JSON.parse(errors.responseText)[0].message);
                }
            );
        };

        $scope.save = function () {
            if ($scope.contact.Id) {
                $scope.contact.update(function () {
                    $scope.$apply(function () {
                        $location.path('/view/' + $scope.contact.Id);
                    });

                });
            } else {
                Contact.save($scope.contact, function (contact) {
                    var c = contact;
                    $scope.$apply(function () {
                        $location.path('/view/' + c.Id || c.id);
                    });
                });
            }
        };

        $scope.doCancel = function () {
            if ($scope.contact.Id) {
                $location.path('/view/' + $scope.contact.Id);
            } else {
                $location.path('/contacts');
            }
        }

        $scope.navigateto = function (navigateurl) {
            $location.path(navigateurl);
        }
    }


])




  /* keep this for closing tags */
  .controller('MyCtrl2', [function() {

  }]);
