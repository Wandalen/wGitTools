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
    vcsFor,

    pullOpen,
    pullOpenRemote,
  },

};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
