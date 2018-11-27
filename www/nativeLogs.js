
module.exports = {

	pluginName: "NativeLogs",

	getLog:function(maxLines,successCB,failureCB){
		cordova.exec(successCB, failureCB, this.pluginName,"getLog", [maxLines]);
	},

  setLogLevel:function(logLevel,successCB,failureCB){
		cordova.exec(successCB, failureCB, this.pluginName,"setLogLevel", [logLevel]);
  }
};



