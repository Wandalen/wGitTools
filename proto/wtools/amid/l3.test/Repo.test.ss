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
  /* - */

  test.case = 'no vcs'
  var vcs = _.repo.vcsFor( 'xxx:///' );
  test.identical( vcs, null );

  /* - */

  test.case = 'git'
  var vcs = _.repo.vcsFor( 'git+https:///' );
  if( _.git )
  test.identical( vcs, _.git );
  else
  test.identical( vcs, null );

  /* - */

  test.case = 'npm'
  var vcs = _.repo.vcsFor( 'npm:///' );
  if( _.npm )
  test.identical( vcs, _.npm );
  else
  test.identical( vcs, null );

  /* - */

  test.case = 'special'
  var vcs = _.repo.vcsFor( [] );
  test.identical( vcs, null );

  /* - */

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => _.repo.vcsFor() )
  test.shouldThrowErrorSync( () => _.repo.vcsFor({ filePath : 1 }) )
  test.shouldThrowErrorSync( () => _.repo.vcsFor({ filePath : '/' }) )
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
