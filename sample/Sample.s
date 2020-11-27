
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

/* get status */

ready.then( () =>
{
  var got =  _.git.status
  ({
    localPath : _.path.join( _.path.current(), 'wModuleForTesting1' ),
    detailing : 1
  });

  console.log( _.toStr( got ) );
  return null;
});

/* clear */

ready.then( () =>
{
  provider.filesDelete( _.path.join( _.path.current(), 'wModuleForTesting1' ) );
  return null;
});

