( function _GitTools_test_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'Tools' );

  _.include( 'wTesting' );

  require( '../git/entry/GitTools.ss' );;
}

//

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

// --
// context
// --

function onSuiteBegin( test )
{
  let context = this;
  context.provider = _.fileProvider;
  let path = context.provider.path;
  context.suiteTempPath = context.provider.path.tempOpen( path.join( __dirname, '../..' ), 'GitTools' );
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

function stateIsHash( test )
{
  test.case = 'not a string';
  var src = [ '#e862c54' ];
  var got = _.git.stateIsHash( src );
  test.identical( got, false );

  test.case = 'empty string - not a version';
  var src = '';
  var got = _.git.stateIsHash( src );
  test.identical( got, false );

  test.case = 'string - without #';
  var src = 'e862c54';
  var got = _.git.stateIsHash( src );
  test.identical( got, false );

  test.case = 'string - length of hash is less than 7';
  var src = '#e862c5';
  var got = _.git.stateIsHash( src );
  test.identical( got, false );

  test.case = 'string - length of hash is bigger than 40';
  var src = '#e862c547239662eb77989fd56ab0d56afa7d3ce6a';
  var got = _.git.stateIsHash( src );
  test.identical( got, false );

  test.case = 'string - # placed at the middle';
  var src = 'e862c54#c0';
  var got = _.git.stateIsHash( src );
  test.identical( got, false );

  test.case = 'string - is version, minimal length';
  var src = '#e862c54';
  var got = _.git.stateIsHash( src );
  test.identical( got, true );

  test.case = 'string - is version, maximal length';
  var src = '#e862c547239662eb77989fd56ab0d56afa7d3ce6';
  var got = _.git.stateIsHash( src );
  test.identical( got, true );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.git.stateIsHash() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.git.stateIsHash( '#e862c54', 'extra' ) );
}

//

function stateIsTag( test )
{
  test.case = 'not a string';
  var src = [ '!tag' ];
  var got = _.git.stateIsTag( src );
  test.identical( got, false );

  test.case = 'empty string';
  var src = '';
  var got = _.git.stateIsTag( src );
  test.identical( got, false );

  test.case = 'string without !';
  var src = 'tag';
  var got = _.git.stateIsTag( src );
  test.identical( got, false );

  test.case = 'string with ! at the middle';
  var src = 'ta!g';
  var got = _.git.stateIsTag( src );
  test.identical( got, false );

  test.case = 'string with only !, src.length === 1';
  var src = '!';
  var got = _.git.stateIsTag( src );
  test.identical( got, false );

  test.case = 'string - tag';
  var src = '!tag';
  var got = _.git.stateIsTag( src );
  test.identical( got, true );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.git.stateIsTag() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.git.stateIsTag( '!tag', 'extra' ) );
}

//

// function pathParse( test )
// {
//   var remotePath = 'git:///git@bitbucket.org:someorg/somerepo.git';
//   var expected =
//   {
//     'protocol' : 'git',
//     'tag' : 'master',
//     'longPath' : '/git@bitbucket.org:someorg/somerepo.git',
//     'localVcsPath' : './',
//     'remoteVcsPath' : 'git@bitbucket.org:someorg/somerepo.git',
//     'remoteVcsLongerPath' : 'git@bitbucket.org:someorg/somerepo.git',
//     'isFixated' : false
//   }
//   var got = _.git.pathParse( remotePath );
//   test.identical( got, expected )
//
//   var remotePath = 'git:///git@bitbucket.org:someorg/somerepo.git/#master';
//   var expected =
//   {
//     'protocol' : 'git',
//     'hash' : 'master',
//     'longPath' : '/git@bitbucket.org:someorg/somerepo.git/',
//     'localVcsPath' : './',
//     'remoteVcsPath' : 'git@bitbucket.org:someorg/somerepo.git',
//     'remoteVcsLongerPath' : 'git@bitbucket.org:someorg/somerepo.git',
//     'isFixated' : false
//   }
//   var got = _.git.pathParse( remotePath );
//   test.identical( got, expected )
//
//   var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/#041839a730fa104a7b6c7e4935b4751ad81b00e0';
//   var expected =
//   {
//     'protocol' : 'git+https',
//     'hash' : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
//     'longPath' : '/github.com/Wandalen/wModuleForTesting1.git/',
//     'localVcsPath' : './',
//     'remoteVcsPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
//     'remoteVcsLongerPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
//     'isFixated' : true
//   }
//   var got = _.git.pathParse( remotePath );
//   test.identical( got, expected )
//
//   var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!0.0.37'
//   var expected =
//   {
//     'protocol' : 'git+https',
//     'tag' : '0.0.37',
//     'longPath' : '/github.com/Wandalen/wModuleForTesting1.git/',
//     'localVcsPath' : './',
//     'remoteVcsPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
//     'remoteVcsLongerPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
//     'isFixated' : false
//   }
//   var got = _.git.pathParse( remotePath );
//   test.identical( got, expected )
//
//   var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master'
//   var expected =
//   {
//     'protocol' : 'git+https',
//     'tag' : 'master',
//     'longPath' : '/github.com/Wandalen/wModuleForTesting1.git/',
//     'localVcsPath' : './',
//     'remoteVcsPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
//     'remoteVcsLongerPath' : 'https://github.com/Wandalen/wModuleForTesting1.git',
//     'isFixated' : false
//   }
//   var got = _.git.pathParse( remotePath );
//   test.identical( got, expected )
//
//   var remotePath = 'git+hd://Tools?out=out/wTools.out.will!master'
//   var expected =
//   {
//     'protocol' : 'git+hd',
//     'query' : 'out=out/wTools.out.will',
//     'tag' : 'master',
//     'longPath' : 'Tools',
//     'localVcsPath' : 'out/wTools.out.will',
//     'remoteVcsPath' : 'Tools',
//     'remoteVcsLongerPath' : 'Tools',
//     'isFixated' : false
//   }
//   var got = _.git.pathParse( remotePath );
//   test.identical( got, expected )
//
//   var remotePath = 'git+hd://Tools?out=out/wTools.out.will!v0.8.505'
//   var expected =
//   {
//     'protocol' : 'git+hd',
//     'query' : 'out=out/wTools.out.will',
//     'tag' : 'v0.8.505',
//     'longPath' : 'Tools',
//     'localVcsPath' : 'out/wTools.out.will',
//     'remoteVcsPath' : 'Tools',
//     'remoteVcsLongerPath' : 'Tools',
//     'isFixated' : false
//   }
//   var got = _.git.pathParse( remotePath );
//   test.identical( got, expected )
//
//   var remotePath = 'git+hd://Tools?out=out/wTools.out.will/!v0.8.505'
//   var expected =
//   {
//     'protocol' : 'git+hd',
//     'query' : 'out=out/wTools.out.will/',
//     'tag' : 'v0.8.505',
//     'longPath' : 'Tools',
//     'localVcsPath' : 'out/wTools.out.will/',
//     'remoteVcsPath' : 'Tools',
//     'remoteVcsLongerPath' : 'Tools',
//     'isFixated' : false
//   }
//   var got = _.git.pathParse( remotePath );
//   test.identical( got, expected )
//
//   var remotePath = 'git+hd://Tools?out=out/wTools.out.will#8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3'
//   var expected =
//   {
//     'protocol' : 'git+hd',
//     'query' : 'out=out/wTools.out.will',
//     'hash' : '8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3',
//     'longPath' : 'Tools',
//     'localVcsPath' : 'out/wTools.out.will',
//     'remoteVcsPath' : 'Tools',
//     'remoteVcsLongerPath' : 'Tools',
//     'isFixated' : true
//   }
//   var got = _.git.pathParse( remotePath );
//   test.identical( got, expected )
//
//   var remotePath = 'git+hd://Tools?out=out/wTools.out.will/#8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3'
//   var expected =
//   {
//     'protocol' : 'git+hd',
//     'query' : 'out=out/wTools.out.will/',
//     'hash' : '8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3',
//     'longPath' : 'Tools',
//     'localVcsPath' : 'out/wTools.out.will/',
//     'remoteVcsPath' : 'Tools',
//     'remoteVcsLongerPath' : 'Tools',
//     'isFixated' : true
//   }
//   var got = _.git.pathParse( remotePath );
//   test.identical( got, expected )
//
//   test.case = 'both hash and tag'
//   var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/#8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3!master';
//   test.shouldThrowErrorSync( () => _.git.pathParse( remotePath ) );
// }

//

function remotePathFromLocal( test )
{
  let a = test.assetFor( 'basic' );

  let repoPath = a.abs( 'repo' );
  let clonePath = a.abs( 'clone' );

  /* - */

  begin({ local : 1 })
  .then( () =>
  {
    let got = _.git.remotePathFromLocal({ localPath : clonePath });
    let expected = `git+hd://${a.path.normalize( repoPath )}`
    test.identical( got, expected );
    return null;
  })

  /* */

  begin({ remote : 1 })
  .then( () =>
  {
    let got = _.git.remotePathFromLocal({ localPath : clonePath });
    let expected = `git+https:///github.com/Wandalen/wModuleForTesting1.git`
    test.identical( got, expected );
    return null;
  })

  /* */

  begin({ local : 1, url : 'git@github.com:Wandalen/wModuleForTesting1.git' })
  .then( () =>
  {
    let got = _.git.remotePathFromLocal({ localPath : clonePath });
    let expected = `git:///git@github.com:Wandalen/wModuleForTesting1.git`
    test.identical( got, expected );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin( o )
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.reflect();
      return null;
    });

    _.assert( !!o.local || !!o.remote );
    _.assert( !o.local || !o.remote );

    if( o.local )
    {
      a.shell( 'git init repo' );
      a.shell( 'git -C repo commit --allow-empty -m initial' );
      a.shell( 'git clone repo clone' );
    }
    else if( o.remote )
    {
      a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git clone' );
    }

    if( o.url )
    {
      a.shell( 'git -C clone remote remove origin' );
      a.shell( 'git -C clone remote add origin ' + o.url );
    }

    return a.ready;
  }
}

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
  var insidePath = a.abs( __dirname, process.platform === 'win32' ? '/c' : '/' );
  var got = _.git.insideRepository({ insidePath })
  test.identical( got, false )
}

//

function tagLocalChange( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  a.ready.then( () =>
  {
    test.case = 'not a repository';
    a.fileProvider.dirMake( a.abs( '.' ) );
    a.fileProvider.fileWrite( a.abs( 'file.txt' ), 'file.txt' );
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.tagLocalChange
    ({
      localPath : a.abs( '.' ),
      tag : 'master',
    });

    test.identical( got, false );
    return null;
  });

  /* - */

  a.ready.then( () =>
  {
    test.open( 'without local changes' );
    return null;
  });

  begin().then( () =>
  {
    test.case = 'repository, no branches excluding master, switch to master';
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.tagLocalChange
    ({
      localPath : a.abs( '.' ),
      tag : 'master',
    });

    test.identical( got, true );
    return null;
  });
  a.shell( 'git branch' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, '* master' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'repository, several branches, switch to second branch';
    return null;
  });

  a.shell( 'git branch second' );

  a.ready.then( () =>
  {
    var got = _.git.tagLocalChange
    ({
      localPath : a.abs( '.' ),
      tag : 'second',
    });

    test.identical( got, true );
    return null;
  });
  a.shell( 'git branch' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'master' ), 1 );
    test.identical( _.strCount( op.output, '* second' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'repository, several branches, switch to second branch and switch back to master';
    return null;
  });

  a.shell( 'git branch second' );

  a.ready.then( () =>
  {
    var got = _.git.tagLocalChange
    ({
      localPath : a.abs( '.' ),
      tag : 'second',
    });

    test.identical( got, true );
    return null;
  });
  a.shell( 'git branch' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'master' ), 1 );
    test.identical( _.strCount( op.output, '* second' ), 1 );
    return null;
  });
  a.ready.then( () =>
  {
    var got = _.git.tagLocalChange
    ({
      localPath : a.abs( '.' ),
      tag : 'master',
    });

    test.identical( got, true );
    return null;
  });
  a.shell( 'git branch' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, '* master' ), 1 );
    test.identical( _.strCount( op.output, 'second' ), 1 );
    return null;
  });

  a.ready.then( () =>
  {
    test.close( 'without local changes' );
    return null;
  });

  /* - */

  a.ready.then( () =>
  {
    test.open( 'with local changes' );
    return null;
  });

  begin().then( () =>
  {
    test.case = 'repository, several branches, switch to second branch';
    a.fileProvider.fileAppend( a.abs( 'file.txt' ), 'new data' );
    return null;
  });

  a.shell( 'git branch second' );
  a.shell( 'git status' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'On branch master' ), 1 );
    test.identical( _.strCount( op.output, 'Changes not staged for commit:' ), 1 );
    test.identical( _.strCount( op.output, 'modified:   file.txt' ), 1 );
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.tagLocalChange
    ({
      localPath : a.abs( '.' ),
      tag : 'second',
    });

    test.identical( got, true );
    return null;
  });
  a.shell( 'git branch' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'master' ), 1 );
    test.identical( _.strCount( op.output, '* second' ), 1 );
    return null;
  });

  a.shell( 'git status' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'On branch second' ), 1 );
    test.identical( _.strCount( op.output, 'Changes not staged for commit:' ), 1 );
    test.identical( _.strCount( op.output, 'modified:   file.txt' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'repository, several branches, switch to second branch and switch back';
    a.fileProvider.fileAppend( a.abs( 'file.txt' ), 'new data' );
    return null;
  });

  a.shell( 'git branch second' );
  a.shell( 'git status' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'On branch master' ), 1 );
    test.identical( _.strCount( op.output, 'Changes not staged for commit:' ), 1 );
    test.identical( _.strCount( op.output, 'modified:   file.txt' ), 1 );
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.tagLocalChange
    ({
      localPath : a.abs( '.' ),
      tag : 'second',
    });

    test.identical( got, true );
    return null;
  });
  a.shell( 'git branch' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'master' ), 1 );
    test.identical( _.strCount( op.output, '* second' ), 1 );
    return null;
  });

  a.shell( 'git status' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'On branch second' ), 1 );
    test.identical( _.strCount( op.output, 'Changes not staged for commit:' ), 1 );
    test.identical( _.strCount( op.output, 'modified:   file.txt' ), 1 );
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.tagLocalChange
    ({
      localPath : a.abs( '.' ),
      tag : 'master',
    });

    test.identical( got, true );
    return null;
  });
  a.shell( 'git branch' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, '* master' ), 1 );
    test.identical( _.strCount( op.output, 'second' ), 1 );
    return null;
  });
  a.shell( 'git status' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'On branch master' ), 1 );
    test.identical( _.strCount( op.output, 'Changes not staged for commit:' ), 1 );
    test.identical( _.strCount( op.output, 'modified:   file.txt' ), 1 );
    return null;
  });

  a.ready.then( () =>
  {
    test.close( 'with local changes' );
    return null;
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'repository, no branches excluding master, switch to initial commit using tag';
    _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      sync : 1,
      tag : 'v0.0.0',
      description : 'v0.0.0',
    });
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'file.txt' ), 'new data' );
    return null;
  });

  a.shell( 'git commit -am second' );

  a.ready.then( () =>
  {
    var got = _.git.tagLocalChange
    ({
      localPath : a.abs( '.' ),
      tag : 'v0.0.0',
    });

    test.identical( got, true );
    return null;
  });
  a.shell( 'git branch' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, '(HEAD detached at v0.0.0)' ), 1 );
    test.identical( _.strCount( op.output, 'master' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'repository, no branches excluding master, switch to initial commit using tag and switch back';
    _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      sync : 1,
      tag : 'v0.0.0',
      description : 'v0.0.0',
    });
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'file.txt' ), 'new data' );
    return null;
  });

  a.shell( 'git commit -am second' );

  a.ready.then( () =>
  {
    _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      sync : 1,
      tag : 'v0.0.1',
      description : 'v0.0.1',
    });
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.tagLocalChange
    ({
      localPath : a.abs( '.' ),
      tag : 'v0.0.0',
    });

    test.identical( got, true );
    return null;
  });
  a.shell( 'git branch' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, '(HEAD detached at v0.0.0)' ), 1 );
    test.identical( _.strCount( op.output, 'master' ), 1 );
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.tagLocalChange
    ({
      localPath : a.abs( '.' ),
      tag : 'v0.0.1',
    });

    test.identical( got, true );
    return null;
  });
  a.shell( 'git branch' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, '(HEAD detached at v0.0.1)' ), 1 );
    test.identical( _.strCount( op.output, 'master' ), 1 );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'empty repository, no branches excluding master, switch to not existed branch';
      return null;
    });

    a.ready.then( () =>
    {
      test.shouldThrowErrorSync( () =>
      {
        return _.git.tagLocalChange
        ({
          localPath : a.abs( '.' ),
          tag : 'not_existed',
        });
      });
      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( '.' ) ) );
    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( '.' ) );
      return null;
    });
    a.shell( `git init` );
    a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( 'file.txt' ), 'file.txt' );
      return null;
    });
    a.shell( 'git add .' );
    a.shell( 'git commit -m init' );
    return a.ready;
  }
}

tagLocalChange.timeOut = 40000;

//

function tagLocalRetrive( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  a.ready.then( () =>
  {
    test.case = 'not a repository';
    a.fileProvider.dirMake( a.abs( '.' ) );
    a.fileProvider.fileWrite( a.abs( 'file.txt' ), 'file.txt' );
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.tagLocalRetrive
    ({
      localPath : a.abs( '.' ),
    });

    test.identical( got, false );
    return null;
  });

  /* - */

  a.ready.then( () =>
  {
    test.open( 'default options' );
    return null;
  });

  begin().then( () =>
  {
    test.case = 'repository, on branch master';
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.tagLocalRetrive
    ({
      localPath : a.abs( '.' ),
    });

    test.identical( got, 'master' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'repository, on another branch';
    return null;
  });

  a.shell( 'git checkout -b second' );

  a.ready.then( () =>
  {
    var got = _.git.tagLocalRetrive
    ({
      localPath : a.abs( '.' ),
    });

    test.identical( got, 'second' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'repository, in detached mode, detached to tag';
    _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      sync : 1,
      tag : 'v0.0.0',
      description : 'v0.0.0',
    });
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'file.txt' ), 'new data' );
    return null;
  });

  a.shell( 'git commit -am second' );
  a.shell( 'git checkout v0.0.0' );

  a.ready.then( () =>
  {
    var got = _.git.tagLocalRetrive
    ({
      localPath : a.abs( '.' ),
    });

    test.identical( got, 'v0.0.0' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'repository, in detached mode, detached to commit';
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'file.txt' ), 'new data' );
    return null;
  });

  a.shell( 'git commit -am second' );
  a.shell( 'git checkout HEAD~' );

  a.ready.then( () =>
  {
    var got = _.git.tagLocalRetrive
    ({
      localPath : a.abs( '.' ),
    });

    test.identical( got, '' );
    return null;
  });

  a.ready.then( () =>
  {
    test.close( 'default options' );
    return null;
  });

  /* - */
  /* - */

  a.ready.then( () =>
  {
    test.open( 'option detailing enabled' );
    return null;
  });

  begin().then( () =>
  {
    test.case = 'repository, on branch master';
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.tagLocalRetrive
    ({
      localPath : a.abs( '.' ),
      detailing : 1,
    });

    var exp =
    {
      tag : 'master',
      isTag : false,
      isBranch : true,
    };
    test.identical( got, exp );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'repository, on another branch';
    return null;
  });

  a.shell( 'git checkout -b second' );

  a.ready.then( () =>
  {
    var got = _.git.tagLocalRetrive
    ({
      localPath : a.abs( '.' ),
      detailing : 1,
    });

    var exp =
    {
      tag : 'second',
      isTag : false,
      isBranch : true,
    };
    test.identical( got, exp );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'repository, in detached mode, detached to tag';
    _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      sync : 1,
      tag : 'v0.0.0',
      description : 'v0.0.0',
    });
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'file.txt' ), 'new data' );
    return null;
  });

  a.shell( 'git commit -am second' );
  a.shell( 'git checkout v0.0.0' );

  a.ready.then( () =>
  {
    var got = _.git.tagLocalRetrive
    ({
      localPath : a.abs( '.' ),
      detailing : 1,
    });

    var exp =
    {
      tag : 'v0.0.0',
      isTag : true,
      isBranch : false,
    };
    test.identical( got, exp );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'repository, in detached mode, detached to commit';
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'file.txt' ), 'new data' );
    return null;
  });

  a.shell( 'git commit -am second' );
  a.shell( 'git checkout HEAD~' );

  a.ready.then( () =>
  {
    var got = _.git.tagLocalRetrive
    ({
      localPath : a.abs( '.' ),
      detailing : 1,
    });

    var exp =
    {
      tag : '',
      isTag : false,
      isBranch : false,
    };
    test.identical( got, exp );
    return null;
  });

  a.ready.then( () =>
  {
    test.close( 'option detailing enabled' );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.tagLocalRetrive() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () => _.git.tagLocalRetrive( { localPath : a.abs( '.' ) }, {} ) );

      test.case = 'wrong type of localPath';
      test.shouldThrowErrorSync( () => _.git.tagLocalRetrive({ localPath : 1 }) );

      test.case = 'unknown option in options map o';
      test.shouldThrowErrorSync( () => _.git.tagLocalRetrive({ localPath : 1, unknown : 1 }) );

      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( '.' ) ) );
    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( '.' ) );
      return null;
    });
    a.shell( `git init` );
    a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( 'file.txt' ), 'file.txt' );
      return null;
    });
    a.shell( 'git add .' );
    a.shell( 'git commit -m init' );
    return a.ready;
  }
}

tagLocalRetrive.timeOut = 20000;

//

function tagExplain( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  let repoPath = a.abs( 'repo' );
  let clonePath = a.abs( 'clone' );

  a.shellSync = _.process.starter
  ({
    currentPath : a.abs( '.' ),
    ready : null,
    sync : 1,
    deasync : 1,
    outputPiping : 1,
    stdio : 'pipe'
  })

  a.init = () =>
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.reflect();
      a.shellSync( 'git init repo' )
      a.shellSync( 'git -C repo commit --allow-empty -m initial' )
      a.shellSync( 'git -C repo tag tag1' )
      a.shellSync( 'git clone repo clone' )
      a.shellSync( 'git -C repo tag remoteTag' )
      a.shellSync( 'git -C clone tag localTag' )
      return null;
    })
    return a.ready;
  }

  a.init()
  .then( () =>
  {
    var remotePath = `git+hd://${repoPath}`;

    test.case = 'tag is branch'
    var got = _.git.tagExplain({ localPath : clonePath, remotePath, tag : 'master' });
    test.identical( got.tag, 'master' )
    test.identical( got.isBranch, true )
    test.identical( got.isTag, false )

    test.case = 'tag is real tag'
    var got = _.git.tagExplain({ localPath : clonePath, remotePath, tag : 'tag1' });
    test.identical( got.tag, 'tag1' )
    test.identical( got.isBranch, false )
    test.identical( got.isTag, true )

    test.case = 'tag is only present on remote'
    var got = _.git.tagExplain({ localPath : clonePath, remotePath, tag : 'remoteTag' });
    test.identical( got.tag, 'remoteTag' )
    test.identical( got.isBranch, false )
    test.identical( got.isTag, true )

    test.case = 'tag is only present locally'
    var got = _.git.tagExplain({ localPath : clonePath, remotePath, tag : 'localTag' });
    test.identical( got.tag, 'localTag' )
    test.identical( got.isBranch, false )
    test.identical( got.isTag, true )

    test.case = 'unknown tag'
    var got = _.git.tagExplain({ localPath : clonePath, remotePath, tag : 'missing' });
    test.identical( got, false );

    /* */

    test.case = 'localPath - path to repository, remotePath - is not repository'
    var remotePath = `git+hd://${repoPath}/out/`;
    var got = _.git.tagExplain({ localPath : clonePath, remotePath, tag : 'master' });
    test.identical( got.tag, 'master' )
    test.identical( got.isBranch, true )
    test.identical( got.isTag, false )

    return null;
  })

  return a.ready;

}
tagExplain.timeOut = 30000;

//

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

function versionIsCommitHash( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  begin().then( () =>
  {
    test.description = 'full hash length, commit exists in repo';
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
      sync : 1
    });
    test.identical( got, true );

    test.description = 'less then full hash length, commit exists in repo';
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a730fa104a7b6c7',
      sync : 1
    });
    test.identical( got, true );

    test.description = 'minimal hash length, commit exists in repo';
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a',
      sync : 1
    });
    test.identical( got, true );

    test.description = 'hash length less than 7, commit exists in repo';
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '04183',
      sync : 1
    });
    test.identical( got, true );

    /* */

    test.description = 'full hash length, commit does not exist in repo';
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'd290dbaa22ea0f13a75d5b9ba19d5b061c6ba8bf',
      sync : 1
    });
    test.identical( got, true );

    test.description = 'minimal hash length, commit does not exist in repo';
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'd290dba',
      sync : 1
    });
    test.identical( got, false );

    test.description = 'version length less than 7, commit hash does not exist in repo';
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'd290db',
      sync : 1
    });
    test.identical( got, false );

    test.case = 'branch name, not a hash';
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'master',
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag, not a hash';
    var got = _.git.versionIsCommitHash
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '0.7.50',
      sync : 1
    });
    test.identical( got, false );

    /* - */

    if( !Config.debug )
    return null;

    test.case = 'wrong o.localPath';
    test.shouldThrowErrorSync( () =>
    {
      _.git.versionIsCommitHash
      ({
        localPath : null,
        version : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
        sync : 1
      });
    });

    test.case = 'wrong o.version';
    test.shouldThrowErrorSync( () =>
    {
      _.git.versionIsCommitHash
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        version : null,
        sync : 1
      });
    });

    test.description = 'repository at o.localPath does not exist'
    _.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) )
    test.shouldThrowErrorSync( () =>
    {
      _.git.versionIsCommitHash
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        version : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
        sync : 1
      });
    });

    return null;
  });

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( '.' ) )
      a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
      return null;
    });
    a.shell( `git clone https://github.com/Wandalen/wModuleForTesting1.git` );
    return a.ready;
  }
}

versionIsCommitHash.timeOut = 60000;

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
    // test.identical( got.runs.length, 1 );
    // _.each( got.runs, ( result ) =>
    test.identical( got.sessions.length, 1 );
    _.each( got.sessions, ( result ) =>
    {
      test.identical( result.exitCode, 0 );
      test.true( _.strHasAny( result.output, [ 'is up to date', 'is up-to-date' ] ) );
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
    // test.identical( got.runs.length, 2 );
    // _.each( got.runs, ( result ) =>
    test.identical( got.sessions.length, 2 );
    _.each( got.sessions, ( result ) =>
    {
      test.identical( result.exitCode, 0 );
      test.true( _.strHasAny( result.output, [ 'is up to date', 'is up-to-date' ] ) );
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
    // test.identical( got.runs.length, 2 );
    // _.each( got.runs, ( result ) =>
    test.identical( got.sessions.length, 2 );
    _.each( got.sessions, ( result ) =>
    {
      test.identical( result.exitCode, 0 );
      test.true( _.strHasAny( result.output, [ 'is up to date', 'is up-to-date' ] ) );
    })
    return null;
  })

  return a.ready;
}

versionsPull.routineTimeOut = 60000;

//

function isUpToDate( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  begin().then( () =>
  {
    test.case = 'remote master, local on branch master';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    });
  });

  a.ready.then( () =>
  {
    test.case = 'remote has fixated version, local on branch master';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#041839a730fa104a7b6c7e4935b4751ad81b00e0';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    });
  });

  /* */

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout 041839a730fa104a7b6c7e4935b4751ad81b00e0' })

  a.ready.then( () =>
  {
    test.case = 'remote has same fixed version, local is detached';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#041839a730fa104a7b6c7e4935b4751ad81b00e0';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    });
  });

  a.ready.then( () =>
  {
    test.case = 'remote has other fixated version, local is detached';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#d70162fc9d06783ec24f622424a35dbda64fe956';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    });
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'local repository resetted to previous commit';
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
    });
  });

  begin().then( () =>
  {
    test.case = 'local repository has new commit';
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
    });
  });

  begin().then( () =>
  {
    test.case = 'local repository update latest commit';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';

    let ready = new _.Consequence().take( null );

    _.process.start
    ({
      execPath : 'git reset --hard HEAD~1',
      currentPath : a.abs( 'wModuleForTesting1' ),
      ready
    });

    _.process.start
    ({
      execPath : 'git commit --allow-empty -m emptycommit',
      currentPath : a.abs( 'wModuleForTesting1' ),
      ready
    });

    ready
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    });

    return ready;
  });

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout 34f17134e3c1fc49ef4b9fa3ec60da8851922588' })

  a.ready.then( () =>
  {
    test.case = 'local repository has new commit, local is detached';
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
    });
  });

  /* */

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout -b newbranch' });

  a.ready.then( () =>
  {
    test.case = 'local is on new branch, chech with no identical remote branch';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    });
  });

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout -b newbranch' });

  a.ready.then( () =>
  {
    test.case = 'local is on new branch, chech with identical remote branch';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!newbranch';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    });
  });

  /* - */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'remote has different branch that does not exist';
      let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git!other';
      var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath });
      return test.shouldThrowErrorAsync( con );
    });

    a.ready.then( () =>
    {
      test.case = 'branch name as hash';
      let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#other';
      var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath });
      return test.shouldThrowErrorAsync( con );
    });

    a.ready.then( () =>
    {
      test.case = 'hash as tag';
      let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git!d70162fc9d06783ec24f622424a35dbda64fe956';
      var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath });
      return test.shouldThrowErrorAsync( con );
    })

    a.ready.then( () =>
    {
      test.case = 'hash and tag';
      let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#d70162fc9d06783ec24f622424a35dbda64fe956!master';
      test.shouldThrowErrorSync( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';
      a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
      a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
      return null;
    });
    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( '.' ) );
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        attemptLimit : 4,
        attemptDelay : 250,
        attemptDelayMultiplier : 4,
      });
    });
    return a.ready;
  }
}

isUpToDate.timeOut = 120000;

//

function isUpToDateRemotePathIsMap( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  begin().then( () =>
  {
    test.case = 'remote master, local on branch master';
    let remotePath = _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git' );
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    });
  });

  a.ready.then( () =>
  {
    test.case = 'remote has fixated version, local on branch master';
    let remotePath = _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git#041839a730fa104a7b6c7e4935b4751ad81b00e0' );
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    });
  });

  /* */

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout 041839a730fa104a7b6c7e4935b4751ad81b00e0' })

  a.ready.then( () =>
  {
    test.case = 'remote has same fixed version, local is detached';
    let remotePath = _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git#041839a730fa104a7b6c7e4935b4751ad81b00e0' );
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    });
  });

  a.ready.then( () =>
  {
    test.case = 'remote has other fixated version, local is detached';
    let remotePath = _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git#d70162fc9d06783ec24f622424a35dbda64fe956' );
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    });
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'local repository resetted to previous commit';
    let remotePath = _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git' );

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
    });
  });

  begin().then( () =>
  {
    test.case = 'local repository has new commit';
    let remotePath = _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git' );

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
    });
  });

  begin().then( () =>
  {
    test.case = 'local repository update latest commit';
    let remotePath = _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git' );

    let ready = new _.Consequence().take( null );

    _.process.start
    ({
      execPath : 'git reset --hard HEAD~1',
      currentPath : a.abs( 'wModuleForTesting1' ),
      ready
    });

    _.process.start
    ({
      execPath : 'git commit --allow-empty -m emptycommit',
      currentPath : a.abs( 'wModuleForTesting1' ),
      ready
    });

    ready
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    });

    return ready;
  });

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout 34f17134e3c1fc49ef4b9fa3ec60da8851922588' })

  a.ready.then( () =>
  {
    test.case = 'local repository has new commit, local is detached';
    let remotePath = _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git' );

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
    });
  });

  /* */

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout -b newbranch' });

  a.ready.then( () =>
  {
    test.case = 'local is on new branch, chech with no identical remote branch';
    let remotePath = _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master' );
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    });
  });

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout -b newbranch' });

  a.ready.then( () =>
  {
    test.case = 'local is on new branch, chech with identical remote branch';
    let remotePath = _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!newbranch' );
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    });
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      let remotePath = _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git' );
      a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
      a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
      return null;
    });
    a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git wModuleForTesting1' );
    return a.ready;
  }
}

isUpToDateRemotePathIsMap.timeOut = 120000;

//

function isUpToDateExtended( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  begin().then( () =>
  {
    test.case = 'both on master, no changes';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    });
  })

  /* */

  a.shell( 'git -C wModuleForTesting1 reset --hard HEAD~1' )
  .then( () =>
  {
    test.case = 'both on master, local one commit behind';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  // begin() /* aaa2 : ? */ /* Dmytro : the routine prepare repo to test, the previous case change repository hard */

  /* */

  begin().then( () =>
  {
    test.case = 'local on master, remote on other branch that does not exist';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!other';
    var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    return test.shouldThrowErrorAsync( con )
  })

  /* */

  a.shell( 'git -C wModuleForTesting1 checkout -b newbranch' );
  a.ready.then( () =>
  {
    test.case = 'local on newbranch, remote on master';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master';

    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
    .finally( ( err, got ) =>
    {
      if( err )
      test.exceptionReport({ err });
      return null;
    })
  })
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout master' });

  /* */

  a.ready.then( () =>
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

  /* */
  a.shell( 'git -C wModuleForTesting1 checkout v0.0.70' );
  a.ready.then( () =>
  {
    test.case = 'local on same tag with remote';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!v0.0.70';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  /* */

  a.shell( 'git -C wModuleForTesting1 checkout v0.0.71' );
  a.ready.then( () =>
  {
    test.case = 'local on different tag with remote';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!v0.0.70';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  /* */

  a.shell( 'git -C wModuleForTesting1 checkout 9a711ca350777586043fbb32cc33ccea267218af' );
  a.ready.then( () =>
  {
    test.case = 'local on same commit as tag on remote';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!v0.0.70';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  /* */

  a.shell( 'git -C wModuleForTesting1 checkout fbfcc8e897be2b7df49dc60b9a35818af195e916' );
  a.ready.then( () =>
  {
    test.case = 'local on different commit as tag on remote';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!v0.0.70';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  /* */

  a.shell( 'git -C wModuleForTesting1 checkout v0.0.71' );
  a.ready.then( () =>
  {
    test.case = 'local on tag, remote on master';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  /* */

  a.shell( 'git -C wModuleForTesting1 checkout v0.0.70' );
  a.ready.then( () =>
  {
    test.case = 'local on tag, remote on hash that local tag is pointing to';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/#9a711ca350777586043fbb32cc33ccea267218af';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, true );
      return got;
    })
  })

  /* */

  a.shell( 'git -C wModuleForTesting1 checkout v0.0.70' );
  a.ready.then( () =>
  {
    test.case = 'local on tag, remote on different hash';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/#fbfcc8e897be2b7df49dc60b9a35818af195e916';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  /* */

  begin();
  a.shell( 'git -C wModuleForTesting1 checkout master' );
  a.ready.then( () =>
  {
    test.case = 'local on master, remote is different';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting12.git/';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  a.shell( 'git -C wModuleForTesting1 checkout v0.0.70' );
  a.ready.then( () =>
  {
    test.case = 'local on tag, remote is different';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting12.git/';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  a.shell( 'git -C wModuleForTesting1 checkout 9a711ca350777586043fbb32cc33ccea267218af' );
  a.ready.then( () =>
  {
    test.case = 'local detached, remote is different';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting12.git/';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  /* */

  begin().then( () =>
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

  /* */

  begin();
  a.shell( 'git -C wModuleForTesting1 remote remove origin' );
  a.ready.then( () =>
  {
    test.case = 'local does not have origin';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath })
    .then( ( got ) =>
    {
      test.identical( got, false );
      return got;
    })
  })

  /* */

  a.ready.then( () =>
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

  /* */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
      a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
      return null;
    });
    a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git wModuleForTesting1' );
    return a.ready;
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

  con.then( () =>
  {
    test.case = 'setup';
    a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
    a.fileProvider.dirMake( a.abs( 'wModuleForTesting1' ) );
    return a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git ' + 'wModuleForTesting1' )
  });

  con.then( () =>
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

isUpToDateThrowing.timeOut = 60000;

//

function isUpToDateMissingTag( test )
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
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master2';
    return test.shouldThrowErrorAsync
    (
      _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath }),
      ( err ) =>
      {
        let exp = `doesn't exist in local and remote copy of the repository`;
        test.true( _.strHas( err.originalMessage, exp ) );
      }
    )
  })

  return con;
}

isUpToDateMissingTag.rapidity = 1;
isUpToDateMissingTag.routineTimeOut = 150000;
isUpToDateMissingTag.description =
`
Tag that is specified in the remotePath is not present.
The routine isUpToDate should throw error with message about it.
`

//

function isUptoDateDifferentiatingTags( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  let repoPath = a.abs( 'repo' );
  let clonePath = a.abs( 'clone' );

  a.shellSync = _.process.starter
  ({
    currentPath : a.abs( '.' ),
    ready : null,
    sync : 1,
    deasync : 1,
    outputPiping : 1,
    stdio : 'pipe'
  })

  a.init = () =>
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.reflect();
      a.shellSync( 'git init repo' )
      a.shellSync( 'git -C repo commit --allow-empty -m initial' )
      a.shellSync( 'git -C repo tag tag1' )
      a.shellSync( 'git clone repo clone' )
      return null;
    })
    return a.ready;
  }

  a.init()
  .then( () =>
  {
    test.case = 'local repo head is on same commit as tag differentiatingTags:0'
    let remotePath = `git+hd://${repoPath}/!tag1`;
    return _.Consequence.From( _.git.isUpToDate({ localPath : clonePath, remotePath, differentiatingTags : 0 }) )
    .then( ( got ) =>
    {
      test.identical( got, true );
      return null;
    })
  })
  .then( () =>
  {
    test.case = 'local repo head is on same commit as tag differentiatingTags:1'
    let remotePath = `git+hd://${repoPath}/!tag1`;
    return _.Consequence.From( _.git.isUpToDate({ localPath : clonePath, remotePath, differentiatingTags : 1 }) )
    .then( ( got ) =>
    {
      test.identical( got, false );
      return null;
    })
  })

  /* */

  a.init()
  .then( () =>
  {
    a.shellSync( 'git -C clone checkout tag1' )
    return null;
  })
  .then( () =>
  {
    test.case = 'local repo head is on tag( detached state ) differentiatingTags:0'
    let remotePath = `git+hd://${repoPath}/!tag1`;
    return _.Consequence.From( _.git.isUpToDate({ localPath : clonePath, remotePath, differentiatingTags : 0 }) )
    .then( ( got ) =>
    {
      test.identical( got, true );
      return null;
    })
  })
  .then( () =>
  {
    test.case = 'local repo head is on tag( detached state ) differentiatingTags:1'
    let remotePath = `git+hd://${repoPath}/!tag1`;
    return _.Consequence.From( _.git.isUpToDate({ localPath : clonePath, remotePath, differentiatingTags : 1 }) )
    .then( ( got ) =>
    {
      test.identical( got, true );
      return null;
    })
  })

  /* */

  return a.ready;
}

isUptoDateDifferentiatingTags.rapidity = 1;
isUptoDateDifferentiatingTags.routineTimeOut = 150000;
isUptoDateDifferentiatingTags.description =
`
Tag that is specified in the remotePath is present.
The routine isUpToDate should return:
  - True if local repo head is on commit related to tag and differentiatingTags is disabled
  - False if local repo head is on commit related to tag and differentiatingTags is enabled
  - True if local repo head is on remote tag and differentiatingTags is disabled
  - True if local repo head is on remote tag and differentiatingTags is enabled
`;

//

function isUptoDateDetailing( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* - */

  begin().then( () =>
  {
    test.case = 'remote master, local on branch master';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 })
    .then( ( got ) =>
    {
      let exp =
      {
        'dirExists' : true,
        'isRepository' : true,
        'isClonedFromRemote' : true,
        'isHead' : true,
        'branchIsUpToDate' : true,
        'result' : true
      };
      test.contains( got, exp );
      return got;
    });
  });

  a.ready.then( () =>
  {
    test.case = 'remote has fixated version, local on branch master';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#041839a730fa104a7b6c7e4935b4751ad81b00e0';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 })
    .then( ( got ) =>
    {
      let exp =
      {
        'dirExists' : true,
        'isRepository' : true,
        'isClonedFromRemote' : true,
        'isHead' : false,
        'branchIsUpToDate' : null,
        'result' : false,
      };
      test.contains( got, exp );
      test.true( _.strDefined( got.reason ) );
      return got;
    });
  });

  /* */

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout 041839a730fa104a7b6c7e4935b4751ad81b00e0' })

  a.ready.then( () =>
  {
    test.case = 'remote has same fixed version, local is detached';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#041839a730fa104a7b6c7e4935b4751ad81b00e0';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 })
    .then( ( got ) =>
    {
      let exp =
      {
        'dirExists' : true,
        'isRepository' : true,
        'isClonedFromRemote' : true,
        'isHead' : true,
        'branchIsUpToDate' : null,
        'result' : true
      };
      test.contains( got, exp );
      return got;
    });
  });

  a.ready.then( () =>
  {
    test.case = 'remote has other fixated version, local is detached';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#d70162fc9d06783ec24f622424a35dbda64fe956';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 })
    .then( ( got ) =>
    {
      let exp =
      {
        'dirExists' : true,
        'isRepository' : true,
        'isClonedFromRemote' : true,
        'isHead' : false,
        'branchIsUpToDate' : null,
        'result' : false,
      };
      test.contains( got, exp );
      test.true( _.strDefined( got.reason ) );
      return got;
    });
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'local repository resetted to previous commit';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';

    return _.process.start
    ({
      execPath : 'git reset --hard HEAD~1',
      currentPath : a.abs( 'wModuleForTesting1' ),
    })
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 }) )
    .then( ( got ) =>
    {
      let exp =
      {
        'dirExists' : true,
        'isRepository' : true,
        'isClonedFromRemote' : true,
        'isHead' : true,
        'branchIsUpToDate' : false,
        'result' : false,
      };
      test.contains( got, exp );
      test.true( _.strDefined( got.reason ) );
      return got;
    });
  });

  begin().then( () =>
  {
    test.case = 'local repository has new commit';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';

    return _.process.start
    ({
      execPath : 'git commit --allow-empty -m emptycommit',
      currentPath : a.abs( 'wModuleForTesting1' ),
    })
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 }) )
    .then( ( got ) =>
    {
      let exp =
      {
        'dirExists' : true,
        'isRepository' : true,
        'isClonedFromRemote' : true,
        'isHead' : true,
        'branchIsUpToDate' : true,
        'result' : true,
      };
      test.contains( got, exp );
      return got;
    });
  });

  begin().then( () =>
  {
    test.case = 'local repository update latest commit';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';

    let ready = new _.Consequence().take( null );

    _.process.start
    ({
      execPath : 'git reset --hard HEAD~1',
      currentPath : a.abs( 'wModuleForTesting1' ),
      ready
    });

    _.process.start
    ({
      execPath : 'git commit --allow-empty -m emptycommit',
      currentPath : a.abs( 'wModuleForTesting1' ),
      ready
    });

    ready
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 }) )
    .then( ( got ) =>
    {
      let exp =
      {
        'dirExists' : true,
        'isRepository' : true,
        'isClonedFromRemote' : true,
        'isHead' : true,
        'branchIsUpToDate' : false,
        'result' : false,
      }
      test.contains( got, exp );
      test.true( _.strDefined( got.reason ) );
      return got;
    });

    return ready;
  });

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout 34f17134e3c1fc49ef4b9fa3ec60da8851922588' })

  a.ready.then( () =>
  {
    test.case = 'local repository has new commit, local is detached';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';

    return _.process.start
    ({
      execPath : 'git commit --allow-empty -m emptycommit',
      currentPath : a.abs( 'wModuleForTesting1' ),
    })
    .then( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 }) )
    .then( ( got ) =>
    {
      let exp =
      {
        'dirExists' : true,
        'isRepository' : true,
        'isClonedFromRemote' : true,
        'isHead' : false,
        'branchIsUpToDate' : null,
        'result' : false,
      }
      test.contains( got, exp );
      test.true( _.strDefined( got.reason ) );
      return got;
    });
  });

  /* */

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout -b newbranch' });

  a.ready.then( () =>
  {
    test.case = 'local is on new branch, chech with no identical remote branch';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!master';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 })
    .then( ( got ) =>
    {
      let exp =
      {
        'dirExists' : true,
        'isRepository' : true,
        'isClonedFromRemote' : true,
        'isHead' : false,
        'branchIsUpToDate' : null,
        'result' : false,
      };
      test.contains( got, exp );
      test.true( _.strDefined( got.reason ) );
      return got;
    });
  });

  begin();
  a.shell({ execPath : 'git -C wModuleForTesting1 checkout -b newbranch' });

  a.ready.then( () =>
  {
    test.case = 'local is on new branch, chech with identical remote branch';
    let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/!newbranch';
    return _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 })
    .then( ( got ) =>
    {
      let exp =
      {
        'dirExists' : true,
        'isRepository' : true,
        'isClonedFromRemote' : true,
        'isHead' : true,
        'branchIsUpToDate' : true,
        'result' : true,
      };
      test.contains( got, exp );
      return got;
    });
  });

  /* - */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'remote has different branch that does not exist';
      let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git!other';
      var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 });
      return test.shouldThrowErrorAsync( con );
    });

    a.ready.then( () =>
    {
      test.case = 'branch name as hash';
      let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#other';
      var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 });
      return test.shouldThrowErrorAsync( con );
    });

    a.ready.then( () =>
    {
      test.case = 'hash as tag';
      let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git!d70162fc9d06783ec24f622424a35dbda64fe956';
      var con = _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 });
      return test.shouldThrowErrorAsync( con );
    })

    a.ready.then( () =>
    {
      test.case = 'hash and tag';
      let remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#d70162fc9d06783ec24f622424a35dbda64fe956!master';
      test.shouldThrowErrorSync( () => _.git.isUpToDate({ localPath : a.abs( 'wModuleForTesting1' ), remotePath, detailing : 1 }) )
      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.ready.then( () =>
    {
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        attemptLimit : 4,
        attemptDelay : 250,
        attemptDelayMultiplier : 4,
      });
    });
    return a.ready;
  }
}

isUptoDateDetailing.timeOut = 240000;
isUptoDateDetailing.description =
`
- The routine isUpToDate should return a map if detailing is enabled
- The returned map should contain the reason field in case of false result
`;


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

  a.ready.then( () =>
  {
    test.case = 'localPath does not exists';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git' });
    test.identical( got.downloaded, false )
    test.identical( got.remoteIsValid, false )
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    a.fileProvider.filesDelete( a.abs( 'clone' ) );
    a.fileProvider.dirMake( a.abs( 'clone' ) );
    return null;
  });

  a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git clone' );

  a.ready.then( () =>
  {
    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, local';
    var remotePath = 'https://github.com/Wandalen/wModuleForTesting1.git';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, local';
    var remotePath = 'git+https://github.com/Wandalen/wModuleForTesting1.git';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, global';
    var remotePath = 'https:///github.com/Wandalen/wModuleForTesting1.git';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, global';
    var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    /* */

    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, local with tag';
    var remotePath = 'https://github.com/Wandalen/wModuleForTesting1.git!alpha';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, local with tag';
    var remotePath = 'git+https://github.com/Wandalen/wModuleForTesting1.git!alpha';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, global with tag';
    var remotePath = 'https:///github.com/Wandalen/wModuleForTesting1.git!alpha';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, global with tag';
    var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git!alpha';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    /* */

    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, local with hash';
    var remotePath = 'https://github.com/Wandalen/wModuleForTesting1.git#f546a27';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, local with hash';
    var remotePath = 'git+https://github.com/Wandalen/wModuleForTesting1.git#f546a27';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, global with hash';
    var remotePath = 'https:///github.com/Wandalen/wModuleForTesting1.git#f546a27';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, global with hash';
    var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git#f546a27';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    /* */

    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, local with localVcsPath';
    var remotePath = 'https://github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, local with localVcsPath';
    var remotePath = 'git+https://github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, global with localVcsPath';
    var remotePath = 'https:///github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, global with localVcsPath';
    var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    /* */

    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, local with localVcsPath and tag';
    var remotePath = 'https://github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml!alpha';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, local with localVcsPath and tag';
    var remotePath = 'git+https://github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml!alpha';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, global with localVcsPath and tag';
    var remotePath = 'https:///github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml!alpha';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, global with localVcsPath and tag';
    var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml!alpha';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    /* */

    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, local with localVcsPath and hash';
    var remotePath = 'https://github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml#f546a27';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, local with localVcsPath and hash';
    var remotePath = 'git+https://github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml#f546a27';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with simple protocol, global with localVcsPath and hash';
    var remotePath = 'https:///github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml#f546a27';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    test.case = 'repository is cloned to localPath, valid remotePath with complex protocol, global with localVcsPath and hash';
    var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/wModuleForTesting1.out.will.yml#f546a27';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );

    /* */

    test.case = 'repository is cloned to localPath, not valid remotePath';
    var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting2.git';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, false );
    return null;
  });

  /* */

  a.shell( 'git -C clone remote remove origin' );
  a.ready.then( () =>
  {
    test.case = 'repository has no origin, localPath and remotePath are valid';
    var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true )
    test.identical( got.remoteIsValid, false )

    test.case = 'repository has no origin, localPath is valid, remotePath is not valid';
    var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting2.git';
    var got = _.git.hasRemote({ localPath : a.abs( 'clone' ), remotePath });
    test.identical( got.downloaded, true )
    test.identical( got.remoteIsValid, false )
    return null;
  });

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.hasRemote() );

      test.case = 'extra arguments';
      var o = { localPath : a.abs( 'clone' ), remotePath : 'https://github.com/Wandalen/wModuleForTesting1' };
      test.shouldThrowErrorSync( () => _.git.hasRemote( o, o ) );

      test.case = 'localPath is not defined string';
      var o = { localPath : '', remotePath : 'https://github.com/Wandalen/wModuleForTesting1' };
      test.shouldThrowErrorSync( () => _.git.hasRemote( o ) );

      test.case = 'remotePath is not defined string';
      var o = { localPath : a.abs( 'clone' ), remotePath : '' };
      test.shouldThrowErrorSync( () => _.git.hasRemote( o ) );

      test.case = 'options map o has unknown option';
      var o = { localPath : a.abs( 'clone' ), remotePath : 'https://github.com/Wandalen/wModuleForTesting1', unknown : 1 };
      test.shouldThrowErrorSync( () => _.git.hasRemote( o ) );

      return null;
    });
  }

  return a.ready;
}

hasRemote.routineTimeOut = 30000;

//

function isRepository( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* - */

  prepareRepo().then( () =>
  {
    test.case = 'check local bare repository';
    var got = _.git.isRepository({ remotePath : a.abs( 'repo' ) });
    test.identical( got, true );

    test.case = 'simple https path';
    var got = _.git.isRepository({ remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git' });
    test.identical( got, true );

    test.case = 'simple https path with tag';
    var got = _.git.isRepository({ remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git!master' });
    test.identical( got, true );

    test.case = 'simple https path with hash';
    var got = _.git.isRepository({ remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git#b9be3d9c10ae6f0f065bb4cf1577b743ddba3720' });
    test.identical( got, true );

    test.case = 'global path';
    var got = _.git.isRepository({ remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git' });
    test.identical( got, true );

    test.case = 'global path with tag';
    var got = _.git.isRepository({ remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git!master' });
    test.identical( got, true );

    test.case = 'global path with hash';
    var got = _.git.isRepository({ remotePath : 'git+https://github.com/Wandalen/wModuleForTesting1.git#b9be3d9c10ae6f0f065bb4cf1577b743ddba3720' });
    test.identical( got, true );

    test.case = 'global path with with subpath';
    var got = _.git.isRepository({ remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git/out/wModuleForTesting1!master' });
    test.identical( got, true );

    test.case = 'simple https path, not a repository';
    var got = _.git.isRepository({ remotePath : 'https://github.com/Wandalen/unknown-module.git' });
    test.identical( got, false );

    /* qqq : ask
    git ls-remote https://github.com/x/y.git
    */
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'path to repository';
    var got = _.git.isRepository({ localPath : a.abs( 'clone' ) });
    test.identical( got, true );

    test.case = 'path to repository with tag';
    var got = _.git.isRepository({ localPath : a.abs( 'clone/!master' ) });
    test.identical( got, true );

    test.case = 'path to repository with hash';
    var got = _.git.isRepository({ localPath : a.abs( 'clone/#b9be3d9c10ae6f0f065bb4cf1577b743ddba3720' ) });
    test.identical( got, true );

    test.case = 'global path to repository';
    var got = _.git.isRepository({ localPath : a.path.globalFromPreferred( a.abs( 'clone' ) ) });
    test.identical( got, true );

    test.case = 'global path to repository with tag';
    var got = _.git.isRepository({ localPath : a.path.globalFromPreferred( a.abs( 'clone/!master' ) ) });
    test.identical( got, true );

    test.case = 'global path to repository with hash';
    var got = _.git.isRepository({ localPath : a.path.globalFromPreferred( a.abs( 'clone/#b9be3d9c10ae6f0f065bb4cf1577b743ddba3720' ) ) });
    test.identical( got, true );

    test.case = 'not cloned';
    var got = _.git.isRepository({ localPath : a.abs( 'clone2' ) });
    test.identical( got, false );

    test.case = 'path to repository';
    var got = _.git.isRepository({ localPath : '/' });
    test.identical( got, false );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'valid remote';
    var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : a.abs( 'repo' ) });
    test.identical( got, true );

    test.case = 'another remote';
    var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : a.abs( 'repo2' ) });
    test.identical( got, false );

    test.case = 'invalid remote';
    var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : a.abs( 'repo3' ) });
    test.identical( got, false );

    test.case = 'global remote';
    var got = _.git.isRepository({ localPath : a.abs( 'clone' ), remotePath : a.path.globalFromPreferred( a.abs( 'repo' ) ) });
    test.identical( got, true );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function prepareRepo()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( 'repo' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'repo' ) ); return null });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git init --bare' });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'repo2' ) ); return null });
    a.shell({ currentPath : a.abs( 'repo2' ), execPath : 'git init --bare' });
    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( 'clone' ) ); return null })
    a.shell( `git clone ${ a.path.nativize( a.abs( 'repo' ) ) } clone` );
    return a.ready;
  }
}

isRepository.timeOut = 30000;

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

  /* */

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
    test.true( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.true( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.true( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] test/ ) )

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
    test.true( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.true( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.true( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] test/ ) )

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
    test.true( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.true( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.true( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] test/ ) )

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

  /* */

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

  /* */

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
    test.true( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.true( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.true( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] test/ ) )

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

  /* */

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
    test.true( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.true( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] test/ ) )
    test.true( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] test/ ) )

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

  /* */

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

  /* */

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

  /* */

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

    test.true( _.strHas( got.status, /List of uncommited changes in files:\n.*\!\! file/ ) )
    test.true( _.strHas( got.status, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.true( _.strHas( got.unpushed, /List of branches with unpushed commits:\n.*\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.true( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )

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

  /* */

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

statusLocal.timeOut = 240000;

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

  initEmptyWithOrigin()
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

  /* */

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
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
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
        test.true( _.strHas( got.output, a.path.nativize( a.abs( 'repo' ) ) ) );
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

  /* */

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

  /* */

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

    test.true( _.strHas( got.unpushed, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.true( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.true( _.strHas( got.status, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )

    return null;
  })

  /* */

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

    test.true( _.strHas( got.uncommitted, 'List of uncommited changes in files:' ) )
    test.true( _.strHas( got.uncommitted, /.+ ?? newFile/ ) )

    test.true( _.strHas( got.unpushed, 'List of branches with unpushed commits:' ) )
    test.true( _.strHas( got.unpushed, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.true( _.strHas( got.unpushed, 'List of unpushed:' ) )
    test.true( _.strHas( got.unpushed, /\[new tag\] .* sometag -> sometag/ ) )
    test.true( _.strHas( got.unpushed, /\[new branch\] .* somebranch -> \?/ ) )

    test.true( _.strHas( got.unpushedCommits, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.true( _.strHas( got.unpushedTags, /\[new tag\] .* sometag -> sometag/ ) )
    test.true( _.strHas( got.unpushedBranches, /\[new branch\] .* somebranch -> \?/ ) )

    test.true( _.strHas( got.status, 'List of uncommited changes in files:' ) )
    test.true( _.strHas( got.status, /.+ ?? newFile/ ) )
    test.true( _.strHas( got.status, /\* master .* \[origin\/master: ahead 1\] no desc/ ) )
    test.true( _.strHas( got.status, /\[new tag\] .* sometag -> sometag/ ) )
    test.true( _.strHas( got.status, /\[new branch\] .* somebranch -> \?/ ) )

    test.contains( got, expected )
    return null;
  })

  /* */

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

  /* */

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
      logger : 1,
    });
    test.identical( !!got.status, true )
    test.identical( !!got.uncommittedUnstaged, true )

    return null;
  })

  /* */

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
      logger : 1,
    });

    test.identical( !!got.status, true )
    test.identical( !!got.uncommittedUnstaged, true )

    return null;
  })

  /* */

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
      logger : 1,
    });
    test.identical( !!got.uncommittedDeleted, true )
    test.identical( !!got.uncommittedAdded, true )
    test.identical( !!got.status, true )

    return null;
  })

  /* */

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
      logger : 1,
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
      logger : 1,
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
      logger : 1,
    });
    test.identical( !!got.status, true )
    test.identical( !!got.uncommittedUnstaged, true )

    return null;
  })

  /* */

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
      logger : 1,
    });
    test.identical( !!got.status, true )
    test.identical( !!got.uncommittedUnstaged, true )

    return null;
  })

  /* */

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

function statusLocalWithAttempts( test )
{
  let context = this;

  let a = test.assetFor( 'basic' );
  a.fileProvider.dirMake( a.abs( '.' ) )

  if( process.platform === 'win32' || process.platform === 'darwin' || !_.process.insideTestContainer() )
  {
    test.true( true );
    return;
  }

  /* */

  let netInterfaces = __.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
  begin().then( () => __.test.netInterfacesDown({ interfaces : netInterfaces }) );

  /* */

  a.ready.then( () =>
  {
    test.case = 'increase attemptDelay';
    var o =
    {
      localPath : a.abs( '.' ),
      unpushed : 0,
      unpushedTags : 1,
      uncommitted : 0,
      detailing : 1,
      explaining : 1,
      attemptDelay : 5000,
    };
    var errCallback = ( err, arg ) =>
    {
      test.true( _.errIs( err ) );
      test.identical( arg, undefined );
      test.identical( _.strCount( err.message, 'fatal' ), 1 );
      test.identical( _.strCount( err.message, 'Could not resolve host' ), 1 );
    };
    var before = _.time.now();
    test.shouldThrowErrorSync( () => _.git.statusLocal( o ), errCallback );
    var spent = _.time.now() - before;
    test.ge( spent, 5000 );

    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'increase number of attempts and attemptDelay';
    var o =
    {
      localPath : a.abs( '.' ),
      unpushed : 0,
      unpushedTags : 1,
      uncommitted : 0,
      detailing : 1,
      explaining : 1,
      attempt : 3,
      attemptDelay : 5000,
    };
    var errCallback = ( err, arg ) =>
    {
      test.true( _.errIs( err ) );
      test.identical( arg, undefined );
      test.identical( _.strCount( err.message, 'fatal' ), 1 );
      test.identical( _.strCount( err.message, 'Could not resolve host' ), 1 );
    };
    var before = _.time.now();
    test.shouldThrowErrorSync( () => _.git.statusLocal( o ), errCallback );
    var spent = _.time.now() - before;
    test.ge( spent, 10000 );

    return null;
  });

  /* */

  a.ready.finally( () => __.test.netInterfacesUp({ interfaces : netInterfaces }) );

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git .' );
    a.shell( 'git tag new_tag' );
    return a.ready;
  }
}

statusLocalWithAttempts.timeOut = 30000;

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  a.fileProvider.dirMake( a.abs( '.' ) );

  /* */

  begin().then( () =>
  {
    test.case = 'check tags on fresh clone';

    var got = _.git.statusRemote
    ({
      localPath : a.abs( 'clone' ),
      remoteCommits : 1,
      remoteBranches : 0,
      remoteTags : 1,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : false,
      status : false
    };
    test.identical( got, expected );
    return null;
  });

  /* */

  a.shell( 'git tag -d v0.0.70' )
  .then( () =>
  {
    test.case = 'compare with remore after remove';

    var got = _.git.statusRemote
    ({
      localPath : a.abs( 'clone' ),
      remoteCommits : 1,
      remoteBranches : 0,
      remoteTags : 1,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : 'refs/tags/v0.0.70\nrefs/tags/v0.0.70^{}',
      status : 'List of unpulled remote tags:\n  refs/tags/v0.0.70\n  refs/tags/v0.0.70^{}'
    };
    test.identical( got, expected );
    return null;
  });

  /* */

  a.shell( 'git fetch --all' )
  .then( () =>
  {
    test.case = 'check tags after fetching';

    var got = _.git.statusRemote
    ({
      localPath : a.abs( 'clone' ),
      remoteCommits : 1,
      remoteBranches : 0,
      remoteTags : 1,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : false,
      status : false
    };
    test.identical( got, expected );
    return null;
  });

  /* */

  a.shell( 'git tag sometag' )
  .then( () =>
  {
    test.case = 'check after creating tag locally';

    var got = _.git.statusRemote
    ({
      localPath : a.abs( 'clone' ),
      remoteCommits : 1,
      remoteBranches : 0,
      remoteTags : 1,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : false,
      status : false
    };
    test.identical( got, expected );
    return null;
  });

  /* */

  a.shell( 'git tag new v0.0.70' );
  a.shell( 'git tag -d v0.0.70' )
  .then( () =>
  {
    test.case = 'check after renaming';

    var got = _.git.statusRemote
    ({
      localPath : a.abs( 'clone' ),
      remoteCommits : 1,
      remoteBranches : 0,
      remoteTags : 1,
      detailing : 1,
      explaining : 1
    });
    var expected =
    {
      remoteCommits : false,
      remoteBranches : null,
      remoteTags : 'refs/tags/v0.0.70\nrefs/tags/v0.0.70^{}',
      status : 'List of unpulled remote tags:\n  refs/tags/v0.0.70\n  refs/tags/v0.0.70^{}'
    };
    test.identical( got, expected );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return null;
    });
    a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone https://github.com/Wandalen/wModuleForTesting2.git clone' });
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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

    /* */

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

    /* */

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

  /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

  /* */

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

  /* */

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
    ];

    _.each( expectedStatus, ( line ) =>
    {
      test.case = 'status has line: ' + _.strQuote( line )
      test.true( !!status.status.match( line ) )
    })

    test.identical( status.conflicts, false );

    return null;
  })

  /* */

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
      test.true( !!status.status.match( line ) )
    })

    return null;
  })

  /* */

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

    _.each( expectedStatus, ( line ) =>
    {
      test.case = 'status has line: ' + _.strQuote( line )
      test.true( !!status.status.match( line ) )
    })

    return null;
  })

  /* */

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

    if( annotated )
    shell( `git -C secondary tag -a ${tag} -m "sometag"` );
    else
    shell( `git -C secondary tag ${ tag }` );

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

statusEveryCheck.timeOut = 100000;

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
      logger : 1,
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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

    /* */

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

  /* */

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

  /* */

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
      logger : 1,
      remoteCommits : null,
      remoteBranches : 0,
      remoteTags : null,
      explaining : 0,
      detailing : 1
    });
    test.identical( got.status, true )

    return null;
  })

  /* */

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

statusFullHalfStaged.timeOut = 15000;

//

function statusFullWithPR( test )
{
  const a = test.assetFor( 'basic' );

  const token = process.env.PRIVATE_WTOOLS_BOT_TOKEN;
  if( !token || !_.process.insideTestContainer() || process.platform === 'win32' )
  return test.true( true );

  const user = 'wtools-bot';
  const repository = `https://github.com/${ user }/New-${ _.number.intRandom( 1000000 ) }`;
  begin();

  /* - */

  a.ready.then( () =>
  {
    test.case = 'prs - 1';
    return _.git.statusFull
    ({
      localPath : a.abs( '.' ),
      local : 1,
      remote : 1,
      prs : 1,
      detailing : 1,
      explaining : 1,
      sync : 1,
      token,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.prs.length, 1 );
    test.identical( op.status, 'Has 1 opened pull request(s)' );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'prs - 0';
    return _.git.statusFull
    ({
      localPath : a.abs( '.' ),
      local : 1,
      remote : 1,
      prs : 0,
      detailing : 1,
      explaining : 1,
      sync : 1,
      token,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.prs, null );
    test.identical( op.status, false );
    return null;
  });

  /* */

  a.ready.finally( () => repositoryDelete() );

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.reflect(); return null });
    a.ready.then( ( op ) => repositoryDelete() );
    a.ready.then( ( op ) => repositoryInit() ).delay( 3000 );
    let execPath = `git config credential.helper '!f(){ echo "username=${ user }" && echo "password=${ token }"; }; f'`;
    a.shell({ execPath });
    a.shell({ execPath : 'git add --all' });
    a.shell({ execPath : 'git commit -m first' });
    a.shell({ execPath : 'git push -u origin master' });
    a.shell({ execPath : 'git checkout -b new' });
    a.ready.then( () => { a.fileProvider.fileAppend( a.abs( 'File.txt' ), 'new line\n' ); return null });
    a.shell({ execPath : 'git commit -am second' });
    a.shell({ execPath : 'git push -u origin new' });
    a.ready.then( () => pullRequestOpen() );
    return a.ready;
  }

  /* */

  function repositoryDelete()
  {
    return _.git.repositoryDelete
    ({
      remotePath : repository,
      token,
      throwing : 0,
    });
  }

  /* */

  function repositoryInit()
  {
    return _.git.repositoryInit
    ({
      remotePath : repository,
      localPath : a.routinePath,
      throwing : 1,
      description : 'Test',
      token,
    });
  }

  /* */

  function pullRequestOpen()
  {
    return _.repo.pullOpen
    ({
      token,
      remotePath : repository,
      descriptionHead : 'Test',
      srcBranch : 'new',
      dstBranch : 'master',
    });
  }
}

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
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
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
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add newFile' )
  .then( () =>
  {
    test.case = 'new staged file'
    test.true( a.fileProvider.fileExists( a.abs( 'clone', 'newFile' ) ) );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
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
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add README' )
  .then( () =>
  {
    test.case = 'unstaged change in existing file'
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
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
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
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
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
    test.identical( got, false );
    return null;
  })
  a.shell( 'git merge' )
  .then( () =>
  {
    test.case = 'merge after fetch, remote had new commit';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : 0 });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : 1 });
    test.identical( got, false );
    return null;
  })

  /* */

  begin()
  a.shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'new local commit'
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false });
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
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true });
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
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true });
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
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true });
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
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local has pushed tag';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false });
    test.identical( got, false );
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git tag -a sometag -m "testtag"' )
  .then( () =>
  {
    test.case = 'local has unpushed annotated tag';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push --follow-tags' )
  .then( () =>
  {
    test.case = 'local has pushed annotated tag';
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false });
    test.identical( got, false );
    var got = _.git.hasLocalChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false });
    test.identical( got, false );
    return null;
  })

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

  begin()
  a.shell( 'git remote add origin ' + 'https://github.com/Wandalen/wModuleForTesting1.git' )
  a.shell( 'git commit --allow-empty -m test' )
  // shell( 'git status -b --porcelain -u' )
  // shell( 'git push --dry-run' )
  .then( () =>
  {
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

  /* */

  return a.ready;

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

hasRemoteChanges.timeOut = 60000;

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
  // a.fileProvider.dirMake( a.abs( 'clone' ) )

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
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
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
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add newFile' )
  .then( () =>
  {
    test.case = 'new staged file'
    test.true( a.fileProvider.fileExists( a.abs( 'clone', 'newFile' ) ) );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
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
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git add README' )
  .then( () =>
  {
    test.case = 'unstaged change in existing file'
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1 });
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
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 0, remote : 1 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), uncommitted : 1, remote : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git merge' )
  .then( () =>
  {
    test.case = 'merge after fetch, remote had new commit';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : 1 });
    test.identical( got, false );
    return null;
  })

  /* */

  begin()
  a.shell( 'git commit --allow-empty -m test' )
  .then( () =>
  {
    test.case = 'new local commit'
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false });
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
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 0 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 1 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 1 });
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
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 1 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 1 });
    test.identical( got, false );
    return null;
  })
  a.shell( 'git checkout feature' )
  repoNewCommitToBranch( 'testCommit', 'feature' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local executed fetch without merge';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 1 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 1 });
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
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 0 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 1 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 1 });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git checkout feature' )
  repoNewCommitToBranch( 'testCommit', 'feature' )
  .then( () =>
  {
    test.case = 'remote has commit to other branch, local has commit to master,fetch without merge, branch downloaded';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 0 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : false, remote : 1 });
    test.identical( got, true );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedCommits : true, remote : 1 });
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
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push --tags' )
  .then( () =>
  {
    test.case = 'local has pushed tag';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false });
    test.identical( got, false );
    return null;
  })

  /* */

  prepareRepo()
  repoNewCommit( 'init' )
  begin()
  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git tag -a sometag -m "testtag"' )
  .then( () =>
  {
    test.case = 'local has unpushed annotated tag';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false });
    test.identical( got, true );
    return null;
  })
  a.shell( 'git push --follow-tags' )
  .then( () =>
  {
    test.case = 'local has pushed annotated tag';
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : false, unpushedCommits : false, remote : 0 });
    test.identical( got, false );
    var got = _.git.hasChanges({ localPath : a.abs( 'clone' ), unpushedTags : true, unpushedCommits : false, remote : 0 });
    test.identical( got, false );
    return null;
  })

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

  /* */

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

function repositoryHasTag( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.fileProvider.dirMake( a.abs( '.' ) )

  /* */

  begin().then( () =>
  {
    test.case = 'tag - master, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - master, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - master, not exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, true );

    /* */

    test.case = 'tag - abc, not exists, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - abc, not exists, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - abc, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    /* */
    test.case = 'tag - 0.0.37, exists, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - 0.0.37, exists, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - 0.0.37, exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    /* */

    test.case = 'tag - hash, not exists, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - hash, not exists, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - hash, not exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    /* */

    test.case = 'tag - branch, exists only on remote server, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'dev1',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - branch, exists only on remote server, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'dev1',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - hash, not exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'dev1',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    /* - */

    if( !Config.debug )
    return null;

    test.case = 'without arguments';
    test.shouldThrowErrorSync( () => _.git.repositoryHasTag() );

    test.case = 'extra arguments';
    test.shouldThrowErrorSync( () =>
    {
      let o =
      {
        tag : 'master',
        localPath : a.abs( 'wModuleForTesting1' ),
      };
      return _.git.repositoryHasTag( o, {} );
    });

    test.case = 'options map o has unknown option';
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryHasTag
      ({
        tag : 'master',
        localPath : a.abs( 'wModuleForTesting1' ),
        unknown : 1,
      });
    });

    test.case = 'wrong type of o.localPath';
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryHasTag
      ({
        tag : 'master',
        localPath : 1,
      });
    });

    test.case = 'wrong type of o.tag';
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryHasTag
      ({
        tag : 1,
        localPath : a.abs( 'wModuleForTesting1' ),
      });
    });

    test.case = 'wrong type of o.remotePath';
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryHasTag
      ({
        tag : 'master',
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 1,
      });
    });

    test.case = 'directory is not a git repository'
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryHasTag
      ({
        localPath : a.abs( '.' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        tag : 'master',
      });
    });

    test.case = 'local - 0 and remote - 0';
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryHasTag
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
        local : 0,
        remote : 0,
      });
    });

    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) ) );
    a.shell( `git clone https://github.com/Wandalen/wModuleForTesting1.git` );
    return a.ready;
  }
}

repositoryHasTag.timeOut = 120000;

//

function repositoryHasTagRemotePathIsMap( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.fileProvider.dirMake( a.abs( '.' ) )

  /* */

  begin().then( () =>
  {
    test.case = 'tag - master, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : 'master',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - master, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : 'master',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - master, not exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : 'master',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, true );

    /* */

    test.case = 'tag - abc, not exists, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : 'abc',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - abc, not exists, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : 'abc',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - abc, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : 'abc',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    /* */
    test.case = 'tag - 0.0.37, exists, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : '0.0.37',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - 0.0.37, exists, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : '0.0.37',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - 0.0.37, exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : '0.0.37',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    /* */

    test.case = 'tag - hash, not exists, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - hash, not exists, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - hash, not exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    /* */

    test.case = 'tag - branch, exists only on remote server, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : 'dev1',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - branch, exists only on remote server, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : 'dev1',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'tag - hash, not exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      tag : 'dev1',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) ) );
    a.shell( `git clone https://github.com/Wandalen/wModuleForTesting1.git` );
    return a.ready;
  }
}

repositoryHasTagRemotePathIsMap.timeOut = 120000;

//

function repositoryHasTagWithOptionReturnVersion( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.fileProvider.dirMake( a.abs( '.' ) )

  /* */

  begin().then( () =>
  {
    test.case = 'tag - master, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 1,
      remote : 1,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got.match( /\b[0-9A-Fa-f]{40}\b/ )[ 0 ], got );

    test.case = 'tag - master, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 0,
      remote : 1,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got.match( /\b[0-9A-Fa-f]{40}\b/ )[ 0 ], got );

    test.case = 'tag - master, not exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 1,
      remote : 0,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got.match( /\b[0-9A-Fa-f]{40}\b/ )[ 0 ], got );

    /* */

    test.case = 'tag - abc, not exists, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 1,
      remote : 1,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, false );

    test.case = 'tag - abc, not exists, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 0,
      remote : 1,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, false );

    test.case = 'tag - abc, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 1,
      remote : 0,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, false );

    /* */
    test.case = 'tag - 0.0.37, exists, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 1,
      remote : 1,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, 'b75c79ceeb6602d0f5aa1f1a230d60c0aff8e3bf' );

    test.case = 'tag - 0.0.37, exists, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 1,
      remote : 0,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, 'b75c79ceeb6602d0f5aa1f1a230d60c0aff8e3bf' );

    test.case = 'tag - 0.0.37, exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 0,
      remote : 1,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, 'b75c79ceeb6602d0f5aa1f1a230d60c0aff8e3bf' );

    /* */

    test.case = 'tag - hash, not exists, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 1,
      remote : 1,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, false );

    test.case = 'tag - hash, not exists, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 0,
      remote : 1,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, false );

    test.case = 'tag - hash, not exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 1,
      remote : 0,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, false );

    /* */

    test.case = 'tag - branch, exists only on remote server, local - 1, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'dev1',
      local : 1,
      remote : 1,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, '8e2aa80ca350f3c45215abafa07a4f2cd320342a' );

    test.case = 'tag - branch, exists only on remote server, local - 0, remote - 1';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'dev1',
      local : 0,
      remote : 1,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, '8e2aa80ca350f3c45215abafa07a4f2cd320342a' );

    test.case = 'tag - hash, not exists, local - 1, remote - 0';
    var got = _.git.repositoryHasTag
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'dev1',
      local : 1,
      remote : 0,
      sync : 1,
      returnVersion : 1,
    });
    test.identical( got, false );

    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) ) );
    a.shell( `git clone https://github.com/Wandalen/wModuleForTesting1.git` );
    return a.ready;
  }
}

repositoryHasTagWithOptionReturnVersion.timeOut = 120000;

//

function repositoryHasVersion( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  begin().then( () =>
  {
    test.open( 'local - 1, remote - 0' );

    test.case = 'full commit hash, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'part of commit hash, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a730fa104a7b6c7',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'minimal length of commit hash, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, true );

    /* */

    test.case = 'full commit hash, not exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'd290dbaa22ea0f13a75d5b9ba19d5b061c6ba8bf',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'minimal part of commit hash, not exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'd290baa',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    test.close( 'local - 1, remote - 0' );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.open( 'local - 0, remote - 1' );

    test.case = 'full commit hash, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'part of commit hash, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a730fa104a7b6c7',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'minimal length of commit hash, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : '041839a',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    /* */

    test.case = 'full commit hash, not exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'd290dbaa22ea0f13a75d5b9ba19d5b061c6ba8bf',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'minimal part of commit hash, not exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      version : 'd290baa',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.close( 'local - 0, remote - 1' );

    return null;
  });

  /* - */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'o.version is a branch name, not a hash';
      var errCallback = ( err, arg ) =>
      {
        test.identical( arg, undefined );
        test.true( _.errIs( err ) );
        var pattern = /Provided version: .* is not a commit hash/;
        test.identical( _.strCount( err.messag, pattern ), 1 );
      };
      test.shouldThrowErrorSync( () =>
      {
        _.git.repositoryHasVersion
        ({
          localPath : a.abs( 'wModuleForTesting1' ),
          version : 'master',
          sync : 1
        });
      }, errCallback );

      /* */

      test.case = 'o.version is a tag name, not a hash';
      var errCallback = ( err, arg ) =>
      {
        test.identical( arg, undefined );
        test.true( _.errIs( err ) );
        var pattern = /Provided version: .* is not a commit hash/;
        test.identical( _.strCount( err.messag, pattern ), 1 );
      };
      test.shouldThrowErrorSync( () =>
      {
        _.git.repositoryHasVersion
        ({
          localPath : a.abs( 'wModuleForTesting1' ),
          version : '0.0.37',
          sync : 1
        });
      }, errCallback );

      /* */

      test.case = 'o.version length is less than 7';
      var errCallback = ( err, arg ) =>
      {
        test.identical( arg, undefined );
        test.true( _.errIs( err ) );
        var pattern = /Provided version: .* is not a commit hash/;
        test.identical( _.strCount( err.messag, pattern ), 1 );
      };
      test.shouldThrowErrorSync( () =>
      {
        _.git.repositoryHasVersion
        ({
          localPath : a.abs( 'wModuleForTesting1' ),
          version : '1c',
          sync : 1
        });
      }, errCallback );

      /* */

      test.case = 'not a repository, should throw error';
      var errCallback = ( err, arg ) =>
      {
        test.identical( arg, undefined );
        test.true( _.errIs( err ) );
        var pattern = /Provided \{-o\.localPath-\}: .* doesn't contain a git repository/;
        test.identical( _.strCount( err.messag, pattern ), 1 );
      };
      test.shouldThrowErrorSync( () =>
      {
        _.git.repositoryHasVersion
        ({
          localPath : a.abs( 'wModuleForTesting12' ),
          version : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
          sync : 1
        });
      }, errCallback );

      /* */

      test.case = 'wrong type of o.localPath';
      test.shouldThrowErrorSync( () =>
      {
        _.git.repositoryHasVersion
        ({
          localPath : null,
          version : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
          sync : 1
        });
      });

      /* */

      test.case = 'wrong type of o.version';
      var errCallback = ( err, arg ) =>
      {
        test.identical( arg, undefined );
        test.true( _.errIs( err ) );
        var pattern = /Provided version: .* is not a commit hash/;
        test.identical( _.strCount( err.messag, pattern ), 1 );
      };
      test.shouldThrowErrorSync( () =>
      {
        _.git.repositoryHasVersion
        ({
          localPath : a.abs( 'wModuleForTesting1' ),
          version : null,
          sync : 1
        });
      }, errCallback );

      return null;
    });

    begin();
    a.shell( 'git clone wModuleForTesting1 repo' );
    a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git commit --allow-empty -m empty' });
    a.ready.then( () =>
    {
      test.case = 'remote is ahead';
      var errCallback = ( err, arg ) =>
      {
        test.identical( arg, undefined );
        test.true( _.errIs( err ) );
        var pattern = /Local repository at .* is not up-to-date with remote/;
        test.identical( _.strCount( err.messag, pattern ), 1 );
      };
      test.shouldThrowErrorSync( () =>
      {
        _.git.repositoryHasVersion
        ({
          localPath : a.abs( 'repo' ),
          version : '041839a730fa104a7b6c7e4935b4751ad81b00e0',
          local : 0,
          remote : 1,
          sync : 1,
        });
      }, errCallback );

      return null;
    });
  }

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
      a.fileProvider.dirMake( a.abs( '.' ) );
      return null;
    });
    a.shell( `git clone https://github.com/Wandalen/wModuleForTesting1.git` );
    return a.ready;
  }
}

repositoryHasVersion.timeOut = 60000;

//

function repositoryHasVersionWithLocalRemoteRepo( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* - */

  begin().then( () =>
  {
    test.open( 'remote path is absolute path' );
    return null;
  });

  a.ready.then( () =>
  {
    let version = getLatestCommit();

    /* */

    test.case = 'local - 1, remote - 0, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'repo' ),
      version,
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'local - 0, remote - 1, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'repo' ),
      version,
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'local - 1, remote - 0, not exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'repo' ),
      version : 'aaaaaaaaaaaaa',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'local - 0, remote - 1, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'repo' ),
      version : 'aaaaaaaaaaaaa',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    return null;
  });

  a.ready.then( () =>
  {
    test.close( 'remote path is absolute path' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.open( 'remote path is relative path with two dots' );
    return null;
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git remote set-url origin ../main/' })

  a.ready.then( () =>
  {
    let version = getLatestCommit();

    /* */

    test.case = 'local - 1, remote - 0, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'repo' ),
      version,
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'local - 0, remote - 1, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'repo' ),
      version,
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, true );

    test.case = 'local - 1, remote - 0, not exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'repo' ),
      version : 'aaaaaaaaaaaaa',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'local - 0, remote - 1, exists';
    var got = _.git.repositoryHasVersion
    ({
      localPath : a.abs( 'repo' ),
      version : 'aaaaaaaaaaaaa',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    return null;
  });

  a.ready.then( () =>
  {
    test.close( 'remote path is relative path with two dots' );
    return null;
  });

  /* */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'local - 0, remote - 1, remote repository is ahead, should throw error';
      return null;
    });

    a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone repo clone' });
    a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git remote set-url origin ../repo' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git commit --allow-empty -m new' });
    a.ready.then( () =>
    {
      var version = getLatestCommit();
      var errCallback = ( err, arg ) =>
      {
        test.true( _.errIs( err ) );
        test.identical( arg, undefined );
        test.identical( _.strCount( err.message, /Local repository at .* is not up-to-date with remote./ ), 2 );
      }
      test.shouldThrowErrorSync( () =>
      {
        _.git.repositoryHasVersion
        ({
          localPath : a.abs( 'clone' ),
          version,
          local : 0,
          remote : 1,
          sync : 1
        })
      }, errCallback );
      return null;
    });

  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'main' ) );
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      return null;
    });

    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'main' ) );
      return null;
    });
    a.shell({ currentPath : a.abs( 'main' ), execPath : `git init --bare` });
    a.shell( `git init` );
    a.shell( 'git clone main repo' );
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git commit --allow-empty -m init' })
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git push -u origin --all' })
    return a.ready;
  }

  /* */

  function getLatestCommit()
  {
    let currentVersion = _.git.localVersion({ localPath : a.abs( 'repo' ) });
    if( !_.git.versionIsCommitHash({ localPath : a.abs( 'repo' ), version : currentVersion }) )
    currentVersion = _.git.repositoryTagToVersion({ localPath : a.abs( 'repo' ), tag : currentVersion });
    return currentVersion;
  }
}

//

function repositoryTagToVersion( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  a.fileProvider.dirMake( a.abs( '.' ) )

  /* */

  begin().then( () =>
  {
    test.case = 'tag - master, local - 1, remote - 1';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got.match( /\b[0-9A-Fa-f]{40}\b/ )[ 0 ], got );

    test.case = 'tag - master, local - 0, remote - 1';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got.match( /\b[0-9A-Fa-f]{40}\b/ )[ 0 ], got );

    test.case = 'tag - master, not exists, local - 1, remote - 0';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'master',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got.match( /\b[0-9A-Fa-f]{40}\b/ )[ 0 ], got );

    /* */

    test.case = 'tag - abc, not exists, local - 1, remote - 1';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - abc, not exists, local - 0, remote - 1';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - abc, local - 1, remote - 0';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : 'abc',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    /* */
    test.case = 'tag - 0.0.37, exists, local - 1, remote - 1';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, 'b75c79ceeb6602d0f5aa1f1a230d60c0aff8e3bf' );

    test.case = 'tag - 0.0.37, exists, local - 0, remote - 1';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, 'b75c79ceeb6602d0f5aa1f1a230d60c0aff8e3bf' );

    test.case = 'tag - 0.0.37, exists, local - 1, remote - 0';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '0.0.37',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, 'b75c79ceeb6602d0f5aa1f1a230d60c0aff8e3bf' );

    /* */

    test.case = 'tag - hash, not exists, local - 1, remote - 1';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 1,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - hash, not exists, local - 0, remote - 1';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 0,
      remote : 1,
      sync : 1
    });
    test.identical( got, false );

    test.case = 'tag - hash, not exists, local - 1, remote - 0';
    var got = _.git.repositoryTagToVersion
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
      local : 1,
      remote : 0,
      sync : 1
    });
    test.identical( got, false );

    /* - */

    if( !Config.debug )
    return null;

    test.case = 'without arguments';
    test.shouldThrowErrorSync( () => _.git.repositoryTagToVersion() );

    test.case = 'extra arguments';
    test.shouldThrowErrorSync( () =>
    {
      let o =
      {
        tag : 'master',
        localPath : a.abs( 'wModuleForTesting1' ),
      };
      return _.git.repositoryTagToVersion( o, {} );
    });

    test.case = 'options map o has unknown option';
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryTagToVersion
      ({
        tag : 'master',
        localPath : a.abs( 'wModuleForTesting1' ),
        unknown : 1,
      });
    });

    test.case = 'wrong type of o.localPath';
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryTagToVersion
      ({
        tag : 'master',
        localPath : 1,
      });
    });

    test.case = 'wrong type of o.tag';
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryTagToVersion
      ({
        tag : 1,
        localPath : a.abs( 'wModuleForTesting1' ),
      });
    });

    test.case = 'wrong type of o.remotePath';
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryTagToVersion
      ({
        tag : 'master',
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 1,
      });
    });

    test.case = 'directory is not a git repository'
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryTagToVersion
      ({
        localPath : a.abs( '.' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        tag : 'master',
      });
    });

    test.case = 'local - 0 and remote - 0';
    test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryTagToVersion
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        tag : '1c5607cbae0b62c8a0553b381b4052927cd40c32',
        local : 0,
        remote : 0,
      });
    });

    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) ) );
    a.shell( `git clone https://github.com/Wandalen/wModuleForTesting1.git` );
    return a.ready;
  }
}

repositoryTagToVersion.timeOut = 60000;

//

function repositoryVersionToTagWithOptionLocal( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* - */

  begin().then( () =>
  {
    test.case = 'version - hash of commit';
    _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      sync : 1,
      tag : 'v0.0.0',
      description : 'v0.0.0',
    });
    return null;
  });

  var initialCommitHash;
  a.ready.then( () =>
  {
    initialCommitHash = a.fileProvider.fileRead( a.abs( '.git/refs/heads/master' ) );
    initialCommitHash = initialCommitHash.trim();
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'file.txt' ), 'new data' );
    return null;
  });

  a.shell( 'git commit -am second' );

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : initialCommitHash,
      local : 1,
      remote : 0,
    });

    test.identical( got, 'v0.0.0' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'version - hash of tag';
    _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      sync : 1,
      tag : 'v0.0.0',
      description : 'v0.0.0',
    });
    return null;
  });

  var initialCommitHash;
  a.shell( 'git show-ref -s' )
  .then( ( op ) =>
  {
    let splits =  _.strSplitNonPreserving({ src : op.output, delimeter : '\n' });
    initialCommitHash = splits[ splits.length - 1 ].trim();
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'file.txt' ), 'new data' );
    return null;
  });

  a.shell( 'git commit -am second' );

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : initialCommitHash,
      local : 1,
      remote : 0,
    });

    test.identical( got, 'v0.0.0' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'version - last commit in branch, no tags except branch name';
    a.fileProvider.fileAppend( a.abs( 'file.txt' ), 'new data' );
    return null;
  });

  a.shell( 'git commit -am second' );

  var commitHash;
  a.ready.then( () =>
  {
    commitHash = a.fileProvider.fileRead( a.abs( '.git/refs/heads/master' ) );
    commitHash = commitHash.trim();
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : commitHash,
      local : 1,
      remote : 0,
    });

    test.identical( got, 'master' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'version - last commit in branch, branch name and tag';
    _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      sync : 1,
      tag : 'v0.0.0',
      description : 'v0.0.0',
    });
    return null;
  });

  var initialCommitHash;
  a.ready.then( () =>
  {
    initialCommitHash = a.fileProvider.fileRead( a.abs( '.git/refs/heads/master' ) );
    initialCommitHash = initialCommitHash.trim();
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : initialCommitHash,
      local : 1,
      remote : 0,
    });

    test.identical( got, [ 'master', 'v0.0.0' ] );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    if( !Config.debug )
    return;

    test.case = 'without arguments';
    test.shouldThrowErrorSync( () => _.git.repositoryVersionToTag() );

    test.case = 'extra arguments';
    test.shouldThrowErrorSync( () =>
    {
      let o = { localPath : a.abs( '.' ), local : 1, version : 'noMatterWhatHashIs' };
      return _.git.repositoryVersionToTag( o, o );
    });

    test.case = 'extra option in options map o';
    test.shouldThrowErrorSync( () =>
    {
      let o = { localPath : a.abs( '.' ), local : 1, version : 'noMatterWhatHashIs', unknown : 1 };
      return _.git.repositoryVersionToTag( o );
    });

    test.case = 'wrong type of o.localPath';
    test.shouldThrowErrorSync( () =>
    {
      let o = { localPath : 1, local : 1, version : 'noMatterWhatHashIs' };
      return _.git.repositoryVersionToTag( o );
    });

    test.case = 'o.localPath is not a repository';
    test.shouldThrowErrorSync( () =>
    {
      let o = { localPath : a.abs( '..' ), local : 1, version : 'noMatterWhatHashIs' };
      return _.git.repositoryVersionToTag( o );
    });

    test.case = 'wrong type of o.version';
    test.shouldThrowErrorSync( () =>
    {
      let o = { localPath : a.abs( '.' ), local : 1, version : 1 };
      return _.git.repositoryVersionToTag( o );
    });

    test.case = 'wrong type of o.remotePath';
    test.shouldThrowErrorSync( () =>
    {
      let o = { localPath : a.abs( '.' ), remote : 1, version : 'noMatterWhatHashIs', remotePath : 1 };
      return _.git.repositoryVersionToTag( o );
    });

    test.case = 'o.local and o.remote is false';
    test.shouldThrowErrorSync( () =>
    {
      let o = { localPath : a.abs( '.' ), local : 0, remote : 0, version : 'noMatterWhatHashIs' };
      return _.git.repositoryVersionToTag( o );
    });

    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( '.' ) ) );
    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( '.' ) );
      return null;
    });
    a.shell( `git init` );
    a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( 'file.txt' ), 'file.txt' );
      return null;
    });
    a.shell( 'git add .' );
    a.shell( 'git commit -m init' );
    return a.ready;
  }
}

repositoryVersionToTagWithOptionLocal.timeOut = 15000;

//

function repositoryVersionToTagWithOptionRemote( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  begin();

  /* */

  a.ready.then( () =>
  {
    test.case = 'version - hash of commit';
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : 'b6e306fd904c4aee13e104f4132ca70bb4f97fa6',
      local : 0,
      remote : 1,
    });

    test.identical( got, 'v0.0.99' );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'version - hash of tag';
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : 'd6f04471d8e33c5019343a791a635c205b500764',
      local : 0,
      remote : 1,
    });

    test.identical( got, 'v0.0.99' );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'version - last commit in branch';
    return null;
  });

  var commitHash;
  a.ready.then( () =>
  {
    commitHash = a.fileProvider.fileRead( a.abs( '.git/refs/heads/master' ) );
    commitHash = commitHash.trim();
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : commitHash,
      local : 0,
      remote : 1,
    });
    got = _.array.as( got );

    test.true( _.longHas( got, 'master' ) );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'version - hash of commit, define remote path';
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : 'b6e306fd904c4aee13e104f4132ca70bb4f97fa6',
      local : 0,
      remote : 1,
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
    });

    test.identical( got, 'v0.0.99' );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'version - hash of tag, define remote path';
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : 'd6f04471d8e33c5019343a791a635c205b500764',
      local : 0,
      remote : 1,
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
    });

    test.identical( got, 'v0.0.99' );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'version - last commit in branch, define remote path';
    return null;
  });

  var commitHash;
  a.ready.then( () =>
  {
    commitHash = a.fileProvider.fileRead( a.abs( '.git/refs/heads/master' ) );
    commitHash = commitHash.trim();
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : commitHash,
      local : 0,
      remote : 1,
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
    });
    got = _.array.as( got );

    test.true( _.longHas( got, 'master' ) );
    return null;
  });


  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( a.abs( '.' ) );
      return null;
    });

    a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git ./' );
    return a.ready;
  }
}

repositoryVersionToTagWithOptionRemote.timeOut = 60000;

//

function repositoryVersionToTagWithOptionsRemoteAndLocal( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* - */

  begin().then( () =>
  {
    test.case = 'version - hash of commit';
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : 'b6e306fd904c4aee13e104f4132ca70bb4f97fa6',
      local : 1,
      remote : 1,
    });

    test.identical( got, 'v0.0.99' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'version - hash of tag';
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : 'd6f04471d8e33c5019343a791a635c205b500764',
      local : 1,
      remote : 1,
    });

    test.identical( got, 'v0.0.99' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'version - last commit in branch';
    return null;
  });

  var commitHash;
  a.ready.then( () =>
  {
    commitHash = a.fileProvider.fileRead( a.abs( '.git/refs/heads/master' ) );
    commitHash = commitHash.trim();
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.repositoryVersionToTag
    ({
      localPath : a.abs( '.' ),
      version : commitHash,
      local : 1,
      remote : 1,
    });
    got = _.array.as( got );

    test.true( _.longHas( got, 'master' ) );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( a.abs( '.' ) );
      return null;
    });

    a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git ./' );
    return a.ready;
  }
}

repositoryVersionToTagWithOptionsRemoteAndLocal.timeOut = 15000;

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
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.true( _.strHas( hookRead, specialComment ) )

      test.will = 'hook handler was created'
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      let customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'copy of original hook does not exist';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      return null;
    })

    shell( 'git commit --allow-empty -m test' )

    con.then( ( got ) =>
    {
      test.will = 'custom handler was executed after git commit';
      test.true( _.strHas( got.output, 'Custom handler executed' ) );
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
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.true( _.strHas( hookRead, specialComment ) )

      test.will = 'hook handler was created'
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      let customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'original hook was copied to .was';
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );
      let wasHook = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) + '.was' );
      test.identical( wasHook, originalUserHookCode );

      return null;
    })

    shell( 'git commit --allow-empty -m test' )

    con.then( ( got ) =>
    {
      test.will = 'original handler was executed after git commit';
      test.true( _.strHas( got.output, 'Original user hook' ) );
      test.will = 'custom handler was executed after git commit';
      test.true( _.strHas( got.output, 'Custom handler executed' ) );
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
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.true( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler exists'
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      var customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'second hook handler exists'
      test.true( a.fileProvider.fileExists( hookHandlerPath2 ) );
      var customHookRead = a.fileProvider.fileRead( hookHandlerPath2 );
      test.identical( customHookRead, handlerCode2 );

      test.will = 'copy of original hook does not exist';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      return null;
    })

    shell( 'git commit --allow-empty -m test' )

    con.then( ( got ) =>
    {
      test.will = 'custom handler1 was executed after git commit';
      test.true( _.strHas( got.output, 'Custom handler executed' ) );
      test.will = 'custom handler2 was executed after git commit';
      test.true( _.strHas( got.output, 'Custom handler2 executed' ) );
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

      /* */

      _.git.hookRegister
      ({
        repoPath : a.abs( 'repo' ),
        filePath : a.abs( hookName + '.source' ),
        hookName,
        handlerName : handlerName2,
        throwing : 1,
        rewriting : 0
      })

      /* */

      test.will = 'hook runner was created';
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.true( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler exists'
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      var customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode2 );

      test.will = 'second hook handler exists'
      test.true( a.fileProvider.fileExists( hookHandlerPath2 ) );
      var customHookRead = a.fileProvider.fileRead( hookHandlerPath2 );
      test.identical( customHookRead, handlerCode );

      test.will = 'copy of original hook does not exist';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      return null;
    })

    shell( 'git commit --allow-empty -m test' )

    con.then( ( got ) =>
    {
      test.will = 'custom handler was executed after git commit';
      test.true( _.strHas( got.output, 'Bad exit code handler executed' ) );
      test.will = 'custom handler2 was not executed after git commit';
      test.true( !_.strHas( got.output, 'Custom handler executed' ) );
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
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      var customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'copy of original hook does not exist';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.true( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler exists'
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      var customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'second hook handler does not exist'
      test.true( !a.fileProvider.fileExists( hookHandlerPath2 ) );

      test.will = 'copy of original hook does not exist';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

      return null;
    })

    shell( 'git commit --allow-empty -m test' )

    con.then( ( got ) =>
    {
      test.will = 'custom handler1 was executed after git commit';
      test.true( _.strHas( got.output, 'Custom handler executed' ) );
      test.will = 'custom handler2 should not be executed after git commit';
      test.true( !_.strHas( got.output, 'Custom handler2 executed' ) );
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
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'hook handler was not created'
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );

      test.will = 'copy of original hook was not created';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.true( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler stays'
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      let customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'copy of original hook was not created';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.true( _.strHas( hookRead, specialComment ) )

      test.will = 'first hook handler stays'
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      let customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'second hook handler does not exist'
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName2 ) ) );

      test.will = 'copy of original hook was not created';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );

      test.will = 'copy of original hook does not exist';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) ) );
      let hookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', hookName ) );
      test.true( _.strHas( hookRead, specialComment ) );

      test.will = 'first hook handler stays'
      test.true( a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', handlerName ) ) );
      let customHookRead = a.fileProvider.fileRead( a.abs( 'repo', './.git/hooks', handlerName ) );
      test.identical( customHookRead, handlerCode );

      test.will = 'copy of original hook was not created';
      test.true( !a.fileProvider.fileExists( a.abs( 'repo', './.git/hooks', hookName ) + '.was' ) );

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
    // let sourceCode = '#!/usr/bin/env node\n' + 'process.exit( 1 )';
    // let tempPath = _.process.tempOpen({ sourceCode });
    let routineCode = '#!/usr/bin/env node\n' + 'process.exit( 1 )';
    let tempPath = _.process.tempOpen({ routineCode });
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
    test.true( a.fileProvider.fileExists( a.abs( './.git/hooks/pre-commit' ) ) );
    test.true( a.fileProvider.fileExists( a.abs( './.git/hooks/pre-commit.commitHandler' ) ) );

    return null;
  })

  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git log -n 1' )

  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );
    test.true( _.strHas( got.output, `your current branch 'master' does not have any commits yet` ) );
    return got;
  })

  .then( () =>
  {
    test.true( a.fileProvider.fileExists( a.abs ( './.git/hooks/pre-commit' ) ) );
    test.true( a.fileProvider.fileExists( a.abs ( './.git/hooks/pre-commit.commitHandler' ) ) );

    _.git.hookUnregister
    ({
      repoPath : a.abs( '.' ),
      handlerName : 'pre-commit.commitHandler',
      force : 0,
      throwing : 1
    })

    test.true( a.fileProvider.fileExists( a.abs( './.git/hooks/pre-commit' ) ) );
    test.true( !a.fileProvider.fileExists( a.abs( './.git/hooks/pre-commit.commitHandler' ) ) );

    return null;
  })

  a.shell( 'git commit --allow-empty -m test' )
  a.shell( 'git log -n 1' )

  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    test.true( _.strHas( got.output, `test` ) );
    return got;
  });

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

  /* */

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

    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'a', 'dir/a' ] ) ), true ); /* aaa : for Dmytro : faile for me */ /* Dmytro : it is more global problem with resolving of modules. See https://github.com/Wandalen/wTools/pull/526 */
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'b', 'dir/b' ] ) ), true );
    test.identical( a.fileProvider.areHardLinked( a.path.s.join( a.abs( 'clone' ), [ 'c', 'dir/c' ] ) ), false );

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

  /* */

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

  /* */

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

function repositoryInit( test )
{
  if( !Config.debug )
  return test.true( true );

  test.shouldThrowErrorSync( () =>
  {
    _.git.repositoryInit
    ({
      localPath : null,
      remotePath : null,
      token : 'token',
      local : 1,
      sync : 1,
      remote : 1,
      dry : 1,
    });
  });

  test.shouldThrowErrorSync( () =>
  {
    _.git.repositoryInit
    ({
      localPath : null,
      remotePath : 'https://github.com/user/New2',
      token : 'token',
      local : 1,
      sync : 1,
      remote : 1,
      dry : 1,
    });
  });
}

//

function repositoryInitRemote( test )
{
  const a = test.assetFor( 'basic' );

  const token = process.env.PRIVATE_WTOOLS_BOT_TOKEN;
  const trigger = __.test.workflowTriggerGet( a.abs( __dirname, '../../../..' ) );
  if( !_.process.insideTestContainer() || trigger === 'pull_request' || !token )
  return test.true( true );

  const user = 'wtools-bot';
  const repository = `https://github.com/${ user }/New-${ _.number.intRandom( 1000000 ) }`;

  /* - */

  a.ready.then( () =>
  {
    test.case = 'create remote repository, dry - 1';
    a.reflect();
    return null;
  });
  a.ready.then( () =>
  {
    return _.git.repositoryInit
    ({
      remotePath : repository,
      localPath : a.routinePath,
      throwing : 1,
      logger : 0,
      dry : 1,
      description : 'Test',
      token,
    });
  }).delay( 3000 );
  a.ready.then( ( op ) =>
  {
    test.identical( op, null );
    return null;
  });
  repositoryDelete( repository ).delay( 3000 );

  /* */

  a.ready.then( () =>
  {
    test.case = 'create remote repository, dry - 0, logger - 0';
    a.reflect();
    return null;
  });
  a.ready.then( () =>
  {
    return _.git.repositoryInit
    ({
      remotePath : repository,
      localPath : a.routinePath,
      throwing : 1,
      logger : 0,
      dry : 0,
      description : 'Test',
      token,
    });
  }).delay( 3000 );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    test.true( _.git.isRepository({ remotePath : repository }) );
    return null;
  });
  repositoryDelete( repository ).delay( 3000 );

  /* */

  a.ready.then( () =>
  {
    test.case = 'create remote repository, dry - 0, logger - 2';
    a.reflect();
    return null;
  });
  a.ready.then( () =>
  {
    return _.git.repositoryInit
    ({
      remotePath : repository,
      localPath : a.routinePath,
      throwing : 1,
      logger : 2,
      dry : 0,
      description : 'Test',
      token,
    });
  }).delay( 3000 );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    test.true( _.git.isRepository({ remotePath : repository }) );
    return null;
  });
  repositoryDelete( repository ).delay( 3000 );

  /* */

  a.ready.then( () =>
  {
    test.case = 'create remote repository, dry - 0, logger - _.logger, logger verbosity - 2';
    a.reflect();
    return null;
  });
  a.ready.then( () =>
  {
    let logger = _global_.logger;
    logger.verbosity = 2;
    return _.git.repositoryInit
    ({
      remotePath : repository,
      localPath : a.routinePath,
      throwing : 1,
      logger,
      dry : 0,
      description : 'Test',
      token,
    });
  }).delay( 3000 );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    test.true( _.git.isRepository({ remotePath : repository }) );
    return null;
  });
  repositoryDelete( repository ).delay( 3000 );

  /* - */

  return a.ready;

  /* */

  function repositoryDelete( remotePath )
  {
    return a.ready.finally( () =>
    {
      return _.git.repositoryDelete
      ({
        remotePath,
        throwing : 0,
        logger : 1,
        dry : 0,
        token,
        attemptDelayMultiplier : 4,
      });
    });
  }
}

repositoryInitRemote.timeOut = 90000;

//

function repositoryDeleteRemote( test )
{
  const a = test.assetFor( 'basic' );

  const token = process.env.PRIVATE_WTOOLS_BOT_TOKEN;
  const trigger = __.test.workflowTriggerGet( a.abs( __dirname, '../../../..' ) );
  if( !_.process.insideTestContainer() || trigger === 'pull_request' || !token )
  return test.true( true );

  const user = 'wtools-bot';
  const repository = `https://github.com/${ user }/New-${ _.number.intRandom( 1000000 ) }`;

  /* - */

  a.ready.then( () =>
  {
    test.case = 'delete remote repository';
    a.reflect();
    return null;
  });
  repositoryForm().delay( 3000 );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    test.true( _.git.isRepository({ remotePath : repository }) );
    return null;
  });
  a.ready.then( () =>
  {
    return _.git.repositoryDelete
    ({
      remotePath : repository,
      throwing : 1,
      logger : 1,
      dry : 0,
      token,
    });
  }).delay( 3000 );
  a.ready.then( ( op ) =>
  {
    test.identical( op.data, undefined );
    test.identical( op.status, 204 );
    test.false( _.git.isRepository({ remotePath : repository }) );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function repositoryForm()
  {
    a.ready.then( () =>
    {
      return _.git.repositoryDelete
      ({
        remotePath : repository,
        throwing : 0,
        logger : 1,
        dry : 0,
        token,
      });
    }).delay( 3000 );
    a.ready.then( () =>
    {
      return _.git.repositoryInit
      ({
        remotePath : repository,
        localPath : a.routinePath,
        throwing : 1,
        logger : 0,
        dry : 0,
        description : 'Test',
        token,
      });
    });
    return a.ready;
  }
}

//

function repositoryDeleteCheckRetryOptions( test )
{
  const a = test.assetFor( 'basic' );

  const token = process.env.PRIVATE_WTOOLS_BOT_TOKEN;
  const trigger = __.test.workflowTriggerGet( a.abs( __dirname, '../../../..' ) );
  if( !_.process.insideTestContainer() || trigger === 'pull_request' || !token )
  return test.true( true );

  const user = 'wtools-bot';
  const repository = `https://github.com/${ user }/New-${ _.number.intRandom( 1000000 ) }`;

  /* - */

  a.ready.then( () =>
  {
    test.case = 'not default attemptLimit';
    return null;
  });
  a.ready.then( () =>
  {
    var onErrorCallback = ( err, arg ) =>
    {
      test.true( _.error.is( err ) );
      _.error.attend( err );
      test.identical( arg, undefined );
      test.identical( _.strCount( err.originalMessage, `Error code : ` ), 1 );
      var exp = `Attempts exhausted, made 4 attempts`;
      test.identical( _.strCount( err.originalMessage, exp ), 1 );
      return null;
    };
    return test.shouldThrowErrorAsync( () =>
    {
      return _.git.repositoryDelete
      ({
        remotePath : repository,
        throwing : 1,
        logger : 1,
        dry : 0,
        token,
        attemptLimit : 4,
      });
    }, onErrorCallback );
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'not default attemptDelay';
    return null;
  });
  a.ready.then( () =>
  {
    var start = _.time.now();
    var onErrorCallback = ( err, arg ) =>
    {
      var spent = _.time.now() - start;
      test.ge( spent, 2000 );
      test.true( _.error.is( err ) );
      _.error.attend( err );
      test.identical( arg, undefined );
      test.identical( _.strCount( err.originalMessage, `Error code : ` ), 1 );
      var exp = `Attempts exhausted, made 3 attempts`;
      test.identical( _.strCount( err.originalMessage, exp ), 1 );
      return null;
    };
    return test.shouldThrowErrorAsync( () =>
    {
      return _.git.repositoryDelete
      ({
        remotePath : repository,
        throwing : 1,
        logger : 1,
        dry : 0,
        token,
        attemptLimit : 3,
        attemptDelay : 1000,
      });
    }, onErrorCallback );
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'not default attemptDelayMultiplier';
    return null;
  });
  a.ready.then( () =>
  {
    var start = _.time.now();
    var onErrorCallback = ( err, arg ) =>
    {
      var spent = _.time.now() - start;
      test.ge( spent, 2000 );
      test.true( _.error.is( err ) );
      _.error.attend( err );
      test.identical( arg, undefined );
      test.identical( _.strCount( err.originalMessage, `Error code : ` ), 1 );
      var exp = `Attempts exhausted, made 3 attempts`;
      test.identical( _.strCount( err.originalMessage, exp ), 1 );
      return null;
    };
    return test.shouldThrowErrorAsync( () =>
    {
      return _.git.repositoryDelete
      ({
        remotePath : repository,
        throwing : 1,
        logger : 1,
        dry : 0,
        token,
        attemptLimit : 3,
        attemptDelay : 250,
        attemptDelayMultiplier : 8,
      });
    }, onErrorCallback );
  });

  /* - */

  return a.ready;
}

repositoryDeleteCheckRetryOptions.timeOut = 120000;

//

function repositoryClone( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* */

  begin().then( () =>
  {
    test.case = 'clone repository with https protocol, local';
    return _.git.repositoryClone
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
    return null;
  });

  begin().then( () =>
  {
    test.case = 'clone repository with https protocol, global';
    return _.git.repositoryClone
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https:///github.com/Wandalen/wModuleForTesting1.git',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'clone repository with https protocol with hash, local';
    return _.git.repositoryClone
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git#b6968a12',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
    return null;
  });

  begin().then( () =>
  {
    test.case = 'clone repository with https protocol with hash, global';
    return _.git.repositoryClone
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https:///github.com/Wandalen/wModuleForTesting1.git#b6968a12',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'clone repository with https protocol with tag, local';
    return _.git.repositoryClone
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git!master',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
    return null;
  });

  begin().then( () =>
  {
    test.case = 'clone repository with https protocol with tag, global';
    return _.git.repositoryClone
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https:///github.com/Wandalen/wModuleForTesting1.git!master',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'clone repository with https protocol with local vcs part, local';
    return _.git.repositoryClone
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git/out/wModuleForTesting1.out.will',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
    return null;
  });

  begin().then( () =>
  {
    test.case = 'clone repository with https protocol with local vcs part, global';
    return _.git.repositoryClone
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https:///github.com/Wandalen/wModuleForTesting1.git/out/wModuleForTesting1.out.will',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
    return null;
  });

  /* setup ssh agent */

  if( process.env.PRIVATE_WTOOLS_BOT_SSH_KEY )
  if( process.platform === 'linux' && _.process.insideTestContainer() && process.env.GITHUB_EVENT_NAME !== 'pull_request' )
  {
    a.ready.then( () => __.test.workflowSshAgentRun() );

    /* */

    begin().then( () =>
    {
      test.case = 'clone repository with git protocol, local';
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'git://git@github.com:Wandalen/wModuleForTesting1.git',
      });
    });
    a.ready.then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
      return null;
    });

    /* */

    begin().then( () =>
    {
      test.case = 'clone repository with git protocol, global';
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'git:///git@github.com:Wandalen/wModuleForTesting1.git',
      });
    });
    a.ready.then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
      return null;
    });

    /* */

    begin().then( () =>
    {
      test.case = 'clone repository with ssh protocol, local';
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'ssh://git@github.com/Wandalen/wModuleForTesting1.git',
      });
    });
    a.ready.then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
      return null;
    });

    /* */

    begin().then( () =>
    {
      test.case = 'clone repository with ssh protocol, global';
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'ssh:///git@github.com/Wandalen/wModuleForTesting1.git',
      });
    });
    a.ready.then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
      return null;
    });

    /* */

    begin().then( () =>
    {
      test.case = 'clone repository with git+https protocol, local';
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'git+https://github.com/Wandalen/wModuleForTesting1.git',
      });
    });
    a.ready.then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
      return null;
    });

    begin().then( () =>
    {
      test.case = 'clone repository with git+https protocol, global';
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git',
      });
    });
    a.ready.then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
      return null;
    });

    /* */

    begin().then( () =>
    {
      test.case = 'clone repository with git+ssh protocol, local';
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'git+ssh://git@github.com/Wandalen/wModuleForTesting1.git',
      });
    });
    a.ready.then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
      return null;
    });

    /* */

    begin().then( () =>
    {
      test.case = 'clone repository with git+ssh protocol, global';
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'git+ssh:///git@github.com/Wandalen/wModuleForTesting1.git',
      });
    });
    a.ready.then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.true( _.git.isRepository({ localPath : a.abs( 'wModuleForTesting1' ) }) );
      return null;
    });
  }

  /* - */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.repositoryClone() );

      test.case = 'extra arguments';
      var o = { localPath : a.abs( 'wModuleForTesting1' ), remotePath : 'https://github.com/Wandalen/wGitTools' };
      test.shouldThrowErrorSync( () => _.git.repositoryClone( o, o ) );

      test.case = 'wrong type of options map o';
      var o = [ a.abs( 'wModuleForTesting1' ), 'https://github.com/Wandalen/wGitTools' ];
      test.shouldThrowErrorSync( () => _.git.repositoryClone( o ) );

      test.case = 'unknown option in options map o';
      var o = { localPath : a.abs( 'wModuleForTesting1' ), remotePath : 'https://github.com/Wandalen/wGitTools', unknown : 1 };
      test.shouldThrowErrorSync( () => _.git.repositoryClone( o ) );

      test.case = 'o.localPath is not defined string';
      var o = { localPath : '', remotePath : 'https://github.com/Wandalen/wGitTools' };
      test.shouldThrowErrorSync( () => _.git.repositoryClone( o ) );

      test.case = 'wrong type of o.localPath';
      var o =
      {
        localPath : _.git.path.parse( a.abs( 'wModuleForTesting1' ) ),
        remotePath : 'https://github.com/Wandalen/wGitTools'
      };
      test.shouldThrowErrorSync( () => _.git.repositoryClone( o ) );

      test.case = 'o.remotePath is not defined string';
      var o = { localPath : a.abs( 'wModuleForTesting1' ), remotePath : '' };
      test.shouldThrowErrorSync( () => _.git.repositoryClone( o ) );

      test.case = 'wrong type of o.remotePath';
      var o = { localPath : a.abs( 'wModuleForTesting1' ), remotePath : [ 'https://github.com/Wandalen/wGitTools' ] };
      test.shouldThrowErrorSync( () => _.git.repositoryClone( o ) );

      return null;
    });

    /* */

    if( process.platform !== 'win32' && _.process.insideTestContainer() )
    {
      begin();
      a.shellNonThrowing( 'ssh-add -D' )
      .then( ( op ) =>
      {
        if( op.exitCode !== 0 )
        return test.true( true );

        /* aaa : for Dmytro : does not throw error for me */
        /* Dmytro : it is special test case for not existed ssh-identity. Ssh-identity removed by command `ssh-add -D`. If some ssh-identity added after command, then test case should not throw error */
        test.case = 'ssh protocol with implicit declaration';
        test.shouldThrowErrorSync( () =>
        {
          _.git.repositoryClone
          ({
            localPath : a.abs( 'wModuleForTesting1' ),
            remotePath : 'git@github.com:Wandalen/wModuleForTesting1.git',
            sync : 1,
          });
        });

        /* aaa : for Dmytro : does not throw error for me */
        /* Dmytro : it is special test case for not existed ssh-identity. Ssh-identity removed by command `ssh-add -D`. If some ssh-identity added after command, then test case should not throw error */
        test.case = 'ssh protocol with explicit declaration ';
        test.shouldThrowErrorSync( () =>
        {
          _.git.repositoryClone
          ({
            localPath : a.abs( 'wModuleForTesting1' ),
            remotePath : 'ssh://git@github.com/Wandalen/wModuleForTesting1.git',
            sync : 1,
          });
        });
        return null;
      });
    }
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) );
      return null;
    });
    return a.ready;
  }
}

repositoryClone.timeOut = 120000;

//

function repositoryCloneCheckRetryOptions( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  if( process.platform === 'win32' || process.platform === 'darwin' || !_.process.insideTestContainer() )
  return test.true( true );

  let netInterfaces = __.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
  a.ready.then( () => __.test.netInterfacesDown({ interfaces : netInterfaces }) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'default options';
    var onErrorCallback = ( err, arg ) =>
    {
      test.true( _.error.is( err ) );
      test.identical( arg, undefined );
      var exp = `Attempts exhausted, made 3 attempts`;
      test.identical( _.strCount( err.originalMessage, exp ), 1 );
      test.identical( _.strCount( err.originalMessage, `Could not resolve host` ), 1 );
      return null;
    };
    return test.shouldThrowErrorAsync
    (
      () =>
      {
        return _.git.repositoryClone
        ({
          localPath : a.abs( 'wModuleForTesting1' ),
          remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        });
      },
      onErrorCallback,
    );
  });

  a.ready.then( () =>
  {
    test.case = 'not default attemptLimit';
    var onErrorCallback = ( err, arg ) =>
    {
      test.true( _.error.is( err ) );
      test.identical( arg, undefined );
      test.identical( _.strCount( err.originalMessage, `Attempts exhausted, made 2 attempts` ), 1 );
      test.identical( _.strCount( err.originalMessage, `Could not resolve host` ), 1 );
      return null;
    };
    return test.shouldThrowErrorAsync
    (
      () =>
      {
        return _.git.repositoryClone
        ({
          localPath : a.abs( 'wModuleForTesting1' ),
          remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
          attemptLimit : 2,
        });
      },
      onErrorCallback,
    );
  });

  let start;
  a.ready.then( () =>
  {
    test.case = 'not default attemptDelay - 1000, not default attemptDelayMultiplier - 1';
    return test.shouldThrowErrorAsync( () =>
    {
      start = _.time.now();
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        attemptDelayMultiplier : 1,
        attemptDelay : 1000,
      });
    });
  });
  a.ready.then( () =>
  {
    let spent = _.time.now() - start;
    test.ge( spent, 1000 * _.git.repositoryClone.defaults.attemptLimit );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'not default attemptDelayMultiplier';
    return test.shouldThrowErrorAsync( () =>
    {
      start = _.time.now();
      return _.git.repositoryClone
      ({
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        attemptLimit : 4,
        attemptDelayMultiplier : 2,
      });
    });
  });
  a.ready.then( () =>
  {
    let spent = _.time.now() - start;
    let delay = _.git.repositoryClone.defaults.attemptDelay;
    test.ge( spent, delay + ( 2 * delay ) + ( 2 * 2 * delay ) );
    return null;
  });

  /* */

  a.ready.finally( () => __.test.netInterfacesUp({ interfaces : netInterfaces }) );

  /* - */

  return a.ready;
}

repositoryCloneCheckRetryOptions.timeOut = 60000;

//

function repositoryCheckout( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  a.ready.then( () =>
  {
    a.fileProvider.dirMake( a.abs( '.' ) );
    return _.git.repositoryClone
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      attemptLimit : 8,
      attemptDelay : 500,
      attemptDelayMultiplier : 2,
    });
  });

  /* - */

  checkout().then( () =>
  {
    test.case = 'remotePath - simple http path, without hash or tag';
    return _.git.repositoryCheckout
    ({
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'master' );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global http path, without hash or tag';
    return _.git.repositoryCheckout
    ({
      remotePath : 'https:///github.com/Wandalen/wModuleForTesting1.git',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'master' );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global path with several protocols, without hash or tag';
    return _.git.repositoryCheckout
    ({
      remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'master' );
    return null;
  });

  /* - */

  checkout();
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git branch -f new' });
  a.ready.then( () =>
  {
    test.case = 'remotePath - simple http path, checkout to newly created local branch';
    return _.git.repositoryCheckout
    ({
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git!new',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'new' );
    return null;
  });

  /* */

  checkout();
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git branch -f new' });
  a.ready.then( () =>
  {
    test.case = 'remotePath - global http path, checkout to newly created local branch';
    return _.git.repositoryCheckout
    ({
      remotePath : 'https:///github.com/Wandalen/wModuleForTesting1.git!new',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'new' );
    return null;
  });

  /* */

  checkout();
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git branch -f new' });
  a.ready.then( () =>
  {
    test.case = 'remotePath - global path with several protocols, checkout to newly created local branch';
    return _.git.repositoryCheckout
    ({
      remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git!new',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'new' );
    return null;
  });

  /* - */

  checkout().then( () =>
  {
    test.case = 'remotePath - simple http path, checkout to hash';
    return _.git.repositoryCheckout
    ({
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git#d7ef64cf6f3ff73eddba286961fa44e7748a14fc',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at d7ef64c' ), 1 );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global http path, checkout to hash';
    return _.git.repositoryCheckout
    ({
      remotePath : 'https:///github.com/Wandalen/wModuleForTesting1.git#d7ef64cf6f3ff73eddba286961fa44e7748a14fc',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at d7ef64c' ), 1 );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global path with several protocols, checkout to hash';
    return _.git.repositoryCheckout
    ({
      remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git#d7ef64cf6f3ff73eddba286961fa44e7748a14fc',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at d7ef64c' ), 1 );
    return null;
  });

  /* - */

  checkout().then( () =>
  {
    test.case = 'remotePath - simple http path, checkout to tag';
    return _.git.repositoryCheckout
    ({
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git!v0.0.101',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at v0.0.101' ), 1 );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global http path, checkout to tag';
    return _.git.repositoryCheckout
    ({
      remotePath : 'https:///github.com/Wandalen/wModuleForTesting1.git!v0.0.101',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at v0.0.101' ), 1 );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global path with several protocols, checkout to tag';
    return _.git.repositoryCheckout
    ({
      remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git!v0.0.101',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at v0.0.101' ), 1 );
    return null;
  });

  /* - */

  checkout().then( () =>
  {
    test.case = 'remotePath - simple http path, checkout to branch which exists only on remote server';
    return _.git.repositoryCheckout
    ({
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git!dev1',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'dev1' );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global http path, checkout to branch which exists only on remote server';
    return _.git.repositoryCheckout
    ({
      remotePath : 'https:///github.com/Wandalen/wModuleForTesting1.git!dev1',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'dev1' );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global path with several protocols, checkout to branch which exists only on remote server';
    return _.git.repositoryCheckout
    ({
      remotePath : 'git+https:///github.com/Wandalen/wModuleForTesting1.git!dev1',
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'dev1' );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    checkout().then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.repositoryCheckout() );

      test.case = 'extra arguments';
      var o =
      {
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git'
      };
      test.shouldThrowErrorSync( () => _.git.repositoryCheckout( o, o ) );

      test.case = 'options map has unknown options';
      var o =
      {
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
        unknown : 1,
      };
      test.shouldThrowErrorSync( () => _.git.repositoryCheckout( o ) );

      test.case = 'o.localPath is empty string';
      var o =
      {
        localPath : '',
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      };
      test.shouldThrowErrorSync( () => _.git.repositoryCheckout( o ) );

      test.case = 'wrong type of o.localPath';
      var o =
      {
        localPath : [ a.abs( 'wModuleForTesting1' ) ],
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
      };
      test.shouldThrowErrorSync( () => _.git.repositoryCheckout( o ) );

      test.case = 'o.remotePath is empty string';
      var o =
      {
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : '',
      };
      test.shouldThrowErrorSync( () => _.git.repositoryCheckout( o ) );

      test.case = 'wrong type of o.remotePath';
      var o =
      {
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : [ 'https://github.com/Wandalen/wModuleForTesting1.git' ],
      };
      test.shouldThrowErrorSync( () => _.git.repositoryCheckout( o ) );

      test.case = 'local directory is not a git repository, path with tag';
      a.fileProvider.dirMake( a.abs( 'wModuleForTesting12' ) );
      var o =
      {
        localPath : a.abs( 'wModuleForTesting12' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting12.git!master',
      };
      test.shouldThrowErrorAsync( () => _.git.repositoryCheckout( o ) );

      test.case = 'local and remote repository has no tag';
      var o =
      {
        localPath : a.abs( 'wModuleForTesting1' ),
        remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git!unknown',
      };
      test.shouldThrowErrorAsync( () => _.git.repositoryCheckout( o ) );
      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function checkout()
  {
    return a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git checkout master' });
  }
}

repositoryCheckout.timeOut = 30000;

//

function repositoryCheckoutRemotePathIsMap( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  a.ready.then( () =>
  {
    a.fileProvider.dirMake( a.abs( '.' ) )
    return _.git.repositoryClone
    ({
      localPath : a.abs( 'wModuleForTesting1' ),
      remotePath : 'https://github.com/Wandalen/wModuleForTesting1.git',
    });
  });

  /* - */

  // aaa : for Dmytro : for Vova : fail!
  //  > git branch --show-current
  // error: unknown option `show-current'
  /* Dmytro : if version of Git < 2.22, then this option does not supports by utility */

  checkout().then( () =>
  {
    test.case = 'remotePath - simple http path, without hash or tag';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'master' );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global http path, without hash or tag';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'https:///github.com/Wandalen/wModuleForTesting1.git' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'master' );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global path with several protocols, without hash or tag';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'master' );
    return null;
  });

  /* - */

  checkout();
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git branch -f new' })
  .then( () =>
  {
    test.case = 'remotePath - simple http path, checkout to newly created local branch';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git!new' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'new' );
    return null;
  });

  /* */

  checkout();
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git branch -f new' })
  .then( () =>
  {
    test.case = 'remotePath - global http path, checkout to newly created local branch';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'https:///github.com/Wandalen/wModuleForTesting1.git!new' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'new' );
    return null;
  });

  /* */

  checkout();
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git branch -f new' })
  .then( () =>
  {
    test.case = 'remotePath - global path with several protocols, checkout to newly created local branch';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git!new' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'new' );
    return null;
  });

  /* - */

  checkout().then( () =>
  {
    test.case = 'remotePath - simple http path, checkout to hash';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git#d7ef64cf6f3ff73eddba286961fa44e7748a14fc' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at d7ef64c' ), 1 );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global http path, checkout to hash';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'https:///github.com/Wandalen/wModuleForTesting1.git#d7ef64cf6f3ff73eddba286961fa44e7748a14fc' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at d7ef64c' ), 1 );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global path with several protocols, checkout to hash';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git#d7ef64cf6f3ff73eddba286961fa44e7748a14fc' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at d7ef64c' ), 1 );
    return null;
  });

  /* - */

  checkout().then( () =>
  {
    test.case = 'remotePath - simple http path, checkout to tag';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git!v0.0.101' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at v0.0.101' ), 1 );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global http path, checkout to tag';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'https:///github.com/Wandalen/wModuleForTesting1.git!v0.0.101' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at v0.0.101' ), 1 );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global path with several protocols, checkout to tag';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git!v0.0.101' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git status' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'HEAD detached at v0.0.101' ), 1 );
    return null;
  });

  /* - */

  checkout().then( () =>
  {
    test.case = 'remotePath - simple http path, checkout to branch which exists only on remote server';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'https://github.com/Wandalen/wModuleForTesting1.git!dev1' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'dev1' );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global http path, checkout to branch which exists only on remote server';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'https:///github.com/Wandalen/wModuleForTesting1.git!dev1' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'dev1' );
    return null;
  });

  /* */

  checkout().then( () =>
  {
    test.case = 'remotePath - global path with several protocols, checkout to branch which exists only on remote server';
    return _.git.repositoryCheckout
    ({
      remotePath : _.git.path.parse( 'git+https:///github.com/Wandalen/wModuleForTesting1.git!dev1' ),
      localPath : a.abs( 'wModuleForTesting1' ),
    });
  });
  a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git rev-parse --abbrev-ref HEAD' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, 'dev1' );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function checkout()
  {
    return a.shell({ currentPath : a.abs( 'wModuleForTesting1' ), execPath : 'git checkout master' });
  }
}

repositoryCheckoutRemotePathIsMap.timeOut = 30000;

//

function repositoryAgree( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  begin().then( () =>
  {
    test.case = 'migrate same repository with same branches, no state, message';
    return _.git.repositoryAgree
    ({
      srcBasePath : dstRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : null,
      dstBranch : 'master',
      commitMessage : null,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'migrate same repository with same branches, state - previous commit, no message';
    return _.git.repositoryAgree
    ({
      srcBasePath : dstRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#HEAD~',
      dstBranch : 'master',
      commitMessage : null,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'migrate another repository with same branches, no state, message, strategy - dst';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : null,
      dstBranch : 'master',
      mergeStrategy : 'dst',
      commitMessage : null,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }
}

//

function repositoryAgreeWithLocalRepository( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  begin().then( () =>
  {
    test.case = 'migrate another repository with same branches, no state, message, strategy - dst';
    return _.git.repositoryAgree
    ({
      srcBasePath : a.abs( '../repo' ),
      dstBasePath : a.abs( '.' ),
      srcState : null,
      dstBranch : 'master',
      mergeStrategy : 'dst',
      commitMessage : null,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'state - hash';
    return _.git.repositoryAgree
    ({
      srcBasePath : a.abs( '../repo' ),
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.ready.finally( ( err, op ) =>
  {
    test.identical( err, undefined );
    test.identical( op, true );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '../repo' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    return a.shell( `git clone ${ srcRepositoryRemote } ../repo` );
  }
}

//

function repositoryAgreeWithNotARepository( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  begin().then( () =>
  {
    test.case = 'agree directory with same files';
    return _.git.repositoryAgree
    ({
      srcBasePath : a.abs( '../repo' ),
      dstBasePath : a.abs( './!master' ),
      srcState : null,
      mergeStrategy : 'src',
      commitMessage : null,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '../repo' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    a.shell( `git clone ${ srcRepositoryRemote } ../repo` );
    return a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '../repo/.git' ) ); return null });
  }
}

//

function repositoryAgreeWithOptionMergeStrategy( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  begin().then( () =>
  {
    test.case = 'strategy - manual';
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : null,
      dstBranch : 'master',
      mergeStrategy : 'manual',
      commitMessage : '__sync__',
    });
  });
  a.ready.finally( ( err, op ) =>
  {
    test.true( _.error.is( err ) );
    _.error.attend( err );
    test.identical( _.strCount( err.originalMessage, 'Process returned exit code' ), 1 );
    var exp = 'Launched as "git merge -s recursive --allow-unrelated-histories --squash';
    test.identical( _.strCount( err.originalMessage, exp ), 1 );
    test.identical( op, undefined );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    var config = a.fileProvider.fileRead( a.abs( 'package.json' ) );
    test.ge( _.strCount( config, 'wmodulefortesting1' ), 1 );
    test.ge( _.strCount( config, 'wmodulefortesting2' ), 1 );
    test.ge( _.strCount( config, '<<<<' ), 1 );
    test.ge( _.strCount( config, '====' ), 1 );
    test.ge( _.strCount( config, '>>>>' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'strategy - dst';
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : null,
      dstBranch : 'master',
      mergeStrategy : 'dst',
      commitMessage : '__sync__',
    });
  });
  a.ready.finally( ( err, op ) =>
  {
    test.identical( err, undefined );
    test.identical( op, true );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 1 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'strategy - src';
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : null,
      dstBranch : 'master',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
    });
  });
  a.ready.finally( ( err, op ) =>
  {
    test.identical( err, undefined );
    test.identical( op, true );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 1 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    if( !Config.debug )
    return null;

    test.case = 'wrong strategy';
    return test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        srcState : null,
        dstBranch : 'master',
        mergeStrategy : 'wrong',
        commitMessage : '__sync__',
      });
    });
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }
}

//

function repositoryAgreeWithOptionCommitMessage( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  begin();
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    test.identical( _.strCount( op.output, `Merge branch 'master' of ${ srcRepositoryRemote } into master` ), 0 );
    return null;
  });
  a.ready.then( () =>
  {
    test.case = 'no commit message';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : null,
      dstBranch : 'master',
      mergeStrategy : 'dst',
      commitMessage : null,
    });
  });
  a.ready.finally( ( err, op ) =>
  {
    test.identical( err, undefined );
    test.identical( op, true );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    test.identical( _.strCount( op.output, `Merge branch master of ${ srcRepositoryRemote } into master` ), 1 );
    return null;
  });

  /* */

  begin();
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    test.identical( _.strCount( op.output, `Merge branch master of ${ srcRepositoryRemote } into master` ), 0 );
    return null;
  });
  a.ready.then( () =>
  {
    test.case = 'no commit message';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : null,
      dstBranch : 'master',
      mergeStrategy : 'dst',
      commitMessage : '__sync__',
    });
  });
  a.ready.finally( ( err, op ) =>
  {
    test.identical( err, undefined );
    test.identical( op, true );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 1 );
    test.identical( _.strCount( op.output, `Merge branch master of ${ srcRepositoryRemote } into master` ), 0 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    if( !Config.debug )
    return null;

    test.case = 'wrong type of commit message';
    return test.shouldThrowErrorSync( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        srcState : null,
        dstBranch : null,
        mergeStrategy : 'dst',
        commitMessage : [ 'wrong' ],
      });
    });
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }
}

repositoryAgreeWithOptionCommitMessage.timeOut = 60000;

//

function repositoryAgreeWithOptionSrcState( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  let previousVersion;
  begin().then( () =>
  {
    test.case = 'state - not defined';
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    previousVersion = config.version;

    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : null,
      dstBranch : 'master',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
    });
  });
  a.ready.finally( ( err, op ) =>
  {
    test.identical( err, undefined );
    test.identical( op, true );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.notIdentical( config.version, previousVersion );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'state - hash';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.ready.finally( ( err, op ) =>
  {
    test.identical( err, undefined );
    test.identical( op, true );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'state - tag';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '!v0.0.170',
      dstBranch : 'master',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.ready.finally( ( err, op ) =>
  {
    test.identical( err, undefined );
    test.identical( op, true );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }
}

//

function repositoryAgreeWithOptionOnly( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  let filesBefore;
  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'only - string without glob';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      only : 'package.json',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'package.json' );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'only - string with glob';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      only : '*package.json',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'package.json\nwas.package.json' );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'only - array, contains strings with and without glob';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      only : [ '*package.json', 'will.yml' ],
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'package.json\nwas.package.json\nwill.yml' );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }
}

repositoryAgreeWithOptionOnly.timeOut = 60000;

//

function repositoryAgreeWithOptionBut( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  let filesBefore;
  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'but - string without glob';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      but : 'package.json',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.split( '\n' );
    test.false( _.longHas( files, 'package.json' ) );
    test.true( _.longHas( files, 'was.package.json' ) );
    test.true( _.longHas( files, 'will.yml' ) );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'but - string with glob';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      but : '*package.json',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.split( '\n' );
    test.false( _.longHas( files, 'package.json' ) );
    test.false( _.longHas( files, 'was.package.json' ) );
    test.true( _.longHas( files, 'will.yml' ) );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'but - array, contains strings with and without glob';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      but : [ '*package.json', 'will.yml' ],
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.split( '\n' );
    test.false( _.longHas( files, 'package.json' ) );
    test.false( _.longHas( files, 'was.package.json' ) );
    test.false( _.longHas( files, 'will.yml' ) );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting1' );
    test.identical( config.about.version, '0.0.1' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }
}

repositoryAgreeWithOptionBut.timeOut = 60000;

//

function repositoryAgreeWithOptionSrcDirPath( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  let filesBefore;
  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'srcDirPath - current dir, dot, no only';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      srcDirPath : '.',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let files = op.output.trim().split( '\n' );
    test.identical( files.length, 14 );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'srcDirPath - current dir, dot with slash, no only';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      srcDirPath : './',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let files = op.output.trim().split( '\n' );
    test.identical( files.length, 14 );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'srcDirPath - nested dir, no only';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      srcDirPath : './proto',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    var exp = [ 'proto/node_modules/wmodulefortesting2', 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s' ];
    test.identical( files, exp );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* - */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'srcDirPath - current dir, dot, with only';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      srcDirPath : '.',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      only : '**/*.s',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    var exp = [ 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s', 'sample/trivial/Sample.s' ];
    test.identical( files, exp );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'srcDirPath - current dir, dot and slash, with only';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      srcDirPath : './',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      only : '**/*.s',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    var exp = [ 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s', 'sample/trivial/Sample.s' ];
    test.identical( files, exp );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'srcDirPath - nested dir, with only';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      srcDirPath : 'proto',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      only : '**/*.s',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    var exp = [ 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s' ];
    test.identical( files, exp );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }
}

repositoryAgreeWithOptionSrcDirPath.timeOut = 60000;

//

function repositoryAgreeWithOptionDstDirPath( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  let filesBefore;
  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'dstDirPath - current dir';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      dstDirPath : './',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 14 );
    test.identical( _.path.common( files ), '.' );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'dstDirPath - nested existed dir';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      dstDirPath : 'proto',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 19 );
    test.identical( _.path.common( files ), 'proto/' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'dstDirPath - nested not existed dir';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      dstDirPath : 'dev',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 19 );
    test.identical( _.path.common( files ), 'dev/' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* - */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'dstDirPath - nested existed dir, with srcDirPath';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      srcDirPath : 'proto',
      dstDirPath : 'proto',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    var exp =
    [
      'proto/proto/node_modules/wmodulefortesting2',
      'proto/proto/wtools/testing/Common.s',
      'proto/proto/wtools/testing/l2/testing2/ModuleForTesting2.s',
    ];
    test.identical( files, exp );
    test.identical( _.path.common( files ), 'proto/proto/' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'dstDirPath - nested existed dir, with only';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      dstDirPath : 'proto',
      only : './proto/**',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    var exp =
    [
      'proto/proto/node_modules/wmodulefortesting2',
      'proto/proto/wtools/testing/Common.s',
      'proto/proto/wtools/testing/l2/testing2/ModuleForTesting2.s',
    ];
    test.identical( files, exp );
    test.identical( _.path.common( files ), 'proto/proto/' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'dstDirPath - nested not existed dir, with srcDirPath';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      srcDirPath : 'proto',
      dstDirPath : 'dev',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    var exp =
    [
      'dev/proto/node_modules/wmodulefortesting2',
      'dev/proto/wtools/testing/Common.s',
      'dev/proto/wtools/testing/l2/testing2/ModuleForTesting2.s',
    ];
    test.identical( files, exp );
    test.identical( _.path.common( files ), 'dev/proto/' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* */

  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'dstDirPath - nested not existed dir, with only';
    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      dstBranch : 'master',
      dstDirPath : 'dev',
      only : './proto/**',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    var exp =
    [
      'dev/proto/node_modules/wmodulefortesting2',
      'dev/proto/wtools/testing/Common.s',
      'dev/proto/wtools/testing/l2/testing2/ModuleForTesting2.s',
    ];
    test.identical( files, exp );
    test.identical( _.path.common( files ), 'dev/proto/' );

    var filesAfter = a.find( a.abs( './' ) );
    test.notIdentical( filesBefore, filesAfter );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }
}

repositoryAgreeWithOptionDstDirPath.timeOut = 120000;

//

function repositoryAgreeWithSingleRepository( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';

  /* - */

  let filesBefore;
  begin().then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'branch has older history, no rewriting';
    return _.git.repositoryAgree
    ({
      srcBasePath : dstRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#3e572f8a86482e419f23b2eb387b5b4852e62b1c',
      dstBranch : 'master',
      dstDirPath : './',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 3 );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    return null;
  });

  /* */

  begin();
  a.shell( 'git reset --hard 87c79885972d81638dc3a8b8a9be63ee64cd9e81' );
  a.ready.then( () =>
  {
    filesBefore = a.find( a.abs( './' ) );
    test.case = 'branch has newer history, rewriting';
    return _.git.repositoryAgree
    ({
      srcBasePath : dstRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#3e572f8a86482e419f23b2eb387b5b4852e62b1c',
      dstBranch : 'master',
      dstDirPath : './',
      mergeStrategy : 'src',
      commitMessage : '__sync__',
      relative : 'now',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 3 );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.171' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.171' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }
}

//

function repositoryAgreeWithOptionLogger( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  begin({ srcRepositoryRemote, logger : 0 }).then( () =>
  {
    test.case = 'logger - 0';
    return null;
  });
  a.shell( 'node testApp' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'doc/ModuleForTesting2.md' ), 0 );
    test.identical( _.strCount( op.output, 'out/wModuleForTesting2.out.will.yml' ), 0 );
    test.identical( _.strCount( op.output, 'proto/node_modules/wmodulefortesting2' ), 0 );
    test.identical( _.strCount( op.output, 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s' ), 0 );
    return null;
  });

  /* */

  begin({ srcRepositoryRemote, logger : 1 }).then( () =>
  {
    test.case = 'logger - 1';
    return null;
  });
  a.shell( 'node testApp' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'doc/ModuleForTesting2.md' ), 0 );
    test.identical( _.strCount( op.output, 'out/wModuleForTesting2.out.will.yml' ), 0 );
    test.identical( _.strCount( op.output, 'proto/node_modules/wmodulefortesting2' ), 0 );
    test.identical( _.strCount( op.output, 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s' ), 0 );
    return null;
  });

  /* */

  begin({ srcRepositoryRemote, logger : 2 }).then( () =>
  {
    test.case = 'logger - 2';
    return null;
  });
  a.shell( 'node testApp' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'doc/ModuleForTesting2.md' ), 1 );
    test.identical( _.strCount( op.output, 'out/wModuleForTesting2.out.will.yml' ), 1 );
    test.identical( _.strCount( op.output, 'proto/node_modules/wmodulefortesting2' ), 1 );
    test.identical( _.strCount( op.output, 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin( locals )
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    a.ready.then( () => a.program({ entry : testApp, locals }));
    return a.ready;
  }

  /* */

  function testApp()
  {
    const _ = require( toolsPath );
    _.include( 'wGitTools' );

    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : __dirname,
      srcState : null,
      dstBranch : 'master',
      mergeStrategy : 'dst',
      commitMessage : null,
      relative : 'now',
      logger,
    });
  }
}

//

function repositoryAgreeWithOptionDry( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  begin({ srcRepositoryRemote, dry : 0 }).then( () =>
  {
    test.case = 'dry - 0';
    test.false( a.fileProvider.fileExists( a.abs( 'doc/ModuleForTesting2.md' ) ) );
    test.false( a.fileProvider.fileExists( a.abs( 'out/wModuleForTesting2.out.will.yml' ) ) );
    test.false( a.fileProvider.fileExists( a.abs( 'proto/node_modules/wmodulefortesting2' ) ) );
    test.false( a.fileProvider.fileExists( a.abs( 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s' ) ) );
    return null;
  });
  a.shell( 'node testApp' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'doc/ModuleForTesting2.md' ), 1 );
    test.identical( _.strCount( op.output, 'out/wModuleForTesting2.out.will.yml' ), 1 );
    test.identical( _.strCount( op.output, 'proto/node_modules/wmodulefortesting2' ), 1 );
    test.identical( _.strCount( op.output, 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s' ), 1 );

    test.true( a.fileProvider.fileExists( a.abs( 'doc/ModuleForTesting2.md' ) ) );
    test.true( a.fileProvider.fileExists( a.abs( 'out/wModuleForTesting2.out.will.yml' ) ) );
    test.true( a.fileProvider.fileExists( a.abs( 'proto/node_modules/wmodulefortesting2' ) ) );
    test.true( a.fileProvider.fileExists( a.abs( 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s' ) ) );
    return null;
  });

  /* */

  begin({ srcRepositoryRemote, dry : 1 }).then( () =>
  {
    test.case = 'dry - 1';
    test.false( a.fileProvider.fileExists( a.abs( 'doc/ModuleForTesting2.md' ) ) );
    test.false( a.fileProvider.fileExists( a.abs( 'out/wModuleForTesting2.out.will.yml' ) ) );
    test.false( a.fileProvider.fileExists( a.abs( 'proto/node_modules/wmodulefortesting2' ) ) );
    test.false( a.fileProvider.fileExists( a.abs( 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s' ) ) );
    return null;
  });
  a.shell( 'node testApp' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'doc/ModuleForTesting2.md' ), 1 );
    test.identical( _.strCount( op.output, 'out/wModuleForTesting2.out.will.yml' ), 1 );
    test.identical( _.strCount( op.output, 'proto/node_modules/wmodulefortesting2' ), 1 );
    test.identical( _.strCount( op.output, 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s' ), 1 );

    test.false( a.fileProvider.fileExists( a.abs( 'doc/ModuleForTesting2.md' ) ) );
    test.false( a.fileProvider.fileExists( a.abs( 'out/wModuleForTesting2.out.will.yml' ) ) );
    test.false( a.fileProvider.fileExists( a.abs( 'proto/node_modules/wmodulefortesting2' ) ) );
    test.false( a.fileProvider.fileExists( a.abs( 'proto/wtools/testing/l2/testing2/ModuleForTesting2.s' ) ) );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin( locals )
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    a.ready.then( () => a.program({ entry : testApp, locals }));
    return a.ready;
  }

  /* */

  function testApp()
  {
    const _ = require( toolsPath );
    _.include( 'wGitTools' );

    return _.git.repositoryAgree
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : __dirname,
      srcState : null,
      dstBranch : 'master',
      mergeStrategy : 'dst',
      commitMessage : null,
      relative : 'now',
      logger : 2,
      dry,
    });
  }
}

//

function repositoryAgreeWithOptionDelay( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  let originalHead;
  begin().then( () =>
  {
    test.case = 'relative - commit, delta - 0';
    return _.git.repositoryAgree
    ({
      srcBasePath : dstRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#711c1496422c88395a2d83c4f9c91512322a3b99~',
      dstBranch : 'master',
      commitMessage : null,
      relative : 'commit',
      delta : 0,
    });
  });
  a.ready.then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#HEAD',
      state2 : '#HEAD',
    });
    return null;
  });
  a.ready.then( ( commits ) =>
  {
    const head = commits[ 0 ];
    originalHead = head;
    test.identical( head.date, '2021-12-17 10:10:57 +0200' );
    test.identical( head.date, head.commiterDate );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, delta - -1h';
    return _.git.repositoryAgree
    ({
      srcBasePath : dstRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#711c1496422c88395a2d83c4f9c91512322a3b99~',
      dstBranch : 'master',
      commitMessage : null,
      relative : 'commit',
      delta : '-01:00:00',
    });
  });
  a.ready.then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#HEAD',
      state2 : '#HEAD',
    });
    return null;
  });
  a.ready.then( ( commits ) =>
  {
    const head = commits[ 0 ];
    test.identical( Date.parse( originalHead.date ) - Date.parse( head.date ), 3600000 );
    test.identical( head.date, head.commiterDate );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, delta - -1h';
    return _.git.repositoryAgree
    ({
      srcBasePath : dstRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#711c1496422c88395a2d83c4f9c91512322a3b99~',
      dstBranch : 'master',
      commitMessage : null,
      relative : 'commit',
      delta : '01:00:00',
    });
  });
  a.ready.then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#HEAD',
      state2 : '#HEAD',
    });
    return null;
  });
  a.ready.then( ( commits ) =>
  {
    const head = commits[ 0 ];
    test.identical( Date.parse( head.date ) - Date.parse( originalHead.date ), 3600000 );
    test.identical( head.date, head.commiterDate );
    return null;
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'relative - now, delta - 0';
    return _.git.repositoryAgree
    ({
      srcBasePath : dstRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#HEAD~',
      dstBranch : 'master',
      commitMessage : null,
      relative : 'now',
      delta : 0,
    });
  });
  a.ready.then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#HEAD',
      state2 : '#HEAD',
    });
    return null;
  });
  a.ready.then( ( commits ) =>
  {
    const head = commits[ 0 ];
    test.ge( Date.parse( head.date ) + 20000, _.time.now() );
    test.identical( head.date, head.commiterDate );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - now, delta - -1h';
    return _.git.repositoryAgree
    ({
      srcBasePath : dstRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#HEAD~',
      dstBranch : 'master',
      commitMessage : null,
      relative : 'now',
      delta : '-01:00:00',
    });
  });
  a.ready.then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#HEAD',
      state2 : '#HEAD',
    });
    return null;
  });
  a.ready.then( ( commits ) =>
  {
    const head = commits[ 0 ];
    test.ge( Date.parse( head.date ) + 20000, _.time.now() - 3600000 );
    test.identical( head.date, head.commiterDate );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - now, delta - -1h';
    return _.git.repositoryAgree
    ({
      srcBasePath : dstRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState : '#HEAD~',
      dstBranch : 'master',
      commitMessage : null,
      relative : 'now',
      delta : '01:00:00',
    });
  });
  a.ready.then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#HEAD',
      state2 : '#HEAD',
    });
    return null;
  });
  a.ready.then( ( commits ) =>
  {
    const head = commits[ 0 ];
    test.ge( Date.parse( head.date ) + 20000, _.time.now() + 3600000 );
    test.identical( head.date, head.commiterDate );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }
}

repositoryAgreeWithOptionDelay.timeOut = 60000;

//

function repositoryMigrate( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  begin();
  agree( '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.170' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }

  /* */

  function agree( state )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        srcState : state,
        dstBranch : 'master',
        mergeStrategy : 'src',
        relative : 'commit',
        delta : '1980:00:00',
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( '.' ),
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }
}

//

function repositoryMigrateWithLocalRepository( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  begin().then( () =>
  {
    test.case = 'sync branches `master` of local repositories, branches as options';
    return null;
  });
  agree( '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.170' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : a.abs( '../repo' ),
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'sync different branches of local repositories, branches in paths';
    return null;
  });
  agree( '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.shell({ currentPath : a.abs( '../repo' ), execPath : 'git checkout -b dev origin/dev' })
  a.shell({ currentPath : a.abs( '../repo' ), execPath : 'git checkout master' })
  a.ready.then( () =>
  {
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.170' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : a.abs( '../repo!dev' ),
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      onCommitMessage : '__sync__',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'sync different branches of local repositories, branches in paths';
    return null;
  });
  a.shell( 'git switch -c dev1 origin/dev1' );
  a.shell( `git reset --hard ${ dstCommit }` );
  agree( '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd', 'dev1' );
  a.shell({ currentPath : a.abs( '../repo' ), execPath : 'git checkout -b dev origin/dev' })
  a.shell({ currentPath : a.abs( '../repo' ), execPath : 'git checkout master' })
  a.ready.then( () =>
  {
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.170' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : a.abs( '../repo!dev' ),
      dstBasePath : a.abs( './!dev1' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      onCommitMessage : '__sync__',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20 --branches dev1 --not master' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '../repo' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    return a.shell( `git clone ${ srcRepositoryRemote } ../repo` );
  }

  /* */

  function agree( state, branch )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : a.abs( '../repo' ),
        dstBasePath : a.abs( '.' ),
        srcState : state,
        dstBranch : branch || 'master',
        mergeStrategy : 'src',
        relative : 'commit',
        delta : '1980:00:00',
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : `${ a.abs( '.' ) }${ branch ? '!' : '' }${ branch ? branch : '' }`,
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }
}

repositoryMigrateWithLocalRepository.timeOut = 60000;

//

function repositoryMigrateWithOptionOnCommitMessage( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'onCommitMessage - string';
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.170' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'onCommitMessage - function that returns string';
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.170' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : () => '__sync__',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'onCommitMessage - function that returns string concatenated with message';
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.170' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : ( e ) => '__sync__' + e,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /__sync__\S+/ ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }

  /* */

  function agree( strategy, state )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        srcState : state,
        dstBranch : 'master',
        mergeStrategy : strategy,
        relative : 'commit',
        delta : '1980:00:00',
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( '.' ),
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }
}

repositoryMigrateWithOptionOnCommitMessage.timeOut = 120000;

//

function repositoryMigrateWithOptionOnCommitMessageManual( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'onCommitMessage - string';
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.170' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : 'manual',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }

  /* */

  function agree( strategy, state )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        srcState : state,
        dstBranch : 'master',
        mergeStrategy : strategy,
        relative : 'commit',
        delta : '1980:00:00',
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( '.' ),
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }
}

repositoryMigrateWithOptionOnCommitMessageManual.experimental = 1;
repositoryMigrateWithOptionOnCommitMessageManual.timeOut = 300000;

//

function repositoryMigrateWithOptionOnDate( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'onDate returns no date';
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.170' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : ( e ) => '',
      onCommitMessage : '__sync__',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    const dateMatch = op.output.match( /Date:\s+((\w+)\s+(\w+)\s(\d+)\s(\d+:))/ );
    const commonDate = dateMatch[ 1 ];
    test.ge( _.strCount( op.output, commonDate ), 15 );
    return null;
  });

  /* */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'onDate returns original date';
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.170' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : ( e ) => e,
      onCommitMessage : '__sync__',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    const dateMatch = op.output.match( /Date:\s+((\w+)\s+(\w+)\s(\d+)\s(\d+:))/ );
    const commonDate = dateMatch[ 1 ];
    test.ge( _.strCount( op.output, commonDate ), 0 );
    return null;
  });

  /* */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'onDate - default';
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.170' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : null,
      onCommitMessage : '__sync__',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    const dateMatch = op.output.match( /Date:\s+((\w+)\s+(\w+)\s(\d+)\s(\d+:))/ );
    const commonDate = dateMatch[ 1 ];
    test.ge( _.strCount( op.output, commonDate ), 0 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }

  /* */

  function agree( strategy, state )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        srcState : state,
        dstBranch : 'master',
        mergeStrategy : strategy,
        relative : 'commit',
        delta : '1980:00:00',
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( '.' ),
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }
}

repositoryMigrateWithOptionOnDate.timeOut = 60000;

//

function repositoryMigrateWithOptionOnDateAsMap( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* */

  let originalHistory = [];
  originalSrcHistoryGet();

  /* - */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'delta - one hour, relative - commit';
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : { relative : 'commit', delta : '01:00:00' },
      onCommitMessage : ( e ) => e,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8e2aa80ca350f3c45215abafa07a4f2cd320342a',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 17 );
    test.notIdentical( op, originalHistory );
    test.notIdentical( op[ 10 ], originalHistory[ 12 ] );
    test.identical( op[ 10 ].message, originalHistory[ 12 ].message );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( Date.parse( op[ 10 ].date ) - Date.parse( originalHistory[ 12 ].date ), 3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), 3600000 );
    for( let i = 0 ; i < op.length ; i++ )
    test.identical( op[ i ].date, op[ i ].commiterDate );
    return null;
  });

  /* */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'delta - one hour, relative - now';
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : { relative : 'now', delta : '01:00:00' },
      onCommitMessage : ( e ) => e,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8e2aa80ca350f3c45215abafa07a4f2cd320342a',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 17 );
    test.notIdentical( op, originalHistory );
    test.notIdentical( op[ 10 ], originalHistory[ 12 ] );
    test.identical( op[ 10 ].message, originalHistory[ 12 ].message );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.ge( Date.parse( op[ 12 ].date ) - Date.now(), 3500000 );
    test.le( Date.parse( op[ 12 ].date ) - Date.now(), 3600000 );
    test.ge( Date.parse( op[ 0 ].date ) - Date.now(), 3500000 );
    test.le( Date.parse( op[ 0 ].date ) - Date.now(), 3600000 );
    for( let i = 0 ; i < op.length ; i++ )
    test.identical( op[ i ].date, op[ i ].commiterDate );
    return null;
  });

  /* - */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'delta - negative, one hour, relative - commit';
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : { relative : 'commit', delta : '-01:00:00' },
      onCommitMessage : ( e ) => e,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8e2aa80ca350f3c45215abafa07a4f2cd320342a',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 17 );
    test.notIdentical( op, originalHistory );
    test.notIdentical( op[ 10 ], originalHistory[ 12 ] );
    test.identical( op[ 10 ].message, originalHistory[ 12 ].message );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( Date.parse( op[ 10 ].date ) - Date.parse( originalHistory[ 12 ].date ), -3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), -3600000 );
    for( let i = 0 ; i < op.length ; i++ )
    test.identical( op[ i ].date, op[ i ].commiterDate );
    return null;
  });

  /* */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'delta - negative, one hour, relative - now';
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : { relative : 'now', delta : '-01:00:00' },
      onCommitMessage : ( e ) => e,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8e2aa80ca350f3c45215abafa07a4f2cd320342a',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 17 );
    test.notIdentical( op, originalHistory );
    test.notIdentical( op[ 10 ], originalHistory[ 12 ] );
    test.identical( op[ 10 ].message, originalHistory[ 12 ].message );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.ge( Date.now() - Date.parse( op[ 12 ].date ), 3500000 );
    test.le( Date.now() - Date.parse( op[ 12 ].date ), 3700000 );
    test.ge( Date.now() - Date.parse( op[ 0 ].date ), 3500000 );
    test.le( Date.now() - Date.parse( op[ 0 ].date ), 3700000 );
    for( let i = 0 ; i < op.length ; i++ )
    test.identical( op[ i ].date, op[ i ].commiterDate );
    return null;
  });

  /* - */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'delta - one hour, relative - commit, periodic - one hour';
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : { relative : 'commit', delta : '01:00:00', periodic : '01:00:00' },
      onCommitMessage : ( e ) => e,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8e2aa80ca350f3c45215abafa07a4f2cd320342a',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 17 );
    test.notIdentical( op, originalHistory );
    test.notIdentical( op[ 10 ], originalHistory[ 12 ] );
    test.identical( op[ 10 ].message, originalHistory[ 12 ].message );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );

    test.identical( Date.parse( op[ 13 ].date ) - Date.parse( originalHistory[ 15 ].date ), 2 * 3600000 + 3600000 );
    test.identical( Date.parse( op[ 11 ].date ) - Date.parse( originalHistory[ 13 ].date ), 4 * 3600000 + 3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), 15 * 3600000 + 3600000 );
    for( let i = 0 ; i < op.length ; i++ )
    test.identical( op[ i ].date, op[ i ].commiterDate );
    return null;
  });

  /* */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'delta - one hour, relative - fromFirst, periodic - one hour';
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : { relative : 'fromFirst', delta : '01:00:00', periodic : '01:00:00' },
      onCommitMessage : ( e ) => e,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8e2aa80ca350f3c45215abafa07a4f2cd320342a',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 17 );
    test.notIdentical( op, originalHistory );
    test.notIdentical( op[ 10 ], originalHistory[ 12 ] );
    test.identical( op[ 10 ].message, originalHistory[ 12 ].message );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );

    test.identical( Date.parse( op[ 11 ].date ) - Date.parse( op[ 12 ].date ), 3600000 );
    test.identical( Date.parse( op[ 10 ].date ) - Date.parse( op[ 11 ].date ), 3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( op[ 1 ].date ), 3600000 );
    for( let i = 0 ; i < op.length ; i++ )
    test.identical( op[ i ].date, op[ i ].commiterDate );
    return null;
  });

  /* */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'delta - one hour, relative - commit, periodic - one hour, deviation - ten minutes';
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : { relative : 'commit', delta : '01:00:00', periodic : '01:00:00', deviation : '00:10:00' },
      onCommitMessage : ( e ) => e,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8e2aa80ca350f3c45215abafa07a4f2cd320342a',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 17 );
    test.notIdentical( op, originalHistory );
    test.notIdentical( op[ 10 ], originalHistory[ 12 ] );
    test.identical( op[ 10 ].message, originalHistory[ 12 ].message );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );

    test.ge( Date.parse( op[ 13 ].date ) - Date.parse( originalHistory[ 15 ].date ), 2 * 3600000 - 12000000 );
    test.le( Date.parse( op[ 13 ].date ) - Date.parse( originalHistory[ 15 ].date ), 2 * 3600000 + 12000000 );
    test.ge( Date.parse( op[ 11 ].date ) - Date.parse( originalHistory[ 13 ].date ), 4 * 3600000 - 12000000 );
    test.le( Date.parse( op[ 11 ].date ) - Date.parse( originalHistory[ 13 ].date ), 4 * 3600000 + 12000000 );
    test.ge( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), 15 * 3600000 - 12000000 );
    test.le( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), 15 * 3600000 + 12000000 );
    for( let i = 0 ; i < op.length ; i++ )
    test.identical( op[ i ].date, op[ i ].commiterDate );
    return null;
  });

  /* */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'delta - one hour, relative - fromFirst, periodic - one hour, deviation - ten minutes';
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : { relative : 'fromFirst', delta : '01:00:00', periodic : '01:00:00', deviation : '00:10:00' },
      onCommitMessage : ( e ) => e,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8e2aa80ca350f3c45215abafa07a4f2cd320342a',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 17 );
    test.notIdentical( op, originalHistory );
    test.notIdentical( op[ 10 ], originalHistory[ 12 ] );
    test.identical( op[ 10 ].message, originalHistory[ 12 ].message );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );

    test.ge( Date.parse( op[ 11 ].date ) - Date.parse( op[ 12 ].date ), 2400000 );
    test.le( Date.parse( op[ 11 ].date ) - Date.parse( op[ 12 ].date ), 5000000 );
    test.ge( Date.parse( op[ 10 ].date ) - Date.parse( op[ 11 ].date ), 2400000 );
    test.le( Date.parse( op[ 10 ].date ) - Date.parse( op[ 11 ].date ), 5000000 );
    test.ge( Date.parse( op[ 0 ].date ) - Date.parse( op[ 1 ].date ), 2400000 );
    test.le( Date.parse( op[ 0 ].date ) - Date.parse( op[ 1 ].date ), 5000000 );
    for( let i = 0 ; i < op.length ; i++ )
    test.identical( op[ i ].date, op[ i ].commiterDate );
    return null;
  });

  /* */

  begin();
  agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.ready.then( () =>
  {
    test.case = 'delta - negative, two days, relative - now, periodic - one hour, deviation - ten minutes';
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onDate : { relative : 'now', delta : '-48:00:00', periodic : '01:00:00', deviation : '00:10:00' },
      onCommitMessage : ( e ) => e,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8e2aa80ca350f3c45215abafa07a4f2cd320342a',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 17 );
    test.notIdentical( op, originalHistory );
    test.notIdentical( op[ 10 ], originalHistory[ 12 ] );
    test.identical( op[ 10 ].message, originalHistory[ 12 ].message );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );

    test.ge( _.time.now() - Date.parse( op[ 14 ].date ), 48 * 3600 * 1000 - 7200 * 1000 );
    test.le( _.time.now() - Date.parse( op[ 14 ].date ), 48 * 3600 * 1000 + 7200 * 1000 );
    test.ge( Date.parse( op[ 11 ].date ) - Date.parse( op[ 12 ].date ), 2400000 );
    test.le( Date.parse( op[ 11 ].date ) - Date.parse( op[ 12 ].date ), 5000000 );
    test.ge( Date.parse( op[ 10 ].date ) - Date.parse( op[ 11 ].date ), 2400000 );
    test.le( Date.parse( op[ 10 ].date ) - Date.parse( op[ 11 ].date ), 5000000 );
    test.ge( Date.parse( op[ 0 ].date ) - Date.parse( op[ 1 ].date ), 2400000 );
    test.le( Date.parse( op[ 0 ].date ) - Date.parse( op[ 1 ].date ), 5000000 );
    for( let i = 0 ; i < op.length ; i++ )
    test.identical( op[ i ].date, op[ i ].commiterDate );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    begin();
    agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
    a.ready.then( () =>
    {
      test.case = 'periodic - one hour, deviation - two hours, should throw error';
      var onErrorCallback = ( err, arg ) =>
      {
        test.true( _.error.is( err ) );
        test.identical( arg, undefined );
        test.identical( err.originalMessage, 'Deviation cannot be bigger than period.' );
      };
      return test.shouldThrowErrorSync( () =>
      {
        return _.git.repositoryMigrate
        ({
          srcBasePath : srcRepositoryRemote,
          dstBasePath : a.abs( '.' ),
          srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
          srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
          srcBranch : 'master',
          dstBranch : 'master',
          onDate : { relative : 'now', delta : '-48:00:00', periodic : '01:00:00', deviation : '02:00:00' },
          onCommitMessage : ( e ) => e,
        });
      }, onErrorCallback );
    });

    /* */

    begin();
    agree( 'src', '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
    a.ready.then( () =>
    {
      test.case = 'delta - negative, new commit should be older than last commit in branch';
      var onErrorCallback = ( err, arg ) =>
      {
        test.true( _.error.is( err ) );
        test.identical( arg, undefined );
        var exp = 'New commit should be newer than last commit in branch.';
        test.identical( err.originalMessage, exp );
      };
      return test.shouldThrowErrorAsync( () =>
      {
        return _.git.repositoryMigrate
        ({
          srcBasePath : srcRepositoryRemote,
          dstBasePath : a.abs( '.' ),
          srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
          srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
          srcBranch : 'master',
          dstBranch : 'master',
          onDate : { relative : 'fromFirst', delta : '-9600:00:00', periodic : '00:00:00', deviation : '00:00:00' },
          onCommitMessage : ( e ) => e,
        });
      }, onErrorCallback );
    });
  }

  /* - */

  return a.ready;

  /* */

  function originalSrcHistoryGet()
  {
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ srcRepositoryRemote } ./` );
    a.shell( `git reset --hard d8c18d24c1d65fab1af6b8d676bba578b58bfad5` );
    a.ready.then( () =>
    {
      return _.git.repositoryHistoryToJson
      ({
        localPath : a.abs( '.' ),
        state1 : `#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd`,
        state2 : '#HEAD',
      });
    });
    a.ready.then( ( op ) =>
    {
      test.identical( op.length, 18 );
      originalHistory = op;
      return null
    });
    return a.ready;
  }

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }

  /* */

  function agree( strategy, state )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        srcState : state,
        dstBranch : 'master',
        mergeStrategy : strategy,
        relative : 'commit',
        delta : '1980:00:00',
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( '.' ),
        state1 : '#HEAD',
        state2 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }
}

repositoryMigrateWithOptionOnDateAsMap.timeOut = 240000;

//

function repositoryMigrateWithOptionOnly( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  let filesBefore;
  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    only : [ '*package.json', 'will.yml' ],
  });
  a.ready.then( () =>
  {
    test.case = 'only - string, file in range of modified files, strategy - src';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      only : 'package.json',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'package.json' );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 8 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 8 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    only : [ '*package.json', 'will.yml' ],
  });
  a.ready.then( () =>
  {
    test.case = 'only - string with glob, files in range of modified files, strategy - src';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      only : '*package.json',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'package.json\nwas.package.json' );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 8 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 8 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    only : [ '*package.json', 'will.yml' ],
  });
  a.ready.then( () =>
  {
    test.case = 'only - array of strings with and without glob, files in range of modified files, strategy - src';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      only : [ '*package.json', 'will.yml' ],
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'package.json\nwas.package.json' );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 10 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 10 );
    return null;
  });

  /* - */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    only : [ '*package.json', 'will.yml' ],
  });
  a.ready.then( () =>
  {
    test.case = 'only - string, file in range of modified files, strategy - dst';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      only : 'package.json',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'package.json' );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 8 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 8 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    only : [ '*package.json', 'will.yml' ],
  });
  a.ready.then( () =>
  {
    test.case = 'only - string with glob, files in range of modified files, strategy - dst';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      only : '*package.json',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'package.json\nwas.package.json' );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 8 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 8 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    only : [ '*package.json', 'will.yml' ],
  });
  a.ready.then( () =>
  {
    test.case = 'only - array of strings with and without glob, files in range of modified files, strategy - dst';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      only : [ '*package.json', 'will.yml' ],
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'package.json\nwas.package.json' );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 10 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 10 );
    return null;
  });

  /* - */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    only : [ '*package.json', 'will.yml' ],
  });
  a.ready.then( () =>
  {
    test.case = 'only - string, file is out of range of modified files, should throw error';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      only : 'Readme.md',
    });
  });
  a.ready.finally( ( err, op ) =>
  {
    test.true( _.error.is( err ) );
    _.error.attend( err );
    test.identical( op, undefined );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 0 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }

  /* */

  function agree( o )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        dstBranch : 'master',
        relative : 'commit',
        delta : '1980:00:00',
        ... o,
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( '.' ),
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }
}

repositoryMigrateWithOptionOnly.timeOut = 180000;

//

function repositoryMigrateWithOptionBut( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  let filesBefore;
  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    but : [ 'package.json' ],
  });
  a.ready.then( () =>
  {
    test.case = 'but - string, file in range of modified files, strategy - src';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      but : 'package.json',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let files = op.output.split( '\n' );
    test.false( _.longHas( files, 'package.json' ) );
    test.true( _.longHas( files, 'was.package.json' ) );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    but : [ 'package.json' ],
  });
  a.ready.then( () =>
  {
    test.case = 'but - string with glob, files in range of modified files, strategy - src';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      but : '*package.json',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let files = op.output.split( '\n' );
    test.false( _.longHas( files, 'package.json' ) );
    test.false( _.longHas( files, 'was.package.json' ) );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 9 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 9 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    but : [ 'package.json' ],
  });
  a.ready.then( () =>
  {
    test.case = 'but - array of strings with and without glob, files in range of modified files, strategy - src';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      but : [ '*package.json', 'will.yml' ],
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let files = op.output.split( '\n' );
    test.false( _.longHas( files, 'package.json' ) );
    test.false( _.longHas( files, 'was.package.json' ) );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 7 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 7 );
    return null;
  });

  /* - */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    but : [ 'package.json' ],
  });
  a.ready.then( () =>
  {
    test.case = 'but - string, file in range of modified files, strategy - dst';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      but : 'package.json',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let files = op.output.split( '\n' );
    test.false( _.longHas( files, 'package.json' ) );
    test.true( _.longHas( files, 'was.package.json' ) );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    but : [ 'package.json' ],
  });
  a.ready.then( () =>
  {
    test.case = 'but - string with glob, files in range of modified files, strategy - dst';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      but : '*package.json',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let files = op.output.split( '\n' );
    test.false( _.longHas( files, 'package.json' ) );
    test.false( _.longHas( files, 'was.package.json' ) );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 9 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 9 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    but : [ 'package.json' ],
  });
  a.ready.then( () =>
  {
    test.case = 'but - array of strings with and without glob, files in range of modified files, strategy - dst';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      but : [ '*package.json', 'will.yml' ],
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let files = op.output.split( '\n' );
    test.false( _.longHas( files, 'package.json' ) );
    test.false( _.longHas( files, 'was.package.json' ) );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 7 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 7 );
    return null;
  });

  /* - */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    only : [ 'Readme.md' ],
  });
  a.ready.then( () =>
  {
    test.case = 'but - string, file is out of range of modified files, should throw error';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      but : 'Readme.md',
    });
  });
  a.ready.finally( ( err, op ) =>
  {
    test.true( _.error.is( err ) );
    _.error.attend( err );
    test.identical( op, undefined );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting1' );
    test.identical( config.about.version, '0.0.1' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 0 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }

  /* */

  function agree( o )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        dstBranch : 'master',
        relative : 'commit',
        delta : '1980:00:00',
        ... o,
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( '.' ),
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }
}

repositoryMigrateWithOptionBut.timeOut = 180000;

//

function repositoryMigrateWithOptionsOnlyAndBut( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  let filesBefore;
  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
  });
  a.ready.then( () =>
  {
    test.case = 'only - string, file in range of modified files, strategy - src';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      only : [ '*package.json', 'will.yml', 'Readme.md' ],
      but : [ 'package.json', 'Readme*' ],
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'was.package.json' );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 10 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 10 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }

  /* */

  function agree( o )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        dstBranch : 'master',
        relative : 'commit',
        delta : '1980:00:00',
        ... o,
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( '.' ),
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }
}

//

function repositoryMigrateWithOptionSrcDirPath( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  let filesBefore;
  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
  });
  a.ready.then( () =>
  {
    test.case = 'srcDirPath - current dir, dot, without only';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      srcDirPath : '.',
      onCommitMessage : '__sync__',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 3 );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
  });
  a.ready.then( () =>
  {
    test.case = 'srcDirPath - current dir, dot and slash, without only';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      srcDirPath : './',
      onCommitMessage : '__sync__',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 3 );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
  });
  a.ready.then( () =>
  {
    test.case = 'srcDirPath - nested dir, without only';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      srcDirPath : './proto',
      onCommitMessage : '__sync__',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 14 );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 0 );
    return null;
  });

  /* - */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
  });
  a.ready.then( () =>
  {
    test.case = 'srcDirPath - current dir, dot, with only';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      srcDirPath : '.',
      onCommitMessage : '__sync__',
      only : [ '*package*', '**.s' ],
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 2 );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 8 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 8 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
  });
  a.ready.then( () =>
  {
    test.case = 'srcDirPath - current dir, dot and slash, with only';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      srcDirPath : './',
      onCommitMessage : '__sync__',
      only : [ '*package*', '**.s' ],
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 2 );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 8 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 8 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
  });
  a.ready.then( () =>
  {
    test.case = 'srcDirPath - nested dir, with only';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      srcDirPath : './proto',
      onCommitMessage : '__sync__',
      only : [ '*package*', '**.s' ],
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 14 );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 0 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }

  /* */

  function agree( o )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        dstBranch : 'master',
        relative : 'commit',
        delta : '1980:00:00',
        ... o,
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( '.' ),
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }
}

repositoryMigrateWithOptionSrcDirPath.timeOut = 180000;

//

function repositoryMigrateWithOptionDstDirPath( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  let filesBefore;
  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
  });
  a.ready.then( () =>
  {
    test.case = 'dstDirPath - current dir';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      dstDirPath : '.',
      onCommitMessage : '__sync__',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 3 );

    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'will.yml' ) );
    test.identical( config.about.name, 'wModuleForTesting2' );
    test.identical( config.about.version, '0.1.0' );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    dstDirPath : 'proto',
  });
  a.ready.then( () =>
  {
    test.case = 'dstDirPath - nested dir, dir synchronized';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      dstDirPath : 'proto',
      onCommitMessage : '__sync__',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 3 );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    dstDirPath : 'proto',
  });
  a.ready.then( () =>
  {
    test.case = 'dstDirPath - nested dir, srcDirPath, dir synchronized';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      srcDirPath : 'proto',
      dstDirPath : 'proto',
      onCommitMessage : '__sync__',
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 19 );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 0 );
    return null;
  });

  /* */

  begin();
  agree
  ({
    mergeStrategy : 'src',
    srcState : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
    dstDirPath : 'proto',
  });
  a.ready.then( () =>
  {
    test.case = 'dstDirPath - nested dir, srcDirPath, dir synchronized';
    filesBefore = a.find( a.abs( './' ) );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : a.abs( '.' ),
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      dstDirPath : 'proto',
      onCommitMessage : '__sync__',
      only : [ '*package*', '**.s' ],
    });
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 2 );

    var filesAfter = a.find( a.abs( './' ) );
    test.identical( filesBefore, filesAfter );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 8 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 8 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ dstCommit }` );
  }

  /* */

  function agree( o )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        dstBranch : 'master',
        relative : 'commit',
        delta : '1980:00:00',
        ... o,
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( o.dstDirPath || '.' ),
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }
}

repositoryMigrateWithOptionDstDirPath.timeOut = 180000;

//

function repositoryMigrateWithOptionLogger( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  begin({ srcRepositoryRemote, logger : 0 });
  agree( '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.shell( 'node testApp' );
  a.ready.then( ( op ) =>
  {
    test.case = 'logger - 0';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'List of commits to migrate :' ), 0 );
    test.identical( _.strCount( op.output, 'author' ), 0 );
    test.identical( _.strCount( op.output, 'email' ), 0 );
    test.identical( _.strCount( op.output, 'hash' ), 0 );
    test.identical( _.strCount( op.output, 'message' ), 0 );
    test.identical( _.strCount( op.output, 'date' ), 0 );
    test.identical( _.strCount( op.output, 'commiterDate' ), 0 );
    return null;
  });

  /* */

  begin({ srcRepositoryRemote, logger : 1 });
  agree( '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.shell( 'node testApp' );
  a.ready.then( ( op ) =>
  {
    test.case = 'logger - 1';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'List of commits to migrate :' ), 0 );
    test.identical( _.strCount( op.output, 'author' ), 0 );
    test.identical( _.strCount( op.output, 'email' ), 0 );
    test.identical( _.strCount( op.output, 'hash' ), 0 );
    test.identical( _.strCount( op.output, 'message' ), 0 );
    test.identical( _.strCount( op.output, 'date' ), 0 );
    test.identical( _.strCount( op.output, 'commiterDate' ), 0 );
    return null;
  });

  /* */

  begin({ srcRepositoryRemote, logger : 2 });
  agree( '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.shell( 'node testApp' );
  a.ready.then( ( op ) =>
  {
    test.case = 'logger - 2';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'List of commits to migrate :' ), 1 );
    test.identical( _.strCount( op.output, 'author' ), 18 );
    test.identical( _.strCount( op.output, 'email' ), 18 );
    test.identical( _.strCount( op.output, 'hash' ), 18 );
    test.identical( _.strCount( op.output, 'message' ), 18 );
    test.identical( _.strCount( op.output, 'date' ), 18 );
    test.identical( _.strCount( op.output, 'commiterDate' ), 18 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin( locals )
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    a.ready.then( () => a.program({ entry : testApp, locals }) );
    return a.ready;
  }

  /* */

  function agree( state )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        srcState : state,
        dstBranch : 'master',
        mergeStrategy : 'src',
        relative : 'commit',
        delta : '1980:00:00',
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( '.' ),
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }

  /* */

  function testApp()
  {
    const _ = require( toolsPath );
    _.include( 'wGitTools' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : __dirname,
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      logger,
    });
  }
}

repositoryMigrateWithOptionLogger.timeOut = 120000;

//

function repositoryMigrateWithOptionDry( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const user = a.shell({ currentPath : __dirname, execPath : 'git config --global user.name', sync : 1 }).output.trim();

  /* - */

  begin({ srcRepositoryRemote, dry : 0 });
  agree( '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 0 );
    return null;
  });
  a.shell( 'node testApp' );
  a.ready.then( ( op ) =>
  {
    test.case = 'logger - 2';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'List of commits to migrate :' ), 1 );
    test.identical( _.strCount( op.output, 'author' ), 18 );
    test.identical( _.strCount( op.output, 'email' ), 18 );
    test.identical( _.strCount( op.output, 'hash' ), 18 );
    test.identical( _.strCount( op.output, 'message' ), 18 );
    test.identical( _.strCount( op.output, 'date' ), 18 );
    test.identical( _.strCount( op.output, 'commiterDate' ), 18 );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 15 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 15 );
    return null;
  });

  /* */

  begin({ srcRepositoryRemote, dry : 1 });
  agree( '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 0 );
    return null;
  });
  a.shell( 'node testApp' );
  a.ready.then( ( op ) =>
  {
    test.case = 'logger - 2';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'List of commits to migrate :' ), 1 );
    test.identical( _.strCount( op.output, 'author' ), 18 );
    test.identical( _.strCount( op.output, 'email' ), 18 );
    test.identical( _.strCount( op.output, 'hash' ), 18 );
    test.identical( _.strCount( op.output, 'message' ), 18 );
    test.identical( _.strCount( op.output, 'date' ), 18 );
    test.identical( _.strCount( op.output, 'commiterDate' ), 18 );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '__sync__' ), 0 );
    test.ge( _.strCount( op.output, `Author: ${ user }` ), 0 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin( locals )
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    a.ready.then( () => a.program({ entry : testApp, locals }) );
    return a.ready;
  }

  /* */

  function agree( state )
  {
    a.ready.then( () =>
    {
      return _.git.repositoryAgree
      ({
        srcBasePath : srcRepositoryRemote,
        dstBasePath : a.abs( '.' ),
        srcState : state,
        dstBranch : 'master',
        mergeStrategy : 'src',
        relative : 'commit',
        delta : '1980:00:00',
      });
    });
    a.ready.then( () =>
    {
      const start = Date.parse( '2021-08-11 14:09:46 +0300' );
      const delta = start - _.time.now() - 3600000;
      return _.git.commitsDates
      ({
        localPath : a.abs( '.' ),
        state1 : '#HEAD',
        relative : 'commit',
        delta,
      });
    });
    return a.ready;
  }

  /* */

  function testApp()
  {
    const _ = require( toolsPath );
    _.include( 'wGitTools' );
    return _.git.repositoryMigrate
    ({
      srcBasePath : srcRepositoryRemote,
      dstBasePath : __dirname,
      srcState1 : '#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd',
      srcState2 : '#d8c18d24c1d65fab1af6b8d676bba578b58bfad5',
      srcBranch : 'master',
      dstBranch : 'master',
      onCommitMessage : '__sync__',
      logger : 2,
      dry,
    });
  }
}

repositoryMigrateWithOptionDry.timeOut = 60000;

//

function repositoryHistoryToJson( test )
{
  const a = test.assetFor( false );
  const srcRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const srcCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';

  /* - */

  begin().then( () =>
  {
    test.case = 'from commit to head';
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : '#HEAD',
    })
  });
  a.ready.then( ( op ) =>
  {
    test.true( _.array.is( op ) );
    test.identical( op.length, 13 );
    test.identical( op[ 0 ].hash, '8e2aa80ca350f3c45215abafa07a4f2cd320342a' );
    test.identical( op[ 0 ].message, 'version 0.0.186' );
    test.identical( op[ 0 ].author, 'Kos' );
    test.identical( op[ 0 ].email, 'wandalen.me@gmail.com' );
    test.identical( op[ 0 ].date, '2021-10-29 08:07:03 +0300' );
    test.identical( op[ 12 ].hash, 'af36e28bc91b6f18e4babc810bbf5bc758ccf19f' );
    test.identical( op[ 12 ].message, 'version 0.0.180' );
    test.identical( op[ 12 ].author, 'wandalen' );
    test.identical( op[ 12 ].email, 'wandalen.me@gmail.com' );
    test.identical( op[ 12 ].date, '2021-08-12 18:31:34 +0300' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'from commit to commit, inside history';
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : '#af815d4eaaf1df0505da1e1b2e526a7d04cdce7e',
    })
  });
  a.ready.then( ( op ) =>
  {
    test.true( _.array.is( op ) );
    test.identical( op.length, 10 );
    test.identical( op[ 0 ].hash, 'af815d4eaaf1df0505da1e1b2e526a7d04cdce7e' );
    test.identical( op[ 0 ].message, 'version 0.0.185' );
    test.identical( op[ 0 ].author, 'wandalen' );
    test.identical( op[ 0 ].email, 'wandalen.me@gmail.com' );
    test.identical( op[ 0 ].date, '2021-10-22 10:03:32 +0300' );
    test.identical( op[ 9 ].hash, 'af36e28bc91b6f18e4babc810bbf5bc758ccf19f' );
    test.identical( op[ 9 ].message, 'version 0.0.180' );
    test.identical( op[ 9 ].author, 'wandalen' );
    test.identical( op[ 9 ].email, 'wandalen.me@gmail.com' );
    test.identical( op[ 9 ].date, '2021-08-12 18:31:34 +0300' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'from tag to tag, inside history';
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '!v0.0.180',
      state2 : '!v0.0.185',
    })
  });
  a.ready.then( ( op ) =>
  {
    test.true( _.array.is( op ) );
    test.identical( op.length, 10 );
    test.identical( op[ 0 ].hash, 'af815d4eaaf1df0505da1e1b2e526a7d04cdce7e' );
    test.identical( op[ 0 ].message, 'version 0.0.185' );
    test.identical( op[ 0 ].author, 'wandalen' );
    test.identical( op[ 0 ].email, 'wandalen.me@gmail.com' );
    test.identical( op[ 0 ].date, '2021-10-22 10:03:32 +0300' );
    test.identical( op[ 9 ].hash, 'af36e28bc91b6f18e4babc810bbf5bc758ccf19f' );
    test.identical( op[ 9 ].message, 'version 0.0.180' );
    test.identical( op[ 9 ].author, 'wandalen' );
    test.identical( op[ 9 ].email, 'wandalen.me@gmail.com' );
    test.identical( op[ 9 ].date, '2021-08-12 18:31:34 +0300' );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ srcRemote } ./` );
    return a.shell( `git reset --hard ${ srcCommit }` );
  }
}

//

function configRead( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  a.ready.then( () =>
  {
    test.case = 'filePath is not a git repository';
    var got = _.git.configRead( a.abs( 'notAGit' ) );
    test.identical( got, null );
    return null;
  });

  begin().then( () =>
  {
    test.case = 'local git repository exists, default config';
    var got = _.git.configRead( a.abs( '.' ) );
    test.identical( _.props.keys( got ), [ 'core' ] );
    test.true( _.mapIs( got.core ) );
    test.identical( got.core.bare, false );
    test.identical( got.core.filemode, !( process.platform === 'win32' ) );
    test.identical( got.core.logallrefupdates, true );
    test.identical( got.core.repositoryformatversion, '0' );
    return null;
  });

  begin();
  a.shell( 'git config user.name user' );
  a.shell( 'git config user.email user@domain.com' );
  a.ready.then( () =>
  {
    test.case = 'local git repository exists, not default config';
    var got = _.git.configRead( a.abs( '.' ) );
    test.identical( _.props.keys( got ), [ 'core', 'user' ] );
    test.true( _.mapIs( got.core ) );
    test.identical( got.core.bare, false );
    test.identical( got.core.filemode, !( process.platform === 'win32' ) );
    test.identical( got.core.logallrefupdates, true );
    test.identical( got.core.repositoryformatversion, '0' );
    test.true( _.mapIs( got.user ) );
    test.identical( got.user.name, 'user' );
    test.identical( got.user.email, 'user@domain.com' );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.configRead() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () => _.git.configRead( a.abs( '.' ), a.abs( '.' ) ) );

      test.case = 'wrong type of filePath';
      test.shouldThrowErrorSync( () => _.git.configRead( { filePath : 'wrong' } ) );

      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( '.' ) ));
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git init` );
    return a.ready;
  }
}

//

function configResetWithOptionWithLocal( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  begin();
  a.shellNonThrowing( 'git config --local --remove-section core' );
  a.shellNonThrowing( 'git config --local --remove-section user' );
  a.ready.then( () =>
  {
    test.case = 'with local path, preset - standard';
    return _.git.configReset
    ({
      localPath : a.abs( '.' ),
      withLocal : 1,
      withGlobal : 0,
      preset : 'standard',
    });
  });
  a.shell( 'git config --local --list' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'core.repositoryformatversion=0' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=true' ), 1 );
    test.identical( _.strCount( op.output, 'core.bare=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.logallrefupdates=true' ), 1 );
    return null;
  });

  /* */

  begin();
  a.shellNonThrowing( 'git config --local --remove-section core' );
  a.shellNonThrowing( 'git config --local --remove-section user' );
  a.ready.then( () =>
  {
    test.case = 'with local path, preset - recommended';
    return _.git.configReset
    ({
      localPath : a.abs( '.' ),
      withLocal : 1,
      withGlobal : 0,
      userName : 'user',
      userMail : 'user@domain.com',
      preset : 'recommended',
    });
  });
  a.shell( 'git config --local --list' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'core.repositoryformatversion=0' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.bare=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.logallrefupdates=true' ), 1 );

    test.identical( _.strCount( op.output, 'user.name=user' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'core.autocrlf=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.ignorecase=false' ), 1 );
    test.identical( _.strCount( op.output, 'credential.helper=store' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.configReset() );

      test.case = 'extra arguments';
      var o = { withLocal : 0, withGlobal : 1, preset : 'standard' };
      test.shouldThrowErrorSync( () => _.git.configReset( o, o ) );

      test.case = 'wrong type of options map';
      var o = { withLocal : 0, withGlobal : 1, preset : 'standard' };
      test.shouldThrowErrorSync( () => _.git.configReset([ o ]) );

      test.case = 'unknown option in options map';
      var o = { unknown : 1, withLocal : 0, withGlobal : 1, preset : 'standard' };
      test.shouldThrowErrorSync( () => _.git.configReset( o ) );

      test.case = 'preset - recommended, and options map has not user name or user email';
      var o = { withLocal : 0, withGlobal : 1, preset : 'recommended' };
      test.shouldThrowErrorSync( () => _.git.configReset( o ) );

      var o = { withLocal : 0, withGlobal : 1, preset : 'recommended', userName : 'user' };
      test.shouldThrowErrorSync( () => _.git.configReset( o ) );

      var o = { withLocal : 0, withGlobal : 1, preset : 'recommended', userMail : 'user@domain.com' };
      test.shouldThrowErrorSync( () => _.git.configReset( o ) );

      test.case = 'withLocal - 1, and options map has wrong o.localPath';
      var o = { withLocal : 1, withGlobal : 0, preset : 'standard' };
      test.shouldThrowErrorSync( () => _.git.configReset( o ) );

      var o = { localPath : a.abs( 'unknown' ), withLocal : 1, withGlobal : 0, preset : 'standard' };
      test.shouldThrowErrorSync( () => _.git.configReset( o ) );

      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( '.' ) ));
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git init` );
    return a.ready;
  }
}

//

function configResetWithOptionWithGlobal( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* to prevent global config corruption */
  if( !_.process.insideTestContainer() )
  {
    test.true( true );
    return;
  }

  /* save original global config */
  let globalConfigPath, originalGlobalConfig;
  a.ready.then( ( op ) =>
  {
    globalConfigPath = a.path.nativize( a.path.join( process.env.HOME, '.gitconfig' ) );
    originalGlobalConfig = a.fileProvider.fileRead( globalConfigPath );
    return null;
  });

  /* */

  begin();
  a.shell( 'git config --global user.name "user2"' );
  a.ready.then( () =>
  {
    test.case = 'without local path, preset - standard';
    return _.git.configReset
    ({
      withLocal : 0,
      withGlobal : 1,
      preset : 'standard',
    });
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  });

  /* */

  begin();
  a.shell( 'git config --global user.name "user2"' );
  a.ready.then( () =>
  {
    test.case = 'with local path, preset - standard';
    return _.git.configReset
    ({
      localPath : a.abs( '.' ),
      withLocal : 0,
      withGlobal : 1,
      preset : 'standard',
    });
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  });

  /* */

  begin();
  a.shell( 'git config --global user.name "user2"' );
  a.ready.then( () =>
  {
    test.case = 'without local path, preset - recommended';
    return _.git.configReset
    ({
      withLocal : 0,
      withGlobal : 1,
      userName : 'user',
      userMail : 'user@domain.com',
      preset : 'recommended',
    });
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'core.autocrlf=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.ignorecase=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 1 );
    test.identical( _.strCount( op.output, 'credential.helper=store' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  begin();
  a.shell( 'git config --global user.name "user2"' );
  a.ready.then( () =>
  {
    test.case = 'with local path, preset - recommended';
    return _.git.configReset
    ({
      localPath : a.abs( '.' ),
      withLocal : 0,
      withGlobal : 1,
      userName : 'user',
      userMail : 'user@domain.com',
      preset : 'recommended',
    });
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'core.autocrlf=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.ignorecase=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 1 );
    test.identical( _.strCount( op.output, 'credential.helper=store' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.fileWrite( globalConfigPath, originalGlobalConfig );

    if( err )
    {
      _.errAttend( err );
      throw _.err( err );
    }
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( '.' ) ));
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git init` );
    return a.ready;
  }
}

configResetWithOptionWithGlobal.timeOut = 30000;

//

function configResetWithOptionsWithLocalWithGlobal( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* to prevent global config corruption */
  if( !_.process.insideTestContainer() )
  {
    test.true( true );
    return;
  }

  /* save original global config */
  let globalConfigPath, originalGlobalConfig;
  a.ready.then( ( op ) =>
  {
    globalConfigPath = a.path.nativize( a.path.join( process.env.HOME, '.gitconfig' ) );
    originalGlobalConfig = a.fileProvider.fileRead( globalConfigPath );
    return null;
  });

  /* */

  begin();
  a.shell( 'git config --global user.name "user2"' );
  a.shellNonThrowing( 'git config --local --remove-section core' );
  a.shellNonThrowing( 'git config --local --remove-section user' );
  a.ready.then( () =>
  {
    test.case = 'with local path, preset - standard';
    return _.git.configReset
    ({
      localPath : a.abs( '.' ),
      withLocal : 1,
      withGlobal : 1,
      preset : 'standard',
    });
  });
  a.shell( 'git config --list' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'core.repositoryformatversion=0' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=true' ), 1 );
    test.identical( _.strCount( op.output, 'core.bare=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.logallrefupdates=true' ), 1 );
    return null;
  });

  /* */

  begin();
  a.shell( 'git config --global user.name "user2"' );
  a.shellNonThrowing( 'git config --local --remove-section core' );
  a.shellNonThrowing( 'git config --local --remove-section user' );
  a.ready.then( () =>
  {
    test.case = 'with local path, preset - recommended';
    return _.git.configReset
    ({
      localPath : a.abs( '.' ),
      withLocal : 1,
      withGlobal : 1,
      userName : 'user',
      userMail : 'user@domain.com',
      preset : 'recommended',
    });
  });
  a.shell( 'git config --list' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'core.repositoryformatversion=0' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 2 );
    test.identical( _.strCount( op.output, 'core.bare=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.logallrefupdates=true' ), 1 );

    test.identical( _.strCount( op.output, 'user.name=user' ), 2 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 2 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 2 );
    test.identical( _.strCount( op.output, 'core.autocrlf=false' ), 2 );
    test.identical( _.strCount( op.output, 'core.ignorecase=false' ), 2 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 2 );
    test.identical( _.strCount( op.output, 'credential.helper=store' ), 2 );
    test.identical( _.strCount( op.output, 'url.https://user@github.com.insteadof=https://github.com' ), 2 );
    test.identical( _.strCount( op.output, 'url.https://user@bitbucket.org.insteadof=https://bitbucket.org' ), 2 );
    return null;
  });

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.fileWrite( globalConfigPath, originalGlobalConfig );

    if( err )
    {
      _.errAttend( err );
      throw _.err( err );
    }
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( '.' ) ));
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git init` );
    return a.ready;
  }
}

configResetWithOptionsWithLocalWithGlobal.timeOut = 15000;

//

function diff( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  /* aaa : bad : use test modules only */ /* Dmytro : done */
  /* aaa : for Dmytro : do properly */ /* Dmytro : done */
  let remotePath = 'https://github.com/Wandalen/wModuleForTesting1.git';
  let latestCommit = _.git.remoteVersionLatest({ remotePath });

  a.fileProvider.dirMake( a.abs( '.' ) )

  /* - */

  begin().then( () =>
  {
    test.case = 'compare two identical states of repo';

    test.description = 'detailing - 1, explaining - 1';
    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${latestCommit}`,
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 1, explaining - 0';
    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${latestCommit}`,
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 0, explaining - 1';
    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${latestCommit}`,
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 0, explaining - 0';
    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `#${latestCommit}`,
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    return null;
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'compare two commits'

    var status =
`modifiedFiles:
  package.json
  was.package.json`

    var statusOriginal =
` package.json     | 2 +-
 was.package.json | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
`;


    test.description = 'detailing - 1, explaining - 1';
    var got = _.git.diff
    ({
      state1 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      state2 : `#faffd60916a71d772ffb9644bbad59152b9ed73e`,
      localPath : a.abs( 'wModuleForTesting1' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      modifiedFiles : 'package.json\nwas.package.json',
      deletedFiles : '',
      addedFiles : '',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
      status,
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 1, explaining - 0';
    var got = _.git.diff
    ({
      state1 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      state2 : `#faffd60916a71d772ffb9644bbad59152b9ed73e`,
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 0, explaining - 1';
    var got = _.git.diff
    ({
      state1 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      state2 : `#faffd60916a71d772ffb9644bbad59152b9ed73e`,
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 0, explaining - 0';
    var got = _.git.diff
    ({
      state1 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      state2 : `#faffd60916a71d772ffb9644bbad59152b9ed73e`,
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    return null;
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'compare commit and tag';

    var status =
`modifiedFiles:
  .eslintrc.yml
  .github/workflows/Publish.yml
  .github/workflows/PullRequest.yml
  .github/workflows/Push.yml
  .gitignore
  .im.will.yml
  LICENSE
  README.md
  out/wModuleForTesting1.out.will.yml
  package.json
  proto/Integration.test.ss
  proto/wtools/testing/Basic.s
  proto/wtools/testing/l1.test/ModuleForTesting1.test.s
  proto/wtools/testing/l1/Include.s
  proto/wtools/testing/l1/ModuleForTesting1.s
  was.package.json
deletedFiles:
  sample/Sample.s
addedFiles:
  sample/trivial/Sample.s`;

    var statusOriginal =
` .eslintrc.yml                                      |  37 ++-
 .github/workflows/Publish.yml                      |  27 +-
 .github/workflows/PullRequest.yml                  |  26 +-
 .github/workflows/Push.yml                         |  45 ++--
 .gitignore                                         |  12 +-
 .im.will.yml                                       |   5 +
 LICENSE                                            |   2 +-
 README.md                                          |   2 +-
 out/wModuleForTesting1.out.will.yml                |  24 +-
 package.json                                       |  63 +++--
 proto/Integration.test.ss                          | 287 +++++++++++++++++++--
 proto/wtools/testing/Basic.s                       |   4 +-
 .../testing/l1.test/ModuleForTesting1.test.s       |  14 +-
 proto/wtools/testing/l1/Include.s                  |  78 +++++-
 proto/wtools/testing/l1/ModuleForTesting1.s        |   9 +-
 sample/Sample.s                                    |   5 -
 sample/trivial/Sample.s                            |   9 +
 was.package.json                                   |   4 +-
 18 files changed, 537 insertions(+), 116 deletions(-)
`;

    test.description = 'detailing - 1, explaining - 1';
    var got = _.git.diff
    ({
      state1 : `!v0.0.100`,
      state2 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      localPath : a.abs( 'wModuleForTesting1' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      modifiedFiles : '.eslintrc.yml\n.github/workflows/Publish.yml\n.github/workflows/PullRequest.yml\n.github/workflows/Push.yml\n.gitignore\n.im.will.yml\nLICENSE\nREADME.md\nout/wModuleForTesting1.out.will.yml\npackage.json\nproto/Integration.test.ss\nproto/wtools/testing/Basic.s\nproto/wtools/testing/l1.test/ModuleForTesting1.test.s\nproto/wtools/testing/l1/Include.s\nproto/wtools/testing/l1/ModuleForTesting1.s\nwas.package.json',
      deletedFiles : 'sample/Sample.s',
      addedFiles : 'sample/trivial/Sample.s',
      renamedFiles : '',
      copiedFiles : '',
      typechangedFiles : '',
      unmergedFiles : '',
      status
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 1, explaining - 0';
    var got = _.git.diff
    ({
      state1 : `!v0.0.100`,
      state2 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 0, explaining - 1';
    var got = _.git.diff
    ({
      state1 : `!v0.0.100`,
      state2 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 0, explaining - 0';
    var got = _.git.diff
    ({
      state1 : `!v0.0.100`,
      state2 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    return null;
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'compare two identical commits';

    test.description = 'detailing - 1, explaining - 1';
    var got = _.git.diff
    ({
      state1 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      state2 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 1, explaining - 0';
    var got = _.git.diff
    ({
      state1 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      state2 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 0, explaining - 1';
    var got = _.git.diff
    ({
      state1 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      state2 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    /* */

    test.description = 'detailing - 0, explaining - 0';
    var got = _.git.diff
    ({
      state1 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      state2 : '#d437e8c69b8acf5d1c41404b31f57d81751b6d69',
      localPath : a.abs( 'wModuleForTesting1' ),
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
    };
    test.contains( got, expected );

    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'wModuleForTesting1' ) ));
    a.shell( `git clone ${ remotePath }` );
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
  .then( () =>
  {
    test.case = 'working..HEAD'
    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : 'committed',
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
      state2 : 'committed',
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
      state2 : 'committed',
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
      state2 : 'committed',
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

  /* working<>committed */

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
    test.case = 'working..committed'
    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `committed`,
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
      state2 : `working`,
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
      state2 : `committed`,
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
      state2 : `working`,
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
      state2 : `committed`,
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
      state2 : `working`,
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
      state2 : `committed`,
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

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `working`,
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
      state2 : 'committed',
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
    };
    test.contains( got, expected );

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : 'committed',
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
    };
    test.contains( got, expected );

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : 'committed',
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
    };
    test.contains( got, expected );

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : 'committed',
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
    };
    test.contains( got, expected );

    return null;
  })

  /* staging<>working */

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
    test.case = 'staging..committed, untracked file should be ignored'

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `working`,
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
      state2 : `staging`,
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
      state2 : `working`,
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
      state2 : `staging`,
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
      state2 : `working`,
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
      state2 : `staging`,
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
      state2 : `working`,
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

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `staging`,
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

  /* staging<>committed */

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
    test.case = 'staging..committed, untracked file should be ignored'

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : `committed`,
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
      state2 : `staging`,
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
      state2 : `committed`,
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
      state2 : `staging`,
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
      state2 : `committed`,
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
      state2 : `staging`,
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
      state2 : `committed`,
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

    var got = _.git.diff
    ({
      state1 : 'committed',
      state2 : `staging`,
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
      state2 : 'committed',
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
    };
    test.contains( got, expected );

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : 'committed',
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
    };
    test.contains( got, expected );

    var got = _.git.diff
    ({
      state1 : 'staging',
      state2 : 'committed',
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
    };
    test.contains( got, expected );

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

  /* */

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

function diffSameStates( test )
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
  .then( () =>
  {
    test.case = 'working..working'
    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `working`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : '',
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `working`,
      localPath : a.abs( 'repo' ),
      detailing : 1,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : false
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `working`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 1,
      sync : 1
    });
    var expected =
    {
      status : ''
    }
    test.contains( got, expected )

    var got = _.git.diff
    ({
      state1 : 'working',
      state2 : `working`,
      localPath : a.abs( 'repo' ),
      detailing : 0,
      explaining : 0,
      sync : 1
    });
    var expected =
    {
      status : false,
    }
    test.contains( got, expected )

    return null;
  })

  /* */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'repo' ) ))
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'repo' ) ); return null })
    a.shell( `git init` )
    return a.ready;
  }

}

diffSameStates.timeOut = 60000;

//

function pull( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.shell.predefined.outputCollecting = 1;
  a.shell.predefined.currentPath = a.abs( 'repo' );

  /* */

  begin().then( () =>
  {
    test.case = 'pull changes';
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'clone/file2.txt' ), 'file2.txt' );
    return null;
  });

  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git add .' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git commit -m second' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push' });

  /* */

  a.ready.then( () =>
  {
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt' ] );

    _.git.pull
    ({
      localPath : a.abs( 'repo' ),
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt', './file2.txt' ] );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'dry - 1, pull not changes';
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'clone/file2.txt' ), 'file2.txt' );
    return null;
  });

  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git add .' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git commit -m second' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push' });

  /* */

  a.ready.then( () =>
  {
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt' ] );

    _.git.pull
    ({
      localPath : a.abs( 'repo' ),
      dry : 1,
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt' ] );

    return null;
  });

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.pull() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () => _.git.pull( { localPath : a.abs( 'repo' ) }, { extra : 1 } ) );

      test.case = 'wrong type of options map o';
      test.shouldThrowErrorSync( () => _.git.pull([ a.abs( 'repo' ) ]) );

      test.case = 'unknown option in options map o';
      test.shouldThrowErrorSync( () => _.git.pull({ localPath : a.abs( 'repo' ), unknown : 1 }) );

      test.case = 'wrong type of o.localPath';
      test.shouldThrowErrorSync( () => _.git.pull({ localPath : 1 }) );

      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'main' ) );
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      return null;
    });

    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'main' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' );
      return null;
    });
    a.shell({ currentPath : a.abs( 'main' ), execPath : `git init --bare` });

    a.shell( `git init` );
    a.shell( 'git remote add origin ../main' );
    a.shell( 'git add .' );
    a.shell( 'git commit -m init' );
    a.shell( 'git push -u origin master' );
    return a.ready;
  }
}

pull.timeOut = 60000;

//

function pullCheckOutput( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.shell.predefined.outputCollecting = 1;
  a.shell.predefined.currentPath = a.abs( 'repo' );
  let program;

  let programShell = _.process.starter
  ({
    currentPath : a.abs( '.' ),
    mode : 'shell',
    throwingExitCode : 1,
    outputCollecting : 1,
  });

  /* */

  begin().then( () =>
  {
    test.case = 'pull changes';
    a.fileProvider.filesDelete( a.abs( 'testApp.js' ) );
    program = programMake({ localPath : a.abs( 'repo' ) });
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'clone/file2.txt' ), 'file2.txt' );
    return null;
  });

  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git add .' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git commit -m second' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push' });

  /* */

  a.ready.then( () =>
  {
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt' ] );
    return null;
  });

  a.ready.then( () =>
  {
    return programShell( 'node ' + _.path.nativize( program.filePath/*programPath*/ ) );
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, />.*git pull/ ), 1 );
    test.identical( _.strCount( op.output, 'file2.txt | 1' ), 1 );
    test.identical( _.strCount( op.output, '1 file changed, 1 insertion(+)' ), 1 );
    test.identical( _.strCount( op.output, /master\s+-> origin\/master/ ), 1 );

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt', './file2.txt' ] );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'dry - 1, pull not changes';
    a.fileProvider.filesDelete( a.abs( 'testApp.js' ) );
    program = programMake({ localPath : a.abs( 'repo' ), dry : 1 });
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'clone/file2.txt' ), 'file2.txt' );
    return null;
  });

  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git add .' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git commit -m second' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push' });

  /* */

  a.ready.then( () =>
  {
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt' ] );
    return null;
  });

  a.ready.then( () =>
  {
    return programShell( 'node ' + _.path.nativize( program.filePath/*programPath*/ ) );
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, />.*git pull/ ), 0 );
    test.identical( _.strCount( op.output, 'file2.txt | 1' ), 0 );
    test.identical( _.strCount( op.output, '1 file changed, 1 insertion(+)' ), 0 );
    test.identical( _.strCount( op.output, /master\s+-> origin\/master/ ), 0 );

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt' ] );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'pull with conflict, throwing - 0';
    a.fileProvider.filesDelete( a.abs( 'testApp.js' ) );
    program = programMake({ localPath : a.abs( 'repo' ), throwing : 0 });
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });

  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'repo/file.txt' ), 'new line' );
    a.fileProvider.fileAppend( a.abs( 'clone/file.txt' ), 'another line' );
    return null;
  });

  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git add .' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git commit -m second' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push' });

  a.shell( 'git add .' );
  a.shell( 'git commit -m change' );

  /* */

  a.ready.then( () =>
  {
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt' ] );
    return null;
  });

  a.ready.then( () =>
  {
    return programShell( 'node ' + _.path.nativize( program.filePath/*programPath*/ ) );
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, />.*git pull/ ), 1 );
    test.identical( _.strCount( op.output, 'Auto-merging file.txt' ), 1 );
    test.identical( _.strCount( op.output, 'CONFLICT (content): Merge conflict in file.txt' ), 1 );
    test.identical( _.strCount( op.output, /master\s+-> origin\/master/ ), 1 );
    test.identical( _.strCount( op.output, 'Process returned exit code 1' ), 0 );

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt' ] );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'pull with conflict, throwing - 1';
    a.fileProvider.filesDelete( a.abs( 'testApp.js' ) );
    program = programMake({ localPath : a.abs( 'repo' ), throwing : 1 });
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });

  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'repo/file.txt' ), 'new line' );
    a.fileProvider.fileAppend( a.abs( 'clone/file.txt' ), 'another line' );
    return null;
  });

  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git add .' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git commit -m second' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push' });

  a.shell( 'git add .' );
  a.shell( 'git commit -m change' );

  /* */

  a.ready.then( () =>
  {
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt' ] );
    return null;
  });

  a.ready.then( () =>
  {
    return programShell({ throwingExitCode : 0, execPath : 'node ' + _.path.nativize( program.filePath/*programPath*/ ) });
  });
  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, />.*git pull/ ), 1 );
    test.identical( _.strCount( op.output, 'Auto-merging file.txt' ), 1 );
    test.identical( _.strCount( op.output, 'CONFLICT (content): Merge conflict in file.txt' ), 1 );
    test.identical( _.strCount( op.output, /master\s+-> origin\/master/ ), 2 );
    test.identical( _.strCount( op.output, 'Process returned exit code 1' ), 1 );

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' })
    test.identical( got, [ '.', './file.txt' ] );

    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'main' ) );
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      return null;
    });

    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'main' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' );
      return null;
    });
    a.shell({ currentPath : a.abs( 'main' ), execPath : `git init --bare` });

    a.shell( `git init` );
    a.shell( 'git remote add origin ../main' );
    a.shell( 'git add .' );
    a.shell( 'git commit -m init' );
    a.shell( 'git push -u origin master' );
    return a.ready;
  }

  /* */

  function programMake( options )
  {
    let locals = { toolsPath : _.module.resolve( 'wTools' ), o : options };
    return a.program({ entry : testApp, locals });
  }

  /* */

  function testApp()
  {
    const _ = require( toolsPath );
    _.include( 'wGitTools' );
    return _.git.pull( o );
  }
}

pullCheckOutput.timeOut = 60000;

//

function pullAllBranches( test )
{
  const context = this;
  const a = test.assetFor( 'basic' );

  /* - */

  begin().then( () =>
  {
    test.case = 'pull changes, second branch is synchronized';
    return null;
  });

  a.ready.then( () =>
  {
    return _.git.pull
    ({
      localPath : a.abs( 'repo' ),
      sync : 0
    });
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git branch' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '* master' ), 1 );
    test.identical( _.strCount( op.output, '* new' ), 0 );
    return null;
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout master' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git log' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'master_init' ), 1 );
    test.identical( _.strCount( op.output, 'master_commit' ), 1 );
    test.identical( _.strCount( op.output, 'new_commit1' ), 0 );
    test.identical( _.strCount( op.output, 'new_commit2' ), 0 );
    return null;
  });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout new' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git log' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'master_init' ), 1 );
    test.identical( _.strCount( op.output, 'master_commit' ), 0 );
    test.identical( _.strCount( op.output, 'new_commit1' ), 1 );
    test.identical( _.strCount( op.output, 'new_commit2' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'pull changes, second branch is not synchronized, no switch on different branch';
    return null;
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout new' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git reset --hard HEAD~' });

  a.ready.then( () =>
  {
    return _.git.pull
    ({
      localPath : a.abs( 'repo' ),
      sync : 0
    });
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git branch' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '* master' ), 0 );
    test.identical( _.strCount( op.output, '* new' ), 1 );
    return null;
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout master' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git log' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'master_init' ), 1 );
    test.identical( _.strCount( op.output, 'master_commit' ), 1 );
    test.identical( _.strCount( op.output, 'new_commit1' ), 0 );
    test.identical( _.strCount( op.output, 'new_commit2' ), 0 );
    return null;
  });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout new' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git log' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'master_init' ), 1 );
    test.identical( _.strCount( op.output, 'master_commit' ), 0 );
    test.identical( _.strCount( op.output, 'new_commit1' ), 1 );
    test.identical( _.strCount( op.output, 'new_commit2' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'pull changes, second branch is not synchronized, no switch on different branch, no each branch pulling';
    return null;
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout new' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git reset --hard HEAD~' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout master' });

  a.ready.then( () =>
  {
    return _.git.pull
    ({
      localPath : a.abs( 'repo' ),
      sync : 0
    });
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git branch' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '* master' ), 1 );
    test.identical( _.strCount( op.output, '* new' ), 0 );
    return null;
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout master' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git log' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'master_init' ), 1 );
    test.identical( _.strCount( op.output, 'master_commit' ), 1 );
    test.identical( _.strCount( op.output, 'new_commit1' ), 0 );
    test.identical( _.strCount( op.output, 'new_commit2' ), 0 );
    return null;
  });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout new' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git log' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'master_init' ), 1 );
    test.identical( _.strCount( op.output, 'master_commit' ), 0 );
    test.identical( _.strCount( op.output, 'new_commit1' ), 1 );
    test.identical( _.strCount( op.output, 'new_commit2' ), 0 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'pull changes, second branch is not synchronized, no switch on different branch, each branch pulling';
    return null;
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout new' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git reset --hard HEAD~' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout master' });

  a.ready.then( () =>
  {
    return _.git.pull
    ({
      localPath : a.abs( 'repo' ),
      eachBranch : 1,
      sync : 0
    });
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git branch' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '* master' ), 1 );
    test.identical( _.strCount( op.output, '* new' ), 0 );
    return null;
  });

  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout master' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git log' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'master_init' ), 1 );
    test.identical( _.strCount( op.output, 'master_commit' ), 1 );
    test.identical( _.strCount( op.output, 'new_commit1' ), 0 );
    test.identical( _.strCount( op.output, 'new_commit2' ), 0 );
    return null;
  });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout new' });
  a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git log' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'master_init' ), 1 );
    test.identical( _.strCount( op.output, 'master_commit' ), 0 );
    test.identical( _.strCount( op.output, 'new_commit1' ), 1 );
    test.identical( _.strCount( op.output, 'new_commit2' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'main' ) );
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      return null;
    });

    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'main' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' );
      return null;
    });
    a.shell({ currentPath : a.abs( 'main' ), execPath : 'git init --bare' });

    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git init' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git remote add origin ../main' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git add .' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git commit -m master_init' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git push -u origin master' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout -b new' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git commit --allow-empty -m new_commit1' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git commit --allow-empty -m new_commit2' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git push -u origin new' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git checkout master' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git commit --allow-empty -m master_commit' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git push' });
    return a.ready;
  }
}

pullAllBranches.timeOut = 60000;

//

function push( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.shell.predefined.outputCollecting = 1;
  a.shell.predefined.currentPath = a.abs( 'repo' );

  /* */

  begin().then( () =>
  {
    test.case = 'push to not added master branch';
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' );
    return null;
  });

  a.shell( 'git add .' );
  a.shell( 'git commit -m init' );

  a.ready.then( () =>
  {
    var got = _.git.push({ localPath : a.abs( 'repo' ) });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });
  a.ready.then( () =>
  {
    var got = a.find( a.abs( 'clone' ) );
    test.identical( got, [ '.', './file.txt' ] );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'push to automatically added branch';
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' );
    return null;
  });

  a.shell( 'git add .' );
  a.shell( 'git commit -m init' );
  a.shell( 'git push -u origin master' );
  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });

  a.ready.then( () =>
  {
    a.fileProvider.fileAppend( a.abs( 'clone/file.txt' ), '\nnew line' );
    return null;
  });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git add .' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git commit -m second' });

  a.ready.then( () =>
  {
    var got = _.git.push({ localPath : a.abs( 'clone' ) });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git pull' )
  .then( () =>
  {
    var got = a.fileProvider.fileRead( a.abs( 'repo/file.txt' ) );
    var exp =
`file.txt
new line`;
    test.identical( got, exp );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'several pushes';
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' );
    return null;
  });

  a.shell( 'git add .' );
  a.shell( 'git commit -m init' );

  a.ready.then( () =>
  {
    var got = _.git.push({ localPath : a.abs( 'repo' ) });
    test.identical( got.exitCode, 0 );
    var got = _.git.push({ localPath : a.abs( 'repo' ) });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });
  a.ready.then( () =>
  {
    var got = a.find( a.abs( 'clone' ) );
    test.identical( got, [ '.', './file.txt' ] );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'dry - 1, push no changes';
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' );
    return null;
  });

  a.shell( 'git add .' );
  a.shell( 'git commit -m init' );

  a.ready.then( () =>
  {
    var got = _.git.push({ localPath : a.abs( 'repo' ), dry : 1 });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });
  a.ready.then( () =>
  {
    var got = a.find( a.abs( 'clone' ) );
    test.identical( got, [ '.' ] );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'withTags - 1, no unpushed tags exist';
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' );
    return null;
  });

  a.shell( 'git add .' );
  a.shell( 'git commit -m init' );

  a.ready.then( () =>
  {
    var got = _.git.push({ localPath : a.abs( 'repo' ), withTags : 1 });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });
  a.ready.then( () =>
  {
    var got = a.find( a.abs( 'clone' ) );
    test.identical( got, [ '.', './file.txt' ] );
    return null;
  });

  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git tag' });
  a.ready.then( ( op ) =>
  {
    test.identical( op.output, '' );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'withTags - 1, tags exist';
    return null;
  });

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' );
    return null;
  });

  a.shell( 'git add .' );
  a.shell( 'git commit -m init' );

  a.ready.then( () =>
  {
    _.git.tagMake({ localPath : a.abs( 'repo' ), tag : 'v000' });
    _.git.tagMake({ localPath : a.abs( 'repo' ), tag : 'init' });
    return null;
  });

  a.ready.then( () =>
  {
    var got = _.git.push({ localPath : a.abs( 'repo' ), withTags : 1 });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });
  a.ready.then( () =>
  {
    var got = a.find( a.abs( 'clone' ) );
    test.identical( got, [ '.', './file.txt' ] );
    return null;
  });

  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git tag' });
  a.ready.then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'v000' ), 1 );
    test.identical( _.strCount( op.output, 'init' ), 1 );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.push() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () => _.git.push( { localPath : a.abs( 'repo' ) }, { extra : 1 } ) );

      test.case = 'wrong type of options map o';
      test.shouldThrowErrorSync( () => _.git.push([ a.abs( 'repo' ) ]) );

      test.case = 'unknown option in options map o';
      test.shouldThrowErrorSync( () => _.git.push({ localPath : a.abs( 'repo' ), unknown : 1 }) );

      test.case = 'wrong type of o.localPath';
      test.shouldThrowErrorSync( () => _.git.push({ localPath : 1 }) );

      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'main' ) );
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      return null;
    });

    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'main' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    });
    a.shell({ currentPath : a.abs( 'main' ), execPath : `git init --bare` });

    a.shell( `git init` );
    a.shell( 'git remote add origin ../main' );
    return a.ready;
  }
}

push.timeOut = 60000;

//

function pushCheckOutput( test )
{
  const a = test.assetFor( 'basic' );
  const ready = _.take( null );
  const command = `node ${ a.path.nativize( a.abs( 'testApp' ) ) }`;


  /* - */

  ready.then( () =>
  {
    test.case = 'push to not added master branch';
    reposMake();
    programMake({ localPath : a.abs( 'repo' ) });
    commitAdd();
    return a.shell( command );
  });
  ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, />.*git push -u origin --all/ ), 1 );
    test.identical( _.strCount( op.output, 'ranch \'master\' set up to track ' ), 1 );
    test.identical( _.strCount( op.output, /\[new branch\]\s+ master -> master/ ), 1 );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'push to automatically added branch';
    reposMake();
    programMake({ localPath : a.abs( 'clone' ) });
    commitAdd();
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git push -u origin master' });
    a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });
    a.ready.then( () => { a.fileProvider.fileAppend( a.abs( 'clone/file.txt' ), '\nnew line' ); return null });
    a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git add .' });
    a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git commit -m second' });
    return a.shell( command );
  });
  ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, />.*git push -u origin --all/ ), 1 );
    test.identical( _.strCount( op.output, 'ranch \'master\' set up to track ' ), 1 );
    test.identical( _.strCount( op.output, /\[new branch\]\s+ master -> master/ ), 0 );
    test.identical( _.strCount( op.output, 'master -> master' ), 1 );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'several pushes';
    reposMake();
    programMake({ localPath : a.abs( 'repo' ) });
    commitAdd();
    a.shell( command );
    return a.shell( command );
  });
  ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, />.*git push -u origin --all/ ), 1 );
    test.identical( _.strCount( op.output, 'ranch \'master\' set up to track ' ), 1 );
    test.identical( _.strCount( op.output, 'Everything up-to-date' ), 1 );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'dry - 1, push no changes';
    reposMake();
    programMake({ localPath : a.abs( 'repo' ), dry : 1 });
    commitAdd();
    return a.shell( command );
  });
  ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'git push --dry-run -u origin --all' ), 1 );
    test.identical( _.strCount( op.output, /\[new branch\]\s+ master -> master/ ), 1 );
    test.identical( _.strCount( op.output, 'Would set upstream of \'master\' to \'master\' of \'origin\'' ), 1 );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'dry - 1, force - 1, push no changes';
    reposMake();
    programMake({ localPath : a.abs( 'repo' ), dry : 1, force : 1 });
    commitAdd();
    return a.shell( command );
  });
  ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'git push --dry-run -u origin --all' ), 1 );
    test.identical( _.strCount( op.output, /\[new branch\]\s+ master -> master/ ), 1 );
    test.identical( _.strCount( op.output, 'Would set upstream of \'master\' to \'master\' of \'origin\'' ), 1 );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'withTags - 1, no unpushed tags exist';
    reposMake();
    programMake({ localPath : a.abs( 'repo' ), withTags : 1 });
    commitAdd();
    return a.shell( command );
  });
  ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, />.*git push -u origin --all/ ), 1 );
    test.identical( _.strCount( op.output, 'ranch \'master\' set up to track ' ), 1 );
    test.identical( _.strCount( op.output, /\[new branch\]\s+ master -> master/ ), 1 );
    test.identical( _.strCount( op.output, />.*git push --tags/ ), 1 );
    test.identical( _.strCount( op.output, 'Everything up-to-date' ), 1 );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'withTags - 1, force - 1, no unpushed tags exist';
    reposMake();
    programMake({ localPath : a.abs( 'repo' ), withTags : 1, force : 1 });
    commitAdd();
    return a.shell( command );
  });
  ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, />.*git push -u origin --all --force/ ), 1 );
    test.identical( _.strCount( op.output, 'ranch \'master\' set up to track ' ), 1 );
    test.identical( _.strCount( op.output, /\[new branch\]\s+ master -> master/ ), 1 );
    test.identical( _.strCount( op.output, />.*git push --tags --force/ ), 1 );
    test.identical( _.strCount( op.output, 'Everything up-to-date' ), 1 );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'withTags - 1, tags exist';
    reposMake();
    programMake({ localPath : a.abs( 'repo' ), withTags : 1 });
    commitAdd();
    a.ready.then( () => _.git.tagMake({ localPath : a.abs( 'repo' ), tag : 'v000', sync : 0 }) );
    a.ready.then( () => _.git.tagMake({ localPath : a.abs( 'repo' ), tag : 'init', sync : 0 }) );
    return a.shell( command );
  });
  ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'ranch \'master\' set up to track ' ), 1 );
    test.identical( _.strCount( op.output, /\[new branch\]\s+ master -> master/ ), 1 );
    test.identical( _.strCount( op.output, />.*git push --tags/ ), 1 );
    test.identical( _.strCount( op.output, /\* \[new tag\]\s+v000 -> v000/ ), 1 );
    test.identical( _.strCount( op.output, /\* \[new tag\]\s+init -> init/ ), 1 );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'withTags - 1, force - 1, tags exist';
    reposMake();
    programMake({ localPath : a.abs( 'repo' ), withTags : 1, force : 1 });
    commitAdd();
    a.ready.then( () => _.git.tagMake({ localPath : a.abs( 'repo' ), tag : 'v000', sync : 0 }) );
    a.ready.then( () => _.git.tagMake({ localPath : a.abs( 'repo' ), tag : 'init', sync : 0 }) );
    return a.shell( command );
  });
  ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'ranch \'master\' set up to track ' ), 1 );
    test.identical( _.strCount( op.output, /\[new branch\]\s+ master -> master/ ), 1 );
    test.identical( _.strCount( op.output, />.*git push --tags --force/ ), 1 );
    test.identical( _.strCount( op.output, /\* \[new tag\]\s+v000 -> v000/ ), 1 );
    test.identical( _.strCount( op.output, /\* \[new tag\]\s+init -> init/ ), 1 );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'throwing - 0, push to not existed repository';
    reposMake();
    programMake({ localPath : a.abs( 'repo' ), throwing : 0 });
    a.ready.then( () => { a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( 'main' ) ); return null });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git add .' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git commit -m init' });
    return a.shell( command );
  });
  ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /fatal: .*\/main\' does not appear to be a git repository/ ), 1 );
    test.identical( _.strCount( op.output, 'fatal: Could not read from remote repository.' ), 1 );
    test.identical( _.strCount( op.output, 'Please make sure you have the correct access rights' ), 1 );
    test.identical( _.strCount( op.output, 'Please make sure you have the correct access rights' ), 1 );
    test.identical( _.strCount( op.output, 'and the repository exists.' ), 1 );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'throwing - 1, push to not existed repository';
    reposMake();
    programMake({ localPath : a.abs( 'repo' ), throwing : 1 });
    a.ready.then( () => { a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( 'main' ) ); return null });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git add .' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git commit -m init' });
    return a.shellNonThrowing( command );
  });
  ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /fatal: .*\/main\' does not appear to be a git repository/ ), 2 );
    test.identical( _.strCount( op.output, 'fatal: Could not read from remote repository.' ), 2 );
    test.identical( _.strCount( op.output, 'Please make sure you have the correct access rights' ), 2 );
    test.identical( _.strCount( op.output, 'Please make sure you have the correct access rights' ), 2 );
    test.identical( _.strCount( op.output, 'and the repository exists.' ), 2 );
    return null;
  });

  /* - */

  return ready;

  /* */

  function reposMake()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'main' ) );
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      a.fileProvider.dirMake( a.abs( 'main' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    });
    a.shell({ currentPath : a.abs( 'main' ), execPath : `git init --bare` });
    a.shell({ currentPath : a.abs( '.' ), execPath : `git clone ./main ./repo` });
    return a.ready;
  }

  /* */

  function programMake( options )
  {
    return a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'testApp' ) );
      let locals = { toolsPath : _.module.resolve( 'wTools' ), o : options };
      return a.program({ entry : testApp, locals });
    });
  }

  /* */

  function testApp()
  {
    const _ = require( toolsPath );
    _.include( 'wGitTools' );
    return _.git.push( o );
  }

  /* */

  function commitAdd()
  {
    a.ready.then( () => { a.fileProvider.fileWrite( a.abs( 'repo/file.txt' ), 'file.txt' ); return null });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git add .' });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git commit -m init' });
    return a.ready;
  }
}

pushCheckOutput.timeOut = 60000;

//

function pushTags( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.shell.predefined.outputCollecting = 1;
  a.shell.predefined.currentPath = a.abs( 'repo' );

  /* - */

  begin().then( () =>
  {
    test.case = 'push tags without history, history changed';
    return null;
  });

  a.shell( 'git ls-remote --tags' );
  a.ready.then( ( op ) =>
  {
    test.description = 'before';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'refs/tags' ), 0 );
    return null;
  });

  commitAdd();
  tagAdd( 'v000' );
  tagAdd( 'v001' );
  tagAdd( 'v002' );
  a.shell( 'git reset --hard HEAD~' );
  a.ready.then( () =>
  {
    var errCallback = ( err, arg ) =>
    {
      test.true( _.errIs( err ) );
      test.identical( arg, undefined );
      test.identical( _.strCount( err.message, /Repository at .* has different commit history on remote server/ ), 2 );
    };
    test.shouldThrowErrorSync( () => _.git.push({ localPath : a.abs( 'repo' ), withTags : 1 }), errCallback );
    return null;
  });

  a.shell( 'git ls-remote --tags' );
  a.ready.then( ( op ) =>
  {
    test.description = 'after';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'refs/tags' ), 0 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'push tags with history, history changed, force - 1';
    return null;
  });

  a.shell( 'git ls-remote --tags' );
  a.ready.then( ( op ) =>
  {
    test.description = 'before';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'refs/tags' ), 0 );
    return null;
  });

  commitAdd();
  tagAdd( 'v000' );
  a.shell( 'git reset --hard HEAD~' );
  a.ready.then( () =>
  {
    var errCallback = ( err, arg ) =>
    {
      test.true( _.errIs( err ) );
      test.identical( arg, undefined );
      test.identical( _.strCount( err.message, /Repository at .* has different commit history on remote server/ ), 2 );
    };
    test.shouldThrowErrorSync( () => _.git.push({ localPath : a.abs( 'repo' ), withTags : 1, force : 1 }), errCallback );
    return null;
  });

  a.shell( 'git ls-remote --tags' );
  a.ready.then( ( op ) =>
  {
    test.description = 'after';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'refs/tags' ), 0 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'push tags without history, withHistory - 0';
    return null;
  });

  a.shell( 'git ls-remote --tags' );
  a.ready.then( ( op ) =>
  {
    test.description = 'before';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'refs/tags' ), 0 );
    return null;
  });

  commitAdd();
  tagAdd( 'v000' );
  a.ready.then( () =>
  {
    var errCallback = ( err, arg ) =>
    {
      test.true( _.errIs( err ) );
      test.identical( arg, undefined );
      test.identical( _.strCount( err.message, /Repository at .* has different commit history on remote server/ ), 2 );
    };
    test.shouldThrowErrorSync( () => _.git.push({ localPath : a.abs( 'repo' ), withTags : 1, withHistory : 0 }), errCallback );
    return null;
  });

  a.shell( 'git ls-remote --tags' );
  a.ready.then( ( op ) =>
  {
    test.description = 'after';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'refs/tags' ), 0 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'push tags with history, withHistory - 0, force - 1';
    return null;
  });

  a.shell( 'git ls-remote --tags' );
  a.ready.then( ( op ) =>
  {
    test.description = 'before';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'refs/tags' ), 0 );
    return null;
  });

  commitAdd();
  tagAdd( 'v000' );
  a.ready.then( () =>
  {
    var errCallback = ( err, arg ) =>
    {
      test.true( _.errIs( err ) );
      test.identical( arg, undefined );
      test.identical( _.strCount( err.message, /Repository at .* has different commit history on remote server/ ), 2 );
    };
    var o = { localPath : a.abs( 'repo' ), withTags : 1, withHistory : 0, force : 1 };
    test.shouldThrowErrorSync( () => _.git.push( o ), errCallback );
    return null;
  });

  a.shell( 'git ls-remote --tags' );
  a.ready.then( ( op ) =>
  {
    test.description = 'after';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'refs/tags' ), 0 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'remote repository has same tags';
    a.fileProvider.filesDelete( a.abs( 'clone' ) );
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });
  a.shell({ currentPath : a.abs( './clone/' ), execPath : 'git tag v000' });
  a.shell({ currentPath : a.abs( './clone/' ), execPath : 'git push --tags' });
  a.shell( 'git ls-remote --tags' );
  a.ready.then( ( op ) =>
  {
    test.description = 'before';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'v000' ), 1 );
    return null;
  });

  tagAdd( 'v000' );
  a.ready.then( () =>
  {
    var errCallback = ( err, arg ) =>
    {
      test.true( _.errIs( err ) );
      test.identical( arg, undefined );
      test.identical( _.strCount( err.message, /Remote repository of .* has the same tags as local repository/ ), 2 );
    };
    test.shouldThrowErrorSync( () => _.git.push({ localPath : a.abs( 'repo' ), withTags : 1 }), errCallback );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'remote repository has same tags, force - 1';
    a.fileProvider.filesDelete( a.abs( 'clone' ) );
    return null;
  });

  a.shell({ currentPath : a.abs( '.' ), execPath : 'git clone main clone' });
  a.shell({ currentPath : a.abs( './clone/' ), execPath : 'git tag v000' });
  a.shell({ currentPath : a.abs( './clone/' ), execPath : 'git push --tags' });
  a.shell( 'git ls-remote --tags' );
  a.ready.then( ( op ) =>
  {
    test.description = 'before';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'v000' ), 1 );
    return null;
  });

  tagAdd( 'v000' );
  a.ready.then( () =>
  {
    var got = _.git.push({ localPath : a.abs( 'repo' ), withTags : 1, force : 1 });
    test.identical( got.exitCode, 0 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( 'main' ) );
      a.fileProvider.filesDelete( a.abs( 'repo' ) );
      return null;
    });

    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'main' ) );
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    });
    a.shell({ currentPath : a.abs( 'main' ), execPath : `git init --bare` });

    a.shell( `git init` );
    a.shell( 'git remote add origin ../main' );
    commitAdd();
    a.shell( 'git push -u origin --all' );
    return a.ready;
  }

  /* */

  function commitAdd()
  {
    a.ready.then( () =>
    {
      a.fileProvider.fileAppend( a.abs( 'repo/file.txt' ), 'file.txt' );
      return null;
    });

    a.shell( 'git add .' );
    a.shell( 'git commit -m init' );
    return a.ready;
  }

  /* */

  function tagAdd( tag )
  {
    return a.ready.then( () =>
    {
      _.git.tagMake({ localPath : a.abs( 'repo' ), tag });
      return null;
    });
  }
}

pushTags.timeOut = 30000;

//

function reset( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.shell.predefined.outputCollecting = 1;
  a.shell.predefined.currentPath = a.abs( 'repo' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /*  */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'reset to HEAD, default options';
    var got = _.git.reset
    ({
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  /* - */

  a.ready.then( () =>
  {
    test.open( 'change state1' );
    return null;
  });

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'state - working, should not reset';
    var got = _.git.reset
    ({
      state1 : 'working',
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'modified' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'state - staged, should not reset';
    var got = _.git.reset
    ({
      state1 : 'staging',
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );
    let files = a.find( a.abs( 'repo' ) );
    test.identical( files, [ '.', './file' ] );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'state - committed, should reset';
    var got = _.git.reset
    ({
      state1 : 'committed',
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' );
  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });
  a.shell( 'git commit -am second' );

  a.ready.then( () =>
  {
    test.case = 'state - commit with Git syntax, should reset';
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `modified`;
    test.identical( read, exp );

    var got = _.git.reset
    ({
      state1 : '!HEAD~',
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' );
  var latestCommit;
  a.ready.then( () =>
  {
    latestCommit = a.fileProvider.fileRead( a.abs( 'repo/.git/refs/heads/master' ) );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });
  a.shell( 'git commit -am second' );

  a.ready.then( () =>
  {
    test.case = 'state - hash, should reset';
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `modified`;
    test.identical( read, exp );

    var got = _.git.reset
    ({
      state1 : `#${ latestCommit }`.trim(),
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' );
  a.ready.then( () =>
  {
    _.git.tagMake
    ({
      localPath : a.abs( 'repo' ),
      sync : 1,
      tag : 'v.0.0.0',
      description : 'v.0.0.0',
    });
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });
  a.shell( 'git commit -am second' );

  a.ready.then( () =>
  {
    test.case = 'state - tag, should reset';
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `modified`;
    test.identical( read, exp );

    var got = _.git.reset
    ({
      state1 : '!v.0.0.0',
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  a.ready.then( () =>
  {
    test.close( 'change state1' );
    return null;
  });

  /* - */

  a.ready.then( () =>
  {
    test.open( 'change state2' );
    return null;
  });

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'state - working, should not reset';
    var got = _.git.reset
    ({
      state2 : 'working',
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `modified`;
    test.identical( read, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'modified' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'state - staged, should not reset';
    var got = _.git.reset
    ({
      state2 : 'staging',
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `modified`;
    test.identical( read, exp );
    let files = a.find( a.abs( 'repo' ) );
    test.identical( files, [ '.', './file' ] );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'state - committed, should reset';
    var got = _.git.reset
    ({
      state2 : 'committed',
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' );
  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });
  a.shell( 'git commit -am second' );

  a.ready.then( () =>
  {
    test.case = 'state - commit with Git syntax, should reset';
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `modified`;
    test.identical( read, exp );

    var got = _.git.reset
    ({
      state2 : '!HEAD~',
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' );
  var latestCommit;
  a.ready.then( () =>
  {
    latestCommit = a.fileProvider.fileRead( a.abs( 'repo/.git/refs/heads/master' ) );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });
  a.shell( 'git commit -am second' );

  a.ready.then( () =>
  {
    test.case = 'state - hash, should reset';
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `modified`;
    test.identical( read, exp );

    var got = _.git.reset
    ({
      state2 : `#${ latestCommit }`.trim(),
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' );
  a.ready.then( () =>
  {
    _.git.tagMake
    ({
      localPath : a.abs( 'repo' ),
      sync : 1,
      tag : 'v.0.0.0',
      description : 'v.0.0.0',
    });
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });
  a.shell( 'git commit -am second' );

  a.ready.then( () =>
  {
    test.case = 'state - tag, should reset';
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `modified`;
    test.identical( read, exp );

    var got = _.git.reset
    ({
      state2 : '!v.0.0.0',
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  a.ready.then( () =>
  {
    test.close( 'change state2' );
    return null;
  });

  /* - */

  a.ready.then( () =>
  {
    test.open( 'change state1 and state2' );
    return null;
  });

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' );
  var latestCommit;
  a.ready.then( () =>
  {
    latestCommit = a.fileProvider.fileRead( a.abs( 'repo/.git/refs/heads/master' ) );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });

  a.shell( 'git commit -am second' );
  a.ready.then( () =>
  {
    test.case = 'state1 - latest commit, state2 - latest commit, should reset';
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `modified`;
    test.identical( read, exp );

    var got = _.git.reset
    ({
      state1 : `#${ latestCommit }`.trim(),
      state2 : `#${ latestCommit }`.trim(),
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' );
  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });
  a.shell( 'git commit -am second' );
  var latestCommit;
  a.ready.then( () =>
  {
    latestCommit = a.fileProvider.fileRead( a.abs( 'repo/.git/refs/heads/master' ) );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'file' );
    return null;
  });

  a.shell( 'git commit -am third' );
  a.ready.then( () =>
  {
    test.case = 'state1 - commit in tree, state2 - latest commit, should reset';
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `file`;
    test.identical( read, exp );

    var got = _.git.reset
    ({
      state1 : `!HEAD~2`,
      state2 : `#${ latestCommit }`.trim(),
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `modified`;
    test.identical( read, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' );
  a.ready.then( () =>
  {
    _.git.tagMake
    ({
      localPath : a.abs( 'repo' ),
      sync : 1,
      tag : 'v.0.0.0',
      description : 'v.0.0.0',
    });
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'modified' );
    return null;
  });
  a.shell( 'git commit -am second' );
  var latestCommit;
  a.ready.then( () =>
  {
    latestCommit = a.fileProvider.fileRead( a.abs( 'repo/.git/refs/heads/master' ) );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'file' );
    return null;
  });

  a.shell( 'git commit -am third' );
  a.ready.then( () =>
  {
    test.case = 'state1 - commit in tree, state2 - tag, should reset';
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `file`;
    test.identical( read, exp );

    var got = _.git.reset
    ({
      state1 : `#HEAD~2`,
      state2 : `!v.0.0.0`,
      localPath : a.abs( 'repo' ),
    });
    var read = a.fileProvider.fileRead( a.abs( 'repo', 'file' ) );
    var exp = `data`;
    test.identical( read, exp );

    return null;
  });

  a.ready.then( () =>
  {
    test.close( 'change state1 and state2' );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'repo' ) ));
    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    });
    a.shell( `git init` );
    return a.ready;
  }
}

reset.timeOut = 30000;

//

function resetWithOptionRemovingUntracked( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.shell.predefined.outputCollecting = 1;
  a.shell.predefined.currentPath = a.abs( 'repo' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'file2' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'removingUntracked - 0, should not delete untraked file';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file', './file2' ] );

    var got = _.git.reset
    ({
      localPath : a.abs( 'repo' ),
      removingUntracked : 0,
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file', './file2' ] );
    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'file2' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'removingUntracked - 1, should delete untraked file';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file', './file2' ] );

    var got = _.git.reset
    ({
      localPath : a.abs( 'repo' ),
      removingUntracked : 1,
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file' ] );
    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', '.gitignore' ), 'file2' );
    return null;
  });
  a.shell( 'git add .' );
  a.shell( 'git commit -m gitignore' );

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'file2' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'removingUntracked - 0, should not delete untraked file';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file', './file2' ] );

    var got = _.git.reset
    ({
      localPath : a.abs( 'repo' ),
      removingUntracked : 0,
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file', './file2' ] );
    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', '.gitignore' ), 'file2' );
    return null;
  });
  a.shell( 'git add .' );
  a.shell( 'git commit -m gitignore' );

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'file2' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'removingUntracked - 1, should delete untraked file';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file', './file2' ] );

    var got = _.git.reset
    ({
      localPath : a.abs( 'repo' ),
      removingUntracked : 1,
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file', './file2' ] );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'repo' ) ));
    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    });
    a.shell( `git init` );
    return a.ready;
  }
}

resetWithOptionRemovingUntracked.timeOut = 30000;

//

function resetWithOptionRemovingSubrepositories( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.shell.predefined.outputCollecting = 1;
  a.shell.predefined.currentPath = a.abs( 'repo' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo/sub', 'file' ), 'file2' );
    return null;
  });
  a.shell({ currentPath : a.abs( 'repo/sub' ), execPath : 'git init' });

  a.ready.then( () =>
  {
    test.case = 'removingSubrepositories - 1, removingUntracked - 0, should not delete subrepository';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file', './sub', './sub/file' ] );

    var got = _.git.reset
    ({
      localPath : a.abs( 'repo' ),
      removingUntracked : 0,
      removingSubrepositories : 1,
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file', './sub', './sub/file' ] );
    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo/sub', 'file' ), 'file2' );
    return null;
  });
  a.shell({ currentPath : a.abs( 'repo/sub' ), execPath : 'git init' });

  a.ready.then( () =>
  {
    test.case = 'removingSubrepositories - 0, removingUntracked - 1, should not delete subrepository';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file', './sub', './sub/file' ] );

    var got = _.git.reset
    ({
      localPath : a.abs( 'repo' ),
      removingUntracked : 1,
      removingSubrepositories : 0,
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file', './sub', './sub/file' ] );
    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo/sub', 'file' ), 'file2' );
    return null;
  });
  a.shell({ currentPath : a.abs( 'repo/sub' ), execPath : 'git init' });

  a.ready.then( () =>
  {
    test.case = 'removingSubrepositories - 1, removingUntracked - 1, should delete subrepository';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file', './sub', './sub/file' ] );

    var got = _.git.reset
    ({
      localPath : a.abs( 'repo' ),
      removingUntracked : 1,
      removingSubrepositories : 1,
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file' ] );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'repo' ) ));
    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    });
    a.shell( `git init` );
    return a.ready;
  }
}

resetWithOptionRemovingSubrepositories.timeOut = 30000;

//

function resetWithOptionRemovingIgnored( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.shell.predefined.outputCollecting = 1;
  a.shell.predefined.currentPath = a.abs( 'repo' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', '.gitignore' ), 'file2' );
    return null;
  });
  a.shell( 'git add .' );
  a.shell( 'git commit -m gitignore' );

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'file2' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'removingIgnored - 1, removingUntracked - 0, should not delete untraked file';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file', './file2' ] );

    var got = _.git.reset
    ({
      localPath : a.abs( 'repo' ),
      removingUntracked : 0,
      removingIgnored : 1,
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file', './file2' ] );
    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', '.gitignore' ), 'file2' );
    return null;
  });
  a.shell( 'git add .' );
  a.shell( 'git commit -m gitignore' );

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'file2' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'removingIgnored - 0, removingUntracked - 1, should not delete untraked file';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file', './file2' ] );

    var got = _.git.reset
    ({
      localPath : a.abs( 'repo' ),
      removingUntracked : 1,
      removingIgnored : 0,
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file', './file2' ] );
    return null;
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    return null;
  });

  a.shell( 'git add file' );
  a.shell( 'git commit -m init' )
  .then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', '.gitignore' ), 'file2' );
    return null;
  });
  a.shell( 'git add .' );
  a.shell( 'git commit -m gitignore' );

  a.ready.then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'file2' );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'removingIgnored - 1, removingUntracked - 1, should delete untraked file';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file', './file2' ] );

    var got = _.git.reset
    ({
      localPath : a.abs( 'repo' ),
      removingUntracked : 1,
      removingIgnored : 1,
    });

    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file' ] );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'repo' ) ));
    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    });
    a.shell( `git init` );
    return a.ready;
  }
}

resetWithOptionRemovingIgnored.timeOut = 30000;

//

function resetWithOptionDry( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let program;

  a.shell.predefined.outputCollecting = 1;
  a.shell.predefined.currentPath = a.abs( 'repo' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  let programShell = _.process.starter
  ({
    currentPath : a.abs( '.' ),
    mode : 'shell',
    throwingExitCode : 1,
    outputCollecting : 1,
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file1' ), 'data' );
    return null;
  });

  a.shell( 'git add .' );
  a.shell( 'git commit -m init' );

  a.ready.then( () =>
  {
    test.case = 'repository is not changed, nothing to reset';
    let o =
    {
      localPath : a.abs( 'repo' ),
      removingUntracked : 1,
      removingIgnored : 1,
      dry : 1,
    };
    program = programMake({ o });
    return null;
  });

  a.ready.then( () =>
  {
    return programShell( 'node ' + _.path.nativize( program.filePath/*programPath*/ ) )
    .then( ( op ) =>
    {
      test.identical( _.strCount( op.output, 'Uncommitted changes, would be reseted :' ), 1 );
      test.identical( _.strCount( op.output, 'file' ), 0 );
      test.identical( _.strCount( op.output, 'file1' ), 0 );
      test.identical( _.strCount( op.output, 'Uncommitted changes, would be cleaned :' ), 1 );

      var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
      test.identical( got, [ '.', './file', './file1' ] );
      return null;
    })
    .then( () =>
    {
      return a.fileProvider.filesDelete( program.filePath/*programPath*/ );
    });
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file1' ), 'data' );
    return null;
  });

  a.shell( 'git add .' );
  a.shell( 'git commit -m init' );

  a.ready.then( () =>
  {
    let o =
    {
      localPath : a.abs( 'repo' ),
      removingUntracked : 0,
      removingIgnored : 1,
      dry : 1,
    };
    program = programMake({ o });

    a.fileProvider.fileAppend( a.abs( 'repo', 'file' ), 'new data' );
    a.fileProvider.fileDelete( a.abs( 'repo', 'file1' ) );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'file2' );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file3' ), 'file3' );
    return null;
  });

  a.shell( 'git add file2' );

  a.ready.then( () =>
  {
    test.case = 'repository changed, without untraked';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file', './file2', './file3' ] );
    return null
  });

  a.ready.then( () =>
  {
    return programShell( 'node ' + _.path.nativize( program.filePath/*programPath*/ ) )
    .then( ( op ) =>
    {
      test.identical( _.strCount( op.output, 'Uncommitted changes, would be reseted :' ), 1 );
      test.identical( _.strCount( op.output, 'M file' ), 1 );
      test.identical( _.strCount( op.output, 'D file1' ), 1 );
      test.identical( _.strCount( op.output, 'Uncommitted changes, would be cleaned :' ), 1 );

      var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
      test.identical( got, [ '.', './file', './file2', './file3' ] );
      return null;
    })
    .then( () =>
    {
      return a.fileProvider.filesDelete( program.filePath/*programPath*/ );
    });
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file1' ), 'data' );
    return null;
  });

  a.shell( 'git add .' );
  a.shell( 'git commit -m init' );

  a.ready.then( () =>
  {
    let o =
    {
      localPath : a.abs( 'repo' ),
      removingUntracked : 1,
      removingIgnored : 1,
      dry : 1,
    };
    program = programMake({ o });

    a.fileProvider.fileAppend( a.abs( 'repo', 'file' ), 'new data' );
    a.fileProvider.fileDelete( a.abs( 'repo', 'file1' ) );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'file2' );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file3' ), 'file3' );
    return null;
  });

  a.shell( 'git add file2' );

  a.ready.then( () =>
  {
    test.case = 'repository changed, with untraked';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './file', './file2', './file3' ] );
    return null
  });

  a.ready.then( () =>
  {
    return programShell( 'node ' + _.path.nativize( program.filePath/*programPath*/ ) )
    .then( ( op ) =>
    {
      test.identical( _.strCount( op.output, 'Uncommitted changes, would be reseted :' ), 1 );
      test.identical( _.strCount( op.output, 'M file' ), 1 );
      test.identical( _.strCount( op.output, 'D file1' ), 1 );
      test.identical( _.strCount( op.output, 'Uncommitted changes, would be cleaned :' ), 1 );
      test.identical( _.strCount( op.output, '?? file3' ), 1 );
      test.identical( _.strCount( op.output, 'A  file2' ), 1 );

      var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
      test.identical( got, [ '.', './file', './file2', './file3' ] );
      return null;
    })
    .then( () =>
    {
      return a.fileProvider.filesDelete( program.filePath/*programPath*/ );
    });
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file1' ), 'data' );
    a.fileProvider.fileWrite( a.abs( 'repo', '.gitignore' ), 'file3' );
    return null;
  });

  a.shell( 'git add .' );
  a.shell( 'git commit -m init' );

  a.ready.then( () =>
  {
    let o =
    {
      localPath : a.abs( 'repo' ),
      removingUntracked : 1,
      removingIgnored : 0,
      dry : 1,
    };
    program = programMake({ o });

    a.fileProvider.fileAppend( a.abs( 'repo', 'file' ), 'new data' );
    a.fileProvider.fileDelete( a.abs( 'repo', 'file1' ) );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'file2' );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file3' ), 'file3' );
    return null;
  });

  a.shell( 'git add file2' );

  a.ready.then( () =>
  {
    test.case = 'repository changed, with untraked and without ignored';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file', './file2', './file3' ] );
    return null
  });

  a.ready.then( () =>
  {
    return programShell( 'node ' + _.path.nativize( program.filePath/*programPath*/ ) )
    .then( ( op ) =>
    {
      test.identical( _.strCount( op.output, 'Uncommitted changes, would be reseted :' ), 1 );
      test.identical( _.strCount( op.output, 'M file' ), 1 );
      test.identical( _.strCount( op.output, 'D file1' ), 1 );
      test.identical( _.strCount( op.output, 'Uncommitted changes, would be cleaned :' ), 1 );
      test.identical( _.strCount( op.output, '!! file3' ), 0 );
      test.identical( _.strCount( op.output, 'A  file2' ), 1 );

      var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
      test.identical( got, [ '.', './.gitignore', './file', './file2', './file3' ] );
      return null;
    })
    .then( () =>
    {
      return a.fileProvider.filesDelete( program.filePath/*programPath*/ );
    });
  });

  /* */

  begin().then( () =>
  {
    a.fileProvider.fileWrite( a.abs( 'repo', 'file' ), 'data' );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file1' ), 'data' );
    a.fileProvider.fileWrite( a.abs( 'repo', '.gitignore' ), 'file3' );
    return null;
  });

  a.shell( 'git add .' );
  a.shell( 'git commit -m init' );

  a.ready.then( () =>
  {
    let o =
    {
      localPath : a.abs( 'repo' ),
      removingUntracked : 1,
      removingIgnored : 1,
      dry : 1,
    };
    program = programMake({ o });

    a.fileProvider.fileAppend( a.abs( 'repo', 'file' ), 'new data' );
    a.fileProvider.fileDelete( a.abs( 'repo', 'file1' ) );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file2' ), 'file2' );
    a.fileProvider.fileWrite( a.abs( 'repo', 'file3' ), 'file3' );
    return null;
  });

  a.shell( 'git add file2' );

  a.ready.then( () =>
  {
    test.case = 'repository changed, with untraked and with ignored';
    var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
    test.identical( got, [ '.', './.gitignore', './file', './file2', './file3' ] );
    return null
  });

  a.ready.then( () =>
  {
    return programShell( 'node ' + _.path.nativize( program.filePath/*programPath*/ ) )
    .then( ( op ) =>
    {
      test.identical( _.strCount( op.output, 'Uncommitted changes, would be reseted :' ), 1 );
      test.identical( _.strCount( op.output, 'M file' ), 1 );
      test.identical( _.strCount( op.output, 'D file1' ), 1 );
      test.identical( _.strCount( op.output, 'Uncommitted changes, would be cleaned :' ), 1 );
      test.identical( _.strCount( op.output, '!! file3' ), 1 );
      test.identical( _.strCount( op.output, 'A  file2' ), 1 );

      var got = a.find({ filePath : a.abs( 'repo' ), outputFormat : 'relative' });
      test.identical( got, [ '.', './.gitignore', './file', './file2', './file3' ] );
      return null;
    })
    .then( () =>
    {
      return a.fileProvider.filesDelete( program.filePath/*programPath*/ );
    });
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'repo' ) ));
    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'repo' ) );
      return null;
    });
    a.shell( `git init` );
    return a.ready;
  }

  /* */

  function programMake( locals )
  {
    locals = _.mapSupplement( { toolsPath : _.module.resolve( 'wTools' ) }, locals );
    return a.program({ entry : testApp, locals });
  }

  /* */

  function testApp()
  {
    const _ = require( toolsPath );
    _.include( 'wGitTools' )
    _.git.reset( o );
  }
}

resetWithOptionDry.timeOut = 30000;

//

function commitsDates( test )
{
  const a = test.assetFor( false );
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const srcCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';

  /* */

  let originalHistory = [];
  begin().then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    originalHistory = op;
    return null
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'relative - commit, change no date';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : 0,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.identical( op, originalHistory );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 is not last commit';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : '#af815d4eaaf1df0505da1e1b2e526a7d04cdce7e',
      relative : 'commit',
      delta : 0,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.identical( op, originalHistory );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - now, change date to current';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'now',
      delta : 0,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.le( Date.parse( op[ 12 ].date ), Date.now() );
    test.ge( Date.parse( op[ 12 ].date ), Date.now() - 20000 );
    test.le( Date.parse( op[ 0 ].date ), Date.now() );
    test.ge( Date.parse( op[ 0 ].date ), Date.now() - 20000 );
    for( let i = 0 ; i < op.length ; i++ )
    test.identical( op[ i ].date, op[ i ].commiterDate );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - now, state2 is not last commit';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : '#af815d4eaaf1df0505da1e1b2e526a7d04cdce7e',
      relative : 'now',
      delta : 0,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.le( Date.parse( op[ 12 ].date ), Date.now() );
    test.ge( Date.parse( op[ 12 ].date ), Date.now() - 20000 );
    test.le( Date.parse( op[ 0 ].date ), Date.parse( originalHistory[ 0 ].date ) );
    for( let i = 0 ; i < op.length ; i++ )
    test.identical( op[ i ].date, op[ i ].commiterDate );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ srcRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ srcCommit }` );
  }
}

//

function commitsDatesWithOptionDelta( test )
{
  const a = test.assetFor( false );
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const srcCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';

  /* */

  let originalHistory = [];
  begin().then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    originalHistory = op;
    return null
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, positive delta, one hour in miliseconds';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : 3600000,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), 3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), 3600000 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 is not last commit, positive delta, one hour in miliseconds';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : '#af815d4eaaf1df0505da1e1b2e526a7d04cdce7e',
      relative : 'commit',
      delta : 3600000,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), 3600000 );
    test.identical( Date.parse( op[ 0 ].date ), Date.parse( originalHistory[ 0 ].date ) );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - now, state2 - to last commit, positive delta, one hour in miliseconds';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'now',
      delta : 3600000,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.ge( Date.parse( op[ 12 ].date ) - Date.now(), 3500000 );
    test.le( Date.parse( op[ 12 ].date ) - Date.now(), 3600000 );
    test.ge( Date.parse( op[ 0 ].date ) - Date.now(), 3500000 );
    test.le( Date.parse( op[ 0 ].date ) - Date.now(), 3600000 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - now, state2 is not last commit, positive delta, one hour in miliseconds';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : '#af815d4eaaf1df0505da1e1b2e526a7d04cdce7e',
      relative : 'now',
      delta : 3600000,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.ge( Date.parse( op[ 12 ].date ) - Date.now(), 3500000 );
    test.le( Date.parse( op[ 12 ].date ) - Date.now(), 3600000 );
    test.ge( Date.parse( op[ 0 ].date ), Date.parse( originalHistory[ 0 ].date ) );
    return null;
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, negative delta, one hour in miliseconds';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : -3600000,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), -3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), -3600000 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 is not last commit, positive delta, one hour in miliseconds';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : '#af815d4eaaf1df0505da1e1b2e526a7d04cdce7e',
      relative : 'commit',
      delta : -3600000,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), -3600000 );
    test.identical( Date.parse( op[ 0 ].date ), Date.parse( originalHistory[ 0 ].date ) );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - now, state2 - to last commit, positive delta, one hour in miliseconds';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'now',
      delta : -3600000,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.ge( Date.now() - Date.parse( op[ 12 ].date ), 3500000 );
    test.le( Date.now() - Date.parse( op[ 12 ].date ), 3700000 );
    test.ge( Date.now() - Date.parse( op[ 0 ].date ), 3500000 );
    test.le( Date.now() - Date.parse( op[ 0 ].date ), 3700000 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - now, state2 is not last commit, positive delta, one hour in miliseconds';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : '#af815d4eaaf1df0505da1e1b2e526a7d04cdce7e',
      relative : 'now',
      delta : -3600000,
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.ge( Date.now() - Date.parse( op[ 12 ].date ), 3500000 );
    test.le( Date.now() - Date.parse( op[ 12 ].date ), 3700000 );
    test.ge( Date.parse( op[ 0 ].date ), Date.parse( originalHistory[ 0 ].date ) );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ srcRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ srcCommit }` );
  }
}

commitsDatesWithOptionDelta.timeOut = 120000;

//

function commitsDatesWithOptionDeltaAsString( test )
{
  const a = test.assetFor( false );
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const srcCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';

  /* */

  let originalHistory = [];
  begin().then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    originalHistory = op;
    return null
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, positive delta, one hour';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : '01:00:00',
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), 3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), 3600000 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, negative delta, one hour';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : '-01:00:00',
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), -3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), -3600000 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, positive delta, two days';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : '48:00:00',
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), 86400000 * 2 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), 86400000 * 2 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, negative delta, one hour in miliseconds';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : '-48:00:00',
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), -86400000 * 2 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), -86400000 * 2 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ srcRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ srcCommit }` );
  }
}

//

function commitsDatesWithOptionDeltaAsStringUnits( test )
{
  const a = test.assetFor( false );
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const srcCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';

  /* */

  let originalHistory = [];
  begin().then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    originalHistory = op;
    return null
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, positive delta, one hour';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : '1h',
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), 3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), 3600000 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, negative delta, one hour';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : '-1h',
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), -3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), -3600000 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, positive delta, two days';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : '2d',
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), 86400000 * 2 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), 86400000 * 2 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, negative delta, one hour in miliseconds';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : '-2d',
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), -86400000 * 2 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), -86400000 * 2 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, positive delta, 2d 1h 30m 60s 1000ms';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : '2d 1h 30m 60s 1000ms',
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    var delta = 86400000 * 2 + 3600000 + 31 * 60000 + 1000;
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), delta );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), delta );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, negative delta, 2d 1h 30m 60s 1000ms';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : '-2d 1h 30m 60s 1000ms',
      periodic : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    var delta = -1 * ( 86400000 * 2 + 3600000 + 31 * 60000 + 1000 );
    test.identical( Date.parse( op[ 12 ].date ) - Date.parse( originalHistory[ 12 ].date ), delta );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), delta );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ srcRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ srcCommit }` );
  }
}

commitsDatesWithOptionDeltaAsStringUnits.timeOut = 60000;

//

function commitsDatesWithOptionPeriodic( test )
{
  const a = test.assetFor( false );
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const srcCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';

  /* */

  let originalHistory = [];
  begin().then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    originalHistory = op;
    return null
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'relative - now, state2 - to last commit, positive delta, periodic - one hour';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'now',
      delta : '01:00:00',
      periodic : '01:00:00',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );
    test.ge( Date.parse( op[ 11 ].date ) - _.time.now(), 3500000 );
    test.le( Date.parse( op[ 11 ].date ) - _.time.now(), 7300000 );

    test.identical( Date.parse( op[ 11 ].date ) - Date.parse( op[ 12 ].date ), 3600000 );
    test.identical( Date.parse( op[ 10 ].date ) - Date.parse( op[ 11 ].date ), 3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( op[ 1 ].date ), 3600000 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'relative - commit, state2 - to last commit, positive delta, periodic - one hour';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'commit',
      delta : '01:00:00',
      periodic : '01:00:00',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );

    test.identical( Date.parse( op[ 11 ].date ) - Date.parse( originalHistory[ 11 ].date ), 2 * 3600000 );
    test.identical( Date.parse( op[ 10 ].date ) - Date.parse( originalHistory[ 10 ].date ), 3 * 3600000 );
    test.identical( Date.parse( op[ 0 ].date ) - Date.parse( originalHistory[ 0 ].date ), 13 * 3600000 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ srcRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ srcCommit }` );
  }
}

//

function commitsDatesWithOptionDeviation( test )
{
  const a = test.assetFor( false );
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const srcCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';

  /* */

  let originalHistory = [];
  begin().then( () =>
  {
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    originalHistory = op;
    return null
  });

  /* - */

  begin().then( () =>
  {
    test.case = 'relative - now, state2 - to last commit, positive delta, periodic - one hour';
    return _.git.commitsDates
    ({
      localPath : a.abs( '.' ),
      state1 : '#af36e28bc91b6f18e4babc810bbf5bc758ccf19f',
      state2 : null,
      relative : 'now',
      delta : '01:00:00',
      periodic : '01:00:00',
      deviation : '00:10:00',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    return _.git.repositoryHistoryToJson
    ({
      localPath : a.abs( '.' ),
      state1 : '#8d8d2d753046cad7a90324138e332d3fe1d798d2',
      state2 : '#HEAD',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.length, 14 );
    test.notIdentical( op, originalHistory );
    test.identical( op[ 13 ], originalHistory[ 13 ] );
    test.notIdentical( op[ 12 ], originalHistory[ 12 ] );
    test.identical( op[ 12 ].message, originalHistory[ 12 ].message );
    test.identical( op[ 12 ].author, originalHistory[ 12 ].author );
    test.notIdentical( op[ 0 ], originalHistory[ 0 ] );
    test.identical( op[ 0 ].message, originalHistory[ 0 ].message );
    test.identical( op[ 0 ].author, originalHistory[ 0 ].author );

    test.ge( Date.parse( op[ 11 ].date ) - Date.parse( op[ 12 ].date ), 2000000 );
    test.le( Date.parse( op[ 11 ].date ) - Date.parse( op[ 12 ].date ), 5000000 );
    test.ge( Date.parse( op[ 10 ].date ) - Date.parse( op[ 11 ].date ), 2000000 );
    test.le( Date.parse( op[ 10 ].date ) - Date.parse( op[ 11 ].date ), 5000000 );
    test.ge( Date.parse( op[ 0 ].date ) - Date.parse( op[ 1 ].date ), 2000000 );
    test.le( Date.parse( op[ 0 ].date ) - Date.parse( op[ 1 ].date ), 5000000 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ srcRepositoryRemote } ./` );
    return a.shell( `git reset --hard ${ srcCommit }` );
  }
}

//

function tagList( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* - */

  begin().then( () =>
  {
    test.case = 'list tags, withDescription - 1, lines - 1';
    var got = _.git.tagList
    ({
      localPath : a.abs( '.' ),
      withDescription : 1,
      lines : 1,
    });
    test.identical( _.strCount( got, /v000\s+version\s+000/ ), 0 );
    test.identical( _.strCount( got, /v000\s+version\s+/ ), 1 );
    test.identical( _.strCount( got, /v001\s+version\s+001/ ), 0 );
    test.identical( _.strCount( got, /v001\s+version\s+/ ), 1 );
    test.identical( _.strCount( got, /v002\s+/ ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'list tags, withDescription - 1, lines - 2';
    var got = _.git.tagList
    ({
      localPath : a.abs( '.' ),
      withDescription : 1,
      lines : 2,
    });
    test.identical( _.strCount( got, /v000\s+version\s+000/ ), 1 );
    test.identical( _.strCount( got, /v000\s+version\s+/ ), 1 );
    test.identical( _.strCount( got, /v001\s+version\s+001/ ), 1 );
    test.identical( _.strCount( got, /v001\s+version\s+/ ), 1 );
    test.identical( _.strCount( got, /v002\s+/ ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'list tags, withDescription - 0, lines - 2';
    var got = _.git.tagList
    ({
      localPath : a.abs( '.' ),
      withDescription : 0,
      lines : 2,
    });
    test.identical( _.strCount( got, /v000\s+version\s+000/ ), 0 );
    test.identical( _.strCount( got, /v000\s+version\s+/ ), 0 );
    test.identical( _.strCount( got, /v000\s+/ ), 1 );
    test.identical( _.strCount( got, /v001\s+version\s+001/ ), 0 );
    test.identical( _.strCount( got, /v001\s+version\s+/ ), 0 );
    test.identical( _.strCount( got, /v001\s+/ ), 1 );
    test.identical( _.strCount( got, /v002\s+/ ), 1 );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.tagList() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '.' ) };
        return _.git.tagList( o, o );
      });

      test.case = 'unknown option in options map o';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '.' ), unknown : 1 };
        return _.git.tagList( o );
      });

      test.case = 'wrong type of o.localPath';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : 1 };
        return _.git.tagList( o );
      });

      test.case = 'wrong type of o.lines';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '.' ), lines : 'ab' };
        return _.git.tagList( o );
      });

      test.case = 'o.localPath is not a repository';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '..' ) };
        return _.git.tagList( o );
      });

      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( '.' ) ) );
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git init` );
    a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( 'file.txt' ), 'file.txt' );
      return null;
    });
    a.shell( 'git add .' );
    a.shell( 'git commit -m init' );
    a.ready.then( () =>
    {
      _.git.tagMake
      ({
        localPath : a.abs( '.' ),
        tag : 'v000',
        description : 'version\n000',
      });
      _.git.tagMake
      ({
        localPath : a.abs( '.' ),
        tag : 'v001',
        description : 'version\n001',
      });
      _.git.tagMake
      ({
        localPath : a.abs( '.' ),
        tag : 'v002',
      });
      return null;
    });

    return a.ready;
  }
}

tagList.timeOut = 60000;

//

function tagDeleteBranch( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* - */

  begin().then( () =>
  {
    test.case = 'delete branch that exists only in local repository, remote - 1, force - 1';
    return null;
  });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git branch new' });
  a.ready.then( () =>
  {
    return _.git.tagDeleteBranch
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 1,
      force : 1,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted branch new (was' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'delete branch that exists in local and remote repositories, remote - 1, force - 1';
    return null;
  });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git branch new' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push origin new' });
  a.ready.then( () =>
  {
    return _.git.tagDeleteBranch
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 1,
      force : 1,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted branch new (was' ), 1 );
    test.identical( _.strCount( op.output, /To .*/ ), 1 );
    test.identical( _.strCount( op.output, /- \[deleted\]\s+new/ ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'delete branch that exists in local and remote repositories, remote - 0, force - 1';
    return null;
  });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git branch new' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push origin new' });
  a.ready.then( () =>
  {
    return _.git.tagDeleteBranch
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 0,
      force : 1,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted branch new (was' ), 1 );
    test.identical( _.strCount( op.output, /To .*/ ), 0 );
    test.identical( _.strCount( op.output, /- \[deleted\]\s+new/ ), 0 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'delete branch that exists in local and remote repositories, remote - 1, force - 0';
    return null;
  });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git branch new' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push origin new' });
  a.ready.then( () =>
  {
    return _.git.tagDeleteBranch
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 1,
      force : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted branch new (was' ), 1 );
    test.identical( _.strCount( op.output, /To .*/ ), 1 );
    test.identical( _.strCount( op.output, /- \[deleted\]\s+new/ ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'delete branch that exists in local and remote repositories, remote - 1, force - 0, local - 0';
    return null;
  });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git branch new' });
  a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push origin new' });
  a.ready.then( () =>
  {
    return _.git.tagDeleteBranch
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 1,
      local : 0,
      force : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted branch new (was' ), 0 );
    test.identical( _.strCount( op.output, /To .*/ ), 1 );
    test.identical( _.strCount( op.output, /- \[deleted\]\s+new/ ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'delete not existed tag, throwing - 0';
    return null;
  });
  a.ready.then( () =>
  {
    return _.git.tagDeleteBranch
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 1,
      local : 1,
      force : 1,
      throwing : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted branch new (was' ), 0 );
    test.identical( _.strCount( op.output, /To .*/ ), 0 );
    test.identical( _.strCount( op.output, /- \[deleted\]\s+new/ ), 0 );
    test.identical( _.strCount( op.output, 'rror: branch \'new\' not found.' ), 1 );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.tagDeleteBranch() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '.' ), tag : 'v0' };
        return _.git.tagDeleteBranch( o, o );
      });

      test.case = 'unknown option in options map o';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '.' ), tag : 'v0', unknown : 1 };
        return _.git.tagDeleteBranch( o );
      });

      test.case = 'wrong type of o.localPath';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : 1, tag : 'v0' };
        return _.git.tagDeleteBranch( o );
      });

      test.case = 'o.tag is not defined';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : 1, tag : '' };
        return _.git.tagDeleteBranch( o );
      });

      test.case = 'o.local - 0, o.remote - 0';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : 1, tag : 'new', local : 0, remote : 0 };
        return _.git.tagDeleteBranch( o );
      });

      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'repo' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'repo' ) ); return null });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git init --bare' });
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'clone' ) ) );
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'clone' ) ); return null });
    a.shell( 'git clone repo clone' );
    a.ready.then( () =>
    {
      a.fileProvider.fileAppend( a.abs( 'clone/file.txt' ), 'file.txt' );
      return null;
    });
    a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git add .' });
    a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git commit -m init' });
    a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push -u origin master' });
    return a.ready;
  }
}

//

function tagDeleteTag( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* - */

  begin().then( () =>
  {
    test.case = 'delete tag that exists only in local repository, remote - 1, force - 1';
    tagMake( 'new' );
    return null;
  });
  a.ready.then( () =>
  {
    return _.git.tagDeleteTag
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 1,
      force : 1,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted tag \'new\' (was' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'delete tag that exists in local and remote repositories, remote - 1, force - 1';
    tagMake( 'new' );
    tagsPush();
    return null;
  });
  a.ready.then( () =>
  {
    return _.git.tagDeleteTag
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 1,
      force : 1,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted tag \'new\' (was' ), 1 );
    test.identical( _.strCount( op.output, /To .*/ ), 1 );
    test.identical( _.strCount( op.output, /- \[deleted\]\s+new/ ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'delete branch that exists in local and remote repositories, remote - 0, force - 1';
    tagMake( 'new' );
    tagsPush();
    return null;
  });
  a.ready.then( () =>
  {
    return _.git.tagDeleteTag
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 0,
      force : 1,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted tag \'new\' (was' ), 1 );
    test.identical( _.strCount( op.output, /To .*/ ), 0 );
    test.identical( _.strCount( op.output, /- \[deleted\]\s+new/ ), 0 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'delete branch that exists in local and remote repositories, remote - 1, force - 0';
    tagMake( 'new' );
    tagsPush();
    return null;
  });
  a.ready.then( () =>
  {
    return _.git.tagDeleteTag
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 1,
      force : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted tag \'new\' (was' ), 1 );
    test.identical( _.strCount( op.output, /To .*/ ), 1 );
    test.identical( _.strCount( op.output, /- \[deleted\]\s+new/ ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'delete branch that exists in local and remote repositories, remote - 1, force - 0, local - 0';
    tagMake( 'new' );
    tagsPush();
    return null;
  });
  a.ready.then( () =>
  {
    return _.git.tagDeleteTag
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 1,
      local : 0,
      force : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted tag \'new\' (was' ), 0 );
    test.identical( _.strCount( op.output, /To .*/ ), 1 );
    test.identical( _.strCount( op.output, /- \[deleted\]\s+new/ ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'delete not existed tag, throwing - 0';
    return null;
  });
  a.ready.then( () =>
  {
    return _.git.tagDeleteTag
    ({
      localPath : a.abs( 'clone' ),
      tag : 'new',
      remote : 1,
      local : 1,
      force : 1,
      throwing : 0,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Deleted tag \'new\' (was' ), 0 );
    test.identical( _.strCount( op.output, /To .*/ ), 0 );
    test.identical( _.strCount( op.output, /- \[deleted\]\s+new/ ), 0 );
    test.identical( _.strCount( op.output, 'rror: tag \'new\' not found.' ), 1 );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.tagDeleteTag() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '.' ), tag : 'v0' };
        return _.git.tagDeleteTag( o, o );
      });

      test.case = 'unknown option in options map o';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '.' ), tag : 'v0', unknown : 1 };
        return _.git.tagDeleteTag( o );
      });

      test.case = 'wrong type of o.localPath';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : 1, tag : 'v0' };
        return _.git.tagDeleteTag( o );
      });

      test.case = 'o.tag is not defined';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : 1, tag : '' };
        return _.git.tagDeleteTag( o );
      });

      test.case = 'o.local - 0, o.remote - 0';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : 1, tag : 'new', local : 0, remote : 0 };
        return _.git.tagDeleteTag( o );
      });

      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'repo' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'repo' ) ); return null });
    a.shell({ currentPath : a.abs( 'repo' ), execPath : 'git init --bare' });
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( 'clone' ) ) );
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( 'clone' ) ); return null });
    a.shell( 'git clone repo clone' );
    a.ready.then( () =>
    {
      a.fileProvider.fileAppend( a.abs( 'clone/file.txt' ), 'file.txt' );
      return null;
    });
    a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git add .' });
    a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git commit -m init' });
    a.shell({ currentPath : a.abs( 'clone' ), execPath : 'git push -u origin master' });
    return a.ready;
  }

  /* */

  function tagMake( tag )
  {
    _.git.tagMake
    ({
      localPath : a.abs( 'clone' ),
      tag,
      force : 1,
      sync : 1,
    });
  }

  /* */

  function tagsPush()
  {
    _.git.push
    ({
      localPath : a.abs( 'clone' ),
      withHistory : 0,
      withTags : 1,
      force : 1,
      sync : 1,
    });
  }
}

//

function tagMake( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* - */

  begin().then( () =>
  {
    test.case = 'make lightweight tag';
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      light : 1,
    });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git tag -ln' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 2 );
    test.identical( _.strCount( op.output, 'v000' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'make two lightweight tags in single commit';
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      light : 1,
    });
    test.identical( got.exitCode, 0 );
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v001',
      light : 1,
    });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git tag -ln' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 3 );
    test.identical( _.strCount( op.output, 'v000' ), 1 );
    test.identical( _.strCount( op.output, 'v001' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'make two lightweight tags with the same name in single commit, force - 1';
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      light : 1,
    });
    test.identical( got.exitCode, 0 );
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      light : 1,
    });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git tag -ln' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 2 );
    test.identical( _.strCount( op.output, 'v000' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'make tag without description';
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
    });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git tag -ln' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 2 );
    test.identical( _.strCount( op.output, 'v000' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'make two tags without description in single commit';
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
    });
    test.identical( got.exitCode, 0 );
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v001',
    });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git tag -ln' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 3 );
    test.identical( _.strCount( op.output, 'v000' ), 1 );
    test.identical( _.strCount( op.output, 'v001' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'make two tags without description, tags have the same name, force - 1';
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
    });
    test.identical( got.exitCode, 0 );
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
    });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git tag -ln' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 2 );
    test.identical( _.strCount( op.output, 'v000' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'make tag with description';
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      description : 'version 000',
    });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git tag -ln' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 2 );
    test.identical( _.strCount( op.output, /v000\s+version 000/ ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'make two tags with description in single commit';
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      description : 'version 000',
    });
    test.identical( got.exitCode, 0 );
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v001',
      description : 'version 001',
    });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git tag -ln' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 3 );
    test.identical( _.strCount( op.output, /v000\s+version 000/ ), 1 );
    test.identical( _.strCount( op.output, /v001\s+version 001/ ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'make two tags with description, tags have the same name, deleting - 1';
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      description : 'version 001',
    });
    test.identical( got.exitCode, 0 );
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      description : 'version 000',
    });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git tag -ln' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 2 );
    test.identical( _.strCount( op.output, /v000\s+version 000/ ), 1 );
    test.identical( _.strCount( op.output, /v000\s+version 001/ ), 0 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'make two tags with description, tags have the same name, deleting - 1';
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      description : 'version 001',
    });
    test.identical( got.exitCode, 0 );
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      description : 'version 000',
    });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git tag -ln' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 2 );
    test.identical( _.strCount( op.output, /v000\s+version 000/ ), 1 );
    test.identical( _.strCount( op.output, /v000\s+version 001/ ), 0 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'make tag with multiline description';
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      description : 'version\n000',
    });
    test.identical( got.exitCode, 0 );
    return null;
  });

  a.shell( 'git tag -ln2' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 3 );
    test.identical( _.strCount( op.output, /v000\s+version\n\s+000/ ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'make tag for not current HEAD';
    return null;
  });
  var commitHash;
  a.shell( 'git rev-parse HEAD' );
  a.ready.then( ( op ) =>
  {
    commitHash = op.output.trim();
    return null;
  });
  a.shell( 'git commit --allow-empty -m "empty commit"' );
  a.ready.then( () =>
  {
    var got = _.git.tagMake
    ({
      localPath : a.abs( '.' ),
      tag : 'v000',
      description : 'version 000',
      toVersion : commitHash,
    });
    test.identical( got.exitCode, 0 );
    return null;
  });
  a.shell( 'git tag -ln' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 2 );
    test.identical( _.strCount( op.output, /v000\s+version 000/ ), 1 );
    return null;
  });
  a.shell( 'git rev-list -n 1 v000' )
  .then( ( op ) =>
  {
    test.identical( _.strLinesCount( op.output ), 2 );
    test.identical( op.output.trim(), commitHash );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.git.tagMake() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '.' ), tag : 'v0' };
        return _.git.tagMake( o, o );
      });

      test.case = 'unknown option in options map o';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '.' ), tag : 'v0', unknown : 1 };
        return _.git.tagMake( o );
      });

      test.case = 'wrong type of o.localPath';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : 1, tag : 'v0' };
        return _.git.tagMake( o );
      });

      test.case = 'o.localPath is not a repository';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '..' ), tag : 'v0' };
        return _.git.tagMake( o );
      });

      test.case = 'add several tags with same name, force - 0';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '.' ), tag : 'v000', light : 1, force : 0 };
        _.git.tagMake( o );
        return _.git.tagMake( o );
      });

      test.case = 'add several tags with same name, force - 0';
      test.shouldThrowErrorSync( () =>
      {
        let o = { localPath : a.abs( '.' ), tag : 'v000', force : 0 };
        _.git.tagMake( o );
        return _.git.tagMake( o );
      });

      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( '.' ) ) );
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git init` );
    a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.abs( 'file.txt' ), 'file.txt' );
      return null;
    });
    a.shell( 'git add .' );
    a.shell( 'git commit -m init' );
    return a.ready;
  }

  /* */

  function programMake( locals )
  {
    locals = _.props.supplement( { toolsPath : _.module.resolve( 'wTools' ) }, locals );
    return a.program({ entry : testApp, locals });
  }

  /* */

  function testApp()
  {
    const _ = require( toolsPath );
    _.include( 'wGitTools' )
    _.git.reset( o );
  }

}

tagMake.timeOut = 20000;

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
    test.true( a.fileProvider.fileExists( a.abs( 'clone', 'file2' ) ) );

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
    test.true( a.fileProvider.fileExists( a.abs( 'clone', 'file2' ) ) );

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

renormalize.timeOut = 60000;

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

    test.true( a.fileProvider.fileExists( a.abs( 'clone', '.gitattributes') ) );

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

renormalizeOriginHasAttributes.timeOut = 120000;

//

function renormalizeAudit( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let testPath = a.abs( 'routine-' + test.name );

  let con = _.take( null );

  let shell = _.process.starter
  ({
    currentPath : a.abs( testPath, 'repo' ),
    ready : con
  });

  let shell2 = _.process.starter
  ({
    currentPath : testPath,
    ready : con
  });

  let program = a.program
  ({
    // routine : testApp,
    entry : testApp,
    locals :
    {
      GitToolsPath : a.path.nativize( a.path.resolve( __dirname, '../git/entry/GitTools.ss' ) ),
      ClonePath : a.abs( testPath, 'clone' )
    }
  });
  let filePath/*programPath*/ = program.filePath/*programPath*/;

  /* - */

  prepare({ attributes : '* text' })
  clone({ config : 'core.eol crlf' })
  .then( () =>
  {
    test.case = 'text in gitattributes, core.eol=crlf';

    return a.appStartNonThrowing({ execPath : filePath/*programPath*/ })
    .then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.true( _.strHas( op.output, 'contains lines that can affect the result of EOL normalization' ) );

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
      a.fileProvider.filesDelete( testPath );
      a.fileProvider.dirMake( testPath )
      a.fileProvider.dirMake( a.abs( testPath, 'repo' ) )

      a.fileProvider.fileWrite( a.abs( testPath, 'repo', 'file1' ), 'abc\n' );

      if( o.attributes )
      a.fileProvider.fileWrite( a.abs( testPath, 'repo', '.gitattributes' ), o.attributes );

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
      a.fileProvider.filesDelete( a.abs( 'clone' ) );
      return null;
    })

    shell2( 'git clone repo clone --config core.autocrlf=true' )

    if( o.config )
    shell2( 'git -C clone config ' + o.config )

    return con;
  }

  function testApp()
  {
    const _ = require( GitToolsPath );
    _.git.renormalize({ localPath : ClonePath, audit : 1 });
  }
}

renormalizeAudit.timeOut = 15000;


// --
// declare
// --

const Proto =
{
  name : 'Tools.mid.GitTools',
  abstract : 0,
  silencing : 1,
  enabled : 1,
  verbosity : 4,
  routineTimeOut : 30000,

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

    // dichotomy

    stateIsHash,
    stateIsTag,

    // path

    // pathParse, /* aaa : check tests */ /* Dmytro : it is not actual task, the routine is commented */

    remotePathFromLocal,

    /* */

    insideRepository,

    // tag

    tagLocalChange,
    tagLocalRetrive,
    tagExplain,

    // version

    versionsRemoteRetrive,
    versionIsCommitHash,
    versionsPull,

    // dichotomy

    isUpToDate,
    isUpToDateRemotePathIsMap,
    isUpToDateExtended,
    isUpToDateThrowing,
    isUpToDateMissingTag,
    isUptoDateDifferentiatingTags,
    isUptoDateDetailing,
    hasFiles,
    hasRemote,
    isRepository,

    // status

    statusLocal,
    statusLocalEmpty,
    statusLocalEmptyWithOrigin,
    statusLocalAsync,
    statusLocalExplainingTrivial,
    statusLocalExtended,
    statusLocalWithAttempts,
    statusRemote,
    statusRemoteTags,
    statusRemoteVersionOption,
    //qqq Vova: add test routine for statuRemote with case when local is in detached state
    status,
    statusEveryCheck,
    statusExplaining,
    statusFull,
    statusFullHalfStaged,
    statusFullWithPR,

    hasLocalChanges,
    hasLocalChangesSpecial,
    hasRemoteChanges,
    hasChanges,

    // tag and version

    repositoryHasTag,
    repositoryHasTagRemotePathIsMap,
    repositoryHasTagWithOptionReturnVersion,
    repositoryHasVersion,
    repositoryHasVersionWithLocalRemoteRepo,
    repositoryTagToVersion,
    repositoryVersionToTagWithOptionLocal,
    repositoryVersionToTagWithOptionRemote,
    repositoryVersionToTagWithOptionsRemoteAndLocal,

    // hook

    gitHooksManager,
    gitHooksManagerErrors,

    hookTrivial,
    hookPreservingHardLinks,

    // top

    repositoryInit,
    repositoryInitRemote,
    repositoryDeleteRemote,
    repositoryDeleteCheckRetryOptions,
    repositoryClone,
    repositoryCloneCheckRetryOptions,
    repositoryCheckout,
    repositoryCheckoutRemotePathIsMap,

    repositoryAgree,
    repositoryAgreeWithLocalRepository,
    repositoryAgreeWithNotARepository,
    repositoryAgreeWithOptionMergeStrategy,
    repositoryAgreeWithOptionCommitMessage,
    repositoryAgreeWithOptionSrcState,
    repositoryAgreeWithOptionOnly,
    repositoryAgreeWithOptionBut,
    repositoryAgreeWithOptionSrcDirPath,
    repositoryAgreeWithOptionDstDirPath,
    repositoryAgreeWithSingleRepository,
    repositoryAgreeWithOptionLogger,
    repositoryAgreeWithOptionDry,
    repositoryAgreeWithOptionDelay,

    repositoryMigrate,
    repositoryMigrateWithLocalRepository,
    repositoryMigrateWithOptionOnCommitMessage,
    repositoryMigrateWithOptionOnCommitMessageManual,
    repositoryMigrateWithOptionOnDate,
    repositoryMigrateWithOptionOnDateAsMap,
    repositoryMigrateWithOptionOnly,
    repositoryMigrateWithOptionBut,
    repositoryMigrateWithOptionsOnlyAndBut,
    repositoryMigrateWithOptionSrcDirPath,
    repositoryMigrateWithOptionDstDirPath,
    repositoryMigrateWithOptionLogger,
    repositoryMigrateWithOptionDry,

    repositoryHistoryToJson,

    // etc

    configRead,
    configResetWithOptionWithLocal,
    configResetWithOptionWithGlobal,
    configResetWithOptionsWithLocalWithGlobal,

    /* */

    diff,
    diffSpecial,
    diffSameStates,
    pull,
    pullCheckOutput,
    pullAllBranches,
    push,
    pushCheckOutput,
    pushTags,
    reset,
    resetWithOptionRemovingUntracked,
    resetWithOptionRemovingSubrepositories,
    resetWithOptionRemovingIgnored,
    resetWithOptionDry,

    commitsDates,
    commitsDatesWithOptionDelta,
    commitsDatesWithOptionDeltaAsString,
    commitsDatesWithOptionDeltaAsStringUnits,
    commitsDatesWithOptionPeriodic,
    commitsDatesWithOptionDeviation,

    tagList,
    tagDeleteBranch,
    tagDeleteTag,
    tagMake,

    renormalize,
    renormalizeOriginHasAttributes,
    renormalizeAudit,

  },
};

//

const Self = wTestSuite( Proto )/* .inherit( Parent ); */
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
