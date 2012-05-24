$estr = function() { return js.Boot.__string_rec(this,''); }
if(typeof haxe=='undefined') haxe = {}
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
if(typeof m=='undefined') m = {}
if(!m.cover) m.cover = {}
if(!m.cover.util) m.cover.util = {}
m.cover.util.Timer = function(time_ms) {
	if( time_ms === $_ ) return;
	this.run = $closure(this,"defaultRun");
	this.id = m.cover.util.Timer.arr.length;
	m.cover.util.Timer.arr[this.id] = this;
	this.timerId = window.setInterval("m.cover.util.Timer.arr[" + this.id + "].run();",time_ms);
}
m.cover.util.Timer.__name__ = ["m","cover","util","Timer"];
m.cover.util.Timer.delay = function(f,time_ms) {
	var t = new m.cover.util.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
m.cover.util.Timer.stamp = function() {
	return Date.now().getTime() / 1000;
}
m.cover.util.Timer.inlineStamp = function() {
	return Date.now().getTime() / 1000;
}
m.cover.util.Timer.prototype.run = null;
m.cover.util.Timer.prototype.id = null;
m.cover.util.Timer.prototype.timerId = null;
m.cover.util.Timer.prototype.defaultRun = function() {
}
m.cover.util.Timer.prototype.stop = function() {
	if(this.id == null) return;
	window.clearInterval(this.timerId);
	m.cover.util.Timer.arr[this.id] = null;
	if(this.id > 100 && this.id == m.cover.util.Timer.arr.length - 1) {
		var p = this.id - 1;
		while(p >= 0 && m.cover.util.Timer.arr[p] == null) p--;
		m.cover.util.Timer.arr = m.cover.util.Timer.arr.slice(0,p + 1);
	}
	this.id = null;
}
m.cover.util.Timer.prototype.__class__ = m.cover.util.Timer;
if(!m.cover.coverage) m.cover.coverage = {}
m.cover.coverage.CoverageLogger = function() { }
m.cover.coverage.CoverageLogger.__name__ = ["m","cover","coverage","CoverageLogger"];
m.cover.coverage.CoverageLogger.prototype.completionHandler = null;
m.cover.coverage.CoverageLogger.prototype.coverage = null;
m.cover.coverage.CoverageLogger.prototype.currentTest = null;
m.cover.coverage.CoverageLogger.prototype.report = null;
m.cover.coverage.CoverageLogger.prototype.reportCurrentTest = null;
m.cover.coverage.CoverageLogger.prototype.addClient = null;
m.cover.coverage.CoverageLogger.prototype.removeClient = null;
m.cover.coverage.CoverageLogger.prototype.getClients = null;
m.cover.coverage.CoverageLogger.prototype.initializeCoverage = null;
m.cover.coverage.CoverageLogger.prototype.logStatement = null;
m.cover.coverage.CoverageLogger.prototype.logBranch = null;
m.cover.coverage.CoverageLogger.prototype.__class__ = m.cover.coverage.CoverageLogger;
m.cover.coverage.CoverageLoggerImpl = function(p) {
	if( p === $_ ) return;
	this.allStatementResultsById = new IntHash();
	this.allBranchResultsById = new IntHash();
	this.clients = [];
}
m.cover.coverage.CoverageLoggerImpl.__name__ = ["m","cover","coverage","CoverageLoggerImpl"];
m.cover.coverage.CoverageLoggerImpl.prototype.completionHandler = null;
m.cover.coverage.CoverageLoggerImpl.prototype.coverage = null;
m.cover.coverage.CoverageLoggerImpl.prototype.currentTest = null;
m.cover.coverage.CoverageLoggerImpl.prototype.allStatementResultsById = null;
m.cover.coverage.CoverageLoggerImpl.prototype.allBranchResultsById = null;
m.cover.coverage.CoverageLoggerImpl.prototype.testStatementResultsById = null;
m.cover.coverage.CoverageLoggerImpl.prototype.testBranchResultsById = null;
m.cover.coverage.CoverageLoggerImpl.prototype.clients = null;
m.cover.coverage.CoverageLoggerImpl.prototype.clientCompleteCount = null;
m.cover.coverage.CoverageLoggerImpl.prototype.report = function(skipClients) {
	if(skipClients == null) skipClients = false;
	this.generateReportResults(false);
	if(!skipClients) this.reportToClients();
}
m.cover.coverage.CoverageLoggerImpl.prototype.reportCurrentTest = function(skipClients) {
	if(skipClients == null) skipClients = false;
	if(this.currentTest == null) throw new m.cover.coverage.CoverageException("No test specified to report on.",null,{ fileName : "CoverageLogger.hx", lineNumber : 137, className : "m.cover.coverage.CoverageLoggerImpl", methodName : "reportCurrentTest"});
	this.generateReportResults(true);
	if(!skipClients) this.reportToClients();
}
m.cover.coverage.CoverageLoggerImpl.prototype.generateReportResults = function(currentTestOnly) {
	if(currentTestOnly == null) currentTestOnly = false;
	if(this.coverage == null) this.initializeCoverage();
	if(currentTestOnly) {
		this.coverage.setStatementResultsHash(this.testStatementResultsById);
		this.coverage.setBranchResultsHash(this.testBranchResultsById);
	} else {
		this.coverage.setStatementResultsHash(this.allStatementResultsById);
		this.coverage.setBranchResultsHash(this.allBranchResultsById);
	}
	this.coverage.getResults(false);
}
m.cover.coverage.CoverageLoggerImpl.prototype.addClient = function(client) {
	if(client == null) throw "Null Client";
	var _g = 0, _g1 = this.clients;
	while(_g < _g1.length) {
		var c = _g1[_g];
		++_g;
		if(c == client) return;
	}
	client.completionHandler = $closure(this,"clientCompletionHandler");
	this.clients.push(client);
}
m.cover.coverage.CoverageLoggerImpl.prototype.removeClient = function(client) {
	client.completionHandler = null;
	this.clients.remove(client);
}
m.cover.coverage.CoverageLoggerImpl.prototype.getClients = function() {
	return this.clients.concat([]);
}
m.cover.coverage.CoverageLoggerImpl.prototype.initializeCoverage = function(resourceName) {
	if(resourceName == null) resourceName = m.cover.coverage.MCoverage.RESOURCE_DATA;
	var serializedData = haxe.Resource.getString(resourceName);
	if(serializedData == null) throw new m.cover.coverage.CoverageException("No generated coverage data found in haxe Resource '" + resourceName + "'",null,{ fileName : "CoverageLogger.hx", lineNumber : 196, className : "m.cover.coverage.CoverageLoggerImpl", methodName : "initializeCoverage"});
	try {
		this.coverage = haxe.Unserializer.run(serializedData);
	} catch( e ) {
		throw new m.cover.coverage.CoverageException("Unable to unserialize coverage data in " + resourceName,e,{ fileName : "CoverageLogger.hx", lineNumber : 203, className : "m.cover.coverage.CoverageLoggerImpl", methodName : "initializeCoverage"});
	}
}
m.cover.coverage.CoverageLoggerImpl.prototype.logStatement = function(id) {
	this.updateStatementHash(this.allStatementResultsById,id);
	if(this.currentTest != null) this.updateStatementHash(this.testStatementResultsById,id);
}
m.cover.coverage.CoverageLoggerImpl.prototype.updateStatementHash = function(hash,id) {
	var count = 1;
	if(hash.exists(id)) count = hash.get(id) + 1;
	hash.set(id,count);
}
m.cover.coverage.CoverageLoggerImpl.prototype.logBranch = function(id,value,compareValue) {
	var bool = false;
	if(compareValue != null) bool = value == compareValue; else bool = value;
	this.updateBranchHash(this.allBranchResultsById,id,bool);
	if(this.currentTest != null) this.updateBranchHash(this.testBranchResultsById,id,bool);
	return value;
}
m.cover.coverage.CoverageLoggerImpl.prototype.updateBranchHash = function(hash,id,value) {
	var r = null;
	if(hash.exists(id)) r = hash.get(id); else {
		r = { id : id, trueCount : 0, falseCount : 0, total : 0};
		hash.set(id,r);
	}
	if(value) r.trueCount++; else r.falseCount++;
	r.total++;
}
m.cover.coverage.CoverageLoggerImpl.prototype.set_currentTest = function(value) {
	this.currentTest = value;
	this.testStatementResultsById = new IntHash();
	this.testBranchResultsById = new IntHash();
	return value;
}
m.cover.coverage.CoverageLoggerImpl.prototype.reportToClients = function() {
	if(this.clients.length == 0) this.addClient(new m.cover.coverage.client.TraceClient());
	this.clientCompleteCount = 0;
	var _g = 0, _g1 = this.clients;
	while(_g < _g1.length) {
		var client = _g1[_g];
		++_g;
		client.report(this.coverage);
	}
}
m.cover.coverage.CoverageLoggerImpl.prototype.clientCompletionHandler = function(client) {
	this.clientCompleteCount++;
	if(this.clientCompleteCount == this.clients.length) {
		if(this.completionHandler != null) this.executeCompletionHandler();
	}
}
m.cover.coverage.CoverageLoggerImpl.prototype.executeCompletionHandler = function() {
	var percent = this.coverage.getPercentage();
	this.completionHandler(percent);
}
m.cover.coverage.CoverageLoggerImpl.prototype.__class__ = m.cover.coverage.CoverageLoggerImpl;
m.cover.coverage.CoverageLoggerImpl.__interfaces__ = [m.cover.coverage.CoverageLogger];
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
if(!m.cover.coverage.data) m.cover.coverage.data = {}
m.cover.coverage.data.AbstractNode = function(p) {
}
m.cover.coverage.data.AbstractNode.__name__ = ["m","cover","coverage","data","AbstractNode"];
m.cover.coverage.data.AbstractNode.prototype.id = null;
m.cover.coverage.data.AbstractNode.prototype.name = null;
m.cover.coverage.data.AbstractNode.prototype.resultCache = null;
m.cover.coverage.data.AbstractNode.prototype.getResults = function(cache) {
	if(cache == null) cache = true;
	if(this.resultCache == null || !cache) this.resultCache = this.emptyResult();
	return this.resultCache;
}
m.cover.coverage.data.AbstractNode.prototype.getPercentage = function() {
	var r = this.getResults();
	try {
		var p = Math.round((r.bt + r.bf + r.sc + r.mc) / (2 * r.b + r.s + r.m) * 10000) / 100;
		if(Math.isNaN(p)) throw "NaN";
		return p;
	} catch( e ) {
	}
	return 0;
}
m.cover.coverage.data.AbstractNode.prototype.getClasses = function() {
	return [];
}
m.cover.coverage.data.AbstractNode.prototype.lookupBranch = function(path) {
	return null;
}
m.cover.coverage.data.AbstractNode.prototype.lookupStatement = function(path) {
	return null;
}
m.cover.coverage.data.AbstractNode.prototype.getMissingBranches = function() {
	return [];
}
m.cover.coverage.data.AbstractNode.prototype.getMissingStatements = function() {
	return [];
}
m.cover.coverage.data.AbstractNode.prototype.emptyResult = function() {
	return { lc : 0, lp : 0, l : 0, sc : 0, s : 0, bt : 0, bf : 0, bc : 0, b : 0, mc : 0, m : 0, cc : 0, c : 0, fc : 0, f : 0, pc : 0, p : 0};
}
m.cover.coverage.data.AbstractNode.prototype.hxSerialize = function(s) {
	s.serialize(this.id);
	s.serialize(this.name);
}
m.cover.coverage.data.AbstractNode.prototype.hxUnserialize = function(s) {
	this.id = s.unserialize();
	this.name = s.unserialize();
}
m.cover.coverage.data.AbstractNode.prototype.__class__ = m.cover.coverage.data.AbstractNode;
haxe.Log = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype.__class__ = haxe.Log;
if(typeof example=='undefined') example = {}
example.Example = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.MCoverage.getLogger().logStatement(53);
	this.covered();
	this.ifMethod(true);
	this.ifMethod(false);
	this.elseIfMethod(0);
	this.elseIfMethod(1);
	this.elseIfMethod(2);
	this.switchMethod(0);
	this.switchMethod(1);
	this.switchMethod(2);
	this.tryCatch(false);
	this.tryCatch(true);
	this.forLoops();
	this.whileLoop();
	this.ternaryExpression(true);
	this.ternaryExpression(false);
	this.inlineFunction();
	this.branchBool(true,false);
	this.branchBool(false,true);
	this.branchBool(true,true);
	this.branchBool(false,false);
	this.branchInt(1,0);
	this.branchInt(0,1);
	this.branchInt(1,1);
	var a = "a";
	var b = "b";
	this.branchString(a,b);
	this.branchString(a,a);
	this.branchFloat(1.1,0.1);
	this.branchFloat(0.1,1.1);
	this.branchFloat(1.1,1.1);
	this.classInstances();
}
example.Example.__name__ = ["example","Example"];
example.Example.log = function(cover,pos) {
	if(cover == null) cover = true;
}
example.Example.prototype.classInstances = function() {
	m.cover.coverage.MCoverage.getLogger().logStatement(1);
	var internalInst = new example.InternalClass();
	var internalIgnoredInst = new example.InternalClassWithIgnore();
	var privateInst = new example._Example.PrivateClass();
	var privateIgnoredInst = new example._Example.PrivateClassWithIgnore();
}
example.Example.prototype.branchFloat = function(a,b) {
	m.cover.coverage.MCoverage.getLogger().logStatement(8);
	if(m.cover.coverage.MCoverage.getLogger().logBranch(0,a == b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(2);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 286, className : "example.Example", methodName : "branchFloat"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(1,a != b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(3);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 290, className : "example.Example", methodName : "branchFloat"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(2,a < b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(4);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 295, className : "example.Example", methodName : "branchFloat"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(3,a <= b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(5);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 300, className : "example.Example", methodName : "branchFloat"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(4,a > b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(6);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 305, className : "example.Example", methodName : "branchFloat"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(5,a >= b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(7);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 310, className : "example.Example", methodName : "branchFloat"});
	}
}
example.Example.prototype.branchString = function(a,b) {
	m.cover.coverage.MCoverage.getLogger().logStatement(11);
	if(m.cover.coverage.MCoverage.getLogger().logBranch(6,a == b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(9);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 274, className : "example.Example", methodName : "branchString"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(7,a != b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(10);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 278, className : "example.Example", methodName : "branchString"});
	}
}
example.Example.prototype.branchInt = function(a,b) {
	m.cover.coverage.MCoverage.getLogger().logStatement(18);
	if(m.cover.coverage.MCoverage.getLogger().logBranch(8,a == b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(12);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 243, className : "example.Example", methodName : "branchInt"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(9,a != b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(13);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 247, className : "example.Example", methodName : "branchInt"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(10,a < b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(14);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 252, className : "example.Example", methodName : "branchInt"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(11,a <= b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(15);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 257, className : "example.Example", methodName : "branchInt"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(12,a > b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(16);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 262, className : "example.Example", methodName : "branchInt"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(13,a >= b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(17);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 267, className : "example.Example", methodName : "branchInt"});
	}
}
example.Example.prototype.branchBool = function(a,b) {
	m.cover.coverage.MCoverage.getLogger().logStatement(23);
	if(m.cover.coverage.MCoverage.getLogger().logBranch(16,m.cover.coverage.MCoverage.getLogger().logBranch(14,a) || m.cover.coverage.MCoverage.getLogger().logBranch(15,b))) {
		m.cover.coverage.MCoverage.getLogger().logStatement(19);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 220, className : "example.Example", methodName : "branchBool"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(17,a == b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(20);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 225, className : "example.Example", methodName : "branchBool"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(18,a != b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(21);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 230, className : "example.Example", methodName : "branchBool"});
	}
	if(m.cover.coverage.MCoverage.getLogger().logBranch(19,a && b)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(22);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 235, className : "example.Example", methodName : "branchBool"});
	}
}
example.Example.prototype.inlineFunction = function() {
	m.cover.coverage.MCoverage.getLogger().logStatement(25);
	var f = function() {
		m.cover.coverage.MCoverage.getLogger().logStatement(24);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 211, className : "example.Example", methodName : "inlineFunction"});
	};
	f();
}
example.Example.prototype.ternaryExpression = function(value) {
	if(value == null) value = true;
	m.cover.coverage.MCoverage.getLogger().logStatement(26);
	var n = m.cover.coverage.MCoverage.getLogger().logBranch(20,value)?4:5;
}
example.Example.prototype.forLoops = function() {
	m.cover.coverage.MCoverage.getLogger().logStatement(29);
	var _g = 0;
	while(_g < 5) {
		var i = _g++;
		m.cover.coverage.MCoverage.getLogger().logStatement(27);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 191, className : "example.Example", methodName : "forLoops"});
	}
	var a = [1,2,3,4,5];
	var _g = 0;
	while(_g < a.length) {
		var i = a[_g];
		++_g;
		m.cover.coverage.MCoverage.getLogger().logStatement(28);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 198, className : "example.Example", methodName : "forLoops"});
	}
}
example.Example.prototype.whileLoop = function() {
	m.cover.coverage.MCoverage.getLogger().logStatement(32);
	var i = 0;
	while(m.cover.coverage.MCoverage.getLogger().logBranch(21,i < 2)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(30);
		i++;
	}
	i = 0;
	while(m.cover.coverage.MCoverage.getLogger().logBranch(23,i < 2)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(31);
		if(m.cover.coverage.MCoverage.getLogger().logBranch(22,i == 1)) break;
		i++;
	}
}
example.Example.prototype.tryCatch = function(value) {
	if(value == null) value = false;
	m.cover.coverage.MCoverage.getLogger().logStatement(36);
	try {
		m.cover.coverage.MCoverage.getLogger().logStatement(34);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 159, className : "example.Example", methodName : "tryCatch"});
		if(m.cover.coverage.MCoverage.getLogger().logBranch(24,value == true)) {
			m.cover.coverage.MCoverage.getLogger().logStatement(33);
			throw "exception";
		}
	} catch( e ) {
		m.cover.coverage.MCoverage.getLogger().logStatement(35);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 167, className : "example.Example", methodName : "tryCatch"});
	}
}
example.Example.prototype.switchMethod = function(value) {
	m.cover.coverage.MCoverage.getLogger().logStatement(40);
	switch(value) {
	case 0:
		m.cover.coverage.MCoverage.getLogger().logStatement(37);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 149, className : "example.Example", methodName : "switchMethod"});
		break;
	case 1:
		m.cover.coverage.MCoverage.getLogger().logStatement(38);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 150, className : "example.Example", methodName : "switchMethod"});
		break;
	default:
		m.cover.coverage.MCoverage.getLogger().logStatement(39);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 151, className : "example.Example", methodName : "switchMethod"});
	}
}
example.Example.prototype.elseIfMethod = function(value) {
	if(value == null) value = 0;
	m.cover.coverage.MCoverage.getLogger().logStatement(44);
	if(m.cover.coverage.MCoverage.getLogger().logBranch(26,value == 0)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(41);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 133, className : "example.Example", methodName : "elseIfMethod"});
	} else if(m.cover.coverage.MCoverage.getLogger().logBranch(25,value == 1)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(42);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 137, className : "example.Example", methodName : "elseIfMethod"});
	} else {
		m.cover.coverage.MCoverage.getLogger().logStatement(43);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 141, className : "example.Example", methodName : "elseIfMethod"});
	}
}
example.Example.prototype.ifMethod = function(value) {
	if(value == null) value = false;
	m.cover.coverage.MCoverage.getLogger().logStatement(47);
	if(m.cover.coverage.MCoverage.getLogger().logBranch(27,value)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(45);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 121, className : "example.Example", methodName : "ifMethod"});
	} else {
		m.cover.coverage.MCoverage.getLogger().logStatement(46);
		example.Example.log(null,{ fileName : "Example.hx", lineNumber : 125, className : "example.Example", methodName : "ifMethod"});
	}
}
example.Example.prototype.notCoverable = function(value) {
	if(value == null) value = true;
	m.cover.coverage.MCoverage.getLogger().logStatement(48);
	var i = 0;
	var o = { a : "a", b : "b"};
	var a = [1,2,3];
}
example.Example.prototype.notCoveredEmpty = function() {
	m.cover.coverage.MCoverage.getLogger().logStatement(49);
}
example.Example.prototype.ignored = function() {
	example.Example.log(false,{ fileName : "Example.hx", lineNumber : 93, className : "example.Example", methodName : "ignored"});
}
example.Example.prototype.notCovered = function(value) {
	if(value == null) value = false;
	m.cover.coverage.MCoverage.getLogger().logStatement(51);
	example.Example.log(false,{ fileName : "Example.hx", lineNumber : 79, className : "example.Example", methodName : "notCovered"});
	if(m.cover.coverage.MCoverage.getLogger().logBranch(28,value)) {
		m.cover.coverage.MCoverage.getLogger().logStatement(50);
		example.Example.log(false,{ fileName : "Example.hx", lineNumber : 83, className : "example.Example", methodName : "notCovered"});
	}
}
example.Example.prototype.covered = function() {
	m.cover.coverage.MCoverage.getLogger().logStatement(52);
	example.Example.log(null,{ fileName : "Example.hx", lineNumber : 70, className : "example.Example", methodName : "covered"});
}
example.Example.prototype.fieldA = null;
example.Example.prototype.__class__ = example.Example;
example.InternalClass = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.MCoverage.getLogger().logStatement(54);
	example.Example.log(null,{ fileName : "Example.hx", lineNumber : 333, className : "example.InternalClass", methodName : "new"});
}
example.InternalClass.__name__ = ["example","InternalClass"];
example.InternalClass.prototype.__class__ = example.InternalClass;
example.InternalClassWithIgnore = function(p) {
	if( p === $_ ) return;
	example.Example.log(false,{ fileName : "Example.hx", lineNumber : 342, className : "example.InternalClassWithIgnore", methodName : "new"});
}
example.InternalClassWithIgnore.__name__ = ["example","InternalClassWithIgnore"];
example.InternalClassWithIgnore.prototype.__class__ = example.InternalClassWithIgnore;
if(!example._Example) example._Example = {}
example._Example.PrivateClass = function(p) {
	if( p === $_ ) return;
	example.Example.log(null,{ fileName : "Example.hx", lineNumber : 350, className : "example._Example.PrivateClass", methodName : "new"});
}
example._Example.PrivateClass.__name__ = ["example","_Example","PrivateClass"];
example._Example.PrivateClass.prototype.__class__ = example._Example.PrivateClass;
example._Example.PrivateClassWithIgnore = function(p) {
	if( p === $_ ) return;
	example.Example.log(false,{ fileName : "Example.hx", lineNumber : 359, className : "example._Example.PrivateClassWithIgnore", methodName : "new"});
}
example._Example.PrivateClassWithIgnore.__name__ = ["example","_Example","PrivateClassWithIgnore"];
example._Example.PrivateClassWithIgnore.prototype.__class__ = example._Example.PrivateClassWithIgnore;
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
m.cover.coverage.data.AbstractNodeList = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.data.AbstractNode.call(this);
	this.itemCount = 0;
	this.itemsById = new IntHash();
	this.items = new Hash();
}
m.cover.coverage.data.AbstractNodeList.__name__ = ["m","cover","coverage","data","AbstractNodeList"];
m.cover.coverage.data.AbstractNodeList.__super__ = m.cover.coverage.data.AbstractNode;
for(var k in m.cover.coverage.data.AbstractNode.prototype ) m.cover.coverage.data.AbstractNodeList.prototype[k] = m.cover.coverage.data.AbstractNode.prototype[k];
m.cover.coverage.data.AbstractNodeList.prototype.itemsById = null;
m.cover.coverage.data.AbstractNodeList.prototype.items = null;
m.cover.coverage.data.AbstractNodeList.prototype.itemCount = null;
m.cover.coverage.data.AbstractNodeList.prototype.getItemByName = function(name,cls) {
	if(!this.items.exists(name)) {
		var item = Type.createInstance(cls,[]);
		item.id = this.itemCount++;
		item.name = name;
		this.items.set(name,item.id);
		this.itemsById.set(item.id,item);
	}
	return this.itemsById.get(this.items.get(name));
}
m.cover.coverage.data.AbstractNodeList.prototype.lookupBranch = function(path) {
	var itemId = path.shift();
	if(itemId == null || !this.itemsById.exists(itemId)) return null;
	return this.itemsById.get(itemId).lookupBranch(path);
}
m.cover.coverage.data.AbstractNodeList.prototype.lookupStatement = function(path) {
	var itemId = path.shift();
	if(itemId == null || !this.itemsById.exists(itemId)) return null;
	return this.itemsById.get(itemId).lookupStatement(path);
}
m.cover.coverage.data.AbstractNodeList.prototype.getMissingBranches = function() {
	var a = [];
	var $it0 = this.itemsById.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		var tmp = node.getMissingBranches();
		a = a.concat(tmp);
	}
	a.sort(m.cover.coverage.data.DataUtil.sortOnBlockName);
	return a;
}
m.cover.coverage.data.AbstractNodeList.prototype.getMissingStatements = function() {
	var a = [];
	var $it0 = this.itemsById.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		var tmp = node.getMissingStatements();
		a = a.concat(tmp);
	}
	a.sort(m.cover.coverage.data.DataUtil.sortOnBlockName);
	return a;
}
m.cover.coverage.data.AbstractNodeList.prototype.getClasses = function() {
	var a = [];
	var $it0 = this.itemsById.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		var tmp = node.getClasses();
		a = a.concat(tmp);
	}
	return a;
}
m.cover.coverage.data.AbstractNodeList.prototype.getResults = function(cache) {
	if(cache == null) cache = true;
	if(this.resultCache == null || !cache) {
		this.resultCache = this.emptyResult();
		var $it0 = this.itemsById.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			var tmp = node.getResults(cache);
			this.resultCache = this.appendResults(this.resultCache,tmp);
		}
	}
	return this.resultCache;
}
m.cover.coverage.data.AbstractNodeList.prototype.appendResults = function(to,from) {
	to.sc += from.sc;
	to.s += from.s;
	to.bt += from.bt;
	to.bf += from.bf;
	to.bc += from.bc;
	to.b += from.b;
	to.mc += from.mc;
	to.m += from.m;
	to.cc += from.cc;
	to.c += from.c;
	to.fc += from.fc;
	to.f += from.f;
	to.pc += from.pc;
	to.p += from.p;
	to.lc += from.lc;
	to.lp += from.lp;
	to.l += from.l;
	return to;
}
m.cover.coverage.data.AbstractNodeList.prototype.hxSerialize = function(s) {
	m.cover.coverage.data.AbstractNode.prototype.hxSerialize.call(this,s);
	s.serialize(this.itemsById);
	s.serialize(this.items);
	s.serialize(this.itemCount);
}
m.cover.coverage.data.AbstractNodeList.prototype.hxUnserialize = function(s) {
	m.cover.coverage.data.AbstractNode.prototype.hxUnserialize.call(this,s);
	this.itemsById = s.unserialize();
	this.items = s.unserialize();
	this.itemCount = s.unserialize();
}
m.cover.coverage.data.AbstractNodeList.prototype.__class__ = m.cover.coverage.data.AbstractNodeList;
m.cover.coverage.data.Clazz = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.data.AbstractNodeList.call(this);
}
m.cover.coverage.data.Clazz.__name__ = ["m","cover","coverage","data","Clazz"];
m.cover.coverage.data.Clazz.__super__ = m.cover.coverage.data.AbstractNodeList;
for(var k in m.cover.coverage.data.AbstractNodeList.prototype ) m.cover.coverage.data.Clazz.prototype[k] = m.cover.coverage.data.AbstractNodeList.prototype[k];
m.cover.coverage.data.Clazz.prototype.getMethods = function() {
	var a = [];
	var $it0 = this.itemsById.iterator();
	while( $it0.hasNext() ) {
		var item = $it0.next();
		if(Type.getClass(item) == m.cover.coverage.data.Method) a.push((function($this) {
			var $r;
			var $t = item;
			if(Std["is"]($t,m.cover.coverage.data.Method)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this)));
	}
	return a;
}
m.cover.coverage.data.Clazz.prototype.appendResults = function(to,from) {
	to = m.cover.coverage.data.AbstractNodeList.prototype.appendResults.call(this,to,from);
	to.mc += from.sc > 0?1:0;
	to.m += 1;
	return to;
}
m.cover.coverage.data.Clazz.prototype.__class__ = m.cover.coverage.data.Clazz;
example.NotCovered = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.MCoverage.getLogger().logStatement(0);
}
example.NotCovered.__name__ = ["example","NotCovered"];
example.NotCovered.prototype.__class__ = example.NotCovered;
m.cover.coverage.MCoverage = function(p) {
}
m.cover.coverage.MCoverage.__name__ = ["m","cover","coverage","MCoverage"];
m.cover.coverage.MCoverage.logger = null;
m.cover.coverage.MCoverage.getLogger = function() {
	if(m.cover.coverage.MCoverage.logger == null) m.cover.coverage.MCoverage.logger = new m.cover.coverage.CoverageLoggerImpl();
	return m.cover.coverage.MCoverage.logger;
}
m.cover.coverage.MCoverage.prototype.__class__ = m.cover.coverage.MCoverage;
m.cover.coverage.data.Package = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.data.AbstractNodeList.call(this);
}
m.cover.coverage.data.Package.__name__ = ["m","cover","coverage","data","Package"];
m.cover.coverage.data.Package.__super__ = m.cover.coverage.data.AbstractNodeList;
for(var k in m.cover.coverage.data.AbstractNodeList.prototype ) m.cover.coverage.data.Package.prototype[k] = m.cover.coverage.data.AbstractNodeList.prototype[k];
m.cover.coverage.data.Package.prototype.getFiles = function() {
	var a = [];
	var $it0 = this.itemsById.iterator();
	while( $it0.hasNext() ) {
		var item = $it0.next();
		if(Type.getClass(item) == m.cover.coverage.data.File) a.push((function($this) {
			var $r;
			var $t = item;
			if(Std["is"]($t,m.cover.coverage.data.File)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this)));
	}
	return a;
}
m.cover.coverage.data.Package.prototype.appendResults = function(to,from) {
	to = m.cover.coverage.data.AbstractNodeList.prototype.appendResults.call(this,to,from);
	to.fc += from.sc > 0?1:0;
	to.f += 1;
	return to;
}
m.cover.coverage.data.Package.prototype.__class__ = m.cover.coverage.data.Package;
m.cover.Exception = function(message,cause,info) {
	if( message === $_ ) return;
	this.type = this.here({ fileName : "Exception.hx", lineNumber : 66, className : "m.cover.Exception", methodName : "new"}).className;
	this.message = message;
	this.cause = cause;
	this.info = info;
	if(cause != null) {
		this.causeExceptionStack = haxe.Stack.exceptionStack();
		this.causeCallStack = haxe.Stack.callStack();
	}
}
m.cover.Exception.__name__ = ["m","cover","Exception"];
m.cover.Exception.prototype.type = null;
m.cover.Exception.prototype.message = null;
m.cover.Exception.prototype.info = null;
m.cover.Exception.prototype.cause = null;
m.cover.Exception.prototype.causeExceptionStack = null;
m.cover.Exception.prototype.causeCallStack = null;
m.cover.Exception.prototype.toString = function() {
	var str = this.type + ": " + this.message;
	if(this.info != null) str += " at " + this.info.className + "#" + this.info.methodName + " (" + this.info.lineNumber + ")";
	if(this.cause != null) str += "\n\t Caused by: " + this.cause;
	return str;
}
m.cover.Exception.prototype.here = function(info) {
	return info;
}
m.cover.Exception.prototype.__class__ = m.cover.Exception;
m.cover.coverage.CoverageException = function(message,cause,info) {
	if( message === $_ ) return;
	m.cover.Exception.call(this,message,cause,info);
	this.type = this.here({ fileName : "CoverageException.hx", lineNumber : 39, className : "m.cover.coverage.CoverageException", methodName : "new"}).className;
}
m.cover.coverage.CoverageException.__name__ = ["m","cover","coverage","CoverageException"];
m.cover.coverage.CoverageException.__super__ = m.cover.Exception;
for(var k in m.cover.Exception.prototype ) m.cover.coverage.CoverageException.prototype[k] = m.cover.Exception.prototype[k];
m.cover.coverage.CoverageException.prototype.__class__ = m.cover.coverage.CoverageException;
m.cover.coverage.data.DataUtil = function(p) {
}
m.cover.coverage.data.DataUtil.__name__ = ["m","cover","coverage","data","DataUtil"];
m.cover.coverage.data.DataUtil.sortOnNodeId = function(a,b) {
	return a.id - b.id;
}
m.cover.coverage.data.DataUtil.sortOnNodeName = function(a,b) {
	var nodeA = a.name.toLowerCase();
	var nodeB = b.name.toLowerCase();
	if(nodeA < nodeB) return -1;
	if(nodeA > nodeB) return 1;
	return 0;
}
m.cover.coverage.data.DataUtil.sortOnBlockName = function(a,b) {
	var blockA = a.toString().toLowerCase();
	var blockB = b.toString().toLowerCase();
	if(blockA < blockB) return -1;
	if(blockA > blockB) return 1;
	return 0;
}
m.cover.coverage.data.DataUtil.prototype.__class__ = m.cover.coverage.data.DataUtil;
if(!haxe.io) haxe.io = {}
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
m.cover.coverage.CoverageReportClient = function() { }
m.cover.coverage.CoverageReportClient.__name__ = ["m","cover","coverage","CoverageReportClient"];
m.cover.coverage.CoverageReportClient.prototype.completionHandler = null;
m.cover.coverage.CoverageReportClient.prototype.report = null;
m.cover.coverage.CoverageReportClient.prototype.output = null;
m.cover.coverage.CoverageReportClient.prototype.__class__ = m.cover.coverage.CoverageReportClient;
m.cover.coverage.AdvancedCoverageReportClient = function() { }
m.cover.coverage.AdvancedCoverageReportClient.__name__ = ["m","cover","coverage","AdvancedCoverageReportClient"];
m.cover.coverage.AdvancedCoverageReportClient.prototype.includeMissingBlocks = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.includeExecutionFrequency = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.includeClassBreakdown = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.includePackageBreakdown = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.includeOverallPercentage = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.includeSummary = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.header = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.executionFrequency = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.missingBlocks = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.classBreakdown = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.packageBreakdown = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.summary = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.overallPercentage = null;
m.cover.coverage.AdvancedCoverageReportClient.prototype.__class__ = m.cover.coverage.AdvancedCoverageReportClient;
m.cover.coverage.AdvancedCoverageReportClient.__interfaces__ = [m.cover.coverage.CoverageReportClient];
if(!m.cover.coverage.client) m.cover.coverage.client = {}
m.cover.coverage.client.PrintClient = function(p) {
	if( p === $_ ) return;
	this.includeHeader = true;
	this.includeMissingBlocks = true;
	this.includeExecutionFrequency = true;
	this.includeClassBreakdown = true;
	this.includePackageBreakdown = true;
	this.includeSummary = true;
	this.includeOverallPercentage = true;
	this.maxBlockExecutionListSize = 25;
	this.newline = "\n";
	this.tab = " ";
	this.divider = this.newline + "----------------------------------------------------------------";
}
m.cover.coverage.client.PrintClient.__name__ = ["m","cover","coverage","client","PrintClient"];
m.cover.coverage.client.PrintClient.prototype.completionHandler = null;
m.cover.coverage.client.PrintClient.prototype.includeHeader = null;
m.cover.coverage.client.PrintClient.prototype.includeMissingBlocks = null;
m.cover.coverage.client.PrintClient.prototype.includeExecutionFrequency = null;
m.cover.coverage.client.PrintClient.prototype.includeClassBreakdown = null;
m.cover.coverage.client.PrintClient.prototype.includePackageBreakdown = null;
m.cover.coverage.client.PrintClient.prototype.includeOverallPercentage = null;
m.cover.coverage.client.PrintClient.prototype.includeSummary = null;
m.cover.coverage.client.PrintClient.prototype.maxBlockExecutionListSize = null;
m.cover.coverage.client.PrintClient.prototype.newline = null;
m.cover.coverage.client.PrintClient.prototype.output = null;
m.cover.coverage.client.PrintClient.prototype.header = null;
m.cover.coverage.client.PrintClient.prototype.executionFrequency = null;
m.cover.coverage.client.PrintClient.prototype.missingBlocks = null;
m.cover.coverage.client.PrintClient.prototype.classBreakdown = null;
m.cover.coverage.client.PrintClient.prototype.packageBreakdown = null;
m.cover.coverage.client.PrintClient.prototype.summary = null;
m.cover.coverage.client.PrintClient.prototype.overallPercentage = null;
m.cover.coverage.client.PrintClient.prototype.divider = null;
m.cover.coverage.client.PrintClient.prototype.tab = null;
m.cover.coverage.client.PrintClient.prototype.packageTotal = null;
m.cover.coverage.client.PrintClient.prototype.packageCompletedCount = null;
m.cover.coverage.client.PrintClient.prototype.packagePartialCount = null;
m.cover.coverage.client.PrintClient.prototype.classTotal = null;
m.cover.coverage.client.PrintClient.prototype.classCompletedCount = null;
m.cover.coverage.client.PrintClient.prototype.classPartialCount = null;
m.cover.coverage.client.PrintClient.prototype.coverage = null;
m.cover.coverage.client.PrintClient.prototype.report = function(coverage) {
	this.output = "";
	this.header = "";
	this.executionFrequency = "";
	this.missingBlocks = "";
	this.classBreakdown = "";
	this.packageBreakdown = "";
	this.summary = "";
	this.overallPercentage = "";
	this.coverage = coverage;
	this.printReport();
	var timer = m.cover.util.Timer.delay($closure(this,"reportComplete"),10);
}
m.cover.coverage.client.PrintClient.prototype.reportComplete = function() {
	if(this.completionHandler != null) this.completionHandler(this);
}
m.cover.coverage.client.PrintClient.prototype.printReport = function() {
	this.header = this.serializeHeader();
	this.executionFrequency = this.serializeExecutionFrequency();
	this.missingBlocks = this.serializeMissingBlocks();
	this.classBreakdown = this.serializeClassResults();
	this.packageBreakdown = this.serializePackageResults();
	this.summary = this.serializeSummary();
	this.overallPercentage = this.serializeOverallPercentage();
	this.output = this.serializeFinalOutput();
}
m.cover.coverage.client.PrintClient.prototype.serializeFinalOutput = function() {
	var output = "";
	if(this.includeHeader) {
		output += this.divider;
		output += this.newline;
		output += this.header;
		output += this.divider;
	}
	if(this.includeExecutionFrequency) {
		output += this.newline;
		output += this.executionFrequency;
	}
	if(this.includeMissingBlocks) {
		output += this.newline;
		output += this.missingBlocks;
	}
	if(this.includeClassBreakdown) {
		output += this.newline;
		output += this.classBreakdown;
	}
	if(this.includePackageBreakdown) {
		output += this.newline;
		output += this.packageBreakdown;
	}
	if(this.includeSummary) {
		output += this.newline;
		output += this.divider;
		output += this.newline;
		output += this.summary;
	}
	if(this.includeOverallPercentage) {
		output += this.newline;
		output += this.divider;
		output += this.overallPercentage;
		output += this.divider;
	}
	output += this.newline;
	return output;
}
m.cover.coverage.client.PrintClient.prototype.serializeHeader = function() {
	return "MCover Coverage Report, generated " + Date.now().toString();
}
m.cover.coverage.client.PrintClient.prototype.serializeOverallPercentage = function() {
	return this.printTabs(["COVERAGE RESULT",this.coverage.getPercentage() + "%"],20);
}
m.cover.coverage.client.PrintClient.prototype.serializeSummary = function() {
	var output = "";
	var r = this.coverage.getResults();
	var s = 4;
	var w = 20;
	output = this.printLine("OVERALL COVERAGE STATS:");
	output += this.printLine("");
	output += this.printTabs(["","total packages",r.pc + " / " + r.p],s,w);
	output += this.printTabs(["","total files",r.fc + " / " + r.f],s,w);
	output += this.printTabs(["","total classes",r.cc + " / " + r.c],s,w);
	output += this.printTabs(["","total methods",r.mc + " / " + r.m],s,w);
	output += this.printTabs(["","total statements",r.sc + " / " + r.s],s,w);
	output += this.printTabs(["","total branches",r.bc + " / " + r.b],s,w);
	output += this.printTabs(["","total lines",r.lc + " / " + r.l],s,w);
	return output;
}
m.cover.coverage.client.PrintClient.prototype.serializePackageResults = function() {
	var output = "";
	output = this.printLine("COVERAGE BREAKDOWN BY PACKAGE:");
	output += this.newline;
	var packages = this.coverage.getPackages();
	if(Lambda.count(packages) == 0) {
		output += this.printTabs(["","None"]);
		return output;
	}
	output += this.printTabs(["","Result","Files","Classes","Package"]);
	var _g = 0;
	while(_g < packages.length) {
		var pckg = packages[_g];
		++_g;
		var r = pckg.getResults();
		var packgName = pckg.name == ""?"[Default]":pckg.name;
		output += this.printTabs(["",pckg.getPercentage() + "%",r.fc + "/" + r.f,r.cc + "/" + r.c,packgName]);
	}
	return output;
}
m.cover.coverage.client.PrintClient.prototype.serializeClassResults = function() {
	var output = "";
	output = this.printLine("COVERAGE BREAKDOWN BY CLASSES:");
	output += this.newline;
	var classes = this.coverage.getClasses();
	if(Lambda.count(classes) == 0) {
		output += this.printTabs(["","None"]);
		return output;
	}
	output += this.printTabs(["","Result","Methods","Statements","Branches","Lines","Class"]);
	var _g = 0;
	while(_g < classes.length) {
		var cls = classes[_g];
		++_g;
		var r = cls.getResults();
		output += this.printTabs(["",cls.getPercentage() + "%",r.mc + "/" + r.m,r.sc + "/" + r.s,r.bc + "/" + r.b,r.lc + "/" + r.l,cls.name]);
	}
	return output;
}
m.cover.coverage.client.PrintClient.prototype.serializeMissingBlocks = function() {
	var output = "";
	output = this.printLine("MISSING STATEMENT COVERAGE:");
	output += this.newline;
	var statements = this.coverage.getMissingStatements();
	if(Lambda.count(statements) == 0) output += this.printTabs(["","None"]); else {
		var currentClass = null;
		var _g = 0;
		while(_g < statements.length) {
			var block = statements[_g];
			++_g;
			if(currentClass != block.qualifiedClassName) {
				currentClass = block.qualifiedClassName;
				output += this.printTabs(["","Class: " + block.qualifiedClassName]);
			}
			output += this.printTabs(["",block.toLocalString()],8);
		}
	}
	output += this.newline;
	output += this.printLine("MISSING BRANCH COVERAGE:");
	output += this.newline;
	var branches = this.coverage.getMissingBranches();
	if(Lambda.count(branches) == 0) output += this.printTabs(["","None"]); else {
		var currentClass = null;
		var _g = 0;
		while(_g < branches.length) {
			var block = branches[_g];
			++_g;
			if(currentClass != block.qualifiedClassName) {
				currentClass = block.qualifiedClassName;
				output += this.printTabs(["","Class: " + block.qualifiedClassName]);
			}
			output += this.printTabs(["",block.toLocalString()],8);
		}
	}
	return output;
}
m.cover.coverage.client.PrintClient.prototype.serializeExecutionFrequency = function() {
	var output = "";
	var statements = [];
	var $it0 = this.coverage.statementResultsById.keys();
	while( $it0.hasNext() ) {
		var key = $it0.next();
		var statement = this.coverage.getStatementById(key);
		if(statement.count > 0) statements.push(statement);
	}
	output = this.printLine("TOP " + this.maxBlockExecutionListSize + " STATEMENTS BY EXECUTION FREQUENCY:");
	output += this.newline;
	if(Lambda.count(statements) == 0) output += this.printTabs(["","None"]); else {
		var statementSort = function(a,b) {
			return -a.count + b.count;
		};
		statements.sort(statementSort);
		output += this.printTabs(["","Count","Statement"]);
		var count = 0;
		var _g = 0;
		while(_g < statements.length) {
			var statement = statements[_g];
			++_g;
			output += this.printTabs(["",statement.count,statement.toString()]);
			count++;
			if(count >= this.maxBlockExecutionListSize) break;
		}
	}
	var branches = [];
	var $it1 = this.coverage.branchResultsById.keys();
	while( $it1.hasNext() ) {
		var key = $it1.next();
		var branch = this.coverage.getBranchById(key);
		if(branch.get_totalCount() > 0) branches.push(branch);
	}
	output += this.newline;
	output += this.printLine("TOP " + this.maxBlockExecutionListSize + " BRANCHES BY EXECUTION FREQUENCY:");
	output += this.newline;
	if(Lambda.count(branches) == 0) output += this.printTabs(["","None"]); else {
		var branchSort = function(a,b) {
			return -a.get_totalCount() + b.get_totalCount();
		};
		branches.sort(branchSort);
		output += this.printTabs(["","Count","True","False","Branch"]);
		var count = 0;
		var _g = 0;
		while(_g < branches.length) {
			var branch = branches[_g];
			++_g;
			output += this.printTabs(["",branch.get_totalCount(),branch.trueCount,branch.falseCount,branch.toString()]);
			count++;
			if(count >= this.maxBlockExecutionListSize) break;
		}
	}
	return output;
}
m.cover.coverage.client.PrintClient.prototype.printLine = function(value) {
	return this.newline + Std.string(value);
}
m.cover.coverage.client.PrintClient.prototype.printTabs = function(args,initialColumnWidth,columnWidth) {
	if(columnWidth == null) columnWidth = 11;
	if(initialColumnWidth == null) initialColumnWidth = 4;
	var s = "";
	var isFirst = true;
	var _g = 0;
	while(_g < args.length) {
		var arg = args[_g];
		++_g;
		arg = Std.string(arg);
		if(isFirst) {
			isFirst = false;
			s += StringTools.rpad(arg,this.tab,initialColumnWidth);
		} else s += StringTools.rpad(arg,this.tab,columnWidth);
	}
	return this.newline + s;
}
m.cover.coverage.client.PrintClient.prototype.__class__ = m.cover.coverage.client.PrintClient;
m.cover.coverage.client.PrintClient.__interfaces__ = [m.cover.coverage.AdvancedCoverageReportClient];
m.cover.coverage.client.TraceClient = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.client.PrintClient.call(this);
	this.newline = "<br/>";
	this.tab = "&nbsp;";
}
m.cover.coverage.client.TraceClient.__name__ = ["m","cover","coverage","client","TraceClient"];
m.cover.coverage.client.TraceClient.__super__ = m.cover.coverage.client.PrintClient;
for(var k in m.cover.coverage.client.PrintClient.prototype ) m.cover.coverage.client.TraceClient.prototype[k] = m.cover.coverage.client.PrintClient.prototype[k];
m.cover.coverage.client.TraceClient.prototype.printReport = function() {
	m.cover.coverage.client.PrintClient.prototype.printReport.call(this);
	this.output += this.newline;
	haxe.Log.trace(this.newline + this.output,{ fileName : "TraceClient.hx", lineNumber : 45, className : "m.cover.coverage.client.TraceClient", methodName : "printReport"});
}
m.cover.coverage.client.TraceClient.prototype.__class__ = m.cover.coverage.client.TraceClient;
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
m.cover.coverage.data.Method = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.data.AbstractNode.call(this);
	this.statementsById = new IntHash();
	this.branchesById = new IntHash();
}
m.cover.coverage.data.Method.__name__ = ["m","cover","coverage","data","Method"];
m.cover.coverage.data.Method.__super__ = m.cover.coverage.data.AbstractNode;
for(var k in m.cover.coverage.data.AbstractNode.prototype ) m.cover.coverage.data.Method.prototype[k] = m.cover.coverage.data.AbstractNode.prototype[k];
m.cover.coverage.data.Method.prototype.statementsById = null;
m.cover.coverage.data.Method.prototype.branchesById = null;
m.cover.coverage.data.Method.prototype.addStatement = function(value) {
	this.statementsById.set(value.id,value);
}
m.cover.coverage.data.Method.prototype.addBranch = function(value) {
	this.branchesById.set(value.id,value);
}
m.cover.coverage.data.Method.prototype.getStatementById = function(id) {
	if(this.statementsById.exists(id)) return this.statementsById.get(id);
	return null;
}
m.cover.coverage.data.Method.prototype.getBranchById = function(id) {
	if(this.branchesById.exists(id)) return this.branchesById.get(id);
	return null;
}
m.cover.coverage.data.Method.prototype.lookupBranch = function(path) {
	var itemId = path.shift();
	if(itemId == null || !this.branchesById.exists(itemId)) return null;
	return this.branchesById.get(itemId);
}
m.cover.coverage.data.Method.prototype.lookupStatement = function(path) {
	var itemId = path.shift();
	if(itemId == null || !this.statementsById.exists(itemId)) return null;
	return this.statementsById.get(itemId);
}
m.cover.coverage.data.Method.prototype.getMissingBranches = function() {
	var a = [];
	var $it0 = this.branchesById.iterator();
	while( $it0.hasNext() ) {
		var branch = $it0.next();
		if(!branch.isCovered()) a.push(branch);
	}
	return a;
}
m.cover.coverage.data.Method.prototype.getMissingStatements = function() {
	var a = [];
	var $it0 = this.statementsById.iterator();
	while( $it0.hasNext() ) {
		var statement = $it0.next();
		if(!statement.isCovered()) a.push(statement);
	}
	return a;
}
m.cover.coverage.data.Method.prototype.getResults = function(cache) {
	if(cache == null) cache = true;
	if(this.resultCache == null || !cache) {
		this.resultCache = this.emptyResult();
		var covered;
		var $it0 = this.statementsById.iterator();
		while( $it0.hasNext() ) {
			var statement = $it0.next();
			covered = statement.count > 0;
			this.resultCache.sc += covered?1:0;
			this.resultCache.s += 1;
			var _g = 0, _g1 = statement.lines;
			while(_g < _g1.length) {
				var line = _g1[_g];
				++_g;
				this.resultCache.lc += covered?1:0;
				this.resultCache.l += 1;
			}
		}
		var $it1 = this.branchesById.iterator();
		while( $it1.hasNext() ) {
			var branch = $it1.next();
			covered = branch.isCovered();
			this.resultCache.bt += branch.trueCount > 0?1:0;
			this.resultCache.bf += branch.falseCount > 0?1:0;
			this.resultCache.bc += covered?1:0;
			this.resultCache.b += 1;
			var partiallyCovered = branch.isPartiallyCovered();
			var _g = 0, _g1 = branch.lines;
			while(_g < _g1.length) {
				var line = _g1[_g];
				++_g;
				if(covered) this.resultCache.lc += 1; else if(partiallyCovered) this.resultCache.lp += 1;
				this.resultCache.l += 1;
			}
		}
	}
	return this.resultCache;
}
m.cover.coverage.data.Method.prototype.hxSerialize = function(s) {
	m.cover.coverage.data.AbstractNode.prototype.hxSerialize.call(this,s);
	s.serialize(this.statementsById);
	s.serialize(this.branchesById);
}
m.cover.coverage.data.Method.prototype.hxUnserialize = function(s) {
	m.cover.coverage.data.AbstractNode.prototype.hxUnserialize.call(this,s);
	this.statementsById = s.unserialize();
	this.branchesById = s.unserialize();
}
m.cover.coverage.data.Method.prototype.__class__ = m.cover.coverage.data.Method;
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
m.cover.coverage.data.AbstractBlock = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.data.AbstractNode.call(this);
	this.lines = [];
}
m.cover.coverage.data.AbstractBlock.__name__ = ["m","cover","coverage","data","AbstractBlock"];
m.cover.coverage.data.AbstractBlock.__super__ = m.cover.coverage.data.AbstractNode;
for(var k in m.cover.coverage.data.AbstractNode.prototype ) m.cover.coverage.data.AbstractBlock.prototype[k] = m.cover.coverage.data.AbstractNode.prototype[k];
m.cover.coverage.data.AbstractBlock.prototype.file = null;
m.cover.coverage.data.AbstractBlock.prototype.packageName = null;
m.cover.coverage.data.AbstractBlock.prototype.className = null;
m.cover.coverage.data.AbstractBlock.prototype.qualifiedClassName = null;
m.cover.coverage.data.AbstractBlock.prototype.methodName = null;
m.cover.coverage.data.AbstractBlock.prototype.min = null;
m.cover.coverage.data.AbstractBlock.prototype.max = null;
m.cover.coverage.data.AbstractBlock.prototype.location = null;
m.cover.coverage.data.AbstractBlock.prototype.lines = null;
m.cover.coverage.data.AbstractBlock.prototype.lookup = null;
m.cover.coverage.data.AbstractBlock.prototype.isCovered = function() {
	return false;
}
m.cover.coverage.data.AbstractBlock.prototype.toString = function() {
	return this.qualifiedClassName + "#" + this.toLocalString();
}
m.cover.coverage.data.AbstractBlock.prototype.toLocalString = function() {
	return this.methodName + " | " + this.location;
}
m.cover.coverage.data.AbstractBlock.prototype.hxSerialize = function(s) {
	m.cover.coverage.data.AbstractNode.prototype.hxSerialize.call(this,s);
	s.serialize(this.file);
	s.serialize(this.packageName);
	s.serialize(this.className);
	s.serialize(this.qualifiedClassName);
	s.serialize(this.methodName);
	s.serialize(this.min);
	s.serialize(this.max);
	s.serialize(this.location);
	s.serialize(this.lookup);
	s.serialize(this.lines);
}
m.cover.coverage.data.AbstractBlock.prototype.hxUnserialize = function(s) {
	m.cover.coverage.data.AbstractNode.prototype.hxUnserialize.call(this,s);
	this.file = s.unserialize();
	this.packageName = s.unserialize();
	this.className = s.unserialize();
	this.qualifiedClassName = s.unserialize();
	this.methodName = s.unserialize();
	this.min = s.unserialize();
	this.max = s.unserialize();
	this.location = s.unserialize();
	this.lookup = s.unserialize();
	this.lines = s.unserialize();
}
m.cover.coverage.data.AbstractBlock.prototype.__class__ = m.cover.coverage.data.AbstractBlock;
m.cover.coverage.data.Branch = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.data.AbstractBlock.call(this);
	this.trueCount = 0;
	this.falseCount = 0;
}
m.cover.coverage.data.Branch.__name__ = ["m","cover","coverage","data","Branch"];
m.cover.coverage.data.Branch.__super__ = m.cover.coverage.data.AbstractBlock;
for(var k in m.cover.coverage.data.AbstractBlock.prototype ) m.cover.coverage.data.Branch.prototype[k] = m.cover.coverage.data.AbstractBlock.prototype[k];
m.cover.coverage.data.Branch.prototype.trueCount = null;
m.cover.coverage.data.Branch.prototype.falseCount = null;
m.cover.coverage.data.Branch.prototype.totalCount = null;
m.cover.coverage.data.Branch.prototype.get_totalCount = function() {
	return this.trueCount + this.falseCount;
}
m.cover.coverage.data.Branch.prototype.isCovered = function() {
	return this.trueCount > 0 && this.falseCount > 0;
}
m.cover.coverage.data.Branch.prototype.isPartiallyCovered = function() {
	return !this.isCovered() && (this.trueCount > 0 || this.falseCount > 0);
}
m.cover.coverage.data.Branch.prototype.toLocalString = function() {
	var s = m.cover.coverage.data.AbstractBlock.prototype.toLocalString.call(this);
	if(!this.isCovered()) {
		s += " | ";
		if(this.trueCount == 0) s += "t";
		if(this.trueCount == 0 && this.falseCount == 0) s += ",";
		if(this.falseCount == 0) s += "f";
	}
	return s;
}
m.cover.coverage.data.Branch.prototype.hxSerialize = function(s) {
	m.cover.coverage.data.AbstractBlock.prototype.hxSerialize.call(this,s);
	s.serialize(this.trueCount);
	s.serialize(this.falseCount);
}
m.cover.coverage.data.Branch.prototype.hxUnserialize = function(s) {
	m.cover.coverage.data.AbstractBlock.prototype.hxUnserialize.call(this,s);
	this.trueCount = s.unserialize();
	this.falseCount = s.unserialize();
}
m.cover.coverage.data.Branch.prototype.__class__ = m.cover.coverage.data.Branch;
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
haxe.Serializer = function(p) {
	if( p === $_ ) return;
	this.buf = new StringBuf();
	this.cache = new Array();
	this.useCache = haxe.Serializer.USE_CACHE;
	this.useEnumIndex = haxe.Serializer.USE_ENUM_INDEX;
	this.shash = new Hash();
	this.scount = 0;
}
haxe.Serializer.__name__ = ["haxe","Serializer"];
haxe.Serializer.run = function(v) {
	var s = new haxe.Serializer();
	s.serialize(v);
	return s.toString();
}
haxe.Serializer.prototype.buf = null;
haxe.Serializer.prototype.cache = null;
haxe.Serializer.prototype.shash = null;
haxe.Serializer.prototype.scount = null;
haxe.Serializer.prototype.useCache = null;
haxe.Serializer.prototype.useEnumIndex = null;
haxe.Serializer.prototype.toString = function() {
	return this.buf.b.join("");
}
haxe.Serializer.prototype.serializeString = function(s) {
	var x = this.shash.get(s);
	if(x != null) {
		this.buf.add("R");
		this.buf.add(x);
		return;
	}
	this.shash.set(s,this.scount++);
	this.buf.add("y");
	s = StringTools.urlEncode(s);
	this.buf.add(s.length);
	this.buf.add(":");
	this.buf.add(s);
}
haxe.Serializer.prototype.serializeRef = function(v) {
	var vt = typeof(v);
	var _g1 = 0, _g = this.cache.length;
	while(_g1 < _g) {
		var i = _g1++;
		var ci = this.cache[i];
		if(typeof(ci) == vt && ci == v) {
			this.buf.add("r");
			this.buf.add(i);
			return true;
		}
	}
	this.cache.push(v);
	return false;
}
haxe.Serializer.prototype.serializeFields = function(v) {
	var _g = 0, _g1 = Reflect.fields(v);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		this.serializeString(f);
		this.serialize(Reflect.field(v,f));
	}
	this.buf.add("g");
}
haxe.Serializer.prototype.serialize = function(v) {
	var $e = (Type["typeof"](v));
	switch( $e[1] ) {
	case 0:
		this.buf.add("n");
		break;
	case 1:
		if(v == 0) {
			this.buf.add("z");
			return;
		}
		this.buf.add("i");
		this.buf.add(v);
		break;
	case 2:
		if(Math.isNaN(v)) this.buf.add("k"); else if(!Math.isFinite(v)) this.buf.add(v < 0?"m":"p"); else {
			this.buf.add("d");
			this.buf.add(v);
		}
		break;
	case 3:
		this.buf.add(v?"t":"f");
		break;
	case 6:
		var c = $e[2];
		if(c == String) {
			this.serializeString(v);
			return;
		}
		if(this.useCache && this.serializeRef(v)) return;
		switch(c) {
		case Array:
			var ucount = 0;
			this.buf.add("a");
			var l = v["length"];
			var _g = 0;
			while(_g < l) {
				var i = _g++;
				if(v[i] == null) ucount++; else {
					if(ucount > 0) {
						if(ucount == 1) this.buf.add("n"); else {
							this.buf.add("u");
							this.buf.add(ucount);
						}
						ucount = 0;
					}
					this.serialize(v[i]);
				}
			}
			if(ucount > 0) {
				if(ucount == 1) this.buf.add("n"); else {
					this.buf.add("u");
					this.buf.add(ucount);
				}
			}
			this.buf.add("h");
			break;
		case List:
			this.buf.add("l");
			var v1 = v;
			var $it0 = v1.iterator();
			while( $it0.hasNext() ) {
				var i = $it0.next();
				this.serialize(i);
			}
			this.buf.add("h");
			break;
		case Date:
			var d = v;
			this.buf.add("v");
			this.buf.add(d.toString());
			break;
		case Hash:
			this.buf.add("b");
			var v1 = v;
			var $it1 = v1.keys();
			while( $it1.hasNext() ) {
				var k = $it1.next();
				this.serializeString(k);
				this.serialize(v1.get(k));
			}
			this.buf.add("h");
			break;
		case IntHash:
			this.buf.add("q");
			var v1 = v;
			var $it2 = v1.keys();
			while( $it2.hasNext() ) {
				var k = $it2.next();
				this.buf.add(":");
				this.buf.add(k);
				this.serialize(v1.get(k));
			}
			this.buf.add("h");
			break;
		case haxe.io.Bytes:
			var v1 = v;
			var i = 0;
			var max = v1.length - 2;
			var chars = "";
			var b64 = haxe.Serializer.BASE64;
			while(i < max) {
				var b1 = v1.b[i++];
				var b2 = v1.b[i++];
				var b3 = v1.b[i++];
				chars += b64.charAt(b1 >> 2) + b64.charAt((b1 << 4 | b2 >> 4) & 63) + b64.charAt((b2 << 2 | b3 >> 6) & 63) + b64.charAt(b3 & 63);
			}
			if(i == max) {
				var b1 = v1.b[i++];
				var b2 = v1.b[i++];
				chars += b64.charAt(b1 >> 2) + b64.charAt((b1 << 4 | b2 >> 4) & 63) + b64.charAt(b2 << 2 & 63);
			} else if(i == max + 1) {
				var b1 = v1.b[i++];
				chars += b64.charAt(b1 >> 2) + b64.charAt(b1 << 4 & 63);
			}
			this.buf.add("s");
			this.buf.add(chars.length);
			this.buf.add(":");
			this.buf.add(chars);
			break;
		default:
			this.cache.pop();
			if(v.hxSerialize != null) {
				this.buf.add("C");
				this.serializeString(Type.getClassName(c));
				this.cache.push(v);
				v.hxSerialize(this);
				this.buf.add("g");
			} else {
				this.buf.add("c");
				this.serializeString(Type.getClassName(c));
				this.cache.push(v);
				this.serializeFields(v);
			}
		}
		break;
	case 4:
		if(this.useCache && this.serializeRef(v)) return;
		this.buf.add("o");
		this.serializeFields(v);
		break;
	case 7:
		var e = $e[2];
		if(this.useCache && this.serializeRef(v)) return;
		this.cache.pop();
		this.buf.add(this.useEnumIndex?"j":"w");
		this.serializeString(Type.getEnumName(e));
		if(this.useEnumIndex) {
			this.buf.add(":");
			this.buf.add(v[1]);
		} else this.serializeString(v[0]);
		this.buf.add(":");
		var l = v["length"];
		this.buf.add(l - 2);
		var _g = 2;
		while(_g < l) {
			var i = _g++;
			this.serialize(v[i]);
		}
		this.cache.push(v);
		break;
	case 5:
		throw "Cannot serialize function";
		break;
	default:
		throw "Cannot serialize " + Std.string(v);
	}
}
haxe.Serializer.prototype.serializeException = function(e) {
	this.buf.add("x");
	this.serialize(e);
}
haxe.Serializer.prototype.__class__ = haxe.Serializer;
if(typeof js=='undefined') js = {}
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
m.cover.coverage.data.File = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.data.AbstractNodeList.call(this);
}
m.cover.coverage.data.File.__name__ = ["m","cover","coverage","data","File"];
m.cover.coverage.data.File.__super__ = m.cover.coverage.data.AbstractNodeList;
for(var k in m.cover.coverage.data.AbstractNodeList.prototype ) m.cover.coverage.data.File.prototype[k] = m.cover.coverage.data.AbstractNodeList.prototype[k];
m.cover.coverage.data.File.prototype.getClasses = function() {
	var a = [];
	var $it0 = this.itemsById.iterator();
	while( $it0.hasNext() ) {
		var item = $it0.next();
		if(Type.getClass(item) == m.cover.coverage.data.Clazz) a.push((function($this) {
			var $r;
			var $t = item;
			if(Std["is"]($t,m.cover.coverage.data.Clazz)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this)));
	}
	return a;
}
m.cover.coverage.data.File.prototype.appendResults = function(to,from) {
	to = m.cover.coverage.data.AbstractNodeList.prototype.appendResults.call(this,to,from);
	to.cc += from.sc > 0?1:0;
	to.c += 1;
	return to;
}
m.cover.coverage.data.File.prototype.__class__ = m.cover.coverage.data.File;
m.cover.coverage.data.Coverage = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.data.AbstractNodeList.call(this);
	this.statements = new IntHash();
	this.branches = new IntHash();
	this.statementResultsById = new IntHash();
	this.branchResultsById = new IntHash();
}
m.cover.coverage.data.Coverage.__name__ = ["m","cover","coverage","data","Coverage"];
m.cover.coverage.data.Coverage.__super__ = m.cover.coverage.data.AbstractNodeList;
for(var k in m.cover.coverage.data.AbstractNodeList.prototype ) m.cover.coverage.data.Coverage.prototype[k] = m.cover.coverage.data.AbstractNodeList.prototype[k];
m.cover.coverage.data.Coverage.prototype.statements = null;
m.cover.coverage.data.Coverage.prototype.branches = null;
m.cover.coverage.data.Coverage.prototype.statementResultsById = null;
m.cover.coverage.data.Coverage.prototype.branchResultsById = null;
m.cover.coverage.data.Coverage.prototype.setStatementResultsHash = function(hash) {
	this.statementResultsById = hash;
}
m.cover.coverage.data.Coverage.prototype.setBranchResultsHash = function(hash) {
	this.branchResultsById = hash;
}
m.cover.coverage.data.Coverage.prototype.addStatement = function(block) {
	this.verifyBlockData(block);
	if(this.statements.exists(block.id)) throw new m.cover.Exception("Statement already exists: " + block.id + " " + block.toString(),null,{ fileName : "Coverage.hx", lineNumber : 72, className : "m.cover.coverage.data.Coverage", methodName : "addStatement"});
	var packg = (function($this) {
		var $r;
		var $t = $this.getItemByName(block.packageName,m.cover.coverage.data.Package);
		if(Std["is"]($t,m.cover.coverage.data.Package)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	var file = (function($this) {
		var $r;
		var $t = packg.getItemByName(block.file,m.cover.coverage.data.File);
		if(Std["is"]($t,m.cover.coverage.data.File)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	var clazz = (function($this) {
		var $r;
		var $t = file.getItemByName(block.qualifiedClassName,m.cover.coverage.data.Clazz);
		if(Std["is"]($t,m.cover.coverage.data.Clazz)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	var method = (function($this) {
		var $r;
		var $t = clazz.getItemByName(block.methodName,m.cover.coverage.data.Method);
		if(Std["is"]($t,m.cover.coverage.data.Method)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	method.addStatement(block);
	block.lookup = [packg.id,file.id,clazz.id,method.id,block.id];
	this.statements.set(block.id,block.lookup.concat([]));
}
m.cover.coverage.data.Coverage.prototype.addBranch = function(block) {
	this.verifyBlockData(block);
	if(this.branches.exists(block.id)) throw new m.cover.Exception("Branch already exists: " + block.id + " " + block.toString(),null,{ fileName : "Coverage.hx", lineNumber : 88, className : "m.cover.coverage.data.Coverage", methodName : "addBranch"});
	var packg = (function($this) {
		var $r;
		var $t = $this.getItemByName(block.packageName,m.cover.coverage.data.Package);
		if(Std["is"]($t,m.cover.coverage.data.Package)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	var file = (function($this) {
		var $r;
		var $t = packg.getItemByName(block.file,m.cover.coverage.data.File);
		if(Std["is"]($t,m.cover.coverage.data.File)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	var clazz = (function($this) {
		var $r;
		var $t = file.getItemByName(block.qualifiedClassName,m.cover.coverage.data.Clazz);
		if(Std["is"]($t,m.cover.coverage.data.Clazz)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	var method = (function($this) {
		var $r;
		var $t = clazz.getItemByName(block.methodName,m.cover.coverage.data.Method);
		if(Std["is"]($t,m.cover.coverage.data.Method)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	method.addBranch(block);
	block.lookup = [packg.id,file.id,clazz.id,method.id,block.id];
	this.branches.set(block.id,block.lookup.concat([]));
}
m.cover.coverage.data.Coverage.prototype.verifyBlockData = function(block) {
	if(block.id == null) throw new m.cover.Exception("id cannot be null",null,{ fileName : "Coverage.hx", lineNumber : 103, className : "m.cover.coverage.data.Coverage", methodName : "verifyBlockData"});
	if(block.packageName == null) throw new m.cover.Exception("packageName cannot be null",null,{ fileName : "Coverage.hx", lineNumber : 104, className : "m.cover.coverage.data.Coverage", methodName : "verifyBlockData"});
	if(block.file == null) throw new m.cover.Exception("file cannot be null",null,{ fileName : "Coverage.hx", lineNumber : 105, className : "m.cover.coverage.data.Coverage", methodName : "verifyBlockData"});
	if(block.qualifiedClassName == null) throw new m.cover.Exception("qualifiedClassName cannot be null",null,{ fileName : "Coverage.hx", lineNumber : 106, className : "m.cover.coverage.data.Coverage", methodName : "verifyBlockData"});
	if(block.methodName == null) throw new m.cover.Exception("methodName cannot be null",null,{ fileName : "Coverage.hx", lineNumber : 107, className : "m.cover.coverage.data.Coverage", methodName : "verifyBlockData"});
}
m.cover.coverage.data.Coverage.prototype.getBranchById = function(id) {
	if(!this.branches.exists(id)) throw new m.cover.Exception("Branch does not exist: " + id,null,{ fileName : "Coverage.hx", lineNumber : 112, className : "m.cover.coverage.data.Coverage", methodName : "getBranchById"});
	var lookup = this.branches.get(id).concat([]);
	return this.lookupBranch(lookup);
}
m.cover.coverage.data.Coverage.prototype.getStatementById = function(id) {
	if(!this.statements.exists(id)) throw new m.cover.Exception("Statement does not exist: " + id,null,{ fileName : "Coverage.hx", lineNumber : 121, className : "m.cover.coverage.data.Coverage", methodName : "getStatementById"});
	var lookup = this.statements.get(id).concat([]);
	return this.lookupStatement(lookup);
}
m.cover.coverage.data.Coverage.prototype.getMissingBranches = function() {
	var a = m.cover.coverage.data.AbstractNodeList.prototype.getMissingBranches.call(this);
	a.sort(m.cover.coverage.data.DataUtil.sortOnBlockName);
	return a;
}
m.cover.coverage.data.Coverage.prototype.getMissingStatements = function() {
	var a = m.cover.coverage.data.AbstractNodeList.prototype.getMissingStatements.call(this);
	a.sort(m.cover.coverage.data.DataUtil.sortOnBlockName);
	return a;
}
m.cover.coverage.data.Coverage.prototype.getClasses = function() {
	var a = m.cover.coverage.data.AbstractNodeList.prototype.getClasses.call(this);
	a.sort(m.cover.coverage.data.DataUtil.sortOnNodeName);
	return a;
}
m.cover.coverage.data.Coverage.prototype.getClassByName = function(name) {
	var index = name.lastIndexOf(".");
	var packageName = index > 1?name.substr(0,index):"";
	if(!this.items.exists(packageName)) return null;
	var pckgId = this.items.get(packageName);
	var pckg = (function($this) {
		var $r;
		var $t = $this.itemsById.get(pckgId);
		if(Std["is"]($t,m.cover.coverage.data.Package)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	var classes = pckg.getClasses();
	var _g = 0;
	while(_g < classes.length) {
		var cls = classes[_g];
		++_g;
		if(cls.name == name) return cls;
	}
	return null;
}
m.cover.coverage.data.Coverage.prototype.getPackages = function() {
	var a = [];
	var $it0 = this.itemsById.iterator();
	while( $it0.hasNext() ) {
		var item = $it0.next();
		a.push((function($this) {
			var $r;
			var $t = item;
			if(Std["is"]($t,m.cover.coverage.data.Package)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this)));
	}
	a.sort(m.cover.coverage.data.DataUtil.sortOnNodeName);
	return a;
}
m.cover.coverage.data.Coverage.prototype.getResults = function(cache) {
	if(cache == null) cache = true;
	if(this.resultCache == null || !cache) {
		var $it0 = this.statements.iterator();
		while( $it0.hasNext() ) {
			var lookup = $it0.next();
			var statement = this.lookupStatement(lookup.concat([]));
			if(this.statementResultsById.exists(statement.id)) statement.count = this.statementResultsById.get(statement.id); else statement.count = 0;
		}
		var $it1 = this.branches.iterator();
		while( $it1.hasNext() ) {
			var lookup = $it1.next();
			var branch = this.lookupBranch(lookup.concat([]));
			if(this.branchResultsById.exists(branch.id)) {
				var result = this.branchResultsById.get(branch.id);
				branch.trueCount = result.trueCount;
				branch.falseCount = result.falseCount;
			} else {
				branch.trueCount = 0;
				branch.falseCount = 0;
			}
		}
		m.cover.coverage.data.AbstractNodeList.prototype.getResults.call(this,cache);
	}
	return this.resultCache;
}
m.cover.coverage.data.Coverage.prototype.appendResults = function(to,from) {
	to = m.cover.coverage.data.AbstractNodeList.prototype.appendResults.call(this,to,from);
	to.pc += from.sc > 0?1:0;
	to.p += 1;
	return to;
}
m.cover.coverage.data.Coverage.prototype.hxSerialize = function(s) {
	m.cover.coverage.data.AbstractNodeList.prototype.hxSerialize.call(this,s);
	s.serialize(this.statements);
	s.serialize(this.branches);
	s.serialize(this.statementResultsById);
	s.serialize(this.branchResultsById);
}
m.cover.coverage.data.Coverage.prototype.hxUnserialize = function(s) {
	m.cover.coverage.data.AbstractNodeList.prototype.hxUnserialize.call(this,s);
	this.statements = s.unserialize();
	this.branches = s.unserialize();
	this.statementResultsById = s.unserialize();
	this.branchResultsById = s.unserialize();
}
m.cover.coverage.data.Coverage.prototype.__class__ = m.cover.coverage.data.Coverage;
m.cover.coverage.data.Statement = function(p) {
	if( p === $_ ) return;
	m.cover.coverage.data.AbstractBlock.call(this);
	this.count = 0;
}
m.cover.coverage.data.Statement.__name__ = ["m","cover","coverage","data","Statement"];
m.cover.coverage.data.Statement.__super__ = m.cover.coverage.data.AbstractBlock;
for(var k in m.cover.coverage.data.AbstractBlock.prototype ) m.cover.coverage.data.Statement.prototype[k] = m.cover.coverage.data.AbstractBlock.prototype[k];
m.cover.coverage.data.Statement.prototype.count = null;
m.cover.coverage.data.Statement.prototype.isCovered = function() {
	return this.count > 0;
}
m.cover.coverage.data.Statement.prototype.hxSerialize = function(s) {
	m.cover.coverage.data.AbstractBlock.prototype.hxSerialize.call(this,s);
	s.serialize(this.count);
}
m.cover.coverage.data.Statement.prototype.hxUnserialize = function(s) {
	m.cover.coverage.data.AbstractBlock.prototype.hxUnserialize.call(this,s);
	this.count = s.unserialize();
}
m.cover.coverage.data.Statement.prototype.__class__ = m.cover.coverage.data.Statement;
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
Main = function() { }
Main.__name__ = ["Main"];
Main.logger = null;
Main.main = function() {
	var example = new example.Example();
	var client = new m.cover.coverage.client.TraceClient();
	client.includeHeader = true;
	client.includeMissingBlocks = false;
	client.includeExecutionFrequency = false;
	client.includeClassBreakdown = true;
	client.includePackageBreakdown = true;
	client.includeOverallPercentage = true;
	client.includeSummary = false;
	Main.logger = m.cover.coverage.MCoverage.getLogger();
	Main.logger.addClient(client);
	Main.logger.completionHandler = Main.completionHandler;
	Main.logger.report();
}
Main.completionHandler = function(percent) {
	Main.completed = true;
	haxe.Log.trace("Coverage report complete: " + percent + "%",{ fileName : "Main.hx", lineNumber : 47, className : "Main", methodName : "completionHandler"});
}
Main.prototype.__class__ = Main;
$_ = {}
js.Boot.__res = {}
js.Boot.__init();
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
	js.Lib.document = document;
	js.Lib.window = window;
	onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if( f == null )
			return false;
		return f(msg,[url+":"+line]);
	}
}
haxe.Resource.content = [{ name : "MCoverData", data : "s17235:Q3kzMDptLmNvdmVyLmNvdmVyYWdlLmRhdGEuQ292ZXJhZ2VubnE6MEN5Mjk6bS5jb3Zlci5jb3ZlcmFnZS5kYXRhLlBhY2thZ2V6eTc6ZXhhbXBsZXE6MEN5MjY6bS5jb3Zlci5jb3ZlcmFnZS5kYXRhLkZpbGV6eTIzOmV4YW1wbGUlMkZOb3RDb3ZlcmVkLmh4cTowQ3kyNzptLmNvdmVyLmNvdmVyYWdlLmRhdGEuQ2xhenp6eTE4OmV4YW1wbGUuTm90Q292ZXJlZHE6MEN5Mjg6bS5jb3Zlci5jb3ZlcmFnZS5kYXRhLk1ldGhvZHp5MzpuZXdxOjBDeTMxOm0uY292ZXIuY292ZXJhZ2UuZGF0YS5TdGF0ZW1lbnR6blI0UjJ5MTA6Tm90Q292ZXJlZFI2UjhpMTU3aTE2M3k2NTouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZOb3RDb3ZlcmVkLmh4JTNBOSUzQSUyMGxpbmVzJTIwOS0xMWF6enp6emhhaTlpMTBpMTFoemdocWhnaGJSOHpoaTFnaGJSNnpoaTFnOjFDUjNpMXkyMDpleGFtcGxlJTJGRXhhbXBsZS5oeHE6MENSNXp5MTU6ZXhhbXBsZS5FeGFtcGxlcToxMENSN2kxMHkxMjpzd2l0Y2hNZXRob2RxOjM3Q1I5aTM3blIxMlIyeTc6RXhhbXBsZVIxM1IxNGkyMTM3aTIxNDJ5NjU6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTE0OSUzQSUyMGNoYXJzJTIwMTEtMTZhemkxemkxMGkzN2hhaTE0OWh6Zzo0MENSOWk0MG5SMTJSMlIxNVIxM1IxNGkyMTA4aTIxODR5Njc6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTE0NyUzQSUyMGxpbmVzJTIwMTQ3LTE1MmF6aTF6aTEwaTQwaGFpMTQ3aTE0OGkxNTJoemc6MzlDUjlpMzluUjEyUjJSMTVSMTNSMTRpMjE3NGkyMTc5eTY1Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0ExNTElM0ElMjBjaGFycyUyMDEyLTE3YXppMXppMTBpMzloYWkxNTFoemc6MzhDUjlpMzhuUjEyUjJSMTVSMTNSMTRpMjE1NWkyMTYweTY1Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0ExNTAlM0ElMjBjaGFycyUyMDExLTE2YXppMXppMTBpMzhoYWkxNTBoemdocWhnOjlDUjdpOXk4OnRyeUNhdGNocTozNENSOWkzNG5SMTJSMlIxNVIxM1IyMGkyMjQ0aTIyNDl5NjM6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTE1OSUzQSUyMGNoYXJzJTIwMy04YXppMXppOWkzNGhhaTE1OWkxNjFpMTYzaHpnOjMzQ1I5aTMzblIxMlIyUjE1UjEzUjIwaTIyODFpMjI4Nnk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTYyJTNBJTIwY2hhcnMlMjA0LTlhemkxemk5aTMzaGFpMTYyaHpnOjM2Q1I5aTM2blIxMlIyUjE1UjEzUjIwaTIyMzNpMjIzNnk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTU3JTNBJTIwY2hhcnMlMjAyLTVhemkxemk5aTM2aGFpMTU3aHpnOjM1Q1I5aTM1blIxMlIyUjE1UjEzUjIwaTIzMzdpMjM0Mnk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTY3JTNBJTIwY2hhcnMlMjAzLThhemkxemk5aTM1aGFpMTY3aHpnaHE6MjRDeTI4Om0uY292ZXIuY292ZXJhZ2UuZGF0YS5CcmFuY2hpMjRuUjEyUjJSMTVSMTNSMjBpMjI1N2kyMjcweTY0Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0ExNjAlM0ElMjBjaGFycyUyMDYtMTlhemkxemk5aTI0aGFpMTYwaHp6Z2hnOjhDUjdpOHk5OndoaWxlTG9vcHE6MzFDUjlpMzFuUjEyUjJSMTVSMTNSMjdpMjQ5M2kyNTA5eTY0Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0ExODIlM0ElMjBjaGFycyUyMDMtMTlhemkxemk4aTMxaGFpMTgzaHpnOjMwQ1I5aTMwblIxMlIyUjE1UjEzUjI3aTI0MTJpMjQxNXk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTc2JTNBJTIwY2hhcnMlMjAzLTZhemkxemk4aTMwaGFpMTc2aHpnOjMyQ1I5aTMyblIxMlIyUjE1UjEzUjI3aTIzNzlpMjM4OXk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTczJTNBJTIwY2hhcnMlMjAyLTEyYXppMXppOGkzMmhhaTE3M2kxNzVpMTc3aTE3OGkxNzlpMTgxaTE4NGh6Z2hxOjIyQ1IyNWkyMm5SMTJSMlIxNVIxM1IyN2kyNDk2aTI1MDJ5NjQ6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTE4MiUzQSUyMGNoYXJzJTIwNi0xMmF6aTF6aThpMjJoYWkxODJoenpnOjIxQ1IyNWkyMW5SMTJSMlIxNVIxM1IyN2kyMzk4aTI0MDN5NjQ6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTE3NCUzQSUyMGNoYXJzJTIwOC0xM2F6aTF6aThpMjFoYWkxNzRoenpnOjIzQ1IyNWkyM25SMTJSMlIxNVIxM1IyN2kyNDM5aTI0NDR5NjQ6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTE4MCUzQSUyMGNoYXJzJTIwOC0xM2F6aTF6aThpMjNoYWkxODBoenpnaGc6N0NSN2k3eTg6Zm9yTG9vcHNxOjI4Q1I5aTI4blIxMlIyUjE1UjEzUjM0aTI2NDRpMjY0OXk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTk4JTNBJTIwY2hhcnMlMjAzLThhemkxemk3aTI4aGFpMTk4aHpnOjI3Q1I5aTI3blIxMlIyUjE1UjEzUjM0aTI1NzZpMjU4MXk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTkxJTNBJTIwY2hhcnMlMjAzLThhemkxemk3aTI3aGFpMTkxaHpnOjI5Q1I5aTI5blIxMlIyUjE1UjEzUjM0aTI1NTNpMjU4Nnk2NzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTg5JTNBJTIwbGluZXMlMjAxODktMTkyYXppMXppN2kyOWhhaTE4OWkxOTBpMTkyaTE5M2kxOTRpMTk1aTE5NmkxOTdpMTk5aHpnaHFoZzo2Q1I3aTZ5MTc6dGVybmFyeUV4cHJlc3Npb25xOjI2Q1I5aTI2blIxMlIyUjE1UjEzUjM4aTI3MTBpMjczMnk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjA0JTNBJTIwY2hhcnMlMjAyLTI0YXppMXppNmkyNmhhaHpnaHE6MjBDUjI1aTIwblIxMlIyUjE1UjEzUjM4aTI3MThpMjcyM3k2NTouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjA0JTNBJTIwY2hhcnMlMjAxMC0xNWF6aTF6aTZpMjBoYWkyMDRoenpnaGc6NUNSN2k1eTE0OmlubGluZUZ1bmN0aW9ucToyNENSOWkyNG5SMTJSMlIxNVIxM1I0MWkyNzk1aTI4MDB5NjM6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTIxMSUzQSUyMGNoYXJzJTIwMy04YXppMXppNWkyNGhhaTIxMWh6ZzoyNUNSOWkyNW5SMTJSMlIxNVIxM1I0MWkyNzY5aTI4MDV5Njc6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTIwOSUzQSUyMGxpbmVzJTIwMjA5LTIxMmF6aTF6aTVpMjVoYWkyMDlpMjEwaTIxMmkyMTNpMjE0aHpnaHFoZzo0Q1I3aTR5MTA6YnJhbmNoQm9vbHE6MTlDUjlpMTluUjEyUjJSMTVSMTNSNDRpMjg3N2kyODgyeTYzOi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EyMjAlM0ElMjBjaGFycyUyMDMtOGF6aTF6aTRpMTloYWkyMjBoemc6MjJDUjlpMjJuUjEyUjJSMTVSMTNSNDRpMjk3M2kyOTc4eTYzOi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EyMzUlM0ElMjBjaGFycyUyMDMtOGF6aTF6aTRpMjJoYWkyMzVoemc6MjFDUjlpMjFuUjEyUjJSMTVSMTNSNDRpMjk0MWkyOTQ2eTYzOi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EyMzAlM0ElMjBjaGFycyUyMDMtOGF6aTF6aTRpMjFoYWkyMzBoemc6MjBDUjlpMjBuUjEyUjJSMTVSMTNSNDRpMjkwOWkyOTE0eTYzOi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EyMjUlM0ElMjBjaGFycyUyMDMtOGF6aTF6aTRpMjBoYWkyMjVoemc6MjNDUjlpMjNuUjEyUjJSMTVSMTNSNDRpMjg1OWkyODg3eTY3Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EyMTglM0ElMjBsaW5lcyUyMDIxOC0yMjFhemkxemk0aTIzaGFpMjE5aTIyMWkyMjJpMjI0aTIyNmkyMjdpMjI5aTIzMWkyMzJpMjM0aTIzNmh6Z2hxOjE2Q1IyNWkxNm5SMTJSMlIxNVIxM1I0NGkyODYyaTI4Njh5NjQ6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTIxOCUzQSUyMGNoYXJzJTIwNS0xMWF6aTF6aTRpMTZoYWh6emc6MTlDUjI1aTE5blIxMlIyUjE1UjEzUjQ0aTI5NThpMjk2NHk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjMzJTNBJTIwY2hhcnMlMjA1LTExYXppMXppNGkxOWhhaTIzM2h6emc6MTVDUjI1aTE1blIxMlIyUjE1UjEzUjQ0aTI4NjdpMjg2OHk2NTouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjE4JTNBJTIwY2hhcnMlMjAxMC0xMWF6aTF6aTRpMTVoYWh6emc6MThDUjI1aTE4blIxMlIyUjE1UjEzUjQ0aTI5MjZpMjkzMnk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjI4JTNBJTIwY2hhcnMlMjA1LTExYXppMXppNGkxOGhhaTIyOGh6emc6MTRDUjI1aTE0blIxMlIyUjE1UjEzUjQ0aTI4NjJpMjg2M3k2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjE4JTNBJTIwY2hhcnMlMjA1LTZhemkxemk0aTE0aGFpMjE4aHp6ZzoxN0NSMjVpMTduUjEyUjJSMTVSMTNSNDRpMjg5NGkyOTAweTY0Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EyMjMlM0ElMjBjaGFycyUyMDUtMTFhemkxemk0aTE3aGFpMjIzaHp6Z2hnOjNDUjdpM3k5OmJyYW5jaEludHE6MThDUjlpMThuUjEyUjJSMTVSMTNSNTZpMzAyN2kzMDU1eTY3Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EyNDElM0ElMjBsaW5lcyUyMDI0MS0yNDRhemkxemkzaTE4aGFpMjQyaTI0NGkyNDZpMjQ4aTI0OWkyNTFpMjUzaTI1NGkyNTZpMjU4aTI1OWkyNjFpMjYzaTI2NGkyNjZpMjY4aHpnOjE3Q1I5aTE3blIxMlIyUjE1UjEzUjU2aTMyMDJpMzIwN3k2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjY3JTNBJTIwY2hhcnMlMjAzLThhemkxemkzaTE3aGFpMjY3aHpnOjE2Q1I5aTE2blIxMlIyUjE1UjEzUjU2aTMxNzBpMzE3NXk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjYyJTNBJTIwY2hhcnMlMjAzLThhemkxemkzaTE2aGFpMjYyaHpnOjE1Q1I5aTE1blIxMlIyUjE1UjEzUjU2aTMxMzlpMzE0NHk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjU3JTNBJTIwY2hhcnMlMjAzLThhemkxemkzaTE1aGFpMjU3aHpnOjE0Q1I5aTE0blIxMlIyUjE1UjEzUjU2aTMxMDdpMzExMnk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjUyJTNBJTIwY2hhcnMlMjAzLThhemkxemkzaTE0aGFpMjUyaHpnOjEzQ1I5aTEzblIxMlIyUjE1UjEzUjU2aTMwNzZpMzA4MXk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjQ3JTNBJTIwY2hhcnMlMjAzLThhemkxemkzaTEzaGFpMjQ3aHpnOjEyQ1I5aTEyblIxMlIyUjE1UjEzUjU2aTMwNDVpMzA1MHk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjQzJTNBJTIwY2hhcnMlMjAzLThhemkxemkzaTEyaGFpMjQzaHpnaHE6MTBDUjI1aTEwblIxMlIyUjE1UjEzUjU2aTMwOTNpMzA5OHk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjUwJTNBJTIwY2hhcnMlMjA1LTEwYXppMXppM2kxMGhhaTI1MGh6emc6MTNDUjI1aTEzblIxMlIyUjE1UjEzUjU2aTMxODdpMzE5M3k2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjY1JTNBJTIwY2hhcnMlMjA1LTExYXppMXppM2kxM2hhaTI2NWh6emc6OUNSMjVpOW5SMTJSMlIxNVIxM1I1NmkzMDYxaTMwNjd5NjQ6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTI0NSUzQSUyMGNoYXJzJTIwNS0xMWF6aTF6aTNpOWhhaTI0NWh6emc6MTJDUjI1aTEyblIxMlIyUjE1UjEzUjU2aTMxNTZpMzE2MXk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjYwJTNBJTIwY2hhcnMlMjA1LTEwYXppMXppM2kxMmhhaTI2MGh6emc6OENSMjVpOG5SMTJSMlIxNVIxM1I1NmkzMDMwaTMwMzZ5NjQ6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTI0MSUzQSUyMGNoYXJzJTIwNS0xMWF6aTF6aTNpOGhhaTI0MWh6emc6MTFDUjI1aTExblIxMlIyUjE1UjEzUjU2aTMxMjRpMzEzMHk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjU1JTNBJTIwY2hhcnMlMjA1LTExYXppMXppM2kxMWhhaTI1NWh6emdoZzoyQ1I3aTJ5MTI6YnJhbmNoU3RyaW5ncToxMENSOWkxMG5SMTJSMlIxNVIxM1I3MGkzMzEzaTMzMTh5NjM6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTI3OCUzQSUyMGNoYXJzJTIwMy04YXppMXppMmkxMGhhaTI3OGh6Zzo5Q1I5aTluUjEyUjJSMTVSMTNSNzBpMzI4MmkzMjg3eTYzOi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EyNzQlM0ElMjBjaGFycyUyMDMtOGF6aTF6aTJpOWhhaTI3NGh6ZzoxMUNSOWkxMW5SMTJSMlIxNVIxM1I3MGkzMjY0aTMyOTJ5Njc6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTI3MiUzQSUyMGxpbmVzJTIwMjcyLTI3NWF6aTF6aTJpMTFoYWkyNzNpMjc1aTI3N2kyNzloemdocTo2Q1IyNWk2blIxMlIyUjE1UjEzUjcwaTMyNjdpMzI3M3k2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjcyJTNBJTIwY2hhcnMlMjA1LTExYXppMXppMmk2aGFpMjcyaHp6Zzo3Q1IyNWk3blIxMlIyUjE1UjEzUjcwaTMyOThpMzMwNHk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjc2JTNBJTIwY2hhcnMlMjA1LTExYXppMXppMmk3aGFpMjc2aHp6Z2hnOjE3Q1I3aTE3UjhxOjUzQ1I5aTUzblIxMlIyUjE1UjEzUjhpMjk4aTMwN3k2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTYlM0ElMjBjaGFycyUyMDItMTFhemkxemkxN2k1M2hhaTE2aTE3aTE4aTE5aTIwaTIxaTIyaTIzaTI0aTI1aTI2aTI3aTI4aTI5aTMwaTMxaTMyaTMzaTM0aTM1aTM2aTM3aTM4aTM5aTQwaTQxaTQyaTQzaTQ0aTQ1aTQ2aTQ3aTQ4aTQ5aTUwaTUxaTUyaTUzaTU0aTU1aTU2aTU3aTU4aTU5aTYwaTYxaTYyaHpnaHFoZzoxQ1I3aTF5MTE6YnJhbmNoRmxvYXRxOjRDUjlpNG5SMTJSMlIxNVIxM1I3N2kzNDUzaTM0NTh5NjM6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTI5NSUzQSUyMGNoYXJzJTIwMy04YXppMXppMWk0aGFpMjk1aHpnOjNDUjlpM25SMTJSMlIxNVIxM1I3N2kzNDIyaTM0Mjd5NjM6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTI5MCUzQSUyMGNoYXJzJTIwMy04YXppMXppMWkzaGFpMjkwaHpnOjJDUjlpMm5SMTJSMlIxNVIxM1I3N2kzMzkxaTMzOTZ5NjM6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTI4NiUzQSUyMGNoYXJzJTIwMy04YXppMXppMWkyaGFpMjg2aHpnOjhDUjlpOG5SMTJSMlIxNVIxM1I3N2kzMzczaTM0MDF5Njc6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTI4NCUzQSUyMGxpbmVzJTIwMjg0LTI4N2F6aTF6aTFpOGhhaTI4NWkyODdpMjg5aTI5MWkyOTJpMjk0aTI5NmkyOTdpMjk5aTMwMWkzMDJpMzA0aTMwNmkzMDdpMzA5aTMxMWh6Zzo3Q1I5aTduUjEyUjJSMTVSMTNSNzdpMzU0OGkzNTUzeTYzOi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EzMTAlM0ElMjBjaGFycyUyMDMtOGF6aTF6aTFpN2hhaTMxMGh6Zzo2Q1I5aTZuUjEyUjJSMTVSMTNSNzdpMzUxNmkzNTIxeTYzOi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EzMDUlM0ElMjBjaGFycyUyMDMtOGF6aTF6aTFpNmhhaTMwNWh6Zzo1Q1I5aTVuUjEyUjJSMTVSMTNSNzdpMzQ4NWkzNDkweTYzOi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EzMDAlM0ElMjBjaGFycyUyMDMtOGF6aTF6aTFpNWhhaTMwMGh6Z2hxOjFDUjI1aTFuUjEyUjJSMTVSMTNSNzdpMzQwN2kzNDEzeTY0Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EyODglM0ElMjBjaGFycyUyMDUtMTFhemkxemkxaTFoYWkyODhoenpnOjRDUjI1aTRuUjEyUjJSMTVSMTNSNzdpMzUwMmkzNTA3eTY0Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0EzMDMlM0ElMjBjaGFycyUyMDUtMTBhemkxemkxaTRoYWkzMDNoenpnOjBDUjI1em5SMTJSMlIxNVIxM1I3N2kzMzc2aTMzODJ5NjQ6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTI4NCUzQSUyMGNoYXJzJTIwNS0xMWF6aTF6aTF6aGFpMjg0aHp6ZzozQ1IyNWkzblIxMlIyUjE1UjEzUjc3aTM0NzBpMzQ3Nnk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjk4JTNBJTIwY2hhcnMlMjA1LTExYXppMXppMWkzaGFpMjk4aHp6ZzoyQ1IyNWkyblIxMlIyUjE1UjEzUjc3aTM0MzlpMzQ0NHk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMjkzJTNBJTIwY2hhcnMlMjA1LTEwYXppMXppMWkyaGFpMjkzaHp6Zzo1Q1IyNWk1blIxMlIyUjE1UjEzUjc3aTM1MzNpMzUzOXk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMzA4JTNBJTIwY2hhcnMlMjA1LTExYXppMXppMWk1aGFpMzA4aHp6Z2hnOjE2Q1I3aTE2eTc6Y292ZXJlZHE6NTJDUjlpNTJuUjEyUjJSMTVSMTNSOTFpMTIzNmkxMjQxeTYyOi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0E3MCUzQSUyMGNoYXJzJTIwMi03YXppMXppMTZpNTJoYWk3MGh6Z2hxaGc6MENSN3p5MTQ6Y2xhc3NJbnN0YW5jZXNxOjFDUjlpMW5SMTJSMlIxNVIxM1I5M2kzNTk1aTM2MzR5NjQ6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTMxNiUzQSUyMGNoYXJzJTIwMi00MWF6aTF6emkxaGFpMzE2aTMxN2kzMThpMzE5aTMyMGkzMjFpMzIyaHpnaHFoZzoxNUNSN2kxNXkxMDpub3RDb3ZlcmVkcTo1MENSOWk1MG5SMTJSMlIxNVIxM1I5NWkxMzg5aTEzOTl5NjM6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTgzJTNBJTIwY2hhcnMlMjAzLTEzYXppMXppMTVpNTBoYWk4M2h6Zzo1MUNSOWk1MW5SMTJSMlIxNVIxM1I5NWkxMzU3aTEzNjd5NjM6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTc5JTNBJTIwY2hhcnMlMjAyLTEyYXppMXppMTVpNTFoYWk3OWk4MGk4Mmk4NGh6Z2hxOjI4Q1IyNWkyOG5SMTJSMlIxNVIxM1I5NWkxMzc1aTEzODB5NjM6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTgxJTNBJTIwY2hhcnMlMjA1LTEwYXppMXppMTVpMjhoYWk4MWh6emdoZzoxNENSN2kxNHkxNTpub3RDb3ZlcmVkRW1wdHlxOjQ5Q1I5aTQ5blIxMlIyUjE1UjEzUjk5aTE2MDlpMTYxMXk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTAwJTNBJTIwY2hhcnMlMjAxLTNhemkxemkxNGk0OWhhaTEwMGh6Z2hxaGc6MTNDUjdpMTN5MTI6bm90Q292ZXJhYmxlcTo0OENSOWk0OG5SMTJSMlIxNVIxM1IxMDFpMTc1MmkxNzYyeTY0Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0ExMDclM0ElMjBjaGFycyUyMDItMTJhemkxemkxM2k0OGhhaTEwN2kxMDhpMTA5aTExMGkxMTFpMTEyaTExM2kxMTRoemdocWhnOjEyQ1I3aTEyeTg6aWZNZXRob2RxOjQ2Q1I5aTQ2blIxMlIyUjE1UjEzUjEwM2kxOTA4aTE5MTN5NjM6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTEyNSUzQSUyMGNoYXJzJTIwMy04YXppMXppMTJpNDZoYWkxMjVoemc6NDVDUjlpNDVuUjEyUjJSMTVSMTNSMTAzaTE4ODNpMTg4OHk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTIxJTNBJTIwY2hhcnMlMjAzLThhemkxemkxMmk0NWhhaTEyMWh6Zzo0N0NSOWk0N25SMTJSMlIxNVIxM1IxMDNpMTg2NmkxOTE4eTY3Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0ExMTklM0ElMjBsaW5lcyUyMDExOS0xMjZhemkxemkxMmk0N2hhaTEyMGkxMjJpMTIzaTEyNGkxMjZoemdocToyN0NSMjVpMjduUjEyUjJSMTVSMTNSMTAzaTE4NjlpMTg3NHk2NDouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTE5JTNBJTIwY2hhcnMlMjA1LTEwYXppMXppMTJpMjdoYWkxMTloenpnaGc6MTFDUjdpMTF5MTI6ZWxzZUlmTWV0aG9kcTo0M0NSOWk0M25SMTJSMlIxNVIxM1IxMDhpMjA1M2kyMDU4eTYzOi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0ExNDElM0ElMjBjaGFycyUyMDMtOGF6aTF6aTExaTQzaGFpMTQxaHpnOjQyQ1I5aTQyblIxMlIyUjE1UjEzUjEwOGkyMDI4aTIwMzN5NjM6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTEzNyUzQSUyMGNoYXJzJTIwMy04YXppMXppMTFpNDJoYWkxMzdoemc6NDFDUjlpNDFuUjEyUjJSMTVSMTNSMTA4aTE5ODdpMTk5Mnk2MzouLiUyRmNvbW1vbiUyRnNyYyUyRmV4YW1wbGUlMkZFeGFtcGxlLmh4JTNBMTMzJTNBJTIwY2hhcnMlMjAzLThhemkxemkxMWk0MWhhaTEzM2h6Zzo0NENSOWk0NG5SMTJSMlIxNVIxM1IxMDhpMTk2NWkyMDYzeTY3Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0ExMzElM0ElMjBsaW5lcyUyMDEzMS0xNDJhemkxemkxMWk0NGhhaTEzMmkxMzRpMTM2aTEzOGkxMzlpMTQwaTE0Mmh6Z2hxOjI1Q1IyNWkyNW5SMTJSMlIxNVIxM1IxMDhpMjAwOWkyMDE5eTY1Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0ExMzUlM0ElMjBjaGFycyUyMDExLTIxYXppMXppMTFpMjVoYWkxMzVoenpnOjI2Q1IyNWkyNm5SMTJSMlIxNVIxM1IxMDhpMTk2OGkxOTc4eTY0Oi4uJTJGY29tbW9uJTJGc3JjJTJGZXhhbXBsZSUyRkV4YW1wbGUuaHglM0ExMzElM0ElMjBjaGFycyUyMDUtMTVhemkxemkxMWkyNmhhaTEzMWh6emdoZ2hiUjQ0aTRSMzhpNlIxMDFpMTNSOTlpMTRSMTRpMTBSOTVpMTVSMjBpOVI3MGkyUjU2aTNSOTN6UjEwOGkxMVI3N2kxUjEwM2kxMlI0MWk1UjM0aTdSOTFpMTZSMjdpOFI4aTE3aGkxOGc6MUNSNWkxeTIxOmV4YW1wbGUuSW50ZXJuYWxDbGFzc3E6MENSN3pSOHE6NTRDUjlpNTRuUjEyUjJ5MTM6SW50ZXJuYWxDbGFzc1IxMTVSOGkzOTI5aTM5NDJ5NjQ6Li4lMkZjb21tb24lMkZzcmMlMkZleGFtcGxlJTJGRXhhbXBsZS5oeCUzQTMzMyUzQSUyMGNoYXJzJTIwMi0xNWF6aTFpMXppNTRoYWkzMzNoemdocWhnaGJSOHpoaTFnaGJSMTN6UjExNWkxaGkyZ2hiUjR6UjEyaTFoaTJnaGJSMnpoaTFxOjI3YXppMXppN2kyN2g6MjZhemkxemk2aTI2aDoyNWF6aTF6aTVpMjVoOjI0YXppMXppNWkyNGg6MjNhemkxemk0aTIzaDo1NGF6aTFpMXppNTRoOjIyYXppMXppNGkyMmg6NTNhemkxemkxN2k1M2g6MjFhemkxemk0aTIxaDo1MmF6aTF6aTE2aTUyaDoyMGF6aTF6aTRpMjBoOjUxYXppMXppMTVpNTFoOjE5YXppMXppNGkxOWg6NTBhemkxemkxNWk1MGg6MThhemkxemkzaTE4aDo0OWF6aTF6aTE0aTQ5aDoxN2F6aTF6aTNpMTdoOjQ4YXppMXppMTNpNDhoOjE2YXppMXppM2kxNmg6NDdhemkxemkxMmk0N2g6MTVhemkxemkzaTE1aDo0NmF6aTF6aTEyaTQ2aDoxNGF6aTF6aTNpMTRoOjQ1YXppMXppMTJpNDVoOjEzYXppMXppM2kxM2g6NDRhemkxemkxMWk0NGg6MTJhemkxemkzaTEyaDo0M2F6aTF6aTExaTQzaDoxMWF6aTF6aTJpMTFoOjQyYXppMXppMTFpNDJoOjEwYXppMXppMmkxMGg6NDFhemkxemkxMWk0MWg6OWF6aTF6aTJpOWg6NDBhemkxemkxMGk0MGg6OGF6aTF6aTFpOGg6MzlhemkxemkxMGkzOWg6N2F6aTF6aTFpN2g6MzhhemkxemkxMGkzOGg6NmF6aTF6aTFpNmg6MzdhemkxemkxMGkzN2g6NWF6aTF6aTFpNWg6MzZhemkxemk5aTM2aDo0YXppMXppMWk0aDozNWF6aTF6aTlpMzVoOjNhemkxemkxaTNoOjM0YXppMXppOWkzNGg6MmF6aTF6aTFpMmg6MzNhemkxemk5aTMzaDoxYXppMXp6aTFoOjMyYXppMXppOGkzMmg6MGF6enp6emg6MzFhemkxemk4aTMxaDozMGF6aTF6aThpMzBoOjI5YXppMXppN2kyOWg6Mjhhemkxemk3aTI4aGhxOjEwYXppMXppM2kxMGg6MjVhemkxemkxMWkyNWg6OWF6aTF6aTNpOWg6MjRhemkxemk5aTI0aDo4YXppMXppM2k4aDoyM2F6aTF6aThpMjNoOjdhemkxemkyaTdoOjIyYXppMXppOGkyMmg6NmF6aTF6aTJpNmg6MjFhemkxemk4aTIxaDo1YXppMXppMWk1aDoyMGF6aTF6aTZpMjBoOjRhemkxemkxaTRoOjE5YXppMXppNGkxOWg6M2F6aTF6aTFpM2g6MThhemkxemk0aTE4aDoyYXppMXppMWkyaDoxN2F6aTF6aTRpMTdoOjFhemkxemkxaTFoOjE2YXppMXppNGkxNmg6MGF6aTF6aTF6aDoxNWF6aTF6aTRpMTVoOjE0YXppMXppNGkxNGg6MTNhemkxemkzaTEzaDoyOGF6aTF6aTE1aTI4aDoxMmF6aTF6aTNpMTJoOjI3YXppMXppMTJpMjdoOjExYXppMXppM2kxMWg6MjZhemkxemkxMWkyNmhocWhxaGc"}];
m.cover.util.Timer.__meta__ = { obj : { IgnoreCover : null, IgnoreLogging : null}, statics : { inlineStamp : { IgnoreCover : null}}, fields : { defaultRun : { IgnoreCover : null}}};
m.cover.util.Timer.arr = [];
m.cover.coverage.CoverageLoggerImpl.__meta__ = { obj : { IgnoreLogging : null}, fields : { logStatement : { IgnoreCover : null}, updateStatementHash : { IgnoreCover : null}, logBranch : { IgnoreCover : null}, updateBranchHash : { IgnoreCover : null}, _ : { IgnoreCover : null}}};
m.cover.coverage.data.AbstractNode.__meta__ = { obj : { IgnoreLogging : null}, fields : { getResults : { IgnoreLogging : null}, getPercentage : { IgnoreLogging : null}, emptyResult : { IgnoreLogging : null}, hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}, _ : { IgnoreCover : null}}};
example.Example.__meta__ = { statics : { log : { IgnoreCover : null}}, fields : { ignored : { IgnoreCover : null}}};
example.InternalClassWithIgnore.__meta__ = { obj : { IgnoreCover : null}};
example._Example.PrivateClassWithIgnore.__meta__ = { obj : { IgnoreCover : null}};
m.cover.coverage.data.AbstractNodeList.__meta__ = { obj : { IgnoreLogging : null}, fields : { getResults : { IgnoreLogging : null}, hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
m.cover.coverage.data.Clazz.__meta__ = { obj : { IgnoreLogging : null}};
m.cover.coverage.MCoverage.__meta__ = { obj : { IgnoreLogging : null, IgnoreCover : null}, statics : { getLogger : { IgnoreLogging : null, IgnoreCover : null}}};
m.cover.coverage.MCoverage.RESOURCE_DATA = "MCoverData";
m.cover.coverage.data.Package.__meta__ = { obj : { IgnoreLogging : null}};
m.cover.coverage.data.DataUtil.__meta__ = { statics : { sortOnNodeId : { IgnoreLogging : null}, sortOnNodeName : { IgnoreLogging : null}, sortOnBlockName : { IgnoreLogging : null}}, fields : { _ : { IgnoreCover : null}}};
m.cover.coverage.client.PrintClient.__meta__ = { obj : { IgnoreLogging : null}};
m.cover.coverage.client.PrintClient.DEFAULT_TAB_WIDTH = 11;
m.cover.coverage.client.PrintClient.SHORT_FIRST_TAB_WIDTH = 4;
m.cover.coverage.client.PrintClient.LONG_FIRST_TAB_WIDTH = 20;
m.cover.coverage.client.TraceClient.__meta__ = { obj : { IgnoreLogging : null}};
m.cover.coverage.data.Method.__meta__ = { obj : { IgnoreLogging : null}, fields : { hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
haxe.Unserializer.DEFAULT_RESOLVER = Type;
haxe.Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.CODES = null;
m.cover.coverage.data.AbstractBlock.__meta__ = { obj : { IgnoreLogging : null}, fields : { hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
m.cover.coverage.data.Branch.__meta__ = { obj : { IgnoreLogging : null}, fields : { hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
haxe.Serializer.USE_CACHE = false;
haxe.Serializer.USE_ENUM_INDEX = false;
haxe.Serializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
js.Lib.onerror = null;
m.cover.coverage.data.File.__meta__ = { obj : { IgnoreLogging : null}};
m.cover.coverage.data.Coverage.__meta__ = { obj : { IgnoreLogging : null}, fields : { getResults : { IgnoreLogging : null}, hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
m.cover.coverage.data.Statement.__meta__ = { obj : { IgnoreLogging : null}, fields : { hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
Main.__meta__ = { obj : { IgnoreCover : null}};
Main.completed = false;
Main.main()