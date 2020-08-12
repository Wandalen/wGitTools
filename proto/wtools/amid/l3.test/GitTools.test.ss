( function _GitTools_test_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../wtools/Tools.s' );

  _.include( 'wTesting' );

  require( '../l3/git/entry/GitTools.ss' );
}

//

let _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin( test )
{
  let context = this;
  context.provider = _.fileProvider;
  let path = context.provider.path;
  context.suiteTempPath = context.provider.path.tempOpen( path.join( __dirname, '../..'  ), 'GitTools' );
  context.assetsOriginalPath = _.path.join( __dirname, '_asset' );
}

//

function onSuiteEnd( test )
{
  let context = this;
  let path = context.provider.path;
  _.assert( _.strHas( context.suiteTempPath, 'GitTools' ), context.suiteTempPath );
  path.tempClose( context.suiteTempPath );
}

// --
// tests
// --

function pathParse( test )
{
  var remotePath = 'git:///git@bitbucket.org:someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'master',
    'longPath' : '/git@bitbucket.org:someorg/somerepo.git',
    'localVcsPath' : './',
    'remoteVcsPath' : 'git@bitbucket.org:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@bitbucket.org:someorg/somerepo.git',
    'isFixated' : false
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git:///git@bitbucket.org:someorg/somerepo.git/#master';
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'master',
    'longPath' : '/git@bitbucket.org:someorg/somerepo.git/',
    'localVcsPath' : './',
    'remoteVcsPath' : 'git@bitbucket.org:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@bitbucket.org:someorg/somerepo.git',
    'isFixated' : false
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/#041839a730fa104a7b6c7e4935b4751ad81b00e0';
  var expected =
  {
    'protocol' : 'git+https',
    'hash' : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
    'longPath' : '/github.com/Wandalen/wModuleForTesting1.git/',
    'localVcsPath' : './',
    'remoteVcsPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
    'remoteVcsLongerPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
    'isFixated' : true
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!0.0.37'
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : '0.0.37',
    'longPath' : '/github.com/Wandalen/wModuleForTesting1.git/',
    'localVcsPath' : './',
    'remoteVcsPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
    'remoteVcsLongerPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
    'isFixated' : false
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master'
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'master',
    'longPath' : '/github.com/Wandalen/wModuleForTesting1.git/',
    'localVcsPath' : './',
    'remoteVcsPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
    'remoteVcsLongerPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
    'isFixated' : false
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+hd://Tools?out=out/wTools.out.will!master'
  var expected =
  {
    'protocol' : 'git+hd',
    'query' : 'out=out/wTools.out.will',
    'tag' : 'master',
    'longPath' : 'Tools',
    'localVcsPath' : 'out/wTools.out.will',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'isFixated' : false
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+hd://Tools?out=out/wTools.out.will!v0.8.505'
  var expected =
  {
    'protocol' : 'git+hd',
    'query' : 'out=out/wTools.out.will',
    'tag' : 'v0.8.505',
    'longPath' : 'Tools',
    'localVcsPath' : 'out/wTools.out.will',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'isFixated' : false
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  var remotePath = 'git+hd://Tools?out=out/wTools.out.will/!v0.8.505'
  var expected =
  {
    'protocol' : 'git+hd',
    'query' : 'out=out/wTools.out.will/',
    'tag' : 'v0.8.505',
    'longPath' : 'Tools',
    'localVcsPath' : 'out/wTools.out.will/',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
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
    'remoteVcsLongerPath' : 'Tools',
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
    'remoteVcsLongerPath' : 'Tools',
    'isFixated' : true
  }
  var got = _.git.pathParse( remotePath );
  test.identical( got, expected )

  test.case = 'both hash and tag'
  var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/#8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3!master';
  test.shouldThrowErrorSync( () => _.git.pathParse( remotePath ) );
}

function versionsRemoteRetrive( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  let cloneShell = _.process.starter
  ({
    currentPath : a.abs( 'clone' ),
    ready : a.ready,
  })

  let repoShell = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready,
  })

  a.fileProvider.dirMake( a.abs( '.' ) );

  /* */

  a.ready.then( () =>
  {
    test.case = 'not git repository';
    return test.shouldThrowErrorAsync( _.git.versionsRemoteRetrive({ localPath : a.abs( 'clone' ) }) );
  })

  .then( () =>
  {
    test.case = 'setup repo';
    a.fileProvider.filesDelete( a.abs( 'repo' ) );
    return _.process.start
    ({
      execPath : 'git clone ' + 'https://github.com/Wandalen/wModuleForTesting1.git' + ' ' + 'repo',
      currentPath : a.abs( '.' ),
    })
  })

  /* */

  .then( () =>
  {
    test.case = 'setup';
    a.fileProvider.filesDelete( a.abs( 'clone' ) );
    return _.process.start
    ({
      execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
      currentPath : a.abs( '.' ),
    })
  })

  /* */

  .then( () => _.git.versionsRemoteRetrive({ localPath : a.abs( 'clone' ) }) )
  .then( ( got ) =>
  {
    test.identical( got, [ 'master' ] );
    return got;
  })

  /* */

  repoShell( 'git checkout -b feature' )
  .then( () => _.git.versionsRemoteRetrive({ localPath : a.abs( 'clone' ) }) )
  .then( ( got ) =>
  {
    test.case = 'remote has new branch, clone is outdated'
    test.identical( got, [ 'master' ] );
    return got;
  })

  cloneShell( 'git fetch' )
  .then( () => _.git.versionsRemoteRetrive({ localPath : a.abs( 'clone' ) }) )
  .then( ( got ) =>
  {
    test.case = 'remote has new branch, clone is up-to-date'
    test.identical( got, [ 'feature', 'master' ] );
    return got;
  })

  repoShell( 'git checkout master' )
  repoShell( 'git branch -d feature' )
  .then( () => _.git.versionsRemoteRetrive({ localPath : a.abs( 'clone' ) }) )
  .then( ( got ) =>
  {
    test.case = 'remote removed new branch, clone is outdated'
    test.identical( got, [ 'feature', 'master' ] );
    return got;
  })

  cloneShell( 'git fetch -p' )
  .then( () => _.git.versionsRemoteRetrive({ localPath : a.abs( 'clone' ) }) )
  .then( ( got ) =>
  {
    test.case = 'remote removed new branch, clone is up-to-date'
    test.identical( got, [ 'master' ] );
    return got;
  })

  return a.ready;
}

versionsRemoteRetrive.routineTimeOut = 30000;

//

function versionsPull( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  /* */

  a.ready.then( () =>
  {
    test.case = 'not git repository';
    return test.shouldThrowErrorAsync( _.git.versionsPull({ localPath : a.abs( 'clone' ) }) );
  })

  .then( () =>
  {
    test.case = 'setup repo';
    a.fileProvider.filesDelete( a.abs( 'repo' ) );
    return _.process.start
    ({
      execPath : 'git clone ' + 'https://github.com/Wandalen/wModuleForTesting1.git' + ' ' + 'repo',
      currentPath : a.abs( '.' ),
    })
  })

  /* */

  .then( () =>
  {
    test.case = 'setup';
    a.fileProvider.filesDelete( a.abs( 'clone' ) );
    return _.process.start
    ({
      execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
      currentPath : a.abs( '.' ),
    })
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'no changes';
    return _.git.versionsPull({ localPath : a.abs( 'clone' ) });
  })
  .then( () => _.git.versionsRemoteRetrive({ localPath : a.abs( 'clone' ) }) )
  .then( ( got ) =>
  {
    test.identical( got, [ 'master' ] );
    let execPath = got.map(( branch ) => `git checkout ${branch} && git status` )
    return _.process.start
    ({
      execPath,
      outputCollecting : 1,
      throwingExitCode : 0,
      mode : 'shell',
      currentPath : a.abs( 'clone' ),
    })
  })
  .then( ( got ) =>
  {
    test.identical( got.length, 1 );
    _.each( got, ( result ) =>
    {
      test.identical( result.exitCode, 0 );
      test.is( _.strHasAny( result.output, [ 'is up to date', 'is up-to-date' ] ) );
    })
    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'new branch on remote';
    return null;
  })
  a.shell2( 'git checkout -b feature' )
  a.shell( 'git fetch' )
  .then( () => _.git.versionsPull({ localPath : a.abs( 'clone' ) }) )
  .then( () => _.git.versionsRemoteRetrive({ localPath : a.abs( 'clone' ) }) )
  .then( ( got ) =>
  {
    test.identical( got, [ 'feature', 'master' ] );
    let execPath = got.map(( branch ) => `git checkout ${branch} && git status` )
    return _.process.start
    ({
      execPath,
      outputCollecting : 1,
      throwingExitCode : 0,
      mode : 'shell',
      currentPath : a.abs( 'clone' ),
    })
  })
  .then( ( got ) =>
  {
    test.identical( got.length, 2 );
    _.each( got, ( result ) =>
    {
      test.identical( result.exitCode, 0 );
      test.is( _.strHasAny( result.output, [ 'is up to date', 'is up-to-date' ] ) );
    })
    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'new commits on remote';
    return null;
  })
  a.shell2( 'git checkout master' )
  a.shell2( 'git commit --allow-empty -m test1' )
  a.shell2( 'git checkout feature' )
  a.shell2( 'git commit --allow-empty -m test2' )
  a.shell( 'git fetch' )
  .then( () => _.git.versionsPull({ localPath : a.abs( 'clone' ) }) )
  .then( () => _.git.versionsRemoteRetrive({ localPath : a.abs( 'clone' ) }) )
  .then( ( got ) =>
  {
    test.identical( got, [ 'feature', 'master' ] );
    let execPath = got.map(( branch ) => `git checkout ${branch} && git status` )
    return _.process.start
    ({
      execPath,
      outputCollecting : 1,
      throwingExitCode : 0,
      mode : 'shell',
      currentPath : a.abs( 'clone' ),
    })
  })
  .then( ( got ) =>
  {
    test.identical( got.length, 2 );
    _.each( got, ( result ) =>
    {
      test.identical( result.exitCode, 0 );
      test.is( _.strHasAny( result.output, [ 'is up to date', 'is up-to-date' ] ) );
    })
    return null;
  })

  return a.ready;
}

versionsPull.routineTimeOut = 30000;

function versionIsCommitHash( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  begin()
  .then( () =>
  {
    test.description = 'full hash length, commit exists in repo'
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
      sync : 1
    })
    test.identical( got, true );

    test.description = 'less then full hash length, commit exists in repo'
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a730fa104a7b6c7',
      sync : 1
    })
    test.identical( got, true );

    test.description = 'minimal hash length, commit exists in repo'
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a',
      sync : 1
    })
    test.identical( got, true );

    test.description = 'full hash length, commit does not exist in repo'
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'd290dbaa22ea0f13a75d5b9ba19d5b061c6ba8bf',
      sync : 1
    })
    test.identical( got, true );

    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'master',
      sync : 1
    })
    test.identical( got, false );

    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '0.7.50',
      sync : 1
    })
    test.identical( got, false );

    test.description = 'minimal hash length, commit does not exist in repo'
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'd290dba',
      sync : 1
    })
    test.identical( got, false )

    test.description = 'version length less than 7'
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '04',
      sync : 1
    })
    test.identical( got, false )

    test.description = 'version length less than 7'
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'd290db',
      sync : 1
    })
    test.identical( got, false )

    test.description = 'remove repository, should throw error'
    _.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) )
    test.shouldThrowErrorSync( () =>
    {
      _.git.versionIsCommitHash
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        version : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
        sync : 1
      })
    })

    if( !Config.debug )
    return null;

    test.shouldThrowErrorSync( () =>
    {
      _.git.versionIsCommitHash
      ({
        localPath : null,
        version : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
        sync : 1
      })
    })

    test.shouldThrowErrorSync( () =>
    {
      _.git.versionIsCommitHash
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        version : null,
        sync : 1
      })
    })

    return null;
  })

  return a.ready;

  /*  */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) ) )
    a.shell( `git clone ${'https://github.com/Wandalen/wModuleForTesting1.git'}` )
    return a.ready;
  }

}

versionIsCommitHash.timeOut = 60000;

//

function statusLocal( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )
  prepareRepo()

  /* */

  begin()
  .then( () =>
  {
    test.case = 'check after fresh clone, defaults'
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
    a.fileProvider.fileWrite( a.abs( 'clone', 'newFile' ), a.abs( 'clone', 'newFile' ) );

    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
    a.fileProvider.fileWrite( a.abs( 'clone', 'README' ), a.abs( 'clone', 'README' ) );
    return null;
  })

  a.shell( 'git add README' )
  a.shell( 'git commit -m test' )
  a.shell( 'git push' )

  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'clone', 'README' ), a.abs( 'clone', 'README' ) + a.abs( 'clone', 'README' ) );

    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git stash' )
  .then( () =>
  {
    test.case = 'after revert'

    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'remote has new commit, local executed fetch without merge';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git merge' )
  .then( () =>
  {
    test.case = 'merge after fetch, remote had new commit';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'new local commit'
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'local and remote has has new commit';

    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local executed fetch without merge';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git fetch' )
  a.shell( 'git status' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local has commit to master,fetch without merge';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git tag sometag' )
  .then( () =>
  {
    test.case = 'local has unpushed tag';

    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local has pushed tag';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git tag -a sometag -m "testtag"' )
  .then( () =>
  {
    test.case = 'local has unpushed annotated tag';

    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git push --follow-tags' )
  .then( () =>
  {
    test.case = 'local has pushed annotated tag';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
    a.fileProvider.fileWrite( a.abs( 'clone', 'README' ), a.abs( 'clone', 'README' ) );
    return null;
  })
  a.shell( 'git add README' )
  a.shell( 'git commit -m test' )
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'unstaged after rename';
    a.fileProvider.fileRename( a.abs( 'clone', 'README' ) + '_', a.abs( 'clone', 'README' ) );

    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after rename';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after rename';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after rename';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
    a.fileProvider.fileWrite( a.abs( 'clone', 'README' ), a.abs( 'clone', 'README' ) );
    return null;
  })
  a.shell( 'git add README' )
  a.shell( 'git commit -m test' )
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'unstaged after delete';
    a.fileProvider.fileDelete( a.abs( 'clone', 'README' ) );
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after delete';

    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after delete';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after delete';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git checkout -b testbranch' )
  .then( () =>
  {
    test.case = 'local clone has unpushed branch';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git push -u origin testbranch' )
  .then( () =>
  {
    test.case = 'local clone does not have unpushed branch';

    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git tag testtag' )
  .then( () =>
  {
    test.case = 'local clone has unpushed tag';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local clone doesnt have unpushed tag';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
    let ignoredFilePath = a.abs( 'clone', 'file' );
    a.fileProvider.fileWrite( ignoredFilePath, ignoredFilePath )
    _.git.ignoreAdd( a.abs( 'clone' ), { 'file' : null } )
    return null;
  })
  a.shell( 'git add --all' )
  a.shell( 'git commit -am "no desc"' )
  .then( () =>
  {
    test.case = 'has ignored file';
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( a.fileProvider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
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

    return a.ready;
  }

}

statusLocal.timeOut = 120000;

//

function statusLocalEmpty( test )
{
  /*
    Empty repo without origin defined
  */

  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )
  prepareRepo()

  initEmpty()
  .then( () =>
  {
    test.case = 'empty'
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
    a.fileProvider.fileWrite( a.abs( 'clone', 'file' ), 'file' );
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
    a.fileProvider.fileWrite( a.abs( 'clone', 'file' ), 'file' );
    return null;
  })
  a.shell( 'git add file' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git commit -m init --allow-empty' )
  .then( () =>
  {
    /* branch master is not tracking remote( no origin ) */

    test.case = 'empty, first commit'
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git checkout -b newbranch' )
  .then( () =>
  {
    test.case = 'empty, new brach'
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git commit -m init --allow-empty' ) //no way to create tag in repo without commits
  a.shell( 'git tag newtag' )
  .then( () =>
  {
    test.case = 'empty, new tag'
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function initEmpty()
  {
    a.ready.then( () =>
    {
      test.case = 'init fresh repo';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      a.fileProvider.dirMake( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git init',
        currentPath : a.abs( 'clone' ),
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( a.fileProvider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
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

    return a.ready;
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
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )
  prepareRepo()

  initEmptyWithOrigin()

  .then( () =>
  {
    test.case = 'empty'
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
    a.fileProvider.fileWrite( a.abs( 'clone', 'file' ), 'file' );
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
    a.fileProvider.fileWrite( a.abs( 'clone', 'file' ), 'file' );
    return null;
  })
  a.shell( 'git add file' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git commit -m init --allow-empty' )
  .then( () =>
  {
    debugger
    test.case = 'empty, first commit'
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git checkout -b newbranch' )
  .then( () =>
  {
    test.case = 'empty, new brach'
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git commit -m init --allow-empty' ) //no way to create tag in repo without commits
  a.shell( 'git tag newtag' )
  .then( () =>
  {
    test.case = 'empty, new tag'
    debugger
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function initEmptyWithOrigin()
  {
    a.ready.then( () =>
    {
      test.case = 'init fresh repo';
      a.fileProvider.filesDelete(  a.abs( 'clone' ) );
      a.fileProvider.dirMake( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git init',
        currentPath : a.abs( 'clone' ),
      })
    })

    a.ready.then( () =>
    {
      return _.process.start
      ({
        execPath : 'git remote add origin ' + a.path.nativize( a.abs( 'repo' ) ),
        currentPath : a.abs( 'clone' ),
      })
    })

    a.ready.then( () =>
    {
      return _.process.start
      ({
        execPath : 'git remote get-url origin',
        currentPath : a.abs( 'clone' ),
        outputCollecting : 1
      })
      .then( ( got ) =>
      {
        test.is( _.strHas( got.output, a.path.nativize( a.abs( 'repo' ) ) ) );
        return null;
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( a.fileProvider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
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

    return a.ready;
  }

}

statusLocalEmptyWithOrigin.timeOut = 30000;

//

function statusLocalAsync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )
  prepareRepo()

  /* */

  begin()
  .then( () =>
  {
    test.case = 'check after fresh clone, defaults'
    return _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( provider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
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

    return a.ready;
  }

}

statusLocalAsync.timeOut = 30000;

//

function statusLocalExplainingTrivial( test )
{

  let context = this;
  let a = test.assetFor( 'basic' );


  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )
  prepareRepo()

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  a.shell( 'git commit --allow-empty -am "no desc"' )
  .then( () =>
  {
    var got = _.git.statusLocal({ localPath : a.abs( 'clone' ), unpushed : 1, uncommitted : 1, detailing : 1, explaining : 1 });
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
  a.shell( 'git commit --allow-empty -am "no desc"' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'clone', 'newFile' ), a.abs( 'clone', 'newFile' ) );
    return null;
  })
  a.shell( 'git tag sometag' )
  a.shell( 'git checkout -b somebranch' )
  a.shell( 'git checkout master' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }
}

statusLocalExplainingTrivial.timeOut = 30000;

//

function statusLocalExtended( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  let join = _.routineJoin( a.path, a.path.join );
  let write = _.routineJoin( a.fileProvider, a.fileProvider.fileWrite );
  let filesDelete = _.routineJoin( a.fileProvider, a.fileProvider.filesDelete );
  let rename = _.routineJoin( a.fileProvider, a.fileProvider.fileRename );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  testCase( 'modified + staged and then modified' )
  prepareRepo()
  begin()
  .then( () =>
  {
    write( join( a.abs( 'clone' ), 'file1' ), 'file1file1' );
    return null;
  })
  a.shell( 'git -C clone add .' )
  .then( () =>
  {
    write( join( a.abs( 'clone' ), 'file1' ), 'file1file1file1' );
    return null;
  })
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
    write( join( a.abs( 'clone' ), 'file1' ), 'file1file1' );
    return null;
  })
  a.shell( 'git -C clone add .' )
  .then( () =>
  {
    filesDelete( join( a.abs( 'clone' ), 'file1' ) );
    return null;
  })
  a.shell( 'git -C clone status -u --porcelain -b' )
  a.shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
    write( join( a.abs( 'clone' ), 'file1' ), 'file1file1' );
    return null;
  })
  a.shell( 'git -C clone add .' )
  a.shell( 'git -C clone mv file1 file3' )
  a.shell( 'git -C clone status -u --porcelain -b' )
  a.shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
    write( join( a.abs( 'clone' ), 'file3' ), 'file3' );
    return null;
  })
  a.shell( 'git -C clone add file3' )
  .then( () =>
  {
    filesDelete( join( a.abs( 'clone' ), 'file3' ) );
    return null;
  })
  a.shell( 'git -C clone status -u --porcelain -b' )
  a.shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
    write( join( a.abs( 'clone' ), 'file3' ), 'file3' );
    return null;
  })
  a.shell( 'git -C clone add file3' )
  .then( () =>
  {
    write( join( a.abs( 'clone' ), 'file3' ), 'file3file3' );
    return null;
  })
  a.shell( 'git -C clone status -u --porcelain -b' )
  a.shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git -C clone mv file1 file3' )
  .then( () =>
  {
    write( join( a.abs( 'clone' ), 'file3' ), 'file3' );
    return null;
  })
  a.shell( 'git -C clone status -u --porcelain -b' )
  a.shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git -C clone mv file1 file3' )
  .then( () =>
  {
    filesDelete( join( a.abs( 'clone' ), 'file3' ) );
    return null;
  })
  a.shell( 'git -C clone status -u --porcelain -b' )
  a.shell( 'git -C clone status' )
  .then( () =>
  {
    var got = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
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

  return a.ready;

  /* - */

  function prepareRepo()
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( secondRepoPath, 'file1' ), 'file1' );
      a.fileProvider.fileWrite( a.abs( secondRepoPath, 'file2' ), 'file2' );
      return null;
    })

    shell( 'git -C secondary add .' )
    shell( 'git -C secondary commit -m initial' )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function testCase( title )
  {
    a.ready.then( () => { test.case = title; return null })
    return a.ready;
  }
}

statusLocalExtended.timeOut = 60000;

//

function statusFullHalfStaged( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );


  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  prepareRepo()
  repoInitCommit()
  begin()
  .then( () =>
  {
    var got = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    .then( () =>
    {
      a.fileProvider.fileWrite( a.abs( 'clone', 'file1' ), 'file1file1' );
      a.fileProvider.fileWrite( a.abs( 'clone', 'file2' ), 'file2file1' );
      return null;
    })

    a.shell( 'git -C clone add .' )

    .then( () =>
    {
      a.fileProvider.fileWrite( a.abs( 'clone', 'file1' ), 'file1file1file1' );
      a.fileProvider.fileWrite( a.abs( 'clone', 'file2' ), 'file2file1file1' );
      return null;
    })

    return a.ready;
  }

  function repoInitCommit()
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( secondRepoPath, 'file1' ), 'file1' );
      a.fileProvider.fileWrite( a.abs( secondRepoPath, 'file2' ), 'file2' );
      return null;
    })

    shell( 'git -C secondary commit --allow-empty -am initial' )
    shell( 'git -C secondary push' )

    return a.ready;
  }
}

//

function statusRemote( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommit( 'test' )
  .then( () =>
  {
    test.case = 'remote has new commit';

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
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
    return _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 1, remoteTags : 1, sync : 0 })
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
    return _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 1, sync : 0 })
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
    return _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 1, detailing : 1, sync : 0 })
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
    return _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 0, detailing : 0, sync : 0 })
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
  a.shell( 'git pull' )
  .then( () =>
  {
    test.case = 'local pulled new commit from remote';
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
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
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
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
  a.shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after fetch';
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
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
  a.shell( 'git checkout test' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after checkout new branch';
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
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
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 1 });
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
  a.shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 1 });
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
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 1 });
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
  a.shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 1 });
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

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewTag( tag )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary tag ' + tag )
    shell( 'git -C secondary push --tags' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( a.fileProvider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
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

    return a.ready;
  }

}

statusRemote.timeOut = 60000;

//

function statusRemoteTags( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  begin()
  .then( () =>
  {
    test.case = 'check tags on fresh clone';

    var got = _.git.statusRemote
    ({
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git tag -d v0.0.70' )
  .then( () =>
  {
    test.case = 'compare with remore after remove';

    var got = _.git.statusRemote
    ({
      localPath : a.abs( 'clone' ),
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
      remoteTags : 'refs/tags/v0.0.70\nrefs/tags/v0.0.70^{}',
      status : 'List of unpulled remote tags:\n  refs/tags/v0.0.70\n  refs/tags/v0.0.70^{}'
    }
    test.identical( got, expected );
    return null;
  })
  a.shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'check tags after fetching';

    var got = _.git.statusRemote
    ({
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git tag sometag' )
  .then( () =>
  {
    test.case = 'check after creating tag locally';

    var got = _.git.statusRemote
    ({
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git tag new v0.0.70' )
  a.shell( 'git tag -d v0.0.70' )
  .then( () =>
  {
    test.case = 'check after renaming';

    var got = _.git.statusRemote
    ({
      localPath : a.abs( 'clone' ),
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
      remoteTags : 'refs/tags/v0.0.70\nrefs/tags/v0.0.70^{}',
      status : 'List of unpulled remote tags:\n  refs/tags/v0.0.70\n  refs/tags/v0.0.70^{}'
    }
    test.identical( got, expected );
    return null;
  })

  /*  */

  return a.ready;

  /* - */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + 'https://github.com/Wandalen/wModuleForTesting1.git' + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }
}

statusRemoteTags.timeOut = 120000;

//

function statusRemoteVersionOption( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommit( 'test' )
  .then( () =>
  {
    test.case = 'remote has new commit';

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : true,
      remoteBranches : null,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : true,
      remoteBranches : null,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : 'master' });
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
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 1, remoteTags : 1, version : null })
    var expected =
    {
      remoteCommits : true,
      remoteBranches : false,
      remoteTags : false,
      status : true
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 1, remoteTags : 1, version : _.all })
    var expected =
    {
      remoteCommits : true,
      remoteBranches : false,
      remoteTags : false,
      status : true
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 1, remoteTags : 1, version : 'master' })
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
    var got =_.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 1, version : null })
    var expected =
    {
      remoteCommits : 'refs/heads/master',
      remoteBranches : '',
      remoteTags : '',
      status : 'List of remote branches that have new commits:\n  refs/heads/master'
    }
    test.identical( got, expected );

    var got =_.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 1, version : _.all })
    var expected =
    {
      remoteCommits : 'refs/heads/master',
      remoteBranches : '',
      remoteTags : '',
      status : 'List of remote branches that have new commits:\n  refs/heads/master'
    }
    test.identical( got, expected );

    var got =_.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 1, remoteTags : 1, explaining : 1, version : 'master' })
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
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
      localPath : a.abs( 'clone' ),
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
  a.shell( 'git pull' )
  .then( () =>
  {
    test.case = 'local pulled new commit from remote';
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    /* */

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : 'master' });
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
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'test' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    /* */

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : true,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'test' });
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
  a.shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after fetch';
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'test' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : true,
      remoteTags : null,
      status : true
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'test' });
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
  a.shell( 'git checkout test' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after checkout new branch';
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'test' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : false,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0, version : 'test' });
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
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : 'master' });
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
  a.shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 1, version : 'master' });
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
    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    /*  */

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );


    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    /*  */

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : null });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : _.all });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : true,
      status : true
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : 'master' });
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
  a.shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : null,
      remoteBranches : null,
      remoteTags : null,
      status : null
    }
    test.identical( got, expected );

    /*  */

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : null });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : _.all });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );


    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0, version : 'master' });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : null,
      status : false
    }
    test.identical( got, expected );

    /*  */

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : null });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : _.all });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : false,
      status : false
    }
    test.identical( got, expected );

    var got = _.git.statusRemote({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 1, version : 'master' });
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

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewTag( tag )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary tag ' + tag )
    shell( 'git -C secondary push --tags' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( a.fileProvider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
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

    return a.ready;
  }

}

statusRemoteVersionOption.timeOut = 60000;

//

function statusExplaining( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.cloneShell = _.process.starter
  ({
    currentPath : a.abs( 'clone' ),
    ready : a.ready
  })

  a.clone2Shell = _.process.starter
  ({
    currentPath : a.abs( 'clone2' ),
    ready : a.ready
  })

  /* - */

  begin();
  a.cloneShell( 'git init' );
  a.cloneShell( 'git remote add origin ../repo' );
  a.cloneShell( 'git add --all' );
  a.cloneShell( 'git commit -am first' );
  a.cloneShell( 'git push -u origin --all' );
  a.shell( 'git clone repo/ clone2' );
  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'clone/File.txt' ), 'new line\n' );
    a.fileProvider.fileAppend( a.abs( 'clone/newFile' ), 'new line\n' );
    a.fileProvider.fileAppend( a.abs( 'clone2/README' ), 'new line\n' );
    return null;
  })
  a.clone2Shell( 'git commit -am first' );
  a.clone2Shell( 'git push' );

  a.ready.then( () =>
  {
    var got = _.git.status
    ({
      detailing : 1,
      explaining : 1,
      local : 0,
      localPath : a.abs( 'clone' ),
      remote : 1,
      remoteBranches : 0,
      sync : 1,
      uncommittedIgnored : 0,
      verbosity : 1,
    });

    test.identical( _.strCount( got.status, 'List of remote branches' ), 1 );

    return null;
  })

  /* */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      a.fileProvider.dirMake( a.abs( 'clone' ) );
      a.fileProvider.fileAppend( a.abs( 'clone', 'newFile' ), 'newFile\n' );
      a.fileProvider.fileAppend( a.abs( 'clone', 'README' ), 'README\n' );
      return null;
    })

    _.process.start
    ({
      execPath : 'git init --bare',
      currentPath : a.abs( 'repo' ),
      ready : a.ready,
    })

    return a.ready;
  }
}

statusExplaining.timeOut = 30000;

//

function hasLocalChanges( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  prepareRepo()

  /* */

  .then( () =>
  {
    test.case = 'repository is not downloaded'
    return test.shouldThrowErrorSync( () => _.git.hasLocalChanges({ localPath : a.abs( 'clone' ) }) )
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'check after fresh clone'
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, false );
    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'new untraked file'
    a.fileProvider.fileWrite( a.abs( 'clone', 'newFile' ), a.abs( 'clone', 'newFile' ) );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add newFile' )
  .then( () =>
  {
    test.case = 'new staged file'
    test.is( a.fileProvider.fileExists( a.abs( 'clone', 'newFile' ) ) );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'unstaged change in existing file'
    a.fileProvider.fileWrite( a.abs( 'clone', 'README' ), a.abs( 'clone', 'README' ) );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add README' )
  .then( () =>
  {
    test.case = 'unstaged change in existing file'
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  .then( () =>
  {
    test.case = 'remote has new commit';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, false );
    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  a.shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'remote has new commit, local executed fetch without merge';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, false );
    return null;
  })
  a.shell( 'git merge' )
  .then( () =>
  {
    test.case = 'merge after fetch, remote had new commit';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : 1  });
    test.identical( got, false );
    return null;
  })

  /*  */

  begin()
  a.shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'new local commit'
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false  });
    test.identical( got, false );
    test.case = 'new local commit'
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  a.shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'local and remote has has new commit';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true  });
    test.identical( got, true );
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommitToBranch( 'testCommit', 'feature' )
  a.shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local executed fetch without merge';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true  });
    test.identical( got, false );
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommitToBranch( 'testCommit', 'feature' )
  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git fetch' )
  a.shell( 'git status' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local has commit to master,fetch without merge';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true  });
    test.identical( got, true );
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git tag sometag' )
  .then( () =>
  {
    test.case = 'local has unpushed tag';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false  });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local has pushed tag';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false  });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git tag -a sometag -m "testtag"' )
  .then( () =>
  {
    test.case = 'local has unpushed annotated tag';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false  });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push --follow-tags' )
  .then( () =>
  {
    test.case = 'local has pushed annotated tag';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false  });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'clone', 'README' ), a.abs( 'clone', 'README' ) );
    return null;
  })
  a.shell( 'git add README' )
  a.shell( 'git commit -m test' )
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'unstaged after rename';
    a.fileProvider.fileRename( a.abs( 'clone', 'README' ) + '_', a.abs( 'clone', 'README' ) );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after rename';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after rename';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after rename';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'clone', 'README' ), a.abs( 'clone', 'README' ) );
    return null;
  })
  a.shell( 'git add README' )
  a.shell( 'git commit -m test' )
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'unstaged after delete';
    a.fileProvider.fileDelete( a.abs( 'clone', 'README' ) );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after delete';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after delete';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after delete';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  a.shell( 'git checkout -b testbranch' )
  .then( () =>
  {
    test.case = 'local clone has unpushed branch';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedBranches : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedBranches : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push -u origin testbranch' )
  .then( () =>
  {
    test.case = 'local clone does not have unpushed branch';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedBranches : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedBranches : 1 });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  a.shell( 'git tag testtag' )
  .then( () =>
  {
    test.case = 'local clone has unpushed tag';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local clone doesnt have unpushed tag';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : 1 });
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
    let ignoredFilePath = a.abs( 'clone', 'file' );
    a.fileProvider.fileWrite( ignoredFilePath, ignoredFilePath )
    _.git.ignoreAdd( a.abs( 'clone' ), { 'file' : null } )
    return null;
  })
  a.shell( 'git add --all' )
  a.shell( 'git commit -am "no desc"' )
  .then( () =>
  {
    test.case = 'has ignored file';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushed : 0, uncommitted : 0, uncommittedIgnored : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushed : 0, uncommitted : 0, uncommittedIgnored : 1 });
    test.identical( got, true );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushed : 0, uncommitted : 1, uncommittedIgnored : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushed : 0, uncommitted : 1, uncommittedIgnored : 1 });
    test.identical( got, true );
    return null;
  })

  /*  */

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( a.fileProvider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
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

    return a.ready;
  }

}

hasLocalChanges.timeOut = 120000;

//

function hasRemoteChanges( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommit( 'test' )
  .then( () =>
  {
    test.case = 'remote has new commit';
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git pull' )
  .then( () =>
  {
    test.case = 'local pulled new commit from remote';
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
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
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after fetch';
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git checkout test' )
  .then( () =>
  {
    test.case = 'remote has new branch, local after checkout new branch';
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 1, remoteTags : 0 });
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
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 1 });
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
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'remote has new tag, local after fetch';
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 0, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 0 });
    test.identical( got, false );
    var got = _.git.hasRemoteChanges({ localPath : a.abs( 'clone' ), remoteCommits : 1, remoteBranches : 0, remoteTags : 1 });
    test.identical( got, false );
    return null;
  })

  /*  */

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewTag( tag )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary tag ' + tag )
    shell( 'git -C secondary push --tags' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( a.fileProvider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
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

    return a.ready;
  }

}

hasRemoteChanges.timeOut = 30000;

//

function hasChanges( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  prepareRepo()

  /* */

  .then( () =>
  {
    test.case = 'repository is not downloaded'
    return test.shouldThrowErrorSync( () => _.git.hasChanges({ localPath : a.abs( 'clone' ) }) )
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'check after fresh clone'
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, false );
    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'new untraked file'
    a.fileProvider.fileWrite( a.abs( 'clone', 'newFile' ), a.abs( 'clone', 'newFile' ) );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    debugger
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add newFile' )
  .then( () =>
  {
    test.case = 'new staged file'
    test.is( a.fileProvider.fileExists( a.abs( 'clone', 'newFile' ) ) );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    test.case = 'unstaged change in existing file'
    a.fileProvider.fileWrite( a.abs( 'clone', 'README' ), a.abs( 'clone', 'README' ) );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add README' )
  .then( () =>
  {
    test.case = 'unstaged change in existing file'
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1  });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  .then( () =>
  {
    test.case = 'remote has new commit, branch is not downloaded';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0, remote : 1 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1, remote : 1 });
    test.identical( got, false );
    return null;
  })
  a.shell( 'git pull' )
  repoNewCommit( 'testCommit' )
  .then( () =>
  {
    test.case = 'remote has new commit, after checkout';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0, remote : 1 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1, remote : 1 });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  a.shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'remote has new commit, local executed fetch without merge';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0, remote : 1 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1, remote : 1  });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git merge' )
  .then( () =>
  {
    test.case = 'merge after fetch, remote had new commit';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : 1  });
    test.identical( got, false );
    return null;
  })

  /*  */

  begin()
  a.shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'new local commit'
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false  });
    test.identical( got, false );
    test.case = 'new local commit'
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true });
    test.identical( got, true );
    return null;
  })

  /* */

  begin()
  repoNewCommit( 'testCommit' )
  a.shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'local and remote has has new commit';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 0  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 1  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 1  });
    test.identical( got, true );
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommitToBranch( 'testCommit', 'feature' )
  a.shell( 'git fetch' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local executed fetch without merge';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 1  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 1  });
    test.identical( got, false );
    return null;
  })
  a.shell( 'git checkout feature' )
  repoNewCommitToBranch( 'testCommit', 'feature' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local executed fetch without merge';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 1  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 1  });
    test.identical( got, true );
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  repoNewCommitToBranch( 'testCommit', 'feature' )
  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git fetch' )
  a.shell( 'git status' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local has commit to master,fetch without merge,branch is not downloaded';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 0  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 1  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 1  });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git checkout feature' )
  repoNewCommitToBranch( 'testCommit', 'feature' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local has commit to master,fetch without merge, branch downloaded';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 0  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 1  });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 1  });
    test.identical( got, true );
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git tag sometag' )
  .then( () =>
  {
    test.case = 'local has unpushed tag';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false  });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local has pushed tag';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false  });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git tag -a sometag -m "testtag"' )
  .then( () =>
  {
    test.case = 'local has unpushed annotated tag';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false  });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push --follow-tags' )
  .then( () =>
  {
    test.case = 'local has pushed annotated tag';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false, remote : 0  });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'clone', 'README' ), a.abs( 'clone', 'README' ) );
    return null;
  })
  a.shell( 'git add README' )
  a.shell( 'git commit -m test' )
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'unstaged after rename';
    a.fileProvider.fileRename( a.abs( 'clone', 'README' ) + '_', a.abs( 'clone', 'README' ) );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after rename';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after rename';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after rename';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'clone', 'README' ), a.abs( 'clone', 'README' ) );
    return null;
  })
  a.shell( 'git add README' )
  a.shell( 'git commit -m test' )
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'unstaged after delete';
    a.fileProvider.fileDelete( a.abs( 'clone', 'README' ) );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add .' )
  .then( () =>
  {
    test.case = 'staged after delete';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git commit -m test' )
  .then( () =>
  {
    test.case = 'comitted after delete';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push' )
  .then( () =>
  {
    test.case = 'pushed after delete';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ) });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  a.shell( 'git checkout -b testbranch' )
  .then( () =>
  {
    test.case = 'local clone has unpushed branch';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedBranches : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedBranches : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push -u origin testbranch' )
  .then( () =>
  {
    test.case = 'local clone does not have unpushed branch';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedBranches : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedBranches : 1 });
    test.identical( got, false );
    return null;
  })

  /*  */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  a.shell( 'git tag testtag' )
  .then( () =>
  {
    test.case = 'local clone has unpushed tag';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local clone doesnt have unpushed tag';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : 1 });
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
    let ignoredFilePath = a.abs( 'clone', 'fileToIgnore' );
    a.fileProvider.fileWrite( ignoredFilePath, ignoredFilePath )
    _.git.ignoreAdd( a.abs( 'clone' ), { 'fileToIgnore' : null } )
    return null;
  })
  a.shell( 'git add --all' )
  a.shell( 'git commit -am "no desc"' )
  .then( () =>
  {
    test.case = 'has ignored file';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushed : 0, uncommitted : 0, uncommittedIgnored : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushed : 0, uncommitted : 0, uncommittedIgnored : 1 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushed : 0, uncommitted : 1, uncommittedIgnored : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushed : 0, uncommitted : 1, uncommittedIgnored : 1 });
    test.identical( got, true );
    return null;
  })

  /*  */

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( 'secondary/file' ), _.time.now().toString() );
      return null;
    })
    shell( 'git -C secondary add .' )
    shell( 'git -C secondary commit -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( a.fileProvider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
        ready : con2
      })

      if( create )
      shell2( 'git -C secondary checkout -b ' + branch )
      else
      shell2( 'git -C secondary checkout ' + branch )

      con2.then( () =>
      {
        a.fileProvider.fileWrite( a.abs( 'secondary/file' ), _.time.now().toString() );
        return null;
      })

      shell2( 'git -C secondary add .' )

      shell2( 'git -C secondary commit -m ' + message )

      if( create )
      shell2( 'git -C secondary push -f --set-upstream origin ' + branch )
      else
      shell2( 'git -C secondary push' )

      return con2;
    })

    return a.ready;
  }

}

hasChanges.timeOut = 120000;

//

function hasLocalChangesSpecial( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  begin()
  a.shell( 'git remote add origin ' + 'https://github.com/Wandalen/wModuleForTesting1.git' )
  a.shell( 'git commit --allow-empty -m test' )
  // shell( 'git status -b --porcelain -u' )
  // shell( 'git push --dry-run' )
  .then( () =>
  {
    debugger
    var got = _.git.hasLocalChanges
    ({
      localPath : a.abs( 'clone' ),
      unpushed : 1,
      uncommitted : 1,
      uncommittedIgnored : 1,
      unpushedCommits : 1,
      unpushedBranches : 1,
      unpushedTags : 0
    })

    test.identical( got, true )

    return null;
  })

  /*  */

  return a.ready;

  /*  */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      a.fileProvider.dirMake( a.abs( 'clone' ) );
      return a.shell({ execPath : 'git init', ready : null });
    })

    return a.ready;
  }
}

//

function hasFiles( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  test.case = 'missing';
  a.fileProvider.filesDelete( a.abs( 'clone' ) );
  var got = _.git.hasFiles({ localPath : a.abs( 'clone' ) });
  test.identical( got, false );

  test.case = 'terminal';
  a.fileProvider.filesDelete( a.abs( 'clone' ) );
  a.fileProvider.fileWrite( a.abs( 'clone' ), a.abs( 'clone' ) )
  var got = _.git.hasFiles({ localPath : a.abs( 'clone' ) });
  test.identical( got, false );

  test.case = 'link';
  a.fileProvider.filesDelete( a.abs( 'clone' ) );
  a.fileProvider.dirMake( a.abs( 'clone' ) );
  a.fileProvider.softLink( a.abs( 'clone', 'file' ), a.abs( 'clone' ) );
  var got = _.git.hasFiles({ localPath : a.abs( 'clone', 'file' ) });
  test.identical( got, false );

  test.case = 'empty dir';
  a.fileProvider.filesDelete( a.abs( 'clone' ) );
  a.fileProvider.dirMake( a.abs( 'clone' ) )
  var got = _.git.hasFiles({ localPath : a.abs( 'clone' ) });
  test.identical( got, false );

  test.case = 'dir with file';
  a.fileProvider.filesDelete( a.abs( 'clone' ) );
  a.fileProvider.fileWrite( a.abs( 'clone', 'file' ), a.abs( 'clone', 'file' ) )
  var got = _.git.hasFiles({ localPath : a.abs( 'clone' ) });
  test.identical( got, true );
}

//

function hasRemote( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.mode = 'spawn';

  a.ready
  .then( () =>
  {
    let got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git' });
    test.identical( got.downloaded, false )
    test.identical( got.remoteIsValid, false )
    return null;
  })

  .then( () =>
  {
    test.case = 'setup';
    a.fileProvider.filesDelete( a.abs( 'clone' ) );
    a.fileProvider.dirMake( a.abs( 'clone' ) );
    return null;
  })

  a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'clone' )

  .then( () =>
  {
    let got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git' });
    test.identical( got.downloaded, true )
    test.identical( got.remoteIsValid, true )
    return null;
  })

  .then( () =>
  {
    let got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting2.git' });
    test.identical( got.downloaded, true )
    test.identical( got.remoteIsValid, false )
    return null;
  })

  a.shell( 'git -C ' + 'clone' + ' remote remove origin' )

  .then( () =>
  {
    let got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git' });
    test.identical( got.downloaded, true )
    test.identical( got.remoteIsValid, false )
    return null;
  })

  .then( () =>
  {
    let got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting2.git' });
    test.identical( got.downloaded, true )
    test.identical( got.remoteIsValid, false )
    return null;
  })

  return a.ready;
}

hasRemote.routineTimeOut = 30000;

function isUpToDate( test )
{

  let context = this;
  let a = test.assetFor( 'basic' );
  let con = new _.Consequence().take( null )

  a.shell.predefined.mode = 'spawn';

  con
  .then( () =>
  {
    test.open( 'local master' );
    test.case = 'setup';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
    a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
    return a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'wModuleForTesting1' )
  })

  .then( () =>
  {
    test.case = 'remote master';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  .then( () =>
  {
    test.case = 'remote has different branch that does not exist';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git!other';
    var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    return test.shouldThrowErrorAsync( con )
  })

  .then( () =>
  {
    test.case = 'remote has fixed version';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#041839a730fa104a7b6c7e4935b4751ad81b00e0';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
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
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
    a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
    return null;
  })

  a.shell({ execPath : 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'wModuleForTesting1', ready : con })
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout 041839a730fa104a7b6c7e4935b4751ad81b00e0', ready : con })

  .then( () =>
  {
    test.case = 'remote has same fixed version';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#041839a730fa104a7b6c7e4935b4751ad81b00e0';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  .then( () =>
  {
    test.case = 'remote has other fixed version';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#d70162fc9d06783ec24f622424a35dbda64fe956';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  .then( () =>
  {
    test.case = 'remote has other branch that does not exist';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git!other';
    var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    return test.shouldThrowErrorAsync( con )
  })

  .then( () =>
  {
    test.case = 'branch name as hash';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#other';
    var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    return test.shouldThrowErrorAsync( con )
  })

  .then( () =>
  {
    test.case = 'hash as tag';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git!d70162fc9d06783ec24f622424a35dbda64fe956';
    var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    return test.shouldThrowErrorAsync( con )
  })

  if( Config.debug )
  {
    con.then( () =>
    {
      test.case = 'hash and tag';
      let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#d70162fc9d06783ec24f622424a35dbda64fe956!master';
      test.shouldThrowErrorSync( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
      return null;
    })
  }

  con.then( () =>
  {
    test.close( 'local detached' );
    return null;
  })

  /**/

  .then( () =>
  {
    test.case = 'local is behind remote';
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
    a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
    return null;
  })

  a.shell({ execPath : 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'wModuleForTesting1', ready : con })

  .then( () =>
  {
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';
    return _.process.start
    ({
      execPath : 'git reset --hard HEAD~1',
      currentPath : a.abs( 'wModuleForTesting1' ),
    })
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
    a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
    return null;
  })

  a.shell({ execPath : 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'wModuleForTesting1', ready : con })

  .then( () =>
  {
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';

    return _.process.start
    ({
      execPath : 'git commit --allow-empty -m emptycommit',
      currentPath : a.abs( 'wModuleForTesting1' ),
    })
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
    a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
    return null;
  })

  a.shell({ execPath : 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'wModuleForTesting1', ready : con })

  .then( () =>
  {
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';

    let ready = new _.Consequence().take( null );

    _.process.start
    ({
      execPath : 'git reset --hard HEAD~1',
      currentPath : a.abs( 'wModuleForTesting1' ),
      ready
    })

    _.process.start
    ({
      execPath : 'git commit --allow-empty -m emptycommit',
      currentPath : a.abs( 'wModuleForTesting1' ),
      ready
    })

    ready
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
    a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
    return null;
  })

  a.shell({ execPath : 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'wModuleForTesting1', ready : con })
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout 34f17134e3c1fc49ef4b9fa3ec60da8851922588', ready : con })

  .then( () =>
  {
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';
    return _.process.start
    ({
      execPath : 'git commit --allow-empty -m emptycommit',
      currentPath : a.abs( 'wModuleForTesting1' ),
    })
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  /* */

  .then( () =>
  {
    test.case = 'local is on different branch than remote';
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
    a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
    return null;
  })

  a.shell({ execPath : 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'wModuleForTesting1', ready : con })
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout -b newbranch', ready : con })

  .then( () =>
  {
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  /* */

  .then( () =>
  {
    test.case = 'local is on different branch than remote';
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
    a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
    return null;
  })

  a.shell({ execPath : 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'wModuleForTesting1', ready : con })
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout -b newbranch', ready : con })

  .then( () =>
  {
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!newbranch';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  return con;
}

isUpToDate.timeOut = 120000;

//

function isUpToDateExtended( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let con = new _.Consequence().take( null )

  a.shell.predefined.mode = 'spawn';

  begin()

  /* */

  .then( () =>
  {
    test.case = 'both on master, no changes';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  /* */

  .then( () =>
  {
    test.case = 'both on master, local one commit behind';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master';
    return a.shell( 'git -C wModuleForTesting1 reset --hard HEAD~1' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  //

  begin() /* qqq2 : ? */

  //

  .then( () =>
  {
    test.case = 'local on master, remote on other branch that does not exist';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!other';
    var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    return test.shouldThrowErrorAsync( con )
  })

  //

  .then( () =>
  {
    test.case = 'local on newbranch, remote on master';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master';
    return a.shell( 'git -C wModuleForTesting1 checkout -b newbranch' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
    .finally( ( err, got ) =>
    {
      if( err )
      test.exceptionReport({ err });
      return a.shell({ execPath : 'git -C wModuleForTesting1 checkout master', ready : null })
    })
  })

  //

  .then( () =>
  {
    test.case = 'local on master, remote on tag points to other commit';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!v0.0.70';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!v0.0.70';
    return a.shell( 'git -C wModuleForTesting1 checkout v0.0.70' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!v0.0.70';
    return a.shell( 'git -C wModuleForTesting1 checkout v0.0.71' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!v0.0.70';
    return a.shell( 'git -C wModuleForTesting1 checkout 9a711ca350777586043fbb32cc33ccea267218af' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!v0.0.70';
    return a.shell( 'git -C wModuleForTesting1 checkout fbfcc8e897be2b7df49dc60b9a35818af195e916' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master';
    return a.shell( 'git -C wModuleForTesting1 checkout v0.0.71' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/#9a711ca350777586043fbb32cc33ccea267218af';
    return a.shell( 'git -C wModuleForTesting1 checkout v0.0.70' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/#fbfcc8e897be2b7df49dc60b9a35818af195e916';
    return a.shell( 'git -C wModuleForTesting1 checkout v0.0.70' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting12.git/';
    return a.shell( 'git -C wModuleForTesting1 checkout master' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  .then( () =>
  {
    test.case = 'local on tag, remote is different';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting12.git/';
    return a.shell( 'git -C wModuleForTesting1 checkout v0.0.70' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  .then( () =>
  {
    test.case = 'local detached, remote is different';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting12.git/';
    return a.shell( 'git -C wModuleForTesting1 checkout 9a711ca350777586043fbb32cc33ccea267218af' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/';
    return a.fileProvider.filesDelete({ filePath : a.abs( 'wModuleForTesting1', '.git'), sync : 0 })
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/';
    return a.shell( 'git -C wModuleForTesting1 remote remove origin' )
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/';
    return a.fileProvider.filesDelete({ filePath : a.abs( 'wModuleForTesting1' ), sync : 0 })
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
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
      a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
      a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
      return a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'wModuleForTesting1' )
    })

    return con;
  }
}

isUpToDateExtended.timeOut = 300000;

//

function isUpToDateThrowing( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let con = new _.Consequence().take( null )

  a.shell.predefined.mode = 'spawn';

  con
  .then( () =>
  {
    test.case = 'setup';
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
    a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
    return a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'wModuleForTesting1' )
  })

  .then( () =>
  {
    test.case = 'branch name as hash';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#master';
    var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    return test.shouldThrowErrorAsync( con );
  })

  .then( () =>
  {
    test.case = 'not existing branch name';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git!master2';
    var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    return test.shouldThrowErrorAsync( con );
  })

  .then( () =>
  {
    test.case = 'branch name as tag';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git!master';
    var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    return test.mustNotThrowError( con );
  })

  .then( () =>
  {
    test.case = 'no branch';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';
    var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    return test.mustNotThrowError( con );
  })

  return con;
}

//

isUpToDateThrowing.timeOut = 60000;


//

function insideRepository( test )
{
  let a = test.assetFor( 'basic' );

  test.case = 'missing'
  var insidePath = a.abs( __dirname, 'someFile' );
  var got = _.git.insideRepository({ insidePath })
  test.identical( got, true )

  test.case = 'terminal'
  var insidePath = a.abs( __filename );
  var got = _.git.insideRepository({ insidePath })
  test.identical( got, true )

  test.case = 'testdir'
  var insidePath = a.abs( __dirname );
  var got = _.git.insideRepository({ insidePath })
  test.identical( got, true )

  test.case = 'root of repo'
  var insidePath = a.abs( __dirname, '../../../..' );
  var got = _.git.insideRepository({ insidePath })
  test.identical( got, true )

  test.case = 'outside of repo'
  var insidePath = a.abs( __dirname, '../../../../..' );
  var got = _.git.insideRepository({ insidePath })
  test.identical( got, false )
}

//

function isRepository( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )
  prepareRepo()

  .then( () =>
  {
    test.case = 'not cloned, only remotePath'
    var got = _.git.isRepository({ remotePath : a.abs( 'repo' ) });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git' });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git#master' });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git/out/wModuleForTesting1#master' });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : 'https://github.com/Wandalen/wModuleForTesting2.git' });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting2.git#master' });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting2.git/out/wModuleForTesting2#master' });
    test.identical( got, true );
    var got = _.git.isRepository({ remotePath : 'git+https:///github.com/Wandalen/wSomeModule.git/out/wSomeModule#master' });
    test.identical( got, false );
    /* qqq : ask
    git ls-remote https://github.com/x/y.git
    */
    return null;
  })

  .then( () =>
  {
    test.case = 'not cloned'
    var got = _.git.isRepository({ localPath : a.abs( 'clone' ) });
    test.identical( got, false );
    var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : a.abs( 'repo' ) });
    test.identical( got, false );
    return null;
  })

  /* */

  // begin()
  // .then( () =>
  // {
  //   test.case = 'check after fresh clone'
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ) });
  //   test.identical( got, true );
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : a.abs( 'repo' ) });
  //   test.identical( got, true );
  //   return null;
  // })
  //
  // begin()
  // .then( () =>
  // {
  //   test.case = 'cloned, other remote'
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ) });
  //   test.identical( got, true );
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : remotePath });
  //   test.identical( got, false );
  //   return null;
  // })
  //
  // begin()
  // .then( () =>
  // {
  //   test.case = 'cloned, provided remote is not a repo'
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ) });
  //   test.identical( got, true );
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : remotePath2 });
  //   test.identical( got, false );
  //   return null;
  // })
  //
  // begin2()
  // .then( () =>
  // {
  //   test.case = 'cloned, provided global remote path to repo'
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ) });
  //   test.identical( got, true );
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : remotePathGlobal });
  //   test.identical( got, true );
  //   return null;
  // })
  //
  // begin2()
  // .then( () =>
  // {
  //   test.case = 'cloned, provided wrong global remote path to repo'
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ) });
  //   test.identical( got, true );
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : remotePathGlobal2 });
  //   test.identical( got, false );
  //   return null;
  // })
  //
  // begin2()
  // .then( () =>
  // {
  //   test.case = 'cloned, provided global remote path to repo with out file'
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ) });
  //   test.identical( got, true );
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : remotePathGlobalWithOut });
  //   test.identical( got, true );
  //   return null;
  // })
  //
  // begin2()
  // .then( () =>
  // {
  //   test.case = 'cloned, provided global remote path to repo with out file'
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ) });
  //   test.identical( got, true );
  //   var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : remotePathGlobalWithOut2 });
  //   test.identical( got, false );
  //   return null;
  // })
  //
  // /* -async- */
  //
  // begin2()
  // .then( () =>
  // {
  //   test.case = 'cloned, provided local path to repo'
  //   return _.git.isRepository({ localPath : a.abs( 'clone' ), sync : 0 })
  //   .then( ( got ) =>
  //   {
  //     test.identical( got, true );
  //     return null;
  //   })
  // })
  // .then( () =>
  // {
  //   test.case = 'cloned, provided global local & remote paths to repo'
  //   return _.git.isRepository({ localPath : a.abs( 'clone' ), sync : 0, remotePath : remotePathGlobal })
  //   .then( ( got ) =>
  //   {
  //     test.identical( got, true );
  //     return null;
  //   })
  // })
  //
  // /*  */
  //
  // begin2()
  // .then( () =>
  // {
  //   test.case = 'cloned, provided global remote path to repo with out file'
  //   return _.git.isRepository({ localPath : a.abs( 'clone' ), sync : 0 })
  //   .then( ( got ) =>
  //   {
  //     test.identical( got, true );
  //     return null;
  //   })
  // })
  // .then( () =>
  // {
  //   test.case = 'cloned, provided global remote path to repo with out file'
  //   return _.git.isRepository({ localPath : a.abs( 'clone' ), sync : 0, remotePath : remotePathGlobalWithOut2 })
  //   .then( ( got ) =>
  //   {
  //     test.identical( got, false );
  //     return null;
  //   })
  // })

  /*  */

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function begin2()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + remotePath + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }
}

isRepository.timeOut = 30000;

//

function status( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  prepareRepo()

  begin()
  .then( () =>
  {
    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
      local : 0,
      unpushed : 0,
      remote : 0,
      uncommitted : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,
      conflicts : null,

      local : null,
      remote : null,


      status : null
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
      local : 1,
      unpushed : 0,
      remote : 0,
      uncommitted : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,
      conflicts : null,

      local : null,
      remote : null,


      status : null
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
      local : 1,
      unpushed : null,
      remote : 0,
      uncommitted : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,

      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      conflicts : null,
      local : false,
      remote : null,

      status : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
      local : 1,
      unpushed : 0,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : false,
      uncommittedDeleted : false,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,

      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      conflicts : false,
      local : false,
      remote : null,

      status : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
      local : 1,
      unpushed : null,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : false,
      uncommittedDeleted : false,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,

      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      conflicts : false,
      local : false,
      remote : null,

      status : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
      local : 0,
      unpushed : null,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,

      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      conflicts : null,
      local : null,
      remote : null,

      status : null
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
      local : 0,
      unpushed : 1,
      uncommitted : null,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,

      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      conflicts : null,
      local : false,
      remote : null,

      status : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
      local : 0,
      unpushed : null,
      uncommitted : 1,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      'remoteBranches' : null,
      'remoteCommits' : null,
      'remoteTags' : null,

      'uncommitted' : false,
      'uncommittedAdded' : false,
      'uncommittedChanged' : false,
      'uncommittedCopied' : false,
      'uncommittedDeleted' : false,
      'uncommittedIgnored' : null,
      'uncommittedRenamed' : false,
      'uncommittedUntracked' : false,
      'uncommittedUnstaged' : false,

      'unpushed' : null,
      'unpushedBranches' : null,
      'unpushedCommits' : null,
      'unpushedTags' : null,

      'conflicts' : false,
      'local' : false,
      'remote' : null,

      'status' : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
      local : 0,
      unpushed : 1,
      uncommitted : 1,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : false,
      uncommittedDeleted : false,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,

      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      conflicts : false,
      local : false,
      remote : null,

      status : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
      local : 0,
      unpushed : 0,
      uncommitted : 0,
      remote : 0,
      detailing : 1,
      explaining : 1
    })
    var expected =
    {
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,

      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      conflicts : null,
      local : null,
      remote : null,

      status : null
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,
      conflicts : null,

      local : null,
      remote : null,


      status : null
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : false,
      remoteTags : false,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      conflicts : null,
      local : null,
      remote : false,

      status : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,
      conflicts : null,

      local : null,
      remote : null,


      status : null
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      conflicts : null,
      local : null,
      remote : false,

      status : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : false,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      conflicts : null,
      local : null,
      remote : false,

      status : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : false,
      remoteTags : false,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      conflicts : null,
      local : null,
      remote : false,

      status : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : false,
      remoteTags : false,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      conflicts : null,
      local : null,
      remote : false,

      status : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : false,
      remoteTags : false,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : false,
      uncommittedDeleted : false,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,
      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      conflicts : false,
      local : false,
      remote : false,

      status : false
    }
    test.identical( status, expected );

    //

    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : null,
      remoteTags : false,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,
      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      conflicts : false,
      local : false,
      remote : false,

      status : false
    }
    test.identical( status, expected );

    return null;
  })

  /*  */

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( a.fileProvider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
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

    return a.ready;
  }

}

status.timeOut = 30000;

//

function statusFull( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.currentPath = a.abs( 'clone' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  prepareRepo()

  begin()
  .then( () =>
  {
    debugger
    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      conflicts : null,

      prs : null,

      local : null,
      remote : null,

      status : null,

      isRepository : true
    }
    test.identical( status, expected );

    //

    debugger
    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      conflicts : null,

      prs : null,

      local : null,
      remote : null,

      status : null,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,

      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      conflicts : null,

      prs : null,

      local : false,
      remote : null,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : false,
      uncommittedDeleted : false,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,

      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      prs : null,

      conflicts : false,

      local : false,
      remote : null,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : false,
      uncommittedDeleted : false,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,

      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      prs : null,

      conflicts : false,

      local : false,
      remote : null,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,

      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      prs : null,

      conflicts : null,

      local : null,
      remote : null,

      status : null,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,

      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      prs : null,

      conflicts : null,

      local : false,
      remote : null,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : false,
      uncommittedDeleted : false,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,

      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      prs : null,

      conflicts : false,

      local : false,
      remote : null,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : false,
      uncommittedDeleted : false,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,

      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      prs : null,

      conflicts : false,

      local : false,
      remote : null,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,

      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      prs : null,

      conflicts : null,

      local : null,
      remote : null,

      status : null,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      prs : null,

      conflicts : null,

      local : null,
      remote : null,

      status : null,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : false,
      remoteTags : false,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      prs : null,

      conflicts : null,

      local : null,
      remote : false,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : null,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      prs : null,

      conflicts : null,

      local : null,
      remote : null,

      status : null,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : null,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      prs : null,

      conflicts : null,

      local : null,
      remote : false,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : false,
      remoteTags : null,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      prs : null,

      conflicts : null,

      local : null,
      remote : false,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : false,
      remoteTags : false,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      prs : null,

      conflicts : null,

      local : null,
      remote : false,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : false,
      remoteTags : false,

      uncommitted : null,
      uncommittedAdded : null,
      uncommittedChanged : null,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : null,
      uncommittedUntracked : null,
      uncommittedUnstaged : null,
      unpushed : null,
      unpushedBranches : null,
      unpushedCommits : null,
      unpushedTags : null,

      prs : null,

      conflicts : null,

      local : null,
      remote : false,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : false,
      remoteTags : false,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : false,
      uncommittedDeleted : false,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,
      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      prs : null,

      conflicts : false,

      local : false,
      remote : false,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : null,
      remoteTags : false,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : null,
      uncommittedDeleted : null,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,
      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      prs : null,

      conflicts : false,

      local : false,
      remote : false,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    //

    var status = _.git.statusFull
    ({
      localPath : a.abs( 'clone' ),
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
      remoteBranches : false,
      remoteCommits : false,
      remoteTags : false,

      uncommitted : false,
      uncommittedAdded : false,
      uncommittedChanged : false,
      uncommittedCopied : false,
      uncommittedDeleted : false,
      uncommittedIgnored : null,
      uncommittedRenamed : false,
      uncommittedUntracked : false,
      uncommittedUnstaged : false,
      unpushed : false,
      unpushedBranches : false,
      unpushedCommits : false,
      unpushedTags : false,

      prs : _.maybe,

      conflicts : false,

      local : false,
      remote : false,

      status : false,

      isRepository : true
    }
    test.identical( status, expected );

    return null;
  })

  /*  */

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( a.fileProvider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
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

    return a.ready;
  }

}

statusFull.timeOut = 30000;

//


function statusEveryCheck( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready,
  })

  a.cloned = _.process.starter
  ({
    currentPath : a.abs( 'clone' ),
    ready : a.ready
  })

  a.secondary = _.process.starter
  ({
    currentPath : a.abs( 'secondary' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

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
      localPath : a.abs( 'clone' ),

      detailing : 1,
      explaining : 1,

      remote : 1,
      remoteBranches : 1,
      remoteCommits : 1,
      remoteTags : 1,

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
  a.cloned( 'git checkout -b  newbranch' )
  a.cloned( 'echo \"Hello World!\" > changed' )
  a.cloned( 'git commit -am change' )
  a.cloned( 'git checkout master' )
  a.cloned( 'echo \"Hello world!\" > changed' )
  a.cloned( 'git commit -am change' )
  a.cloned({ execPath : 'git merge newbranch', throwingExitCode : 0 })
  a.cloned( 'git status --b --porcelain -u ')
  .then( () =>
  {
    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),

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
  a.cloned( 'touch untracked' )
  a.cloned( 'touch tracked' )
  a.cloned( 'touch file' )
  a.cloned( 'git add tracked' )
  a.cloned( 'git add file' )
  a.cloned( 'git commit -m test file' )
  a.cloned( 'echo "xxx" > file' )
  a.cloned( 'git checkout -b  newbranch' )
  a.cloned( 'echo \"Hello World!\" > changed' )
  a.cloned( 'git commit -am change' )
  a.cloned( 'git checkout master' )
  a.cloned( 'echo \"Hello world!\" > changed' )
  a.cloned( 'git commit -am change' )
  a.cloned({ execPath : 'git merge newbranch', throwingExitCode : 0 })
  .then( () =>
  {
    var status = _.git.status
    ({
      localPath : a.abs( 'clone' ),

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

  return a.ready;

  /* - */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    })

    a.shell2( 'git init --bare' );

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    a.shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( 'secondary', 'changed' ), 'changed' )
      a.fileProvider.fileWrite( a.abs( 'secondary', 'renamed' ), 'renamed' )
      a.fileProvider.fileWrite( a.abs( 'secondary', 'copied' ), 'copied' )
      a.fileProvider.fileWrite( a.abs( 'secondary', 'deleted' ), 'deleted' )
      a.fileProvider.fileWrite( a.abs( 'secondary', 'changed2' ), 'changed2' )
      return null;
    })

    a.shell( 'git -C secondary add -fA .' )
    a.shell( 'git -C secondary commit -m init' )
    a.shell( 'git -C secondary push' )

    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      test.case = 'clean clone';
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' ),
      })
    })

    return a.ready;
  }

  function remoteChanges()
  {
    repoNewCommit( 'newcommit' )// new commit to master
    repoNewCommitToBranch( 'newcommittobranch', 'testbranch' )// new branch
    repoNewCommitToBranch( 'newcommittobranch', 'second' )// new commit to second branch
    repoNewTag( 'testtag' )//regular tag
    repoNewTag( 'testtag2', true ) //annotated tag

    return a.ready;
  }

  function localChanges()
  {
    a.cloned( 'git checkout -b new' )//unpushed branch
    a.cloned( 'git checkout second' )//commit to second branch
    a.cloned( 'git commit --allow-empty -m test' )
    a.cloned( 'git checkout master' )//commit to master branch
    a.cloned( 'git commit --allow-empty -m test' )

    a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( 'clone', 'added' ), 'added' )
      a.fileProvider.fileWrite( a.abs( 'clone', 'untracked' ), 'untracked' )
      a.fileProvider.fileWrite( a.abs( 'clone', 'ignored' ), 'ignored' )
      a.fileProvider.fileWrite( a.abs( 'clone', 'changed' ), 'changed2' )
      a.fileProvider.fileWrite( a.abs( 'clone', 'changed2' ), 'changed3' )
      a.fileProvider.fileDelete( a.abs( 'clone', 'deleted' ) )
      a.fileProvider.fileCopy( a.abs( 'clone', 'copied2' ), a.abs( 'clone', 'copied' ) )

      _.git.ignoreAdd( a.abs( 'clone' ), { 'ignored' : null } )

      return null;
    })

    a.cloned( 'git add .gitignore' )
    a.cloned( 'git add added' )
    a.cloned( 'git mv renamed renamed2' )
    a.cloned( 'git add changed' )
    a.cloned( 'git tag tag2' )
    a.cloned( 'git tag -a tag3 -m "sometag"' )

    return a.ready;
  }

  function repoNewCommit( message )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )
    shell( 'git -C secondary commit --allow-empty -m ' + message )
    shell( 'git -C secondary push' )

    return a.ready;
  }

  function repoNewTag( tag, annotated )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    a.ready.then( () =>
    {
      let secondRepoPath = a.abs( 'secondary' );
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    if( !annotated )
    {
      shell( 'git -C secondary tag ' + tag )
    }
    else
    {
      shell( `git -C secondary tag -a ${tag} -m "sometag"` )
    }

    shell( 'git -C secondary push --tags' )

    return a.ready;
  }

  function repoNewCommitToBranch( message, branch )
  {
    let shell = _.process.starter
    ({
      currentPath : a.abs( '.' ),
      ready : a.ready
    })

    let create = true;
    let secondRepoPath = a.abs( a.abs( '.' ), 'secondary' );

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( secondRepoPath );
      return null;
    })

    shell( 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' secondary' )

    a.ready.then( () =>
    {
      if( a.fileProvider.fileExists( a.abs( secondRepoPath, '.git/refs/head', branch ) ) )
      create = false;
      return null;
    })

    a.ready.then( () =>
    {
      let con2 = new _.Consequence().take( null );
      let shell2 = _.process.starter
      ({
        currentPath : a.abs( '.' ),
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

    return a.ready;
  }

}

statusEveryCheck.timeOut = 60000;

//

function repositoryInit( test )
{
  if( !Config.debug )
  {
    test.is( true );
    return;
  }

  test.shouldThrowErrorSync( () =>
  {
    _.git.repositoryInit
    ({
      localPath : null,
      remotePath : null,
      token : 'token',
      local : 1,
      remote : 1,
      dry : 1,
    });
  })

  test.shouldThrowErrorSync( () =>
  {
    _.git.repositoryInit
    ({
      localPath : null,
      remotePath : 'https://github.com/user/New2',
      token : 'token',
      local : 1,
      remote : 1,
      dry : 1,
    });
  })
}

//

function prOpen( test )
{
  let a = test.assetFor( 'basic' );
  a.reflect();

  a.ready.Try( () =>
  {
    return repositoryDelete( 'https://github.com/bot-w/New' );
  })
  .catch( ( err ) =>
  {
    _.errAttend( err );
    return null;
  })

  a.ready.then( () =>
  {
    return _.git.repositoryInit
    ({
      remotePath : 'https://github.com/bot-w/New',
      localPath : a.routinePath,
      throwing : 1,
      sync : 1,
      verbosity : 0,
      dry : 0,
      description : 'Test',
      token : process.env.WTOOLS_BOT_TOKEN,
    })
  })

  /* - */

  a.shell( `git config credential.helper '!f(){ echo "username=bot-w" && echo "password=${ process.env.WTOOLS_BOT_TOKEN }"; }; f'` );
  a.shell( 'git add --all' );
  a.shell( 'git commit -m first' );
  a.shell( 'git push -u origin master' );
  a.shell( 'git checkout -b new' );
  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'File.txt' ), 'new line\n' );
    return null;
  });
  a.shell( 'git commit -am second' );
  a.shell( 'git push -u origin new' );

  a.ready.then( () =>
  {
    return _.git.prOpen
    ({
      token : process.env.WTOOLS_BOT_TOKEN,
      remotePath : 'https://github.com/bot-w/New',
      title : 'new',
      srcBranch : 'new',
      dstBranch : 'master',
    });
  })
  a.ready.then( ( op ) =>
  {
    test.case = 'opened pr only title';
    test.identical( op.changed_files, 1 );
    test.identical( op.state, 'open' );
    test.identical( op.title, 'new' );
    test.identical( _.strCount( op.html_url, /https:\/\/github\.com\/bot-w\/New\/pull\/\d/ ), 1 );
    return null;
  });

  /* */

  a.shell( 'git checkout master' );
  a.shell( 'git checkout -b new2' );
  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'File.txt' ), 'new line\n' );
    return null;
  });
  a.shell( 'git commit -am second' );
  a.shell( 'git push -u origin new2' );

  a.ready.then( () =>
  {
    return _.git.prOpen
    ({
      token : process.env.WTOOLS_BOT_TOKEN,
      remotePath : 'https://github.com/bot-w/New',
      title : 'new2',
      body : 'Some description',
      srcBranch : 'new2',
      dstBranch : 'master',
    });
  })
  a.ready.then( ( op ) =>
  {
    test.case = 'opened pr with body';
    test.identical( op.body, 'Some description' );
    test.identical( op.changed_files, 1 );
    test.identical( op.state, 'open' );
    test.identical( op.title, 'new2' );
    test.identical( _.strCount( op.html_url, /https:\/\/github\.com\/bot-w\/New\/pull\/\d/ ), 1 );
    return null;
  });

  /* */

  a.shell( 'git checkout master' );
  a.shell( 'git checkout -b new3' );
  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'File.txt' ), 'new line\n' );
    return null;
  });
  a.shell( 'git commit -am second' );
  a.shell( 'git push -u origin new3' );

  a.ready.then( () =>
  {
    return _.git.prOpen
    ({
      token : process.env.WTOOLS_BOT_TOKEN,
      remotePath : 'https://github.com/bot-w/New',
      title : 'new3',
      srcBranch : 'bot-w:new3',
      dstBranch : 'master',
      sync : 0,
    });
  })
  a.ready.then( ( op ) =>
  {
    test.case = 'opened pr, sync : 0, srcBranch has user name';
    test.identical( op.changed_files, 1 );
    test.identical( op.state, 'open' );
    test.identical( op.title, 'new3' );
    test.identical( _.strCount( op.html_url, /https:\/\/github\.com\/bot-w\/New\/pull\/\d/ ), 1 );
    return null;
  });

  /* - */

  a.ready.then( () =>
  {

    if( !Config.debug )
    return null;

    test.case = 'wrong git service';
    test.shouldThrowErrorSync( () =>
    {
      _.git.prOpen
      ({
        throwing : 1,
        sync : 1,
        token : 'token',
        remotePath : 'https://gitlab.com/user/NewRepo',
        title : 'master',
        body : null,
        srcBranch : 'doc',
        dstBranch : 'master',
      });
    })

    test.case = 'wrong token';
    test.shouldThrowErrorSync( () =>
    {
      _.git.prOpen
      ({
        throwing : 1,
        sync : 1,
        token : 'token',
        remotePath : 'https://github.com/user/NewRepo',
        title : 'master',
        body : null,
        srcBranch : 'doc',
        dstBranch : 'master',
      });
    })

    test.case = 'without fields title, srcBranch';
    test.shouldThrowErrorSync( () =>
    {
      _.git.prOpen
      ({
        sync : 1,
        token : 'token',
        remotePath : 'https://github.com/user/NewRepo',
        dstBranch : 'master',
      });
    })

    test.case = 'without token';
    test.shouldThrowErrorSync( () =>
    {
      _.git.prOpen
      ({
        remotePath : 'https://github.com/user/NewRepo',
        title : 'master',
        body : null,
        srcBranch : 'doc',
        dstBranch : 'master',
      });
    })

    return null
  });

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    repositoryDelete( 'https://github.com/bot-w/New' );

    if( err )
    throw _.err( err );
    return null;
  })

  return a.ready;

  /* */

  function repositoryDelete( remotePath )
  {
    return _.git.repositoryDelete
    ({
      remotePath,
      throwing : 1,
      sync : 1,
      verbosity : 1,
      dry : 0,
      token : process.env.WTOOLS_BOT_TOKEN,
    })
  }
}

prOpen.timeOut = 60000;

//

function repositoryHasTag( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  begin()
  .then( () =>
  {
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 1,
      remote : 1,
      sync : 1
    })
    test.identical( got, true );

    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 0,
      remote : 1,
      sync : 1
    })
    test.identical( got, true );

    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 1,
      remote : 0,
      sync : 1
    })
    test.identical( got, true );

    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 1,
      remote : 1,
      sync : 1
    })
    test.identical( got, false );

    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 0,
      remote : 1,
      sync : 1
    })
    test.identical( got, false );

    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 1,
      remote : 0,
      sync : 1
    })
    test.identical( got, false );

    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 1,
      remote : 1,
      sync : 1
    })
    test.identical( got, true );

    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 1,
      remote : 0,
      sync : 1
    })
    test.identical( got, true );

    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 0,
      remote : 1,
      sync : 1
    })
    test.identical( got, true );

    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 1,
      remote : 1,
      sync : 1
    })
    test.identical( got, false );

    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 0,
      remote : 1,
      sync : 1
    })
    test.identical( got, false );

    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 1,
      remote : 0,
      sync : 1
    })
    test.identical( got, false );

    test.description = 'should throw error if localPath does not contain git repo'
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasTag
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        tag : 'master',
        local : 1,
        remote : 1,
        sync : 1
      })
    })

    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasTag
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        tag : 'master',
        local : 0,
        remote : 1,
        sync : 1
      })
    })

    if( !Config.debug )
    return null;


    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasTag
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
        local : 0,
        remote : 0,
        sync : 1
      })
    })

    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasTag
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        tag : 'master',
        local : 0,
        remote : 0,
        sync : 1
      })
    })

    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasTag
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        tag : '0.0.37',
        local : 0,
        remote : 0,
        sync : 1
      })
    })

    return null;
  })

  return a.ready;

  /*  */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) ))
    a.shell( `git clone ${ 'https://github.com/Wandalen/wModuleForTesting1.git' }` )
    return a.ready;
  }

}

repositoryHasTag.timeOut = 60000;

//

function repositoryHasVersion( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  begin()
  .then( () =>
  {
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
      sync : 1
    })
    test.identical( got, true );

    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a730fa104a7b6c7',
      sync : 1
    })
    test.identical( got, true );

    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a',
      sync : 1
    })
    test.identical( got, true );

    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'd290dbaa22ea0f13a75d5b9ba19d5b061c6ba8bf',
      sync : 1
    })
    test.identical( got, false );

    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasVersion
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        version : 'master',
        sync : 1
      })
    })

    test.description = 'version length less than 7'
    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasVersion
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        version : '1c',
        sync : 1
      })
    })

    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasVersion
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        version : '0.0.37',
        sync : 1
      })
    })

    test.description = 'remote repository, should throw error'
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) )

    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasVersion
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        version : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
        sync : 1
      })
    })

    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasVersion
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        version : 'd290dbaa22ea0f13a75d5b9ba19d5b061c6ba8bf',
        sync : 1
      })
    })

    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasVersion
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        version : '0.0.37',
        sync : 1
      })
    })

    //

    if( !Config.debug )
    return null;

    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasVersion
      ({
        localPath : null,
        version : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
        sync : 1
      })
    })

    test.shouldThrowErrorSync( () =>
    {
      _.git.repositoryHasVersion
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        version : null,
        sync : 1
      })
    })

    return null;
  })

  return a.ready;

  /*  */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) ))
    a.shell( `git clone ${'https://github.com/Wandalen/wModuleForTesting1.git'}` )
    return a.ready;
  }

}

repositoryHasVersion.timeOut = 60000;

//

function diff( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let remotePath = 'https://github.com/Wandalen/wPathBasic.git';
  let latestCommit = _.git.versionRemoteLatestRetrive({ remotePath });

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  begin()
  .then( () =>
  {
    test.case = 'compare two identical states of repo'
    var got = _.git.diff
    ({
      state1 : 'HEAD',
      state2 : `#${latestCommit}`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : '',
      modifiedFiles : '',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'HEAD',
      state2 : `#${latestCommit}`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : false,
      modifiedFiles : false,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'HEAD',
      state2 : `#${latestCommit}`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : '',
      modifiedFiles : false,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'HEAD',
      state2 : `#${latestCommit}`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : false,
      modifiedFiles : false,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    return null;
  })

  begin()
  .then( () =>
  {
    var status =
`modifiedFiles:
  .im.will.yml
  out/wPathBasic.out.will.yml
  package.json
  was.package.json
deletedFiles:
  proto/dwtools/abase/l3.test/PathBasic.test.s
addedFiles:
  proto/dwtools/abase/l2.test/Path.test.s
renamedFiles:
  proto/dwtools/abase/l3.test/PathBasic.test.html
  proto/dwtools/abase/l3/PathBasic.s
  proto/dwtools/abase/l4.test/Paths.test.s
  proto/dwtools/abase/l4/PathsBasic.s`

    var statusOriginal =
` .im.will.yml                                       |   10 +-
 out/wPathBasic.out.will.yml                        |   38 +-
 package.json                                       |   10 +-
 .../PathBasic.test.html => l2.test/Path.test.html} |    0
 proto/dwtools/abase/l2.test/Path.test.s            | 8570 ++++++++++++++++++
 proto/dwtools/abase/{l3 => l2}/PathBasic.s         | 1999 ++---
 proto/dwtools/abase/l3.test/PathBasic.test.s       | 9062 --------------------
 .../abase/{l4.test => l3.test}/Paths.test.s        | 1446 ++--
 proto/dwtools/abase/{l4 => l3}/PathsBasic.s        |  263 +-
 was.package.json                                   |    6 +-
 10 files changed, 10676 insertions(+), 10728 deletions(-)
`

    test.case = 'compare two commits'
    var got = _.git.diff
    ({
      state1 : '#0e2b5fb2566960cd412c3d992c98098128a04af5',
      state2 : `#db9497547fefa56a29e4a01f48a4d2d0050fa49c`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      modifiedFiles : '.im.will.yml\nout/wPathBasic.out.will.yml\npackage.json\nwas.package.json',
      deletedFiles : 'proto/dwtools/abase/l3.test/PathBasic.test.s',
      addedFiles : 'proto/dwtools/abase/l2.test/Path.test.s',
      renamedFiles : 'proto/dwtools/abase/l3.test/PathBasic.test.html\nproto/dwtools/abase/l3/PathBasic.s\nproto/dwtools/abase/l4.test/Paths.test.s\nproto/dwtools/abase/l4/PathsBasic.s',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
      status

    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : '#0e2b5fb2566960cd412c3d992c98098128a04af5',
      state2 : `#db9497547fefa56a29e4a01f48a4d2d0050fa49c`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : true,
      addedFiles : true,
      renamedFiles : true,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : '#0e2b5fb2566960cd412c3d992c98098128a04af5',
      state2 : `#db9497547fefa56a29e4a01f48a4d2d0050fa49c`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : statusOriginal,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : '#0e2b5fb2566960cd412c3d992c98098128a04af5',
      state2 : `#db9497547fefa56a29e4a01f48a4d2d0050fa49c`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })


  begin()
  .then( () =>
  {
    var status =
`modifiedFiles:
  .ex.will.yml
  .gitattributes
  .im.will.yml
  .travis.yml
  LICENSE
  README.md
  out/wPathBasic.out.will.yml
  package.json
  proto/dwtools/abase/l3.test/PathBasic.test.s
  proto/dwtools/abase/l3/PathBasic.s
  proto/dwtools/abase/l4.test/Paths.test.s
deletedFiles:
  was.package.json
addedFiles:
  out/debug/dwtools/Tools.s
  out/debug/dwtools/abase/l3.test/PathBasic.test.html
  out/debug/dwtools/abase/l3.test/PathBasic.test.s
  out/debug/dwtools/abase/l3/PathBasic.s
  out/debug/dwtools/abase/l4.test/Paths.test.s
  out/debug/dwtools/abase/l4/PathsBasic.s
  out/wPathFundamentals.out.will.yml
  package-old.json`

    var statusOriginal =
` .ex.will.yml                                       |   98 +-
 .gitattributes                                     |    1 +
 .im.will.yml                                       |  242 +-
 .travis.yml                                        |    2 +-
 LICENSE                                            |    3 +-
 README.md                                          |    8 -
 out/debug/dwtools/Tools.s                          |   24 +
 .../dwtools/abase/l3.test/PathBasic.test.html      |   45 +
 out/debug/dwtools/abase/l3.test/PathBasic.test.s   | 8438 ++++++++++++++++++++
 out/debug/dwtools/abase/l3/PathBasic.s             | 2855 +++++++
 out/debug/dwtools/abase/l4.test/Paths.test.s       | 1400 ++++
 out/debug/dwtools/abase/l4/PathsBasic.s            |  482 ++
 out/wPathBasic.out.will.yml                        | 1856 ++---
 out/wPathFundamentals.out.will.yml                 |  598 ++
 package-old.json                                   |   54 +
 package.json                                       |   83 +-
 proto/dwtools/abase/l3.test/PathBasic.test.s       | 1324 +--
 proto/dwtools/abase/l3/PathBasic.s                 |  689 +-
 proto/dwtools/abase/l4.test/Paths.test.s           |   70 +-
 was.package.json                                   |   30 -
 20 files changed, 15281 insertions(+), 3021 deletions(-)
`
    test.case = 'compare commit and tag'
    var got = _.git.diff
    ({
      state1 : '#0e2b5fb2566960cd412c3d992c98098128a04af5',
      state2 : `!v0.7.4`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      modifiedFiles : '.ex.will.yml\n.gitattributes\n.im.will.yml\n.travis.yml\nLICENSE\nREADME.md\nout/wPathBasic.out.will.yml\npackage.json\nproto/dwtools/abase/l3.test/PathBasic.test.s\nproto/dwtools/abase/l3/PathBasic.s\nproto/dwtools/abase/l4.test/Paths.test.s',
      deletedFiles : 'was.package.json',
      addedFiles : 'out/debug/dwtools/Tools.s\nout/debug/dwtools/abase/l3.test/PathBasic.test.html\nout/debug/dwtools/abase/l3.test/PathBasic.test.s\nout/debug/dwtools/abase/l3/PathBasic.s\nout/debug/dwtools/abase/l4.test/Paths.test.s\nout/debug/dwtools/abase/l4/PathsBasic.s\nout/wPathFundamentals.out.will.yml\npackage-old.json',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
      status
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : '#0e2b5fb2566960cd412c3d992c98098128a04af5',
      state2 : `!v0.7.4`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : true,
      addedFiles : true,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : '#0e2b5fb2566960cd412c3d992c98098128a04af5',
      state2 : `!v0.7.4`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : statusOriginal,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : '#0e2b5fb2566960cd412c3d992c98098128a04af5',
      state2 : `!v0.7.4`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })

  begin()
  .then( () =>
  {
    test.case = 'compare two identical commits'
    var got = _.git.diff
    ({
      state1 : '#db9497547fefa56a29e4a01f48a4d2d0050fa49c',
      state2 : '#db9497547fefa56a29e4a01f48a4d2d0050fa49c',
      localPath : a.abs( 'wPathBasic' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : '',
      modifiedFiles : '',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : '#db9497547fefa56a29e4a01f48a4d2d0050fa49c',
      state2 : `#db9497547fefa56a29e4a01f48a4d2d0050fa49c`,
      localPath : a.abs( 'wPathBasic' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : false,
      modifiedFiles : false,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : '#db9497547fefa56a29e4a01f48a4d2d0050fa49c',
      state2 : '#db9497547fefa56a29e4a01f48a4d2d0050fa49c',
      localPath : a.abs( 'wPathBasic' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : '',
      modifiedFiles : false,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : '#db9497547fefa56a29e4a01f48a4d2d0050fa49c',
      state2 : '#db9497547fefa56a29e4a01f48a4d2d0050fa49c',
      localPath : a.abs( 'wPathBasic' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : false,
      modifiedFiles : false,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    return null;
  })

  /* */

  return a.ready;

  /*  */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'wPathBasic' ) ))
    a.shell( `git clone ${remotePath}` )
    return a.ready;
  }
}

diff.timeOut = 60000;

//

function diffSpecial( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shell.predefined.outputCollecting = 1;
  a.shell.predefined.currentPath = a.abs( 'repo' )

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'bare' ),
    ready : a.ready
  })

  a.fileProvider.dirMake( a.abs( '.' ) )

  /*  */

  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'dat' )
    return null;
  })
  .then( () =>
  {
    test.case = 'working..HEAD'
    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `HEAD`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : 'modifiedFiles:\n  file',
      modifiedFiles : 'file',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `HEAD`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `HEAD`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status :
      ' file | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n',
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `HEAD`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })

  //

  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'dat' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m change' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data2' )
    return null;
  })
  a.shell( 'git rev-parse HEAD^' )
  .then( ( got ) =>
  {
    let prevCommit = _.strStrip( got.output );
    test.case = 'working vs previous commit'
    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `#${prevCommit}`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : 'modifiedFiles:\n  file',
      modifiedFiles : 'file',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `#${prevCommit}`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `#${prevCommit}`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status :
      ' file | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n',
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `#${prevCommit}`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })

  //

  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m init' )
  a.shell( 'git tag -a init -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'dat' )
    return null;
  })
  .then( () =>
  {
    test.case = 'working..tag'
    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : 'modifiedFiles:\n  file',
      modifiedFiles : 'file',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status :
      ' file | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n',
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'dat' )
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'data' )
    return null;
  })
  a.shell( 'git add file' )
  .then( () =>
  {
    test.case = 'staging..HEAD, untracked file should be ignored'
    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `HEAD`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : 'modifiedFiles:\n  file',
      modifiedFiles : 'file',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `HEAD`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `HEAD`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status :
      ' file | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n',
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `HEAD`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'dat' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m change' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data2' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git rev-parse HEAD^' )
  .then( ( got ) =>
  {
    let prevCommit = _.strStrip( got.output );
    test.case = 'staging, compare with previous commit'
    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `#${prevCommit}`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : 'modifiedFiles:\n  file',
      modifiedFiles : 'file',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `HEAD`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `HEAD`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status :
      ' file | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n',
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `HEAD`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })

  /*  */

  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m init' )
  a.shell( 'git tag -a init -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'dat' )
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'data' )
    return null;
  })
  a.shell( 'git add file' )
  .then( () =>
  {
    test.case = 'staging..tag, untracked file should be ignored'
    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : 'modifiedFiles:\n  file',
      modifiedFiles : 'file',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status :
      ' file | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n',
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'datadata' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m change' )
  .then( () =>
  {
    test.case = 'committed..HEAD^'
    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `HEAD^`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : 'modifiedFiles:\n  file',
      modifiedFiles : 'file',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `HEAD^`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `HEAD^`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status :
      ' file | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n',
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `HEAD^`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })

  /* */

  initBare()
  cloneBare()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'datadata' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m change' )
  .then( () =>
  {
    test.case = 'committed, unpushed commit..origin'
    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `!origin/`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : 'modifiedFiles:\n  file',
      modifiedFiles : 'file',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `!origin/`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `!origin/`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status :
      ' file | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n',
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `!origin/`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })

  //

  initBare()
  cloneBare()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'datadata' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m change' )
  a.shell( 'git ls-remote origin HEAD' )
  .then( ( got ) =>
  {
    let remoteHEAD = _.strIsolateLeftOrAll( got.output, /\s+/ )[ 0 ];
    test.case = 'committed, unpushed commit..lastest commit on remote'
    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${remoteHEAD}`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : 'modifiedFiles:\n  file',
      modifiedFiles : 'file',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${remoteHEAD}`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${remoteHEAD}`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status :
      ' file | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n',
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${remoteHEAD}`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })

  //

  initBare()
  cloneBare()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'datadata' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m change' )
  a.shell( 'git push' )
  a.shell( 'git ls-remote origin HEAD' )
  .then( ( got ) =>
  {
    let remoteHEAD = _.strIsolateLeftOrAll( got.output, /\s+/ )[ 0 ];
    test.case = 'committed, pushed commit..lastest commit on remote'
    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${remoteHEAD}`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : '',
      modifiedFiles : '',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${remoteHEAD}`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : false,
      modifiedFiles : false,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${remoteHEAD}`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : '',
      modifiedFiles : false,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${remoteHEAD}`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : false,
      modifiedFiles : false,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    return null;
  })

  /* */

  begin()
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m init' )
  a.shell( 'git tag -a init -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'datadata' )
    return null;
  })
  a.shell( 'git add file' )
  a.shell( 'git commit -m change' )
  .then( () =>
  {
    test.case = 'committed..tag'
    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : 'modifiedFiles:\n  file',
      modifiedFiles : 'file',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : true,
      deletedFiles : false,
      addedFiles : false,
      renamedFiles : false,
      copiedFiles : false,
      typechangedFiles : false,
      unmergedFiles : false,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status :
      ' file | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n',
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `!init`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : true,
      modifiedFiles : _.maybe,
      deletedFiles : _.maybe,
      addedFiles : _.maybe,
      renamedFiles : _.maybe,
      copiedFiles : _.maybe,
      typechangedFiles : _.maybe,
      unmergedFiles : _.maybe,
    }
    test.contains( got, expected )

    return null;
  })

  /* */

  return a.ready;

  /*  */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'repo' ) ))
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'repo' ) ); return null })
    a.shell( `git init` )
    return a.ready;
  }

  function initBare()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'bare' ) ))
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'bare' ) ); return null })
    a.shell2( `git init --bare` )
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'repo' ) ))
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'repo' ) ); return null })
    a.shell( `git clone ../bare .` )
    a.ready.then( () => { a.fileProvider.fileWrite( a.abs( 'repo', 'file'), 'data' ); return null })
    a.shell( `git add file` )
    a.shell( `git commit -m init` )
    a.shell( `git push` )
    return a.ready;
  }

  function cloneBare()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'repo' ) ))
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'repo' ) ); return null })
    a.shell( `git clone ../bare .` )
    return a.ready;
  }
}

diffSpecial.timeOut = 60000;

//

function gitHooksManager( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let hookName = 'post-commit';
  let handlerName = hookName + '.custom';
  let handlerCode =
  `#!/bin/sh
    echo "Custom handler executed."
  `;
  var specialComment = 'This script is generated by utility willbe';

  /*
    - No git repository
    - No hooks registered
    - User's hook already exists
    - User's hook was created by hookRegister, try to add another one
    - First hook handler returns bad exit code, second should not be executed
    - Try to register hook with existing handler name, previously registered handlers should work as before
    - Register two handlers for single hook, unregister second handler, only first should be executed
  */

  a.ready
  .then( () =>
  {
    test.case = 'No git repository';

    a.fileProvider.filesDelete( a.abs( 'repo' ) );
    a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )

    test.shouldThrowErrorSync( () =>
    {
      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName,
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
      currentPath : a.abs( 'repo' ),
      outputCollecting : 1,
      ready : con
    })

    con.then( () =>
    {
      let files = a.fileProvider.dirRead( a.abs( 'repo', './.git/hooks' ) );
      let samples = files.filter( ( file ) => a.path.ext( file ) === 'sample' );
      test.will = 'only sample hooks are registered'
      test.identical( files.length, samples.length );

      test.will = 'original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )

      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName,
        throwing : 1,
        rewriting : 0
      })

      test.will = 'hook runner was created';
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'hook handler was created'
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      let customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'copy of original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      currentPath : a.abs( 'repo' ),
      outputCollecting : 1,
      ready : con
    })

    con.then( () =>
    {
      let files = a.fileProvider.dirRead( a.abs( 'repo', './.git/hooks' ) );
      let samples = files.filter( ( file ) => a.path.ext( file ) === 'sample' );
      test.will = 'only sample hooks are registered'
      test.identical( files.length, samples.length );

      let originalUserHookCode =
      `#!/bin/sh
      echo "Original user hook."
      `
      a.fileProvider.fileWrite( a.abs( 'repo', './.git/hooks', hookName ), originalUserHookCode );

      test.will = 'users hook exists';
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )

      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName,
        throwing : 1,
        rewriting : 0
      })

      test.will = 'hook runner was created';
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'hook handler was created'
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      let customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'original hook was copied to .was';
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );
      let wasHook = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) + '.was' );
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
      currentPath : a.abs( 'repo' ),
      outputCollecting : 1,
      ready : con
    })

    con.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )
      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName,
        throwing : 1,
        rewriting : 0
      })
      return null;
    })

    con.then( () =>
    {
      let handlerName2 = handlerName + '2';
      let hookHandlerPath2 = a.abs( 'repo', './.git/hooks', handlerName ) + '2';
      let handlerCodePath2 = a.abs( hookName + '.source' ) + '2'

      let handlerCode2 =
      `#!/bin/sh
      echo "Custom handler2 executed."
      `
      a.fileProvider.fileWrite( handlerCodePath2, handlerCode2 )

      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : handlerCodePath2,
        hookName,
        handlerName : handlerName2,
        throwing : 1,
        rewriting : 0
      })

      test.will = 'hook runner was created';
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler exists'
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      var customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'second hook handler exists'
      test.is( a.fileProvider.fileExists( hookHandlerPath2 ) );
      var customHookRead = a.fileProvider.fileRead( hookHandlerPath2 );
      test.identical( customHookRead, handlerCode2 );

      test.will = 'copy of original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
    let hookHandlerPath2 = a.abs( 'repo', './.git/hooks', handlerName ) + '2';
    let handlerCodePath2 = a.abs( hookName + '.source' ) + '2'

    let con = begin();

    let shell = _.process.starter
    ({
      currentPath : a.abs( 'repo' ),
      outputCollecting : 1,
      ready : con
    })

    con.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )
      a.fileProvider.fileWrite( handlerCodePath2, handlerCode2 )

      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : handlerCodePath2,
        hookName,
        handlerName,
        throwing : 1,
        rewriting : 0
      })

      //

      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName : handlerName2,
        throwing : 1,
        rewriting : 0
      })

      //

      test.will = 'hook runner was created';
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler exists'
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      var customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode2 );

      test.will = 'second hook handler exists'
      test.is( a.fileProvider.fileExists( hookHandlerPath2 ) );
      var customHookRead = a.fileProvider.fileRead( hookHandlerPath2 );
      test.identical( customHookRead, handlerCode );

      test.will = 'copy of original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      currentPath : a.abs( 'repo' ),
      outputCollecting : 1,
      ready : con
    })

    con.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )
      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName,
        throwing : 1,
        rewriting : 0
      })
      return null;
    })

    con.then( () =>
    {
      let hooksBefore = a.fileProvider.dirRead( a.abs( 'repo', './.git/hooks' ) );
      let hookRunnerBefore =  a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );

      test.shouldThrowErrorSync( () =>
      {
        _.git.hookRegister
        ({
          repoPath : a.abs( 'repo' ),
          filePath : a.abs( hookName + '.source' ),
          hookName,
          handlerName,
          throwing : 1,
          rewriting : 0
        })
      })

      let hooksAfter = a.fileProvider.dirRead( a.abs( 'repo', './.git/hooks' ) );

      test.identical( hooksAfter, hooksBefore );

      test.will = 'hook runner was not changed created';
      let hookRunnerNow = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.identical( hookRunnerNow, hookRunnerBefore );

      test.will = 'custom hook was not changed'
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      var customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'copy of original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      currentPath : a.abs( 'repo' ),
      outputCollecting : 1,
      ready : con
    })

    con.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )
      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName,
        throwing : 1,
        rewriting : 0
      })
      return null;
    })

    con.then( () =>
    {
      let handlerName2 = handlerName + '2';
      let hookHandlerPath2 = a.abs( 'repo', './.git/hooks', handlerName ) + '2';
      let handlerCodePath2 = a.abs( hookName + '.source' ) + '2'

      let handlerCode2 =
      `#!/bin/sh
      echo "Custom handler2 executed."
      `
      a.fileProvider.fileWrite( handlerCodePath2, handlerCode2 )

      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : handlerCodePath2,
        hookName,
        handlerName : handlerName2,
        throwing : 1,
        rewriting : 0
      })

      _.git.hookUnregister
      ({
        repoPath : a.abs( 'repo' ),
        handlerName : handlerName2,
        force : 0,
        throwing : 1
      })

      test.will = 'hook runner was created';
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler exists'
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      var customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'second hook handler does not exist'
      test.is( !a.fileProvider.fileExists( hookHandlerPath2 ) );

      test.will = 'copy of original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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

  return a.ready;

  /* - */

  function begin()
  {
    let con = new _.Consequence().take( null );

    let shell = _.process.starter
    ({
      currentPath : a.abs( 'repo' ),
      ready : con
    })

    con.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      let filesTree =
      {
        'proto' :
        {
          'Tools.s' : 'Tools'
        }
      }
      let extract = new _.FileProvider.Extract({ filesTree })
      extract.filesReflectTo( context.provider, a.abs( 'repo' ) );
      return null;
    })

    shell( 'git init' )
    shell( 'git add .' )
    shell( 'git commit -m init' )

    return con;
  }
}

gitHooksManager.timeOut = 30000;

//

function gitHooksManagerErrors( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let hookName = 'post-commit';
  let handlerName = hookName + '.custom';
  let handlerCode =
  `#!/bin/sh
  //   echo "Custom handler executed."
  // `;
  var specialComment = 'This script is generated by utility willbe';

  /*
    - No git repository
    - No source file
    - Unknown git hook
    - Wrong handler name: original hook name
    - Wrong handler name: wrong name pattern
    - Rewriting of existing hook
  */

  a.ready
  .then( () =>
  {
    test.case = 'No git repository';

    a.fileProvider.filesDelete( a.abs( 'repo' ) );
    a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )

    test.shouldThrowErrorSync( () =>
    {
      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName,
        throwing : 1,
        rewriting : 0
      })
    })

    return null;
  })

  .then( () =>
  {
    test.case = 'No source file';

    a.fileProvider.filesDelete( a.abs( 'repo' ) );
    test.shouldThrowErrorSync( () =>
    {
      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName,
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
      let files = a.fileProvider.dirRead( a.abs( 'repo', './.git/hooks' ) );
      let samples = files.filter( ( file ) => a.path.ext( file ) === 'sample' );
      test.will = 'only sample hooks are registered'
      test.identical( files.length, samples.length );

      test.will = 'original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )

      test.shouldThrowErrorSync( () =>
      {
        _.git.hookRegister
        ({
          repoPath : a.abs( 'repo' ),
          filePath : a.abs( hookName + '.source' ),
          hookName : 'some-random-hook',
          handlerName,
          throwing : 1,
          rewriting : 0
        })
      })

      test.will = 'hook runner was not created';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'hook handler was not created'
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );

      test.will = 'copy of original hook was not created';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      test.will = 'hooks directory stays the same as before';
      let filesNow = a.fileProvider.dirRead( a.abs( 'repo', './.git/hooks' ) );
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
      let files = a.fileProvider.dirRead( a.abs( 'repo', './.git/hooks' ) );
      let samples = files.filter( ( file ) => a.path.ext( file ) === 'sample' );
      test.will = 'only sample hooks are registered'
      test.identical( files.length, samples.length );

      test.will = 'original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )

      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName,
        throwing : 1,
        rewriting : 0
      })

      test.shouldThrowErrorSync( () =>
      {
        _.git.hookRegister
        ({
          repoPath : a.abs( 'repo' ),
          filePath : a.abs( hookName + '.source' ),
          hookName,
          handlerName : hookName,
          throwing : 1,
          rewriting : 0
        })
      })

      test.will = 'hook runner stays';
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler stays'
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      let customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'copy of original hook was not created';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      let files = a.fileProvider.dirRead( a.abs( 'repo', './.git/hooks' ) );
      let samples = files.filter( ( file ) => a.path.ext( file ) === 'sample' );
      test.will = 'only sample hooks are registered'
      test.identical( files.length, samples.length );

      test.will = 'original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )

      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName,
        throwing : 1,
        rewriting : 0
      })

      let handlerName2 = 'post-yyy-' + handlerName;

      test.shouldThrowErrorSync( () =>
      {
        _.git.hookRegister
        ({
          repoPath : a.abs( 'repo' ),
          filePath : a.abs( hookName + '.source' ),
          hookName,
          handlerName : handlerName2,
          throwing : 1,
          rewriting : 0
        })
      })

      test.will = 'hook runner stays';
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.is( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler stays'
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      let customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'second hook handler does not exist'
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName2 ) ) );

      test.will = 'copy of original hook was not created';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      let files = a.fileProvider.dirRead( a.abs( 'repo', './.git/hooks' ) );
      let samples = files.filter( ( file ) => a.path.ext( file ) === 'sample' );
      test.will = 'only sample hooks are registered'
      test.identical( files.length, samples.length );

      test.will = 'original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      a.fileProvider.fileWrite( a.abs( hookName + '.source' ), handlerCode )

      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName,
        throwing : 1,
        rewriting : 0
      })

      test.shouldThrowErrorSync( () =>
      {
        _.git.hookRegister
        ({
          repoPath : a.abs( 'repo' ),
          filePath : a.abs( hookName + '.source' ),
          hookName,
          handlerName,
          throwing : 1,
          rewriting : 0
        })
      })

      test.will = 'hook runner stays';
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.is( _.strHas( hookRead, specialComment ) );

      test.will = 'first hook handler stays'
      test.is( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      let customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'copy of original hook was not created';
      test.is( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      return null;
    })

    return con;
  })

  return a.ready;

  /* - */

  function begin()
  {
    let con = new _.Consequence().take( null );

    let shell = _.process.starter
    ({
      currentPath : a.abs( 'repo' ),
      ready : con
    })

    con.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      let filesTree =
      {
        'proto' :
        {
          'Tools.s' : 'Tools'
        }
      }
      let extract = new _.FileProvider.Extract({ filesTree })
      extract.filesReflectTo( context.provider, a.abs( 'repo' ) );
      return null;
    })

    shell( 'git init' )
    shell( 'git add .' )
    shell( 'git commit -m init' )

    return con;
  }
}

gitHooksManagerErrors.timeOut = 30000;

//

function hookTrivial( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.fileProvider.dirMake( a.abs( '.' ) );

  a.shell.predefined.throwingExitCode = 0;
  a.shell.predefined.outputCollecting = 1;

  a.shell( 'git init' )
  .then( () =>
  {
    let sourceCode = '#!/usr/bin/env node\n' +  'process.exit( 1 )';
    let tempPath = _.process.tempOpen({ sourceCode });
    _.git.hookRegister
    ({
      repoPath : a.abs( '.' ),
      filePath : tempPath,
      handlerName : 'pre-commit.commitHandler',
      hookName : 'pre-commit',
      throwing : 1,
      rewriting : 0
    })
    _.process.tempClose({ filePath : tempPath });
    test.is( a.fileProvider.fileExists( a.abs( './.git/hooks/pre-commit' ) ) );
    test.is( a.fileProvider.fileExists( a.abs( './.git/hooks/pre-commit.commitHandler' ) ) );

    return null;
  })

  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git log -n 1' )

  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );
    test.is( _.strHas( got.output, `your current branch 'master' does not have any commits yet` ) );
    return got;
  })

  .then( () =>
  {
    test.is( a.fileProvider.fileExists( a.abs ( './.git/hooks/pre-commit' ) ) );
    test.is( a.fileProvider.fileExists( a.abs ( './.git/hooks/pre-commit.commitHandler' ) ) );

    _.git.hookUnregister
    ({
      repoPath : a.abs( '.' ),
      handlerName : 'pre-commit.commitHandler',
      force : 0,
      throwing : 1
    })

    test.is( a.fileProvider.fileExists( a.abs( './.git/hooks/pre-commit' ) ) );
    test.is( !a.fileProvider.fileExists( a.abs( './.git/hooks/pre-commit.commitHandler' ) ) );

    return null;
  })

  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git log -n 1' )

  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, `test` ) );
    return got;
  })

  return a.ready;

}

//

function hookPreservingHardLinks( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.shellClone = _.process.starter
  ({
    currentPath : a.abs( 'clone' ),
    ready : a.ready
  })

  a.shellRepo = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
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
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'a', 'b' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'b', 'c' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'a', 'b', 'c' ] ) ), false );

    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), 'dir', [ 'a', 'b' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), 'dir', [ 'b', 'c' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), 'dir', [ 'a', 'b', 'c' ] ) ), false );

    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'a', 'dir/a' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'b', 'dir/b' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'c', 'dir/c' ] ) ), false );

    return null;
  })

  .then( () => _.git.hookPreservingHardLinksRegister( a.abs( 'clone' ) ) );

  a.shellRepo( 'git commit --allow-empty -m test' )
  a.shellClone( 'git pull' )

  .then( () =>
  {
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'a', 'b' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'b', 'c' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'a', 'b', 'c' ] ) ), false );

    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), 'dir', [ 'a', 'b' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), 'dir', [ 'b', 'c' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), 'dir', [ 'a', 'b', 'c' ] ) ), false );

    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'a', 'dir/a' ] ) ), true );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'b', 'dir/b' ] ) ), true );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'c', 'dir/c' ] ) ), false );

    debugger

    return null;
  })

  .then( () => _.git.hookPreservingHardLinksUnregister( a.abs( 'clone' ) ) )

  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'a' ), 'a1' )
    a.fileProvider.fileWrite( a.abs( 'repo', 'b' ), 'b1' )
    a.fileProvider.fileWrite( a.abs( 'repo', 'c' ), 'c1' )
    return null;
  })

  a.shellRepo( 'git add .' )
  a.shellRepo( 'git commit --allow-empty -m test2' )
  a.shellClone( 'git pull' )

  .then( () =>
  {
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'a', 'b' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'b', 'c' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'a', 'b', 'c' ] ) ), false );

    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), 'dir', [ 'a', 'b' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), 'dir', [ 'b', 'c' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), 'dir', [ 'a', 'b', 'c' ] ) ), false );

    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'a', 'dir/a' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'b', 'dir/b' ] ) ), false );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'c', 'dir/c' ] ) ), false );

    return null;
  })

  return a.ready;

  /*  */

  function prepareRepo()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( a.abs( '.' ) )
      a.fileProvider.dirMake( a.abs( 'repo' ) )

      extract.filesReflectTo( context.provider, a.abs( 'repo' ) );
      return null;
    })

    a.shellRepo( 'git init' )
    a.shellRepo( 'git add .' )
    a.shellRepo( 'git commit -m init' )

    return a.ready;
  }

  //

  function prepareClone()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      a.fileProvider.dirMake( a.abs( 'clone' ) );

      return _.process.start
      ({
        execPath : 'git clone ' + a.path.nativize( a.abs( 'repo' ) ) + ' ' + 'clone',
        currentPath : a.abs( '.' )
      })
    })

    return a.ready;
  }

}

hookPreservingHardLinks.timeOut = 30000;

//

function renormalize( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let file1Data = 'abc\n';
  let file1DataCrlf = 'abc\r\n';

  a.shell.predefined.currentPath = a.abs( 'repo' );

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( '.' ),
    ready : a.ready
  })

  a.shell3 = _.process.starter
  ({
    currentPath : a.abs( 'clone' ),
    sync : 1
  })

  prepare()
  clone()
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );
    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );

    return null;
  })

  /* - */

  prepare()
  clone()
  .then( () =>
  {
    test.case = 'local uncommited change'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    a.fileProvider.fileWrite( a.abs( 'clone', 'file1' ), 'data' );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, 'data' );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, true );
    test.identical( config.core.eol, undefined );

    return null;
  })

  /* - */

  prepare()
  clone()
  .then( () =>
  {
    test.case = 'local uncommited change, safe:0'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    a.fileProvider.fileWrite( a.abs( 'clone', 'file1' ), 'data' );

    return _.git.renormalize({ localPath : a.abs( 'clone' ), safe : 0 });
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );


    return null;
  })


  /* - */

  prepare()
  clone()
  .then( () =>
  {
    test.case = 'local uncommited file'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    a.fileProvider.fileWrite( a.abs( 'clone', 'file2' ), 'data' );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    test.is( a.fileProvider.fileExists( a.abs( 'clone', 'file2' ) ) );

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    let file2 = a.fileProvider.fileRead( a.abs( 'clone', 'file2' ) );
    test.identical( file2, 'data' );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, true );

    return null;
  })

  /* - */

  prepare()
  clone()
  .then( () =>
  {
    test.case = 'local uncommited file'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    a.fileProvider.fileWrite( a.abs( 'clone', 'file2' ), 'data' );

    return _.git.renormalize({ localPath : a.abs( 'clone' ), safe : 0 });
  })
  .then( () =>
  {
    test.is( a.fileProvider.fileExists( a.abs( 'clone', 'file2' ) ) );

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    let file2 = a.fileProvider.fileRead( a.abs( 'clone', 'file2' ) );
    test.identical( file2, 'data' );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );


    return null;
  })

  /* - */

  prepare()
  clone()
  .then( () =>
  {
    test.case = 'local unpushed commit, safe'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    a.fileProvider.fileWrite( a.abs( 'clone', 'file1' ), 'data' );

    a.shell3( 'git commit -am change' );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, 'data' );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, true );
    test.identical( config.core.eol, undefined );

    let status = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
      uncommitted : 1,
      detailing : 1,
      unpushed : 1,
      explaining : 0,
      sync : 1,
    });

    test.identical( status.unpushedCommits, true )

    return null;
  })

  /* - */

  prepare()
  clone()
  .then( () =>
  {
    test.case = 'local unpushed commit, safe:0'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    a.shell3( 'git commit -m change --allow-empty' );

    return _.git.renormalize({ localPath : a.abs( 'clone' ), safe : 0 });
  })
  .then( () =>
  {
    a.shell3( 'git status' );

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );
    test.identical( config.core.eol, undefined );

    let status = _.git.statusLocal
    ({
      localPath : a.abs( 'clone' ),
      uncommitted : 1,
      detailing : 1,
      unpushed : 1,
      explaining : 0,
      sync : 1,
    });

    test.identical( status.unpushedCommits, true )

    return null;
  })

  return a.ready;

  /* - */

  function prepare()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( a.abs( '.' ) )
      a.fileProvider.dirMake( a.abs( 'repo' ) )

      a.fileProvider.fileWrite( a.abs( 'repo', 'file1' ), file1Data );

      return null;
    })

    a.shell( 'git init' )
    a.shell( 'git add -fA .' )
    a.shell( 'git commit -m init' )

    return a.ready;
  }

  function clone()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return null;
    })

    a.shell2( 'git clone repo clone --config core.autocrlf=true' )

    return a.ready;
  }

}

renormalize.timeOut = 30000;

//

function renormalizeOriginHasAttributes( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let file1Data = 'abc\n';
  let file1DataCrlf = 'abc\r\n';
  let eolConfig = globalGitEolGet();

  a.shell2 = _.process.starter
  ({
    currentPath : a.abs( 'repo' ),
    ready : a.ready
  })

  /* - */

  prepare({ attributes : '* text eol=lf' })
  clone()
  .then( () =>
  {
    test.case = 'eol=lf in gitattributes'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );

    return null;
  })


  /* - */

  prepare({ attributes : '* text eol=crlf' })
  clone()
  .then( () =>
  {
    test.case = 'eol=crlf in gitattributes'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1DataCrlf );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );

    return null;
  })


  /* - */

  prepare({ attributes : '*.s linguist-language=JavaScript' })
  clone()
  .then( () =>
  {
    test.case = 'gitattributes without eol'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );

    return null;
  })

  /* - */

  prepare({ attributes : '*.s linguist-language=JavaScript' })
  clone({ config : 'core.eol lf' })
  .then( () =>
  {
    test.case = 'gitattributes without eol, core.eol=lf'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );

    return null;
  })

  /* - */

  prepare({ attributes : '*.s linguist-language=JavaScript' })
  clone({ config : 'core.eol crlf' })
  .then( () =>
  {
    test.case = 'gitattributes without eol, core.eol=crlf'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );

    return null;
  })

  /* - */

  prepare({ attributes : '* text' })
  clone()
  .then( () =>
  {
    test.case = 'text in gitattributes'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );

    if( eolConfig === 'lf' )
    test.identical( file1, file1Data );
    else
    test.identical( file1, file1DataCrlf );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );


    return null;
  })


  /* - */

  prepare({ attributes : '* text' })
  clone({ config : 'core.eol lf' })
  .then( () =>
  {
    test.case = 'text in gitattributes, core.eol=lf'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );


    return null;
  })

  /* - */

  prepare({ attributes : '* text' })
  clone({ config : 'core.eol crlf' })
  .then( () =>
  {
    test.case = 'text in gitattributes, core.eol=crlf'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1DataCrlf );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );


    return null;
  })


  /* - */

  prepare({ attributes : '* text=auto' })
  clone()
  .then( () =>
  {
    test.case = 'eol=auto in gitattributes'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );

    if( eolConfig === 'lf')
    test.identical( file1, file1Data );
    else
    test.identical( file1, file1DataCrlf );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );


    return null;
  })

  /* - */

  prepare({ attributes : '* text=auto' })
  clone({ config : 'core.eol lf' })
  .then( () =>
  {
    test.case = 'eol=auto in gitattributes, core.eol=lf'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );


    return null;
  })

  /* - */

  prepare({ attributes : '* text=auto' })
  clone({ config : 'core.eol crlf' })
  .then( () =>
  {
    test.case = 'eol=auto in gitattributes, core.eol=crlf'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.notIdentical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );

    test.identical( file1, file1DataCrlf );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );


    return null;
  })

  /* - */

  prepare({ attributes : '* -text' })
  clone()
  .then( () =>
  {
    test.case = '-text in gitattributes'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );


    return null;
  })

  /* - */

  prepare({ attributes : '* -text' })
  clone({ config : 'core.eol lf' })
  .then( () =>
  {
    test.case = '-text in gitattributes, core.eol=lf'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );


    return null;
  })

  /* - */

  prepare({ attributes : '* -text' })
  clone({ config : 'core.eol crlf' })
  .then( () =>
  {
    test.case = '-text in gitattributes, core.eol=crlf'

    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    return _.git.renormalize( a.abs( 'clone' ) );
  })
  .then( () =>
  {
    let file1 = a.fileProvider.fileRead( a.abs( 'clone', 'file1' ) );
    test.identical( file1, file1Data );

    test.is( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

    let config = _.git.configRead( a.abs( 'clone' ) );
    test.identical( config.core.autocrlf, false );


    return null;
  })

  return a.ready;

  /* - */

  function prepare( o )
  {
    o = o || {};

    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( a.abs( '.' ) )
      a.fileProvider.dirMake( a.abs( 'repo' ) )

      a.fileProvider.fileWrite( a.abs( 'repo', 'file1' ), file1Data );

      if( o.attributes )
      a.fileProvider.fileWrite( a.abs( 'repo', '.gitattributes' ), o.attributes );

      return null;
    })

    a.shell2( 'git init' )
    a.shell2( 'git add -fA .' )
    a.shell2( 'git commit -m init' )

    return a.ready;
  }

  function clone( o )
  {
    o = o || {}
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return null;
    })

    a.shell( 'git clone repo clone --config core.autocrlf=true' )

    if( o.config )
    a.shell( 'git -C clone config ' + o.config )

    return a.ready;
  }

  function globalGitEolGet()
  {
    var result = _.process.start
    ({
      execPath : 'git config --global core.eol',
      sync : 1,
      outputCollecting : 1,
      throwingExitCode : 0
    });

    result = _.strStrip( result.output );

    if( !result )
    result = process.platform === 'win32' ? 'crlf' : 'lf';

    return result;
  }

}

renormalizeOriginHasAttributes.timeOut = 60000;

//

function renormalizeAudit( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let provider = context.provider;
  let path = provider.path;
  let testPath = path.join( context.suiteTempPath, 'routine-' + test.name );
  // let repoPath = path.join( testPath, 'repo' ); // a.abs( testPath, 'repo' )
  // let clonePath = path.join( testPath, 'clone' ); // a.abs( testPath, 'clone' )
  let file1Data = 'abc\n';

  let con = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    currentPath : a.abs( testPath, 'repo' ),
    ready : con
  })

  let shell2 = _.process.starter
  ({
    currentPath : testPath,
    ready : con
  })

  let programPath = a.program
  ({
    routine : program,
    locals :
    {
      GitToolsPath : a.path.nativize( a.path.resolve( __dirname, '../l3/git/entry/GitTools.ss' ) ),
      ClonePath : a.abs( testPath, 'clone' )
    }
  });

  /* - */

  prepare({ attributes : '* text' })
  clone({ config : 'core.eol crlf' })
  .then( () =>
  {
    test.case = 'text in gitattributes, core.eol=crlf';

    return a.appStartNonThrowing({ execPath : programPath })
    .then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.is( _.strHas( op.output, 'contains lines that can affect the result of EOL normalization'  ) );

      return null;
    });
  })

  return con;

  /* - */

  function prepare( o )
  {
    o = o || {};

    con.then( () =>
    {
      provider.filesDelete( testPath );
      provider.dirMake( testPath )
      provider.dirMake( a.abs( testPath, 'repo' ) )

      provider.fileWrite( a.abs( testPath, 'repo', 'file1' ), file1Data );

      if( o.attributes )
      provider.fileWrite( a.abs( testPath, 'repo', '.gitattributes' ), o.attributes );

      return null;
    })

    shell( 'git init' )
    shell( 'git add -fA .' )
    shell( 'git commit -m init' )

    return con;
  }

  function clone( o )
  {
    o = o || {}
    con.then( () =>
    {
      provider.filesDelete( a.abs( 'clone' ) );
      return null;
    })

    shell2( 'git clone repo clone --config core.autocrlf=true' )

    if( o.config )
    shell2( 'git -C clone config ' + o.config )

    return con;
  }

  function program()
  {
    let _ = require( GitToolsPath );
    _.git.renormalize({ localPath : ClonePath, audit : 1 });
  }
}

renormalizeAudit.timeOut = 15000;


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
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null
  },

  tests :
  {
    pathParse, /* qqq : check tests */

    versionsRemoteRetrive,
    versionsPull,
    versionIsCommitHash,

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
    statusExplaining,
    hasLocalChanges,
    hasRemoteChanges,
    hasChanges,
    hasLocalChangesSpecial,

    hasFiles,
    hasRemote,
    isUpToDate,
    isUpToDateExtended,
    isUpToDateThrowing,
    insideRepository,
    isRepository,

    statusFull,
    statusEveryCheck,

    repositoryInit,
    prOpen,
    repositoryHasTag,
    repositoryHasVersion,

    diff,
    diffSpecial,

    gitHooksManager,
    gitHooksManagerErrors,

    hookTrivial,
    hookPreservingHardLinks,

    renormalize,
    renormalizeOriginHasAttributes,
    renormalizeAudit

  },

}

//

let Self = new wTestSuite( Proto )/* .inherit( Parent ); */
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
