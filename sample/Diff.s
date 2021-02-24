
require( 'wgittools' );
let _ = wTools;

var got =  _.git.diff
({
  localPath : _.path.join( __dirname, '..' ),
  state1 : 'working',
  state2 : 'HEAD~1',
  generatingPatch : 0,
  detailing : 1,
  explaining : 1,
  fetchTags : 1
});

console.log( _.entity.exportString( got.status ) )

