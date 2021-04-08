( function _Repo_test_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wTesting' );

  require( '../l3/git/entry/GitTools.ss' );
}

//

const _ = _global_.wTools;

// --
// tests
// --

function vcsFor( test )
{
  test.case = 'trivial'

  /* - */

  var vcs = _.repo.vcsFor( '/' );
  test.identical( vcs, null );

  /* - */

  var vcs = _.repo.vcsFor( 'git+https:///' );
  test.identical( vcs, _.git );

  /* - */

  if( _.npm ) //qqq: remove after move to wRepo
  {
    var vcs = _.repo.vcsFor( 'npm:///' );
    test.identical( vcs, _.npm );
  }

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => _.repo.vcsFor() )
  test.shouldThrowErrorSync( () => _.repo.vcsFor({ filePath : 1 }) )
}

// --
// declare
// --

const Proto =
{

  name : 'Tools.mid.Repo',
  abstract : 0,
  silencing : 1,
  enabled : 1,
  verbosity : 4,

  tests :
  {
    vcsFor
  },

};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
