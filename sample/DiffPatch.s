
require( 'wgittools' );
let _ = wTools;
_.include( 'wFiles' );
_.include( 'wProcess' );

/* */

let ready = _.take( null );
let provider = _.FileProvider.HardDrive();

/* clone repository */

ready.then( () =>
{
  return _.process.start
  ({
    currentPath : '.',
    execPath : 'git clone https://github.com/Wandalen/wModuleForTesting1.git',
    mode : 'shell',
    sync : 1,
  });
});

/* Generates diff patch with colors and minimal amount of context */

ready.then( () =>
{
  var got =  _.git.diff
  ({
    localPath : _.path.join( _.path.current(), 'wModuleForTesting1' ),
    state1 : 'working',
    state2 : 'HEAD~1',
    generatingPatch : 1,
    coloredPatch : 1,
    linesOfContext : 0,
    detailing : 1,
    explaining : 1
  });

  console.log( `Status:${_.toStr( got.status )}` );
  console.log( `Patch:${_.toStr( got.patch )}` );
  return null;
});

/* clear */

ready.then( () =>
{
  provider.filesDelete( _.path.join( _.path.current(), 'wModuleForTesting1' ) );
  return null;
});

