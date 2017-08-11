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
  $scope.toggle_pod = function(entry) {
    if (true == entry.pod) {
      entry.pod = false;
    } else {
      entry.pod = true;
    }
    $scope.save_entry(entry);
  };
  $scope.save_entry = function(entry) {
    $scope.notice = "";

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
  $scope.columns = function() {
    return ["feed_id", "post_date", "subject", "read"];
  };
}]);
