$estr = function() { return js.Boot.__string_rec(this,''); }
if(typeof massive=='undefined') massive = {}
if(!massive.munit) massive.munit = {}
if(!massive.munit.async) massive.munit.async = {}
massive.munit.async.AsyncDelegate = function(testCase,handler,timeout,info) {
	if( testCase === $_ ) return;
	var self = this;
	this.testCase = testCase;
	this.handler = handler;
	this.delegateHandler = Reflect.makeVarArgs($closure(this,"responseHandler"));
	this.info = info;
	this.params = [];
	this.timedOut = false;
	if(timeout == null || timeout <= 0) timeout = 400;
	this.timeoutDelay = timeout;
	this.timer = massive.munit.util.Timer.delay($closure(this,"timeoutHandler"),this.timeoutDelay);
}
massive.munit.async.AsyncDelegate.__name__ = ["massive","munit","async","AsyncDelegate"];
massive.munit.async.AsyncDelegate.prototype.observer = null;
massive.munit.async.AsyncDelegate.prototype.info = null;
massive.munit.async.AsyncDelegate.prototype.delegateHandler = null;
massive.munit.async.AsyncDelegate.prototype.timeoutDelay = null;
massive.munit.async.AsyncDelegate.prototype.timedOut = null;
massive.munit.async.AsyncDelegate.prototype.testCase = null;
massive.munit.async.AsyncDelegate.prototype.handler = null;
massive.munit.async.AsyncDelegate.prototype.timer = null;
massive.munit.async.AsyncDelegate.prototype.deferredTimer = null;
massive.munit.async.AsyncDelegate.prototype.params = null;
massive.munit.async.AsyncDelegate.prototype.runTest = function() {
	this.handler.apply(this.testCase,this.params);
}
massive.munit.async.AsyncDelegate.prototype.responseHandler = function(params) {
	if(this.timedOut) return;
	this.timer.stop();
	if(this.deferredTimer != null) this.deferredTimer.stop();
	if(params == null) params = [];
	this.params = params;
	if(this.observer != null) this.observer.asyncResponseHandler(this);
}
massive.munit.async.AsyncDelegate.prototype.timeoutHandler = function() {
	this.actualTimeoutHandler();
}
massive.munit.async.AsyncDelegate.prototype.actualTimeoutHandler = function() {
	this.deferredTimer = null;
	this.handler = null;
	this.delegateHandler = null;
	this.timedOut = true;
	if(this.observer != null) this.observer.asyncTimeoutHandler(this);
}
massive.munit.async.AsyncDelegate.prototype.__class__ = massive.munit.async.AsyncDelegate;
massive.munit.ITestResultClient = function() { }
massive.munit.ITestResultClient.__name__ = ["massive","munit","ITestResultClient"];
massive.munit.ITestResultClient.prototype.completionHandler = null;
massive.munit.ITestResultClient.prototype.id = null;
massive.munit.ITestResultClient.prototype.addPass = null;
massive.munit.ITestResultClient.prototype.addFail = null;
massive.munit.ITestResultClient.prototype.addError = null;
massive.munit.ITestResultClient.prototype.addIgnore = null;
massive.munit.ITestResultClient.prototype.reportFinalStatistics = null;
massive.munit.ITestResultClient.prototype.__class__ = massive.munit.ITestResultClient;
if(!massive.munit.client) massive.munit.client = {}
massive.munit.client.PrintClient = function(includeIgnoredReport) {
	if( includeIgnoredReport === $_ ) return;
	if(includeIgnoredReport == null) includeIgnoredReport = false;
	this.id = "print";
	this.includeIgnoredReport = includeIgnoredReport;
	this.init();
	this.print("MUnit Results" + this.newline);
	this.print("------------------------------" + this.newline);
}
massive.munit.client.PrintClient.__name__ = ["massive","munit","client","PrintClient"];
massive.munit.client.PrintClient.prototype.id = null;
massive.munit.client.PrintClient.prototype.completionHandler = null;
massive.munit.client.PrintClient.prototype.get_completeHandler = function() {
	return this.completionHandler;
}
massive.munit.client.PrintClient.prototype.set_completeHandler = function(value) {
	return this.completionHandler = value;
}
massive.munit.client.PrintClient.prototype.newline = null;
massive.munit.client.PrintClient.prototype.failures = null;
massive.munit.client.PrintClient.prototype.errors = null;
massive.munit.client.PrintClient.prototype.ignored = null;
massive.munit.client.PrintClient.prototype.output = null;
massive.munit.client.PrintClient.prototype.currentTestClass = null;
massive.munit.client.PrintClient.prototype.originalTrace = null;
massive.munit.client.PrintClient.prototype.includeIgnoredReport = null;
massive.munit.client.PrintClient.prototype.textArea = null;
massive.munit.client.PrintClient.prototype.init = function() {
	this.originalTrace = haxe.Log.trace;
	haxe.Log.trace = $closure(this,"customTrace");
	this.output = "";
	this.failures = "";
	this.errors = "";
	this.ignored = "";
	this.currentTestClass = "";
	this.newline = "\n";
	this.textArea = js.Lib.document.getElementById("haxe:trace");
	if(this.textArea == null) {
		var positionInfo = massive.haxe.util.ReflectUtil.here({ fileName : "PrintClient.hx", lineNumber : 150, className : "massive.munit.client.PrintClient", methodName : "init"});
		var error = "MissingElementException: 'haxe:trace' element not found at " + positionInfo.className + "#" + positionInfo.methodName + "(" + positionInfo.lineNumber + ")";
		js.Lib.alert(error);
	}
}
massive.munit.client.PrintClient.prototype.addPass = function(result) {
	this.checkForNewTestClass(result);
	this.print(".");
}
massive.munit.client.PrintClient.prototype.addFail = function(result) {
	this.checkForNewTestClass(result);
	this.failures += this.newline + result.failure;
}
massive.munit.client.PrintClient.prototype.addError = function(result) {
	this.checkForNewTestClass(result);
	this.errors += this.newline + result.error;
}
massive.munit.client.PrintClient.prototype.addIgnore = function(result) {
	this.checkForNewTestClass(result);
	this.print(",");
	if(this.includeIgnoredReport) this.ignored += this.newline + result.get_location() + " - " + result.description;
}
massive.munit.client.PrintClient.prototype.reportFinalStatistics = function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
	this.printExceptions();
	this.print(this.newline + this.newline);
	if(this.includeIgnoredReport && this.ignored != "") {
		this.print("Ignored:" + this.newline);
		this.print("------------------------------");
		this.print(this.ignored);
	}
	this.print(this.newline + this.newline);
	this.print(passCount == testCount?"PASSED":"FAILED");
	this.print(this.newline + "Tests: " + testCount + "  Passed: " + passCount + "  Failed: " + failCount + " Errors: " + errorCount + " Ignored: " + ignoreCount + " Time: " + massive.munit.util.MathUtil.round(time,5) + this.newline);
	this.print("==============================" + this.newline);
	haxe.Log.trace = this.originalTrace;
	if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
	return this.output;
}
massive.munit.client.PrintClient.prototype.checkForNewTestClass = function(result) {
	if(result.className != this.currentTestClass) {
		this.printExceptions();
		this.currentTestClass = result.className;
		this.print(this.newline + "Class: " + this.currentTestClass + " ");
	}
}
massive.munit.client.PrintClient.prototype.printExceptions = function() {
	if(this.errors != "") {
		this.print(this.errors + this.newline,massive.munit.client.PrintLevel.ERROR);
		this.errors = "";
	}
	if(this.failures != "") {
		this.print(this.failures + this.newline,massive.munit.client.PrintLevel.FAILURE);
		this.failures = "";
	}
}
massive.munit.client.PrintClient.prototype.print = function(value,level) {
	if(level == null) level = massive.munit.client.PrintLevel.NONE;
	var htmlValue = this.serialiseToHTML(value,level);
	if(this.textArea != null) {
		this.textArea.innerHTML += htmlValue;
		js.Lib.window.scrollTo(0,js.Lib.document.body.scrollHeight);
	}
	this.output += value;
}
massive.munit.client.PrintClient.prototype.serialiseToHTML = function(value,level) {
	value = js.Boot.__string_rec(value,"");
	var v = StringTools.htmlEscape(value);
	v = v.split(this.newline).join("<br/>");
	switch( (level)[1] ) {
	case 1:
		v = "<b>" + v + "</b>";
		break;
	case 2:
		v = "<b>" + v + "</b>";
		break;
	default:
		null;
	}
	return v;
}
massive.munit.client.PrintClient.prototype.customTrace = function(value,info) {
	this.print("TRACE: " + info.fileName + "|" + info.lineNumber + "| " + Std.string(value) + this.newline);
}
massive.munit.client.PrintClient.prototype.__class__ = massive.munit.client.PrintClient;
massive.munit.client.PrintClient.__interfaces__ = [massive.munit.ITestResultClient];
if(typeof munit=='undefined') munit = {}
if(!munit.client) munit.client = {}
munit.client.MCoverPrintClient = function(includeIgnoredReport) {
	if( includeIgnoredReport === $_ ) return;
	if(includeIgnoredReport == null) includeIgnoredReport = false;
	massive.munit.client.PrintClient.call(this,includeIgnoredReport);
	massive.mcover.MCoverRunner.instance.completionHandler = $closure(this,"codeCoverageComplete");
	this.coverClient = new massive.mcover.client.PrintClient();
	massive.mcover.MCoverRunner.addClient(this.coverClient);
}
munit.client.MCoverPrintClient.__name__ = ["munit","client","MCoverPrintClient"];
munit.client.MCoverPrintClient.__super__ = massive.munit.client.PrintClient;
for(var k in massive.munit.client.PrintClient.prototype ) munit.client.MCoverPrintClient.prototype[k] = massive.munit.client.PrintClient.prototype[k];
munit.client.MCoverPrintClient.prototype.coverClient = null;
munit.client.MCoverPrintClient.prototype.reportFinalStatistics = function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
	this.printExceptions();
	this.print(this.newline + this.newline);
	if(this.includeIgnoredReport && this.ignored != "") {
		this.print("Ignored:" + this.newline);
		this.print("------------------------------");
		this.print(this.ignored);
	}
	this.print(this.newline + this.newline);
	this.print(passCount == testCount?"PASSED":"FAILED");
	this.print(this.newline + "Tests: " + testCount + "  Passed: " + passCount + "  Failed: " + failCount + " Errors: " + errorCount + " Ignored: " + ignoreCount + " Time: " + massive.munit.util.MathUtil.round(time,5) + this.newline);
	this.print("==============================" + this.newline);
	massive.mcover.MCoverRunner.report();
	if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
	return this.output;
}
munit.client.MCoverPrintClient.prototype.codeCoverageComplete = function(percent) {
	this.print(this.coverClient.output + this.newline);
	haxe.Log.trace = this.originalTrace;
	if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
}
munit.client.MCoverPrintClient.prototype.__class__ = munit.client.MCoverPrintClient;
if(typeof haxe=='undefined') haxe = {}
haxe.Http = function(url) {
	if( url === $_ ) return;
	this.url = url;
	this.headers = new Hash();
	this.params = new Hash();
	this.async = true;
}
haxe.Http.__name__ = ["haxe","Http"];
haxe.Http.requestUrl = function(url) {
	var h = new haxe.Http(url);
	h.async = false;
	var r = null;
	h.onData = function(d) {
		r = d;
	};
	h.onError = function(e) {
		throw e;
	};
	h.request(false);
	return r;
}
haxe.Http.prototype.url = null;
haxe.Http.prototype.async = null;
haxe.Http.prototype.postData = null;
haxe.Http.prototype.headers = null;
haxe.Http.prototype.params = null;
haxe.Http.prototype.setHeader = function(header,value) {
	this.headers.set(header,value);
}
haxe.Http.prototype.setParameter = function(param,value) {
	this.params.set(param,value);
}
haxe.Http.prototype.setPostData = function(data) {
	this.postData = data;
}
haxe.Http.prototype.request = function(post) {
	var me = this;
	var r = new js.XMLHttpRequest();
	var onreadystatechange = function() {
		if(r.readyState != 4) return;
		var s = (function($this) {
			var $r;
			try {
				$r = r.status;
			} catch( e ) {
				$r = null;
			}
			return $r;
		}(this));
		if(s == undefined) s = null;
		if(s != null) me.onStatus(s);
		if(s != null && s >= 200 && s < 400) me.onData(r.responseText); else switch(s) {
		case null: case undefined:
			me.onError("Failed to connect or resolve host");
			break;
		case 12029:
			me.onError("Failed to connect to host");
			break;
		case 12007:
			me.onError("Unknown host");
			break;
		default:
			me.onError("Http Error #" + r.status);
		}
	};
	if(this.async) r.onreadystatechange = onreadystatechange;
	var uri = this.postData;
	if(uri != null) post = true; else {
		var $it0 = this.params.keys();
		while( $it0.hasNext() ) {
			var p = $it0.next();
			if(uri == null) uri = ""; else uri += "&";
			uri += StringTools.urlDecode(p) + "=" + StringTools.urlEncode(this.params.get(p));
		}
	}
	try {
		if(post) r.open("POST",this.url,this.async); else if(uri != null) {
			var question = this.url.split("?").length <= 1;
			r.open("GET",this.url + (question?"?":"&") + uri,this.async);
			uri = null;
		} else r.open("GET",this.url,this.async);
	} catch( e ) {
		this.onError(e.toString());
		return;
	}
	if(this.headers.get("Content-Type") == null && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	var $it1 = this.headers.keys();
	while( $it1.hasNext() ) {
		var h = $it1.next();
		r.setRequestHeader(h,this.headers.get(h));
	}
	r.send(uri);
	if(!this.async) onreadystatechange();
}
haxe.Http.prototype.onData = function(data) {
}
haxe.Http.prototype.onError = function(msg) {
}
haxe.Http.prototype.onStatus = function(status) {
}
haxe.Http.prototype.__class__ = haxe.Http;
massive.munit.TestResult = function(p) {
	if( p === $_ ) return;
	this.passed = false;
	this.executionTime = 0.0;
	this.name = "";
	this.className = "";
	this.description = "";
	this.async = false;
	this.ignore = false;
	this.error = null;
	this.failure = null;
}
massive.munit.TestResult.__name__ = ["massive","munit","TestResult"];
massive.munit.TestResult.prototype.passed = null;
massive.munit.TestResult.prototype.executionTime = null;
massive.munit.TestResult.prototype.name = null;
massive.munit.TestResult.prototype.className = null;
massive.munit.TestResult.prototype.description = null;
massive.munit.TestResult.prototype.location = null;
massive.munit.TestResult.prototype.get_location = function() {
	return this.name == "" && this.className == ""?"":this.className + "#" + this.name;
}
massive.munit.TestResult.prototype.async = null;
massive.munit.TestResult.prototype.ignore = null;
massive.munit.TestResult.prototype.failure = null;
massive.munit.TestResult.prototype.error = null;
massive.munit.TestResult.prototype.__class__ = massive.munit.TestResult;
List = function(p) {
	if( p === $_ ) return;
	this.length = 0;
}
List.__name__ = ["List"];
List.prototype.h = null;
List.prototype.q = null;
List.prototype.length = null;
List.prototype.add = function(item) {
	var x = [item];
	if(this.h == null) this.h = x; else this.q[1] = x;
	this.q = x;
	this.length++;
}
List.prototype.push = function(item) {
	var x = [item,this.h];
	this.h = x;
	if(this.q == null) this.q = x;
	this.length++;
}
List.prototype.first = function() {
	return this.h == null?null:this.h[0];
}
List.prototype.last = function() {
	return this.q == null?null:this.q[0];
}
List.prototype.pop = function() {
	if(this.h == null) return null;
	var x = this.h[0];
	this.h = this.h[1];
	if(this.h == null) this.q = null;
	this.length--;
	return x;
}
List.prototype.isEmpty = function() {
	return this.h == null;
}
List.prototype.clear = function() {
	this.h = null;
	this.q = null;
	this.length = 0;
}
List.prototype.remove = function(v) {
	var prev = null;
	var l = this.h;
	while(l != null) {
		if(l[0] == v) {
			if(prev == null) this.h = l[1]; else prev[1] = l[1];
			if(this.q == l) this.q = prev;
			this.length--;
			return true;
		}
		prev = l;
		l = l[1];
	}
	return false;
}
List.prototype.iterator = function() {
	return { h : this.h, hasNext : function() {
		return this.h != null;
	}, next : function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		return x;
	}};
}
List.prototype.toString = function() {
	var s = new StringBuf();
	var first = true;
	var l = this.h;
	s.b[s.b.length] = "{" == null?"null":"{";
	while(l != null) {
		if(first) first = false; else s.b[s.b.length] = ", " == null?"null":", ";
		s.add(Std.string(l[0]));
		l = l[1];
	}
	s.b[s.b.length] = "}" == null?"null":"}";
	return s.b.join("");
}
List.prototype.join = function(sep) {
	var s = new StringBuf();
	var first = true;
	var l = this.h;
	while(l != null) {
		if(first) first = false; else s.b[s.b.length] = sep == null?"null":sep;
		s.add(l[0]);
		l = l[1];
	}
	return s.b.join("");
}
List.prototype.filter = function(f) {
	var l2 = new List();
	var l = this.h;
	while(l != null) {
		var v = l[0];
		l = l[1];
		if(f(v)) l2.add(v);
	}
	return l2;
}
List.prototype.map = function(f) {
	var b = new List();
	var l = this.h;
	while(l != null) {
		var v = l[0];
		l = l[1];
		b.add(f(v));
	}
	return b;
}
List.prototype.__class__ = List;
if(!massive.mcover) massive.mcover = {}
massive.mcover.CoverageClient = function() { }
massive.mcover.CoverageClient.__name__ = ["massive","mcover","CoverageClient"];
massive.mcover.CoverageClient.prototype.report = null;
massive.mcover.CoverageClient.prototype.logEntry = null;
massive.mcover.CoverageClient.prototype.id = null;
massive.mcover.CoverageClient.prototype.completionHandler = null;
massive.mcover.CoverageClient.prototype.__class__ = massive.mcover.CoverageClient;
massive.munit.TestSuite = function(p) {
	if( p === $_ ) return;
	this.tests = new Array();
	this.index = 0;
}
massive.munit.TestSuite.__name__ = ["massive","munit","TestSuite"];
massive.munit.TestSuite.prototype.tests = null;
massive.munit.TestSuite.prototype.index = null;
massive.munit.TestSuite.prototype.add = function(test) {
	this.tests.push(test);
	this.sortTests();
}
massive.munit.TestSuite.prototype.hasNext = function() {
	return this.index < this.tests.length;
}
massive.munit.TestSuite.prototype.next = function() {
	return this.hasNext()?this.tests[this.index++]:null;
}
massive.munit.TestSuite.prototype.repeat = function() {
	if(this.index > 0) this.index--;
}
massive.munit.TestSuite.prototype.sortTests = function() {
	this.tests.sort($closure(this,"sortByName"));
}
massive.munit.TestSuite.prototype.sortByName = function(x,y) {
	var xName = Type.getClassName(x);
	var yName = Type.getClassName(y);
	if(xName == yName) return 0;
	if(xName > yName) return 1; else return -1;
}
massive.munit.TestSuite.prototype.__class__ = massive.munit.TestSuite;
massive.mcover.CoverageEntryTest = function(p) {
}
massive.mcover.CoverageEntryTest.__name__ = ["massive","mcover","CoverageEntryTest"];
massive.mcover.CoverageEntryTest.prototype.beforeClass = function() {
}
massive.mcover.CoverageEntryTest.prototype.afterClass = function() {
}
massive.mcover.CoverageEntryTest.prototype.setup = function() {
}
massive.mcover.CoverageEntryTest.prototype.tearDown = function() {
}
massive.mcover.CoverageEntryTest.prototype.shouldDeserializeKeyInConstructor = function() {
	var entry = new massive.mcover.CoverageEntry(massive.mcover.CoverageEntryTest.DEFAULT_KEY);
	massive.munit.Assert.areEqual(massive.mcover.CoverageEntryTest.DEFAULT_KEY,entry.key,{ fileName : "CoverageEntryTest.hx", lineNumber : 50, className : "massive.mcover.CoverageEntryTest", methodName : "shouldDeserializeKeyInConstructor"});
	massive.munit.Assert.areEqual(1,entry.id,{ fileName : "CoverageEntryTest.hx", lineNumber : 51, className : "massive.mcover.CoverageEntryTest", methodName : "shouldDeserializeKeyInConstructor"});
	massive.munit.Assert.areEqual("src",entry.classPath,{ fileName : "CoverageEntryTest.hx", lineNumber : 52, className : "massive.mcover.CoverageEntryTest", methodName : "shouldDeserializeKeyInConstructor"});
	massive.munit.Assert.areEqual("foo",entry.packageName,{ fileName : "CoverageEntryTest.hx", lineNumber : 53, className : "massive.mcover.CoverageEntryTest", methodName : "shouldDeserializeKeyInConstructor"});
	massive.munit.Assert.areEqual("Main",entry.className,{ fileName : "CoverageEntryTest.hx", lineNumber : 54, className : "massive.mcover.CoverageEntryTest", methodName : "shouldDeserializeKeyInConstructor"});
	massive.munit.Assert.areEqual(1,entry.min,{ fileName : "CoverageEntryTest.hx", lineNumber : 55, className : "massive.mcover.CoverageEntryTest", methodName : "shouldDeserializeKeyInConstructor"});
	massive.munit.Assert.areEqual(100,entry.max,{ fileName : "CoverageEntryTest.hx", lineNumber : 56, className : "massive.mcover.CoverageEntryTest", methodName : "shouldDeserializeKeyInConstructor"});
	massive.munit.Assert.areEqual("location",entry.location,{ fileName : "CoverageEntryTest.hx", lineNumber : 57, className : "massive.mcover.CoverageEntryTest", methodName : "shouldDeserializeKeyInConstructor"});
	massive.munit.Assert.areEqual(0,entry.count,{ fileName : "CoverageEntryTest.hx", lineNumber : 59, className : "massive.mcover.CoverageEntryTest", methodName : "shouldDeserializeKeyInConstructor"});
	massive.munit.Assert.isFalse(entry.get_result(),{ fileName : "CoverageEntryTest.hx", lineNumber : 61, className : "massive.mcover.CoverageEntryTest", methodName : "shouldDeserializeKeyInConstructor"});
}
massive.mcover.CoverageEntryTest.prototype.shouldThrowErrorOnInvalidKeyFormat = function() {
	try {
		var entry = new massive.mcover.CoverageEntry("foo");
		massive.munit.Assert.fail("expected exception for invalid key in constructor",{ fileName : "CoverageEntryTest.hx", lineNumber : 70, className : "massive.mcover.CoverageEntryTest", methodName : "shouldThrowErrorOnInvalidKeyFormat"});
	} catch( e ) {
		massive.munit.Assert.isTrue(true,{ fileName : "CoverageEntryTest.hx", lineNumber : 74, className : "massive.mcover.CoverageEntryTest", methodName : "shouldThrowErrorOnInvalidKeyFormat"});
	}
}
massive.mcover.CoverageEntryTest.prototype.shouldThrowErrorOnEmptyKey = function() {
	try {
		var entry = new massive.mcover.CoverageEntry("||||||");
		massive.munit.Assert.fail("expected exception for empty key in constructor",{ fileName : "CoverageEntryTest.hx", lineNumber : 84, className : "massive.mcover.CoverageEntryTest", methodName : "shouldThrowErrorOnEmptyKey"});
	} catch( e ) {
		massive.munit.Assert.isTrue(true,{ fileName : "CoverageEntryTest.hx", lineNumber : 88, className : "massive.mcover.CoverageEntryTest", methodName : "shouldThrowErrorOnEmptyKey"});
	}
}
massive.mcover.CoverageEntryTest.prototype.shouldSerialiseToKey = function() {
	var entry = new massive.mcover.CoverageEntry(massive.mcover.CoverageEntryTest.DEFAULT_KEY);
	massive.munit.Assert.areEqual(massive.mcover.CoverageEntryTest.DEFAULT_KEY,entry.toString(),{ fileName : "CoverageEntryTest.hx", lineNumber : 96, className : "massive.mcover.CoverageEntryTest", methodName : "shouldSerialiseToKey"});
}
massive.mcover.CoverageEntryTest.prototype.shouldChangeResultWhenCountChanges = function() {
	var entry = new massive.mcover.CoverageEntry(massive.mcover.CoverageEntryTest.DEFAULT_KEY);
	massive.munit.Assert.areEqual(0,entry.count,{ fileName : "CoverageEntryTest.hx", lineNumber : 103, className : "massive.mcover.CoverageEntryTest", methodName : "shouldChangeResultWhenCountChanges"});
	massive.munit.Assert.isFalse(entry.get_result(),{ fileName : "CoverageEntryTest.hx", lineNumber : 104, className : "massive.mcover.CoverageEntryTest", methodName : "shouldChangeResultWhenCountChanges"});
	entry.count++;
	massive.munit.Assert.areEqual(1,entry.count,{ fileName : "CoverageEntryTest.hx", lineNumber : 108, className : "massive.mcover.CoverageEntryTest", methodName : "shouldChangeResultWhenCountChanges"});
	massive.munit.Assert.isTrue(entry.get_result(),{ fileName : "CoverageEntryTest.hx", lineNumber : 109, className : "massive.mcover.CoverageEntryTest", methodName : "shouldChangeResultWhenCountChanges"});
}
massive.mcover.CoverageEntryTest.prototype.__class__ = massive.mcover.CoverageEntryTest;
if(!massive.haxe) massive.haxe = {}
massive.haxe.Exception = function(message,info) {
	if( message === $_ ) return;
	this.message = message;
	this.info = info;
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "Exception.hx", lineNumber : 70, className : "massive.haxe.Exception", methodName : "new"}).className;
}
massive.haxe.Exception.__name__ = ["massive","haxe","Exception"];
massive.haxe.Exception.prototype.type = null;
massive.haxe.Exception.prototype.message = null;
massive.haxe.Exception.prototype.info = null;
massive.haxe.Exception.prototype.toString = function() {
	var str = this.type + ": " + this.message;
	if(this.info != null) str += " at " + this.info.className + "#" + this.info.methodName + " (" + this.info.lineNumber + ")";
	return str;
}
massive.haxe.Exception.prototype.__class__ = massive.haxe.Exception;
massive.munit.MUnitException = function(message,info) {
	if( message === $_ ) return;
	massive.haxe.Exception.call(this,message,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "MUnitException.hx", lineNumber : 50, className : "massive.munit.MUnitException", methodName : "new"}).className;
}
massive.munit.MUnitException.__name__ = ["massive","munit","MUnitException"];
massive.munit.MUnitException.__super__ = massive.haxe.Exception;
for(var k in massive.haxe.Exception.prototype ) massive.munit.MUnitException.prototype[k] = massive.haxe.Exception.prototype[k];
massive.munit.MUnitException.prototype.__class__ = massive.munit.MUnitException;
massive.munit.async.MissingAsyncDelegateException = function(message,info) {
	if( message === $_ ) return;
	massive.munit.MUnitException.call(this,message,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "MissingAsyncDelegateException.hx", lineNumber : 47, className : "massive.munit.async.MissingAsyncDelegateException", methodName : "new"}).className;
}
massive.munit.async.MissingAsyncDelegateException.__name__ = ["massive","munit","async","MissingAsyncDelegateException"];
massive.munit.async.MissingAsyncDelegateException.__super__ = massive.munit.MUnitException;
for(var k in massive.munit.MUnitException.prototype ) massive.munit.async.MissingAsyncDelegateException.prototype[k] = massive.munit.MUnitException.prototype[k];
massive.munit.async.MissingAsyncDelegateException.prototype.__class__ = massive.munit.async.MissingAsyncDelegateException;
if(!massive.haxe.util) massive.haxe.util = {}
massive.haxe.util.ReflectUtil = function() { }
massive.haxe.util.ReflectUtil.__name__ = ["massive","haxe","util","ReflectUtil"];
massive.haxe.util.ReflectUtil.here = function(info) {
	return info;
}
massive.haxe.util.ReflectUtil.prototype.__class__ = massive.haxe.util.ReflectUtil;
massive.munit.client.HTTPClient = function(client,url,queueRequest) {
	if( client === $_ ) return;
	if(queueRequest == null) queueRequest = true;
	if(url == null) url = "http://localhost:2000";
	this.id = "HTTPClient";
	this.client = client;
	this.url = url;
	this.queueRequest = queueRequest;
}
massive.munit.client.HTTPClient.__name__ = ["massive","munit","client","HTTPClient"];
massive.munit.client.HTTPClient.dispatchNextRequest = function() {
	if(massive.munit.client.HTTPClient.responsePending || massive.munit.client.HTTPClient.queue.length == 0) return;
	massive.munit.client.HTTPClient.responsePending = true;
	var request = massive.munit.client.HTTPClient.queue.pop();
	request.send();
}
massive.munit.client.HTTPClient.prototype.id = null;
massive.munit.client.HTTPClient.prototype.completionHandler = null;
massive.munit.client.HTTPClient.prototype.get_completeHandler = function() {
	return this.completionHandler;
}
massive.munit.client.HTTPClient.prototype.set_completeHandler = function(value) {
	return this.completionHandler = value;
}
massive.munit.client.HTTPClient.prototype.client = null;
massive.munit.client.HTTPClient.prototype.url = null;
massive.munit.client.HTTPClient.prototype.request = null;
massive.munit.client.HTTPClient.prototype.queueRequest = null;
massive.munit.client.HTTPClient.prototype.addPass = function(result) {
	this.client.addPass(result);
}
massive.munit.client.HTTPClient.prototype.addFail = function(result) {
	this.client.addFail(result);
}
massive.munit.client.HTTPClient.prototype.addError = function(result) {
	this.client.addError(result);
}
massive.munit.client.HTTPClient.prototype.addIgnore = function(result) {
	this.client.addIgnore(result);
}
massive.munit.client.HTTPClient.prototype.reportFinalStatistics = function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
	var result = this.client.reportFinalStatistics(testCount,passCount,failCount,errorCount,ignoreCount,time);
	this.sendResult(result);
	return result;
}
massive.munit.client.HTTPClient.prototype.sendResult = function(result) {
	this.request = new massive.munit.client.URLRequest(this.url);
	this.request.setHeader("munit-clientId",this.client.id);
	this.request.setHeader("munit-platformId",this.platform());
	this.request.onData = $closure(this,"onData");
	this.request.onError = $closure(this,"onError");
	this.request.data = result;
	if(this.queueRequest) {
		massive.munit.client.HTTPClient.queue.unshift(this.request);
		massive.munit.client.HTTPClient.dispatchNextRequest();
	} else this.request.send();
}
massive.munit.client.HTTPClient.prototype.platform = function() {
	return "js";
	return "unknown";
}
massive.munit.client.HTTPClient.prototype.onData = function(data) {
	if(this.queueRequest) {
		massive.munit.client.HTTPClient.responsePending = false;
		massive.munit.client.HTTPClient.dispatchNextRequest();
	}
	if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
}
massive.munit.client.HTTPClient.prototype.onError = function(msg) {
	if(this.queueRequest) {
		massive.munit.client.HTTPClient.responsePending = false;
		massive.munit.client.HTTPClient.dispatchNextRequest();
	}
	if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
}
massive.munit.client.HTTPClient.prototype.__class__ = massive.munit.client.HTTPClient;
massive.munit.client.HTTPClient.__interfaces__ = [massive.munit.ITestResultClient];
massive.munit.client.URLRequest = function(url) {
	if( url === $_ ) return;
	this.url = url;
	this.createClient(url);
	this.setHeader("Content-Type","text/plain");
}
massive.munit.client.URLRequest.__name__ = ["massive","munit","client","URLRequest"];
massive.munit.client.URLRequest.prototype.onData = null;
massive.munit.client.URLRequest.prototype.onError = null;
massive.munit.client.URLRequest.prototype.data = null;
massive.munit.client.URLRequest.prototype.url = null;
massive.munit.client.URLRequest.prototype.headers = null;
massive.munit.client.URLRequest.prototype.client = null;
massive.munit.client.URLRequest.prototype.createClient = function(url) {
	this.client = new haxe.Http(url);
}
massive.munit.client.URLRequest.prototype.setHeader = function(name,value) {
	this.client.setHeader(name,value);
}
massive.munit.client.URLRequest.prototype.send = function() {
	this.client.onData = this.onData;
	this.client.onError = this.onError;
	this.client.setPostData(this.data);
	this.client.request(true);
}
massive.munit.client.URLRequest.prototype.__class__ = massive.munit.client.URLRequest;
Reflect = function() { }
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	if(o.hasOwnProperty != null) return o.hasOwnProperty(field);
	var arr = Reflect.fields(o);
	var $it0 = arr.iterator();
	while( $it0.hasNext() ) {
		var t = $it0.next();
		if(t == field) return true;
	}
	return false;
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	if(o == null) return new Array();
	var a = new Array();
	if(o.hasOwnProperty) {
		for(var i in o) if( o.hasOwnProperty(i) ) a.push(i);
	} else {
		var t;
		try {
			t = o.__proto__;
		} catch( e ) {
			t = null;
		}
		if(t != null) o.__proto__ = null;
		for(var i in o) if( i != "__proto__" ) a.push(i);
		if(t != null) o.__proto__ = t;
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && f.__name__ == null;
}
Reflect.compare = function(a,b) {
	return a == b?0:a > b?1:-1;
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && v.__name__ != null;
}
Reflect.deleteField = function(o,f) {
	if(!Reflect.hasField(o,f)) return false;
	delete(o[f]);
	return true;
}
Reflect.copy = function(o) {
	var o2 = { };
	var _g = 0, _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		o2[f] = Reflect.field(o,f);
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = new Array();
		var _g1 = 0, _g = arguments.length;
		while(_g1 < _g) {
			var i = _g1++;
			a.push(arguments[i]);
		}
		return f(a);
	};
}
Reflect.prototype.__class__ = Reflect;
massive.mcover.CoverageEntry = function(value) {
	if( value === $_ ) return;
	this.key = value;
	var a = this.key.split("|");
	if(a.length != 7) throw "Invalid entry format: " + this.key;
	this.id = Std.parseInt(a[0]);
	this.classPath = a[1];
	this.packageName = a[2];
	this.className = a[3];
	this.min = Std.parseInt(a[4]);
	this.max = Std.parseInt(a[5]);
	this.location = a[6];
	this.count = 0;
}
massive.mcover.CoverageEntry.__name__ = ["massive","mcover","CoverageEntry"];
massive.mcover.CoverageEntry.prototype.toString = function() {
	var parts = [this.id,this.classPath,this.packageName,this.className,this.min,this.max,this.location];
	return parts.join("|");
}
massive.mcover.CoverageEntry.prototype.get_result = function() {
	return this.count > 0;
}
massive.mcover.CoverageEntry.prototype.result = null;
massive.mcover.CoverageEntry.prototype.count = null;
massive.mcover.CoverageEntry.prototype.location = null;
massive.mcover.CoverageEntry.prototype.max = null;
massive.mcover.CoverageEntry.prototype.min = null;
massive.mcover.CoverageEntry.prototype.className = null;
massive.mcover.CoverageEntry.prototype.packageName = null;
massive.mcover.CoverageEntry.prototype.classPath = null;
massive.mcover.CoverageEntry.prototype.id = null;
massive.mcover.CoverageEntry.prototype.key = null;
massive.mcover.CoverageEntry.prototype.__class__ = massive.mcover.CoverageEntry;
haxe.StackItem = { __ename__ : ["haxe","StackItem"], __constructs__ : ["CFunction","Module","FilePos","Method","Lambda"] }
haxe.StackItem.CFunction = ["CFunction",0];
haxe.StackItem.CFunction.toString = $estr;
haxe.StackItem.CFunction.__enum__ = haxe.StackItem;
haxe.StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Lambda = function(v) { var $x = ["Lambda",4,v]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.Stack = function() { }
haxe.Stack.__name__ = ["haxe","Stack"];
haxe.Stack.callStack = function() {
	return haxe.Stack.makeStack("$s");
}
haxe.Stack.exceptionStack = function() {
	return haxe.Stack.makeStack("$e");
}
haxe.Stack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.b[b.b.length] = "\nCalled from " == null?"null":"\nCalled from ";
		haxe.Stack.itemToString(b,s);
	}
	return b.b.join("");
}
haxe.Stack.itemToString = function(b,s) {
	var $e = (s);
	switch( $e[1] ) {
	case 0:
		b.b[b.b.length] = "a C function" == null?"null":"a C function";
		break;
	case 1:
		var m = $e[2];
		b.b[b.b.length] = "module " == null?"null":"module ";
		b.b[b.b.length] = m == null?"null":m;
		break;
	case 2:
		var line = $e[4], file = $e[3], s1 = $e[2];
		if(s1 != null) {
			haxe.Stack.itemToString(b,s1);
			b.b[b.b.length] = " (" == null?"null":" (";
		}
		b.b[b.b.length] = file == null?"null":file;
		b.b[b.b.length] = " line " == null?"null":" line ";
		b.b[b.b.length] = line == null?"null":line;
		if(s1 != null) b.b[b.b.length] = ")" == null?"null":")";
		break;
	case 3:
		var meth = $e[3], cname = $e[2];
		b.b[b.b.length] = cname == null?"null":cname;
		b.b[b.b.length] = "." == null?"null":".";
		b.b[b.b.length] = meth == null?"null":meth;
		break;
	case 4:
		var n = $e[2];
		b.b[b.b.length] = "local function #" == null?"null":"local function #";
		b.b[b.b.length] = n == null?"null":n;
		break;
	}
}
haxe.Stack.makeStack = function(s) {
	var a = (function($this) {
		var $r;
		try {
			$r = eval(s);
		} catch( e ) {
			$r = [];
		}
		return $r;
	}(this));
	var m = new Array();
	var _g1 = 0, _g = a.length - (s == "$s"?2:0);
	while(_g1 < _g) {
		var i = _g1++;
		var d = a[i].split("::");
		m.unshift(haxe.StackItem.Method(d[0],d[1]));
	}
	return m;
}
haxe.Stack.prototype.__class__ = haxe.Stack;
IntIter = function(min,max) {
	if( min === $_ ) return;
	this.min = min;
	this.max = max;
}
IntIter.__name__ = ["IntIter"];
IntIter.prototype.min = null;
IntIter.prototype.max = null;
IntIter.prototype.hasNext = function() {
	return this.min < this.max;
}
IntIter.prototype.next = function() {
	return this.min++;
}
IntIter.prototype.__class__ = IntIter;
TestSuite = function(p) {
	if( p === $_ ) return;
	massive.munit.TestSuite.call(this);
	this.add(massive.mcover.CoverageEntryTest);
}
TestSuite.__name__ = ["TestSuite"];
TestSuite.__super__ = massive.munit.TestSuite;
for(var k in massive.munit.TestSuite.prototype ) TestSuite.prototype[k] = massive.munit.TestSuite.prototype[k];
TestSuite.prototype.__class__ = TestSuite;
massive.munit.TestClassHelper = function(type,isDebug) {
	if( type === $_ ) return;
	if(isDebug == null) isDebug = false;
	this.type = type;
	this.isDebug = isDebug;
	this.tests = [];
	this.index = 0;
	this.className = Type.getClassName(type);
	this.beforeClass = $closure(this,"nullFunc");
	this.afterClass = $closure(this,"nullFunc");
	this.before = $closure(this,"nullFunc");
	this.after = $closure(this,"nullFunc");
	this.parse(type);
}
massive.munit.TestClassHelper.__name__ = ["massive","munit","TestClassHelper"];
massive.munit.TestClassHelper.prototype.type = null;
massive.munit.TestClassHelper.prototype.test = null;
massive.munit.TestClassHelper.prototype.beforeClass = null;
massive.munit.TestClassHelper.prototype.afterClass = null;
massive.munit.TestClassHelper.prototype.before = null;
massive.munit.TestClassHelper.prototype.after = null;
massive.munit.TestClassHelper.prototype.tests = null;
massive.munit.TestClassHelper.prototype.index = null;
massive.munit.TestClassHelper.prototype.className = null;
massive.munit.TestClassHelper.prototype.isDebug = null;
massive.munit.TestClassHelper.prototype.hasNext = function() {
	return this.index < this.tests.length;
}
massive.munit.TestClassHelper.prototype.next = function() {
	return this.hasNext()?this.tests[this.index++]:null;
}
massive.munit.TestClassHelper.prototype.current = function() {
	return this.index <= 0?this.tests[0]:this.tests[this.index - 1];
}
massive.munit.TestClassHelper.prototype.parse = function(type) {
	this.test = Type.createEmptyInstance(type);
	var inherintanceChain = this.getInheritanceChain(type);
	var fieldMeta = this.collateFieldMeta(inherintanceChain);
	this.scanForTests(fieldMeta);
	this.tests.sort($closure(this,"sortTestsByName"));
}
massive.munit.TestClassHelper.prototype.getInheritanceChain = function(clazz) {
	var inherintanceChain = [clazz];
	while((clazz = Type.getSuperClass(clazz)) != null) inherintanceChain.push(clazz);
	return inherintanceChain;
}
massive.munit.TestClassHelper.prototype.collateFieldMeta = function(inherintanceChain) {
	var meta = { };
	while(inherintanceChain.length > 0) {
		var clazz = inherintanceChain.pop();
		var newMeta = haxe.rtti.Meta.getFields(clazz);
		var markedFieldNames = Reflect.fields(newMeta);
		var _g = 0;
		while(_g < markedFieldNames.length) {
			var fieldName = markedFieldNames[_g];
			++_g;
			var recordedFieldTags = Reflect.field(meta,fieldName);
			var newFieldTags = Reflect.field(newMeta,fieldName);
			var newTagNames = Reflect.fields(newFieldTags);
			if(recordedFieldTags == null) {
				var tagsCopy = { };
				var _g1 = 0;
				while(_g1 < newTagNames.length) {
					var tagName = newTagNames[_g1];
					++_g1;
					tagsCopy[tagName] = Reflect.field(newFieldTags,tagName);
				}
				meta[fieldName] = tagsCopy;
			} else {
				var ignored = false;
				var _g1 = 0;
				while(_g1 < newTagNames.length) {
					var tagName = newTagNames[_g1];
					++_g1;
					if(tagName == "Ignore") ignored = true;
					if(!ignored && (tagName == "Test" || tagName == "AsyncTest") && Reflect.hasField(recordedFieldTags,"Ignore")) Reflect.deleteField(recordedFieldTags,"Ignore");
					var tagValue = Reflect.field(newFieldTags,tagName);
					recordedFieldTags[tagName] = tagValue;
				}
			}
		}
	}
	return meta;
}
massive.munit.TestClassHelper.prototype.scanForTests = function(fieldMeta) {
	var fieldNames = Reflect.fields(fieldMeta);
	var _g = 0;
	while(_g < fieldNames.length) {
		var fieldName = fieldNames[_g];
		++_g;
		var f = Reflect.field(this.test,fieldName);
		if(Reflect.isFunction(f)) {
			var funcMeta = Reflect.field(fieldMeta,fieldName);
			this.searchForMatchingTags(fieldName,f,funcMeta);
		}
	}
}
massive.munit.TestClassHelper.prototype.searchForMatchingTags = function(fieldName,func,funcMeta) {
	var _g = 0, _g1 = massive.munit.TestClassHelper.META_TAGS;
	while(_g < _g1.length) {
		var tag = _g1[_g];
		++_g;
		if(Reflect.hasField(funcMeta,tag)) {
			var args = Reflect.field(funcMeta,tag);
			var description = args != null?args[0]:"";
			var isAsync = args != null && description == "Async";
			var isIgnored = Reflect.hasField(funcMeta,"Ignore");
			if(isAsync) description = ""; else if(isIgnored) {
				args = Reflect.field(funcMeta,"Ignore");
				description = args != null?args[0]:"";
			}
			switch(tag) {
			case "BeforeClass":
				this.beforeClass = func;
				break;
			case "AfterClass":
				this.afterClass = func;
				break;
			case "Before":
				this.before = func;
				break;
			case "After":
				this.after = func;
				break;
			case "AsyncTest":
				if(!this.isDebug) this.addTest(fieldName,func,this.test,true,isIgnored,description);
				break;
			case "Test":
				if(!this.isDebug) this.addTest(fieldName,func,this.test,isAsync,isIgnored,description);
				break;
			case "TestDebug":
				if(this.isDebug) this.addTest(fieldName,func,this.test,isAsync,isIgnored,description);
				break;
			}
		}
	}
}
massive.munit.TestClassHelper.prototype.addTest = function(field,testFunction,testInstance,isAsync,isIgnored,description) {
	var result = new massive.munit.TestResult();
	result.async = isAsync;
	result.ignore = isIgnored;
	result.className = this.className;
	result.description = description;
	result.name = field;
	var data = { test : testFunction, scope : testInstance, result : result};
	this.tests.push(data);
}
massive.munit.TestClassHelper.prototype.sortTestsByName = function(x,y) {
	if(x.result.name == y.result.name) return 0;
	if(x.result.name > y.result.name) return 1; else return -1;
}
massive.munit.TestClassHelper.prototype.nullFunc = function() {
}
massive.munit.TestClassHelper.prototype.__class__ = massive.munit.TestClassHelper;
ValueType = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
Type = function() { }
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	if(o.__enum__ != null) return null;
	return o.__class__;
}
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
}
Type.getSuperClass = function(c) {
	return c.__super__;
}
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl;
	try {
		cl = eval(name);
	} catch( e ) {
		cl = null;
	}
	if(cl == null || cl.__name__ == null) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e;
	try {
		e = eval(name);
	} catch( err ) {
		e = null;
	}
	if(e == null || e.__ename__ == null) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	if(args.length <= 3) return new cl(args[0],args[1],args[2]);
	if(args.length > 8) throw "Too many arguments";
	return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
}
Type.createEmptyInstance = function(cl) {
	return new cl($_);
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.createEnumIndex = function(e,index,params) {
	var c = e.__constructs__[index];
	if(c == null) throw index + " is not a valid enum constructor index";
	return Type.createEnum(e,c,params);
}
Type.getInstanceFields = function(c) {
	var a = Reflect.fields(c.prototype);
	a.remove("__class__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	a.remove("__name__");
	a.remove("__interfaces__");
	a.remove("__super__");
	a.remove("prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.copy();
}
Type["typeof"] = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ != null) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
Type.enumEq = function(a,b) {
	if(a == b) return true;
	try {
		if(a[0] != b[0]) return false;
		var _g1 = 2, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!Type.enumEq(a[i],b[i])) return false;
		}
		var e = a.__enum__;
		if(e != b.__enum__ || e == null) return false;
	} catch( e ) {
		return false;
	}
	return true;
}
Type.enumConstructor = function(e) {
	return e[0];
}
Type.enumParameters = function(e) {
	return e.slice(2);
}
Type.enumIndex = function(e) {
	return e[1];
}
Type.prototype.__class__ = Type;
if(typeof js=='undefined') js = {}
js.Boot = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__unhtml(js.Boot.__string_rec(v,"")) + "<br/>";
	var d = document.getElementById("haxe:trace");
	if(d == null) alert("No haxe:trace element defined\n" + msg); else d.innerHTML += msg;
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.__closure = function(o,f) {
	var m = o[f];
	if(m == null) return null;
	var f1 = function() {
		return m.apply(o,arguments);
	};
	f1.scope = o;
	f1.method = m;
	return f1;
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ != null || o.__ename__ != null)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__ != null) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		return o.__enum__ == cl || cl == Class && o.__name__ != null || cl == Enum && o.__ename__ != null;
	}
}
js.Boot.__init = function() {
	js.Lib.isIE = typeof document!='undefined' && document.all != null && typeof window!='undefined' && window.opera == null;
	js.Lib.isOpera = typeof window!='undefined' && window.opera != null;
	Array.prototype.copy = Array.prototype.slice;
	Array.prototype.insert = function(i,x) {
		this.splice(i,0,x);
	};
	Array.prototype.remove = Array.prototype.indexOf?function(obj) {
		var idx = this.indexOf(obj);
		if(idx == -1) return false;
		this.splice(idx,1);
		return true;
	}:function(obj) {
		var i = 0;
		var l = this.length;
		while(i < l) {
			if(this[i] == obj) {
				this.splice(i,1);
				return true;
			}
			i++;
		}
		return false;
	};
	Array.prototype.iterator = function() {
		return { cur : 0, arr : this, hasNext : function() {
			return this.cur < this.arr.length;
		}, next : function() {
			return this.arr[this.cur++];
		}};
	};
	if(String.prototype.cca == null) String.prototype.cca = String.prototype.charCodeAt;
	String.prototype.charCodeAt = function(i) {
		var x = this.cca(i);
		if(x != x) return null;
		return x;
	};
	var oldsub = String.prototype.substr;
	String.prototype.substr = function(pos,len) {
		if(pos != null && pos != 0 && len != null && len < 0) return "";
		if(len == null) len = this.length;
		if(pos < 0) {
			pos = this.length + pos;
			if(pos < 0) pos = 0;
		} else if(len < 0) len = this.length + len - pos;
		return oldsub.apply(this,[pos,len]);
	};
	$closure = js.Boot.__closure;
}
js.Boot.prototype.__class__ = js.Boot;
if(!massive.mcover.client) massive.mcover.client = {}
massive.mcover.client.PrintClient = function(p) {
	if( p === $_ ) return;
	this.id = "print";
	this.output = "";
	this.newline = "\n";
	this.tab = " ";
	this.divider = "----------------------------------------------------------------";
}
massive.mcover.client.PrintClient.__name__ = ["massive","mcover","client","PrintClient"];
massive.mcover.client.PrintClient.prototype.printToTabs = function(args,columnWidth) {
	if(columnWidth == null) columnWidth = 10;
	var s = "";
	var _g = 0;
	while(_g < args.length) {
		var arg = args[_g];
		++_g;
		arg = Std.string(arg);
		while(arg.length < columnWidth) arg += "|";
		s += arg.split("|").join(this.tab);
	}
	this.print(s);
}
massive.mcover.client.PrintClient.prototype.print = function(value) {
	this.output += this.newline + Std.string(value);
}
massive.mcover.client.PrintClient.prototype.printClassResults = function(classes) {
	this.classTotal = 0;
	this.classPartialCount = 0;
	this.classCompletedCount = 0;
	this.print("");
	this.print("COVERAGE BREAKDOWN BY CLASSES:");
	this.print("");
	this.printToTabs(["result","blocks","class"]);
	var $it0 = classes.iterator();
	while( $it0.hasNext() ) {
		var cls = $it0.next();
		this.classTotal += 1;
		if(cls.get_count() > 0) this.classPartialCount += 1;
		if(cls.get_percent() == 100) this.classCompletedCount += 1;
		this.printToTabs([cls.get_percent() + "%",cls.get_count() + "/" + cls.get_total(),cls.name]);
	}
}
massive.mcover.client.PrintClient.prototype.printPackageResults = function(packages) {
	this.packageTotal = 0;
	this.packagePartialCount = 0;
	this.packageCompletedCount = 0;
	this.print("");
	this.print("COVERAGE BREAKDOWN BY PACKAGE:");
	this.print("");
	this.printToTabs(["result","blocks","package"]);
	var $it0 = packages.iterator();
	while( $it0.hasNext() ) {
		var pckg = $it0.next();
		this.packageTotal += 1;
		if(pckg.get_count() > 0) this.packagePartialCount += 1;
		if(pckg.get_percent() == 100) this.packageCompletedCount += 1;
		this.printToTabs([pckg.get_percent() + "%",pckg.get_count() + "/" + pckg.get_total(),pckg.name]);
	}
}
massive.mcover.client.PrintClient.prototype.printReport = function() {
	var percent = Math.round(this.count / this.total * 1000) / 10;
	this.print("MCover v0 Coverage Report, generated " + Date.now().toString());
	this.print(this.divider);
	this.printClassResults(this.classes);
	this.print(this.divider);
	this.printPackageResults(this.packages);
	this.print(this.divider);
	this.print("");
	this.print("OVERALL STATS SUMMARY:");
	this.print("");
	this.printToTabs(["total packages",this.packagePartialCount],20);
	this.printToTabs(["total classes",this.classPartialCount],20);
	this.printToTabs(["total blocks",this.count],20);
	this.print("");
	this.printToTabs(["RESULT",percent + "%"],20);
	this.print("");
	this.print(this.divider);
}
massive.mcover.client.PrintClient.prototype.report = function(total,count,entries,classes,packages) {
	this.output = "";
	this.total = total;
	this.count = count;
	this.entries = entries;
	this.classes = classes;
	this.packages = packages;
	this.printReport();
	if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
	return this.output;
}
massive.mcover.client.PrintClient.prototype.packages = null;
massive.mcover.client.PrintClient.prototype.classes = null;
massive.mcover.client.PrintClient.prototype.entries = null;
massive.mcover.client.PrintClient.prototype.count = null;
massive.mcover.client.PrintClient.prototype.total = null;
massive.mcover.client.PrintClient.prototype.logEntry = function(entry) {
}
massive.mcover.client.PrintClient.prototype.classPartialCount = null;
massive.mcover.client.PrintClient.prototype.classCompletedCount = null;
massive.mcover.client.PrintClient.prototype.classTotal = null;
massive.mcover.client.PrintClient.prototype.packagePartialCount = null;
massive.mcover.client.PrintClient.prototype.packageCompletedCount = null;
massive.mcover.client.PrintClient.prototype.packageTotal = null;
massive.mcover.client.PrintClient.prototype.tab = null;
massive.mcover.client.PrintClient.prototype.divider = null;
massive.mcover.client.PrintClient.prototype.output = null;
massive.mcover.client.PrintClient.prototype.newline = null;
massive.mcover.client.PrintClient.prototype.set_completeHandler = function(value) {
	return this.completionHandler = value;
}
massive.mcover.client.PrintClient.prototype.get_completeHandler = function() {
	return this.completionHandler;
}
massive.mcover.client.PrintClient.prototype.completionHandler = null;
massive.mcover.client.PrintClient.prototype.id = null;
massive.mcover.client.PrintClient.prototype.__class__ = massive.mcover.client.PrintClient;
massive.mcover.client.PrintClient.__interfaces__ = [massive.mcover.CoverageClient];
massive.mcover.client.TraceClient = function(p) {
	if( p === $_ ) return;
	massive.mcover.client.PrintClient.call(this);
	this.newline = "<br/>";
	this.tab = "&nbsp;";
}
massive.mcover.client.TraceClient.__name__ = ["massive","mcover","client","TraceClient"];
massive.mcover.client.TraceClient.__super__ = massive.mcover.client.PrintClient;
for(var k in massive.mcover.client.PrintClient.prototype ) massive.mcover.client.TraceClient.prototype[k] = massive.mcover.client.PrintClient.prototype[k];
massive.mcover.client.TraceClient.prototype.printReport = function() {
	massive.mcover.client.PrintClient.prototype.printReport.call(this);
	this.output += this.newline;
	haxe.Log.trace("@@@",{ fileName : "TraceClient.hx", lineNumber : 19, className : "massive.mcover.client.TraceClient", methodName : "printReport"});
	var textArea = js.Lib.document.getElementById("haxe:trace");
	if(textArea == null) {
		var error = "MissingElementException: 'haxe:trace' element not found in html file";
		js.Lib.alert(error);
		return;
	}
	textArea.innerHTML += this.output;
	js.Lib.window.scrollTo(0,js.Lib.document.body.scrollHeight);
}
massive.mcover.client.TraceClient.prototype.__class__ = massive.mcover.client.TraceClient;
IntHash = function(p) {
	if( p === $_ ) return;
	this.h = {}
	if(this.h.__proto__ != null) {
		this.h.__proto__ = null;
		delete(this.h.__proto__);
	}
}
IntHash.__name__ = ["IntHash"];
IntHash.prototype.h = null;
IntHash.prototype.set = function(key,value) {
	this.h[key] = value;
}
IntHash.prototype.get = function(key) {
	return this.h[key];
}
IntHash.prototype.exists = function(key) {
	return this.h[key] != null;
}
IntHash.prototype.remove = function(key) {
	if(this.h[key] == null) return false;
	delete(this.h[key]);
	return true;
}
IntHash.prototype.keys = function() {
	var a = new Array();
	for( x in this.h ) a.push(x);
	return a.iterator();
}
IntHash.prototype.iterator = function() {
	return { ref : this.h, it : this.keys(), hasNext : function() {
		return this.it.hasNext();
	}, next : function() {
		var i = this.it.next();
		return this.ref[i];
	}};
}
IntHash.prototype.toString = function() {
	var s = new StringBuf();
	s.b[s.b.length] = "{" == null?"null":"{";
	var it = this.keys();
	while( it.hasNext() ) {
		var i = it.next();
		s.b[s.b.length] = i == null?"null":i;
		s.b[s.b.length] = " => " == null?"null":" => ";
		s.add(Std.string(this.get(i)));
		if(it.hasNext()) s.b[s.b.length] = ", " == null?"null":", ";
	}
	s.b[s.b.length] = "}" == null?"null":"}";
	return s.b.join("");
}
IntHash.prototype.__class__ = IntHash;
if(!massive.mcover.util) massive.mcover.util = {}
massive.mcover.util.Timer = function(time_ms) {
	if( time_ms === $_ ) return;
	this.id = massive.mcover.util.Timer.arr.length;
	massive.mcover.util.Timer.arr[this.id] = this;
	this.timerId = window.setInterval("massive.mcover.util.Timer.arr[" + this.id + "].run();",time_ms);
}
massive.mcover.util.Timer.__name__ = ["massive","mcover","util","Timer"];
massive.mcover.util.Timer.stamp = function() {
	return Date.now().getTime() / 1000;
}
massive.mcover.util.Timer.delay = function(f,time_ms) {
	var t = new massive.mcover.util.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
massive.mcover.util.Timer.prototype.run = function() {
}
massive.mcover.util.Timer.prototype.stop = function() {
	if(this.id == null) return;
	window.clearInterval(this.timerId);
	massive.mcover.util.Timer.arr[this.id] = null;
	if(this.id > 100 && this.id == massive.mcover.util.Timer.arr.length - 1) {
		var p = this.id - 1;
		while(p >= 0 && massive.mcover.util.Timer.arr[p] == null) p--;
		massive.mcover.util.Timer.arr = massive.mcover.util.Timer.arr.slice(0,p + 1);
	}
	this.id = null;
}
massive.mcover.util.Timer.prototype.timerId = null;
massive.mcover.util.Timer.prototype.id = null;
massive.mcover.util.Timer.prototype.__class__ = massive.mcover.util.Timer;
StringBuf = function(p) {
	if( p === $_ ) return;
	this.b = new Array();
}
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype.add = function(x) {
	this.b[this.b.length] = x == null?"null":x;
}
StringBuf.prototype.addSub = function(s,pos,len) {
	this.b[this.b.length] = s.substr(pos,len);
}
StringBuf.prototype.addChar = function(c) {
	this.b[this.b.length] = String.fromCharCode(c);
}
StringBuf.prototype.toString = function() {
	return this.b.join("");
}
StringBuf.prototype.b = null;
StringBuf.prototype.__class__ = StringBuf;
massive.munit.UnhandledException = function(source,testLocation) {
	if( source === $_ ) return;
	massive.munit.MUnitException.call(this,source.toString() + this.formatLocation(source,testLocation),null);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "UnhandledException.hx", lineNumber : 48, className : "massive.munit.UnhandledException", methodName : "new"}).className;
}
massive.munit.UnhandledException.__name__ = ["massive","munit","UnhandledException"];
massive.munit.UnhandledException.__super__ = massive.munit.MUnitException;
for(var k in massive.munit.MUnitException.prototype ) massive.munit.UnhandledException.prototype[k] = massive.munit.MUnitException.prototype[k];
massive.munit.UnhandledException.prototype.formatLocation = function(source,testLocation) {
	var stackTrace = this.getStackTrace(source);
	if(stackTrace == "") stackTrace = " at " + testLocation; else stackTrace = " " + stackTrace.substr(1);
	return stackTrace;
}
massive.munit.UnhandledException.prototype.getStackTrace = function(source) {
	var s = "";
	if(s == "") {
		var stack = haxe.Stack.exceptionStack();
		while(stack.length > 0) {
			var $e = (stack.shift());
			switch( $e[1] ) {
			case 2:
				var line = $e[4], file = $e[3], item = $e[2];
				s += "\tat " + file + " (" + line + ")\n";
				break;
			case 1:
				var m = $e[2];
				break;
			case 3:
				var method = $e[3], classname = $e[2];
				s += "\tat " + classname + "#" + method + "\n";
				break;
			case 4:
				var v = $e[2];
				break;
			case 0:
				break;
			}
		}
	}
	return s;
}
massive.munit.UnhandledException.prototype.__class__ = massive.munit.UnhandledException;
massive.munit.Assert = function() { }
massive.munit.Assert.__name__ = ["massive","munit","Assert"];
massive.munit.Assert.isTrue = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(value != true) massive.munit.Assert.fail("Expected TRUE but was [" + value + "]",info);
}
massive.munit.Assert.isFalse = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(value != false) massive.munit.Assert.fail("Expected FALSE but was [" + value + "]",info);
}
massive.munit.Assert.isNull = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(value != null) massive.munit.Assert.fail("Value [" + value + "] was not NULL",info);
}
massive.munit.Assert.isNotNull = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(value == null) massive.munit.Assert.fail("Value [" + value + "] was NULL",info);
}
massive.munit.Assert.isNaN = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(!Math.isNaN(value)) massive.munit.Assert.fail("Value [" + value + "]  was not NaN",info);
}
massive.munit.Assert.isNotNaN = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(Math.isNaN(value)) massive.munit.Assert.fail("Value [" + value + "] was NaN",info);
}
massive.munit.Assert.isType = function(value,type) {
	massive.munit.Assert.assertionCount++;
	if(!Std["is"](value,type)) massive.munit.Assert.fail("Value [" + value + "] was not of type: " + Type.getClassName(type),{ fileName : "Assert.hx", lineNumber : 126, className : "massive.munit.Assert", methodName : "isType"});
}
massive.munit.Assert.isNotType = function(value,type) {
	massive.munit.Assert.assertionCount++;
	if(Std["is"](value,type)) massive.munit.Assert.fail("Value [" + value + "] was of type: " + Type.getClassName(type),{ fileName : "Assert.hx", lineNumber : 138, className : "massive.munit.Assert", methodName : "isNotType"});
}
massive.munit.Assert.areEqual = function(expected,actual,info) {
	massive.munit.Assert.assertionCount++;
	if(expected != actual) massive.munit.Assert.fail("Value [" + actual + "] was not equal to expected value [" + expected + "]",info);
}
massive.munit.Assert.areNotEqual = function(expected,actual,info) {
	massive.munit.Assert.assertionCount++;
	if(expected == actual) massive.munit.Assert.fail("Value [" + actual + "] was equal to value [" + expected + "]",info);
}
massive.munit.Assert.fail = function(msg,info) {
	throw new massive.munit.AssertionException(msg,info);
}
massive.munit.Assert.prototype.__class__ = massive.munit.Assert;
Lambda = function() { }
Lambda.__name__ = ["Lambda"];
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.list = function(it) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		l.add(i);
	}
	return l;
}
Lambda.map = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(x));
	}
	return l;
}
Lambda.mapi = function(it,f) {
	var l = new List();
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(i++,x));
	}
	return l;
}
Lambda.has = function(it,elt,cmp) {
	if(cmp == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var x = $it0.next();
			if(x == elt) return true;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(cmp(x,elt)) return true;
		}
	}
	return false;
}
Lambda.exists = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
}
Lambda.foreach = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
}
Lambda.iter = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		f(x);
	}
}
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
}
Lambda.fold = function(it,f,first) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		first = f(x,first);
	}
	return first;
}
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
}
Lambda.empty = function(it) {
	return !it.iterator().hasNext();
}
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
}
Lambda.concat = function(a,b) {
	var l = new List();
	var $it0 = a.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(x);
	}
	var $it1 = b.iterator();
	while( $it1.hasNext() ) {
		var x = $it1.next();
		l.add(x);
	}
	return l;
}
Lambda.prototype.__class__ = Lambda;
if(!haxe.rtti) haxe.rtti = {}
haxe.rtti.Meta = function() { }
haxe.rtti.Meta.__name__ = ["haxe","rtti","Meta"];
haxe.rtti.Meta.getType = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.obj == null?{ }:meta.obj;
}
haxe.rtti.Meta.getStatics = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.statics == null?{ }:meta.statics;
}
haxe.rtti.Meta.getFields = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.fields == null?{ }:meta.fields;
}
haxe.rtti.Meta.prototype.__class__ = haxe.rtti.Meta;
massive.munit.async.AsyncTimeoutException = function(message,info) {
	if( message === $_ ) return;
	massive.munit.MUnitException.call(this,message,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "AsyncTimeoutException.hx", lineNumber : 47, className : "massive.munit.async.AsyncTimeoutException", methodName : "new"}).className;
}
massive.munit.async.AsyncTimeoutException.__name__ = ["massive","munit","async","AsyncTimeoutException"];
massive.munit.async.AsyncTimeoutException.__super__ = massive.munit.MUnitException;
for(var k in massive.munit.MUnitException.prototype ) massive.munit.async.AsyncTimeoutException.prototype[k] = massive.munit.MUnitException.prototype[k];
massive.munit.async.AsyncTimeoutException.prototype.__class__ = massive.munit.async.AsyncTimeoutException;
massive.mcover.MCoverRunner = function(p) {
	if( p === $_ ) return;
	massive.mcover.MCoverRunner.log("12|src|massive.mcover|MCoverRunner|1699|1706|src/massive/mcover/MCoverRunner.hx:72: characters 2-9");
	this.reset();
}
massive.mcover.MCoverRunner.__name__ = ["massive","mcover","MCoverRunner"];
massive.mcover.MCoverRunner.addClient = function(client) {
	massive.mcover.MCoverRunner.log("13|src|massive.mcover|MCoverRunner|977|1001|src/massive/mcover/MCoverRunner.hx:43: characters 2-26");
	massive.mcover.MCoverRunner.clientQueue.push(client);
}
massive.mcover.MCoverRunner.report = function() {
	massive.mcover.MCoverRunner.log("14|src|massive.mcover|MCoverRunner|741|761|src/massive/mcover/MCoverRunner.hx:33: characters 2-22");
	massive.mcover.MCoverRunner.reportPending = true;
}
massive.mcover.MCoverRunner.log = function(value) {
	massive.mcover.MCoverRunner.logQueue.push(value);
}
massive.mcover.MCoverRunner.prototype.addEntryToHashes = function(entry) {
	massive.mcover.MCoverRunner.log("2|src|massive.mcover|MCoverRunner|3985|4026|src/massive/mcover/MCoverRunner.hx:197: characters 2-43");
	this.entries.set(Lambda.count(this.entries),entry);
	var packageKey = entry.packageName != ""?entry.packageName:"[default]";
	if(!this.packages.exists(packageKey)) {
		massive.mcover.MCoverRunner.log("0|src|massive.mcover|MCoverRunner|4150|4215|src/massive/mcover/MCoverRunner.hx:202: characters 3-68");
		this.packages.set(packageKey,new massive.mcover.CoverageEntryCollection(packageKey));
	}
	var pckg = this.packages.get(packageKey);
	pckg.addEntry(entry);
	var classKey = entry.packageName != ""?entry.packageName + "." + entry.className:entry.className;
	if(!this.classes.exists(classKey)) {
		massive.mcover.MCoverRunner.log("1|src|massive.mcover|MCoverRunner|4430|4490|src/massive/mcover/MCoverRunner.hx:212: characters 3-63");
		this.classes.set(classKey,new massive.mcover.CoverageEntryCollection(classKey));
	}
	var cls = this.classes.get(classKey);
	cls.addEntry(entry);
}
massive.mcover.MCoverRunner.prototype.parseEntries = function() {
	massive.mcover.MCoverRunner.log("3|src|massive.mcover|MCoverRunner|3653|3698|src/massive/mcover/MCoverRunner.hx:180: characters 2-47");
	var file = haxe.Resource.getString("MCover");
	if(file == null) return;
	var lines = file.split("\n");
	var _g = 0;
	while(_g < lines.length) {
		var line = lines[_g];
		++_g;
		line = StringTools.trim(line);
		if(line.length == 0) continue;
		var entry = new massive.mcover.CoverageEntry(line);
		this.addEntryToHashes(entry);
	}
}
massive.mcover.MCoverRunner.prototype.clientCompletionHandler = function(client) {
	massive.mcover.MCoverRunner.log("6|src|massive.mcover|MCoverRunner|3386|3618|src/massive/mcover/MCoverRunner.hx:167: lines 167-175");
	if(++this.clientCompleteCount == this.clients.length) {
		massive.mcover.MCoverRunner.log("5|src|massive.mcover|MCoverRunner|3438|3614|src/massive/mcover/MCoverRunner.hx:169: lines 169-174");
		if(this.completionHandler != null) {
			massive.mcover.MCoverRunner.log("4|src|massive.mcover|MCoverRunner|3478|3510|src/massive/mcover/MCoverRunner.hx:171: characters 4-36");
			var percent = this.count / this.total;
			var handler = this.completionHandler;
			massive.mcover.util.Timer.delay(function() {
				handler(percent);
			},1);
		}
	}
}
massive.mcover.MCoverRunner.prototype.reportResults = function() {
	massive.mcover.MCoverRunner.log("8|src|massive.mcover|MCoverRunner|3041|3064|src/massive/mcover/MCoverRunner.hx:150: characters 2-25");
	this.clientCompleteCount = 0;
	if(this.clients.length == 0) {
		massive.mcover.MCoverRunner.log("7|src|massive.mcover|MCoverRunner|3100|3131|src/massive/mcover/MCoverRunner.hx:154: characters 3-34");
		var client = new massive.mcover.client.TraceClient();
		client.set_completeHandler($closure(this,"clientCompletionHandler"));
		this.clients.push(client);
	}
	var _g = 0, _g1 = this.clients;
	while(_g < _g1.length) {
		var client = _g1[_g];
		++_g;
		client.report(this.total,this.count,this.entries,this.classes,this.packages);
	}
}
massive.mcover.MCoverRunner.prototype.logEntry = function(value) {
	massive.mcover.MCoverRunner.log("10|src|massive.mcover|MCoverRunner|2744|2780|src/massive/mcover/MCoverRunner.hx:132: characters 2-38");
	var temp = new massive.mcover.CoverageEntry(value);
	if(!this.entries.exists(temp.id)) throw "Unexpected entry " + value;
	var entry = this.entries.get(temp.id);
	if(!entry.get_result()) {
		massive.mcover.MCoverRunner.log("9|src|massive.mcover|MCoverRunner|2917|2927|src/massive/mcover/MCoverRunner.hx:140: characters 3-13");
		this.count += 1;
	}
	entry.count += 1;
	var _g = 0, _g1 = this.clients;
	while(_g < _g1.length) {
		var client = _g1[_g];
		++_g;
		client.logEntry(entry);
	}
}
massive.mcover.MCoverRunner.prototype.tick = function() {
	var localClients = massive.mcover.MCoverRunner.clientQueue.concat([]);
	massive.mcover.MCoverRunner.clientQueue = [];
	var _g = 0;
	while(_g < localClients.length) {
		var client = localClients[_g];
		++_g;
		client.set_completeHandler($closure(this,"clientCompletionHandler"));
		this.clients.push(client);
	}
	var localLogs = massive.mcover.MCoverRunner.logQueue.concat([]);
	massive.mcover.MCoverRunner.logQueue = [];
	var _g = 0;
	while(_g < localLogs.length) {
		var value = localLogs[_g];
		++_g;
		this.logEntry(value);
	}
	if(massive.mcover.MCoverRunner.reportPending == true) {
		massive.mcover.MCoverRunner.reportPending = false;
		this.reportResults();
		this.timer.stop();
		this.timer = null;
	}
}
massive.mcover.MCoverRunner.prototype.reset = function() {
	massive.mcover.MCoverRunner.log("11|src|massive.mcover|MCoverRunner|1742|1754|src/massive/mcover/MCoverRunner.hx:77: characters 2-14");
	this.clients = [];
	this.entries = new IntHash();
	this.classes = new Hash();
	this.packages = new Hash();
	this.parseEntries();
	this.total = Lambda.count(this.entries);
	this.count = 0;
	if(this.timer != null) this.timer.stop();
	this.timer = new massive.mcover.util.Timer(10);
	this.timer.run = $closure(this,"tick");
}
massive.mcover.MCoverRunner.prototype.timer = null;
massive.mcover.MCoverRunner.prototype.clientCompleteCount = null;
massive.mcover.MCoverRunner.prototype.packages = null;
massive.mcover.MCoverRunner.prototype.classes = null;
massive.mcover.MCoverRunner.prototype.entries = null;
massive.mcover.MCoverRunner.prototype.clients = null;
massive.mcover.MCoverRunner.prototype.count = null;
massive.mcover.MCoverRunner.prototype.total = null;
massive.mcover.MCoverRunner.prototype.completionHandler = null;
massive.mcover.MCoverRunner.prototype.__class__ = massive.mcover.MCoverRunner;
massive.munit.client.PrintLevel = { __ename__ : ["massive","munit","client","PrintLevel"], __constructs__ : ["NONE","FAILURE","ERROR"] }
massive.munit.client.PrintLevel.NONE = ["NONE",0];
massive.munit.client.PrintLevel.NONE.toString = $estr;
massive.munit.client.PrintLevel.NONE.__enum__ = massive.munit.client.PrintLevel;
massive.munit.client.PrintLevel.FAILURE = ["FAILURE",1];
massive.munit.client.PrintLevel.FAILURE.toString = $estr;
massive.munit.client.PrintLevel.FAILURE.__enum__ = massive.munit.client.PrintLevel;
massive.munit.client.PrintLevel.ERROR = ["ERROR",2];
massive.munit.client.PrintLevel.ERROR.toString = $estr;
massive.munit.client.PrintLevel.ERROR.__enum__ = massive.munit.client.PrintLevel;
haxe.Log = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype.__class__ = haxe.Log;
Hash = function(p) {
	if( p === $_ ) return;
	this.h = {}
	if(this.h.__proto__ != null) {
		this.h.__proto__ = null;
		delete(this.h.__proto__);
	}
}
Hash.__name__ = ["Hash"];
Hash.prototype.h = null;
Hash.prototype.set = function(key,value) {
	this.h["$" + key] = value;
}
Hash.prototype.get = function(key) {
	return this.h["$" + key];
}
Hash.prototype.exists = function(key) {
	try {
		key = "$" + key;
		return this.hasOwnProperty.call(this.h,key);
	} catch( e ) {
		for(var i in this.h) if( i == key ) return true;
		return false;
	}
}
Hash.prototype.remove = function(key) {
	if(!this.exists(key)) return false;
	delete(this.h["$" + key]);
	return true;
}
Hash.prototype.keys = function() {
	var a = new Array();
	for(var i in this.h) a.push(i.substr(1));
	return a.iterator();
}
Hash.prototype.iterator = function() {
	return { ref : this.h, it : this.keys(), hasNext : function() {
		return this.it.hasNext();
	}, next : function() {
		var i = this.it.next();
		return this.ref["$" + i];
	}};
}
Hash.prototype.toString = function() {
	var s = new StringBuf();
	s.b[s.b.length] = "{" == null?"null":"{";
	var it = this.keys();
	while( it.hasNext() ) {
		var i = it.next();
		s.b[s.b.length] = i == null?"null":i;
		s.b[s.b.length] = " => " == null?"null":" => ";
		s.add(Std.string(this.get(i)));
		if(it.hasNext()) s.b[s.b.length] = ", " == null?"null":", ";
	}
	s.b[s.b.length] = "}" == null?"null":"}";
	return s.b.join("");
}
Hash.prototype.__class__ = Hash;
massive.mcover.CoverageEntryCollection = function(name) {
	if( name === $_ ) return;
	this.name = name;
	this.entries = new IntHash();
}
massive.mcover.CoverageEntryCollection.__name__ = ["massive","mcover","CoverageEntryCollection"];
massive.mcover.CoverageEntryCollection.prototype.get_total = function() {
	return Lambda.count(this.entries);
}
massive.mcover.CoverageEntryCollection.prototype.get_count = function() {
	var n = 0;
	var $it0 = this.entries.iterator();
	while( $it0.hasNext() ) {
		var elem = $it0.next();
		if(elem.get_result()) n++;
	}
	return n;
}
massive.mcover.CoverageEntryCollection.prototype.get_percent = function() {
	return Math.round(this.get_count() / this.get_total() * 100);
}
massive.mcover.CoverageEntryCollection.prototype.addEntry = function(entry) {
	var $it0 = this.entries.iterator();
	while( $it0.hasNext() ) {
		var elem = $it0.next();
		if(elem == entry) throw "Entry aleady exists in result " + entry;
	}
	this.entries.set(Lambda.count(this.entries),entry);
}
massive.mcover.CoverageEntryCollection.prototype.percent = null;
massive.mcover.CoverageEntryCollection.prototype.total = null;
massive.mcover.CoverageEntryCollection.prototype.count = null;
massive.mcover.CoverageEntryCollection.prototype.entries = null;
massive.mcover.CoverageEntryCollection.prototype.name = null;
massive.mcover.CoverageEntryCollection.prototype.__class__ = massive.mcover.CoverageEntryCollection;
Std = function() { }
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	if(x < 0) return Math.ceil(x);
	return Math.floor(x);
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && x.charCodeAt(1) == 120) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return Math.floor(Math.random() * x);
}
Std.prototype.__class__ = Std;
massive.munit.client.JUnitReportClient = function(p) {
	if( p === $_ ) return;
	this.id = "junit";
	this.xml = new StringBuf();
	this.currentTestClass = "";
	this.newline = "\n";
	this.testSuiteXML = null;
	this.xml.add("<testsuites>" + this.newline);
}
massive.munit.client.JUnitReportClient.__name__ = ["massive","munit","client","JUnitReportClient"];
massive.munit.client.JUnitReportClient.prototype.id = null;
massive.munit.client.JUnitReportClient.prototype.completionHandler = null;
massive.munit.client.JUnitReportClient.prototype.get_completeHandler = function() {
	return this.completionHandler;
}
massive.munit.client.JUnitReportClient.prototype.set_completeHandler = function(value) {
	return this.completionHandler = value;
}
massive.munit.client.JUnitReportClient.prototype.newline = null;
massive.munit.client.JUnitReportClient.prototype.xml = null;
massive.munit.client.JUnitReportClient.prototype.testSuiteXML = null;
massive.munit.client.JUnitReportClient.prototype.currentTestClass = null;
massive.munit.client.JUnitReportClient.prototype.suitePassCount = null;
massive.munit.client.JUnitReportClient.prototype.suiteFailCount = null;
massive.munit.client.JUnitReportClient.prototype.suiteErrorCount = null;
massive.munit.client.JUnitReportClient.prototype.suiteExecutionTime = null;
massive.munit.client.JUnitReportClient.prototype.addPass = function(result) {
	this.checkForNewTestClass(result);
	this.suitePassCount++;
	this.testSuiteXML.add("<testcase classname=\"" + result.className + "\" name=\"" + result.name + "\" time=\"" + massive.munit.util.MathUtil.round(result.executionTime,5) + "\" />" + this.newline);
}
massive.munit.client.JUnitReportClient.prototype.addFail = function(result) {
	this.checkForNewTestClass(result);
	this.suiteFailCount++;
	this.testSuiteXML.add("<testcase classname=\"" + result.className + "\" name=\"" + result.name + "\" time=\"" + massive.munit.util.MathUtil.round(result.executionTime,5) + "\" >" + this.newline);
	this.testSuiteXML.add("<failure message=\"" + result.failure.message + "\" type=\"" + result.failure.type + "\">");
	this.testSuiteXML.add(result.failure);
	this.testSuiteXML.add("</failure>" + this.newline);
	this.testSuiteXML.add("</testcase>" + this.newline);
}
massive.munit.client.JUnitReportClient.prototype.addError = function(result) {
	this.checkForNewTestClass(result);
	this.suiteErrorCount++;
	this.testSuiteXML.add("<testcase classname=\"" + result.className + "\" name=\"" + result.name + "\" time=\"" + massive.munit.util.MathUtil.round(result.executionTime,5) + "\" >" + this.newline);
	this.testSuiteXML.add("<error message=\"" + result.error.message + "\" type=\"" + result.error.type + "\">");
	this.testSuiteXML.add(result.error);
	this.testSuiteXML.add("</error>" + this.newline);
	this.testSuiteXML.add("</testcase>" + this.newline);
}
massive.munit.client.JUnitReportClient.prototype.addIgnore = function(result) {
}
massive.munit.client.JUnitReportClient.prototype.reportFinalStatistics = function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
	this.endTestSuite();
	this.xml.add("</testsuites>");
	if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
	return this.xml.b.join("");
}
massive.munit.client.JUnitReportClient.prototype.checkForNewTestClass = function(result) {
	if(result.className != this.currentTestClass) {
		this.endTestSuite();
		this.currentTestClass = result.className;
		this.startTestSuite();
	}
}
massive.munit.client.JUnitReportClient.prototype.endTestSuite = function() {
	if(this.testSuiteXML == null) return;
	var suiteTestCount = this.suitePassCount + this.suiteFailCount + this.suiteErrorCount;
	this.suiteExecutionTime = massive.munit.util.Timer.stamp() - this.suiteExecutionTime;
	var header = "<testsuite errors=\"" + this.suiteErrorCount + "\" failures=\"" + this.suiteFailCount + "\" hostname=\"\" name=\"" + this.currentTestClass + "\" tests=\"" + suiteTestCount + "\" time=\"" + massive.munit.util.MathUtil.round(this.suiteExecutionTime,5) + "\" timestamp=\"" + Date.now() + "\">" + this.newline;
	var footer = "</testsuite>" + this.newline;
	this.testSuiteXML.add("<system-out></system-out>" + this.newline);
	this.testSuiteXML.add("<system-err></system-err>" + this.newline);
	this.xml.add(header);
	this.xml.add(this.testSuiteXML.b.join(""));
	this.xml.add(footer);
}
massive.munit.client.JUnitReportClient.prototype.startTestSuite = function() {
	this.suitePassCount = 0;
	this.suiteFailCount = 0;
	this.suiteErrorCount = 0;
	this.suiteExecutionTime = massive.munit.util.Timer.stamp();
	this.testSuiteXML = new StringBuf();
}
massive.munit.client.JUnitReportClient.prototype.__class__ = massive.munit.client.JUnitReportClient;
massive.munit.client.JUnitReportClient.__interfaces__ = [massive.munit.ITestResultClient];
if(!massive.munit.util) massive.munit.util = {}
massive.munit.util.Timer = function(time_ms) {
	if( time_ms === $_ ) return;
	this.id = massive.munit.util.Timer.arr.length;
	massive.munit.util.Timer.arr[this.id] = this;
	this.timerId = window.setInterval("massive.munit.util.Timer.arr[" + this.id + "].run();",time_ms);
}
massive.munit.util.Timer.__name__ = ["massive","munit","util","Timer"];
massive.munit.util.Timer.delay = function(f,time_ms) {
	var t = new massive.munit.util.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
massive.munit.util.Timer.stamp = function() {
	return Date.now().getTime() / 1000;
}
massive.munit.util.Timer.prototype.id = null;
massive.munit.util.Timer.prototype.timerId = null;
massive.munit.util.Timer.prototype.stop = function() {
	if(this.id == null) return;
	window.clearInterval(this.timerId);
	massive.munit.util.Timer.arr[this.id] = null;
	if(this.id > 100 && this.id == massive.munit.util.Timer.arr.length - 1) {
		var p = this.id - 1;
		while(p >= 0 && massive.munit.util.Timer.arr[p] == null) p--;
		massive.munit.util.Timer.arr = massive.munit.util.Timer.arr.slice(0,p + 1);
	}
	this.id = null;
}
massive.munit.util.Timer.prototype.run = function() {
}
massive.munit.util.Timer.prototype.__class__ = massive.munit.util.Timer;
massive.munit.async.IAsyncDelegateObserver = function() { }
massive.munit.async.IAsyncDelegateObserver.__name__ = ["massive","munit","async","IAsyncDelegateObserver"];
massive.munit.async.IAsyncDelegateObserver.prototype.asyncResponseHandler = null;
massive.munit.async.IAsyncDelegateObserver.prototype.asyncTimeoutHandler = null;
massive.munit.async.IAsyncDelegateObserver.prototype.__class__ = massive.munit.async.IAsyncDelegateObserver;
massive.munit.TestRunner = function(resultClient) {
	if( resultClient === $_ ) return;
	this.clients = new Array();
	this.addResultClient(resultClient);
	this.set_asyncFactory(this.createAsyncFactory());
	this.running = false;
	this.isDebug = false;
}
massive.munit.TestRunner.__name__ = ["massive","munit","TestRunner"];
massive.munit.TestRunner.prototype.completionHandler = null;
massive.munit.TestRunner.prototype.clientCount = null;
massive.munit.TestRunner.prototype.get_clientCount = function() {
	return this.clients.length;
}
massive.munit.TestRunner.prototype.running = null;
massive.munit.TestRunner.prototype.testCount = null;
massive.munit.TestRunner.prototype.failCount = null;
massive.munit.TestRunner.prototype.errorCount = null;
massive.munit.TestRunner.prototype.passCount = null;
massive.munit.TestRunner.prototype.ignoreCount = null;
massive.munit.TestRunner.prototype.clientCompleteCount = null;
massive.munit.TestRunner.prototype.clients = null;
massive.munit.TestRunner.prototype.activeHelper = null;
massive.munit.TestRunner.prototype.testSuites = null;
massive.munit.TestRunner.prototype.asyncPending = null;
massive.munit.TestRunner.prototype.suiteIndex = null;
massive.munit.TestRunner.prototype.asyncFactory = null;
massive.munit.TestRunner.prototype.set_asyncFactory = function(value) {
	if(value == this.asyncFactory) return value;
	if(this.running) throw new massive.munit.MUnitException("Can't change AsyncFactory while tests are running",{ fileName : "TestRunner.hx", lineNumber : 117, className : "massive.munit.TestRunner", methodName : "set_asyncFactory"});
	value.observer = this;
	return this.asyncFactory = value;
}
massive.munit.TestRunner.prototype.emptyParams = null;
massive.munit.TestRunner.prototype.startTime = null;
massive.munit.TestRunner.prototype.testStartTime = null;
massive.munit.TestRunner.prototype.isDebug = null;
massive.munit.TestRunner.prototype.addResultClient = function(resultClient) {
	var _g = 0, _g1 = this.clients;
	while(_g < _g1.length) {
		var client = _g1[_g];
		++_g;
		if(client == resultClient) return;
	}
	resultClient.set_completeHandler($closure(this,"clientCompletionHandler"));
	this.clients.push(resultClient);
}
massive.munit.TestRunner.prototype.debug = function(testSuiteClasses) {
	this.isDebug = true;
	this.run(testSuiteClasses);
}
massive.munit.TestRunner.prototype.run = function(testSuiteClasses) {
	if(this.running) return;
	this.running = true;
	this.asyncPending = false;
	this.testCount = 0;
	this.failCount = 0;
	this.errorCount = 0;
	this.passCount = 0;
	this.ignoreCount = 0;
	this.suiteIndex = 0;
	this.clientCompleteCount = 0;
	massive.munit.Assert.assertionCount = 0;
	this.emptyParams = new Array();
	this.testSuites = new Array();
	this.startTime = massive.munit.util.Timer.stamp();
	var _g = 0;
	while(_g < testSuiteClasses.length) {
		var suiteType = testSuiteClasses[_g];
		++_g;
		this.testSuites.push(Type.createInstance(suiteType,new Array()));
	}
	this.execute();
}
massive.munit.TestRunner.prototype.execute = function() {
	var _g1 = this.suiteIndex, _g = this.testSuites.length;
	while(_g1 < _g) {
		var i = _g1++;
		var suite = this.testSuites[i];
		while( suite.hasNext() ) {
			var testClass = suite.next();
			if(this.activeHelper == null || this.activeHelper.type != testClass) {
				this.activeHelper = new massive.munit.TestClassHelper(testClass,this.isDebug);
				this.activeHelper.beforeClass.apply(this.activeHelper.test,this.emptyParams);
			}
			this.executeTestCases();
			if(!this.asyncPending) this.activeHelper.afterClass.apply(this.activeHelper.test,this.emptyParams); else {
				suite.repeat();
				this.suiteIndex = i;
				return;
			}
		}
	}
	if(!this.asyncPending) {
		var time = massive.munit.util.Timer.stamp() - this.startTime;
		var _g = 0, _g1 = this.clients;
		while(_g < _g1.length) {
			var client = _g1[_g];
			++_g;
			client.reportFinalStatistics(this.testCount,this.passCount,this.failCount,this.errorCount,this.ignoreCount,time);
		}
	}
}
massive.munit.TestRunner.prototype.executeTestCases = function() {
	var $it0 = this.activeHelper;
	while( $it0.hasNext() ) {
		var testCaseData = $it0.next();
		if(testCaseData.result.ignore) {
			this.ignoreCount++;
			var _g = 0, _g1 = this.clients;
			while(_g < _g1.length) {
				var c = _g1[_g];
				++_g;
				c.addIgnore(testCaseData.result);
			}
		} else {
			this.testCount++;
			this.activeHelper.before.apply(this.activeHelper.test,this.emptyParams);
			this.testStartTime = massive.munit.util.Timer.stamp();
			this.executeTestCase(testCaseData,testCaseData.result.async);
			if(!this.asyncPending) this.activeHelper.after.apply(this.activeHelper.test,this.emptyParams); else break;
		}
	}
}
massive.munit.TestRunner.prototype.executeTestCase = function(testCaseData,async) {
	var result = testCaseData.result;
	try {
		var assertionCount = massive.munit.Assert.assertionCount;
		if(async) {
			var delegateCount = this.asyncFactory.asyncDelegateCount;
			testCaseData.test.apply(testCaseData.scope,[this.asyncFactory]);
			if(this.asyncFactory.asyncDelegateCount == delegateCount) throw new massive.munit.async.MissingAsyncDelegateException("No AsyncDelegate was created in async test at " + result.get_location(),null);
			if(massive.munit.Assert.assertionCount > assertionCount) throw new massive.munit.AssertionException("Assertion(s) were made before async test returned at " + result.get_location(),null);
			this.asyncPending = true;
		} else {
			testCaseData.test.apply(testCaseData.scope,this.emptyParams);
			if(massive.munit.Assert.assertionCount > assertionCount) {
				result.passed = true;
				result.executionTime = massive.munit.util.Timer.stamp() - this.testStartTime;
				this.passCount++;
				var _g = 0, _g1 = this.clients;
				while(_g < _g1.length) {
					var c = _g1[_g];
					++_g;
					c.addPass(result);
				}
			} else throw new massive.munit.AssertionException("No assertions made in test case at " + result.get_location(),null);
		}
	} catch( $e0 ) {
		if( js.Boot.__instanceof($e0,massive.munit.AssertionException) ) {
			var ae = $e0;
			result.executionTime = massive.munit.util.Timer.stamp() - this.testStartTime;
			result.failure = ae;
			this.failCount++;
			var _g = 0, _g1 = this.clients;
			while(_g < _g1.length) {
				var c = _g1[_g];
				++_g;
				c.addFail(result);
			}
		} else {
		var e = $e0;
		result.executionTime = massive.munit.util.Timer.stamp() - this.testStartTime;
		if(!Std["is"](e,massive.munit.MUnitException)) e = new massive.munit.UnhandledException(e,result.get_location());
		result.error = e;
		this.errorCount++;
		var _g = 0, _g1 = this.clients;
		while(_g < _g1.length) {
			var c = _g1[_g];
			++_g;
			c.addError(result);
		}
		}
	}
}
massive.munit.TestRunner.prototype.clientCompletionHandler = function(resultClient) {
	if(++this.clientCompleteCount == this.clients.length) {
		if(this.completionHandler != null) {
			var successful = this.passCount == this.testCount;
			var handler = this.completionHandler;
			massive.munit.util.Timer.delay(function() {
				handler(successful);
			},1);
		}
		this.running = false;
	}
}
massive.munit.TestRunner.prototype.asyncResponseHandler = function(delegate) {
	var testCaseData = this.activeHelper.current();
	testCaseData.test = $closure(delegate,"runTest");
	testCaseData.scope = delegate;
	this.asyncPending = false;
	this.executeTestCase(testCaseData,false);
	this.activeHelper.after.apply(this.activeHelper.test,this.emptyParams);
	this.execute();
}
massive.munit.TestRunner.prototype.asyncTimeoutHandler = function(delegate) {
	var testCaseData = this.activeHelper.current();
	var result = testCaseData.result;
	result.executionTime = massive.munit.util.Timer.stamp() - this.testStartTime;
	result.error = new massive.munit.async.AsyncTimeoutException("",delegate.info);
	this.asyncPending = false;
	this.errorCount++;
	var _g = 0, _g1 = this.clients;
	while(_g < _g1.length) {
		var c = _g1[_g];
		++_g;
		c.addError(result);
	}
	this.activeHelper.after.apply(this.activeHelper.test,this.emptyParams);
	this.execute();
}
massive.munit.TestRunner.prototype.createAsyncFactory = function() {
	return new massive.munit.async.AsyncFactory(this);
}
massive.munit.TestRunner.prototype.__class__ = massive.munit.TestRunner;
massive.munit.TestRunner.__interfaces__ = [massive.munit.async.IAsyncDelegateObserver];
haxe.Resource = function() { }
haxe.Resource.__name__ = ["haxe","Resource"];
haxe.Resource.content = null;
haxe.Resource.listNames = function() {
	var names = new Array();
	var _g = 0, _g1 = haxe.Resource.content;
	while(_g < _g1.length) {
		var x = _g1[_g];
		++_g;
		names.push(x.name);
	}
	return names;
}
haxe.Resource.getString = function(name) {
	var _g = 0, _g1 = haxe.Resource.content;
	while(_g < _g1.length) {
		var x = _g1[_g];
		++_g;
		if(x.name == name) {
			if(x.str != null) return x.str;
			var b = haxe.Unserializer.run(x.data);
			return b.toString();
		}
	}
	return null;
}
haxe.Resource.getBytes = function(name) {
	var _g = 0, _g1 = haxe.Resource.content;
	while(_g < _g1.length) {
		var x = _g1[_g];
		++_g;
		if(x.name == name) {
			if(x.str != null) return haxe.io.Bytes.ofString(x.str);
			return haxe.Unserializer.run(x.data);
		}
	}
	return null;
}
haxe.Resource.prototype.__class__ = haxe.Resource;
TestMain = function(p) {
	if( p === $_ ) return;
	var suites = new Array();
	suites.push(TestSuite);
	var printClient = new munit.client.MCoverPrintClient(true);
	var runner = new massive.munit.TestRunner(printClient);
	runner.addResultClient(new massive.munit.client.HTTPClient(new massive.munit.client.JUnitReportClient()));
	runner.completionHandler = $closure(this,"completionHandler");
	runner.run(suites);
}
TestMain.__name__ = ["TestMain"];
TestMain.main = function() {
	new TestMain();
}
TestMain.prototype.completionHandler = function(successful) {
	try {
		js.Lib.eval("testResult(" + successful + ");");
	} catch( e ) {
	}
}
TestMain.prototype.__class__ = TestMain;
haxe.Unserializer = function(buf) {
	if( buf === $_ ) return;
	this.buf = buf;
	this.length = buf.length;
	this.pos = 0;
	this.scache = new Array();
	this.cache = new Array();
	var r = haxe.Unserializer.DEFAULT_RESOLVER;
	if(r == null) {
		r = Type;
		haxe.Unserializer.DEFAULT_RESOLVER = r;
	}
	this.setResolver(r);
}
haxe.Unserializer.__name__ = ["haxe","Unserializer"];
haxe.Unserializer.initCodes = function() {
	var codes = new Array();
	var _g1 = 0, _g = haxe.Unserializer.BASE64.length;
	while(_g1 < _g) {
		var i = _g1++;
		codes[haxe.Unserializer.BASE64.cca(i)] = i;
	}
	return codes;
}
haxe.Unserializer.run = function(v) {
	return new haxe.Unserializer(v).unserialize();
}
haxe.Unserializer.prototype.buf = null;
haxe.Unserializer.prototype.pos = null;
haxe.Unserializer.prototype.length = null;
haxe.Unserializer.prototype.cache = null;
haxe.Unserializer.prototype.scache = null;
haxe.Unserializer.prototype.resolver = null;
haxe.Unserializer.prototype.setResolver = function(r) {
	if(r == null) this.resolver = { resolveClass : function(_) {
		return null;
	}, resolveEnum : function(_) {
		return null;
	}}; else this.resolver = r;
}
haxe.Unserializer.prototype.getResolver = function() {
	return this.resolver;
}
haxe.Unserializer.prototype.get = function(p) {
	return this.buf.cca(p);
}
haxe.Unserializer.prototype.readDigits = function() {
	var k = 0;
	var s = false;
	var fpos = this.pos;
	while(true) {
		var c = this.buf.cca(this.pos);
		if(c != c) break;
		if(c == 45) {
			if(this.pos != fpos) break;
			s = true;
			this.pos++;
			continue;
		}
		if(c < 48 || c > 57) break;
		k = k * 10 + (c - 48);
		this.pos++;
	}
	if(s) k *= -1;
	return k;
}
haxe.Unserializer.prototype.unserializeObject = function(o) {
	while(true) {
		if(this.pos >= this.length) throw "Invalid object";
		if(this.buf.cca(this.pos) == 103) break;
		var k = this.unserialize();
		if(!Std["is"](k,String)) throw "Invalid object key";
		var v = this.unserialize();
		o[k] = v;
	}
	this.pos++;
}
haxe.Unserializer.prototype.unserializeEnum = function(edecl,tag) {
	var constr = Reflect.field(edecl,tag);
	if(constr == null) throw "Unknown enum tag " + Type.getEnumName(edecl) + "." + tag;
	if(this.buf.cca(this.pos++) != 58) throw "Invalid enum format";
	var nargs = this.readDigits();
	if(nargs == 0) {
		this.cache.push(constr);
		return constr;
	}
	var args = new Array();
	while(nargs > 0) {
		args.push(this.unserialize());
		nargs -= 1;
	}
	var e = constr.apply(edecl,args);
	this.cache.push(e);
	return e;
}
haxe.Unserializer.prototype.unserialize = function() {
	switch(this.buf.cca(this.pos++)) {
	case 110:
		return null;
	case 116:
		return true;
	case 102:
		return false;
	case 122:
		return 0;
	case 105:
		return this.readDigits();
	case 100:
		var p1 = this.pos;
		while(true) {
			var c = this.buf.cca(this.pos);
			if(c >= 43 && c < 58 || c == 101 || c == 69) this.pos++; else break;
		}
		return Std.parseFloat(this.buf.substr(p1,this.pos - p1));
	case 121:
		var len = this.readDigits();
		if(this.buf.cca(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid string length";
		var s = this.buf.substr(this.pos,len);
		this.pos += len;
		s = StringTools.urlDecode(s);
		this.scache.push(s);
		return s;
	case 107:
		return Math.NaN;
	case 109:
		return Math.NEGATIVE_INFINITY;
	case 112:
		return Math.POSITIVE_INFINITY;
	case 97:
		var buf = this.buf;
		var a = new Array();
		this.cache.push(a);
		while(true) {
			var c = this.buf.cca(this.pos);
			if(c == 104) {
				this.pos++;
				break;
			}
			if(c == 117) {
				this.pos++;
				var n = this.readDigits();
				a[a.length + n - 1] = null;
			} else a.push(this.unserialize());
		}
		return a;
	case 111:
		var o = { };
		this.cache.push(o);
		this.unserializeObject(o);
		return o;
	case 114:
		var n = this.readDigits();
		if(n < 0 || n >= this.cache.length) throw "Invalid reference";
		return this.cache[n];
	case 82:
		var n = this.readDigits();
		if(n < 0 || n >= this.scache.length) throw "Invalid string reference";
		return this.scache[n];
	case 120:
		throw this.unserialize();
		break;
	case 99:
		var name = this.unserialize();
		var cl = this.resolver.resolveClass(name);
		if(cl == null) throw "Class not found " + name;
		var o = Type.createEmptyInstance(cl);
		this.cache.push(o);
		this.unserializeObject(o);
		return o;
	case 119:
		var name = this.unserialize();
		var edecl = this.resolver.resolveEnum(name);
		if(edecl == null) throw "Enum not found " + name;
		return this.unserializeEnum(edecl,this.unserialize());
	case 106:
		var name = this.unserialize();
		var edecl = this.resolver.resolveEnum(name);
		if(edecl == null) throw "Enum not found " + name;
		this.pos++;
		var index = this.readDigits();
		var tag = Type.getEnumConstructs(edecl)[index];
		if(tag == null) throw "Unknown enum index " + name + "@" + index;
		return this.unserializeEnum(edecl,tag);
	case 108:
		var l = new List();
		this.cache.push(l);
		var buf = this.buf;
		while(this.buf.cca(this.pos) != 104) l.add(this.unserialize());
		this.pos++;
		return l;
	case 98:
		var h = new Hash();
		this.cache.push(h);
		var buf = this.buf;
		while(this.buf.cca(this.pos) != 104) {
			var s = this.unserialize();
			h.set(s,this.unserialize());
		}
		this.pos++;
		return h;
	case 113:
		var h = new IntHash();
		this.cache.push(h);
		var buf = this.buf;
		var c = this.buf.cca(this.pos++);
		while(c == 58) {
			var i = this.readDigits();
			h.set(i,this.unserialize());
			c = this.buf.cca(this.pos++);
		}
		if(c != 104) throw "Invalid IntHash format";
		return h;
	case 118:
		var d = Date.fromString(this.buf.substr(this.pos,19));
		this.cache.push(d);
		this.pos += 19;
		return d;
	case 115:
		var len = this.readDigits();
		var buf = this.buf;
		if(this.buf.cca(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid bytes length";
		var codes = haxe.Unserializer.CODES;
		if(codes == null) {
			codes = haxe.Unserializer.initCodes();
			haxe.Unserializer.CODES = codes;
		}
		var i = this.pos;
		var rest = len & 3;
		var size = (len >> 2) * 3 + (rest >= 2?rest - 1:0);
		var max = i + (len - rest);
		var bytes = haxe.io.Bytes.alloc(size);
		var bpos = 0;
		while(i < max) {
			var c1 = codes[buf.cca(i++)];
			var c2 = codes[buf.cca(i++)];
			bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
			var c3 = codes[buf.cca(i++)];
			bytes.b[bpos++] = (c2 << 4 | c3 >> 2) & 255;
			var c4 = codes[buf.cca(i++)];
			bytes.b[bpos++] = (c3 << 6 | c4) & 255;
		}
		if(rest >= 2) {
			var c1 = codes[buf.cca(i++)];
			var c2 = codes[buf.cca(i++)];
			bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
			if(rest == 3) {
				var c3 = codes[buf.cca(i++)];
				bytes.b[bpos++] = (c2 << 4 | c3 >> 2) & 255;
			}
		}
		this.pos += len;
		this.cache.push(bytes);
		return bytes;
	case 67:
		var name = this.unserialize();
		var cl = this.resolver.resolveClass(name);
		if(cl == null) throw "Class not found " + name;
		var o = Type.createEmptyInstance(cl);
		this.cache.push(o);
		o.hxUnserialize(this);
		if(this.buf.cca(this.pos++) != 103) throw "Invalid custom data";
		return o;
	default:
	}
	this.pos--;
	throw "Invalid char " + this.buf.charAt(this.pos) + " at position " + this.pos;
}
haxe.Unserializer.prototype.__class__ = haxe.Unserializer;
massive.munit.AssertionException = function(msg,info) {
	if( msg === $_ ) return;
	massive.munit.MUnitException.call(this,msg,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "AssertionException.hx", lineNumber : 49, className : "massive.munit.AssertionException", methodName : "new"}).className;
}
massive.munit.AssertionException.__name__ = ["massive","munit","AssertionException"];
massive.munit.AssertionException.__super__ = massive.munit.MUnitException;
for(var k in massive.munit.MUnitException.prototype ) massive.munit.AssertionException.prototype[k] = massive.munit.MUnitException.prototype[k];
massive.munit.AssertionException.prototype.__class__ = massive.munit.AssertionException;
massive.munit.async.AsyncFactory = function(observer) {
	if( observer === $_ ) return;
	this.observer = observer;
	this.asyncDelegateCount = 0;
}
massive.munit.async.AsyncFactory.__name__ = ["massive","munit","async","AsyncFactory"];
massive.munit.async.AsyncFactory.prototype.observer = null;
massive.munit.async.AsyncFactory.prototype.asyncDelegateCount = null;
massive.munit.async.AsyncFactory.prototype.createHandler = function(testCase,handler,timeout,info) {
	var dispatcher = new massive.munit.async.AsyncDelegate(testCase,handler,timeout,info);
	dispatcher.observer = this.observer;
	this.asyncDelegateCount++;
	return dispatcher.delegateHandler;
}
massive.munit.async.AsyncFactory.prototype.__class__ = massive.munit.async.AsyncFactory;
if(!haxe.io) haxe.io = {}
haxe.io.Error = { __ename__ : ["haxe","io","Error"], __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] }
haxe.io.Error.Blocked = ["Blocked",0];
haxe.io.Error.Blocked.toString = $estr;
haxe.io.Error.Blocked.__enum__ = haxe.io.Error;
haxe.io.Error.Overflow = ["Overflow",1];
haxe.io.Error.Overflow.toString = $estr;
haxe.io.Error.Overflow.__enum__ = haxe.io.Error;
haxe.io.Error.OutsideBounds = ["OutsideBounds",2];
haxe.io.Error.OutsideBounds.toString = $estr;
haxe.io.Error.OutsideBounds.__enum__ = haxe.io.Error;
haxe.io.Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe.io.Error; $x.toString = $estr; return $x; }
haxe.io.Bytes = function(length,b) {
	if( length === $_ ) return;
	this.length = length;
	this.b = b;
}
haxe.io.Bytes.__name__ = ["haxe","io","Bytes"];
haxe.io.Bytes.alloc = function(length) {
	var a = new Array();
	var _g = 0;
	while(_g < length) {
		var i = _g++;
		a.push(0);
	}
	return new haxe.io.Bytes(length,a);
}
haxe.io.Bytes.ofString = function(s) {
	var a = new Array();
	var _g1 = 0, _g = s.length;
	while(_g1 < _g) {
		var i = _g1++;
		var c = s.cca(i);
		if(c <= 127) a.push(c); else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe.io.Bytes(a.length,a);
}
haxe.io.Bytes.ofData = function(b) {
	return new haxe.io.Bytes(b.length,b);
}
haxe.io.Bytes.prototype.length = null;
haxe.io.Bytes.prototype.b = null;
haxe.io.Bytes.prototype.get = function(pos) {
	return this.b[pos];
}
haxe.io.Bytes.prototype.set = function(pos,v) {
	this.b[pos] = v & 255;
}
haxe.io.Bytes.prototype.blit = function(pos,src,srcpos,len) {
	if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) throw haxe.io.Error.OutsideBounds;
	var b1 = this.b;
	var b2 = src.b;
	if(b1 == b2 && pos > srcpos) {
		var i = len;
		while(i > 0) {
			i--;
			b1[i + pos] = b2[i + srcpos];
		}
		return;
	}
	var _g = 0;
	while(_g < len) {
		var i = _g++;
		b1[i + pos] = b2[i + srcpos];
	}
}
haxe.io.Bytes.prototype.sub = function(pos,len) {
	if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
	return new haxe.io.Bytes(len,this.b.slice(pos,pos + len));
}
haxe.io.Bytes.prototype.compare = function(other) {
	var b1 = this.b;
	var b2 = other.b;
	var len = this.length < other.length?this.length:other.length;
	var _g = 0;
	while(_g < len) {
		var i = _g++;
		if(b1[i] != b2[i]) return b1[i] - b2[i];
	}
	return this.length - other.length;
}
haxe.io.Bytes.prototype.readString = function(pos,len) {
	if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
	var s = "";
	var b = this.b;
	var fcc = String.fromCharCode;
	var i = pos;
	var max = pos + len;
	while(i < max) {
		var c = b[i++];
		if(c < 128) {
			if(c == 0) break;
			s += fcc(c);
		} else if(c < 224) s += fcc((c & 63) << 6 | b[i++] & 127); else if(c < 240) {
			var c2 = b[i++];
			s += fcc((c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127);
		} else {
			var c2 = b[i++];
			var c3 = b[i++];
			s += fcc((c & 15) << 18 | (c2 & 127) << 12 | c3 << 6 & 127 | b[i++] & 127);
		}
	}
	return s;
}
haxe.io.Bytes.prototype.toString = function() {
	return this.readString(0,this.length);
}
haxe.io.Bytes.prototype.toHex = function() {
	var s = new StringBuf();
	var chars = [];
	var str = "0123456789abcdef";
	var _g1 = 0, _g = str.length;
	while(_g1 < _g) {
		var i = _g1++;
		chars.push(str.charCodeAt(i));
	}
	var _g1 = 0, _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		var c = this.b[i];
		s.b[s.b.length] = String.fromCharCode(chars[c >> 4]);
		s.b[s.b.length] = String.fromCharCode(chars[c & 15]);
	}
	return s.b.join("");
}
haxe.io.Bytes.prototype.getData = function() {
	return this.b;
}
haxe.io.Bytes.prototype.__class__ = haxe.io.Bytes;
js.Lib = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.isIE = null;
js.Lib.isOpera = null;
js.Lib.document = null;
js.Lib.window = null;
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
js.Lib.prototype.__class__ = js.Lib;
StringTools = function() { }
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&");
}
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && s.substr(0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && s.substr(slen - elen,elen) == end;
}
StringTools.isSpace = function(s,pos) {
	var c = s.charCodeAt(pos);
	return c >= 9 && c <= 13 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return s.substr(r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return s.substr(0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.rpad = function(s,c,l) {
	var sl = s.length;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		s += c.substr(0,l - sl);
		sl = l;
	} else {
		s += c;
		sl += cl;
	}
	return s;
}
StringTools.lpad = function(s,c,l) {
	var ns = "";
	var sl = s.length;
	if(sl >= l) return s;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		ns += c.substr(0,l - sl);
		sl = l;
	} else {
		ns += c;
		sl += cl;
	}
	return ns + s;
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
}
StringTools.fastCodeAt = function(s,index) {
	return s.cca(index);
}
StringTools.isEOF = function(c) {
	return c != c;
}
StringTools.prototype.__class__ = StringTools;
massive.munit.util.MathUtil = function(p) {
}
massive.munit.util.MathUtil.__name__ = ["massive","munit","util","MathUtil"];
massive.munit.util.MathUtil.round = function(value,precision) {
	value = value * Math.pow(10,precision);
	return Math.round(value) / Math.pow(10,precision);
}
massive.munit.util.MathUtil.prototype.__class__ = massive.munit.util.MathUtil;
$_ = {}
js.Boot.__res = {}
js.Boot.__init();
js["XMLHttpRequest"] = window.XMLHttpRequest?XMLHttpRequest:window.ActiveXObject?function() {
	try {
		return new ActiveXObject("Msxml2.XMLHTTP");
	} catch( e ) {
		try {
			return new ActiveXObject("Microsoft.XMLHTTP");
		} catch( e1 ) {
			throw "Unable to create XMLHttpRequest object.";
		}
	}
}:(function($this) {
	var $r;
	throw "Unable to create XMLHttpRequest object.";
	return $r;
}(this));
{
	Math.__name__ = ["Math"];
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
	Math.isFinite = function(i) {
		return isFinite(i);
	};
	Math.isNaN = function(i) {
		return isNaN(i);
	};
}
{
	String.prototype.__class__ = String;
	String.__name__ = ["String"];
	Array.prototype.__class__ = Array;
	Array.__name__ = ["Array"];
	Int = { __name__ : ["Int"]};
	Dynamic = { __name__ : ["Dynamic"]};
	Float = Number;
	Float.__name__ = ["Float"];
	Bool = { __ename__ : ["Bool"]};
	Class = { __name__ : ["Class"]};
	Enum = { };
	Void = { __ename__ : ["Void"]};
}
haxe.Resource.content = [{ name : "MCover", data : "s1990:MHxzcmN8bWFzc2l2ZS5tY292ZXJ8TUNvdmVyUnVubmVyfDQxNTB8NDIxNXxzcmMvbWFzc2l2ZS9tY292ZXIvTUNvdmVyUnVubmVyLmh4OjIwMjogY2hhcmFjdGVycyAzLTY4CjF8c3JjfG1hc3NpdmUubWNvdmVyfE1Db3ZlclJ1bm5lcnw0NDMwfDQ0OTB8c3JjL21hc3NpdmUvbWNvdmVyL01Db3ZlclJ1bm5lci5oeDoyMTI6IGNoYXJhY3RlcnMgMy02MwoyfHNyY3xtYXNzaXZlLm1jb3ZlcnxNQ292ZXJSdW5uZXJ8Mzk4NXw0MDI2fHNyYy9tYXNzaXZlL21jb3Zlci9NQ292ZXJSdW5uZXIuaHg6MTk3OiBjaGFyYWN0ZXJzIDItNDMKM3xzcmN8bWFzc2l2ZS5tY292ZXJ8TUNvdmVyUnVubmVyfDM2NTN8MzY5OHxzcmMvbWFzc2l2ZS9tY292ZXIvTUNvdmVyUnVubmVyLmh4OjE4MDogY2hhcmFjdGVycyAyLTQ3CjR8c3JjfG1hc3NpdmUubWNvdmVyfE1Db3ZlclJ1bm5lcnwzNDc4fDM1MTB8c3JjL21hc3NpdmUvbWNvdmVyL01Db3ZlclJ1bm5lci5oeDoxNzE6IGNoYXJhY3RlcnMgNC0zNgo1fHNyY3xtYXNzaXZlLm1jb3ZlcnxNQ292ZXJSdW5uZXJ8MzQzOHwzNjE0fHNyYy9tYXNzaXZlL21jb3Zlci9NQ292ZXJSdW5uZXIuaHg6MTY5OiBsaW5lcyAxNjktMTc0CjZ8c3JjfG1hc3NpdmUubWNvdmVyfE1Db3ZlclJ1bm5lcnwzMzg2fDM2MTh8c3JjL21hc3NpdmUvbWNvdmVyL01Db3ZlclJ1bm5lci5oeDoxNjc6IGxpbmVzIDE2Ny0xNzUKN3xzcmN8bWFzc2l2ZS5tY292ZXJ8TUNvdmVyUnVubmVyfDMxMDB8MzEzMXxzcmMvbWFzc2l2ZS9tY292ZXIvTUNvdmVyUnVubmVyLmh4OjE1NDogY2hhcmFjdGVycyAzLTM0Cjh8c3JjfG1hc3NpdmUubWNvdmVyfE1Db3ZlclJ1bm5lcnwzMDQxfDMwNjR8c3JjL21hc3NpdmUvbWNvdmVyL01Db3ZlclJ1bm5lci5oeDoxNTA6IGNoYXJhY3RlcnMgMi0yNQo5fHNyY3xtYXNzaXZlLm1jb3ZlcnxNQ292ZXJSdW5uZXJ8MjkxN3wyOTI3fHNyYy9tYXNzaXZlL21jb3Zlci9NQ292ZXJSdW5uZXIuaHg6MTQwOiBjaGFyYWN0ZXJzIDMtMTMKMTB8c3JjfG1hc3NpdmUubWNvdmVyfE1Db3ZlclJ1bm5lcnwyNzQ0fDI3ODB8c3JjL21hc3NpdmUvbWNvdmVyL01Db3ZlclJ1bm5lci5oeDoxMzI6IGNoYXJhY3RlcnMgMi0zOAoxMXxzcmN8bWFzc2l2ZS5tY292ZXJ8TUNvdmVyUnVubmVyfDE3NDJ8MTc1NHxzcmMvbWFzc2l2ZS9tY292ZXIvTUNvdmVyUnVubmVyLmh4Ojc3OiBjaGFyYWN0ZXJzIDItMTQKMTJ8c3JjfG1hc3NpdmUubWNvdmVyfE1Db3ZlclJ1bm5lcnwxNjk5fDE3MDZ8c3JjL21hc3NpdmUvbWNvdmVyL01Db3ZlclJ1bm5lci5oeDo3MjogY2hhcmFjdGVycyAyLTkKMTN8c3JjfG1hc3NpdmUubWNvdmVyfE1Db3ZlclJ1bm5lcnw5Nzd8MTAwMXxzcmMvbWFzc2l2ZS9tY292ZXIvTUNvdmVyUnVubmVyLmh4OjQzOiBjaGFyYWN0ZXJzIDItMjYKMTR8c3JjfG1hc3NpdmUubWNvdmVyfE1Db3ZlclJ1bm5lcnw3NDF8NzYxfHNyYy9tYXNzaXZlL21jb3Zlci9NQ292ZXJSdW5uZXIuaHg6MzM6IGNoYXJhY3RlcnMgMi0yMg"}];
{
	js.Lib.document = document;
	js.Lib.window = window;
	onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if( f == null )
			return false;
		return f(msg,[url+":"+line]);
	}
}
{
	var d = Date;
	d.now = function() {
		return new Date();
	};
	d.fromTime = function(t) {
		var d1 = new Date();
		d1["setTime"](t);
		return d1;
	};
	d.fromString = function(s) {
		switch(s.length) {
		case 8:
			var k = s.split(":");
			var d1 = new Date();
			d1["setTime"](0);
			d1["setUTCHours"](k[0]);
			d1["setUTCMinutes"](k[1]);
			d1["setUTCSeconds"](k[2]);
			return d1;
		case 10:
			var k = s.split("-");
			return new Date(k[0],k[1] - 1,k[2],0,0,0);
		case 19:
			var k = s.split(" ");
			var y = k[0].split("-");
			var t = k[1].split(":");
			return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
		default:
			throw "Invalid date format : " + s;
		}
	};
	d.prototype["toString"] = function() {
		var date = this;
		var m = date.getMonth() + 1;
		var d1 = date.getDate();
		var h = date.getHours();
		var mi = date.getMinutes();
		var s = date.getSeconds();
		return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d1 < 10?"0" + d1:"" + d1) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
	};
	d.prototype.__class__ = d;
	d.__name__ = ["Date"];
}
massive.munit.async.AsyncDelegate.DEFAULT_TIMEOUT = 400;
massive.munit.client.PrintClient.DEFAULT_ID = "print";
massive.mcover.CoverageEntryTest.__meta__ = { fields : { beforeClass : { BeforeClass : null}, afterClass : { AfterClass : null}, setup : { Before : null}, tearDown : { After : null}, shouldDeserializeKeyInConstructor : { Test : null}, shouldThrowErrorOnInvalidKeyFormat : { Test : null}, shouldThrowErrorOnEmptyKey : { Test : null}, shouldSerialiseToKey : { Test : null}, shouldChangeResultWhenCountChanges : { Test : null}}};
massive.mcover.CoverageEntryTest.DEFAULT_KEY = "1|src|foo|Main|1|100|location";
massive.munit.client.HTTPClient.DEFAULT_SERVER_URL = "http://localhost:2000";
massive.munit.client.HTTPClient.DEFAULT_ID = "HTTPClient";
massive.munit.client.HTTPClient.CLIENT_HEADER_KEY = "munit-clientId";
massive.munit.client.HTTPClient.PLATFORM_HEADER_KEY = "munit-platformId";
massive.munit.client.HTTPClient.queue = [];
massive.munit.client.HTTPClient.responsePending = false;
massive.mcover.CoverageEntry.__meta__ = { obj : { IgnoreCover : null}};
massive.munit.TestClassHelper.META_TAG_BEFORE_CLASS = "BeforeClass";
massive.munit.TestClassHelper.META_TAG_AFTER_CLASS = "AfterClass";
massive.munit.TestClassHelper.META_TAG_BEFORE = "Before";
massive.munit.TestClassHelper.META_TAG_AFTER = "After";
massive.munit.TestClassHelper.META_TAG_TEST = "Test";
massive.munit.TestClassHelper.META_TAG_ASYNC_TEST = "AsyncTest";
massive.munit.TestClassHelper.META_TAG_IGNORE = "Ignore";
massive.munit.TestClassHelper.META_PARAM_ASYNC_TEST = "Async";
massive.munit.TestClassHelper.META_TAG_TEST_DEBUG = "TestDebug";
massive.munit.TestClassHelper.META_TAGS = ["BeforeClass","AfterClass","Before","After","Test","AsyncTest","TestDebug"];
massive.mcover.client.PrintClient.__meta__ = { obj : { IgnoreCover : null}};
massive.mcover.client.PrintClient.DEFAULT_ID = "print";
massive.mcover.client.TraceClient.__meta__ = { obj : { IgnoreCover : null}};
massive.mcover.util.Timer.__meta__ = { obj : { IgnoreCover : null}};
massive.mcover.util.Timer.arr = new Array();
massive.munit.Assert.assertionCount = 0;
massive.mcover.MCoverRunner.__meta__ = { statics : { log : { IgnoreCover : null}}, fields : { tick : { IgnoreCover : null}}};
massive.mcover.MCoverRunner.reportPending = false;
massive.mcover.MCoverRunner.clientQueue = [];
massive.mcover.MCoverRunner.logQueue = [];
massive.mcover.MCoverRunner.instance = new massive.mcover.MCoverRunner();
massive.mcover.CoverageEntryCollection.__meta__ = { obj : { IgnoreCover : null}};
massive.munit.client.JUnitReportClient.DEFAULT_ID = "junit";
massive.munit.util.Timer.arr = new Array();
haxe.Unserializer.DEFAULT_RESOLVER = Type;
haxe.Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.CODES = null;
js.Lib.onerror = null;
TestMain.main()