
require( 'wgittools' );
let _ = wTools;

/* Generates diff patch with colors and minimal amount of context*/

var got =  _.git.diff
({
  localPath : _.path.join( __dirname, '..' ),
  state1 : 'working',
  state2 : 'HEAD~1',
  generatingPatch : 1,
  coloredPatch : 1,
  linesOfContext : 0,
  detailing : 1,
  explaining : 1
});

console.log( `Status:${_.toStr( got.status )}` )
console.log( `Patch:${_.toStr( got.patch )}` )

