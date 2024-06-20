var Action = function() {};

Action.prototype = {

run: function(parameters) { // Function that is called before extension is run
    parameters.completionFunction({"URL": document.URL, "title": document.title }); // tell iOS the JavaScript has finished preprocessing and then send the URL the user is visiting and its title to the extension.
},

finalize: function(parameters) { // Function that is called after extension is run
    var customJavaScript = parameters["customJavaScript"];
    eval(customJavaScript);
}

};

var ExtensionPreprocessingJS = new Action
