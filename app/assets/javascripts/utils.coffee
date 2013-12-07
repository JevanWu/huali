class Utils
  @basename: (url) ->
    base = new String(url).substring(url.lastIndexOf('/') + 1)
    if base.lastIndexOf(".") != -1
      base = base.substring(0, base.lastIndexOf("."))

    return base

  @dirname: (url) ->
    # http://kevin.vanzonneveld.net
    # +   original by: Ozh
    # +   improved by: XoraX (http://www.xorax.info)
    # *     example 1: dirname('/etc/passwd');
    # *     returns 1: '/etc'
    # *     example 2: dirname('c:/Temp/x');
    # *     returns 2: 'c:/Temp'
    # *     example 3: dirname('/dir/test/');
    # *     returns 3: '/dir'
    return url.replace(/\\/g, '/').replace(/\/[^\/]*\/?$/, '')

window.Utils = Utils
