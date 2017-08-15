app.filter('abbreviate', function() {
  var MAX_LENGTH = _.constant(5);
  var IGNORE_WORDS = _.constant(['the']);

  return function(input) {
    var words  = input.replace(/[-_]/g, ' ').split(' ');
    var output = '';
    var index  = 0;

    while ((index < words.length) && (output.length < MAX_LENGTH())) {
      more_words = words[index].split(/(?=[A-Z])/);

      angular.forEach(more_words, function(word, i) {
        output += word.charAt(0).toUpperCase();
      });

      index += 1;
    }

    return output;
  };
})
