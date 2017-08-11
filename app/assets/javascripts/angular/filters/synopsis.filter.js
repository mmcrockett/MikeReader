app.filter('synopsis', function() {
  var DIV_WIDTH = _.constant(0.75);
  var TOTAL_PADDING = _.constant(40);
  var VIEWPORT_EST  = _.constant((jQuery(window).width() - TOTAL_PADDING()) * DIV_WIDTH());
  var LETTER_SIZE_EST = _.constant(8);

  return function(input, size) {
    var width     = 0;
    var i         = 0;

    var words  = input.split(" ");
    var output = "";

    console.debug(VIEWPORT_EST());

    while ((width < VIEWPORT_EST()) && (i < words.length)) {
      output += words[i] + ' ';
      width += LETTER_SIZE_EST() * (words[i].length + 1);
      i += 1;
    }

    if (i != words.length) {
      output += '...';
    }

    return output;
  };
})
