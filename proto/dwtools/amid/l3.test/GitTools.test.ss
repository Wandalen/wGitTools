( function _GitTools_test_ss_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );

  require( '../l3/git/IncludeMid.s' );
}

//

var _ = _global_.wTools;

// --
// context
// --

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

function pathParse( test )
{
  var remotePath = 'git+https:///github.com/Wandalen/wTools.git/#8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3';
  var expected =
  {
    'protocol' : 'git+https',
    'hash' : '8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3',
    'longPath' : '/github.com/Wandalen/wTools.git/',
    'localVcsPath' : './',
    'remoteVcsPath' : 'https://github.com/Wandalen/wTools.git',
    'longerRemoteVcsPath' : 'https://github.com/Wandalen/wTools.git',
    'isFixated' : true
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+https:///github.com/Wandalen/wTools.git/@v0.8.505'
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'v0.8.505',
    'longPath' : '/github.com/Wandalen/wTools.git/',
    'localVcsPath' : './',
    'remoteVcsPath' : 'https://github.com/Wandalen/wTools.git',
    'longerRemoteVcsPath' : 'https://github.com/Wandalen/wTools.git',
    'isFixated' : false
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+https:///github.com/Wandalen/wTools.git/@master'
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'master',
    'longPath' : '/github.com/Wandalen/wTools.git/',
    'localVcsPath' : './',
    'remoteVcsPath' : 'https://github.com/Wandalen/wTools.git',
    'longerRemoteVcsPath' : 'https://github.com/Wandalen/wTools.git',
    'isFixated' : false
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+hd://Tools?out=out/wTools.out.will@master'
  var expected =
  {
    'protocol' : 'git+hd',
    'query' : 'out=out/wTools.out.will',
    'tag' : 'master',
    'longPath' : 'Tools',
    'localVcsPath' : 'out/wTools.out.will',
    'remoteVcsPath' : 'Tools',
    'longerRemoteVcsPath' : 'Tools',
    'isFixated' : false
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+hd://Tools?out=out/wTools.out.will@v0.8.505'
  var expected =
  {
    'protocol' : 'git+hd',
    'query' : 'out=out/wTools.out.will',
    'tag' : 'v0.8.505',
    'longPath' : 'Tools',
    'localVcsPath' : 'out/wTools.out.will',
    'remoteVcsPath' : 'Tools',
    'longerRemoteVcsPath' : 'Tools',
    'isFixated' : false
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+hd://Tools?out=out/wTools.out.will/@v0.8.505'
  var expected =
  {
    'protocol' : 'git+hd',
    'query' : 'out=out/wTools.out.will/',
    'tag' : 'v0.8.505',
    'longPath' : 'Tools',
    'localVcsPath' : 'out/wTools.out.will/',
    'remoteVcsPath' : 'Tools',
    'longerRemoteVcsPath' : 'Tools',
    'isFixated' : false
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+hd://Tools?out=out/wTools.out.will#8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3'
  var expected =
  {
    'protocol' : 'git+hd',
    'query' : 'out=out/wTools.out.will',
    'hash' : '8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3',
    'longPath' : 'Tools',
    'localVcsPath' : 'out/wTools.out.will',
    'remoteVcsPath' : 'Tools',
    'longerRemoteVcsPath' : 'Tools',
    'isFixated' : true
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+hd://Tools?out=out/wTools.out.will/#8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3'
  var expected =
  {
    'protocol' : 'git+hd',
    'query' : 'out=out/wTools.out.will/',
    'hash' : '8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3',
    'longPath' : 'Tools',
    'localVcsPath' : 'out/wTools.out.will/',
    'remoteVcsPath' : 'Tools',
    'longerRemoteVcsPath' : 'Tools',
    'isFixated' : true
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  test.case = 'both hash and tag'
  var remotePath = 'git+https:///github.com/Wandalen/wTools.git/#8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3@master';
  test.shouldThrowErrorSync( () => _.git.pathParse( remotePath ) );
}

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

function statusLocal( test )
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

  begin()
  .then( () =>
  {
    test.case = 'check after fresh clone, defaults'
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    return null;
  })

  begin()
  .then( () =>
  {
    test.case = 'check after fresh clone, defaults'
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedIgnored : 0,
      unpushed : 1,
      unpushedTags : 0,
      unpushedBranches : 0,
      detailing : 0,
      explaining : 0
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : null,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : null,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    test.case = 'check after fresh clone, defaults + detailing'
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedIgnored : 0,
      unpushed : 1,
      unpushedTags : 0,
      unpushedBranches : 0,
      detailing : 1,
      explaining : 0
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : null,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : null,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    test.case = 'check after fresh clone, defaults + detailing + explaining'

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedIgnored : 0,
      unpushed : 1,
      unpushedTags : 0,
      unpushedBranches : 0,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : null,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : null,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    test.case = 'check after fresh clone, everything off'

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 0,
      uncommittedUntracked : 0,
      uncommittedAdded : 0,
      uncommittedChanged : 0,
      uncommittedDeleted : 0,
      uncommittedRenamed : 0,
      uncommittedCopied : 0,
      uncommittedIgnored : 0,
      unpushed : 0,
      unpushedCommits : 0,
      unpushedTags : 0,
      unpushedBranches : 0,
      explaining : 0,
      detailing : 0,
      conflicts : 0,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : null,
      'uncommittedUntracked' : null,
      'uncommittedAdded' : null,
      'uncommittedChanged' : null,
      'uncommittedDeleted' : null,
      'uncommittedRenamed' : null,
      'uncommittedCopied' : null,
      'uncommittedIgnored' : null,
      'uncommittedUnstaged' : null,
      'unpushed' : null,
      'unpushedCommits' : null,
      'unpushedTags' : null,
      'unpushedBranches' : null,
      'status' : null,
      'conflicts' : null
    }
    test.identical( got, expected )

    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'new untraked file'
    provider.fileWrite( filePath, filePath );

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });

    var expectedStatus =  'List of uncommited changes in files:\n  ?? newFile'

    var expected =
    {
      'uncommitted' : expectedStatus,
      'uncommittedUntracked' : '?? newFile',
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : expectedStatus,
      'conflicts' : false
    }
    debugger
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : true,
      'uncommittedUntracked' : true,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )

    return null
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'unstaged change in existing file'
    provider.fileWrite( readmePath, readmePath );
    return null;
  })

  shell( 'git add README' )
  shell( 'git commit -m test' )
  shell( 'git push' )

  .then( () =>
  {
    provider.fileWrite( readmePath, readmePath + readmePath );

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });

    var expectedStatus = `List of uncommited changes in files:\n  M README`;
    var expected =
    {
      'uncommitted' : expectedStatus,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : 'M README',
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : expectedStatus,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : true,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : true,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )

    return null;
  })
  shell( 'git stash' )
  .then( () =>
  {
    test.case = 'after revert'

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  .then( () =>
  {
    test.case = 'remote has new commit';

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'remote has new commit, local executed fetch without merge';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    return null;
  })
  shell( 'git merge' )
  .then( () =>
  {
    test.case = 'merge after fetch, remote had new commit';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )
    return null;
  })

  /*  */

  begin()
  shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'new local commit'
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'conflicts' : false
    }
    test.contains( got, expected )
    debugger
    test.is( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.is( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.is( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] test/ ) )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : true,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )

    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'local and remote has has new commit';

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'conflicts' : false
    }
    test.contains( got, expected )
    debugger
    test.is( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.is( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.is( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] test/ ) )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : true,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )

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
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

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
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'conflicts' : false
    }
    test.contains( got, expected )
    debugger
    test.is( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.is( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.is( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] test/ ) )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : true,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git tag sometag' )
  .then( () =>
  {
    test.case = 'local has unpushed tag';

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : 'List of unpushed:\n  [new tag]   sometag -> sometag',
      'unpushedCommits' : false,
      'unpushedTags' : '[new tag]   sometag -> sometag',
      'unpushedBranches' : false,
      'status' : 'List of unpushed:\n  [new tag]   sometag -> sometag',
      'conflicts' : false

    }
    debugger
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : false,
      'unpushedTags' : true,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )

    return null;

  })
  shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local has pushed tag';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git tag -a sometag -m "testtag"' )
  .then( () =>
  {
    test.case = 'local has unpushed annotated tag';

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : 'List of unpushed:\n  [new tag]   sometag -> sometag',
      'unpushedCommits' : false,
      'unpushedTags' : '[new tag]   sometag -> sometag',
      'unpushedBranches' : false,
      'status' : 'List of unpushed:\n  [new tag]   sometag -> sometag',
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : false,
      'unpushedTags' : true,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected );

    return null;
  })
  shell( 'git push --follow-tags' )
  .then( () =>
  {
    test.case = 'local has pushed annotated tag';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )
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

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : 'List of uncommited changes in files:\n  ?? README_\n  D README',
      'uncommittedUntracked' : '?? README_',
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : 'D README',
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : 'List of uncommited changes in files:\n  ?? README_\n  D README',
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : true,
      'uncommittedUntracked' : true,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : true,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false

    }
    test.identical( got, expected )

    return null;
  })
  shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after rename';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : 'List of uncommited changes in files:\n  R  README -> README_',
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : 'R  README -> README_',
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : 'List of uncommited changes in files:\n  R  README -> README_',
      'conflicts' : false
    }
    debugger
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : true,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : true,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )
    return null;
  })
  shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after rename';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'conflicts' : false
    }
    test.contains( got, expected )
    debugger
    test.is( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.is( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.is( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] test/ ) )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : true,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )
    return null;
  })
  shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after rename';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )
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
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : 'List of uncommited changes in files:\n  D README',
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : 'D README',
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : 'List of uncommited changes in files:\n  D README',
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : true,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : true,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )
    return null;
  })
  shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after delete';

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : 'List of uncommited changes in files:\n  D  README',
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : 'D  README',
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : 'List of uncommited changes in files:\n  D  README',
      'conflicts' : false
    }
    debugger
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : true,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : true,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )

    return null;
  })
  shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after delete';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'conflicts' : false
    }
    test.contains( got, expected )
    debugger
    test.is( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.is( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.is( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] test/ ) )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 0,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : true,
      'unpushedTags' : null,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )
    return null;
  })
  shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after delete';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git checkout -b testbranch' )
  .then( () =>
  {
    test.case = 'local clone has unpushed branch';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : 'List of unpushed:\n  [new branch]        testbranch -> ?',
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : '[new branch]        testbranch -> ?',
      'status' : 'List of unpushed:\n  [new branch]        testbranch -> ?',
      'conflicts' : false
    }
    debugger
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : true,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )
    return null;
  })
  shell( 'git push -u origin testbranch' )
  .then( () =>
  {
    test.case = 'local clone does not have unpushed branch';

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git tag testtag' )
  .then( () =>
  {
    test.case = 'local clone has unpushed tag';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : 'List of unpushed:\n  [new tag]   testtag -> testtag',
      'unpushedCommits' : false,
      'unpushedTags' : '[new tag]   testtag -> testtag',
      'unpushedBranches' : false,
      'status' : 'List of unpushed:\n  [new tag]   testtag -> testtag',
      'conflicts' : false

    }
    debugger
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : false,
      'unpushedTags' : true,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )

    return null;
  })
  shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local clone doesnt have unpushed tag';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : false,
      'conflicts' : false
    }
    test.identical( got, expected )
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  .then( () =>
  {
    test.case = 'local clone has ignored file';
    let ignoredFilePath = path.join( localPath, 'file' );
    provider.fileWrite( ignoredFilePath,ignoredFilePath )
    _.git.ignoreAdd( localPath, { 'file' : null } )
    return null;
  })
  shell( 'git add --all' )
  shell( 'git commit -am "no desc"' )
  .then( () =>
  {
    test.case = 'has ignored file';
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 1,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : 'List of uncommited changes in files:\n  !! file',
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : '!! file',
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'conflicts' : false
    }
    test.contains( got, expected )

    test.is( _.strHas( got.status, /List of uncommited changes in files:\n.*\!\! file/ ) )
    test.is( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.is( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.is( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )

    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : true,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : true,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : true,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'status' : true,
      'conflicts' : false
    }
    test.identical( got, expected )

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

statusLocal.timeOut = 30000;

//

function statusLocalEmpty( test )
{
  /*
    Empty repo without origin defined
  */

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

  initEmpty()
  .then( () =>
  {
    test.case = 'empty'
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'conflicts' : false,
      'status' : false
    }
    test.identical( got, expected )

    return null;
  })

  //

  initEmpty()
  .then( () =>
  {
    test.case = 'empty + new file'
    provider.fileWrite( path.join( localPath, 'file' ), 'file' );
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : true,
      'uncommittedUntracked' : true,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'conflicts' : false,
      'status' : true
    }
    test.identical( got, expected )

    return null;

  })

  //

  initEmpty()
  .then( () =>
  {
    test.case = 'empty, new tracked file'
    provider.fileWrite( path.join( localPath, 'file' ), 'file' );
    return null;
  })
  shell( 'git add file' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : true,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : true,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'conflicts' : false,
      'status' : true
    }
    test.identical( got, expected )

    return null;
  })

  //

  initEmpty()
  shell( 'git commit -m init --allow-empty' )
  .then( () =>
  {
    /* branch master is not tracking remote( no origin ) */

    test.case = 'empty, first commit'
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : true,
      'conflicts' : false,
      'status' : true
    }
    test.identical( got, expected )

    return null;
  })

  //

  initEmpty()
  shell( 'git checkout -b newbranch' )
  .then( () =>
  {
    test.case = 'empty, new brach'
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'conflicts' : false,
      'status' : false
    }
    test.identical( got, expected )
    return null;
  })

  //

  initEmpty()
  shell( 'git commit -m init --allow-empty' ) //no way to create tag in repo without commits
  shell( 'git tag newtag' )
  .then( () =>
  {
    test.case = 'empty, new tag'
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : false,
      'unpushedTags' : true,
      'unpushedBranches' : true,
      'conflicts' : false,
      'status' : true
    }
    test.identical( got, expected )
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

  function initEmpty()
  {
    con.then( () =>
    {
      test.case = 'init fresh repo';
      provider.filesDelete( localPath );
      provider.dirMake( localPath );
      return _.process.start
      ({
        execPath : 'git init',
        currentPath : localPath,
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

statusLocalEmpty.timeOut = 30000;

//

function statusLocalEmptyWithOrigin( test )
{

  /*
    Empty repo with origin defined
  */

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

  initEmptyWithOrigin()

  .then( () =>
  {
    test.case = 'empty'
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'conflicts' : false,
      'status' : false
    }
    test.identical( got, expected )

    return null;
  })

  //

  .then( () =>
  {
    test.case = 'empty + new file'
    provider.fileWrite( path.join( localPath, 'file' ), 'file' );
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : true,
      'uncommittedUntracked' : true,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'conflicts' : false,
      'status' : true
    }
    test.identical( got, expected )

    return null;

  })

  //

  .then( () =>
  {
    test.case = 'empty, new tracked file'
    provider.fileWrite( path.join( localPath, 'file' ), 'file' );
    return null;
  })
  shell( 'git add file' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : true,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : true,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'conflicts' : false,
      'status' : true
    }
    test.identical( got, expected )
    return null;
  })



  initEmptyWithOrigin()
  shell( 'git commit -m init --allow-empty' )
  .then( () =>
  {
    debugger
    test.case = 'empty, first commit'
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : true,
      'conflicts' : false,
      'status' : true
    }
    test.identical( got, expected )
    return null;
  })

  //

  initEmptyWithOrigin()
  shell( 'git checkout -b newbranch' )
  .then( () =>
  {
    test.case = 'empty, new brach'
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : false,
      'unpushedCommits' : false,
      'unpushedTags' : false,
      'unpushedBranches' : false,
      'conflicts' : false,
      'status' : false
    }
    test.identical( got, expected )
    return null;
  })

  //

  initEmptyWithOrigin()
  shell( 'git commit -m init --allow-empty' ) //no way to create tag in repo without commits
  shell( 'git tag newtag' )
  .then( () =>
  {
    test.case = 'empty, new tag'
    debugger
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      explaining : 0,
      detailing : 1,
      conflicts : 1,
      sync : 1
    });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : false,
      'uncommittedUnstaged' : false,
      'unpushed' : true,
      'unpushedCommits' : false,
      'unpushedTags' : true,
      'unpushedBranches' : true,
      'conflicts' : false,
      'status' : true
    }
    test.identical( got, expected )
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

  function initEmptyWithOrigin()
  {
    con.then( () =>
    {
      test.case = 'init fresh repo';
      provider.filesDelete( localPath );
      provider.dirMake( localPath );
      return _.process.start
      ({
        execPath : 'git init',
        currentPath : localPath,
      })
    })

    con.then( () =>
    {
      return _.process.start
      ({
        execPath : 'git remote add origin ' + repoPathNative,
        currentPath : localPath,
      })
    })

    con.then( () =>
    {
      return _.process.start
      ({
        execPath : 'git remote get-url origin',
        currentPath : localPath,
        outputCollecting : 1
      })
      .then( ( got ) =>
      {
        test.is( _.strHas( got.output, repoPathNative ) );
        return null;
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

statusLocalEmptyWithOrigin.timeOut = 30000;

//

function statusLocalAsync( test )
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

  begin()
  .then( () =>
  {
    test.case = 'check after fresh clone, defaults'
    return _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedTags : 1,
      unpushedBranches : 1,
      detailing : 1,
      explaining : 0,
      sync : 0
    })
    .then( ( got ) =>
    {
      var expected =
      {
        'uncommitted' : false,
        'uncommittedUntracked' : false,
        'uncommittedAdded' : false,
        'uncommittedChanged' : false,
        'uncommittedDeleted' : false,
        'uncommittedRenamed' : false,
        'uncommittedCopied' : false,
        'uncommittedIgnored' : false,
        'uncommittedUnstaged' : false,
        'unpushed' : false,
        'unpushedCommits' : false,
        'unpushedTags' : false,
        'unpushedBranches' : false,

        'conflicts' : false,

        'status' : false
      }
      test.identical( got, expected )
      return null;
    })
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

statusLocalAsync.timeOut = 30000;

//

function statusLocalExplainingTrivial( test )
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

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git commit --allow-empty -am "no desc"' )
  .then( () =>
  {
    var got = _.git.statusLocal({ localPath, unpushed : 1, uncommitted : 1, detailing : 1, explaining : 1 });
    var expected =
    {
      'uncommitted' : false,
      'uncommittedUntracked' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : null,
      'unpushedTags' : false,
      'unpushedBranches' : false,
    }
    test.contains( got, expected )

    test.is( _.strHas( got.unpushed, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.is( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.is( _.strHas( got.status, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )

    return null;
  })

  //

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git commit --allow-empty -am "no desc"' )
  .then( () =>
  {
    _.fileProvider.fileWrite( filePath, filePath );
    return null;
  })
  shell( 'git tag sometag' )
  shell( 'git checkout -b somebranch' )
  shell( 'git checkout master' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath,
      unpushed : 1,
      unpushedBranches : 1,
      unpushedTags : 1,
      uncommitted : 1,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      'uncommittedUntracked' : '?? newFile',
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedDeleted' : false,
      'uncommittedRenamed' : false,
      'uncommittedCopied' : false,
      'uncommittedIgnored' : null,
    }

    test.is( _.strHas( got.uncommitted, 'List of uncommited changes in files:' ) )
    test.is( _.strHas( got.uncommitted, /.+ ?? newFile/ ) )

    test.is( _.strHas( got.unpushed, 'List of branches with unpushed commits:' ) )
    test.is( _.strHas( got.unpushed, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.is( _.strHas( got.unpushed, 'List of unpushed:' ) )
    test.is( _.strHas( got.unpushed, /\[new tag\] .* sometag -> sometag/ ) )
    test.is( _.strHas( got.unpushed, /\[new branch\] .* somebranch -> \?/ ) )

    test.is( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.is( _.strHas( got.unpushedTags, /\[new tag\] .* sometag -> sometag/ ) )
    test.is( _.strHas( got.unpushedBranches, /\[new branch\] .* somebranch -> \?/ ) )

    test.is( _.strHas( got.status, 'List of uncommited changes in files:' ) )
    test.is( _.strHas( got.status, /.+ ?? newFile/ ) )
    test.is( _.strHas( got.status, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.is( _.strHas( got.status, /\[new tag\] .* sometag -> sometag/ ) )
    test.is( _.strHas( got.status, /\[new branch\] .* somebranch -> \?/ ) )

    test.contains( got, expected )
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
}

statusLocalExplainingTrivial.timeOut = 30000;

//

function statusLocalExtended( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'clone' );
  let repoPath = path.join( testPath, 'repo' );
  let repoPathNative = path.nativize( repoPath );
  let join = _.routineJoin( _.path, _.path.join );
  let write = _.routineJoin( _.fileProvider, _.fileProvider.fileWrite );
  let filesDelete = _.routineJoin( _.fileProvider, _.fileProvider.filesDelete );
  let rename = _.routineJoin( _.fileProvider, _.fileProvider.fileRename );

  let con = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    currentPath : testPath,
    ready : con
  })

  let shell2 = _.process.starter
  ({
    currentPath : repoPath,
    ready : con
  })

  provider.dirMake( testPath )

  /*  */

  testCase( 'modified + staged and then modified' )
  prepareRepo()
  begin()
  .then( () =>
  {
    write( join( localPath, 'file1' ), 'file1file1' );
    return null;
  })
  shell( 'git -C clone add .' )
  .then( () =>
  {
    write( join( localPath, 'file1' ), 'file1file1file1' );
    return null;
  })
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      detailing : 1,
      explaining : 1,
      unpushed : 1,
      verbosity : 1,
    });
    test.identical( !!got.status, true )
    test.identical( !!got.uncommittedUnstaged, true )

    return null;
  })

  /*  */

  testCase( 'modified and then deleted' )
  prepareRepo()
  begin()
  .then( () =>
  {
    write( join( localPath, 'file1' ), 'file1file1' );
    return null;
  })
  shell( 'git -C clone add .' )
  .then( () =>
  {
    filesDelete( join( localPath, 'file1' ) );
    return null;
  })
  shell( 'git -C clone status -u --porcelain -b' )
  shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      detailing : 1,
      explaining : 1,
      unpushed : 1,
      verbosity : 1,
    });

    test.identical( !!got.status, true )
    test.identical( !!got.uncommittedUnstaged, true )

    return null;
  })

  /*  */

  testCase( 'modified and then renamed' )
  prepareRepo()
  begin()
  .then( () =>
  {
    write( join( localPath, 'file1' ), 'file1file1' );
    return null;
  })
  shell( 'git -C clone add .' )
  shell( 'git -C clone mv file1 file3' )
  shell( 'git -C clone status -u --porcelain -b' )
  shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      detailing : 1,
      explaining : 1,
      unpushed : 1,
      verbosity : 1,
    });
    test.identical( !!got.uncommittedDeleted, true )
    test.identical( !!got.uncommittedAdded, true )
    test.identical( !!got.status, true )

    return null;
  })

  /*  */

  testCase( 'added to index and then deleted' )
  prepareRepo()
  begin()
  .then( () =>
  {
    write( join( localPath, 'file3' ), 'file3' );
    return null;
  })
  shell( 'git -C clone add file3' )
  .then( () =>
  {
    filesDelete( join( localPath, 'file3' ) );
    return null;
  })
  shell( 'git -C clone status -u --porcelain -b' )
  shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      detailing : 1,
      explaining : 1,
      unpushed : 1,
      verbosity : 1,
    });
    test.identical( !!got.status, true )
    test.identical( !!got.uncommittedUnstaged, true )

    return null;
  })

  /* */

  testCase( 'added to index and then modified' )
  prepareRepo()
  begin()
  .then( () =>
  {
    write( join( localPath, 'file3' ), 'file3' );
    return null;
  })
  shell( 'git -C clone add file3' )
  .then( () =>
  {
    write( join( localPath, 'file3' ), 'file3file3' );
    return null;
  })
  shell( 'git -C clone status -u --porcelain -b' )
  shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      detailing : 1,
      explaining : 1,
      unpushed : 1,
      verbosity : 1,
    });
    test.identical( !!got.status, true )
    test.identical( !!got.uncommittedUnstaged, true )

    return null;
  })

  /* */

  testCase( 'renamed then modified' )
  prepareRepo()
  begin()
  shell( 'git -C clone mv file1 file3' )
  .then( () =>
  {
    write( join( localPath, 'file3' ), 'file3' );
    return null;
  })
  shell( 'git -C clone status -u --porcelain -b' )
  shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      detailing : 1,
      explaining : 1,
      unpushed : 1,
      verbosity : 1,
    });
    test.identical( !!got.status, true )
    test.identical( !!got.uncommittedUnstaged, true )

    return null;
  })

  /*  */

  testCase( 'renamed then deleted' )
  prepareRepo()
  begin()
  shell( 'git -C clone mv file1 file3' )
  .then( () =>
  {
    filesDelete( join( localPath, 'file3' ) );
    return null;
  })
  shell( 'git -C clone status -u --porcelain -b' )
  shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath,
      uncommitted : 1,
      detailing : 1,
      explaining : 1,
      unpushed : 1,
      verbosity : 1,
    });
    test.identical( !!got.status, true )
    test.identical( !!got.uncommittedUnstaged, true )

    return null;
  })

  /*  */

  return con;

  /* - */

  function prepareRepo()
  {
    let shell = _.process.starter
    ({
      currentPath : testPath,
      ready : con
    })
    let secondRepoPath = path.join( testPath, 'secondary' );

    con.then( () =>
    {
      provider.filesDelete( repoPath );
      provider.dirMake( repoPath );
      return null;
    })

    shell2( 'git init --bare' );

    con.then( () =>
    {
      provider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + repoPathNative + ' secondary' )

    con.then( () =>
    {
      _.fileProvider.fileWrite( _.path.join( secondRepoPath, 'file1' ), 'file1' );
      _.fileProvider.fileWrite( _.path.join( secondRepoPath, 'file2' ), 'file2' );
      return null;
    })

    shell( 'git -C secondary add .' )
    shell( 'git -C secondary commit -m initial' )
    shell( 'git -C secondary push' )

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

  function testCase( title )
  {
    con.then( () => { test.case = title; return null })
    return con;
  }
}

statusLocalExtended.timeOut = 30000;

//

function statusFullHalfStaged( test )
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
    currentPath : testPath,
    ready : con
  })

  let shell2 = _.process.starter
  ({
    currentPath : repoPath,
    ready : con
  })

  provider.dirMake( testPath )

  /*  */

  prepareRepo()
  repoInitCommit()
  begin()
  .then( () =>
  {
    var got = _.git.statusFull
    ({
      localPath,
      local : 1,
      remote : 0,
      prs : 0,
      uncommitted : null,
      uncommittedUntracked : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedDeleted : null,
      uncommittedRenamed : null,
      uncommittedCopied : null,
      uncommittedIgnored : 0,
      unpushed : null,
      unpushedCommits : null,
      unpushedTags : null,
      unpushedBranches : null,
      verbosity : 1,
      remoteCommits : null,
      remoteBranches : 0,
      remoteTags : null,
      explaining : 0,
      detailing : 1
    });
    test.identical( got.status, true )

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

    .then( () =>
    {
      _.fileProvider.fileWrite( _.path.join( localPath, 'file1' ), 'file1file1' );
      _.fileProvider.fileWrite( _.path.join( localPath, 'file2' ), 'file2file1' );
      return null;
    })

    shell( 'git -C clone add .' )

    .then( () =>
    {
      _.fileProvider.fileWrite( _.path.join( localPath, 'file1' ), 'file1file1file1' );
      _.fileProvider.fileWrite( _.path.join( localPath, 'file2' ), 'file2file1file1' );
      return null;
    })

    return con;
  }

  function repoInitCommit()
  {
    let shell = _.process.starter
    ({
      currentPath : testPath,
      ready : con
    })

    let secondRepoPath = path.join( testPath, 'secondary' );

    con.then( () =>
    {
      provider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + repoPathNative + ' secondary' )

    con.then( () =>
    {
      _.fileProvider.fileWrite( _.path.join( secondRepoPath, 'file1' ), 'file1' );
      _.fileProvider.fileWrite( _.path.join( secondRepoPath, 'file2' ), 'file2' );
      return null;
    })

    shell( 'git -C secondary commit --allow-empty -am initial' )
    shell( 'git -C secondary push' )

    return con;
  }
}

//

function statusRemote( test )
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

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommit( 'test' )
  .then( () =>
  {
    test.case = 'remote has new commit';

    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : true,
      remoteBranches : null,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );

    return null;

  })
  .then( () =>
  {
    return _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 1, remoteTags : 1, sync : 0 })
    .then( ( got ) =>
    {
      var expected =
      {
        remoteCommits : true,
        remoteBranches : false,
        remoteTags : false,
        status : true
      }
      test.identical( got, expected );
      return null;
    })
  })
  .then( () =>
  {
    return _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 1, sync : 0 })
    .then( ( got ) =>
    {
      var expected =
      {
        remoteCommits : 'refs/heads/master',
        remoteBranches : '',
        remoteTags : '',
        status : 'List of remote branches that have new commits:\n  refs/heads/master'
      }
      test.identical( got, expected );
      return null;
    })
  })
  .then( () =>
  {
    return _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 1, detailing : 1, sync : 0 })
    .then( ( got ) =>
    {
      var expected =
      {
        remoteCommits : 'refs/heads/master',
        remoteBranches : false,
        remoteTags : false,
        status : 'List of remote branches that have new commits:\n  refs/heads/master'
      }
      test.identical( got, expected );
      return null;
    })
  })
  .then( () =>
  {
    return _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 0, detailing : 0, sync : 0 })
    .then( ( got ) =>
    {
      var expected =
      {
        remoteCommits : true,
        remoteBranches : false,
        remoteTags : false,
        status : true
      }
      test.identical( got, expected );
      return null;
    })
  })
  shell( 'git pull' )
  .then( () =>
  {
    test.case = 'local pulled new commit from remote';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommitToBranch( 'test', 'test' )
  .then( () =>
  {
    test.case = 'remote has new branch';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : true,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );
    return null;
  })
  shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after fetch';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : true,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );
    return null;
  })
  shell( 'git checkout test' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after checkout new branch';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    return null;
  })

  //

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewTag( 'test' )
  .then( () =>
  {
    test.case = 'remote has new tag';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 1 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );
    return null;
  })
  shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 1 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );
    return null;
  })

  //

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewTag( 'test' )
  .then( () =>
  {
    test.case = 'remote has new tag';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 1 });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );
    return null;
  })
  shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 1 });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );
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

  function repoNewTag( tag )
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
    shell( 'git -C secondary tag ' + tag )
    shell( 'git -C secondary push --tags' )

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

statusRemote.timeOut = 30000;

//

function statusRemoteTags( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'clone' );
  let remotePath = 'https://github.com/Wandalen/willbe.git';

  let con = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    currentPath : localPath,
    ready : con
  })

  provider.dirMake( testPath )

  /*  */

  begin()
  .then( () =>
  {
    test.case = 'check tags on fresh clone';

    var got = _.git.statusRemote
    ({
      localPath,
      remoteCommits : 1,
      remoteBranches : 1,
      remoteTags : 1,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : false,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );
    return null;
  })
  shell( 'git tag -d v0.5.6' )
  .then( () =>
  {
    test.case = 'compare with remore after remove';

    var got = _.git.statusRemote
    ({
      localPath,
      remoteCommits : 1,
      remoteBranches : 1,
      remoteTags : 1,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : false,
      remoteTags : 'refs/tags/v0.5.6\nrefs/tags/v0.5.6^{}',
      status : 'List of unpulled remote tags:\n  refs/tags/v0.5.6\n  refs/tags/v0.5.6^{}'
    }
    test.identical( got, expected );
    return null;
  })
  shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'check tags after fetching';

    var got = _.git.statusRemote
    ({
      localPath,
      remoteCommits : 1,
      remoteBranches : 1,
      remoteTags : 1,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : false,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );
    return null;
  })
  shell( 'git tag sometag' )
  .then( () =>
  {
    test.case = 'check after creating tag locally';

    var got = _.git.statusRemote
    ({
      localPath,
      remoteCommits : 1,
      remoteBranches : 1,
      remoteTags : 1,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : false,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );
    return null;
  })
  shell( 'git tag new v0.5.6' )
  shell( 'git tag -d v0.5.6' )
  .then( () =>
  {
    test.case = 'check after renaming';

    var got = _.git.statusRemote
    ({
      localPath,
      remoteCommits : 1,
      remoteBranches : 1,
      remoteTags : 1,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : false,
      remoteTags : 'refs/tags/v0.5.6\nrefs/tags/v0.5.6^{}',
      status : 'List of unpulled remote tags:\n  refs/tags/v0.5.6\n  refs/tags/v0.5.6^{}'
    }
    test.identical( got, expected );
    return null;
  })

  /*  */

  return con;

  /* - */

  function begin()
  {
    con.then( () =>
    {
      test.case = 'clean clone';
      provider.filesDelete( localPath );
      return _.process.start
      ({
        execPath : 'git clone ' + remotePath + ' ' + path.name( localPath ),
        currentPath : testPath,
      })
    })

    return con;
  }
}

statusRemoteTags.timeOut = 30000;

//

function statusRemoteVersionOption( test )
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

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommit( 'test' )
  .then( () =>
  {
    test.case = 'remote has new commit';

    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : true,
      remoteBranches : null,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : true,
      remoteBranches : null,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : true,
      remoteBranches : null,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );

    return null;

  })
  .then( () =>
  {
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 1, remoteTags : 1, version : null })
    var expected =
    {
      remoteCommits : true,
      remoteBranches : false,
      remoteTags : false,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 1, remoteTags : 1, version : _.all })
    var expected =
    {
      remoteCommits : true,
      remoteBranches : false,
      remoteTags : false,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 1, remoteTags : 1, version : 'master' })
    var expected =
    {
      remoteCommits : true,
      remoteBranches : false,
      remoteTags : false,
      status : true
    }
    test.identical( got, expected );
    
    return null;
  })
  .then( () =>
  {
    var got =_.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 1, version : null })
    var expected =
    {
      remoteCommits : 'refs/heads/master',
      remoteBranches : '',
      remoteTags : '',
      status : 'List of remote branches that have new commits:\n  refs/heads/master'
    }
    test.identical( got, expected );
    
    var got =_.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 1, version : _.all })
    var expected =
    {
      remoteCommits : 'refs/heads/master',
      remoteBranches : '',
      remoteTags : '',
      status : 'List of remote branches that have new commits:\n  refs/heads/master'
    }
    test.identical( got, expected );
    
    var got =_.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 1, version : 'master' })
    var expected =
    {
      remoteCommits : 'refs/heads/master',
      remoteBranches : '',
      remoteTags : '',
      status : 'List of remote branches that have new commits:\n  refs/heads/master'
    }
    test.identical( got, expected );
    
    return null;
  })
  .then( () =>
  {
    var got = _.git.statusRemote
    ({ 
      localPath, 
      remoteCommits : 1, 
      remoteBranches : 1, 
      remoteTags : 1, 
      explaining : 1, 
      detailing : 1, 
      version : null 
    })
    var expected =
    {
      remoteCommits : 'refs/heads/master',
      remoteBranches : false,
      remoteTags : false,
      status : 'List of remote branches that have new commits:\n  refs/heads/master'
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote
    ({ 
      localPath, 
      remoteCommits : 1, 
      remoteBranches : 1, 
      remoteTags : 1, 
      explaining : 1, 
      detailing : 1, 
      version : _.all 
    })
    var expected =
    {
      remoteCommits : 'refs/heads/master',
      remoteBranches : false,
      remoteTags : false,
      status : 'List of remote branches that have new commits:\n  refs/heads/master'
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote
    ({ 
      localPath, 
      remoteCommits : 1, 
      remoteBranches : 1, 
      remoteTags : 1, 
      explaining : 1, 
      detailing : 1, 
      version : 'master' 
    })
    var expected =
    {
      remoteCommits : 'refs/heads/master',
      remoteBranches : false,
      remoteTags : false,
      status : 'List of remote branches that have new commits:\n  refs/heads/master'
    }
    test.identical( got, expected );
    
    return null;
  })
  .then( () =>
  {
    var got = _.git.statusRemote
    ({ 
      localPath, 
      remoteCommits : 1, 
      remoteBranches : 1, 
      remoteTags : 1, 
      explaining : 0, 
      detailing : 0, 
      version : null
    })
    var expected =
    {
      remoteCommits : true,
      remoteBranches : false,
      remoteTags : false,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote
    ({ 
      localPath, 
      remoteCommits : 1, 
      remoteBranches : 1, 
      remoteTags : 1, 
      explaining : 0, 
      detailing : 0, 
      version : _.all
    })
    var expected =
    {
      remoteCommits : true,
      remoteBranches : false,
      remoteTags : false,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote
    ({ 
      localPath, 
      remoteCommits : 1, 
      remoteBranches : 1, 
      remoteTags : 1, 
      explaining : 0, 
      detailing : 0, 
      version : 'master'
    })
    var expected =
    {
      remoteCommits : true,
      remoteBranches : false,
      remoteTags : false,
      status : true
    }
    test.identical( got, expected );
    
    return null;
  })
  shell( 'git pull' )
  .then( () =>
  {
    test.case = 'local pulled new commit from remote';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    /* */
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommitToBranch( 'test', 'test' )
  .then( () =>
  {
    test.case = 'remote has new branch';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'test' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    /* */
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : true,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'test' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : true,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );
    
    return null;
  })
  shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after fetch';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'test' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : true,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'test' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : true,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );
    
    return null;
  })
  shell( 'git checkout test' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after checkout new branch';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'test' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'test' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    return null;
  })

  //

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewTag( 'test' )
  .then( () =>
  {
    test.case = 'remote has new tag';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );
    
    return null;
  })
  shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );
    
    return null;
  })

  //

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewTag( 'test' )
  .then( () =>
  {
    test.case = 'remote has new tag';
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    /*  */
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
      
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    /*  */
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : null });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : _.all });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : 'master' });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );
    
    return null;
  })
  shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    
    /*  */
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
      
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    
    /*  */
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : null });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : _.all });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );
    
    var got = _.git.statusRemote({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : 'master' });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );
    
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

  function repoNewTag( tag )
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
    shell( 'git -C secondary tag ' + tag )
    shell( 'git -C secondary push --tags' )

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

statusRemoteVersionOption.timeOut = 30000;

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

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git checkout -b testbranch' )
  .then( () =>
  {
    test.case = 'local clone has unpushed branch';
    var got = _.git.hasLocalChanges({ localPath, unpushedBranches : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedBranches : 1 });
    test.identical( got, true );
    return null;
  })
  shell( 'git push -u origin testbranch' )
  .then( () =>
  {
    test.case = 'local clone does not have unpushed branch';
    var got = _.git.hasLocalChanges({ localPath, unpushedBranches : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedBranches : 1 });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git tag testtag' )
  .then( () =>
  {
    test.case = 'local clone has unpushed tag';
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : 1 });
    test.identical( got, true );
    return null;
  })
  shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local clone doesnt have unpushed tag';
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushedTags : 1 });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  .then( () =>
  {
    test.case = 'local clone has unpushed tag';
    let ignoredFilePath = path.join( localPath, 'file' );
    provider.fileWrite( ignoredFilePath,ignoredFilePath )
    _.git.ignoreAdd( localPath, { 'file' : null } )
    return null;
  })
  shell( 'git add --all' )
  shell( 'git commit -am "no desc"' )
  .then( () =>
  {
    test.case = 'has ignored file';
    var got = _.git.hasLocalChanges({ localPath, unpushed : 0, uncommitted : 0, uncommittedIgnored : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushed : 0, uncommitted : 0, uncommittedIgnored : 1 });
    test.identical( got, true );
    var got = _.git.hasLocalChanges({ localPath, unpushed : 0, uncommitted : 1, uncommittedIgnored : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath, unpushed : 0, uncommitted : 1, uncommittedIgnored : 1 });
    test.identical( got, true );
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

function hasRemoteChanges( test )
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

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommit( 'test' )
  .then( () =>
  {
    test.case = 'remote has new commit';
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, true );
    return null;
  })
  shell( 'git pull' )
  .then( () =>
  {
    test.case = 'local pulled new commit from remote';
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommitToBranch( 'test', 'test' )
  .then( () =>
  {
    test.case = 'remote has new branch';
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
    test.identical( got, true );
    return null;
  })
  shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after fetch';
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
    test.identical( got, true );
    return null;
  })
  shell( 'git checkout test' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after checkout new branch';
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
    test.identical( got, false );
    return null;
  })

  //

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewTag( 'test' )
  .then( () =>
  {
    test.case = 'remote has new tag';
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 1 });
    test.identical( got, true );
    return null;
  })
  shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 1 });
    test.identical( got, false );
    return null;
  })

  //

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewTag( 'test' )
  .then( () =>
  {
    test.case = 'remote has new tag';
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 1 });
    test.identical( got, true );
    return null;
  })
  shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath, remoteCommits : 1, remoteBranches : 0, remoteTags : 1 });
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

  function repoNewTag( tag )
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
    shell( 'git -C secondary tag ' + tag )
    shell( 'git -C secondary push --tags' )

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

hasRemoteChanges.timeOut = 30000;

//

function hasChanges( test )
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
    return test.shouldThrowErrorSync( () => _.git.hasChanges({ localPath }) )
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'check after fresh clone'
    var got = _.git.hasChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, uncommitted : 1  });
    test.identical( got, false );
    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'new untraked file'
    provider.fileWrite( filePath, filePath );
    var got = _.git.hasChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    debugger
    var got = _.git.hasChanges({ localPath, uncommitted : 1  });
    test.identical( got, true );
    return null;
  })
  shell( 'git add newFile' )
  .then( () =>
  {
    test.case = 'new staged file'
    test.is( provider.fileExists( filePath ) );
    var got = _.git.hasChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, uncommitted : 1  });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'unstaged change in existing file'
    provider.fileWrite( readmePath, readmePath );
    var got = _.git.hasChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, uncommitted : 1  });
    test.identical( got, true );
    return null;
  })
  shell( 'git add README' )
  .then( () =>
  {
    test.case = 'unstaged change in existing file'
    var got = _.git.hasChanges({ localPath, uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, uncommitted : 1  });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  .then( () =>
  {
    test.case = 'remote has new commit, branch is not downloaded';
    var got = _.git.hasChanges({ localPath, uncommitted : 0, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, uncommitted : 1, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, uncommitted : 0, remote : 1 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, uncommitted : 1, remote : 1 });
    test.identical( got, false );
    return null;
  })
  shell( 'git pull' )
  repoNewCommit( 'testCommit' )
  .then( () =>
  {
    test.case = 'remote has new commit, after checkout';
    var got = _.git.hasChanges({ localPath, uncommitted : 0, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, uncommitted : 1, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, uncommitted : 0, remote : 1 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath, uncommitted : 1, remote : 1 });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'remote has new commit, local executed fetch without merge';
    var got = _.git.hasChanges({ localPath, uncommitted : 0, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, uncommitted : 1, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, uncommitted : 0, remote : 1 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath, uncommitted : 1, remote : 1  });
    test.identical( got, true );
    return null;
  })
  shell( 'git merge' )
  .then( () =>
  {
    test.case = 'merge after fetch, remote had new commit';
    var got = _.git.hasChanges({ localPath, unpushedCommits : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedCommits : 1  });
    test.identical( got, false );
    return null;
  })

  /*  */

  begin()
  shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'new local commit'
    var got = _.git.hasChanges({ localPath, unpushedCommits : false  });
    test.identical( got, false );
    test.case = 'new local commit'
    var got = _.git.hasChanges({ localPath, unpushedCommits : true });
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
    var got = _.git.hasChanges({ localPath, unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedCommits : true, remote : 0  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath, unpushedCommits : false, remote : 1  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath, unpushedCommits : true, remote : 1  });
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
    var got = _.git.hasChanges({ localPath, unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedCommits : true, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedCommits : false, remote : 1  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedCommits : true, remote : 1  });
    test.identical( got, false );
    return null;
  })
  shell( 'git checkout feature' )
  repoNewCommitToBranch( 'testCommit', 'feature' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local executed fetch without merge';
    var got = _.git.hasChanges({ localPath, unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedCommits : true, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedCommits : false, remote : 1  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath, unpushedCommits : true, remote : 1  });
    test.identical( got, true );
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
    test.case = 'remote has commit to other branch, local has commit to master,fetch without merge,branch is not downloaded';
    var got = _.git.hasChanges({ localPath, unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedCommits : true, remote : 0  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath, unpushedCommits : false, remote : 1  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedCommits : true, remote : 1  });
    test.identical( got, true );
    return null;
  })
  shell( 'git checkout feature' )
  repoNewCommitToBranch( 'testCommit', 'feature' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local has commit to master,fetch without merge, branch downloaded';
    var got = _.git.hasChanges({ localPath, unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedCommits : true, remote : 0  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath, unpushedCommits : false, remote : 1  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath, unpushedCommits : true, remote : 1  });
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
    var got = _.git.hasChanges({ localPath, unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedTags : true, unpushedCommits : false  });
    test.identical( got, true );
    return null;
  })
  shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local has pushed tag';
    var got = _.git.hasChanges({ localPath, unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedTags : true, unpushedCommits : false  });
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
    var got = _.git.hasChanges({ localPath, unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedTags : true, unpushedCommits : false  });
    test.identical( got, true );
    return null;
  })
  shell( 'git push --follow-tags' )
  .then( () =>
  {
    test.case = 'local has pushed annotated tag';
    var got = _.git.hasChanges({ localPath, unpushedTags : false, unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedTags : true, unpushedCommits : false, remote : 0  });
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
    var got = _.git.hasChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after rename';
    var got = _.git.hasChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after rename';
    var got = _.git.hasChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after rename';
    var got = _.git.hasChanges({ localPath });
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
    var got = _.git.hasChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after delete';
    var got = _.git.hasChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after delete';
    var got = _.git.hasChanges({ localPath });
    test.identical( got, true );
    return null;
  })
  shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after delete';
    var got = _.git.hasChanges({ localPath });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git checkout -b testbranch' )
  .then( () =>
  {
    test.case = 'local clone has unpushed branch';
    var got = _.git.hasChanges({ localPath, unpushedBranches : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedBranches : 1 });
    test.identical( got, true );
    return null;
  })
  shell( 'git push -u origin testbranch' )
  .then( () =>
  {
    test.case = 'local clone does not have unpushed branch';
    var got = _.git.hasChanges({ localPath, unpushedBranches : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedBranches : 1 });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  shell( 'git tag testtag' )
  .then( () =>
  {
    test.case = 'local clone has unpushed tag';
    var got = _.git.hasChanges({ localPath, unpushedTags : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedTags : 1 });
    test.identical( got, true );
    return null;
  })
  shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local clone doesnt have unpushed tag';
    var got = _.git.hasChanges({ localPath, unpushedTags : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushedTags : 1 });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  .then( () =>
  {
    test.case = 'local clone has unpushed tag';
    let ignoredFilePath = path.join( localPath, 'file' );
    provider.fileWrite( ignoredFilePath,ignoredFilePath )
    _.git.ignoreAdd( localPath, { 'file' : null } )
    return null;
  })
  shell( 'git add --all' )
  shell( 'git commit -am "no desc"' )
  .then( () =>
  {
    test.case = 'has ignored file';
    var got = _.git.hasChanges({ localPath, unpushed : 0, uncommitted : 0, uncommittedIgnored : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushed : 0, uncommitted : 0, uncommittedIgnored : 1 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath, unpushed : 0, uncommitted : 1, uncommittedIgnored : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath, unpushed : 0, uncommitted : 1, uncommittedIgnored : 1 });
    test.identical( got, true );
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
      shell2( 'git -C secondary push -f --set-upstream origin ' + branch )
      else
      shell2( 'git -C secondary push' )

      return con2;
    })

    return con;
  }

}

hasChanges.timeOut = 30000;

//

function hasLocalChangesSpecial( test )
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

  provider.dirMake( testPath );

  /*  */

  begin()
  shell( 'git remote add origin ' + remotePath )
  shell( 'git commit --allow-empty -m test' )
  // shell( 'git status -b --porcelain -u' )
  // shell( 'git push --dry-run' )
  .then( () =>
  {
    debugger
    var got = _.git.hasLocalChanges
    ({
      localPath,
      unpushed : 1,
      uncommitted : 1,
      uncommittedIgnored : 1,
      unpushedCommits : 1,
      unpushedBranches : 1,
      unpushedTags: 0
    })

    test.identical( got, true )

    return null;
  })

  /*  */

  return con;

  /*  */

  function begin()
  {
    con.then( () =>
    {
      provider.filesDelete( localPath );
      provider.dirMake( localPath );
      return shell({ execPath : 'git init', ready : null });
    })

    return con;
  }
}

//

function hasFiles( test )
{
  let context = this;
  let provider = context.provider;
  let path = context.provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'repo' );
  let filePath = path.join( localPath, 'file' );

  test.case = 'missing';
  provider.filesDelete( localPath );
  var got = _.git.hasFiles({ localPath });
  test.identical( got, false );

  test.case = 'terminal';
  provider.filesDelete( localPath );
  provider.fileWrite( localPath, localPath )
  var got = _.git.hasFiles({ localPath });
  test.identical( got, false );

  test.case = 'link';
  provider.filesDelete( localPath );
  provider.dirMake( localPath );
  provider.softLink( filePath, localPath );
  var got = _.git.hasFiles({ localPath : filePath });
  test.identical( got, false );

  test.case = 'empty dir';
  provider.filesDelete( localPath );
  provider.dirMake( localPath )
  var got = _.git.hasFiles({ localPath });
  test.identical( got, false );

  test.case = 'dir with file';
  provider.filesDelete( localPath );
  provider.fileWrite( filePath, filePath )
  var got = _.git.hasFiles({ localPath });
  test.identical( got, true );
}

//

function hasRemote( test )
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
    let got = _.git.hasRemote({ localPath, remotePath : remotePath });
    test.identical( got.downloaded, false )
    test.identical( got.remoteIsValid, false )
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
    let got = _.git.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true )
    test.identical( got.remoteIsValid, true )
    return null;
  })

  .then( () =>
  {
    let got = _.git.hasRemote({ localPath, remotePath : remotePath2 });
    test.identical( got.downloaded, true )
    test.identical( got.remoteIsValid, false )
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


function isUpToDateExtended( test )
{
  let context = this;
  let provider = context.provider;
  let path = context.provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'wTools' );

  let con = new _.Consequence().take( null )

  let shell = _.process.starter
  ({
    currentPath : testPath,
    mode : 'spawn',
  })

  begin()

  //

  .then( () =>
  {
    test.case = 'both on master, no changes';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/@master';
    return _.git.isUpToDate({ localPath, remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  //

  .then( () =>
  {
    test.case = 'both on master, local one commit behind';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/@master';
    return shell( 'git -C wTools reset --hard HEAD~1' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  //

  begin()

  //

  .then( () =>
  {
    test.case = 'local on master, remote on other branch';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/@other';
    return _.git.isUpToDate({ localPath, remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  //

  .then( () =>
  {
    test.case = 'local on master, remote on tag points to other commit';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/@v0.8.505';
    return _.git.isUpToDate({ localPath, remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  //

  .then( () =>
  {
    test.case = 'local on same tag with remote';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/@v0.8.505';
    return shell( 'git -C wTools checkout v0.8.505' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  //

  .then( () =>
  {
    test.case = 'local on different tag with remote';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/@v0.8.505';
    return shell( 'git -C wTools checkout v0.8.504' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  //

  .then( () =>
  {
    test.case = 'local on same commit as tag on remote';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/@v0.8.505';
    return shell( 'git -C wTools checkout 8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  //

  .then( () =>
  {
    test.case = 'local on different commit as tag on remote';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/@v0.8.505';
    return shell( 'git -C wTools checkout 8b5d86906b761c464a10618fc06f13724ee654ab' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  //

  .then( () =>
  {
    test.case = 'local on tag, remote on master';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/@master';
    return shell( 'git -C wTools checkout v0.8.504' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  //

  .then( () =>
  {
    test.case = 'local on tag, remote on hash that local tag is pointing to';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/#8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3';
    return shell( 'git -C wTools checkout v0.8.505' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  //

  .then( () =>
  {
    test.case = 'local on tag, remote on different hash';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/#8b5d86906b761c464a10618fc06f13724ee654ab';
    return shell( 'git -C wTools checkout v0.8.505' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })
  
  //
  
  begin()
  
  //
  
  .then( () =>
  {
    test.case = 'local on master, remote is different';
    let remotePath = 'git+https:///github.com/Wandalen/wTools2.git/';
    return shell( 'git -C wTools checkout master' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })
  
  .then( () =>
  {
    test.case = 'local on tag, remote is different';
    let remotePath = 'git+https:///github.com/Wandalen/wTools2.git/';
    return shell( 'git -C wTools checkout v0.8.505' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })
  
  .then( () =>
  {
    test.case = 'local detached, remote is different';
    let remotePath = 'git+https:///github.com/Wandalen/wTools2.git/';
    return shell( 'git -C wTools checkout 8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })
  
  //
  
  begin()
  .then( () =>
  {
    test.case = 'local does not have gitconfig';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/';
    return _.fileProvider.filesDelete({ filePath : _.path.join( localPath, '.git'), sync : 0 })
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })
  
  //
  
  begin()
  .then( () =>
  {
    test.case = 'local does not have origin';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/';
    return shell( 'git -C wTools remote remove origin' )
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })
  
  //
  
  .then( () =>
  {
    test.case = 'local does not exist';
    let remotePath = 'git+https:///github.com/Wandalen/wTools.git/';
    return _.fileProvider.filesDelete({ filePath : localPath, sync : 0 })
    .then( () => _.git.isUpToDate({ localPath, remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })
  
  //

  return con;

  /*  */

  function begin()
  {
    con.then( () =>
    {
      provider.filesDelete( localPath );
      provider.dirMake( localPath );
      return shell( 'git clone https://github.com/Wandalen/wTools.git ' + path.name( localPath ) )
    })

    return con;
  }
}

isUpToDateExtended.timeOut = 60000;

//

function insideRepository( test )
{
  test.case = 'missing'
  var insidePath = _.path.join( __dirname, 'someFile' );
  var got = _.git.insideRepository({ insidePath })
  test.identical( got,true )

  test.case = 'terminal'
  var insidePath = _.path.normalize( __filename );
  var got = _.git.insideRepository({ insidePath })
  test.identical( got,true )

  test.case = 'testdir'
  var insidePath = _.path.normalize( __dirname );
  var got = _.git.insideRepository({ insidePath })
  test.identical( got,true )

  test.case = 'root of repo'
  var insidePath = _.path.join( __dirname, '../../../..' );
  var got = _.git.insideRepository({ insidePath })
  test.identical( got,true )

  test.case = 'outside of repo'
  var insidePath = _.path.join( __dirname, '../../../../..' );
  var got = _.git.insideRepository({ insidePath })
  test.identical( got,false )
}

//

function isRepository( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'clone' );
  let repoPath = path.join( testPath, 'repo' );
  let repoPathNative = path.nativize( repoPath );

  let remotePath = 'https://github.com/Wandalen/wPathBasic.git';
  let remotePathGlobal = 'git+https:///github.com/Wandalen/wPathBasic.git#master';
  let remotePathGlobalWithOut = 'git+https:///github.com/Wandalen/wPathBasic.git/out/wPathBasic#master';
  let remotePath2 = 'https://github.com/Wandalen/wTools.git';
  let remotePathGlobal2 = 'git+https:///github.com/Wandalen/wTools.git#master';
  let remotePathGlobalWithOut2 = 'git+https:///github.com/Wandalen/wTools.git/out/wTools#master';
  let remotePath3 = 'git+https:///github.com/Wandalen/wSomeModule.git/out/wSomeModule#master';


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

  .then( () =>
  {
    test.case = 'not cloned, only remotePath'
    var got = _.git.isRepository({ remotePath : repoPath });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : remotePath });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : remotePathGlobal });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : remotePathGlobalWithOut });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : remotePath2 });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : remotePathGlobal2 });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : remotePathGlobalWithOut2 });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : remotePath3 });
    test.identical( got, false );
    return null;
  })

  .then( () =>
  {
    test.case = 'not cloned'
    var got = _.git.isRepository({ localPath });
    test.identical( got, false );
    var got = _.git.isRepository({ localPath, remotePath : repoPath });
    test.identical( got, false );
    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'check after fresh clone'
    var got = _.git.isRepository({ localPath });
    test.identical( got, true );
    var got = _.git.isRepository({ localPath, remotePath : repoPath });
    test.identical( got, true );
    return null;
  })

  begin()
  .then( () =>
  {
    test.case = 'cloned, other remote'
    var got = _.git.isRepository({ localPath });
    test.identical( got, true );
    var got = _.git.isRepository({ localPath, remotePath : remotePath });
    test.identical( got, false );
    return null;
  })

  begin()
  .then( () =>
  {
    test.case = 'cloned, provided remote is not a repo'
    var got = _.git.isRepository({ localPath });
    test.identical( got, true );
    var got = _.git.isRepository({ localPath, remotePath : remotePath2 });
    test.identical( got, false );
    return null;
  })

  begin2()
  .then( () =>
  {
    test.case = 'cloned, provided global remote path to repo'
    var got = _.git.isRepository({ localPath });
    test.identical( got, true );
    var got = _.git.isRepository({ localPath, remotePath : remotePathGlobal });
    test.identical( got, true );
    return null;
  })

  begin2()
  .then( () =>
  {
    test.case = 'cloned, provided wrong global remote path to repo'
    var got = _.git.isRepository({ localPath });
    test.identical( got, true );
    var got = _.git.isRepository({ localPath, remotePath : remotePathGlobal2 });
    test.identical( got, false );
    return null;
  })

  begin2()
  .then( () =>
  {
    test.case = 'cloned, provided global remote path to repo with out file'
    var got = _.git.isRepository({ localPath });
    test.identical( got, true );
    var got = _.git.isRepository({ localPath, remotePath : remotePathGlobalWithOut });
    test.identical( got, true );
    return null;
  })

  begin2()
  .then( () =>
  {
    test.case = 'cloned, provided global remote path to repo with out file'
    var got = _.git.isRepository({ localPath });
    test.identical( got, true );
    var got = _.git.isRepository({ localPath, remotePath : remotePathGlobalWithOut2 });
    test.identical( got, false );
    return null;
  })

  /* -async- */

  begin2()
  .then( () =>
  {
    test.case = 'cloned, provided local path to repo'
    return _.git.isRepository({ localPath, sync : 0 })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return null;
    })
  })
  .then( () =>
  {
    test.case = 'cloned, provided global local & remote paths to repo'
    return _.git.isRepository({ localPath, sync : 0, remotePath : remotePathGlobal })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return null;
    })
  })

  /*  */

  begin2()
  .then( () =>
  {
    test.case = 'cloned, provided global remote path to repo with out file'
    return _.git.isRepository({ localPath, sync : 0 })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return null;
    })
  })
  .then( () =>
  {
    test.case = 'cloned, provided global remote path to repo with out file'
    return _.git.isRepository({ localPath, sync : 0, remotePath : remotePathGlobalWithOut2 })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return null;
    })
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

  function begin2()
  {
    con.then( () =>
    {
      test.case = 'clean clone';
      provider.filesDelete( localPath );
      return _.process.start
      ({
        execPath : 'git clone ' + remotePath + ' ' + path.name( localPath ),
        currentPath : testPath,
      })
    })

    return con;
  }
}

isRepository.timeOut = 30000;

//

function status( test )
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

  begin()
  .then( () =>
  {
    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      remote : 0,
      uncommitted : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
       remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,
      conflicts : null,

      local : null,
      remote : null,


      status: null
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 1,
      unpushed : 0,
      remote : 0,
      uncommitted : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
       remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,
      conflicts : null,

      local : null,
      remote : null,


      status: null
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 1,
      unpushed : null,
      remote : 0,
      uncommitted : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,

      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      conflicts : null,
      local : false,
      remote : null,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 1,
      unpushed : 0,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: false,
      uncommittedDeleted: false,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,

      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      conflicts : false,
      local : false,
      remote : null,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 1,
      unpushed : null,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: false,
      uncommittedDeleted: false,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,

      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      conflicts : false,
      local : false,
      remote : null,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : null,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,

      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      conflicts : null,
      local : null,
      remote : null,

      status: null
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : 1,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,

      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      conflicts : null,
      local : false,
      remote : null,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : null,
      uncommitted : 1,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: false,
      uncommittedDeleted: false,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,

      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      'conflicts' : false,
      'local' : false,
      'remote' : null,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : 1,
      uncommitted : 1,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: false,
      uncommittedDeleted: false,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,

      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      conflicts : false,
      local : false,
      remote : null,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,

      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      conflicts : null,
      local : null,
      remote : null,

      status: null
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 1,
      remoteBranches : 0,
      remoteTags : 0,
      remoteCommits : 0,
      detailing : 1,
      explaining : 1,

    })
    var expected =
    {
       remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,
      conflicts : null,

      local : null,
      remote : null,


      status: null
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 1,
      remoteBranches : null,
      remoteTags : null,
      remoteCommits : null,
      detailing : 1,
      explaining : 1,

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: false,
      remoteTags: false,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      conflicts : null,
      local : null,
      remote : false,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 0,
      remoteBranches : null,
      remoteTags : null,
      remoteCommits : null,
      detailing : 1,
      explaining : 1,

    })
    var expected =
    {
       remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,
      conflicts : null,

      local : null,
      remote : null,


      status: null
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 0,
      remoteBranches : 1,
      remoteTags : null,
      remoteCommits : null,
      detailing : 1,
      explaining : 1,

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      conflicts : null,
      local : null,
      remote : false,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 0,
      remoteBranches : 1,
      remoteTags : null,
      remoteCommits : 1,
      detailing : 1,
      explaining : 1,

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: false,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      conflicts : null,
      local : null,
      remote : false,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 0,
      remoteBranches : 1,
      remoteTags : 1,
      remoteCommits : 1,
      detailing : 1,
      explaining : 1,

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: false,
      remoteTags: false,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      conflicts : null,
      local : null,
      remote : false,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 1,
      remoteBranches : 1,
      remoteTags : 1,
      remoteCommits : 1,
      detailing : 1,
      explaining : 1,

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: false,
      remoteTags: false,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      conflicts : null,
      local : null,
      remote : false,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 1,
      unpushed : null,
      uncommitted : null,
      remote : 1,
      remoteBranches : null,
      remoteTags : null,
      remoteCommits : null,
      detailing : 1,
      explaining : 1,

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: false,
      remoteTags: false,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: false,
      uncommittedDeleted: false,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,
      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      conflicts : false,
      local : false,
      remote : false,

      status: false
    }
    test.identical( status,expected );

    //

    var status = _.git.status
    ({
      localPath : localPath,
      local : 1,
      unpushed : null,
      uncommitted : null,
      uncommittedCopied : 0,
      uncommittedDeleted : 0,
      remote : 1,
      remoteBranches : null,
      remoteTags : null,
      remoteCommits : 0,
      detailing : 1,
      explaining : 1,

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: null,
      remoteTags: false,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,
      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      conflicts : false,
      local : false,
      remote : false,

      status: false
    }
    test.identical( status,expected );

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

status.timeOut = 30000;

//

function statusFull( test )
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

  begin()
  .then( () =>
  {
    debugger
    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      remote : 0,
      uncommitted : 0,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      conflicts : null,

      prs : null,

      local : null,
      remote : null,

      status: null,

      isRepository : true
    }
    test.identical( status,expected );

    //

    debugger
    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 1,
      unpushed : 0,
      remote : 0,
      uncommitted : 0,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      conflicts : null,

      prs : null,

      local : null,
      remote : null,

      status: null,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 1,
      unpushed : null,
      remote : 0,
      uncommitted : 0,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,

      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      conflicts : null,

      prs : null,

      local : false,
      remote : null,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 1,
      unpushed : 0,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: false,
      uncommittedDeleted: false,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,

      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      prs : null,

      conflicts : false,

      local : false,
      remote : null,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 1,
      unpushed : null,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: false,
      uncommittedDeleted: false,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,

      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      prs : null,

      conflicts : false,

      local : false,
      remote : null,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : null,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,

      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      prs : null,

      conflicts : null,

      local : null,
      remote : null,

      status: null,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : 1,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,

      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      prs : null,

      conflicts : null,

      local : false,
      remote : null,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : null,
      uncommitted : 1,
      remote : 0,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: false,
      uncommittedDeleted: false,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,

      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      prs : null,

      conflicts : false,

      local : false,
      remote : null,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : 1,
      uncommitted : 1,
      remote : 0,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: false,
      uncommittedDeleted: false,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,

      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      prs : null,

      conflicts : false,

      local : false,
      remote : null,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 0,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,

      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      prs : null,

      conflicts : null,

      local : null,
      remote : null,

      status: null,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 1,
      remoteBranches : 0,
      remoteTags : 0,
      remoteCommits : 0,
      detailing : 1,
      explaining : 1,
      prs : 0

    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      prs : null,

      conflicts : null,

      local : null,
      remote : null,

      status: null,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 1,
      remoteBranches : null,
      remoteTags : null,
      remoteCommits : null,
      detailing : 1,
      explaining : 1,
      prs : 0

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: false,
      remoteTags: false,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      prs : null,

      conflicts : null,

      local : null,
      remote : false,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 0,
      remoteBranches : null,
      remoteTags : null,
      remoteCommits : null,
      detailing : 1,
      explaining : 1,
      prs : 0

    })
    var expected =
    {
      remoteBranches: null,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      prs : null,

      conflicts : null,

      local : null,
      remote : null,

      status: null,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 0,
      remoteBranches : 1,
      remoteTags : null,
      remoteCommits : null,
      detailing : 1,
      explaining : 1,
      prs : 0

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: null,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      prs : null,

      conflicts : null,

      local : null,
      remote : false,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 0,
      remoteBranches : 1,
      remoteTags : null,
      remoteCommits : 1,
      detailing : 1,
      explaining : 1,
      prs : 0

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: false,
      remoteTags: null,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      prs : null,

      conflicts : null,

      local : null,
      remote : false,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 0,
      remoteBranches : 1,
      remoteTags : 1,
      remoteCommits : 1,
      detailing : 1,
      explaining : 1,
      prs : 0

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: false,
      remoteTags: false,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      prs : null,

      conflicts : null,

      local : null,
      remote : false,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 1,
      remoteBranches : 1,
      remoteTags : 1,
      remoteCommits : 1,
      detailing : 1,
      explaining : 1,
      prs : 0

    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: false,
      remoteTags: false,

      uncommitted: null,
      uncommittedAdded: null,
      uncommittedChanged: null,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: null,
      uncommittedUntracked: null,
      uncommittedUnstaged: null,
      unpushed: null,
      unpushedBranches: null,
      unpushedCommits: null,
      unpushedTags: null,

      prs : null,

      conflicts : null,

      local : null,
      remote : false,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 1,
      unpushed : null,
      uncommitted : null,
      remote : 1,
      remoteBranches : null,
      remoteTags : null,
      remoteCommits : null,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: false,
      remoteTags: false,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: false,
      uncommittedDeleted: false,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,
      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      prs : null,

      conflicts : false,

      local : false,
      remote : false,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 1,
      unpushed : null,
      uncommitted : null,
      uncommittedCopied : 0,
      uncommittedDeleted : 0,
      remote : 1,
      remoteBranches : null,
      remoteTags : null,
      remoteCommits : 0,
      detailing : 1,
      explaining : 1,
      prs : 0
    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: null,
      remoteTags: false,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: null,
      uncommittedDeleted: null,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,
      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      prs : null,

      conflicts : false,

      local : false,
      remote : false,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

    //

    var status = _.git.statusFull
    ({
      localPath : localPath,
      local : 1,
      unpushed : null,
      uncommitted : null,
      remote : 1,
      remoteBranches : null,
      remoteTags : null,
      remoteCommits : null,
      detailing : 1,
      explaining : 1,
      prs : 1
    })
    var expected =
    {
      remoteBranches: false,
      remoteCommits: false,
      remoteTags: false,

      uncommitted: false,
      uncommittedAdded: false,
      uncommittedChanged: false,
      uncommittedCopied: false,
      uncommittedDeleted: false,
      uncommittedIgnored: null,
      uncommittedRenamed: false,
      uncommittedUntracked: false,
      uncommittedUnstaged: false,
      unpushed: false,
      unpushedBranches: false,
      unpushedCommits: false,
      unpushedTags: false,

      prs : _.maybe,

      conflicts : false,

      local : false,
      remote : false,

      status: false,

      isRepository : true
    }
    test.identical( status,expected );

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

statusFull.timeOut = 30000;

//


function statusEveryCheck( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = path.join( context.suitePath, 'routine-' + test.name );
  let localPath = path.join( testPath, 'clone' );
  let repoPath = path.join( testPath, 'repo' );
  let secondaryPath = path.join( testPath, 'secondary' );
  let repoPathNative = path.nativize( repoPath );
  let remotePath = 'https://github.com/Wandalen/wPathBasic.git';
  let filePath = path.join( localPath, 'newFile' );
  let readmePath = path.join( localPath, 'README' );

  let con = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    currentPath : testPath,
    ready : con
  })

  let repo = _.process.starter
  ({
    currentPath : repoPath,
    ready : con,
  })

  let cloned = _.process.starter
  ({
    currentPath : localPath,
    ready : con
  })

  let secondary = _.process.starter
  ({
    currentPath : secondaryPath,
    ready : con
  })

  provider.dirMake( testPath )

  /*  */

  prepareRepo()
  repoNewCommit( 'newcommit' );
  repoNewCommitToBranch( 'newcommittobranch', 'second' )
  begin()
  remoteChanges()
  localChanges()
  .then( () =>
  {
    var status = _.git.status
    ({
      localPath : localPath,

      detailing : 1,
      explaining : 1,

      remote : 1,
      remoteBranches : 1,
      remoteCommits : 1,
      remoteTags: 1,

      local : 1,
      uncommitted : 1,
      uncommittedUntracked : 1,
      uncommittedAdded : 1,
      uncommittedChanged : 1,
      uncommittedDeleted : 1,
      uncommittedRenamed : 1,
      uncommittedCopied : 1,
      uncommittedIgnored : 1,
      unpushed : 1,
      unpushedCommits : 1,
      unpushedTags : 1,
      unpushedBranches : 1,

      conflicts : 1
    })

    let expectedStatus =
    [
      'List of uncommited changes in files:',
      '  \\?\\? copied2',
      '  \\?\\? untracked',
      '  A  \\.gitignore',
      '  A  added',
      '  M  changed',
      '  M changed2',
      '  D deleted',
      '  R  renamed -> renamed2',
      '  !! ignored',
      'List of branches with unpushed commits:',
      '  \\* master .* \\[origin\\/master: ahead 1\\] test',
      '  second .* \\[origin\\\/second: ahead 1\\] test',
      'List of unpushed:',
      '  \\[new tag\\]   tag2 -> tag2',
      '  \\[new tag\\]   tag3 -> tag3',
      '  \\[new branch\\]        new -> \\?',
      'List of unpulled remote branches:',
      '  refs\\/heads\\/testbranch',
      'List of remote branches that have new commits:',
      '  refs\\/heads\\/master',
      '  refs\\/heads\\/second',
      'List of unpulled remote tags:',
      '  refs\\/tags\\/testtag',
      '  refs\\/tags\\/testtag2',
      '  refs\\/tags\\/testtag2\\^\\{\\}',
    ]

    debugger

    _.each( expectedStatus, ( line ) =>
    {
      test.case = 'status has line: ' + _.strQuote( line )
      test.is(  !!status.status.match( line ) )
    })

    test.identical( status.conflicts, false );

    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' );
  begin()
  cloned( 'git checkout -b  newbranch' )
  cloned( 'echo \"Hello World!\" > changed' )
  cloned( 'git commit -am change' )
  cloned( 'git checkout master' )
  cloned( 'echo \"Hello world!\" > changed' )
  cloned( 'git commit -am change' )
  cloned({ execPath : 'git merge newbranch', throwingExitCode : 0 })
  cloned( 'git status --b --porcelain -u ')
  .then( () =>
  {
    var status = _.git.status
    ({
      localPath : localPath,

      detailing : 1,
      explaining : 1,
      remote : 0,
      local : 0,
      conflicts : 1
    })

    let expectedStatus =
    [
      'List of uncommited changes in files:',
      '  UU changed'
    ]

    _.each( expectedStatus, ( line ) =>
    {
      test.case = 'status has line: ' + _.strQuote( line )
      test.is(  !!status.status.match( line ) )
    })

    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' );
  begin()
  remoteChanges()
  cloned( 'touch untracked' )
  cloned( 'touch tracked' )
  cloned( 'touch file' )
  cloned( 'git add tracked' )
  cloned( 'git add file' )
  cloned( 'git commit -m test file' )
  cloned( 'echo "xxx" > file' )
  cloned( 'git checkout -b  newbranch' )
  cloned( 'echo \"Hello World!\" > changed' )
  cloned( 'git commit -am change' )
  cloned( 'git checkout master' )
  cloned( 'echo \"Hello world!\" > changed' )
  cloned( 'git commit -am change' )
  cloned({ execPath : 'git merge newbranch', throwingExitCode : 0 })
  .then( () =>
  {
    var status = _.git.status
    ({
      localPath : localPath,

      detailing : 1,
      explaining : 1,
      remote : 1,
      local : 1,
      conflicts : 1
    })

    let expectedStatus =
    [
      'List of uncommited changes in files:',
      '  \\?\\? untracked',
      '  A  tracked',
      '  M  file',
      '  UU changed',
      'List of branches with unpushed commits:',
      '  \\* master    .* \\[origin\\/master: ahead 2\\] change',
      'List of unpushed:',
      '  \\[new branch\\]        newbranch -> \\?',
      'List of remote branches that have new commits:',
      '  refs\\/heads\\/master',
      'List of unpulled remote tags:',
      '  refs\\/tags\\/testtag',
      '  refs\\/tags\\/testtag2',
      '  refs\\/tags\\/testtag2\\^\\{\\}'
    ]

    debugger
    _.each( expectedStatus, ( line ) =>
    {
      test.case = 'status has line: ' + _.strQuote( line )
      test.is(  !!status.status.match( line ) )
    })

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

    repo( 'git init --bare' );

    con.then( () =>
    {
      let secondRepoPath = path.join( testPath, 'secondary' );
      provider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + repoPathNative + ' secondary' )
    con.then( () =>
    {
      provider.fileWrite( path.join( testPath, 'secondary', 'changed' ), 'changed' )
      provider.fileWrite( path.join( testPath, 'secondary', 'renamed' ), 'renamed' )
      provider.fileWrite( path.join( testPath, 'secondary', 'copied' ), 'copied' )
      provider.fileWrite( path.join( testPath, 'secondary', 'deleted' ), 'deleted' )
      provider.fileWrite( path.join( testPath, 'secondary', 'changed2' ), 'changed2' )
      return null;
    })

    shell( 'git -C secondary add -fA .' )
    shell( 'git -C secondary commit -m init' )
    shell( 'git -C secondary push' )

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

  function remoteChanges()
  {
    repoNewCommit( 'newcommit' )// new commit to master
    repoNewCommitToBranch( 'newcommittobranch', 'testbranch' )// new branch
    repoNewCommitToBranch( 'newcommittobranch', 'second' )// new commit to second branch
    repoNewTag( 'testtag' )//regular tag
    repoNewTag( 'testtag2', true ) //annotated tag

    return con;
  }

  function localChanges()
  {
    cloned( 'git checkout -b new' )//unpushed branch
    cloned( 'git checkout second' )//commit to second branch
    cloned( 'git commit --allow-empty -m test' )
    cloned( 'git checkout master' )//commit to master branch
    cloned( 'git commit --allow-empty -m test' )

    con.then( () =>
    {
      provider.fileWrite( provider.path.join( localPath, 'added' ), 'added' )
      provider.fileWrite( provider.path.join( localPath, 'untracked' ), 'untracked' )
      provider.fileWrite( provider.path.join( localPath, 'ignored' ), 'ignored' )

      provider.fileWrite( provider.path.join( localPath, 'changed' ), 'changed2' )
      provider.fileWrite( provider.path.join( localPath, 'changed2' ), 'changed3' )
      provider.fileDelete( provider.path.join( localPath, 'deleted' ) )
      provider.fileCopy( provider.path.join( localPath, 'copied2' ),provider.path.join( localPath, 'copied' ) )

      _.git.ignoreAdd( localPath, { 'ignored' : null } )

      return null;
    })

    cloned( 'git add .gitignore' )
    cloned( 'git add added' )
    cloned( 'git mv renamed renamed2' )
    cloned( 'git add changed' )
    cloned( 'git tag tag2' )
    cloned( 'git tag -a tag3 -m "sometag"' )

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

  function repoNewTag( tag, annotated )
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

    if( !annotated )
    {
      shell( 'git -C secondary tag ' + tag )
    }
    else
    {
      shell( `git -C secondary tag -a ${tag} -m "sometag"` )
    }

    shell( 'git -C secondary push --tags' )

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
      {
        shell2( 'git -C secondary checkout -b ' + branch )
        shell2( 'git -C secondary branch -u origin' )
        shell2( 'git -C secondary push -f origin ' + branch )
      }
      else
      {
        shell2( 'git -C secondary checkout ' + branch )
      }

      shell2( 'git -C secondary commit --allow-empty -m ' + message )
      shell2( 'git -C secondary push origin ' + branch )

      return con2;
    })

    return con;
  }

}

statusEveryCheck.timeOut = 30000;

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
    pathParse,

    versionsRemoteRetrive,
    versionsPull,

    statusLocal,
    statusLocalEmpty,
    statusLocalEmptyWithOrigin,
    statusLocalAsync,
    statusLocalExplainingTrivial,
    statusLocalExtended,
    statusFullHalfStaged,
    statusRemote,
    statusRemoteTags,
    statusRemoteVersionOption,
    //qqq Vova: add test routine for statuRemote with case when local is in detached state
    status,
    hasLocalChanges,
    hasRemoteChanges,
    hasChanges,
    hasLocalChangesSpecial,

    hasFiles,
    hasRemote,
    isUpToDate,
    isUpToDateExtended,
    insideRepository,
    isRepository,

    statusFull,
    statusEveryCheck,

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
