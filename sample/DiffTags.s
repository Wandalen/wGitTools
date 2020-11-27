
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

/* Diff local tag 0.0.38 with tag v0.0.46 on remote "origin" */

ready.then( () =>
{
  var got =  _.git.diff
  ({
    localPath : _.path.join( _.path.current(), 'wModuleForTesting1' ),
    state1 : '!0.0.104',
    state2 : '!origin/v0.0.96',
    generatingPatch : 0,
    detailing : 1,
    explaining : 1,
    fetchTags : 1
  });

  console.log( _.toStr( got.status ) );
  return null;
});

/* clear */

ready.then( () =>
{
  provider.filesDelete( _.path.join( _.path.current(), 'wModuleForTesting1' ) );
  return null;
});


