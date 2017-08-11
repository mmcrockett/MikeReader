app.controller('FeedsController', ['$scope', '$log', 'Restangular',
function($scope, Logger, Restangular) {
  var Feed = Restangular.all('feeds');

  $scope.new_url = "";

  $scope.initialize = function(columns, valid_statuses) {
    $scope.notice = "";
    $scope.load_data();
  };
  $scope.load_data = function() {
    Feed.getList()
    .then(
      function(feeds) {
        $scope.feeds = feeds;
      }
    ).catch(
      function(e) {
        $scope.notice = "Error loading feeds.";
        Logger.error("Couldn't load feeds." + e);
      }
    ).finally ();
  };
  $scope.toggle_display = function(feed) {
    if (true == feed.display) {
      feed.display = false;
    } else {
      feed.display = true;
    }
    $scope.save_feed(feed);
  };
  $scope.toggle_pod = function(feed) {
    if (true == feed.pod) {
      feed.pod = false;
    } else {
      feed.pod = true;
    }
    $scope.save_feed(feed);
  };
  $scope.save_feed = function(feed) {
    $scope.notice = "";

    feed.save()
    .then()
    .catch(
      function(e) {
        $scope.notice = "Failed to save feed change.";
        Logger.error(e);
      }
    )
    .finally();
  };
  $scope.columns = function() {
    return ["id", "name", "url", "active?", "pod?"];
  };
  $scope.add_feed = function() {
    if (false == _.isEmpty($scope.new_url)) {
      $scope.feeds.post({url: $scope.new_url, name: ''})
        .then(
          function(feed) {
            $scope.feeds.push(feed);
            $scope.new_url = "";
          }
      ).catch(
        function(e) {
          $scope.notice = "Error saving new feed.";
          Logger.error("Couldn't load feeds." + e);
        }
      ).finally ();
    }
  };
}]);
