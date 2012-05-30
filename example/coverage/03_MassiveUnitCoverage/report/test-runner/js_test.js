var $_, $hxClasses = $hxClasses || {}, $estr = function() { return js.Boot.__string_rec(this,''); }
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var ExampleTest = $hxClasses["ExampleTest"] = function() {
};
ExampleTest.__name__ = ["ExampleTest"];
ExampleTest.prototype = {
	timer: null
	,beforeClass: function() {
	}
	,afterClass: function() {
	}
	,setup: function() {
	}
	,tearDown: function() {
	}
	,testExample: function() {
		massive.munit.Assert.isTrue(true,{ fileName : "ExampleTest.hx", lineNumber : 45, className : "ExampleTest", methodName : "testExample"});
	}
	,testAsyncExample: function(factory) {
		var handler = factory.createHandler(this,this.onTestAsyncExampleComplete.$bind(this),300,{ fileName : "ExampleTest.hx", lineNumber : 51, className : "ExampleTest", methodName : "testAsyncExample"});
		this.timer = massive.munit.util.Timer.delay(handler,200);
	}
	,onTestAsyncExampleComplete: function() {
		massive.munit.Assert.isFalse(false,{ fileName : "ExampleTest.hx", lineNumber : 57, className : "ExampleTest", methodName : "onTestAsyncExampleComplete"});
	}
	,testExampleThatOnlyRunsWithDebugFlag: function() {
		massive.munit.Assert.isTrue(true,{ fileName : "ExampleTest.hx", lineNumber : 67, className : "ExampleTest", methodName : "testExampleThatOnlyRunsWithDebugFlag"});
	}
	,__class__: ExampleTest
}
var Hash = $hxClasses["Hash"] = function() {
	this.h = { };
};
Hash.__name__ = ["Hash"];
Hash.prototype = {
	h: null
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return a.iterator();
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		s.b[s.b.length] = "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b[s.b.length] = i == null?"null":i;
			s.b[s.b.length] = " => ";
			s.add(Std.string(this.get(i)));
			if(it.hasNext()) s.b[s.b.length] = ", ";
		}
		s.b[s.b.length] = "}";
		return s.b.join("");
	}
	,__class__: Hash
}
var IntHash = $hxClasses["IntHash"] = function() {
	this.h = { };
};
IntHash.__name__ = ["IntHash"];
IntHash.prototype = {
	h: null
	,set: function(key,value) {
		this.h[key] = value;
	}
	,get: function(key) {
		return this.h[key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return a.iterator();
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		s.b[s.b.length] = "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b[s.b.length] = i == null?"null":i;
			s.b[s.b.length] = " => ";
			s.add(Std.string(this.get(i)));
			if(it.hasNext()) s.b[s.b.length] = ", ";
		}
		s.b[s.b.length] = "}";
		return s.b.join("");
	}
	,__class__: IntHash
}
var IntIter = $hxClasses["IntIter"] = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIter.__name__ = ["IntIter"];
IntIter.prototype = {
	min: null
	,max: null
	,hasNext: function() {
		return this.min < this.max;
	}
	,next: function() {
		return this.min++;
	}
	,__class__: IntIter
}
var Lambda = $hxClasses["Lambda"] = function() { }
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
Lambda.prototype = {
	__class__: Lambda
}
var List = $hxClasses["List"] = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	h: null
	,q: null
	,length: null
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,first: function() {
		return this.h == null?null:this.h[0];
	}
	,last: function() {
		return this.q == null?null:this.q[0];
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,remove: function(v) {
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
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		s.b[s.b.length] = "{";
		while(l != null) {
			if(first) first = false; else s.b[s.b.length] = ", ";
			s.add(Std.string(l[0]));
			l = l[1];
		}
		s.b[s.b.length] = "}";
		return s.b.join("");
	}
	,join: function(sep) {
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
	,filter: function(f) {
		var l2 = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			if(f(v)) l2.add(v);
		}
		return l2;
	}
	,map: function(f) {
		var b = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			b.add(f(v));
		}
		return b;
	}
	,__class__: List
}
var Reflect = $hxClasses["Reflect"] = function() { }
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
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
Reflect.getProperty = function(o,field) {
	var tmp;
	return o == null?null:o.__properties__ && (tmp = o.__properties__["get_" + field])?o[tmp]():o[field];
}
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(hasOwnProperty.call(o,f)) a.push(f);
		}
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
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
}
Reflect.prototype = {
	__class__: Reflect
}
var Std = $hxClasses["Std"] = function() { }
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	return x | 0;
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
Std.prototype = {
	__class__: Std
}
var StringBuf = $hxClasses["StringBuf"] = function() {
	this.b = new Array();
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	add: function(x) {
		this.b[this.b.length] = x == null?"null":x;
	}
	,addSub: function(s,pos,len) {
		this.b[this.b.length] = s.substr(pos,len);
	}
	,addChar: function(c) {
		this.b[this.b.length] = String.fromCharCode(c);
	}
	,toString: function() {
		return this.b.join("");
	}
	,b: null
	,__class__: StringBuf
}
var StringTools = $hxClasses["StringTools"] = function() { }
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
StringTools.prototype = {
	__class__: StringTools
}
var TestMain = $hxClasses["TestMain"] = function() {
	var suites = new Array();
	suites.push(TestSuite);
	var client = new m.cover.coverage.munit.client.MCoverPrintClient();
	var httpClient = new massive.munit.client.HTTPClient(new m.cover.coverage.munit.client.MCoverSummaryReportClient());
	var runner = new massive.munit.TestRunner(client);
	runner.addResultClient(httpClient);
	runner.completionHandler = this.completionHandler.$bind(this);
	runner.run(suites);
};
TestMain.__name__ = ["TestMain"];
TestMain.main = function() {
	new TestMain();
}
TestMain.prototype = {
	completionHandler: function(successful) {
		try {
			eval("testResult(" + successful + ");");
		} catch( e ) {
		}
	}
	,__class__: TestMain
}
var massive = massive || {}
if(!massive.munit) massive.munit = {}
massive.munit.TestSuite = $hxClasses["massive.munit.TestSuite"] = function() {
	this.tests = new Array();
	this.index = 0;
};
massive.munit.TestSuite.__name__ = ["massive","munit","TestSuite"];
massive.munit.TestSuite.prototype = {
	tests: null
	,index: null
	,add: function(test) {
		this.tests.push(test);
		this.sortTests();
	}
	,hasNext: function() {
		return this.index < this.tests.length;
	}
	,next: function() {
		return this.hasNext()?this.tests[this.index++]:null;
	}
	,repeat: function() {
		if(this.index > 0) this.index--;
	}
	,sortTests: function() {
		this.tests.sort(this.sortByName.$bind(this));
	}
	,sortByName: function(x,y) {
		var xName = Type.getClassName(x);
		var yName = Type.getClassName(y);
		if(xName == yName) return 0;
		if(xName > yName) return 1; else return -1;
	}
	,__class__: massive.munit.TestSuite
}
var TestSuite = $hxClasses["TestSuite"] = function() {
	massive.munit.TestSuite.call(this);
	this.add(example.AccountTest);
	this.add(example.CalculatorTest);
	this.add(ExampleTest);
};
TestSuite.__name__ = ["TestSuite"];
TestSuite.__super__ = massive.munit.TestSuite;
TestSuite.prototype = $extend(massive.munit.TestSuite.prototype,{
	__class__: TestSuite
});
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
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
var Type = $hxClasses["Type"] = function() { }
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
	var cl = $hxClasses[name];
	if(cl == null || cl.__name__ == null) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || e.__ename__ == null) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	switch(args.length) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw "Too many arguments";
	}
	return null;
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
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
	var a = [];
	for(var i in c.prototype) a.push(i);
	a.remove("__class__");
	a.remove("__properties__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	a.remove("__name__");
	a.remove("__interfaces__");
	a.remove("__properties__");
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
Type.allEnums = function(e) {
	var all = [];
	var cst = e.__constructs__;
	var _g = 0;
	while(_g < cst.length) {
		var c = cst[_g];
		++_g;
		var v = Reflect.field(e,c);
		if(!Reflect.isFunction(v)) all.push(v);
	}
	return all;
}
Type.prototype = {
	__class__: Type
}
var example = example || {}
example.Account = $hxClasses["example.Account"] = function() {
	this.values = [];
};
example.Account.__name__ = ["example","Account"];
example.Account.prototype = {
	values: null
	,add: function(value) {
		this.values.push(value);
	}
	,remove: function(value) {
		this.values.remove(value);
	}
	,toString: function() {
		return this.values.toString();
	}
	,totalValue: function() {
		var total = 0;
		var _g = 0, _g1 = this.values;
		while(_g < _g1.length) {
			var value = _g1[_g];
			++_g;
			total = example.Calculator.add(total,value);
		}
		return total;
	}
	,__class__: example.Account
}
example.AccountTest = $hxClasses["example.AccountTest"] = function() {
};
example.AccountTest.__name__ = ["example","AccountTest"];
example.AccountTest.prototype = {
	instance: null
	,beforeClass: function() {
	}
	,afterClass: function() {
	}
	,setup: function() {
	}
	,tearDown: function() {
	}
	,shouldBeEmptyAtConstructor: function() {
		this.instance = new example.Account();
		massive.munit.Assert.areEqual(0,this.instance.totalValue(),{ fileName : "AccountTest.hx", lineNumber : 45, className : "example.AccountTest", methodName : "shouldBeEmptyAtConstructor"});
	}
	,shouldAddValueToTotal: function() {
		this.instance = new example.Account();
		this.instance.add(10);
		this.instance.add(1);
		massive.munit.Assert.areEqual(11,this.instance.totalValue(),{ fileName : "AccountTest.hx", lineNumber : 54, className : "example.AccountTest", methodName : "shouldAddValueToTotal"});
	}
	,__class__: example.AccountTest
}
example.Calculator = $hxClasses["example.Calculator"] = function() {
};
example.Calculator.__name__ = ["example","Calculator"];
example.Calculator.add = function(a,b) {
	return a + b;
}
example.Calculator.greatestValue = function(a,b) {
	if(a > b) return a;
	return b;
}
example.Calculator.prototype = {
	__class__: example.Calculator
}
example.CalculatorTest = $hxClasses["example.CalculatorTest"] = function() {
};
example.CalculatorTest.__name__ = ["example","CalculatorTest"];
example.CalculatorTest.prototype = {
	instance: null
	,beforeClass: function() {
	}
	,afterClass: function() {
	}
	,setup: function() {
	}
	,tearDown: function() {
	}
	,shouldAddValues: function() {
		var a = 1;
		var b = 10;
		massive.munit.Assert.areEqual(11,example.Calculator.add(a,b),{ fileName : "CalculatorTest.hx", lineNumber : 47, className : "example.CalculatorTest", methodName : "shouldAddValues"});
	}
	,shouldReturn10: function() {
		var a = 10;
		var b = 1;
		massive.munit.Assert.areEqual(a,example.Calculator.greatestValue(a,b),{ fileName : "CalculatorTest.hx", lineNumber : 56, className : "example.CalculatorTest", methodName : "shouldReturn10"});
	}
	,__class__: example.CalculatorTest
}
var haxe = haxe || {}
haxe.Http = $hxClasses["haxe.Http"] = function(url) {
	this.url = url;
	this.headers = new Hash();
	this.params = new Hash();
	this.async = true;
};
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
haxe.Http.prototype = {
	url: null
	,async: null
	,postData: null
	,headers: null
	,params: null
	,setHeader: function(header,value) {
		this.headers.set(header,value);
	}
	,setParameter: function(param,value) {
		this.params.set(param,value);
	}
	,setPostData: function(data) {
		this.postData = data;
	}
	,request: function(post) {
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
				uri += StringTools.urlEncode(p) + "=" + StringTools.urlEncode(this.params.get(p));
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
	,onData: function(data) {
	}
	,onError: function(msg) {
	}
	,onStatus: function(status) {
	}
	,__class__: haxe.Http
}
haxe.Log = $hxClasses["haxe.Log"] = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype = {
	__class__: haxe.Log
}
haxe.Resource = $hxClasses["haxe.Resource"] = function() { }
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
haxe.Resource.prototype = {
	__class__: haxe.Resource
}
haxe.Serializer = $hxClasses["haxe.Serializer"] = function() {
	this.buf = new StringBuf();
	this.cache = new Array();
	this.useCache = haxe.Serializer.USE_CACHE;
	this.useEnumIndex = haxe.Serializer.USE_ENUM_INDEX;
	this.shash = new Hash();
	this.scount = 0;
};
haxe.Serializer.__name__ = ["haxe","Serializer"];
haxe.Serializer.run = function(v) {
	var s = new haxe.Serializer();
	s.serialize(v);
	return s.toString();
}
haxe.Serializer.prototype = {
	buf: null
	,cache: null
	,shash: null
	,scount: null
	,useCache: null
	,useEnumIndex: null
	,toString: function() {
		return this.buf.b.join("");
	}
	,serializeString: function(s) {
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
	,serializeRef: function(v) {
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
	,serializeFields: function(v) {
		var _g = 0, _g1 = Reflect.fields(v);
		while(_g < _g1.length) {
			var f = _g1[_g];
			++_g;
			this.serializeString(f);
			this.serialize(Reflect.field(v,f));
		}
		this.buf.add("g");
	}
	,serialize: function(v) {
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
	,serializeException: function(e) {
		this.buf.add("x");
		this.serialize(e);
	}
	,__class__: haxe.Serializer
}
haxe.StackItem = $hxClasses["haxe.StackItem"] = { __ename__ : ["haxe","StackItem"], __constructs__ : ["CFunction","Module","FilePos","Method","Lambda"] }
haxe.StackItem.CFunction = ["CFunction",0];
haxe.StackItem.CFunction.toString = $estr;
haxe.StackItem.CFunction.__enum__ = haxe.StackItem;
haxe.StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Lambda = function(v) { var $x = ["Lambda",4,v]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.Stack = $hxClasses["haxe.Stack"] = function() { }
haxe.Stack.__name__ = ["haxe","Stack"];
haxe.Stack.callStack = function() {
	return [];
}
haxe.Stack.exceptionStack = function() {
	return [];
}
haxe.Stack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.b[b.b.length] = "\nCalled from ";
		haxe.Stack.itemToString(b,s);
	}
	return b.b.join("");
}
haxe.Stack.itemToString = function(b,s) {
	var $e = (s);
	switch( $e[1] ) {
	case 0:
		b.b[b.b.length] = "a C function";
		break;
	case 1:
		var m = $e[2];
		b.b[b.b.length] = "module ";
		b.b[b.b.length] = m == null?"null":m;
		break;
	case 2:
		var line = $e[4], file = $e[3], s1 = $e[2];
		if(s1 != null) {
			haxe.Stack.itemToString(b,s1);
			b.b[b.b.length] = " (";
		}
		b.b[b.b.length] = file == null?"null":file;
		b.b[b.b.length] = " line ";
		b.b[b.b.length] = line == null?"null":line;
		if(s1 != null) b.b[b.b.length] = ")";
		break;
	case 3:
		var meth = $e[3], cname = $e[2];
		b.b[b.b.length] = cname == null?"null":cname;
		b.b[b.b.length] = ".";
		b.b[b.b.length] = meth == null?"null":meth;
		break;
	case 4:
		var n = $e[2];
		b.b[b.b.length] = "local function #";
		b.b[b.b.length] = n == null?"null":n;
		break;
	}
}
haxe.Stack.makeStack = function(s) {
	return null;
}
haxe.Stack.prototype = {
	__class__: haxe.Stack
}
haxe.Unserializer = $hxClasses["haxe.Unserializer"] = function(buf) {
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
};
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
haxe.Unserializer.prototype = {
	buf: null
	,pos: null
	,length: null
	,cache: null
	,scache: null
	,resolver: null
	,setResolver: function(r) {
		if(r == null) this.resolver = { resolveClass : function(_) {
			return null;
		}, resolveEnum : function(_) {
			return null;
		}}; else this.resolver = r;
	}
	,getResolver: function() {
		return this.resolver;
	}
	,get: function(p) {
		return this.buf.cca(p);
	}
	,readDigits: function() {
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
	,unserializeObject: function(o) {
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
	,unserializeEnum: function(edecl,tag) {
		if(this.buf.cca(this.pos++) != 58) throw "Invalid enum format";
		var nargs = this.readDigits();
		if(nargs == 0) return Type.createEnum(edecl,tag);
		var args = new Array();
		while(nargs-- > 0) args.push(this.unserialize());
		return Type.createEnum(edecl,tag,args);
	}
	,unserialize: function() {
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
			var e = this.unserializeEnum(edecl,this.unserialize());
			this.cache.push(e);
			return e;
		case 106:
			var name = this.unserialize();
			var edecl = this.resolver.resolveEnum(name);
			if(edecl == null) throw "Enum not found " + name;
			this.pos++;
			var index = this.readDigits();
			var tag = Type.getEnumConstructs(edecl)[index];
			if(tag == null) throw "Unknown enum index " + name + "@" + index;
			var e = this.unserializeEnum(edecl,tag);
			this.cache.push(e);
			return e;
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
	,__class__: haxe.Unserializer
}
if(!haxe.io) haxe.io = {}
haxe.io.Bytes = $hxClasses["haxe.io.Bytes"] = function(length,b) {
	this.length = length;
	this.b = b;
};
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
haxe.io.Bytes.prototype = {
	length: null
	,b: null
	,get: function(pos) {
		return this.b[pos];
	}
	,set: function(pos,v) {
		this.b[pos] = v & 255;
	}
	,blit: function(pos,src,srcpos,len) {
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
	,sub: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		return new haxe.io.Bytes(len,this.b.slice(pos,pos + len));
	}
	,compare: function(other) {
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
	,readString: function(pos,len) {
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
	,toString: function() {
		return this.readString(0,this.length);
	}
	,toHex: function() {
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
	,getData: function() {
		return this.b;
	}
	,__class__: haxe.io.Bytes
}
haxe.io.Error = $hxClasses["haxe.io.Error"] = { __ename__ : ["haxe","io","Error"], __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] }
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
if(!haxe.rtti) haxe.rtti = {}
haxe.rtti.Meta = $hxClasses["haxe.rtti.Meta"] = function() { }
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
haxe.rtti.Meta.prototype = {
	__class__: haxe.rtti.Meta
}
var js = js || {}
js.Boot = $hxClasses["js.Boot"] = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
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
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
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
		if(x != x) return undefined;
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
	Function.prototype["$bind"] = function(o) {
		var f = function() {
			return f.method.apply(f.scope,arguments);
		};
		f.scope = o;
		f.method = this;
		return f;
	};
}
js.Boot.prototype = {
	__class__: js.Boot
}
js.Lib = $hxClasses["js.Lib"] = function() { }
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
js.Lib.prototype = {
	__class__: js.Lib
}
var m = m || {}
if(!m.cover) m.cover = {}
m.cover.Exception = $hxClasses["m.cover.Exception"] = function(message,cause,info) {
	this.type = this.here({ fileName : "Exception.hx", lineNumber : 66, className : "m.cover.Exception", methodName : "new"}).className;
	this.message = message;
	this.cause = cause;
	this.info = info;
	if(cause != null) {
		this.causeExceptionStack = haxe.Stack.exceptionStack();
		this.causeCallStack = haxe.Stack.callStack();
	}
};
m.cover.Exception.__name__ = ["m","cover","Exception"];
m.cover.Exception.prototype = {
	type: null
	,message: null
	,info: null
	,cause: null
	,causeExceptionStack: null
	,causeCallStack: null
	,toString: function() {
		var str = this.type + ": " + this.message;
		if(this.info != null) str += " at " + this.info.className + "#" + this.info.methodName + " (" + this.info.lineNumber + ")";
		if(this.cause != null) str += "\n\t Caused by: " + this.cause;
		return str;
	}
	,here: function(info) {
		return info;
	}
	,__class__: m.cover.Exception
}
if(!m.cover.coverage) m.cover.coverage = {}
m.cover.coverage.CoverageException = $hxClasses["m.cover.coverage.CoverageException"] = function(message,cause,info) {
	m.cover.Exception.call(this,message,cause,info);
	this.type = this.here({ fileName : "CoverageException.hx", lineNumber : 39, className : "m.cover.coverage.CoverageException", methodName : "new"}).className;
};
m.cover.coverage.CoverageException.__name__ = ["m","cover","coverage","CoverageException"];
m.cover.coverage.CoverageException.__super__ = m.cover.Exception;
m.cover.coverage.CoverageException.prototype = $extend(m.cover.Exception.prototype,{
	__class__: m.cover.coverage.CoverageException
});
m.cover.coverage.CoverageLogger = $hxClasses["m.cover.coverage.CoverageLogger"] = function() { }
m.cover.coverage.CoverageLogger.__name__ = ["m","cover","coverage","CoverageLogger"];
m.cover.coverage.CoverageLogger.prototype = {
	completionHandler: null
	,coverage: null
	,currentTest: null
	,report: null
	,reportCurrentTest: null
	,addClient: null
	,removeClient: null
	,getClients: null
	,initializeCoverage: null
	,logStatement: null
	,logBranch: null
	,__class__: m.cover.coverage.CoverageLogger
	,__properties__: {set_currentTest:"set_currentTest"}
}
m.cover.coverage.CoverageLoggerImpl = $hxClasses["m.cover.coverage.CoverageLoggerImpl"] = function() {
	this.allStatementResultsById = new IntHash();
	this.allBranchResultsById = new IntHash();
	this.clients = [];
};
m.cover.coverage.CoverageLoggerImpl.__name__ = ["m","cover","coverage","CoverageLoggerImpl"];
m.cover.coverage.CoverageLoggerImpl.__interfaces__ = [m.cover.coverage.CoverageLogger];
m.cover.coverage.CoverageLoggerImpl.prototype = {
	completionHandler: null
	,coverage: null
	,currentTest: null
	,allStatementResultsById: null
	,allBranchResultsById: null
	,testStatementResultsById: null
	,testBranchResultsById: null
	,clients: null
	,clientCompleteCount: null
	,report: function(skipClients) {
		if(skipClients == null) skipClients = false;
		this.generateReportResults(false);
		if(!skipClients) this.reportToClients();
	}
	,reportCurrentTest: function(skipClients) {
		if(skipClients == null) skipClients = false;
		if(this.currentTest == null) throw new m.cover.coverage.CoverageException("No test specified to report on.",null,{ fileName : "CoverageLogger.hx", lineNumber : 137, className : "m.cover.coverage.CoverageLoggerImpl", methodName : "reportCurrentTest"});
		this.generateReportResults(true);
		if(!skipClients) this.reportToClients();
	}
	,generateReportResults: function(currentTestOnly) {
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
	,addClient: function(client) {
		if(client == null) throw "Null Client";
		var _g = 0, _g1 = this.clients;
		while(_g < _g1.length) {
			var c = _g1[_g];
			++_g;
			if(c == client) return;
		}
		client.completionHandler = this.clientCompletionHandler.$bind(this);
		this.clients.push(client);
	}
	,removeClient: function(client) {
		client.completionHandler = null;
		this.clients.remove(client);
	}
	,getClients: function() {
		return this.clients.concat([]);
	}
	,initializeCoverage: function(resourceName) {
		if(resourceName == null) resourceName = m.cover.coverage.MCoverage.RESOURCE_DATA;
		var serializedData = haxe.Resource.getString(resourceName);
		if(serializedData == null) throw new m.cover.coverage.CoverageException("No generated coverage data found in haxe Resource '" + resourceName + "'",null,{ fileName : "CoverageLogger.hx", lineNumber : 196, className : "m.cover.coverage.CoverageLoggerImpl", methodName : "initializeCoverage"});
		try {
			this.coverage = haxe.Unserializer.run(serializedData);
		} catch( e ) {
			throw new m.cover.coverage.CoverageException("Unable to unserialize coverage data in " + resourceName,e,{ fileName : "CoverageLogger.hx", lineNumber : 203, className : "m.cover.coverage.CoverageLoggerImpl", methodName : "initializeCoverage"});
		}
	}
	,logStatement: function(id) {
		this.updateStatementHash(this.allStatementResultsById,id);
		if(this.currentTest != null) this.updateStatementHash(this.testStatementResultsById,id);
	}
	,updateStatementHash: function(hash,id) {
		var count = 1;
		if(hash.exists(id)) count = hash.get(id) + 1;
		hash.set(id,count);
	}
	,logBranch: function(id,value,compareValue) {
		var bool = false;
		if(compareValue != null) bool = value == compareValue; else bool = value;
		this.updateBranchHash(this.allBranchResultsById,id,bool);
		if(this.currentTest != null) this.updateBranchHash(this.testBranchResultsById,id,bool);
		return value;
	}
	,updateBranchHash: function(hash,id,value) {
		var r = null;
		if(hash.exists(id)) r = hash.get(id); else {
			r = { id : id, trueCount : 0, falseCount : 0, total : 0};
			hash.set(id,r);
		}
		if(value) r.trueCount++; else r.falseCount++;
		r.total++;
	}
	,set_currentTest: function(value) {
		this.currentTest = value;
		this.testStatementResultsById = new IntHash();
		this.testBranchResultsById = new IntHash();
		return value;
	}
	,reportToClients: function() {
		if(this.clients.length == 0) this.addClient(new m.cover.coverage.client.TraceClient());
		this.clientCompleteCount = 0;
		var _g = 0, _g1 = this.clients;
		while(_g < _g1.length) {
			var client = _g1[_g];
			++_g;
			client.report(this.coverage);
		}
	}
	,clientCompletionHandler: function(client) {
		this.clientCompleteCount++;
		if(this.clientCompleteCount == this.clients.length) {
			if(this.completionHandler != null) this.executeCompletionHandler();
		}
	}
	,executeCompletionHandler: function() {
		var percent = this.coverage.getPercentage();
		this.completionHandler(percent);
	}
	,__class__: m.cover.coverage.CoverageLoggerImpl
	,__properties__: {set_currentTest:"set_currentTest"}
}
m.cover.coverage.CoverageReportClient = $hxClasses["m.cover.coverage.CoverageReportClient"] = function() { }
m.cover.coverage.CoverageReportClient.__name__ = ["m","cover","coverage","CoverageReportClient"];
m.cover.coverage.CoverageReportClient.prototype = {
	completionHandler: null
	,report: null
	,output: null
	,__class__: m.cover.coverage.CoverageReportClient
}
m.cover.coverage.AdvancedCoverageReportClient = $hxClasses["m.cover.coverage.AdvancedCoverageReportClient"] = function() { }
m.cover.coverage.AdvancedCoverageReportClient.__name__ = ["m","cover","coverage","AdvancedCoverageReportClient"];
m.cover.coverage.AdvancedCoverageReportClient.__interfaces__ = [m.cover.coverage.CoverageReportClient];
m.cover.coverage.AdvancedCoverageReportClient.prototype = {
	includeMissingBlocks: null
	,includeExecutionFrequency: null
	,includeClassBreakdown: null
	,includePackageBreakdown: null
	,includeOverallPercentage: null
	,includeSummary: null
	,header: null
	,executionFrequency: null
	,missingBlocks: null
	,classBreakdown: null
	,packageBreakdown: null
	,summary: null
	,overallPercentage: null
	,__class__: m.cover.coverage.AdvancedCoverageReportClient
}
m.cover.coverage.MCoverage = $hxClasses["m.cover.coverage.MCoverage"] = function() {
};
m.cover.coverage.MCoverage.__name__ = ["m","cover","coverage","MCoverage"];
m.cover.coverage.MCoverage.logger = null;
m.cover.coverage.MCoverage.getLogger = function() {
	if(m.cover.coverage.MCoverage.logger == null) m.cover.coverage.MCoverage.logger = new m.cover.coverage.CoverageLoggerImpl();
	return m.cover.coverage.MCoverage.logger;
}
m.cover.coverage.MCoverage.prototype = {
	__class__: m.cover.coverage.MCoverage
}
if(!m.cover.coverage.client) m.cover.coverage.client = {}
m.cover.coverage.client.PrintClient = $hxClasses["m.cover.coverage.client.PrintClient"] = function() {
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
};
m.cover.coverage.client.PrintClient.__name__ = ["m","cover","coverage","client","PrintClient"];
m.cover.coverage.client.PrintClient.__interfaces__ = [m.cover.coverage.AdvancedCoverageReportClient];
m.cover.coverage.client.PrintClient.prototype = {
	completionHandler: null
	,includeHeader: null
	,includeMissingBlocks: null
	,includeExecutionFrequency: null
	,includeClassBreakdown: null
	,includePackageBreakdown: null
	,includeOverallPercentage: null
	,includeSummary: null
	,maxBlockExecutionListSize: null
	,newline: null
	,output: null
	,header: null
	,executionFrequency: null
	,missingBlocks: null
	,classBreakdown: null
	,packageBreakdown: null
	,summary: null
	,overallPercentage: null
	,divider: null
	,tab: null
	,packageTotal: null
	,packageCompletedCount: null
	,packagePartialCount: null
	,classTotal: null
	,classCompletedCount: null
	,classPartialCount: null
	,coverage: null
	,report: function(coverage) {
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
		var timer = m.cover.util.Timer.delay(this.reportComplete.$bind(this),10);
	}
	,reportComplete: function() {
		if(this.completionHandler != null) this.completionHandler(this);
	}
	,printReport: function() {
		this.header = this.serializeHeader();
		this.executionFrequency = this.serializeExecutionFrequency();
		this.missingBlocks = this.serializeMissingBlocks();
		this.classBreakdown = this.serializeClassResults();
		this.packageBreakdown = this.serializePackageResults();
		this.summary = this.serializeSummary();
		this.overallPercentage = this.serializeOverallPercentage();
		this.output = this.serializeFinalOutput();
	}
	,serializeFinalOutput: function() {
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
	,serializeHeader: function() {
		return "MCover Coverage Report, generated " + Date.now().toString();
	}
	,serializeOverallPercentage: function() {
		return this.printTabs(["COVERAGE RESULT",this.coverage.getPercentage() + "%"],20);
	}
	,serializeSummary: function() {
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
	,serializePackageResults: function() {
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
	,serializeClassResults: function() {
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
	,serializeMissingBlocks: function() {
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
	,serializeExecutionFrequency: function() {
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
	,printLine: function(value) {
		return this.newline + Std.string(value);
	}
	,printTabs: function(args,initialColumnWidth,columnWidth) {
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
	,__class__: m.cover.coverage.client.PrintClient
}
m.cover.coverage.client.TraceClient = $hxClasses["m.cover.coverage.client.TraceClient"] = function() {
	m.cover.coverage.client.PrintClient.call(this);
	this.newline = "<br/>";
	this.tab = "&nbsp;";
};
m.cover.coverage.client.TraceClient.__name__ = ["m","cover","coverage","client","TraceClient"];
m.cover.coverage.client.TraceClient.__super__ = m.cover.coverage.client.PrintClient;
m.cover.coverage.client.TraceClient.prototype = $extend(m.cover.coverage.client.PrintClient.prototype,{
	printReport: function() {
		m.cover.coverage.client.PrintClient.prototype.printReport.call(this);
		this.output += this.newline;
		haxe.Log.trace(this.newline + this.output,{ fileName : "TraceClient.hx", lineNumber : 45, className : "m.cover.coverage.client.TraceClient", methodName : "printReport"});
	}
	,__class__: m.cover.coverage.client.TraceClient
});
if(!m.cover.coverage.data) m.cover.coverage.data = {}
m.cover.coverage.data.AbstractNode = $hxClasses["m.cover.coverage.data.AbstractNode"] = function() {
};
m.cover.coverage.data.AbstractNode.__name__ = ["m","cover","coverage","data","AbstractNode"];
m.cover.coverage.data.AbstractNode.prototype = {
	id: null
	,name: null
	,resultCache: null
	,getResults: function(cache) {
		if(cache == null) cache = true;
		if(this.resultCache == null || !cache) this.resultCache = this.emptyResult();
		return this.resultCache;
	}
	,getPercentage: function() {
		var r = this.getResults();
		try {
			var p = Math.round((r.bt + r.bf + r.sc + r.mc) / (2 * r.b + r.s + r.m) * 10000) / 100;
			if(Math.isNaN(p)) throw "NaN";
			return p;
		} catch( e ) {
		}
		return 0;
	}
	,getClasses: function() {
		return [];
	}
	,lookupBranch: function(path) {
		return null;
	}
	,lookupStatement: function(path) {
		return null;
	}
	,getMissingBranches: function() {
		return [];
	}
	,getMissingStatements: function() {
		return [];
	}
	,emptyResult: function() {
		return { lc : 0, lp : 0, l : 0, sc : 0, s : 0, bt : 0, bf : 0, bc : 0, b : 0, mc : 0, m : 0, cc : 0, c : 0, fc : 0, f : 0, pc : 0, p : 0};
	}
	,hxSerialize: function(s) {
		s.serialize(this.id);
		s.serialize(this.name);
	}
	,hxUnserialize: function(s) {
		this.id = s.unserialize();
		this.name = s.unserialize();
	}
	,__class__: m.cover.coverage.data.AbstractNode
}
m.cover.coverage.data.AbstractBlock = $hxClasses["m.cover.coverage.data.AbstractBlock"] = function() {
	m.cover.coverage.data.AbstractNode.call(this);
	this.lines = [];
};
m.cover.coverage.data.AbstractBlock.__name__ = ["m","cover","coverage","data","AbstractBlock"];
m.cover.coverage.data.AbstractBlock.__super__ = m.cover.coverage.data.AbstractNode;
m.cover.coverage.data.AbstractBlock.prototype = $extend(m.cover.coverage.data.AbstractNode.prototype,{
	file: null
	,packageName: null
	,className: null
	,qualifiedClassName: null
	,methodName: null
	,min: null
	,max: null
	,location: null
	,lines: null
	,lookup: null
	,isCovered: function() {
		return false;
	}
	,toString: function() {
		return this.qualifiedClassName + "#" + this.toLocalString();
	}
	,toLocalString: function() {
		return this.methodName + " | " + this.location;
	}
	,hxSerialize: function(s) {
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
	,hxUnserialize: function(s) {
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
	,__class__: m.cover.coverage.data.AbstractBlock
});
m.cover.coverage.data.AbstractNodeList = $hxClasses["m.cover.coverage.data.AbstractNodeList"] = function() {
	m.cover.coverage.data.AbstractNode.call(this);
	this.itemCount = 0;
	this.itemsById = new IntHash();
	this.items = new Hash();
};
m.cover.coverage.data.AbstractNodeList.__name__ = ["m","cover","coverage","data","AbstractNodeList"];
m.cover.coverage.data.AbstractNodeList.__super__ = m.cover.coverage.data.AbstractNode;
m.cover.coverage.data.AbstractNodeList.prototype = $extend(m.cover.coverage.data.AbstractNode.prototype,{
	itemsById: null
	,items: null
	,itemCount: null
	,getItemByName: function(name,cls) {
		if(!this.items.exists(name)) {
			var item = Type.createInstance(cls,[]);
			item.id = this.itemCount++;
			item.name = name;
			this.items.set(name,item.id);
			this.itemsById.set(item.id,item);
		}
		return this.itemsById.get(this.items.get(name));
	}
	,lookupBranch: function(path) {
		var itemId = path.shift();
		if(itemId == null || !this.itemsById.exists(itemId)) return null;
		return this.itemsById.get(itemId).lookupBranch(path);
	}
	,lookupStatement: function(path) {
		var itemId = path.shift();
		if(itemId == null || !this.itemsById.exists(itemId)) return null;
		return this.itemsById.get(itemId).lookupStatement(path);
	}
	,getMissingBranches: function() {
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
	,getMissingStatements: function() {
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
	,getClasses: function() {
		var a = [];
		var $it0 = this.itemsById.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			var tmp = node.getClasses();
			a = a.concat(tmp);
		}
		return a;
	}
	,getResults: function(cache) {
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
	,appendResults: function(to,from) {
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
	,hxSerialize: function(s) {
		m.cover.coverage.data.AbstractNode.prototype.hxSerialize.call(this,s);
		s.serialize(this.itemsById);
		s.serialize(this.items);
		s.serialize(this.itemCount);
	}
	,hxUnserialize: function(s) {
		m.cover.coverage.data.AbstractNode.prototype.hxUnserialize.call(this,s);
		this.itemsById = s.unserialize();
		this.items = s.unserialize();
		this.itemCount = s.unserialize();
	}
	,__class__: m.cover.coverage.data.AbstractNodeList
});
m.cover.coverage.data.Branch = $hxClasses["m.cover.coverage.data.Branch"] = function() {
	m.cover.coverage.data.AbstractBlock.call(this);
	this.trueCount = 0;
	this.falseCount = 0;
};
m.cover.coverage.data.Branch.__name__ = ["m","cover","coverage","data","Branch"];
m.cover.coverage.data.Branch.__super__ = m.cover.coverage.data.AbstractBlock;
m.cover.coverage.data.Branch.prototype = $extend(m.cover.coverage.data.AbstractBlock.prototype,{
	trueCount: null
	,falseCount: null
	,totalCount: null
	,get_totalCount: function() {
		return this.trueCount + this.falseCount;
	}
	,isCovered: function() {
		return this.trueCount > 0 && this.falseCount > 0;
	}
	,isPartiallyCovered: function() {
		return !this.isCovered() && (this.trueCount > 0 || this.falseCount > 0);
	}
	,toLocalString: function() {
		var s = m.cover.coverage.data.AbstractBlock.prototype.toLocalString.call(this);
		if(!this.isCovered()) {
			s += " | ";
			if(this.trueCount == 0) s += "t";
			if(this.trueCount == 0 && this.falseCount == 0) s += ",";
			if(this.falseCount == 0) s += "f";
		}
		return s;
	}
	,hxSerialize: function(s) {
		m.cover.coverage.data.AbstractBlock.prototype.hxSerialize.call(this,s);
		s.serialize(this.trueCount);
		s.serialize(this.falseCount);
	}
	,hxUnserialize: function(s) {
		m.cover.coverage.data.AbstractBlock.prototype.hxUnserialize.call(this,s);
		this.trueCount = s.unserialize();
		this.falseCount = s.unserialize();
	}
	,__class__: m.cover.coverage.data.Branch
	,__properties__: {get_totalCount:"get_totalCount"}
});
m.cover.coverage.data.Clazz = $hxClasses["m.cover.coverage.data.Clazz"] = function() {
	m.cover.coverage.data.AbstractNodeList.call(this);
};
m.cover.coverage.data.Clazz.__name__ = ["m","cover","coverage","data","Clazz"];
m.cover.coverage.data.Clazz.__super__ = m.cover.coverage.data.AbstractNodeList;
m.cover.coverage.data.Clazz.prototype = $extend(m.cover.coverage.data.AbstractNodeList.prototype,{
	getMethods: function() {
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
	,appendResults: function(to,from) {
		to = m.cover.coverage.data.AbstractNodeList.prototype.appendResults.call(this,to,from);
		to.mc += from.sc > 0?1:0;
		to.m += 1;
		return to;
	}
	,__class__: m.cover.coverage.data.Clazz
});
m.cover.coverage.data.Coverage = $hxClasses["m.cover.coverage.data.Coverage"] = function() {
	m.cover.coverage.data.AbstractNodeList.call(this);
	this.statements = new IntHash();
	this.branches = new IntHash();
	this.statementResultsById = new IntHash();
	this.branchResultsById = new IntHash();
};
m.cover.coverage.data.Coverage.__name__ = ["m","cover","coverage","data","Coverage"];
m.cover.coverage.data.Coverage.__super__ = m.cover.coverage.data.AbstractNodeList;
m.cover.coverage.data.Coverage.prototype = $extend(m.cover.coverage.data.AbstractNodeList.prototype,{
	statements: null
	,branches: null
	,statementResultsById: null
	,branchResultsById: null
	,setStatementResultsHash: function(hash) {
		this.statementResultsById = hash;
	}
	,setBranchResultsHash: function(hash) {
		this.branchResultsById = hash;
	}
	,addStatement: function(block) {
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
	,addBranch: function(block) {
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
	,verifyBlockData: function(block) {
		if(block.id == null) throw new m.cover.Exception("id cannot be null",null,{ fileName : "Coverage.hx", lineNumber : 103, className : "m.cover.coverage.data.Coverage", methodName : "verifyBlockData"});
		if(block.packageName == null) throw new m.cover.Exception("packageName cannot be null",null,{ fileName : "Coverage.hx", lineNumber : 104, className : "m.cover.coverage.data.Coverage", methodName : "verifyBlockData"});
		if(block.file == null) throw new m.cover.Exception("file cannot be null",null,{ fileName : "Coverage.hx", lineNumber : 105, className : "m.cover.coverage.data.Coverage", methodName : "verifyBlockData"});
		if(block.qualifiedClassName == null) throw new m.cover.Exception("qualifiedClassName cannot be null",null,{ fileName : "Coverage.hx", lineNumber : 106, className : "m.cover.coverage.data.Coverage", methodName : "verifyBlockData"});
		if(block.methodName == null) throw new m.cover.Exception("methodName cannot be null",null,{ fileName : "Coverage.hx", lineNumber : 107, className : "m.cover.coverage.data.Coverage", methodName : "verifyBlockData"});
	}
	,getBranchById: function(id) {
		if(!this.branches.exists(id)) throw new m.cover.Exception("Branch does not exist: " + id,null,{ fileName : "Coverage.hx", lineNumber : 112, className : "m.cover.coverage.data.Coverage", methodName : "getBranchById"});
		var lookup = this.branches.get(id).concat([]);
		return this.lookupBranch(lookup);
	}
	,getStatementById: function(id) {
		if(!this.statements.exists(id)) throw new m.cover.Exception("Statement does not exist: " + id,null,{ fileName : "Coverage.hx", lineNumber : 121, className : "m.cover.coverage.data.Coverage", methodName : "getStatementById"});
		var lookup = this.statements.get(id).concat([]);
		return this.lookupStatement(lookup);
	}
	,getMissingBranches: function() {
		var a = m.cover.coverage.data.AbstractNodeList.prototype.getMissingBranches.call(this);
		a.sort(m.cover.coverage.data.DataUtil.sortOnBlockName);
		return a;
	}
	,getMissingStatements: function() {
		var a = m.cover.coverage.data.AbstractNodeList.prototype.getMissingStatements.call(this);
		a.sort(m.cover.coverage.data.DataUtil.sortOnBlockName);
		return a;
	}
	,getClasses: function() {
		var a = m.cover.coverage.data.AbstractNodeList.prototype.getClasses.call(this);
		a.sort(m.cover.coverage.data.DataUtil.sortOnNodeName);
		return a;
	}
	,getClassByName: function(name) {
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
	,getPackages: function() {
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
	,getResults: function(cache) {
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
	,appendResults: function(to,from) {
		to = m.cover.coverage.data.AbstractNodeList.prototype.appendResults.call(this,to,from);
		to.pc += from.sc > 0?1:0;
		to.p += 1;
		return to;
	}
	,hxSerialize: function(s) {
		m.cover.coverage.data.AbstractNodeList.prototype.hxSerialize.call(this,s);
		s.serialize(this.statements);
		s.serialize(this.branches);
		s.serialize(this.statementResultsById);
		s.serialize(this.branchResultsById);
	}
	,hxUnserialize: function(s) {
		m.cover.coverage.data.AbstractNodeList.prototype.hxUnserialize.call(this,s);
		this.statements = s.unserialize();
		this.branches = s.unserialize();
		this.statementResultsById = s.unserialize();
		this.branchResultsById = s.unserialize();
	}
	,__class__: m.cover.coverage.data.Coverage
});
m.cover.coverage.data.DataUtil = $hxClasses["m.cover.coverage.data.DataUtil"] = function() {
};
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
m.cover.coverage.data.DataUtil.prototype = {
	__class__: m.cover.coverage.data.DataUtil
}
m.cover.coverage.data.File = $hxClasses["m.cover.coverage.data.File"] = function() {
	m.cover.coverage.data.AbstractNodeList.call(this);
};
m.cover.coverage.data.File.__name__ = ["m","cover","coverage","data","File"];
m.cover.coverage.data.File.__super__ = m.cover.coverage.data.AbstractNodeList;
m.cover.coverage.data.File.prototype = $extend(m.cover.coverage.data.AbstractNodeList.prototype,{
	getClasses: function() {
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
	,appendResults: function(to,from) {
		to = m.cover.coverage.data.AbstractNodeList.prototype.appendResults.call(this,to,from);
		to.cc += from.sc > 0?1:0;
		to.c += 1;
		return to;
	}
	,__class__: m.cover.coverage.data.File
});
m.cover.coverage.data.Method = $hxClasses["m.cover.coverage.data.Method"] = function() {
	m.cover.coverage.data.AbstractNode.call(this);
	this.statementsById = new IntHash();
	this.branchesById = new IntHash();
};
m.cover.coverage.data.Method.__name__ = ["m","cover","coverage","data","Method"];
m.cover.coverage.data.Method.__super__ = m.cover.coverage.data.AbstractNode;
m.cover.coverage.data.Method.prototype = $extend(m.cover.coverage.data.AbstractNode.prototype,{
	statementsById: null
	,branchesById: null
	,addStatement: function(value) {
		this.statementsById.set(value.id,value);
	}
	,addBranch: function(value) {
		this.branchesById.set(value.id,value);
	}
	,getStatementById: function(id) {
		if(this.statementsById.exists(id)) return this.statementsById.get(id);
		return null;
	}
	,getBranchById: function(id) {
		if(this.branchesById.exists(id)) return this.branchesById.get(id);
		return null;
	}
	,lookupBranch: function(path) {
		var itemId = path.shift();
		if(itemId == null || !this.branchesById.exists(itemId)) return null;
		return this.branchesById.get(itemId);
	}
	,lookupStatement: function(path) {
		var itemId = path.shift();
		if(itemId == null || !this.statementsById.exists(itemId)) return null;
		return this.statementsById.get(itemId);
	}
	,getMissingBranches: function() {
		var a = [];
		var $it0 = this.branchesById.iterator();
		while( $it0.hasNext() ) {
			var branch = $it0.next();
			if(!branch.isCovered()) a.push(branch);
		}
		return a;
	}
	,getMissingStatements: function() {
		var a = [];
		var $it0 = this.statementsById.iterator();
		while( $it0.hasNext() ) {
			var statement = $it0.next();
			if(!statement.isCovered()) a.push(statement);
		}
		return a;
	}
	,getResults: function(cache) {
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
	,hxSerialize: function(s) {
		m.cover.coverage.data.AbstractNode.prototype.hxSerialize.call(this,s);
		s.serialize(this.statementsById);
		s.serialize(this.branchesById);
	}
	,hxUnserialize: function(s) {
		m.cover.coverage.data.AbstractNode.prototype.hxUnserialize.call(this,s);
		this.statementsById = s.unserialize();
		this.branchesById = s.unserialize();
	}
	,__class__: m.cover.coverage.data.Method
});
m.cover.coverage.data.Package = $hxClasses["m.cover.coverage.data.Package"] = function() {
	m.cover.coverage.data.AbstractNodeList.call(this);
};
m.cover.coverage.data.Package.__name__ = ["m","cover","coverage","data","Package"];
m.cover.coverage.data.Package.__super__ = m.cover.coverage.data.AbstractNodeList;
m.cover.coverage.data.Package.prototype = $extend(m.cover.coverage.data.AbstractNodeList.prototype,{
	getFiles: function() {
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
	,appendResults: function(to,from) {
		to = m.cover.coverage.data.AbstractNodeList.prototype.appendResults.call(this,to,from);
		to.fc += from.sc > 0?1:0;
		to.f += 1;
		return to;
	}
	,__class__: m.cover.coverage.data.Package
});
m.cover.coverage.data.Statement = $hxClasses["m.cover.coverage.data.Statement"] = function() {
	m.cover.coverage.data.AbstractBlock.call(this);
	this.count = 0;
};
m.cover.coverage.data.Statement.__name__ = ["m","cover","coverage","data","Statement"];
m.cover.coverage.data.Statement.__super__ = m.cover.coverage.data.AbstractBlock;
m.cover.coverage.data.Statement.prototype = $extend(m.cover.coverage.data.AbstractBlock.prototype,{
	count: null
	,isCovered: function() {
		return this.count > 0;
	}
	,hxSerialize: function(s) {
		m.cover.coverage.data.AbstractBlock.prototype.hxSerialize.call(this,s);
		s.serialize(this.count);
	}
	,hxUnserialize: function(s) {
		m.cover.coverage.data.AbstractBlock.prototype.hxUnserialize.call(this,s);
		this.count = s.unserialize();
	}
	,__class__: m.cover.coverage.data.Statement
});
massive.munit.ITestResultClient = $hxClasses["massive.munit.ITestResultClient"] = function() { }
massive.munit.ITestResultClient.__name__ = ["massive","munit","ITestResultClient"];
massive.munit.ITestResultClient.prototype = {
	completionHandler: null
	,id: null
	,addPass: null
	,addFail: null
	,addError: null
	,addIgnore: null
	,reportFinalStatistics: null
	,__class__: massive.munit.ITestResultClient
	,__properties__: {set_completionHandler:"set_completeHandler",get_completionHandler:"get_completeHandler"}
}
massive.munit.IAdvancedTestResultClient = $hxClasses["massive.munit.IAdvancedTestResultClient"] = function() { }
massive.munit.IAdvancedTestResultClient.__name__ = ["massive","munit","IAdvancedTestResultClient"];
massive.munit.IAdvancedTestResultClient.__interfaces__ = [massive.munit.ITestResultClient];
massive.munit.IAdvancedTestResultClient.prototype = {
	setCurrentTestClass: null
	,__class__: massive.munit.IAdvancedTestResultClient
}
if(!m.cover.coverage.munit) m.cover.coverage.munit = {}
if(!m.cover.coverage.munit.client) m.cover.coverage.munit.client = {}
m.cover.coverage.munit.client.MCoverPrintClient = $hxClasses["m.cover.coverage.munit.client.MCoverPrintClient"] = function(munitClient,mcoverClient,mcoverLogger) {
	this.id = "MCoverPrintClient";
	if(munitClient == null) munitClient = new massive.munit.client.RichPrintClient();
	this.client = munitClient;
	if(mcoverClient == null) mcoverClient = new m.cover.coverage.client.PrintClient();
	this.mcoverClient = mcoverClient;
	if(mcoverLogger == null) mcoverLogger = this.initializeMCoverLogger();
	this.mcoverLogger = mcoverLogger;
	this.init();
};
m.cover.coverage.munit.client.MCoverPrintClient.__name__ = ["m","cover","coverage","munit","client","MCoverPrintClient"];
m.cover.coverage.munit.client.MCoverPrintClient.__interfaces__ = [massive.munit.IAdvancedTestResultClient];
m.cover.coverage.munit.client.MCoverPrintClient.prototype = {
	id: null
	,completionHandler: null
	,get_completeHandler: function() {
		return this.completionHandler;
	}
	,set_completeHandler: function(value) {
		return this.completionHandler = value;
	}
	,includeMissingBlocks: null
	,includeExecutionFrequency: null
	,includeClassAndPackageBreakdowns: null
	,client: null
	,mcoverLogger: null
	,mcoverClient: null
	,coveredClasses: null
	,currentCoveredClass: null
	,classPercentage: null
	,addPass: function(result) {
		this.client.addPass(result);
	}
	,addFail: function(result) {
		this.client.addFail(result);
	}
	,addError: function(result) {
		this.client.addError(result);
	}
	,addIgnore: function(result) {
		this.client.addIgnore(result);
	}
	,initializeMCoverLogger: function() {
		try {
			return m.cover.coverage.MCoverage.getLogger();
		} catch( e ) {
			var msg = "ERROR: Unable to initialize MCover Logger\n" + e;
			haxe.Log.trace(msg,{ fileName : "MCoverPrintClient.hx", lineNumber : 155, className : "m.cover.coverage.munit.client.MCoverPrintClient", methodName : "initializeMCoverLogger"});
		}
		return null;
	}
	,init: function() {
		this.includeMissingBlocks = true;
		this.includeExecutionFrequency = true;
		this.includeClassAndPackageBreakdowns = true;
		this.currentCoveredClass = null;
		this.classPercentage = 0;
		this.coveredClasses = new Hash();
		this.mcoverClient.includeMissingBlocks = true;
		this.mcoverClient.includeExecutionFrequency = true;
		this.mcoverLogger.addClient(this.mcoverClient);
	}
	,setCurrentTestClass: function(className) {
		var hasMatch = className != null && className.lastIndexOf("Test") == className.length - 4;
		var coveredClassName = hasMatch?className.substr(0,className.length - 4):null;
		var hasChanged = this.currentCoveredClass != coveredClassName;
		if(hasChanged && this.currentCoveredClass != null) {
			if(this.mcoverLogger.currentTest != null) this.updateTestClassCoverage();
		}
		this.client.setCurrentTestClass(className);
		if(hasChanged) {
			this.currentCoveredClass = coveredClassName;
			this.mcoverLogger.set_currentTest(this.currentCoveredClass);
		}
	}
	,reportFinalStatistics: function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
		this.updateFinalCoverageReport();
		var result = this.client.reportFinalStatistics(testCount,passCount,failCount,errorCount,ignoreCount,time);
		if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
		return result;
	}
	,updateTestClassCoverage: function() {
		this.mcoverLogger.reportCurrentTest(true);
		var cls = this.mcoverLogger.coverage.getClassByName(this.currentCoveredClass);
		if(cls == null) return;
		this.coveredClasses.set(cls.name,cls);
		this.classPercentage = cls.getPercentage();
		var coverageResult = this.createCoverageResultForClass(cls);
		this.client.setCurrentTestClassCoverage(coverageResult);
	}
	,updateFinalCoverageReport: function() {
		this.mcoverLogger.report(false);
		var percent = this.mcoverLogger.coverage.getPercentage();
		var coverageResults = null;
		var executionFrequencies = null;
		var classBreakdown = null;
		var packageBreakdown = null;
		if(this.includeMissingBlocks) coverageResults = this.createOutstandingCoverageResults();
		if(this.includeClassAndPackageBreakdowns) {
			classBreakdown = this.mcoverClient.classBreakdown;
			packageBreakdown = this.mcoverClient.packageBreakdown;
		}
		if(this.includeExecutionFrequency) executionFrequencies = this.mcoverClient.executionFrequency;
		var summary = this.mcoverClient.summary + "\n" + this.mcoverClient.overallPercentage;
		this.client.reportFinalCoverage(percent,coverageResults,summary,classBreakdown,packageBreakdown,executionFrequencies);
	}
	,createOutstandingCoverageResults: function() {
		var classes = this.mcoverLogger.coverage.getClasses();
		var results = [];
		var _g = 0;
		while(_g < classes.length) {
			var cls = classes[_g];
			++_g;
			if(cls.getPercentage() == 100) continue;
			var result = this.createCoverageResultForClass(cls);
			results.push(result);
		}
		return results;
	}
	,createCoverageResultForClass: function(cls) {
		var percent = cls.getPercentage();
		var blocks = [];
		if(percent != 100 && this.includeMissingBlocks) {
			var str = "";
			var statements = cls.getMissingStatements();
			if(statements.length > 0) {
				var _g = 0;
				while(_g < statements.length) {
					var block = statements[_g];
					++_g;
					var blockString = block.methodName + " (" + block.location + ")";
					if(str != "") str += "\n";
					str += blockString;
				}
				blocks.push(str);
			}
			var branches = cls.getMissingBranches();
			if(branches.length > 0) {
				str = "";
				var _g = 0;
				while(_g < branches.length) {
					var block = branches[_g];
					++_g;
					var blockString = block.methodName + " (" + block.location + ")";
					if(!block.isCovered()) {
						blockString += " ";
						if(block.trueCount == 0) blockString += "t";
						if(block.trueCount == 0 && block.falseCount == 0) blockString += ",";
						if(block.falseCount == 0) blockString += "f";
					}
					if(str != "") str += "\n";
					str += blockString;
				}
				blocks.push(str);
			}
		}
		return { className : cls.name, percent : percent, blocks : blocks};
	}
	,__class__: m.cover.coverage.munit.client.MCoverPrintClient
	,__properties__: {set_completionHandler:"set_completeHandler",get_completionHandler:"get_completeHandler"}
}
massive.munit.ICoverageTestResultClient = $hxClasses["massive.munit.ICoverageTestResultClient"] = function() { }
massive.munit.ICoverageTestResultClient.__name__ = ["massive","munit","ICoverageTestResultClient"];
massive.munit.ICoverageTestResultClient.__interfaces__ = [massive.munit.IAdvancedTestResultClient];
massive.munit.ICoverageTestResultClient.prototype = {
	setCurrentTestClassCoverage: null
	,reportFinalCoverage: null
	,__class__: massive.munit.ICoverageTestResultClient
}
if(!massive.munit.client) massive.munit.client = {}
massive.munit.client.AbstractTestResultClient = $hxClasses["massive.munit.client.AbstractTestResultClient"] = function() {
	this.init();
};
massive.munit.client.AbstractTestResultClient.__name__ = ["massive","munit","client","AbstractTestResultClient"];
massive.munit.client.AbstractTestResultClient.__interfaces__ = [massive.munit.ICoverageTestResultClient,massive.munit.IAdvancedTestResultClient];
massive.munit.client.AbstractTestResultClient.prototype = {
	id: null
	,completionHandler: null
	,get_completeHandler: function() {
		return this.completionHandler;
	}
	,set_completeHandler: function(value) {
		return this.completionHandler = value;
	}
	,output: null
	,get_output: function() {
		return this.output;
	}
	,passCount: null
	,failCount: null
	,errorCount: null
	,ignoreCount: null
	,currentTestClass: null
	,currentClassResults: null
	,currentCoverageResult: null
	,traces: null
	,totalResults: null
	,totalCoveragePercent: null
	,totalCoverageReport: null
	,totalCoverageResults: null
	,originalTrace: null
	,finalResult: null
	,init: function() {
		this.originalTrace = haxe.Log.trace;
		haxe.Log.trace = this.customTrace.$bind(this);
		this.currentTestClass = null;
		this.currentClassResults = [];
		this.traces = [];
		this.passCount = 0;
		this.failCount = 0;
		this.errorCount = 0;
		this.ignoreCount = 0;
		this.currentCoverageResult = null;
		this.totalResults = [];
		this.totalCoveragePercent = 0;
		this.totalCoverageReport = null;
		this.totalCoverageResults = null;
	}
	,setCurrentTestClass: function(className) {
		if(this.currentTestClass == className) return;
		if(this.currentTestClass != null) this.finalizeTestClass();
		this.currentTestClass = className;
		if(this.currentTestClass != null) this.initializeTestClass();
	}
	,addPass: function(result) {
		this.passCount++;
		this.updateTestClass(result);
	}
	,addFail: function(result) {
		this.failCount++;
		this.updateTestClass(result);
	}
	,addError: function(result) {
		this.errorCount++;
		this.updateTestClass(result);
	}
	,addIgnore: function(result) {
		this.ignoreCount++;
		this.updateTestClass(result);
	}
	,setCurrentTestClassCoverage: function(result) {
		this.currentCoverageResult = result;
	}
	,reportFinalCoverage: function(percent,missingCoverageResults,summary,classBreakdown,packageBreakdown,executionFrequency) {
		if(percent == null) percent = 0;
		this.totalCoveragePercent = percent;
		this.totalCoverageResults = missingCoverageResults;
		this.totalCoverageReport = summary;
	}
	,reportFinalStatistics: function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
		this.finalResult = passCount == testCount;
		this.printReports();
		this.printFinalStatistics(this.finalResult,testCount,passCount,failCount,errorCount,ignoreCount,time);
		this.printOverallResult(this.finalResult);
		haxe.Log.trace = this.originalTrace;
		if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
		return this.get_output();
	}
	,initializeTestClass: function() {
		this.currentClassResults = [];
		this.traces = [];
		this.passCount = 0;
		this.failCount = 0;
		this.errorCount = 0;
		this.ignoreCount = 0;
	}
	,updateTestClass: function(result) {
		this.currentClassResults.push(result);
		this.totalResults.push(result);
	}
	,finalizeTestClass: function() {
		this.currentClassResults.sort(this.sortTestResults.$bind(this));
	}
	,printReports: function() {
	}
	,printFinalStatistics: function(result,testCount,passCount,failCount,errorCount,ignoreCount,time) {
	}
	,printOverallResult: function(result) {
	}
	,customTrace: function(value,info) {
		var traceString = info.fileName + "|" + info.lineNumber + "| " + Std.string(value);
		this.traces.push(traceString);
	}
	,sortTestResults: function(a,b) {
		var aInt = (function($this) {
			var $r;
			switch( (a.get_type())[1] ) {
			case 3:
				$r = 2;
				break;
			case 2:
				$r = 1;
				break;
			case 4:
				$r = 0;
				break;
			case 1:
				$r = -1;
				break;
			default:
				$r = -2;
			}
			return $r;
		}(this));
		var bInt = (function($this) {
			var $r;
			switch( (b.get_type())[1] ) {
			case 3:
				$r = 2;
				break;
			case 2:
				$r = 1;
				break;
			case 4:
				$r = 0;
				break;
			case 1:
				$r = -1;
				break;
			default:
				$r = -2;
			}
			return $r;
		}(this));
		return aInt - bInt;
	}
	,__class__: massive.munit.client.AbstractTestResultClient
	,__properties__: {get_output:"get_output",set_completionHandler:"set_completeHandler",get_completionHandler:"get_completeHandler"}
}
massive.munit.client.SummaryReportClient = $hxClasses["massive.munit.client.SummaryReportClient"] = function() {
	massive.munit.client.AbstractTestResultClient.call(this);
	this.id = massive.munit.client.SummaryReportClient.DEFAULT_ID;
};
massive.munit.client.SummaryReportClient.__name__ = ["massive","munit","client","SummaryReportClient"];
massive.munit.client.SummaryReportClient.__super__ = massive.munit.client.AbstractTestResultClient;
massive.munit.client.SummaryReportClient.prototype = $extend(massive.munit.client.AbstractTestResultClient.prototype,{
	printFinalStatistics: function(result,testCount,passCount,failCount,errorCount,ignoreCount,time) {
		this.output = "";
		this.output += "result:" + result;
		this.output += "\ncount:" + testCount;
		this.output += "\npass:" + passCount;
		this.output += "\nfail:" + failCount;
		this.output += "\nerror:" + errorCount;
		this.output += "\nignore:" + ignoreCount;
		this.output += "\ntime:" + time;
		this.output += "\n";
		var resultCount = 0;
		while(this.totalResults.length > 0 && resultCount < 10) {
			var result1 = this.totalResults.shift();
			if(!result1.passed) {
				this.output += "\n# " + result1.get_location();
				resultCount++;
			}
		}
		var remainder = failCount + errorCount - resultCount;
		if(remainder > 0) this.output += "# ... plus " + remainder + " more";
	}
	,printOverallResult: function(result) {
	}
	,printReports: function() {
	}
	,__class__: massive.munit.client.SummaryReportClient
});
m.cover.coverage.munit.client.MCoverSummaryReportClient = $hxClasses["m.cover.coverage.munit.client.MCoverSummaryReportClient"] = function() {
	massive.munit.client.SummaryReportClient.call(this);
	this.initializeLogger();
};
m.cover.coverage.munit.client.MCoverSummaryReportClient.__name__ = ["m","cover","coverage","munit","client","MCoverSummaryReportClient"];
m.cover.coverage.munit.client.MCoverSummaryReportClient.__super__ = massive.munit.client.SummaryReportClient;
m.cover.coverage.munit.client.MCoverSummaryReportClient.prototype = $extend(massive.munit.client.SummaryReportClient.prototype,{
	mcoverLogger: null
	,coverage: null
	,initializeLogger: function() {
		try {
			this.mcoverLogger = m.cover.coverage.MCoverage.getLogger();
		} catch( e ) {
			var msg = "ERROR: Unable to initialize MCover Logger\n" + e;
			haxe.Log.trace(msg,{ fileName : "MCoverSummaryReportClient.hx", lineNumber : 76, className : "m.cover.coverage.munit.client.MCoverSummaryReportClient", methodName : "initializeLogger"});
		}
		return null;
	}
	,printFinalStatistics: function(result,testCount,passCount,failCount,errorCount,ignoreCount,time) {
		massive.munit.client.SummaryReportClient.prototype.printFinalStatistics.call(this,result,testCount,passCount,failCount,errorCount,ignoreCount,time);
		this.mcoverLogger.report(false);
		this.coverage = this.mcoverLogger.coverage;
		this.output += "\n#coverage:percent,count/total";
		this.output += "\ncoverage:" + this.coverage.getPercentage() + "%";
		var r = this.coverage.getResults();
		this.output += "\n" + this.appendResult("packages",r.pc,r.p);
		this.output += "\n" + this.appendResult("files",r.fc,r.f);
		this.output += "\n" + this.appendResult("classes",r.cc,r.c);
		this.output += "\n" + this.appendResult("methods",r.mc,r.m);
		this.output += "\n" + this.appendResult("statements",r.sc,r.s);
		this.output += "\n" + this.appendResult("branches",r.bc,r.b);
		this.output += "\n" + this.appendResult("lines",r.lc,r.l);
		this.output += "\n";
	}
	,appendResult: function(name,count,total) {
		var percent = m.cover.util.NumberUtil.round(count / total * 100,2);
		return name + ":" + percent + "%," + count + "/" + total;
	}
	,__class__: m.cover.coverage.munit.client.MCoverSummaryReportClient
});
if(!m.cover.util) m.cover.util = {}
m.cover.util.NumberUtil = $hxClasses["m.cover.util.NumberUtil"] = function() { }
m.cover.util.NumberUtil.__name__ = ["m","cover","util","NumberUtil"];
m.cover.util.NumberUtil.round = function(value,precision) {
	if(precision == null) precision = 4;
	value = value * Math.pow(10,precision);
	return Math.round(value) / Math.pow(10,precision);
}
m.cover.util.NumberUtil.prototype = {
	__class__: m.cover.util.NumberUtil
}
m.cover.util.Timer = $hxClasses["m.cover.util.Timer"] = function(time_ms) {
	this.run = this.defaultRun.$bind(this);
	this.id = m.cover.util.Timer.arr.length;
	m.cover.util.Timer.arr[this.id] = this;
	this.timerId = window.setInterval("m.cover.util.Timer.arr[" + this.id + "].run();",time_ms);
};
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
m.cover.util.Timer.prototype = {
	run: null
	,id: null
	,timerId: null
	,defaultRun: function() {
	}
	,stop: function() {
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
	,__class__: m.cover.util.Timer
}
if(!massive.haxe) massive.haxe = {}
massive.haxe.Exception = $hxClasses["massive.haxe.Exception"] = function(message,info) {
	this.message = message;
	this.info = info;
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "Exception.hx", lineNumber : 70, className : "massive.haxe.Exception", methodName : "new"}).className;
};
massive.haxe.Exception.__name__ = ["massive","haxe","Exception"];
massive.haxe.Exception.prototype = {
	type: null
	,message: null
	,info: null
	,toString: function() {
		var str = this.type + ": " + this.message;
		if(this.info != null) str += " at " + this.info.className + "#" + this.info.methodName + " (" + this.info.lineNumber + ")";
		return str;
	}
	,__class__: massive.haxe.Exception
}
if(!massive.haxe.util) massive.haxe.util = {}
massive.haxe.util.ReflectUtil = $hxClasses["massive.haxe.util.ReflectUtil"] = function() { }
massive.haxe.util.ReflectUtil.__name__ = ["massive","haxe","util","ReflectUtil"];
massive.haxe.util.ReflectUtil.here = function(info) {
	return info;
}
massive.haxe.util.ReflectUtil.prototype = {
	__class__: massive.haxe.util.ReflectUtil
}
massive.munit.Assert = $hxClasses["massive.munit.Assert"] = function() { }
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
massive.munit.Assert.prototype = {
	__class__: massive.munit.Assert
}
massive.munit.MUnitException = $hxClasses["massive.munit.MUnitException"] = function(message,info) {
	massive.haxe.Exception.call(this,message,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "MUnitException.hx", lineNumber : 50, className : "massive.munit.MUnitException", methodName : "new"}).className;
};
massive.munit.MUnitException.__name__ = ["massive","munit","MUnitException"];
massive.munit.MUnitException.__super__ = massive.haxe.Exception;
massive.munit.MUnitException.prototype = $extend(massive.haxe.Exception.prototype,{
	__class__: massive.munit.MUnitException
});
massive.munit.AssertionException = $hxClasses["massive.munit.AssertionException"] = function(msg,info) {
	massive.munit.MUnitException.call(this,msg,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "AssertionException.hx", lineNumber : 49, className : "massive.munit.AssertionException", methodName : "new"}).className;
};
massive.munit.AssertionException.__name__ = ["massive","munit","AssertionException"];
massive.munit.AssertionException.__super__ = massive.munit.MUnitException;
massive.munit.AssertionException.prototype = $extend(massive.munit.MUnitException.prototype,{
	__class__: massive.munit.AssertionException
});
massive.munit.TestClassHelper = $hxClasses["massive.munit.TestClassHelper"] = function(type,isDebug) {
	if(isDebug == null) isDebug = false;
	this.type = type;
	this.isDebug = isDebug;
	this.tests = [];
	this.index = 0;
	this.className = Type.getClassName(type);
	this.beforeClass = this.nullFunc.$bind(this);
	this.afterClass = this.nullFunc.$bind(this);
	this.before = this.nullFunc.$bind(this);
	this.after = this.nullFunc.$bind(this);
	this.parse(type);
};
massive.munit.TestClassHelper.__name__ = ["massive","munit","TestClassHelper"];
massive.munit.TestClassHelper.prototype = {
	type: null
	,test: null
	,beforeClass: null
	,afterClass: null
	,before: null
	,after: null
	,tests: null
	,index: null
	,className: null
	,isDebug: null
	,hasNext: function() {
		return this.index < this.tests.length;
	}
	,next: function() {
		return this.hasNext()?this.tests[this.index++]:null;
	}
	,current: function() {
		return this.index <= 0?this.tests[0]:this.tests[this.index - 1];
	}
	,parse: function(type) {
		this.test = Type.createEmptyInstance(type);
		var inherintanceChain = this.getInheritanceChain(type);
		var fieldMeta = this.collateFieldMeta(inherintanceChain);
		this.scanForTests(fieldMeta);
		this.tests.sort(this.sortTestsByName.$bind(this));
	}
	,getInheritanceChain: function(clazz) {
		var inherintanceChain = [clazz];
		while((clazz = Type.getSuperClass(clazz)) != null) inherintanceChain.push(clazz);
		return inherintanceChain;
	}
	,collateFieldMeta: function(inherintanceChain) {
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
	,scanForTests: function(fieldMeta) {
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
	,searchForMatchingTags: function(fieldName,func,funcMeta) {
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
	,addTest: function(field,testFunction,testInstance,isAsync,isIgnored,description) {
		var result = new massive.munit.TestResult();
		result.async = isAsync;
		result.ignore = isIgnored;
		result.className = this.className;
		result.description = description;
		result.name = field;
		var data = { test : testFunction, scope : testInstance, result : result};
		this.tests.push(data);
	}
	,sortTestsByName: function(x,y) {
		if(x.result.name == y.result.name) return 0;
		if(x.result.name > y.result.name) return 1; else return -1;
	}
	,nullFunc: function() {
	}
	,__class__: massive.munit.TestClassHelper
}
massive.munit.TestResult = $hxClasses["massive.munit.TestResult"] = function() {
	this.passed = false;
	this.executionTime = 0.0;
	this.name = "";
	this.className = "";
	this.description = "";
	this.async = false;
	this.ignore = false;
	this.error = null;
	this.failure = null;
};
massive.munit.TestResult.__name__ = ["massive","munit","TestResult"];
massive.munit.TestResult.prototype = {
	passed: null
	,executionTime: null
	,name: null
	,className: null
	,description: null
	,location: null
	,get_location: function() {
		return this.name == "" && this.className == ""?"":this.className + "#" + this.name;
	}
	,async: null
	,ignore: null
	,failure: null
	,error: null
	,type: null
	,get_type: function() {
		if(this.error != null) return massive.munit.TestResultType.ERROR;
		if(this.failure != null) return massive.munit.TestResultType.FAIL;
		if(this.ignore == true) return massive.munit.TestResultType.IGNORE;
		if(this.passed == true) return massive.munit.TestResultType.PASS;
		return massive.munit.TestResultType.UNKNOWN;
	}
	,__class__: massive.munit.TestResult
	,__properties__: {get_type:"get_type",get_location:"get_location"}
}
massive.munit.TestResultType = $hxClasses["massive.munit.TestResultType"] = { __ename__ : ["massive","munit","TestResultType"], __constructs__ : ["UNKNOWN","PASS","FAIL","ERROR","IGNORE"] }
massive.munit.TestResultType.UNKNOWN = ["UNKNOWN",0];
massive.munit.TestResultType.UNKNOWN.toString = $estr;
massive.munit.TestResultType.UNKNOWN.__enum__ = massive.munit.TestResultType;
massive.munit.TestResultType.PASS = ["PASS",1];
massive.munit.TestResultType.PASS.toString = $estr;
massive.munit.TestResultType.PASS.__enum__ = massive.munit.TestResultType;
massive.munit.TestResultType.FAIL = ["FAIL",2];
massive.munit.TestResultType.FAIL.toString = $estr;
massive.munit.TestResultType.FAIL.__enum__ = massive.munit.TestResultType;
massive.munit.TestResultType.ERROR = ["ERROR",3];
massive.munit.TestResultType.ERROR.toString = $estr;
massive.munit.TestResultType.ERROR.__enum__ = massive.munit.TestResultType;
massive.munit.TestResultType.IGNORE = ["IGNORE",4];
massive.munit.TestResultType.IGNORE.toString = $estr;
massive.munit.TestResultType.IGNORE.__enum__ = massive.munit.TestResultType;
if(!massive.munit.async) massive.munit.async = {}
massive.munit.async.IAsyncDelegateObserver = $hxClasses["massive.munit.async.IAsyncDelegateObserver"] = function() { }
massive.munit.async.IAsyncDelegateObserver.__name__ = ["massive","munit","async","IAsyncDelegateObserver"];
massive.munit.async.IAsyncDelegateObserver.prototype = {
	asyncResponseHandler: null
	,asyncTimeoutHandler: null
	,asyncDelegateCreatedHandler: null
	,__class__: massive.munit.async.IAsyncDelegateObserver
}
massive.munit.TestRunner = $hxClasses["massive.munit.TestRunner"] = function(resultClient) {
	this.clients = new Array();
	this.addResultClient(resultClient);
	this.set_asyncFactory(this.createAsyncFactory());
	this.running = false;
	this.isDebug = false;
};
massive.munit.TestRunner.__name__ = ["massive","munit","TestRunner"];
massive.munit.TestRunner.__interfaces__ = [massive.munit.async.IAsyncDelegateObserver];
massive.munit.TestRunner.prototype = {
	completionHandler: null
	,clientCount: null
	,get_clientCount: function() {
		return this.clients.length;
	}
	,running: null
	,testCount: null
	,failCount: null
	,errorCount: null
	,passCount: null
	,ignoreCount: null
	,clientCompleteCount: null
	,clients: null
	,activeHelper: null
	,testSuites: null
	,asyncPending: null
	,asyncDelegate: null
	,suiteIndex: null
	,asyncFactory: null
	,set_asyncFactory: function(value) {
		if(value == this.asyncFactory) return value;
		if(this.running) throw new massive.munit.MUnitException("Can't change AsyncFactory while tests are running",{ fileName : "TestRunner.hx", lineNumber : 119, className : "massive.munit.TestRunner", methodName : "set_asyncFactory"});
		value.observer = this;
		return this.asyncFactory = value;
	}
	,emptyParams: null
	,startTime: null
	,testStartTime: null
	,isDebug: null
	,addResultClient: function(resultClient) {
		var _g = 0, _g1 = this.clients;
		while(_g < _g1.length) {
			var client = _g1[_g];
			++_g;
			if(client == resultClient) return;
		}
		resultClient.set_completeHandler(this.clientCompletionHandler.$bind(this));
		this.clients.push(resultClient);
	}
	,debug: function(testSuiteClasses) {
		this.isDebug = true;
		this.run(testSuiteClasses);
	}
	,run: function(testSuiteClasses) {
		if(this.running) return;
		this.running = true;
		this.asyncPending = false;
		this.asyncDelegate = null;
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
	,execute: function() {
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
				if(Std["is"](client,massive.munit.IAdvancedTestResultClient)) ((function($this) {
					var $r;
					var $t = client;
					if(Std["is"]($t,massive.munit.IAdvancedTestResultClient)) $t; else throw "Class cast error";
					$r = $t;
					return $r;
				}(this))).setCurrentTestClass(null);
				client.reportFinalStatistics(this.testCount,this.passCount,this.failCount,this.errorCount,this.ignoreCount,time);
			}
		}
	}
	,executeTestCases: function() {
		var _g = 0, _g1 = this.clients;
		while(_g < _g1.length) {
			var c = _g1[_g];
			++_g;
			if(Std["is"](c,massive.munit.IAdvancedTestResultClient)) ((function($this) {
				var $r;
				var $t = c;
				if(Std["is"]($t,massive.munit.IAdvancedTestResultClient)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this))).setCurrentTestClass(this.activeHelper.className);
		}
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
	,executeTestCase: function(testCaseData,async) {
		var result = testCaseData.result;
		try {
			var assertionCount = massive.munit.Assert.assertionCount;
			if(async) {
				testCaseData.test.apply(testCaseData.scope,[this.asyncFactory]);
				if(this.asyncDelegate == null) throw new massive.munit.async.MissingAsyncDelegateException("No AsyncDelegate was created in async test at " + result.get_location(),null);
				this.asyncPending = true;
			} else {
				testCaseData.test.apply(testCaseData.scope,this.emptyParams);
				result.passed = true;
				result.executionTime = massive.munit.util.Timer.stamp() - this.testStartTime;
				this.passCount++;
				var _g = 0, _g1 = this.clients;
				while(_g < _g1.length) {
					var c = _g1[_g];
					++_g;
					c.addPass(result);
				}
			}
		} catch( e ) {
			if(async && this.asyncDelegate != null) {
				this.asyncDelegate.cancelTest();
				this.asyncDelegate = null;
			}
			if(Std["is"](e,org.hamcrest.AssertionException)) e = new massive.munit.AssertionException(e.message,e.info);
			if(Std["is"](e,massive.munit.AssertionException)) {
				result.executionTime = massive.munit.util.Timer.stamp() - this.testStartTime;
				result.failure = e;
				this.failCount++;
				var _g = 0, _g1 = this.clients;
				while(_g < _g1.length) {
					var c = _g1[_g];
					++_g;
					c.addFail(result);
				}
			} else {
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
	,clientCompletionHandler: function(resultClient) {
		if(++this.clientCompleteCount == this.clients.length) {
			if(this.completionHandler != null) {
				var successful = this.passCount == this.testCount;
				var handler = this.completionHandler;
				massive.munit.util.Timer.delay(function() {
					handler(successful);
				},10);
			}
			this.running = false;
		}
	}
	,asyncResponseHandler: function(delegate) {
		var testCaseData = this.activeHelper.current();
		testCaseData.test = delegate.runTest.$bind(delegate);
		testCaseData.scope = delegate;
		this.asyncPending = false;
		this.asyncDelegate = null;
		this.executeTestCase(testCaseData,false);
		this.activeHelper.after.apply(this.activeHelper.test,this.emptyParams);
		this.execute();
	}
	,asyncTimeoutHandler: function(delegate) {
		var testCaseData = this.activeHelper.current();
		var result = testCaseData.result;
		result.executionTime = massive.munit.util.Timer.stamp() - this.testStartTime;
		result.error = new massive.munit.async.AsyncTimeoutException("",delegate.info);
		this.asyncPending = false;
		this.asyncDelegate = null;
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
	,asyncDelegateCreatedHandler: function(delegate) {
		this.asyncDelegate = delegate;
	}
	,createAsyncFactory: function() {
		return new massive.munit.async.AsyncFactory(this);
	}
	,__class__: massive.munit.TestRunner
	,__properties__: {set_asyncFactory:"set_asyncFactory",get_clientCount:"get_clientCount"}
}
massive.munit.UnhandledException = $hxClasses["massive.munit.UnhandledException"] = function(source,testLocation) {
	massive.munit.MUnitException.call(this,source.toString() + this.formatLocation(source,testLocation),null);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "UnhandledException.hx", lineNumber : 48, className : "massive.munit.UnhandledException", methodName : "new"}).className;
};
massive.munit.UnhandledException.__name__ = ["massive","munit","UnhandledException"];
massive.munit.UnhandledException.__super__ = massive.munit.MUnitException;
massive.munit.UnhandledException.prototype = $extend(massive.munit.MUnitException.prototype,{
	formatLocation: function(source,testLocation) {
		var stackTrace = this.getStackTrace(source);
		if(stackTrace == "") stackTrace = " at " + testLocation; else stackTrace = " " + stackTrace.substr(1);
		return stackTrace;
	}
	,getStackTrace: function(source) {
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
					var module = $e[2];
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
	,__class__: massive.munit.UnhandledException
});
massive.munit.async.AsyncDelegate = $hxClasses["massive.munit.async.AsyncDelegate"] = function(testCase,handler,timeout,info) {
	var self = this;
	this.testCase = testCase;
	this.handler = handler;
	this.delegateHandler = Reflect.makeVarArgs(this.responseHandler.$bind(this));
	this.info = info;
	this.params = [];
	this.timedOut = false;
	this.canceled = false;
	if(timeout == null || timeout <= 0) timeout = 400;
	this.timeoutDelay = timeout;
	this.timer = massive.munit.util.Timer.delay(this.timeoutHandler.$bind(this),this.timeoutDelay);
};
massive.munit.async.AsyncDelegate.__name__ = ["massive","munit","async","AsyncDelegate"];
massive.munit.async.AsyncDelegate.prototype = {
	observer: null
	,info: null
	,delegateHandler: null
	,timeoutDelay: null
	,timedOut: null
	,testCase: null
	,handler: null
	,timer: null
	,canceled: null
	,deferredTimer: null
	,params: null
	,runTest: function() {
		this.handler.apply(this.testCase,this.params);
	}
	,cancelTest: function() {
		this.canceled = true;
		this.timer.stop();
		if(this.deferredTimer != null) this.deferredTimer.stop();
	}
	,responseHandler: function(params) {
		if(this.timedOut || this.canceled) return;
		this.timer.stop();
		if(this.deferredTimer != null) this.deferredTimer.stop();
		if(params == null) params = [];
		this.params = params;
		if(this.observer != null) this.observer.asyncResponseHandler(this);
	}
	,timeoutHandler: function() {
		this.actualTimeoutHandler();
	}
	,actualTimeoutHandler: function() {
		this.deferredTimer = null;
		this.handler = null;
		this.delegateHandler = null;
		this.timedOut = true;
		if(this.observer != null) this.observer.asyncTimeoutHandler(this);
	}
	,__class__: massive.munit.async.AsyncDelegate
}
massive.munit.async.AsyncFactory = $hxClasses["massive.munit.async.AsyncFactory"] = function(observer) {
	this.observer = observer;
	this.asyncDelegateCount = 0;
};
massive.munit.async.AsyncFactory.__name__ = ["massive","munit","async","AsyncFactory"];
massive.munit.async.AsyncFactory.prototype = {
	observer: null
	,asyncDelegateCount: null
	,createHandler: function(testCase,handler,timeout,info) {
		var delegate = new massive.munit.async.AsyncDelegate(testCase,handler,timeout,info);
		delegate.observer = this.observer;
		this.asyncDelegateCount++;
		this.observer.asyncDelegateCreatedHandler(delegate);
		return delegate.delegateHandler;
	}
	,__class__: massive.munit.async.AsyncFactory
}
massive.munit.async.AsyncTimeoutException = $hxClasses["massive.munit.async.AsyncTimeoutException"] = function(message,info) {
	massive.munit.MUnitException.call(this,message,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "AsyncTimeoutException.hx", lineNumber : 47, className : "massive.munit.async.AsyncTimeoutException", methodName : "new"}).className;
};
massive.munit.async.AsyncTimeoutException.__name__ = ["massive","munit","async","AsyncTimeoutException"];
massive.munit.async.AsyncTimeoutException.__super__ = massive.munit.MUnitException;
massive.munit.async.AsyncTimeoutException.prototype = $extend(massive.munit.MUnitException.prototype,{
	__class__: massive.munit.async.AsyncTimeoutException
});
massive.munit.async.MissingAsyncDelegateException = $hxClasses["massive.munit.async.MissingAsyncDelegateException"] = function(message,info) {
	massive.munit.MUnitException.call(this,message,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "MissingAsyncDelegateException.hx", lineNumber : 47, className : "massive.munit.async.MissingAsyncDelegateException", methodName : "new"}).className;
};
massive.munit.async.MissingAsyncDelegateException.__name__ = ["massive","munit","async","MissingAsyncDelegateException"];
massive.munit.async.MissingAsyncDelegateException.__super__ = massive.munit.MUnitException;
massive.munit.async.MissingAsyncDelegateException.prototype = $extend(massive.munit.MUnitException.prototype,{
	__class__: massive.munit.async.MissingAsyncDelegateException
});
massive.munit.client.HTTPClient = $hxClasses["massive.munit.client.HTTPClient"] = function(client,url,queueRequest) {
	if(queueRequest == null) queueRequest = true;
	if(url == null) url = "http://localhost:2000";
	this.id = "HTTPClient";
	this.client = client;
	this.url = url;
	this.queueRequest = queueRequest;
};
massive.munit.client.HTTPClient.__name__ = ["massive","munit","client","HTTPClient"];
massive.munit.client.HTTPClient.__interfaces__ = [massive.munit.IAdvancedTestResultClient];
massive.munit.client.HTTPClient.dispatchNextRequest = function() {
	if(massive.munit.client.HTTPClient.responsePending || massive.munit.client.HTTPClient.queue.length == 0) return;
	massive.munit.client.HTTPClient.responsePending = true;
	var request = massive.munit.client.HTTPClient.queue.pop();
	request.send();
}
massive.munit.client.HTTPClient.prototype = {
	id: null
	,completionHandler: null
	,get_completeHandler: function() {
		return this.completionHandler;
	}
	,set_completeHandler: function(value) {
		return this.completionHandler = value;
	}
	,client: null
	,url: null
	,request: null
	,queueRequest: null
	,setCurrentTestClass: function(className) {
		if(Std["is"](this.client,massive.munit.IAdvancedTestResultClient)) ((function($this) {
			var $r;
			var $t = $this.client;
			if(Std["is"]($t,massive.munit.IAdvancedTestResultClient)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this))).setCurrentTestClass(className);
	}
	,addPass: function(result) {
		this.client.addPass(result);
	}
	,addFail: function(result) {
		this.client.addFail(result);
	}
	,addError: function(result) {
		this.client.addError(result);
	}
	,addIgnore: function(result) {
		this.client.addIgnore(result);
	}
	,reportFinalStatistics: function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
		var result = this.client.reportFinalStatistics(testCount,passCount,failCount,errorCount,ignoreCount,time);
		this.sendResult(result);
		return result;
	}
	,sendResult: function(result) {
		this.request = new massive.munit.client.URLRequest(this.url);
		this.request.setHeader("munit-clientId",this.client.id);
		this.request.setHeader("munit-platformId",this.platform());
		this.request.onData = this.onData.$bind(this);
		this.request.onError = this.onError.$bind(this);
		this.request.data = result;
		if(this.queueRequest) {
			massive.munit.client.HTTPClient.queue.unshift(this.request);
			massive.munit.client.HTTPClient.dispatchNextRequest();
		} else this.request.send();
	}
	,platform: function() {
		return "js";
		return "unknown";
	}
	,onData: function(data) {
		if(this.queueRequest) {
			massive.munit.client.HTTPClient.responsePending = false;
			massive.munit.client.HTTPClient.dispatchNextRequest();
		}
		if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
	}
	,onError: function(msg) {
		if(this.queueRequest) {
			massive.munit.client.HTTPClient.responsePending = false;
			massive.munit.client.HTTPClient.dispatchNextRequest();
		}
		if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
	}
	,__class__: massive.munit.client.HTTPClient
	,__properties__: {set_completionHandler:"set_completeHandler",get_completionHandler:"get_completeHandler"}
}
massive.munit.client.URLRequest = $hxClasses["massive.munit.client.URLRequest"] = function(url) {
	this.url = url;
	this.createClient(url);
	this.setHeader("Content-Type","text/plain");
};
massive.munit.client.URLRequest.__name__ = ["massive","munit","client","URLRequest"];
massive.munit.client.URLRequest.prototype = {
	onData: null
	,onError: null
	,data: null
	,url: null
	,headers: null
	,client: null
	,createClient: function(url) {
		this.client = new haxe.Http(url);
	}
	,setHeader: function(name,value) {
		this.client.setHeader(name,value);
	}
	,send: function() {
		this.client.onData = this.onData;
		this.client.onError = this.onError;
		this.client.setPostData(this.data);
		this.client.request(true);
	}
	,__class__: massive.munit.client.URLRequest
}
massive.munit.client.JUnitReportClient = $hxClasses["massive.munit.client.JUnitReportClient"] = function() {
	this.id = "junit";
	this.xml = new StringBuf();
	this.currentTestClass = "";
	this.newline = "\n";
	this.testSuiteXML = null;
	this.xml.add("<testsuites>" + this.newline);
};
massive.munit.client.JUnitReportClient.__name__ = ["massive","munit","client","JUnitReportClient"];
massive.munit.client.JUnitReportClient.__interfaces__ = [massive.munit.IAdvancedTestResultClient];
massive.munit.client.JUnitReportClient.prototype = {
	id: null
	,completionHandler: null
	,get_completeHandler: function() {
		return this.completionHandler;
	}
	,set_completeHandler: function(value) {
		return this.completionHandler = value;
	}
	,newline: null
	,xml: null
	,testSuiteXML: null
	,currentTestClass: null
	,suitePassCount: null
	,suiteFailCount: null
	,suiteErrorCount: null
	,suiteExecutionTime: null
	,setCurrentTestClass: function(className) {
		if(this.currentTestClass == className) return;
		if(this.currentTestClass != null) this.endTestSuite();
		this.currentTestClass = className;
		if(this.currentTestClass != null) this.startTestSuite();
	}
	,addPass: function(result) {
		this.suitePassCount++;
		this.testSuiteXML.add("<testcase classname=\"" + result.className + "\" name=\"" + result.name + "\" time=\"" + massive.munit.util.MathUtil.round(result.executionTime,5) + "\" />" + this.newline);
	}
	,addFail: function(result) {
		this.suiteFailCount++;
		this.testSuiteXML.add("<testcase classname=\"" + result.className + "\" name=\"" + result.name + "\" time=\"" + massive.munit.util.MathUtil.round(result.executionTime,5) + "\" >" + this.newline);
		this.testSuiteXML.add("<failure message=\"" + result.failure.message + "\" type=\"" + result.failure.type + "\">");
		this.testSuiteXML.add(result.failure);
		this.testSuiteXML.add("</failure>" + this.newline);
		this.testSuiteXML.add("</testcase>" + this.newline);
	}
	,addError: function(result) {
		this.suiteErrorCount++;
		this.testSuiteXML.add("<testcase classname=\"" + result.className + "\" name=\"" + result.name + "\" time=\"" + massive.munit.util.MathUtil.round(result.executionTime,5) + "\" >" + this.newline);
		this.testSuiteXML.add("<error message=\"" + result.error.message + "\" type=\"" + result.error.type + "\">");
		this.testSuiteXML.add(result.error);
		this.testSuiteXML.add("</error>" + this.newline);
		this.testSuiteXML.add("</testcase>" + this.newline);
	}
	,addIgnore: function(result) {
	}
	,reportFinalStatistics: function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
		this.xml.add("</testsuites>");
		if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
		return this.xml.b.join("");
	}
	,endTestSuite: function() {
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
	,startTestSuite: function() {
		this.suitePassCount = 0;
		this.suiteFailCount = 0;
		this.suiteErrorCount = 0;
		this.suiteExecutionTime = massive.munit.util.Timer.stamp();
		this.testSuiteXML = new StringBuf();
	}
	,__class__: massive.munit.client.JUnitReportClient
	,__properties__: {set_completionHandler:"set_completeHandler",get_completionHandler:"get_completeHandler"}
}
massive.munit.client.PrintClientBase = $hxClasses["massive.munit.client.PrintClientBase"] = function(includeIgnoredReport) {
	if(includeIgnoredReport == null) includeIgnoredReport = true;
	massive.munit.client.AbstractTestResultClient.call(this);
	this.id = "simple";
	this.verbose = false;
	this.includeIgnoredReport = includeIgnoredReport;
	this.printLine("MUnit Results");
	this.printLine(this.divider);
};
massive.munit.client.PrintClientBase.__name__ = ["massive","munit","client","PrintClientBase"];
massive.munit.client.PrintClientBase.__super__ = massive.munit.client.AbstractTestResultClient;
massive.munit.client.PrintClientBase.prototype = $extend(massive.munit.client.AbstractTestResultClient.prototype,{
	verbose: null
	,includeIgnoredReport: null
	,divider: null
	,divider2: null
	,init: function() {
		massive.munit.client.AbstractTestResultClient.prototype.init.call(this);
		this.divider = "------------------------------";
		this.divider2 = "==============================";
	}
	,initializeTestClass: function() {
		massive.munit.client.AbstractTestResultClient.prototype.initializeTestClass.call(this);
		this.printLine("Class: " + this.currentTestClass + " ");
	}
	,updateTestClass: function(result) {
		massive.munit.client.AbstractTestResultClient.prototype.updateTestClass.call(this,result);
		if(this.verbose) this.printLine(" " + result.name + ": " + result.get_type() + " "); else {
			switch( (result.get_type())[1] ) {
			case 1:
				this.print(".");
				break;
			case 2:
				this.print("!");
				break;
			case 3:
				this.print("x");
				break;
			case 4:
				this.print(",");
				break;
			case 0:
				null;
				break;
			}
		}
	}
	,finalizeTestClass: function() {
		massive.munit.client.AbstractTestResultClient.prototype.finalizeTestClass.call(this);
		var _g = 0, _g1 = this.traces;
		while(_g < _g1.length) {
			var item = _g1[_g];
			++_g;
			this.printLine("TRACE: " + item,1);
		}
		var _g = 0, _g1 = this.currentClassResults;
		while(_g < _g1.length) {
			var result = _g1[_g];
			++_g;
			switch( (result.get_type())[1] ) {
			case 3:
				this.printLine("ERROR: " + Std.string(result.error),1);
				break;
			case 2:
				this.printLine("FAIL: " + Std.string(result.failure),1);
				break;
			case 4:
				var ingoredString = result.get_location();
				if(result.description != null) ingoredString += " - " + result.description;
				this.printLine("IGNORE: " + ingoredString,1);
				break;
			case 1:
			case 0:
				null;
				break;
			}
		}
	}
	,setCurrentTestClassCoverage: function(result) {
		massive.munit.client.AbstractTestResultClient.prototype.setCurrentTestClassCoverage.call(this,result);
		this.print(" [" + result.percent + "%]");
	}
	,reportFinalCoverage: function(percent,missingCoverageResults,summary,classBreakdown,packageBreakdown,executionFrequency) {
		if(percent == null) percent = 0;
		massive.munit.client.AbstractTestResultClient.prototype.reportFinalCoverage.call(this,percent,missingCoverageResults,summary,classBreakdown,packageBreakdown,executionFrequency);
		this.printLine("");
		this.printLine(this.divider);
		this.printLine("COVERAGE REPORT");
		this.printLine(this.divider);
		if(missingCoverageResults != null && missingCoverageResults.length > 0) {
			this.printLine("MISSING CODE BLOCKS:");
			var _g = 0;
			while(_g < missingCoverageResults.length) {
				var result = missingCoverageResults[_g];
				++_g;
				this.printLine(result.className + " [" + result.percent + "%]",1);
				var _g1 = 0, _g2 = result.blocks;
				while(_g1 < _g2.length) {
					var item = _g2[_g1];
					++_g1;
					this.printIndentedLines(item,2);
				}
				this.printLine("");
			}
		}
		if(executionFrequency != null) {
			this.printLine("CODE EXECUTION FREQUENCY:");
			this.printIndentedLines(executionFrequency,1);
			this.printLine("");
		}
		if(classBreakdown != null) this.printIndentedLines(classBreakdown,0);
		if(packageBreakdown != null) this.printIndentedLines(packageBreakdown,0);
		if(summary != null) this.printIndentedLines(summary,0);
	}
	,printIndentedLines: function(value,indent) {
		if(indent == null) indent = 1;
		var lines = value.split("\n");
		var _g = 0;
		while(_g < lines.length) {
			var line = lines[_g];
			++_g;
			this.printLine(line,indent);
		}
	}
	,printReports: function() {
		this.printFinalIgnoredStatistics(this.ignoreCount);
	}
	,printFinalIgnoredStatistics: function(count) {
		if(!this.includeIgnoredReport || count == 0) return;
		var items = Lambda.filter(this.totalResults,this.filterIngored.$bind(this));
		if(items.length == 0) return;
		this.printLine("");
		this.printLine("Ignored (" + count + "):");
		this.printLine(this.divider);
		var $it0 = items.iterator();
		while( $it0.hasNext() ) {
			var result = $it0.next();
			var ingoredString = result.get_location();
			if(result.description != null) ingoredString += " - " + result.description;
			this.printLine("IGNORE: " + ingoredString,1);
		}
		this.printLine("");
	}
	,filterIngored: function(result) {
		return result.get_type() == massive.munit.TestResultType.IGNORE;
	}
	,printFinalStatistics: function(result,testCount,passCount,failCount,errorCount,ignoreCount,time) {
		this.printLine(this.divider2);
		var resultString = result?"PASSED":"FAILED";
		resultString += "\n" + "Tests: " + testCount + "  Passed: " + passCount + "  Failed: " + failCount + " Errors: " + errorCount + " Ignored: " + ignoreCount + " Time: " + massive.munit.util.MathUtil.round(time,5);
		this.printLine(resultString);
		this.printLine("");
	}
	,printOverallResult: function(result) {
		this.printLine("");
	}
	,print: function(value) {
		this.output += Std.string(value);
	}
	,printLine: function(value,indent) {
		if(indent == null) indent = 0;
		value = Std.string(value);
		value = this.indentString(value,indent);
		this.print("\n" + value);
	}
	,indentString: function(value,indent) {
		if(indent == null) indent = 0;
		if(indent > 0) value = StringTools.lpad(""," ",indent * 4) + value;
		if(value == "") value = "";
		return value;
	}
	,__class__: massive.munit.client.PrintClientBase
});
massive.munit.client.PrintClient = $hxClasses["massive.munit.client.PrintClient"] = function(includeIgnoredReport) {
	if(includeIgnoredReport == null) includeIgnoredReport = true;
	massive.munit.client.PrintClientBase.call(this,includeIgnoredReport);
	this.id = "print";
};
massive.munit.client.PrintClient.__name__ = ["massive","munit","client","PrintClient"];
massive.munit.client.PrintClient.__super__ = massive.munit.client.PrintClientBase;
massive.munit.client.PrintClient.prototype = $extend(massive.munit.client.PrintClientBase.prototype,{
	external: null
	,textArea: null
	,init: function() {
		massive.munit.client.PrintClientBase.prototype.init.call(this);
		this.external = new massive.munit.client.ExternalPrintClientJS();
		this.initJS();
	}
	,initJS: function() {
		var div = js.Lib.document.getElementById("haxe:trace");
		if(div == null) {
			var positionInfo = massive.haxe.util.ReflectUtil.here({ fileName : "PrintClient.hx", lineNumber : 124, className : "massive.munit.client.PrintClient", methodName : "initJS"});
			var error = "MissingElementException: 'haxe:trace' element not found at " + positionInfo.className + "#" + positionInfo.methodName + "(" + positionInfo.lineNumber + ")";
			js.Lib.alert(error);
		}
	}
	,printOverallResult: function(result) {
		massive.munit.client.PrintClientBase.prototype.printOverallResult.call(this,result);
		this.external.setResult(result);
		this.external.setResultBackground(result);
	}
	,reportFinalStatistics: function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
		massive.munit.client.PrintClientBase.prototype.reportFinalStatistics.call(this,testCount,passCount,failCount,errorCount,ignoreCount,time);
	}
	,print: function(value) {
		massive.munit.client.PrintClientBase.prototype.print.call(this,value);
		this.external.print(value);
	}
	,printLine: function(value,indent) {
		if(indent == null) indent = 0;
		massive.munit.client.PrintClientBase.prototype.printLine.call(this,value,indent);
	}
	,__class__: massive.munit.client.PrintClient
});
massive.munit.client.ExternalPrintClient = $hxClasses["massive.munit.client.ExternalPrintClient"] = function() { }
massive.munit.client.ExternalPrintClient.__name__ = ["massive","munit","client","ExternalPrintClient"];
massive.munit.client.ExternalPrintClient.prototype = {
	queue: null
	,setResult: null
	,print: null
	,printLine: null
	,setResultBackground: null
	,createTestClass: null
	,printToTestClassSummary: null
	,setTestClassResult: null
	,trace: null
	,addTestPass: null
	,addTestFail: null
	,addTestError: null
	,addTestIgnore: null
	,addTestClassCoverage: null
	,addTestClassCoverageItem: null
	,createCoverageReport: null
	,addMissingCoverageClass: null
	,addCoverageReportSection: null
	,addCoverageSummary: null
	,printSummary: null
	,__class__: massive.munit.client.ExternalPrintClient
}
massive.munit.client.ExternalPrintClientJS = $hxClasses["massive.munit.client.ExternalPrintClientJS"] = function() {
	var div = js.Lib.document.getElementById("haxe:trace");
	if(div == null) {
		var positionInfo = massive.haxe.util.ReflectUtil.here({ fileName : "PrintClientBase.hx", lineNumber : 341, className : "massive.munit.client.ExternalPrintClientJS", methodName : "new"});
		var error = "MissingElementException: 'haxe:trace' element not found at " + positionInfo.className + "#" + positionInfo.methodName + "(" + positionInfo.lineNumber + ")";
		js.Lib.alert(error);
	}
};
massive.munit.client.ExternalPrintClientJS.__name__ = ["massive","munit","client","ExternalPrintClientJS"];
massive.munit.client.ExternalPrintClientJS.__interfaces__ = [massive.munit.client.ExternalPrintClient];
massive.munit.client.ExternalPrintClientJS.prototype = {
	print: function(value) {
		this.queue("munitPrint",value);
	}
	,printLine: function(value) {
		this.queue("munitPrintLine",value);
	}
	,setResult: function(value) {
		this.queue("setResult",value);
	}
	,setResultBackground: function(value) {
		this.queue("setResultBackground",value);
	}
	,trace: function(value) {
		this.queue("munitTrace",value);
	}
	,createTestClass: function(className) {
		this.queue("createTestClass",className);
	}
	,printToTestClassSummary: function(value) {
		this.queue("updateTestSummary",value);
	}
	,setTestClassResult: function(resultType) {
		this.queue("setTestClassResult",resultType);
	}
	,addTestPass: function(value) {
		if(value == null) return;
		this.queue("addTestPass",value);
	}
	,addTestFail: function(value) {
		this.queue("addTestFail",value);
	}
	,addTestError: function(value) {
		this.queue("addTestError",value);
	}
	,addTestIgnore: function(value) {
		this.queue("addTestIgnore",value);
	}
	,addTestClassCoverage: function(className,percent) {
		if(percent == null) percent = 0;
		this.queue("addTestCoverageClass",[className,percent]);
	}
	,addTestClassCoverageItem: function(value) {
		this.queue("addTestCoverageItem",value);
	}
	,createCoverageReport: function(percent) {
		if(percent == null) percent = 0;
		this.queue("createCoverageReport",percent);
	}
	,addMissingCoverageClass: function(className,percent) {
		if(percent == null) percent = 0;
		this.queue("addMissingCoverageClass",[className,percent]);
	}
	,addCoverageReportSection: function(name,value) {
		this.queue("addCoverageReportSection",[name,value]);
	}
	,addCoverageSummary: function(value) {
		this.queue("addCoverageSummary",value);
	}
	,printSummary: function(value) {
		this.queue("printSummary",value);
	}
	,queue: function(method,args) {
		var a = [];
		if(Std["is"](args,Array)) a = a.concat((function($this) {
			var $r;
			var $t = args;
			if(Std["is"]($t,Array)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this))); else a.push(args);
		var jsCode = this.convertToJavaScript(method,a);
		return eval(jsCode);
		return false;
	}
	,convertToJavaScript: function(method,args) {
		var htmlArgs = [];
		var _g = 0;
		while(_g < args.length) {
			var arg = args[_g];
			++_g;
			var html = this.serialiseToHTML(Std.string(arg));
			htmlArgs.push(html);
		}
		var jsCode;
		if(htmlArgs == null || htmlArgs.length == 0) jsCode = "addToQueue(\"" + method + "\")"; else {
			jsCode = "addToQueue(\"" + method + "\"";
			var _g = 0;
			while(_g < htmlArgs.length) {
				var arg = htmlArgs[_g];
				++_g;
				jsCode += ",\"" + arg + "\"";
			}
			jsCode += ")";
		}
		return jsCode;
	}
	,serialiseToHTML: function(value) {
		value = js.Boot.__string_rec(value,"");
		var v = StringTools.htmlEscape(value);
		v = v.split("\n").join("<br/>");
		v = v.split(" ").join("&nbsp;");
		v = v.split("\"").join("\\'");
		return v;
	}
	,__class__: massive.munit.client.ExternalPrintClientJS
}
massive.munit.client.RichPrintClient = $hxClasses["massive.munit.client.RichPrintClient"] = function() {
	massive.munit.client.PrintClientBase.call(this);
	this.id = "RichPrintClient";
};
massive.munit.client.RichPrintClient.__name__ = ["massive","munit","client","RichPrintClient"];
massive.munit.client.RichPrintClient.__super__ = massive.munit.client.PrintClientBase;
massive.munit.client.RichPrintClient.prototype = $extend(massive.munit.client.PrintClientBase.prototype,{
	testClassResultType: null
	,external: null
	,init: function() {
		massive.munit.client.PrintClientBase.prototype.init.call(this);
		this.external = new massive.munit.client.ExternalPrintClientJS();
	}
	,initializeTestClass: function() {
		massive.munit.client.PrintClientBase.prototype.initializeTestClass.call(this);
		this.external.createTestClass(this.currentTestClass);
		this.external.printToTestClassSummary("Class: " + this.currentTestClass + " ");
	}
	,updateTestClass: function(result) {
		massive.munit.client.PrintClientBase.prototype.updateTestClass.call(this,result);
		var value = this.serializeTestResult(result);
		switch( (result.get_type())[1] ) {
		case 1:
			this.external.printToTestClassSummary(".");
			this.external.addTestPass(value);
			break;
		case 2:
			this.external.printToTestClassSummary("!");
			this.external.addTestFail(value);
			break;
		case 3:
			this.external.printToTestClassSummary("x");
			this.external.addTestError(value);
			break;
		case 4:
			this.external.printToTestClassSummary(",");
			this.external.addTestIgnore(value);
			break;
		case 0:
			null;
			break;
		}
	}
	,serializeTestResult: function(result) {
		var summary = result.name;
		if(result.description != null && result.description != "") summary += " - " + result.description + " -";
		summary += " (" + massive.munit.util.MathUtil.round(result.executionTime,4) + "s)";
		var str = null;
		if(result.error != null) str = "Error: " + summary + "\n" + Std.string(result.error); else if(result.failure != null) str = "Failure: " + summary + "\n" + Std.string(result.failure); else if(result.ignore) str = "Ignore: " + summary; else if(result.passed) {
		}
		return str;
	}
	,finalizeTestClass: function() {
		massive.munit.client.PrintClientBase.prototype.finalizeTestClass.call(this);
		this.testClassResultType = this.getTestClassResultType();
		var code = (function($this) {
			var $r;
			switch( ($this.testClassResultType)[1] ) {
			case 1:
				$r = 0;
				break;
			case 2:
				$r = 1;
				break;
			case 3:
				$r = 2;
				break;
			case 4:
				$r = 3;
				break;
			default:
				$r = -1;
			}
			return $r;
		}(this));
		if(code == -1) return;
		this.external.setTestClassResult(code);
	}
	,getTestClassResultType: function() {
		if(this.errorCount > 0) return massive.munit.TestResultType.ERROR; else if(this.failCount > 0) return massive.munit.TestResultType.FAIL; else if(this.ignoreCount > 0) return massive.munit.TestResultType.IGNORE; else return massive.munit.TestResultType.PASS;
	}
	,setCurrentTestClassCoverage: function(result) {
		massive.munit.client.PrintClientBase.prototype.setCurrentTestClassCoverage.call(this,result);
		this.external.printToTestClassSummary(" [" + result.percent + "%]");
		if(result.percent == 100) return;
		this.external.addTestClassCoverage(result.className,result.percent);
		var _g = 0, _g1 = result.blocks;
		while(_g < _g1.length) {
			var item = _g1[_g];
			++_g;
			this.external.addTestClassCoverageItem(item);
		}
	}
	,reportFinalCoverage: function(percent,missingCoverageResults,summary,classBreakdown,packageBreakdown,executionFrequency) {
		if(percent == null) percent = 0;
		massive.munit.client.PrintClientBase.prototype.reportFinalCoverage.call(this,percent,missingCoverageResults,summary,classBreakdown,packageBreakdown,executionFrequency);
		this.external.createCoverageReport(percent);
		this.printMissingCoverage(missingCoverageResults);
		if(executionFrequency != null) this.external.addCoverageReportSection("Code Execution Frequency",this.trim(executionFrequency));
		if(classBreakdown != null) this.external.addCoverageReportSection("Class Breakdown",this.trim(classBreakdown));
		if(packageBreakdown != null) this.external.addCoverageReportSection("Package Breakdown",this.trim(packageBreakdown));
		if(packageBreakdown != null) this.external.addCoverageReportSection("Summary",this.trim(summary));
	}
	,trim: function(output) {
		while(output.indexOf("\n") == 0) output = output.substr(1);
		while(output.lastIndexOf("\n") == output.length - 2) output = output.substr(0,output.length - 2);
		return output;
	}
	,printMissingCoverage: function(missingCoverageResults) {
		if(missingCoverageResults == null || missingCoverageResults.length == 0) return;
		var _g = 0;
		while(_g < missingCoverageResults.length) {
			var result = missingCoverageResults[_g];
			++_g;
			this.external.addMissingCoverageClass(result.className,result.percent);
			var _g1 = 0, _g2 = result.blocks;
			while(_g1 < _g2.length) {
				var item = _g2[_g1];
				++_g1;
				this.external.addTestClassCoverageItem(item);
			}
		}
	}
	,printReports: function() {
		massive.munit.client.PrintClientBase.prototype.printReports.call(this);
	}
	,printFinalStatistics: function(result,testCount,passCount,failCount,errorCount,ignoreCount,time) {
		massive.munit.client.PrintClientBase.prototype.printFinalStatistics.call(this,result,testCount,passCount,failCount,errorCount,ignoreCount,time);
		var resultString = result?"PASSED":"FAILED";
		resultString += "\n" + "Tests: " + testCount + "  Passed: " + passCount + "  Failed: " + failCount + " Errors: " + errorCount + " Ignored: " + ignoreCount + " Time: " + massive.munit.util.MathUtil.round(time,5);
		this.external.printSummary(resultString);
	}
	,printOverallResult: function(result) {
		massive.munit.client.PrintClientBase.prototype.printOverallResult.call(this,result);
		this.external.setResult(result);
	}
	,customTrace: function(value,info) {
		massive.munit.client.PrintClientBase.prototype.customTrace.call(this,value,info);
		var t = this.traces[this.traces.length - 1];
		this.external.trace(t);
	}
	,print: function(value) {
		massive.munit.client.PrintClientBase.prototype.print.call(this,value);
		return;
	}
	,printLine: function(value,indent) {
		if(indent == null) indent = 0;
		massive.munit.client.PrintClientBase.prototype.printLine.call(this,value,indent);
	}
	,__class__: massive.munit.client.RichPrintClient
});
if(!massive.munit.util) massive.munit.util = {}
massive.munit.util.MathUtil = $hxClasses["massive.munit.util.MathUtil"] = function() {
};
massive.munit.util.MathUtil.__name__ = ["massive","munit","util","MathUtil"];
massive.munit.util.MathUtil.round = function(value,precision) {
	value = value * Math.pow(10,precision);
	return Math.round(value) / Math.pow(10,precision);
}
massive.munit.util.MathUtil.prototype = {
	__class__: massive.munit.util.MathUtil
}
massive.munit.util.Timer = $hxClasses["massive.munit.util.Timer"] = function(time_ms) {
	this.id = massive.munit.util.Timer.arr.length;
	massive.munit.util.Timer.arr[this.id] = this;
	this.timerId = window.setInterval("massive.munit.util.Timer.arr[" + this.id + "].run();",time_ms);
};
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
massive.munit.util.Timer.prototype = {
	id: null
	,timerId: null
	,stop: function() {
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
	,run: function() {
	}
	,__class__: massive.munit.util.Timer
}
var org = org || {}
if(!org.hamcrest) org.hamcrest = {}
org.hamcrest.Exception = $hxClasses["org.hamcrest.Exception"] = function(message,cause,info) {
	if(message == null) message = "";
	this.name = Type.getClassName(Type.getClass(this));
	this.message = message;
	this.cause = cause;
	this.info = info;
};
org.hamcrest.Exception.__name__ = ["org","hamcrest","Exception"];
org.hamcrest.Exception.prototype = {
	name: null
	,message: null
	,cause: null
	,info: null
	,toString: function() {
		var str = this.name + ": " + this.message;
		if(this.info != null) str += " at " + this.info.className + "#" + this.info.methodName + " (" + this.info.lineNumber + ")";
		if(this.cause != null) str += "\n\t Caused by: " + this.cause;
		return str;
	}
	,__class__: org.hamcrest.Exception
}
org.hamcrest.AssertionException = $hxClasses["org.hamcrest.AssertionException"] = function(message,cause,info) {
	if(message == null) message = "";
	org.hamcrest.Exception.call(this,message,cause,info);
};
org.hamcrest.AssertionException.__name__ = ["org","hamcrest","AssertionException"];
org.hamcrest.AssertionException.__super__ = org.hamcrest.Exception;
org.hamcrest.AssertionException.prototype = $extend(org.hamcrest.Exception.prototype,{
	__class__: org.hamcrest.AssertionException
});
org.hamcrest.IllegalArgumentException = $hxClasses["org.hamcrest.IllegalArgumentException"] = function(message,cause,info) {
	if(message == null) message = "Argument could not be processed.";
	org.hamcrest.Exception.call(this,message,cause,info);
};
org.hamcrest.IllegalArgumentException.__name__ = ["org","hamcrest","IllegalArgumentException"];
org.hamcrest.IllegalArgumentException.__super__ = org.hamcrest.Exception;
org.hamcrest.IllegalArgumentException.prototype = $extend(org.hamcrest.Exception.prototype,{
	__class__: org.hamcrest.IllegalArgumentException
});
org.hamcrest.MissingImplementationException = $hxClasses["org.hamcrest.MissingImplementationException"] = function(message,cause,info) {
	if(message == null) message = "Abstract method not overridden.";
	org.hamcrest.Exception.call(this,message,cause,info);
};
org.hamcrest.MissingImplementationException.__name__ = ["org","hamcrest","MissingImplementationException"];
org.hamcrest.MissingImplementationException.__super__ = org.hamcrest.Exception;
org.hamcrest.MissingImplementationException.prototype = $extend(org.hamcrest.Exception.prototype,{
	__class__: org.hamcrest.MissingImplementationException
});
org.hamcrest.UnsupportedOperationException = $hxClasses["org.hamcrest.UnsupportedOperationException"] = function(message,cause,info) {
	if(message == null) message = "";
	org.hamcrest.Exception.call(this,message,cause,info);
};
org.hamcrest.UnsupportedOperationException.__name__ = ["org","hamcrest","UnsupportedOperationException"];
org.hamcrest.UnsupportedOperationException.__super__ = org.hamcrest.Exception;
org.hamcrest.UnsupportedOperationException.prototype = $extend(org.hamcrest.Exception.prototype,{
	__class__: org.hamcrest.UnsupportedOperationException
});
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
	d.prototype.__class__ = $hxClasses["Date"] = d;
	d.__name__ = ["Date"];
}
{
	Math.__name__ = ["Math"];
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
	$hxClasses["Math"] = Math;
	Math.isFinite = function(i) {
		return isFinite(i);
	};
	Math.isNaN = function(i) {
		return isNaN(i);
	};
}
{
	String.prototype.__class__ = $hxClasses["String"] = String;
	String.__name__ = ["String"];
	Array.prototype.__class__ = $hxClasses["Array"] = Array;
	Array.__name__ = ["Array"];
	var Int = $hxClasses["Int"] = { __name__ : ["Int"]};
	var Dynamic = $hxClasses["Dynamic"] = { __name__ : ["Dynamic"]};
	var Float = $hxClasses["Float"] = Number;
	Float.__name__ = ["Float"];
	var Bool = $hxClasses["Bool"] = Boolean;
	Bool.__ename__ = ["Bool"];
	var Class = $hxClasses["Class"] = { __name__ : ["Class"]};
	var Enum = { };
	var Void = $hxClasses["Void"] = { __ename__ : ["Void"]};
}
haxe.Resource.content = [];
{
	if(typeof document != "undefined") js.Lib.document = document;
	if(typeof window != "undefined") {
		js.Lib.window = window;
		js.Lib.window.onerror = function(msg,url,line) {
			var f = js.Lib.onerror;
			if(f == null) return false;
			return f(msg,[url + ":" + line]);
		};
	}
}
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
ExampleTest.__meta__ = { fields : { beforeClass : { BeforeClass : null}, afterClass : { AfterClass : null}, setup : { Before : null}, tearDown : { After : null}, testExample : { Test : null}, testAsyncExample : { AsyncTest : null}, testExampleThatOnlyRunsWithDebugFlag : { TestDebug : null}}};
example.AccountTest.__meta__ = { fields : { beforeClass : { BeforeClass : null}, afterClass : { AfterClass : null}, setup : { Before : null}, tearDown : { After : null}, shouldBeEmptyAtConstructor : { Test : null}, shouldAddValueToTotal : { Test : null}}};
example.CalculatorTest.__meta__ = { fields : { beforeClass : { BeforeClass : null}, afterClass : { AfterClass : null}, setup : { Before : null}, tearDown : { After : null}, shouldAddValues : { Test : null}, shouldReturn10 : { Test : null}}};
haxe.Serializer.USE_CACHE = false;
haxe.Serializer.USE_ENUM_INDEX = false;
haxe.Serializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.DEFAULT_RESOLVER = Type;
haxe.Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.CODES = null;
js.Lib.onerror = null;
m.cover.coverage.CoverageLoggerImpl.__meta__ = { obj : { IgnoreLogging : null}, fields : { logStatement : { IgnoreCover : null}, updateStatementHash : { IgnoreCover : null}, logBranch : { IgnoreCover : null}, updateBranchHash : { IgnoreCover : null}, _ : { IgnoreCover : null}}};
m.cover.coverage.MCoverage.__meta__ = { obj : { IgnoreLogging : null, IgnoreCover : null}, statics : { getLogger : { IgnoreLogging : null, IgnoreCover : null}}};
m.cover.coverage.MCoverage.RESOURCE_DATA = "MCoverData";
m.cover.coverage.client.PrintClient.__meta__ = { obj : { IgnoreLogging : null}};
m.cover.coverage.client.PrintClient.DEFAULT_TAB_WIDTH = 11;
m.cover.coverage.client.PrintClient.SHORT_FIRST_TAB_WIDTH = 4;
m.cover.coverage.client.PrintClient.LONG_FIRST_TAB_WIDTH = 20;
m.cover.coverage.client.TraceClient.__meta__ = { obj : { IgnoreLogging : null}};
m.cover.coverage.data.AbstractNode.__meta__ = { obj : { IgnoreLogging : null}, fields : { getResults : { IgnoreLogging : null}, getPercentage : { IgnoreLogging : null}, emptyResult : { IgnoreLogging : null}, hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}, _ : { IgnoreCover : null}}};
m.cover.coverage.data.AbstractBlock.__meta__ = { obj : { IgnoreLogging : null}, fields : { hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
m.cover.coverage.data.AbstractNodeList.__meta__ = { obj : { IgnoreLogging : null}, fields : { getResults : { IgnoreLogging : null}, hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
m.cover.coverage.data.Branch.__meta__ = { obj : { IgnoreLogging : null}, fields : { hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
m.cover.coverage.data.Clazz.__meta__ = { obj : { IgnoreLogging : null}};
m.cover.coverage.data.Coverage.__meta__ = { obj : { IgnoreLogging : null}, fields : { getResults : { IgnoreLogging : null}, hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
m.cover.coverage.data.DataUtil.__meta__ = { statics : { sortOnNodeId : { IgnoreLogging : null}, sortOnNodeName : { IgnoreLogging : null}, sortOnBlockName : { IgnoreLogging : null}}, fields : { _ : { IgnoreCover : null}}};
m.cover.coverage.data.File.__meta__ = { obj : { IgnoreLogging : null}};
m.cover.coverage.data.Method.__meta__ = { obj : { IgnoreLogging : null}, fields : { hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
m.cover.coverage.data.Package.__meta__ = { obj : { IgnoreLogging : null}};
m.cover.coverage.data.Statement.__meta__ = { obj : { IgnoreLogging : null}, fields : { hxSerialize : { IgnoreLogging : null}, hxUnserialize : { IgnoreLogging : null}}};
m.cover.coverage.munit.client.MCoverPrintClient.__meta__ = { fields : { initializeMCoverLogger : { IgnoreCover : null}}};
m.cover.coverage.munit.client.MCoverPrintClient.DEFAULT_ID = "MCoverPrintClient";
massive.munit.client.SummaryReportClient.DEFAULT_ID = "summary";
m.cover.coverage.munit.client.MCoverSummaryReportClient.__meta__ = { fields : { initializeLogger : { IgnoreCover : null}}};
m.cover.util.NumberUtil.__meta__ = { obj : { IgnoreCover : null, IgnoreLogging : null}};
m.cover.util.Timer.__meta__ = { obj : { IgnoreCover : null, IgnoreLogging : null}, statics : { inlineStamp : { IgnoreCover : null}}, fields : { defaultRun : { IgnoreCover : null}}};
m.cover.util.Timer.arr = [];
massive.munit.Assert.assertionCount = 0;
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
massive.munit.async.AsyncDelegate.DEFAULT_TIMEOUT = 400;
massive.munit.client.HTTPClient.DEFAULT_SERVER_URL = "http://localhost:2000";
massive.munit.client.HTTPClient.DEFAULT_ID = "HTTPClient";
massive.munit.client.HTTPClient.CLIENT_HEADER_KEY = "munit-clientId";
massive.munit.client.HTTPClient.PLATFORM_HEADER_KEY = "munit-platformId";
massive.munit.client.HTTPClient.queue = [];
massive.munit.client.HTTPClient.responsePending = false;
massive.munit.client.JUnitReportClient.DEFAULT_ID = "junit";
massive.munit.client.PrintClientBase.DEFAULT_ID = "simple";
massive.munit.client.PrintClient.DEFAULT_ID = "print";
massive.munit.client.RichPrintClient.DEFAULT_ID = "RichPrintClient";
massive.munit.util.Timer.arr = new Array();
TestMain.main()