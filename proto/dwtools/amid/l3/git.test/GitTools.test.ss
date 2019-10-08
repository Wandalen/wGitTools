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

//

function gitHooksManager( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'repo' )
  let hooksPath = path.join( localPath, './.git/hooks' )

  let hookName = 'post-commit';
  let handlerName = hookName + '.custom';
  let originalHookPath = path.join( hooksPath, hookName );
  let hookHandlerPath = path.join( hooksPath, handlerName );
  let wasOriginalHookPath = originalHookPath + '.was'

  let handlerCodePath = path.join( testPath, hookName + '.source' );
  let handlerCode =
  `#!/bin/sh
    echo "Custom handler executed."
  `
  var specialComment = 'This script is generated by utility willbe';

  let ready = new _.Consequence().take( null )

  /*
    - No git repository
    - No hooks registered
    - User's hook already exists
    - User's hook was created by hookRegister, try to add another one
    - First hook handler returns bad exit code, second should not be executed
    - Try to register hook with existing handler name, previously registered handlers should work as before
  */

  .then( () =>
  {
    test.case = 'No git repository';

    provider.filesDelete( localPath );
    provider.fileWrite( handlerCodePath, handlerCode )

    test.shouldThrowErrorSync( () =>
    {
      _.git.hookRegister
      ({
        repoPath : localPath,
        filePath : handlerCodePath,
        hookName : hookName,
        handlerName : handlerName,
        throwing : 1,
        rewriting : 0
      })
    })

    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'No hooks registered';
    let con = begin();

    let shell = _.process.starter
    ({
      currentPath : localPath,
      outputCollecting : 1,
      ready : con
    })

    con.then( () =>
    {
      let files = provider.dirRead( hooksPath );
      let samples = files.filter( ( file ) => path.ext( file ) === 'sample' );
      test.will = 'only sample hooks are registered'
      test.identical( files.length, samples.length );

      test.will = 'original hook does not exist';
      test.is( !provider.fileExists( originalHookPath ) );

      test.will = 'copy of original hook does not exist';
      test.is( !provider.fileExists( wasOriginalHookPath ) );

      provider.fileWrite( handlerCodePath, handlerCode )

      _.git.hookRegister
      ({
        repoPath : localPath,
        filePath : handlerCodePath,
        hookName : hookName,
        handlerName : handlerName,
        throwing : 1,
        rewriting : 0
      })

      test.will = 'hook runner was created';
      test.is( provider.fileExists( originalHookPath ) );
      let hookRead = provider.fileRead( originalHookPath );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'hook handler was created'
      test.is( provider.fileExists( hookHandlerPath ) );
      let customHookRead = provider.fileRead( hookHandlerPath );
      test.identical( customHookRead,handlerCode );

      test.will = 'copy of original hook does not exist';
      test.is( !provider.fileExists( wasOriginalHookPath ) );

      return null;
    })

    shell( 'git commit --allow-empty -m test' )

    con.then( ( got ) =>
    {
      test.will = 'custom handler was executed after git commit';
      test.is( _.strHas( got.output, 'Custom handler executed' ) );
      return null;
    })

    return con;
  })

  /* */

  .then( () =>
  {
    test.case = 'User\'s hook already exists';
    let con = begin();

    let shell = _.process.starter
    ({
      currentPath : localPath,
      outputCollecting : 1,
      ready : con
    })

    con.then( () =>
    {
      let files = provider.dirRead( hooksPath );
      let samples = files.filter( ( file ) => path.ext( file ) === 'sample' );
      test.will = 'only sample hooks are registered'
      test.identical( files.length, samples.length );

      let originalUserHookCode =
      `#!/bin/sh
      echo "Original user hook."
      `
      provider.fileWrite( originalHookPath, originalUserHookCode );

      test.will = 'users hook exists';
      test.is( provider.fileExists( originalHookPath ) );

      test.will = 'copy of original hook does not exist';
      test.is( !provider.fileExists( wasOriginalHookPath ) );

      provider.fileWrite( handlerCodePath, handlerCode )

      _.git.hookRegister
      ({
        repoPath : localPath,
        filePath : handlerCodePath,
        hookName : hookName,
        handlerName : handlerName,
        throwing : 1,
        rewriting : 0
      })

      test.will = 'hook runner was created';
      test.is( provider.fileExists( originalHookPath ) );
      let hookRead = provider.fileRead( originalHookPath );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'hook handler was created'
      test.is( provider.fileExists( hookHandlerPath ) );
      let customHookRead = provider.fileRead( hookHandlerPath );
      test.identical( customHookRead,handlerCode );

      test.will = 'original hook was copied to .was';
      test.is( provider.fileExists( wasOriginalHookPath ) );
      let wasHook = provider.fileRead( wasOriginalHookPath );
      test.identical( wasHook, originalUserHookCode );

      return null;
    })

    shell( 'git commit --allow-empty -m test' )

    con.then( ( got ) =>
    {
      test.will = 'original handler was executed after git commit';
      test.is( _.strHas( got.output, 'Original user hook' ) );
      test.will = 'custom handler was executed after git commit';
      test.is( _.strHas( got.output, 'Custom handler executed' ) );
      return null;
    })

    return con;
  })

  /* */

  .then( () =>
  {
    test.case = 'User\'s hook was created by hookRegister, try to add another one';
    let con = begin();

    let shell = _.process.starter
    ({
      currentPath : localPath,
      outputCollecting : 1,
      ready : con
    })

    con.then( () =>
    {
      provider.fileWrite( handlerCodePath, handlerCode )
      _.git.hookRegister
      ({
        repoPath : localPath,
        filePath : handlerCodePath,
        hookName : hookName,
        handlerName : handlerName,
        throwing : 1,
        rewriting : 0
      })
      return null;
    })

    con.then( () =>
    {
      let handlerName2 = handlerName + '2';
      let hookHandlerPath2 = hookHandlerPath + '2';
      let handlerCodePath2 = handlerCodePath + '2'

      let handlerCode2 =
      `#!/bin/sh
      echo "Custom handler2 executed."
      `
      provider.fileWrite( handlerCodePath2, handlerCode2 )

      _.git.hookRegister
      ({
        repoPath : localPath,
        filePath : handlerCodePath2,
        hookName : hookName,
        handlerName : handlerName2,
        throwing : 1,
        rewriting : 0
      })

      test.will = 'hook runner was created';
      test.is( provider.fileExists( originalHookPath ) );
      let hookRead = provider.fileRead( originalHookPath );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler exists'
      test.is( provider.fileExists( hookHandlerPath ) );
      var customHookRead = provider.fileRead( hookHandlerPath );
      test.identical( customHookRead,handlerCode );

      test.will = 'second hook handler exists'
      test.is( provider.fileExists( hookHandlerPath2 ) );
      var customHookRead = provider.fileRead( hookHandlerPath2 );
      test.identical( customHookRead,handlerCode2 );

      test.will = 'copy of original hook does not exist';
      test.is( !provider.fileExists( wasOriginalHookPath ) );

      return null;
    })

    shell( 'git commit --allow-empty -m test' )

    con.then( ( got ) =>
    {
      test.will = 'custom handler1 was executed after git commit';
      test.is( _.strHas( got.output, 'Custom handler executed' ) );
      test.will = 'custom handler2 was executed after git commit';
      test.is( _.strHas( got.output, 'Custom handler2 executed' ) );
      return null;
    })

    return con;
  })

  /* */

  .then( () =>
  {
    test.case = 'First hook handler returns bad exit code, second should not be executed';

    let handlerCode2 =
    `#!/bin/sh
    echo "Bad exit code handler executed."
    exit 1
    `
    let handlerName2 = handlerName + '2';
    let hookHandlerPath2 = hookHandlerPath + '2';
    let handlerCodePath2 = handlerCodePath + '2'

    let con = begin();

    let shell = _.process.starter
    ({
      currentPath : localPath,
      outputCollecting : 1,
      ready : con
    })

    con.then( () =>
    {
      provider.fileWrite( handlerCodePath, handlerCode )
      provider.fileWrite( handlerCodePath2, handlerCode2 )

      _.git.hookRegister
      ({
        repoPath : localPath,
        filePath : handlerCodePath2,
        hookName : hookName,
        handlerName : handlerName,
        throwing : 1,
        rewriting : 0
      })

      //

      _.git.hookRegister
      ({
        repoPath : localPath,
        filePath : handlerCodePath,
        hookName : hookName,
        handlerName : handlerName2,
        throwing : 1,
        rewriting : 0
      })

      //

      test.will = 'hook runner was created';
      test.is( provider.fileExists( originalHookPath ) );
      let hookRead = provider.fileRead( originalHookPath );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler exists'
      test.is( provider.fileExists( hookHandlerPath ) );
      var customHookRead = provider.fileRead( hookHandlerPath );
      test.identical( customHookRead,handlerCode2 );

      test.will = 'second hook handler exists'
      test.is( provider.fileExists( hookHandlerPath2 ) );
      var customHookRead = provider.fileRead( hookHandlerPath2 );
      test.identical( customHookRead,handlerCode );

      test.will = 'copy of original hook does not exist';
      test.is( !provider.fileExists( wasOriginalHookPath ) );

      return null;
    })

    shell( 'git commit --allow-empty -m test' )

    con.then( ( got ) =>
    {
      test.will = 'custom handler was executed after git commit';
      test.is( _.strHas( got.output, 'Bad exit code handler executed' ) );
      test.will = 'custom handler2 was not executed after git commit';
      test.is( !_.strHas( got.output, 'Custom handler executed' ) );
      return null;
    })

    return con;
  })

  /* */

  .then( () =>
  {
    test.case = 'Try to register hook with existing handler name, previously registered handlers should work as before';
    let con = begin();

    let shell = _.process.starter
    ({
      currentPath : localPath,
      outputCollecting : 1,
      ready : con
    })

    con.then( () =>
    {
      provider.fileWrite( handlerCodePath, handlerCode )
      _.git.hookRegister
      ({
        repoPath : localPath,
        filePath : handlerCodePath,
        hookName : hookName,
        handlerName : handlerName,
        throwing : 1,
        rewriting : 0
      })
      return null;
    })

    con.then( () =>
    {
      let hooksBefore = provider.dirRead( hooksPath );
      let hookRunnerBefore =  provider.fileRead( originalHookPath );

      test.shouldThrowErrorSync( () =>
      {
        _.git.hookRegister
        ({
          repoPath : localPath,
          filePath : handlerCodePath,
          hookName : hookName,
          handlerName : handlerName,
          throwing : 1,
          rewriting : 0
        })
      })

      let hooksAfter = provider.dirRead( hooksPath );

      test.identical( hooksAfter, hooksBefore );

      test.will = 'hook runner was not changed created';
      let hookRunnerNow = provider.fileRead( originalHookPath );
      test.identical( hookRunnerNow, hookRunnerBefore );

      test.will = 'custom hook was not changed'
      test.is( provider.fileExists( hookHandlerPath ) );
      var customHookRead = provider.fileRead( hookHandlerPath );
      test.identical( customHookRead,handlerCode );

      test.will = 'copy of original hook does not exist';
      test.is( !provider.fileExists( wasOriginalHookPath ) );

      return null;
    })

    shell( 'git commit --allow-empty -m test' )

    con.then( ( got ) =>
    {
      test.will = 'only one custom handler was executed';
      test.identical( _.strCount( got.output, 'Running .git/hooks/post-commit' ), 1 );
      test.identical( _.strCount( got.output, 'Custom handler executed' ), 1 );
      return null;
    })

    return con;
  })

  /* */

  return ready;

  /* - */

  function begin()
  {
    let con = new _.Consequence().take( null );

    let shell = _.process.starter
    ({
      currentPath : localPath,
      ready : con
    })

    con.then( () =>
    {
      provider.filesDelete( localPath );
      provider.dirMake( localPath );
      let filesTree =
      {
        'proto' :
        {
          'Tools.s' : 'Tools'
        }
      }
      let extract = new _.FileProvider.Extract({ filesTree })
      extract.filesReflectTo( provider, localPath );
      return null;
    })

    shell( 'git init' )
    shell( 'git add .' )
    shell( 'git commit -m init' )

    return con;
  }
}

//

function hook( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );

  provider.dirMake( testPath );

  let con = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    currentPath : testPath,
    throwingExitCode : 0,
    outputCollecting : 1,
    ready : con
  })

  shell( 'git init' )

  .then( () =>
  {
    let sourceCode = '#!/usr/bin/env node\n' +  'process.exit( 1 )';
    let tempPath = _.process.tempOpen({ sourceCode : sourceCode });
    _.git.hookRegister
    ({
      repoPath : testPath,
      filePath : tempPath,
      handlerName : 'pre-commit.commitHandler',
      hookName : 'pre-commit',
      throwing : 1,
      rewriting : 0
    })
    _.process.tempClose({ filePath : tempPath });
    test.is( provider.fileExists( path.join( testPath, './.git/hooks/pre-commit' ) ) );
    test.is( provider.fileExists( path.join( testPath, './.git/hooks/pre-commit.commitHandler' ) ) );

    return null;
  })

  shell( 'git commit --allow-empty -m test' )
  shell( 'git log -n 1' )

  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );
    test.is( _.strHas( got.output, `your current branch 'master' does not have any commits yet` ) );
    return got;
  })

  .then( () =>
  {
    test.is( provider.fileExists( path.join( testPath, './.git/hooks/pre-commit' ) ) );
    test.is( provider.fileExists( path.join( testPath, './.git/hooks/pre-commit.commitHandler' ) ) );

    _.git.hookUnregister
    ({
      repoPath : testPath,
      handlerName : 'pre-commit.commitHandler',
      force : 0,
      throwing : 1
    })

    test.is( provider.fileExists( path.join( testPath, './.git/hooks/pre-commit' ) ) );
    test.is( !provider.fileExists( path.join( testPath, './.git/hooks/pre-commit.commitHandler' ) ) );

    return null;
  })

  shell( 'git commit --allow-empty -m test' )
  shell( 'git log -n 1' )

  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, `test` ) );
    return got;
  })

  return con;

}

//

function hookPreservingHardLinks( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'clone' );
  let repoPath = path.join( testPath, 'repo' );
  let repoPathNative = path.nativize( repoPath );

  let con = new _.Consequence().take( null );

  let shellClone = _.process.starter
  ({
    currentPath : localPath,
    ready : con
  })

  let shellRepo = _.process.starter
  ({
    currentPath : repoPath,
    ready : con
  })

  let filesTree =
  {
    'a' : 'a',
    'b' : 'b',
    'c' : 'c',
    'dir' :
    {
      'a' : 'a',
      'b' : 'b',
      'c' : 'c1'
    }
  }
  let extract = _.FileProvider.Extract({ filesTree });

  /* */

  prepareRepo()
  prepareClone()

  /*  */

  .then( () =>
  {
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'a', 'b' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'b', 'c' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'a', 'b', 'c' ] ) ), false );

    test.identical( provider.filesAreHardLinked( path.s.join( localPath, 'dir', [ 'a', 'b' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, 'dir', [ 'b', 'c' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, 'dir', [ 'a', 'b', 'c' ] ) ), false );

    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'a', 'dir/a' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'b', 'dir/b' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'c', 'dir/c' ] ) ), false );

    return null;
  })

  .then( () => _.git.hookPreservingHardLinksRegister( localPath ) );

  shellRepo( 'git commit --allow-empty -m test' )
  shellClone( 'git pull' )

  .then( () =>
  {
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'a', 'b' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'b', 'c' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'a', 'b', 'c' ] ) ), false );

    test.identical( provider.filesAreHardLinked( path.s.join( localPath, 'dir', [ 'a', 'b' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, 'dir', [ 'b', 'c' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, 'dir', [ 'a', 'b', 'c' ] ) ), false );

    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'a', 'dir/a' ] ) ), true );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'b', 'dir/b' ] ) ), true );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'c', 'dir/c' ] ) ), false );

    debugger

    return null;
  })

  .then( () => _.git.hookPreservingHardLinksUnregister( localPath ) )

  .then( () =>
  {
    provider.fileWrite( path.join( repoPath, 'a' ), 'a1' )
    provider.fileWrite( path.join( repoPath, 'b' ), 'b1' )
    provider.fileWrite( path.join( repoPath, 'c' ), 'c1' )
    return null;
  })

  shellRepo( 'git add .' )
  shellRepo( 'git commit --allow-empty -m test2' )
  shellClone( 'git pull' )

  .then( () =>
  {
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'a', 'b' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'b', 'c' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'a', 'b', 'c' ] ) ), false );

    test.identical( provider.filesAreHardLinked( path.s.join( localPath, 'dir', [ 'a', 'b' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, 'dir', [ 'b', 'c' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, 'dir', [ 'a', 'b', 'c' ] ) ), false );

    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'a', 'dir/a' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'b', 'dir/b' ] ) ), false );
    test.identical( provider.filesAreHardLinked( path.s.join( localPath, [ 'c', 'dir/c' ] ) ), false );

    return null;
  })

  return con;

  /*  */

  function prepareRepo()
  {
    con.then( () =>
    {
      provider.filesDelete( testPath );
      provider.dirMake( testPath )
      provider.dirMake( repoPath )

      extract.filesReflectTo( provider, repoPath );
      return null;
    })

    shellRepo( 'git init' )
    shellRepo( 'git add .' )
    shellRepo( 'git commit -m init' )

    return con;
  }

  //

  function prepareClone()
  {
    con.then( () =>
    {
      provider.filesDelete( localPath );
      provider.dirMake( localPath );

      return _.process.start
      ({
        execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
        currentPath : testPath
      })
    })

    return con;
  }

}

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
    hasLocalChanges,

    gitHooksManager,

    hook,
    hookPreservingHardLinks,

  },

}

//

var Self = new wTestSuite( Proto )/* .inherit( Parent ); */
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
