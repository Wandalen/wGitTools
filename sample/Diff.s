
require( 'wgittools' );
let _ = wTools;

var got =  _.git.diff
({
  localPath : _.path.join( __dirname, '..' ),
  state1 : '#abc6e1da8be34f69d24af6f90f323816a9d83f3b',
  state2 : '!v0.3.306',
  generatingPatch : 0,
  detailing : 1,
  explaining : 1,
  fetchTags : 1
});

console.log( _.entity.exportString( got.status ) );

