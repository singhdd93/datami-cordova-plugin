var exec = require('cordova/exec');


exports.getSdState =  function(cb) {
		exec(cb, null, "DatamiSDStateChangePlugin", 'getSDState', []);
};