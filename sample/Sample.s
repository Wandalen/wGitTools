require( '..' );
let _ = wTools;

var got =  _.git.status
({
  localPath : _.path.join( __dirname, '..' ),
  detailing : 1
});

console.log( _.toStr( got ) )
