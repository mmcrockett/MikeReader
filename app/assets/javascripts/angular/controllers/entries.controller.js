app.controller('EntriesController', ['$scope', '$log', 'Restangular',
function($scope, Logger, Restangular) {
  var VIEWPORT_EST  = _.constant(jQuery(window).width());

  $scope.initialize = function(request_type) {
    $scope.notice = "";
    $scope.Entry  = Restangular.all(request_type);

    $scope.load_data();
  };
  $scope.load_data = function() {
    $scope.Entry.getList({viewport: VIEWPORT_EST()})
    .then(
      function(entries) {
        $scope.entries = entries;
      }
    ).catch(
      function(e) {
        $scope.notice = "Error loading entries.";
        Logger.error("Couldn't load entries." + e);
      }
    ).finally ();
  };
  $scope.mark_read = function(entry) {
    $scope.notice = "";
    entry.read = true;

    entry.save()
    .then()
    .catch(
      function(e) {
        $scope.notice = "Failed to save entry change.";
        Logger.error(e);
      }
    )
    .finally();
  };
}]);
