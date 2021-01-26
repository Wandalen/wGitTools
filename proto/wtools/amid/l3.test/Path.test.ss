( function _Path_test_ss_()
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
// tests
// --

function parse( test )
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
  var got = _.git.path.parse( remotePath );
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
  var got = _.git.path.parse( remotePath );
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
  var got = _.git.path.parse( remotePath );
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
  var got = _.git.path.parse( remotePath );
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
  var got = _.git.path.parse( remotePath );
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
  var got = _.git.path.parse( remotePath );
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
  var got = _.git.path.parse( remotePath );
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
  var got = _.git.path.parse( remotePath );
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
  var got = _.git.path.parse( remotePath );
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
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected )

  test.case = 'both hash and tag'
  var remotePath = 'git+https:///github.com/Wandalen/wModuleForTesting1.git/#8b6968a12cb94da75d96bd85353fcfc8fd6cc2d3!master';
  test.shouldThrowErrorSync( () => _.git.path.parse( remotePath ) );
}

// --
// declare
// --

var Proto =
{

  name : 'Tools.mid.GitTools.Path',
  abstract : 0,
  silencing : 1,
  enabled : 1,
  verbosity : 4,

  tests :
  {

    // parse

    parse, /* qqq : check tests */

  },

};

//

let Self = new wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
