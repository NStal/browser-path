path = require "./path.js"
url = require "url"
testURL = "https://wuminghan:12345@a.b.cgithub.com:8080/NStal/pywebquery?abd=123#asd=5"
testURL = "http://example/file?abc=2"
obj = path.url.parse testURL
obj2 = url.parse testURL
for prop of obj
    console.log "test property",prop
    console.assert obj[prop] is obj2[prop]

from = "1/2?abd=123#asd=5?asd=sss#123"
to ="a/../../../?asd=123#123454"
from = "http://example/file?abc=2"
to = "a/../../../b/../../../c/d/e/d/../.././x/y/z?abc=123"

#console.log "mine",path.url.resolve from,to
#console.log "their",url.resolve from,to


uris = [
		['http://a/b/c/d;p?q', 'g:h'          , 'g:h'],
		['http://a/b/c/d;p?q', 'g'            , 'http://a/b/c/g'],
		['http://a/b/c/d;p?q', './g'          , 'http://a/b/c/g'],
		['http://a/b/c/d;p?q', 'g/'           , 'http://a/b/c/g/'],
		['http://a/b/c/d;p?q', '/g'           , 'http://a/g'],
		['http://a/b/c/d;p?q', '//g'          , 'http://g'],
		['http://a/b/c/d;p?q', '?y'           , 'http://a/b/c/?y'],
		['http://a/b/c/d;p?q', 'g?y'          , 'http://a/b/c/g?y'],
		['http://a/b/c/d;p?q', '#s'           , '#s'],
		['http://a/b/c/d;p?q', 'g#s'          , 'http://a/b/c/g#s'],
		['http://a/b/c/d;p?q', 'g?y#s'        , 'http://a/b/c/g?y#s'],
		['http://a/b/c/d;p?q', ';x'           , 'http://a/b/c/;x'],
		['http://a/b/c/d;p?q', 'g;x'          , 'http://a/b/c/g;x'],
		['http://a/b/c/d;p?q', 'g;x?y#s'      , 'http://a/b/c/g;x?y#s'],
		['http://a/b/c/d;p?q', '.'            , 'http://a/b/c/'],
		['http://a/b/c/d;p?q', './'           , 'http://a/b/c/'],
		['http://a/b/c/d;p?q', '..'           , 'http://a/b/'],
		['http://a/b/c/d;p?q', '../'          , 'http://a/b/'],
		['http://a/b/c/d;p?q', '../g'         , 'http://a/b/g'],
		['http://a/b/c/d;p?q', '../..'        , 'http://a/'],
		['http://a/b/c/d;p?q', '../../'       , 'http://a/'],
		['http://a/b/c/d;p?q', '../../g'      , 'http://a/g'],
		['http://a/b/c/d;p?q', ''             , ''],
		['http://a/b/c/d;p?q', '../../../g'   , 'http://a/../g'],
		['http://a/b/c/d;p?q', '../../../../g', 'http://a/../../g'],
		['http://a/b/c/d;p?q', '/./g'         , 'http://a/./g'],
		['http://a/b/c/d;p?q', '/../g'        , 'http://a/../g'],
		['http://a/b/c/d;p?q', 'g.'           , 'http://a/b/c/g.'],
		['http://a/b/c/d;p?q', '.g'           , 'http://a/b/c/.g'],
		['http://a/b/c/d;p?q', 'g..'          , 'http://a/b/c/g..'],
		['http://a/b/c/d;p?q', '..g'          , 'http://a/b/c/..g'],
		['http://a/b/c/d;p?q', './../g'       , 'http://a/b/g'],
		['http://a/b/c/d;p?q', './g/.'        , 'http://a/b/c/g/'],
		['http://a/b/c/d;p?q', 'g/./h'        , 'http://a/b/c/g/h'],
		['http://a/b/c/d;p?q', 'g/../h'       , 'http://a/b/c/h'],
		['http://a/b/c/d;p?q', 'g;x=1/./y'    , 'http://a/b/c/g;x=1/y'],
		['http://a/b/c/d;p?q', 'g;x=1/../y'   , 'http://a/b/c/y'],
		['http://a/b/c/d;p?q', 'g?y/./x'      , 'http://a/b/c/g?y/./x'],
		['http://a/b/c/d;p?q', 'g?y/../x'     , 'http://a/b/c/g?y/../x'],
		['http://a/b/c/d;p?q', 'g#s/./x'      , 'http://a/b/c/g#s/./x'],
		['http://a/b/c/d;p?q', 'g#s/../x'     , 'http://a/b/c/g#s/../x']
	];
fails = []
for test,index in uris
    console.log "test=>",test.join("	")
    mine = path.url.resolve test[0],test[1]
    theirs = url.resolve test[0],test[1]
    expect = test[2]
#    console.log "mine",mine
#    console.log "theirs",theirs
    if mine isnt theirs
        fails.push [test,mine,theirs,index]
for fail in fails
    test = fail[0]
    mine = path.url.resolve(test[0],test[1])
    mineBase = path.url.parse(test[0])
    mineTarget = path.url.parse(test[1])
    console.log mineBase,mineTarget
    
    console.log "index:",fail[3]
    console.log "CASE",fail[0]
    console.log "mine",fail[1]
    console.log "node",fail[2]
    process.exit(0)
dir = "/home/wuminghan/./../wuminghan/test.config.json"
console.log path.path.dirname dir
console.log path.path.extname dir
console.log path.path.basename dir
console.log path.path.normalize dir
console.log path.path.join dir,"../test.coffee"
console.log path.path.resolve dir,"../test.coffee/abc.config"
console.log path.url.resolve '/a/b/c/./../d;p?q', '../g', 'http://a/b/g'