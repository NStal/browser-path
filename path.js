// recoded from from http://www.grauw.nl/articles/resolve-uri.html
// make many fix for nodejs compatible 

(function(exports){    
    var uriregexp = new RegExp('^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?');
    exports.path = {};
    exports.url = {};
    exports.url.parse = function(url){
        var match = url.match(uriregexp) || {};
        var authority = match[4];
        var authReg = /((([\w]+)(:\w+)?)?@)?([\w.]+)(:(\d+))?/i;
        if(authority){
            var authMatch = authority.match(authReg) || [];
        }else{
            var authMatch = [];
        }
        return {
            protocol:match[1] || null
            ,pathname:match[5] || null
            ,path:match[5] && match[6] && match[5] + match[6] || match[5] || match[6] || null
            ,query:match[7] || null
            ,hash:match[8] || null
            ,port:authMatch[7] || null 
            ,auth:authMatch[2] || null
            ,hostname:authMatch[5] || null
            ,host:(authMatch[5] || "") + (authMatch[6] || "") || null
            ,search:match[6] || null
            ,href:url
        }
    }
    exports.url.format = function(urlObject){
        var result = "";
        if(urlObject.protocol)result+=urlObject.protocol+"//";
        if(urlObject.auth)result+=urlObject.auth+"@";
        if(urlObject.host)result+=urlObject.host;
        if(urlObject.pathname){
            result+=urlObject.pathname
        }else{
            //nodejs will add a / if no pathname present
            result+="/"
        }
        
        if(urlObject.search)result+=urlObject.search;
        if(urlObject.hash)result+=urlObject.hash;
        return result;
    }
    exports.url.resolve = function(base,target){
        if(target == "")return base;
        var targetObject = exports.url.parse(target);
        if(targetObject.protocol)return target;
        var baseObject = exports.url.parse(base);
        // in RFC resolve with #hash will result in #hash
        // in nodejs it will change the base hash
        if(target[0] == "#"){
            baseObject.hash = targetObject.hash;
            return exports.url.format(baseObject)
        }
        targetObject.protocol = baseObject.protocol;
        
        if(!targetObject.auth){
            targetObject.auth = baseObject.auth || "";
        }
        if(!targetObject.host){
            targetObject.host = baseObject.host
            if(targetObject.pathname){
                var targetSegments = targetObject.pathname.split("/");
                if(targetObject.pathname[0]=="/"){
                    // so only depends on targetObject
                    baseObject.pathname = "";
                }
                var baseSegments = baseObject.pathname.split("/");
                baseSegments.pop();
                baseSegments = baseSegments.filter(function(seg){return seg != "."});
                targetSegments.forEach(function(tseg,index){
                    if(tseg == ".."){
                        // resolve xxx://root/ with ../../../file result in xxx://root/file
                        // not xxx://root/../../../file
                        // but when no scheme/host available it behaves as RFC specs
                        // I will honour nodejs behavior.
                        if(targetSegments.host){
                            if(baseSegments.length >0 && baseSegments[baseSegments.length-1] != ".."){
                                baseSegments.pop();
                            }else{
                                baseSegments.push("..");
                            }
                        }else{
                            if(baseSegments.length >0){
                                baseSegments.pop();
                            }
                        }
                    }else if(tseg != "."){
                        baseSegments.push(tseg);
                    }else if (tseg == "." && index == targetSegments.length-1){
                        baseSegments.push("")
                    }
                })
                var _baseSegments = []
                var offset = 0;
                var result = baseSegments.join("/");
                // here also nodejs will prepend a / if it's empty
                //
                if((baseObject.pathname[0] == "/" || targetObject.pathname[0])&& result[0]!="/"){
                    result = "/"+result;
                }
                var last = targetSegments[targetSegments.length-1];
                if(last == ".." && result[result.length-1]!="/"){
                    result += "/";
                }
                result = exports.path.normalize(result);
                targetObject.pathname = result;
            }
            if(!targetObject.pathname){
                targetObject.pathname = baseObject.pathname;
            }
        }
        return exports.url.format(targetObject);
    }
    var pathReg = /(.*\/)?([^\/]+?)(\.[^\/\.]+)?$/i
    exports.path.dirname = function(path){
        return exports.path.normalize(path.match(pathReg)[1])
    }
    exports.path.basename = function(path){
        var match = path.match(pathReg)
        return match[2]+match[3]
    }
    exports.path.extname = function(path){
        var match = path.match(pathReg)
        return match[3]
    }
    exports.path.normalize = function(path){
        var segs = path.split("/");
        var result = [];
        var offset = 0;
        segs.forEach(function(seg,index){
            if(seg == ".."){
                if(result.length > offset){
                    result.pop();
                }else{
                    result.push("..");
                }
            }else if(seg == "."){
                return
            }else if(seg){
                result.push(seg)
            }else if(index < segs.length -1 && index != 0){
                return
            }else{
                result.push("");
            }
        })
        return result.join("/");
    }
    exports.path.join = function(){
        var args = [].slice.call(arguments,0)
        return exports.path.normalize(args.join("/"))
    }
    exports.path.resolve = exports.url.resolve;
})(exports || window)
