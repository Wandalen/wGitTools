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
  prepareRepo()

  /* */

  .then( () =>
  {
    test.case = 'repository is not downloaded'
    return test.shouldThrowErrorSync( () => _.git.hasLocalChanges({ localPath }) )
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'check after fresh clone'
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 1  });
    test.identical( got, false );
    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'new untraked file'
    provider.fileWrite( filePath, filePath );
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 1  });
    test.identical( got, true );
    return null;
  })
  shell( 'git add newFile' )
  .then( () =>
  {
    test.case = 'new staged file'
    test.is( provider.fileExists( filePath ) );
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 1  });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'unstaged change in existing file'
    provider.fileWrite( readmePath, readmePath );
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 1  });
    test.identical( got, true );
    return null;
  })
  shell( 'git add README' )
  .then( () =>
  {
    test.case = 'unstaged change in existing file'
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 1  });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  .then( () =>
  {
    test.case = 'remote has new commit';
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 1  });
    test.identical( got, false );
    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'remote has new commit, local executed fetch without merge';
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, uncommitted : 1  });
    test.identical( got, false );
    return null;
  })
  shell( 'git merge' )
  .then( () =>
  {
    test.case = 'merge after fetch, remote had new commit';
    var got = _.git.hasLocalChanges({ localPath, unpushedCommits : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedCommits : 1  });
    test.identical( got, false );
    return null;
  })

  /*  */

  begin()
  shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'new local commit'
    var got = _.git.hasLocalChanges({ localPath, unpushedCommits : false  });
    test.identical( got, false );
    test.case = 'new local commit'
    var got = _.git.hasLocalChanges({ localPath, unpushedCommits : true });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'local and remote has has new commit';
    var got = _.git.hasLocalChanges({ localPath, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedCommits : true  });
    test.identical( got, true );
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommitToBranch( 'testCommit', 'feature' )
  shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local executed fetch without merge';
    var got = _.git.hasLocalChanges({ localPath, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedCommits : true  });
    test.identical( got, false );
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommitToBranch( 'testCommit', 'feature' )
  shell( 'git commit --allow-empty -m test' )
  shell( 'git fetch' )
  shell( 'git status' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local has commit to master,fetch without merge';
    var got = _.git.hasLocalChanges({ localPath, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedCommits : true  });
    test.identical( got, true );
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git commit --allow-empty -m test' )
  shell( 'git tag sometag' )
  .then( () =>
  {
    test.case = 'local has unpushed tag';
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : true, unpushedCommits : false  });
    test.identical( got, true );
    return null;
  })
  shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local has pushed tag';
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : true, unpushedCommits : false  });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git commit --allow-empty -m test' )
  shell( 'git tag -a sometag -m "testtag"' )
  .then( () =>
  {
    test.case = 'local has unpushed annotated tag';
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : true, unpushedCommits : false  });
    test.identical( got, true );
    return null;
  })
  shell( 'git push --follow-tags' )
  .then( () =>
  {
    test.case = 'local has pushed annotated tag';
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : true, unpushedCommits : false  });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  .then( () =>
  {
    provider.fileWrite( readmePath, readmePath );
    return null;
  })
  shell( 'git add README' )
  shell( 'git commit -m test' )
  shell( 'git push' )
  .then( () =>
  {
    test.case = 'unstaged after rename';
    provider.fileRename( readmePath + '_', readmePath );
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after rename';
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after rename';
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after rename';
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  .then( () =>
  {
    provider.fileWrite( readmePath, readmePath );
    return null;
  })
  shell( 'git add README' )
  shell( 'git commit -m test' )
  shell( 'git push' )
  .then( () =>
  {
    test.case = 'unstaged after delete';
    provider.fileDelete( readmePath );
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after delete';
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after delete';
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after delete';
    var got = _.git.hasLocalChanges({ localPath });
    test.identical( got, false );
    return null;
  })

  /*  */

  return con;

  /* - */

  function prepareRepo()
  {
    con.then( () =>
    {
      provider.filesDelete( repoPath );
      provider.dirMake( repoPath );
      return null;
    })

    shell2( 'git init --bare' );

    return con;
  }

  /* */

  function begin()
  {
    con.then( () =>
    {
      test.case = 'clean clone';
      provider.filesDelete( localPath );
      return _.process.start
      ({
        execPath : 'git clone ' + repoPathNative + ' ' + path.name( localPath ),
        currentPath : testPath,
      })
    })

    return con;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : testPath,
      ready : con
    })

    con.then( () =>
    {
      let secondRepoPath = path.join( testPath, 'secondary' );
      provider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + repoPathNative + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return con;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : testPath,
      ready : con
    })

    let create = true;
    let secondRepoPath = path.join( testPath, 'secondary' );

    con.then( () =>
    {
      provider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + repoPathNative + ' secondary' )

    con.then( () =>
    {
      if( provider.fileExists( path.join( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    con.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : testPath,
        ready : con2
      })

      if( create )
      shell2( 'git -C secondary checkout -b ' + branch )
      else
      shell2( 'git -C secondary checkout ' + branch )

      shell2( 'git -C secondary commit --allow-empty -m ' + message )

      if( create )
      shell2( 'git -C secondary push --set-upstream origin ' + branch )
      else
      shell2( 'git -C secondary push' )

      return con2;
    })

    return con;
  }

}

hasLocalChanges.timeOut = 30000;

//

function isDownloaded( test )
{
  let context = this;
  let provider = context.provider;
  let path = context.provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'repo' );
  let filePath = path.join( localPath, 'file' );

  test.case = 'missing';
  provider.filesDelete( localPath );
  var got = _.git.isDownloaded({ localPath });
  test.identical( got, false );

  test.case = 'terminal';
  provider.filesDelete( localPath );
  provider.fileWrite( localPath, localPath )
  var got = _.git.isDownloaded({ localPath });
  test.identical( got, false );

  test.case = 'link';
  provider.filesDelete( localPath );
  provider.dirMake( localPath );
  provider.softLink( filePath, localPath );
  var got = _.git.isDownloaded({ localPath : filePath });
  test.identical( got, false );

  test.case = 'empty dir';
  provider.filesDelete( localPath );
  provider.dirMake( localPath )
  var got = _.git.isDownloaded({ localPath });
  test.identical( got, false );

  test.case = 'dir with file';
  provider.filesDelete( localPath );
  provider.fileWrite( filePath, filePath )
  var got = _.git.isDownloaded({ localPath });
  test.identical( got, true );
}

//

function isDownloadedFromRemote( test )
{
  let context = this;
  let provider = _.fileProvider;
  let path = provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'wPathBasic' );
  let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git';
  let remotePath2 = 'git+https:///github.com/Wandalen/wTools.git';

  let con = new _.Consequence().take( null )

  let shell = _.process.starter
  ({
    currentPath : testPath,
    mode : 'spawn',
    ready : con
  })

  con
  .then( () =>
  {
    let got = _.git.isDownloadedFromRemote({ localPath, remotePath : remotePath });
    test.identical( got.downloaded, false )
    test.identical( got.downloadedFromRemote, false )
    return null;
  })

  .then( () =>
  {
    test.case = 'setup';
    provider.filesDelete( localPath );
    provider.dirMake( localPath );
    return null;
  })

  shell( 'git clone https://github.com/Wandalen/wPathBasic.git ' + path.name( localPath ) )

  .then( () =>
  {
    let got = _.git.isDownloadedFromRemote({ localPath, remotePath });
    test.identical( got.downloaded, true )
    test.identical( got.downloadedFromRemote, true )
    return null;
  })

  .then( () =>
  {
    let got = _.git.isDownloadedFromRemote({ localPath, remotePath : remotePath2 });
    test.identical( got.downloaded, true )
    test.identical( got.downloadedFromRemote, false )
    return null;
  })

  return con;
}

function isUpToDate( test )
{
  let context = this;
  let provider = context.provider;
  let path = context.provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'wPathBasic' );

  let con = new _.Consequence().take( null )

  let shell = _.process.starter
  ({
    currentPath : testPath,
    mode : 'spawn',
  })


  con
  .then( () =>
  {
    test.open( 'local master' );
    test.case = 'setup';
    let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git';
    provider.filesDelete( localPath );
    provider.dirMake( localPath );
    return shell( 'git clone https://github.com/Wandalen/wPathBasic.git ' + path.name( localPath ) )
  })

  .then( () =>
  {
    test.case = 'remote master';
    let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git';
    return _.git.isUpToDate({ localPath, remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  .then( () =>
  {
    test.case = 'remote has different branch';
    let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git#other';
    return _.git.isUpToDate({ localPath, remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  .then( () =>
  {
    test.case = 'remote has fixed version';
    let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git#c94e0130358ba54fc47237e15bac1ab18024c0a9';
    return _.git.isUpToDate({ localPath, remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  .then( () =>
  {
    test.close( 'local master' );
    return null;
  })

  /**/

  .then( () =>
  {
    test.open( 'local detached' );
    test.case = 'setup';
    provider.filesDelete( localPath );
    provider.dirMake( localPath );
    return null;
  })

  shell({ execPath : 'git clone https://github.com/Wandalen/wPathBasic.git ' + path.name( localPath ), ready : con })
  shell({ execPath : 'git -C wPathBasic checkout c94e0130358ba54fc47237e15bac1ab18024c0a9', ready : con })

  .then( () =>
  {
    test.case = 'remote has same fixed version';
    let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git#c94e0130358ba54fc47237e15bac1ab18024c0a9';
    return _.git.isUpToDate({ localPath, remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  .then( () =>
  {
    test.case = 'remote has other fixed version';
    let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git#469a6497f616cf18639b2aa68957f4dab78b7965';
    return _.git.isUpToDate({ localPath, remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  .then( () =>
  {
    test.case = 'remote has other branch';
    let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git#other';
    return _.git.isUpToDate({ localPath, remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  .then( () =>
  {
    test.close( 'local detached' );
    return null;
  })

  /**/

  .then( () =>
  {
    test.case = 'local is behind remote';
    provider.filesDelete( localPath );
    provider.dirMake( localPath );
    return null;
  })

  shell({ execPath : 'git clone https://github.com/Wandalen/wPathBasic.git ' + path.name( localPath ), ready : con })

  .then( () =>
  {
    let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git';
    return _.process.start
    ({
      execPath : 'git reset --hard HEAD~1',
      currentPath : localPath,
    })
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  /* */

  .then( () =>
  {
    test.case = 'local is ahead remote';
    provider.filesDelete( localPath );
    provider.dirMake( localPath );
    return null;
  })

  shell({ execPath : 'git clone https://github.com/Wandalen/wPathBasic.git ' + path.name( localPath ), ready : con })

  .then( () =>
  {
    let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git';

    return _.process.start
    ({
      execPath : 'git commit --allow-empty -m emptycommit',
      currentPath : localPath,
    })
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  /*  */

  .then( () =>
  {
    test.case = 'local and remote have new commit';
    provider.filesDelete( localPath );
    provider.dirMake( localPath );
    return null;
  })

  shell({ execPath : 'git clone https://github.com/Wandalen/wPathBasic.git ' + path.name( localPath ), ready : con })

  .then( () =>
  {
    let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git';

    let ready = new _.Consequence().take( null );

    _.process.start
    ({
      execPath : 'git reset --hard HEAD~1',
      currentPath : localPath,
      ready
    })

    _.process.start
    ({
      execPath : 'git commit --allow-empty -m emptycommit',
      currentPath : localPath,
      ready
    })

    ready
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })

    return ready;
  })

  /* */

  .then( () =>
  {
    test.case = 'local is detached and has local commit';
    provider.filesDelete( localPath );
    provider.dirMake( localPath );
    return null;
  })

  shell({ execPath : 'git clone https://github.com/Wandalen/wPathBasic.git ' + path.name( localPath ), ready : con })
  shell({ execPath : 'git -C wPathBasic checkout 05930d3a7964b253ea3bbfeca7eb86848f550e96', ready : con })

  .then( () =>
  {
    let remotePath = 'git+https:///github.com/Wandalen/wPathBasic.git';
    return _.process.start
    ({
      execPath : 'git commit --allow-empty -m emptycommit',
      currentPath : localPath,
    })
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  return con;
}

isUpToDate.timeOut = 30000;

//

function insideRepository( test )
{
  test.case = 'missing'
  var localPath = _.path.join( __dirname, 'someFile' );
  var got = _.git.insideRepository({ localPath })
  test.identical( got,true )

  test.case = 'terminal'
  var localPath = _.path.normalize( __filename );
  var got = _.git.insideRepository({ localPath })
  test.identical( got,true )

  test.case = 'testdir'
  var localPath = _.path.normalize( __dirname );
  var got = _.git.insideRepository({ localPath })
  test.identical( got,true )

  test.case = 'root of repo'
  var localPath = _.path.join( __dirname, '../../../../..' );
  var got = _.git.insideRepository({ localPath })
  test.identical( got,true )

  test.case = 'outside of repo'
  var localPath = _.path.join( __dirname, '../../../../../..' );
  var got = _.git.insideRepository({ localPath })
  test.identical( got,false )
}

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
    - Register two handlers for single hook, unregister second handler, only first should be executed
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

  .then( () =>
  {
    test.case = 'Register two handlers for single hook, unregister second handler, only first should be executed';
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

      _.git.hookUnregister
      ({
        repoPath : localPath,
        handlerName : handlerName2,
        force : 0,
        throwing : 1
      })

      test.will = 'hook runner was created';
      test.is( provider.fileExists( originalHookPath ) );
      let hookRead = provider.fileRead( originalHookPath );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler exists'
      test.is( provider.fileExists( hookHandlerPath ) );
      var customHookRead = provider.fileRead( hookHandlerPath );
      test.identical( customHookRead,handlerCode );

      test.will = 'second hook handler does not exist'
      test.is( !provider.fileExists( hookHandlerPath2 ) );

      test.will = 'copy of original hook does not exist';
      test.is( !provider.fileExists( wasOriginalHookPath ) );

      return null;
    })

    shell( 'git commit --allow-empty -m test' )

    con.then( ( got ) =>
    {
      test.will = 'custom handler1 was executed after git commit';
      test.is( _.strHas( got.output, 'Custom handler executed' ) );
      test.will = 'custom handler2 should not be executed after git commit';
      test.is( !_.strHas( got.output, 'Custom handler2 executed' ) );
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

function gitHooksManagerErrors( test )
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
    - No source file
    - Unknown git hook
    - Wrong handler name: original hook name
    - Wrong handler name: wrong name pattern
    - Rewriting of existing hook
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

  .then( () =>
  {
    test.case = 'No source file';

    provider.filesDelete( localPath );
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
    test.case = 'Unknown git hook';
    let con = begin();

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

      test.shouldThrowErrorSync( () =>
      {
        _.git.hookRegister
        ({
          repoPath : localPath,
          filePath : handlerCodePath,
          hookName : 'some-random-hook',
          handlerName : handlerName,
          throwing : 1,
          rewriting : 0
        })
      })

      test.will = 'hook runner was not created';
      test.is( !provider.fileExists( originalHookPath ) );

      test.will = 'hook handler was not created'
      test.is( !provider.fileExists( hookHandlerPath ) );

      test.will = 'copy of original hook was not created';
      test.is( !provider.fileExists( wasOriginalHookPath ) );

      test.will = 'hooks directory stays the same as before';
      let filesNow = provider.dirRead( hooksPath );
      test.identical( filesNow, files );

      return null;
    })

    return con;
  })

  /* */

  .then( () =>
  {
    test.case = 'Wrong handler name: original hook name';
    let con = begin();

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

      test.shouldThrowErrorSync( () =>
      {
        _.git.hookRegister
        ({
          repoPath : localPath,
          filePath : handlerCodePath,
          hookName : hookName,
          handlerName : hookName,
          throwing : 1,
          rewriting : 0
        })
      })

      test.will = 'hook runner stays';
      test.is( provider.fileExists( originalHookPath ) );
      let hookRead = provider.fileRead( originalHookPath );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler stays'
      test.is( provider.fileExists( hookHandlerPath ) );
      let customHookRead = provider.fileRead( hookHandlerPath );
      test.identical( customHookRead,handlerCode );

      test.will = 'copy of original hook was not created';
      test.is( !provider.fileExists( wasOriginalHookPath ) );

      return null;
    })

    return con;
  })

  /* */

  .then( () =>
  {
    test.case = 'Wrong handler name: wrong name pattern';
    let con = begin();

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

      let handlerName2 = 'post-yyy-' + handlerName;

      test.shouldThrowErrorSync( () =>
      {
        _.git.hookRegister
        ({
          repoPath : localPath,
          filePath : handlerCodePath,
          hookName : hookName,
          handlerName : handlerName2,
          throwing : 1,
          rewriting : 0
        })
      })

      test.will = 'hook runner stays';
      test.is( provider.fileExists( originalHookPath ) );
      let hookRead = provider.fileRead( originalHookPath );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler stays'
      test.is( provider.fileExists( hookHandlerPath ) );
      let customHookRead = provider.fileRead( hookHandlerPath );
      test.identical( customHookRead,handlerCode );

      test.will = 'second hook handler does not exist'
      test.is( !provider.fileExists( path.join( hooksPath, handlerName2 ) ) );

      test.will = 'copy of original hook was not created';
      test.is( !provider.fileExists( wasOriginalHookPath ) );

      return null;
    })

    return con;
  })

  /* */

  .then( () =>
  {
    test.case = 'Wrong handler name: wrong name pattern';
    let con = begin();

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

      test.will = 'hook runner stays';
      test.is( provider.fileExists( originalHookPath ) );
      let hookRead = provider.fileRead( originalHookPath );
      test.is( _.strHas( hookRead, specialComment ) );

      test.will = 'first hook handler stays'
      test.is( provider.fileExists( hookHandlerPath ) );
      let customHookRead = provider.fileRead( hookHandlerPath );
      test.identical( customHookRead,handlerCode );

      test.will = 'copy of original hook was not created';
      test.is( !provider.fileExists( wasOriginalHookPath ) );

      return null;
    })

    return con;
  })

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

function hookTrivial( test )
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

    isDownloaded,
    isDownloadedFromRemote,
    isUpToDate,
    insideRepository,

    gitHooksManager,
    gitHooksManagerErrors,

    hookTrivial,
    hookPreservingHardLinks,

  },

}

//

var Self = new wTestSuite( Proto )/* .inherit( Parent ); */
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
