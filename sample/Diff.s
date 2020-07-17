
require( '..' );
let _ = wTools;

var got =  _.git.diff
({ 
  localPath : _.path.join( __dirname, '..' ),
  state1 : 'working',
  state2 : 'tag::v0.3.36',
  attachOriginalDiffOutput : 1,
  detailing : 1,
  explaining : 1
});

console.log( _.toStr( got.status ) )

