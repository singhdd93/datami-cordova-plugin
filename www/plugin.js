var exec = require('cordova/exec');


exports.getsdstate =  function(cb) {
		exec(cb, null, "DatamiSDStateChangePlugin", 'getSDState', []);
};