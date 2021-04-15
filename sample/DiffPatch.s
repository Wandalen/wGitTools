
require( 'wgittools' );
let _ = wTools;

/* Generates diff patch with colors and minimal amount of context*/

var got =  _.git.diff
({
  localPath : _.path.join( __dirname, '..' ),
  state1 : '#abc6e1da8be34f69d24af6f90f323816a9d83f3b',
  state2 : '!v0.3.306',
  generatingPatch : 1,
  coloredPatch : 1,
  linesOfContext : 0,
  detailing : 1,
  explaining : 1
});

console.log( `Status : ${ _.entity.exportString( got.status ) }` );
console.log( `Patch : ${ _.entity.exportString( got.patch ) }` );

