( function _GitTools_test_ss_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../Tools.s' );

  _.include( 'wTesting' );

  require( '../git/IncludeMid.s' );
}

//

var _ = _global_.wTools;

//

function onSuiteBegin( test )
{
  let context = this;
  context.provider = _.fileProvider;
  let path = context.provider.path;
  context.suitePath = context.provider.path.pathDirTempOpen( path.join( __dirname, '../..'  ),'GitTools' );
  context.suitePath = context.provider.pathResolveLinkFull({ filePath : context.suitePath, resolvingSoftLink : 1 });
  context.suitePath = context.suitePath.absolutePath;

}

function onSuiteEnd( test )
{
  let context = this;
  let path = context.provider.path;
  _.assert( _.strHas( context.suitePath, 'GitTools' ), context.suitePath );
  path.pathDirTempClose( context.suitePath );
}

// --
// tests
// --

function versionsRemoteRetrive( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'clone' );
  let repoPath = path.join( testPath, 'repo' );
  let repoPathNative = path.nativize( repoPath );
  let remotePath = 'https://github.com/Wandalen/wPathBasic.git';

  let con = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    currentPath : localPath,
    ready : con
  })

  let shell2 = _.process.starter
  ({
    currentPath : repoPath,
    ready : con
  })

  provider.dirMake( testPath );

  /* */

  con.then( () =>
  {
    test.case = 'not git repository';
    return test.shouldThrowErrorAsync( _.git.versionsRemoteRetrive({ localPath }) );
  })

  .then( () =>
  {
    test.case = 'setup repo';
    provider.filesDelete( repoPath );
    return _.process.start
    ({
      execPath : 'git clone ' + remotePath + ' ' + path.name( repoPath ),
      currentPath : testPath,
    })
  })

  /* */

  .then( () =>
  {
    test.case = 'setup';
    provider.filesDelete( localPath );
    return _.process.start
    ({
      execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
      currentPath : testPath,
    })
  })

  /* */

  .then( () => _.git.versionsRemoteRetrive({ localPath }) )
  .then( ( got ) =>
  {
    test.identical( got, [ 'master'] );
    return got;
  })

  /* */

  shell2( 'git checkout -b feature' )
  .then( () => _.git.versionsRemoteRetrive({ localPath }) )
  .then( ( got ) =>
  {
    test.case = 'remote has new branch, clone is outdated'
    test.identical( got, [ 'master' ] );
    return got;
  })

  shell( 'git fetch' )
  .then( () => _.git.versionsRemoteRetrive({ localPath }) )
  .then( ( got ) =>
  {
    test.case = 'remote has new branch, clone is up-to-date'
    test.identical( got, [ 'feature', 'master' ] );
    return got;
  })

  shell2( 'git checkout master' )
  shell2( 'git branch -d feature' )
  .then( () => _.git.versionsRemoteRetrive({ localPath }) )
  .then( ( got ) =>
  {
    test.case = 'remote removed new branch, clone is outdated'
    test.identical( got, [ 'feature', 'master' ] );
    return got;
  })

  shell( 'git fetch -p' )
  .then( () => _.git.versionsRemoteRetrive({ localPath }) )
  .then( ( got ) =>
  {
    test.case = 'remote removed new branch, clone is up-to-date'
    test.identical( got, [ 'master' ] );
    return got;
  })

  return con;
}

//

function versionsPull( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'clone' );
  let repoPath = path.join( testPath, 'repo' );
  let repoPathNative = path.nativize( repoPath );
  let remotePath = 'https://github.com/Wandalen/wPathBasic.git';

  let con = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    currentPath : localPath,
    ready : con
  })

  let shell2 = _.process.starter
  ({
    currentPath : repoPath,
    ready : con
  })

  provider.dirMake( testPath );

  /* */

  con.then( () =>
  {
    test.case = 'not git repository';
    return test.shouldThrowErrorAsync( _.git.versionsPull({ localPath }) );
  })

  .then( () =>
  {
    test.case = 'setup repo';
    provider.filesDelete( repoPath );
    return _.process.start
    ({
      execPath : 'git clone ' + remotePath + ' ' + path.name( repoPath ),
      currentPath : testPath,
    })
  })

  /* */

  .then( () =>
  {
    test.case = 'setup';
    provider.filesDelete( localPath );
    return _.process.start
    ({
      execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
      currentPath : testPath,
    })
  })

  /* */

  con.then( () =>
  {
    test.case = 'no changes';
    return _.git.versionsPull({ localPath });
  })
  .then( () => _.git.versionsRemoteRetrive({ localPath }) )
  .then( ( got ) =>
  {
    test.identical( got, [ 'master' ] );
    let execPath = got.map(( branch ) => `git checkout ${branch} && git status` )
    return _.process.start
    ({
      execPath : execPath,
      outputCollecting : 1,
      throwingExitCode : 0,
      mode : 'shell',
      currentPath : localPath,
    })
  })
  .then( ( got ) =>
  {
    test.identical( got.length, 1 );
    _.each( got, ( result ) =>
    {
      test.identical( result.exitCode, 0 );
      test.is( _.strHas( result.output, 'is up to date' ) );
    })
    return null;
  })

  /* */

  con.then( () =>
  {
    test.case = 'new branch on remote';
    return null;
  })
  shell2( 'git checkout -b feature' )
  shell( 'git fetch' )
  .then( () => _.git.versionsPull({ localPath }) )
  .then( () => _.git.versionsRemoteRetrive({ localPath }) )
  .then( ( got ) =>
  {
    test.identical( got, [ 'feature', 'master' ] );
    let execPath = got.map(( branch ) => `git checkout ${branch} && git status` )
    return _.process.start
    ({
      execPath : execPath,
      outputCollecting : 1,
      throwingExitCode : 0,
      mode : 'shell',
      currentPath : localPath,
    })
  })
  .then( ( got ) =>
  {
    test.identical( got.length, 2 );
    _.each( got, ( result ) =>
    {
      test.identical( result.exitCode, 0 );
      test.is( _.strHas( result.output, 'is up to date' ) );
    })
    return null;
  })

  /* */

  con.then( () =>
  {
    test.case = 'new commits on remote';
    return null;
  })
  shell2( 'git checkout master' )
  shell2( 'git commit --allow-empty -m test1' )
  shell2( 'git checkout feature' )
  shell2( 'git commit --allow-empty -m test2' )
  shell( 'git fetch' )
  .then( () => _.git.versionsPull({ localPath }) )
  .then( () => _.git.versionsRemoteRetrive({ localPath }) )
  .then( ( got ) =>
  {
    test.identical( got, [ 'feature', 'master' ] );
    let execPath = got.map(( branch ) => `git checkout ${branch} && git status` )
    return _.process.start
    ({
      execPath : execPath,
      outputCollecting : 1,
      throwingExitCode : 0,
      mode : 'shell',
      currentPath : localPath,
    })
  })
  .then( ( got ) =>
  {
    test.identical( got.length, 2 );
    _.each( got, ( result ) =>
    {
      test.identical( result.exitCode, 0 );
      test.is( _.strHas( result.output, 'is up to date' ) );
    })
    return null;
  })

  return con;
}

//

function hasLocalChanges( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'clone' );
  let repoPath = path.join( testPath, 'repo' );
  let repoPathNative = path.nativize( repoPath );
  let remotePath = 'https://github.com/Wandalen/wPathBasic.git';
  let filePath = path.join( localPath, 'newFile' );
  let readmePath = path.join( localPath, 'README' );

  let con = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    currentPath : localPath,
    ready : con
  })

  let shell2 = _.process.starter
  ({
    currentPath : repoPath,
    ready : con
  })

  provider.dirMake( testPath )

  /* */

  con.then( () =>
  {
    test.case = 'setup repo';
    provider.filesDelete( repoPath );
    return _.process.start
    ({
      execPath : 'git clone ' + remotePath + ' ' + path.name( repoPath ),
      currentPath : testPath,
    })
  })

  /* */

  .then( () =>
  {
    test.case = 'repository is not downloaded'
    return test.shouldThrowErrorSync( () => _.git.hasLocalChanges({ localPath }) )
  })

  /* */

  .then( () =>
  {
    test.case = 'clean clone';
    provider.filesDelete( localPath );
    return _.process.start
    ({
      execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
      currentPath : testPath,
    })
  })
  .then( () =>
  {
    test.case = 'check after fresh clone'
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, false );
    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'clean clone';
    provider.filesDelete( localPath );
    return _.process.start
    ({
      execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
      currentPath : testPath,
    })
  })
  .then( () =>
  {
    test.case = 'new untraked file'
    provider.fileWrite( filePath, filePath );
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git add newFile' )
  .then( () =>
  {
    test.case = 'new staged file'
    test.is( provider.fileExists( filePath ) );
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'clean clone';
    provider.filesDelete( localPath );
    return _.process.start
    ({
      execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
      currentPath : testPath,
    })
  })
  .then( () =>
  {
    test.case = 'change in existing file'
    provider.fileWrite( readmePath, readmePath );
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'clean clone';
    provider.filesDelete( localPath );
    return _.process.start
    ({
      execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
      currentPath : testPath,
    })
  })
  shell2( 'git commit --allow-empty -m testcommit' )
  .then( () =>
  {
    test.case = 'remote has new commit';
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, false );
    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'clean clone';
    provider.filesDelete( localPath );
    return _.process.start
    ({
      execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
      currentPath : testPath,
    })
  })
  shell2( 'git commit --allow-empty -m testcommit' )
  shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'remote has new commit, local executed fetch without merge';
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, false );
    return null;
  })

  /*  */

  .then( () =>
  {
    test.case = 'clean clone';
    provider.filesDelete( localPath );
    return _.process.start
    ({
      execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
      currentPath : testPath,
    })
  })
  shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'new local commit'
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'clean clone';
    provider.filesDelete( localPath );
    return _.process.start
    ({
      execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
      currentPath : testPath,
    })
  })
  shell( 'git commit --allow-empty -m test' )
  shell2( 'git commit --allow-empty -m testcommit' )
  .then( () =>
  {
    test.case = 'local and remote has has new commit';
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'clean clone';
    provider.filesDelete( localPath );
    return _.process.start
    ({
      execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
      currentPath : testPath,
    })
  })
  shell( 'git commit --allow-empty -m test' )
  shell2( 'git commit --allow-empty -m testcommit' )
  shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'local and remote has has new commit, local executed fetch without merge';
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })

  return con;
}

hasLocalChanges.timeOut = 30000;

// --
// declare
// --

var Proto =
{

  name : 'Tools.mid.GitTools',
  abstract : 0,
  silencing : 1,
  enabled : 1,
  verbosity : 4,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    provider : null,
    suitePath : null,
  },

  tests :
  {
    versionsRemoteRetrive,
    versionsPull,
    hasLocalChanges
  },

}

//

var Self = new wTestSuite( Proto )/* .inherit( Parent ); */
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
