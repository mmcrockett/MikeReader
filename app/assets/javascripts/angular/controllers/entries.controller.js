app.controller('EntriesController', ['$scope', '$log', 'Restangular', '$interval',
function($scope, Logger, Restangular, $interval) {
  var VIEWPORT_EST  = _.constant(jQuery(window).width());
  $scope.refresh_interval = _.constant(1000 * 60 * 60);
  $scope.filter = 'Unknown';
  $scope.loading = false;
  var update_interval = null;

  $scope.initialize = function(filter, feeds) {
    $scope.notice = "";
    $scope.filter = filter;
    $scope.Entry  = Restangular.all('entries');
    $scope.feeds  = feeds;
    $scope.setup_updates();

    $scope.load_data();
  };
  $scope.feed_name = function(entry) {
    var feed = _.findWhere($scope.feeds, {id: entry.feed_id});
    var name = '';

    if (true == angular.isObject(feed)) {
      name = feed.name;
    }

    if (true == _.isEmpty(name)) {
      name = '' + entry.feed_id;
    }

    return name;
  };
  $scope.load_data = function() {
    $scope.loading = true;
    $scope.Entry.getList({viewport: VIEWPORT_EST(), filter: $scope.filter})
    .then(
      function(entries) {
        $scope.entries = entries;
      }
    ).catch(
      function(e) {
        $scope.notice = "Error loading entries.";
        Logger.error("Couldn't load entries." + e);
      }
    ).finally (function(){
      $scope.loading = false;
    });
  };
  $scope.mark_read = function(entry, eventHandler) {
    if (3 != eventHandler.which) {
      $scope.notice = "";
      entry.read = true;
      entry.saving = true;

      entry.save()
      .then()
      .catch(
        function(e) {
          $scope.notice = "Failed to save entry change.";
          Logger.error(e);
        }
      )
      .finally(function(){
        entry.saving = false;
      });
    }
  };
  $scope.$on('$destroy', function() {
    $scope.stop_updates();
  });
  $scope.stop_updates = function() {
    if (true == angular.isObject(update_interval)) {
      $interval.cancel(update_interval);
      update_interval = null;
    }
  };
  $scope.setup_updates = function() {
    if (false == angular.isObject(update_interval)) {
      update_interval = $interval($scope.load_data, $scope.refresh_interval());
    } else {
      Logger.debug("Interval already exists.");
    }
  };
}]);
