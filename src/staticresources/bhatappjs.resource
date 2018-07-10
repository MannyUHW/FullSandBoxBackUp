'use strict';

angular.element(document).ready(function() {
 
 
//alert('appsjs');
 
var bhatModule = angular.module('bhat', ['bhat.controllers',
										 'bhat.directives',
										 'bhat.filters',
										 'bhat.services']);



// Declare app level module which depends on filters, and services
/*
bhatModule.
  config(['$routeProvider', function ($routeProvider) {
      $routeProvider
          .when('/', { templateUrl: sitePrefix + '/angular_vfremote_home', controller: 'MyCtrl1' })
          .when('/view1', {
              templateUrl: sitePrefix + '/angular_vfremote_partial1',
              controller: 'MyCtrl1'
          })
          .when('/view2', {
              templateUrl: sitePrefix + '/angular_vfremote_partial2',
              controller: 'MyCtrl2'
          })
          .otherwise({ redirectTo: '/' });
  }]);

*/

// Declare app level module which depends on filters, and services
bhatModule.
  config(['$routeProvider', function($routeProvider) {
    $routeProvider.
        //when('/', { controller: HomeCtrl, templateUrl: sitePrefix + '/BhatActivitySummary.html' }).
        when('/', { controller: "ActivitydailyCtrl", templateUrl: sitePrefix + '/BhatActivityDaily' }).
        //when('/login', { controller: LoginCtrl, templateUrl: sitePrefix + '/BhatLogin' }).
        when('/activitysummary', { controller: "ctrlActivitySummary", templateUrl: sitePrefix + '/BhatActivitySummary' }).
        when('/activitylist', { controller: "ctrlactivitylist", templateUrl: sitePrefix + '/BhatActivityList' }).
        when('/activitydaily', { controller: "ActivitydailyCtrl", templateUrl: sitePrefix + '/BhatActivityDaily' }).
        when('/approverlist', { controller: "ctrlRead", templateUrl: sitePrefix + '/BhatApproverList' }).
        when('/approverweekly', { controller: "ctrlRead", templateUrl: sitePrefix + '/BhatApproverWeekly' }).
        when('/approversingle', { controller: "ActivitydailyCtrl", templateUrl: sitePrefix + '/BhatApproverSingle' }).
        when('/new', { controller: "ContactDetailCtrl", templateUrl: sitePrefix + '/BhatActivitySingle' }).
        when('/activitysingle', { controller: "ActivitydailyCtrl", templateUrl: sitePrefix + '/BhatActivitySingle' }).
        otherwise({ redirectTo: '/activitydaily' });
  }]);

 var $injector = angular.bootstrap(document, ['bhat']);
    var $controller = $injector.get('$controller');
    //var AngularCtrl = $controller('bhat.controllers');
    //AngularCtrl.setUserName();
 

 });


