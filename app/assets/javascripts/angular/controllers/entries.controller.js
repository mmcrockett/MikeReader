app.controller('EntriesController', ['$scope', '$log', 'Restangular',
function($scope, Logger, Restangular) {
  var entry = Restangular.all('entries');

  $scope.initialize = function(columns, valid_statuses) {
    $scope.notice = "";
    $scope.load_data();
  };
  $scope.load_data = function() {
    entry.getList()
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
