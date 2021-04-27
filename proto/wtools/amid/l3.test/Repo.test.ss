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
// context
// --

function onSuiteBegin( test )
{
  let context = this;
  context.provider = _.fileProvider;
  let path = context.provider.path;
  context.suiteTempPath = context.provider.path.tempOpen( path.join( __dirname, '../..' ), 'Repo' );
  context.assetsOriginalPath = _.path.join( __dirname, '_asset' );
}

//

function onSuiteEnd( test )
{
  let context = this;
  let path = context.provider.path;
  _.assert( _.strHas( context.suiteTempPath, 'Repo' ), context.suiteTempPath );
  path.tempClose( context.suiteTempPath );
}

// --
// tests
// --

function providerForPath( test )
{
  test.case = 'remotePath - git, github, no protocol';
  var got = _.repo.providerForPath( 'git@github.com:user/repo.git' );
  test.identical( got, _.repo.provider.github );

  test.case = 'remotePath - git, github, git protocol';
  var got = _.repo.providerForPath( 'git://git@github.com:user/repo.git' );
  test.identical( got, _.repo.provider.github );

  test.case = 'remotePath - git, github, https protocol';
  var got = _.repo.providerForPath( 'https://github.com/user/repo.git' );
  test.identical( got, _.repo.provider.github );

  test.case = 'remotePath - git, github, git+https protocol';
  var got = _.repo.providerForPath( 'git+https://git@github.com/user/repo.git' );
  test.identical( got, _.repo.provider.github );

  test.case = 'remotePath - git, github, ssh protocol';
  var got = _.repo.providerForPath( 'ssh://git@github.com/user/repo.git' );
  test.identical( got, _.repo.provider.github );

  test.case = 'remotePath - git, github, git+ssh protocol';
  var got = _.repo.providerForPath( 'git+ssh://git@github.com/user/repo.git' );
  test.identical( got, _.repo.provider.github );

  /* */

  test.case = 'remotePath - git, gitlab, no protocol';
  var got = _.repo.providerForPath( 'git@gitlab.com:user/repo.git' );
  test.identical( got, _.repo.provider.git );

  test.case = 'remotePath - git, gitlab, git protocol';
  var got = _.repo.providerForPath( 'git://git@gitlab.com:user/repo.git' );
  test.identical( got, _.repo.provider.git );

  test.case = 'remotePath - git, gitlab, https protocol';
  var got = _.repo.providerForPath( 'https://gitlab.com/user/repo.git' );
  test.identical( got, _.repo.provider.git );

  test.case = 'remotePath - git, gitlab, git+https protocol';
  var got = _.repo.providerForPath( 'git+https://git@gitlab.com/user/repo.git' );
  test.identical( got, _.repo.provider.git );

  test.case = 'remotePath - git, gitlab, ssh protocol';
  var got = _.repo.providerForPath( 'ssh://git@gitlab.com/user/repo.git' );
  test.identical( got, _.repo.provider.git );

  test.case = 'remotePath - git, gitlab, git+ssh protocol';
  var got = _.repo.providerForPath( 'git+ssh://git@gitlab.com/user/repo.git' );
  test.identical( got, _.repo.provider.git );

  /* */

  test.case = 'remotePath - npm';
  var got = _.repo.providerForPath( 'npm://wmodulefortesting1' );
  test.identical( got, _.repo.provider.npm );

  test.case = 'remotePath - global, npm';
  var got = _.repo.providerForPath( 'npm:///wmodulefortesting1' );
  test.identical( got, _.repo.provider.npm );

  /* */

  test.case = 'remotePath - http';
  var got = _.repo.providerForPath( 'http://remote-path.com' );
  test.identical( got, _.repo.provider.http );

  test.case = 'remotePath - global, http';
  var got = _.repo.providerForPath( 'http:///remote-path.com' );
  test.identical( got, _.repo.provider.http );

  test.case = 'remotePath - https';
  var got = _.repo.providerForPath( 'https://remote-path.com' );
  test.identical( got, _.repo.provider.http );

  test.case = 'remotePath - global, https';
  var got = _.repo.providerForPath( 'https:///remote-path.com' );
  test.identical( got, _.repo.provider.http );

  /* */

  test.case = 'remotePath - empty string';
  var got = _.repo.providerForPath( '' );
  test.identical( got, _.repo.provider.hd );

  test.case = 'remotePath - local hard drive path';
  var got = _.repo.providerForPath( '/a/b/c' );
  test.identical( got, _.repo.provider.hd );

  test.case = 'remotePath - hard drive path with protocol';
  var got = _.repo.providerForPath( 'hd://a/b/c' );
  test.identical( got, _.repo.provider.hd );

  test.case = 'remotePath - global hard drive path with protocol';
  var got = _.repo.providerForPath( 'file:///a/b/c' );
  test.identical( got, _.repo.provider.hd );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.repo.providerForPath() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.repo.providerForPath( 'https://github.com/user/repo.git', 'hd:///local' ) );
}

//

function pullListRemote( test )
{
  let a = test.assetFor( 'basic' );
  let user = 'wtools-bot';
  let repository = `https://github.com/${ user }/New-${ _.idWithDateAndTime() }`;
  let token = process.env.PRIVATE_WTOOLS_BOT_TOKEN;

  let testing = _globals_.testing.wTools;
  let validPlatform = process.platform === 'linux' || process.platform === 'darwin';
  let validEnvironments = testing.test.workflowTriggerGet( a.abs( __dirname, '../../../..' ) ) !== 'pull_request' && token;
  let insideTestContainer = _.process.insideTestContainer();
  if( !validPlatform || !insideTestContainer || !validEnvironments )
  return test.true( true );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'single pull request, check sync';
    a.reflect();
    return null;
  });
  repositoryForm();
  branchMake( 'new' );
  pullRequestMake( 'master', 'new', 'new' )

  a.ready.then( () =>
  {
    var op = _.repo.pullList
    ({
      token,
      remotePath : repository,
    });

    test.identical( op.result.elements.length, 1 );
    var pr = op.result.elements[ 0 ];
    test.identical( pr.description.head, 'new' );
    test.identical( pr.description.body, '' );
    test.identical( pr.from.name, user );
    test.identical( pr.to.tag, 'master' );
    test.identical( pr.type, 'repo.pull' );
    return null;
  });
  a.ready.then( () => repositoryDelete( repository ) );

  /* */

  a.ready.then( () =>
  {
    test.case = 'several pull requests, check sync';
    a.reflect();
    return null;
  });
  repositoryForm();
  branchMake( 'new' );
  pullRequestMake( 'master', 'new', 'new' )
  a.shell( 'git checkout master' );
  branchMake( 'new2' );
  pullRequestMake( 'master', 'new2', 'new2' )

  a.ready.then( () =>
  {
    var op = _.repo.pullList
    ({
      token,
      remotePath : repository,
    });

    test.identical( op.result.elements.length, 2 );
    var pr = op.result.elements[ 0 ];
    test.identical( pr.description.head, 'new2' );
    test.identical( pr.description.body, '' );
    test.identical( pr.from.name, user );
    test.identical( pr.to.tag, 'master' );
    test.identical( pr.type, 'repo.pull' );
    var pr = op.result.elements[ 1 ];
    test.identical( pr.description.head, 'new' );
    test.identical( pr.description.body, '' );
    test.identical( pr.from.name, user );
    test.identical( pr.to.tag, 'master' );
    test.identical( pr.type, 'repo.pull' );
    return null;
  });
  a.ready.then( () => repositoryDelete( repository ) );

  /* */

  /* qqq : for Dmytro : uncomment when find reason of lock */
  // a.ready.then( () =>
  // {
  //   test.case = 'single pull request, check async';
  //   a.reflect();
  //   return null;
  // });
  // repositoryForm();
  // branchMake( 'new' );
  // pullRequestMake( 'master', 'new', 'new' )
  //
  // a.ready.then( () =>
  // {
  //   return _.repo.pullList
  //   ({
  //     token,
  //     remotePath : repository,
  //     sync : 0,
  //   });
  // });
  // a.ready.then( ( op ) =>
  // {
  //   test.identical( op.result.elements.length, 1 );
  //   var pr = op.result.elements[ 0 ];
  //   test.identical( pr.description.head, 'new' );
  //   test.identical( pr.description.body, '' );
  //   test.identical( pr.from.name, user );
  //   test.identical( pr.to.tag, 'master' );
  //   test.identical( pr.type, 'repo.pull' );
  //   return null;
  // });
  // a.ready.then( () => repositoryDelete( repository ) );
  //
  // /* */
  //
  // a.ready.then( () =>
  // {
  //   test.case = 'several pull requests, check async';
  //   a.reflect();
  //   return null;
  // });
  // repositoryForm();
  // branchMake( 'new' );
  // pullRequestMake( 'master', 'new', 'new' )
  // a.shell( 'git checkout master' );
  // branchMake( 'new2' );
  // pullRequestMake( 'master', 'new2', 'new2' )
  //
  // a.ready.then( () =>
  // {
  //   return _.repo.pullList
  //   ({
  //     token,
  //     remotePath : repository,
  //     sync : 0,
  //   });
  // });
  // a.ready.then( ( op ) =>
  // {
  //   test.identical( op.result.elements.length, 2 );
  //   var pr = op.result.elements[ 0 ];
  //   test.identical( pr.description.head, 'new2' );
  //   test.identical( pr.description.body, '' );
  //   test.identical( pr.from.name, user );
  //   test.identical( pr.to.tag, 'master' );
  //   test.identical( pr.type, 'repo.pull' );
  //   var pr = op.result.elements[ 1 ];
  //   test.identical( pr.description.head, 'new' );
  //   test.identical( pr.description.body, '' );
  //   test.identical( pr.from.name, user );
  //   test.identical( pr.to.tag, 'master' );
  //   test.identical( pr.type, 'repo.pull' );
  //   return null;
  // });
  // a.ready.then( () => repositoryDelete( repository ) );

  /* - */

  return a.ready;

  /* */

  function repositoryForm()
  {
    a.ready.then( () =>
    {
      return _.git.repositoryInit
      ({
        remotePath : repository,
        localPath : a.routinePath,
        throwing : 1,
        sync : 1,
        logger : 0,
        dry : 0,
        description : 'Test',
        token,
      })
    });

    a.shell( `git config credential.helper '!f(){ echo "username=${ user }" && echo "password=${ token }"; }; f'`);
    a.shell( 'git add --all' );
    a.shell( 'git commit -m first' );
    a.shell( 'git push -u origin master' );
    return a.ready;
  }

  /* */

  function pullRequestMake( dstBranch, srcBranch, name )
  {
    return a.ready.then( () =>
    {
      return _.repo.pullOpen
      ({
        token,
        remotePath : repository,
        descriptionHead : srcBranch,
        srcBranch,
        dstBranch,
      });
    });
  }

  /* */

  function repositoryDelete( remotePath )
  {
    return _.git.repositoryDelete
    ({
      remotePath,
      throwing : 1,
      sync : 1,
      logger : 1,
      dry : 0,
      token,
    });
  }

  /* */

  function branchMake( branch )
  {
    a.shell( `git checkout -b ${ branch }` );
    a.ready.then( () =>
    {
      a.fileProvider.fileAppend( a.abs( 'File.txt' ), 'new line\n' );
      return null;
    });
    a.shell( 'git commit -am second' );
    a.shell( `git push -u origin ${ branch }` );
    return a.ready;
  }
}

pullListRemote.timeOut = 200000;

//

function pullOpen( test )
{
  if( !Config.debug )
  {
    test.true( true );
    return;
  }

  test.case = 'wrong git service';
  test.shouldThrowErrorSync( () =>
  {
    _.git.pullOpen
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
    _.git.pullOpen
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
    _.git.pullOpen
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
    _.git.pullOpen
    ({
      remotePath : 'https://github.com/user/NewRepo',
      title : 'master',
      body : null,
      srcBranch : 'doc',
      dstBranch : 'master',
    });
  })
}

//

function pullOpenRemote( test )
{
  let a = test.assetFor( 'basic' );
  let user = 'wtools-bot';
  let repository = `https://github.com/${ user }/New-${ _.idWithDateAndTime() }`;
  let token = process.env.PRIVATE_WTOOLS_BOT_TOKEN;

  let testing = _globals_.testing.wTools;
  let validPlatform = process.platform === 'linux' || process.platform === 'darwin';
  let validEnvironments = testing.test.workflowTriggerGet( a.abs( __dirname, '../../../..' ) ) !== 'pull_request' && token;
  let insideTestContainer = _.process.insideTestContainer();
  if( !validPlatform || !insideTestContainer || !validEnvironments )
  return test.true( true );

  /* - */

  a.reflect();
  repositoryForm();

  /* */

  branchMake( 'new' ).then( () =>
  {
    test.case = 'opened pr only descriptionHead';
    return null;
  });
  a.ready.then( () =>
  {
    return _.repo.pullOpen
    ({
      token,
      remotePath : repository,
      descriptionHead : 'new',
      srcBranch : 'new',
      dstBranch : 'master',
    });
  })
  a.ready.then( ( op ) =>
  {
    test.identical( op.data.changed_files, 1 );
    test.identical( op.data.state, 'open' );
    test.identical( op.data.title, 'new' );
    test.identical( _.strCount( op.data.html_url, /https:\/\/github\.com\/.*\/New-.*\/pull\/\d/ ), 1 );
    return null;
  });

  /* */

  a.shell( 'git checkout master' );
  branchMake( 'new2' ).then( () =>
  {
    test.case = 'opened pr, sync : 0, srcBranch has user name';
    return null;
  });
  a.ready.then( () =>
  {
    return _.repo.pullOpen
    ({
      token,
      remotePath : repository,
      descriptionHead : 'new2',
      srcBranch : `${ user }:new2`,
      dstBranch : 'master',
      sync : 0,
    });
  })
  a.ready.then( ( op ) =>
  {
    test.identical( op.data.changed_files, 1 );
    test.identical( op.data.state, 'open' );
    test.identical( op.data.title, 'new2' );
    test.identical( _.strCount( op.data.html_url, /https:\/\/github\.com\/.*\/New-.*\/pull\/\d/ ), 1 );
    return null;
  });

  /* */

  a.shell( 'git checkout master' );
  branchMake( 'new3' ).then( () =>
  {
    test.case = 'opened pr with descriptionBody';
    return null;
  });
  a.ready.then( () =>
  {
    return _.repo.pullOpen
    ({
      token,
      remotePath : repository,
      descriptionHead : 'new3',
      descriptionBody : 'Some description',
      srcBranch : 'new3',
      dstBranch : 'master',
    });
  })
  a.ready.then( ( op ) =>
  {
    test.identical( op.data.body, 'Some description' );
    test.identical( op.data.changed_files, 1 );
    test.identical( op.data.state, 'open' );
    test.identical( op.data.title, 'new3' );
    test.identical( _.strCount( op.data.html_url, /https:\/\/github\.com\/.*\/New-.*\/pull\/\d/ ), 1 );
    return null;
  });

  /* */

  a.shell( 'git checkout master' );
  branchMake( 'new4' ).then( () =>
  {
    test.case = 'opened pr, dstBranch is not defined, should be master';
    return null;
  });
  a.shell( 'git checkout master' );
  a.ready.then( () =>
  {
    return _.repo.pullOpen
    ({
      token,
      remotePath : repository,
      descriptionHead : 'new4',
      descriptionBody : 'Some description',
      srcBranch : 'new4',
      localPath : a.routinePath,
    });
  })
  a.ready.then( ( op ) =>
  {
    test.identical( op.data.body, 'Some description' );
    test.identical( op.data.changed_files, 1 );
    test.identical( op.data.state, 'open' );
    test.identical( op.data.title, 'new4' );
    test.identical( _.strCount( op.data.html_url, /https:\/\/github\.com\/.*\/New-.*\/pull\/\d/ ), 1 );
    return null;
  });

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    repositoryDelete( repository );

    if( err )
    throw _.err( err, 'Repository should be deleted manually' );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function repositoryForm()
  {
    a.ready.Try( () =>
    {
      return repositoryDelete( repository );
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
        remotePath : repository,
        localPath : a.routinePath,
        throwing : 1,
        sync : 1,
        logger : 0,
        dry : 0,
        description : 'Test',
        token,
      })
    })

    a.shell
    (
      `git config credential.helper '!f(){ echo "username=${ user }" && echo "password=${ token }"; }; f'`
    );
    a.shell( 'git add --all' );
    a.shell( 'git commit -m first' );
    a.shell( 'git push -u origin master' );
    return a.ready;
  }

  /* */

  function repositoryDelete( remotePath )
  {
    return _.git.repositoryDelete
    ({
      remotePath,
      throwing : 1,
      sync : 1,
      logger : 1,
      dry : 0,
      token,
    });
  }

  /* */

  function branchMake( branch )
  {
    a.shell( `git checkout -b ${ branch }` );
    a.ready.then( () =>
    {
      a.fileProvider.fileAppend( a.abs( 'File.txt' ), 'new line\n' );
      return null;
    });
    a.shell( 'git commit -am second' );
    a.shell( `git push -u origin ${ branch }` );
    return a.ready;
  }
}

pullOpenRemote.timeOut = 60000;

//

function vcsFor( test )
{
  test.case = 'not known protocol';
  var vcs = _.repo.vcsFor( 'xxx:///' );
  test.identical( vcs, null );

  /* */

  test.case = 'git';
  var vcs = _.repo.vcsFor( 'git:///' );
  if( _.git )
  test.identical( vcs, _.git );
  else
  test.identical( vcs, null );

  test.case = 'git+https';
  var vcs = _.repo.vcsFor( 'git+https:///' );
  if( _.git )
  test.identical( vcs, _.git );
  else
  test.identical( vcs, null );

  test.case = 'git+ssh';
  var vcs = _.repo.vcsFor( 'git+ssh:///' );
  if( _.git )
  test.identical( vcs, _.git );
  else
  test.identical( vcs, null );

  test.case = 'git+hd';
  var vcs = _.repo.vcsFor( 'git+hd:///' );
  if( _.git )
  test.identical( vcs, _.git );
  else
  test.identical( vcs, null );

  test.case = 'git+file';
  var vcs = _.repo.vcsFor( 'git+file:///' );
  if( _.git )
  test.identical( vcs, _.git );
  else
  test.identical( vcs, null );

  test.case = 'git+bad - not valid protocol';
  var vcs = _.repo.vcsFor( 'git+bad:///' );
  test.identical( vcs, null );

  /* */

  test.case = 'npm';
  var vcs = _.repo.vcsFor( 'npm:///' );
  if( _.npm )
  test.identical( vcs, _.npm );
  else
  test.identical( vcs, null );

  test.case = 'npm+https';
  var vcs = _.repo.vcsFor( 'npm+https:///' );
  test.identical( vcs, null );

  /* */

  test.case = 'http';
  var vcs = _.repo.vcsFor( 'http:///' );
  if( _.npm )
  test.identical( vcs, _.http );
  else
  test.identical( vcs, null );

  test.case = 'http+npm';
  var vcs = _.repo.vcsFor( 'http+npm:///' );
  test.identical( vcs, null );

  test.case = 'https';
  var vcs = _.repo.vcsFor( 'https:///' );
  if( _.npm )
  test.identical( vcs, _.http );
  else
  test.identical( vcs, null );

  test.case = 'https+npm';
  var vcs = _.repo.vcsFor( 'https+npm:///' );
  test.identical( vcs, null );

  /* */

  test.case = 'special';
  var vcs = _.repo.vcsFor( [] );
  test.identical( vcs, null );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.repo.vcsFor() )

  test.case = 'wrong type of filePath';
  test.shouldThrowErrorSync( () => _.repo.vcsFor({ filePath : 1 }) )

  test.case = 'filePath is not empty array';
  test.shouldThrowErrorSync( () => _.repo.vcsFor({ filePath : [ 'git:///' ] }) )

  test.case = 'filePath is not a global path';
  test.shouldThrowErrorSync( () => _.repo.vcsFor({ filePath : '/' }) )
}

//

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
    providerForPath,

    pullListRemote,

    pullOpen,
    pullOpenRemote,

    vcsFor,
  },

};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
