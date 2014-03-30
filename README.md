# browser-path
 
A browser version of nodejs path/url module.

# test

coffee test.coffee


# example

```javascript
// after include in html or what ever just load it.
var path = window.path
path.join("/home/user","media/music") 
// /home/user/media/music

url.resolve("http://test.example.com/start/child?key=value","../target/child?key2=value2")
// http://test.example.com/target/child?key2=value2
```

# support API
* url.parse
* url.format
* url.resolve
* path.dirname
* path.basename
* path.extname
* path.normalize
* path.join
* path.resolve