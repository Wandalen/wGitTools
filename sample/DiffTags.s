
require( 'wgittools' );
let _ = wTools;

/* Diff local tag 0.3.48 with tag v0.3.36 on remote "origin" */

var got =  _.git.diff
({
  localPath : _.path.join( __dirname, '..' ),
  state1 : '!0.3.48',
  state2 : '!origin/v0.3.36',
  generatingPatch : 0,
  detailing : 1,
  explaining : 1,
  fetchTags : 1
});

console.log( _.toStr( got.status ) )

