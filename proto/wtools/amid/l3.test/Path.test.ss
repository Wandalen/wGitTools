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

function parseFullRemoteProtocols( test )
{
  test.open( 'empty protocol - git or ssh syntax' );

  test.case = 'simple git path';
  var remotePath = 'git@github.com:someorg/somerepo.git';
  var expected =
  {
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : './',
    'protocols' : [],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git path with tag';
  var remotePath = 'git@github.com:someorg/somerepo.git!new';
  var expected =
  {
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git path with tag after slash';
  var remotePath = 'git@github.com:someorg/somerepo.git/!new';
  var expected =
  {
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git path with hash';
  var remotePath = 'git@github.com:someorg/somerepo.git#b6968a12';
  var expected =
  {
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git path with hash after slash';
  var remotePath = 'git@github.com:someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.close( 'empty protocol - git or ssh syntax' );

  /* - */

  test.open( 'git' );

  test.case = 'simple git path';
  var remotePath = 'git://git@github.com:someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : './',
    'protocols' : [ 'git' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git path';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : '/git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : './',
    'protocols' : [ 'git' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git path with tag';
  var remotePath = 'git://git@github.com:someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git path with tag';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : '/git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git path with tag after slash';
  var remotePath = 'git://git@github.com:someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git path with tag after slash';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : '/git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git path with hash';
  var remotePath = 'git://git@github.com:someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git path with hash';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : '/git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git path with hash after slash';
  var remotePath = 'git://git@github.com:someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git path with hash after slash';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : '/git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.close( 'git' );

  /* - */

  test.open( 'ssh' );

  test.case = 'simple ssh path';
  var remotePath = 'ssh://git@github.com:someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : './',
    'protocols' : [ 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global ssh path';
  var remotePath = 'ssh:///git@github.com:someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : '/git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : './',
    'protocols' : [ 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'ssh path with tag';
  var remotePath = 'ssh://git@github.com:someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git path with tag';
  var remotePath = 'ssh:///git@github.com:someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : '/git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'ssh path with tag after slash';
  var remotePath = 'ssh://git@github.com:someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global ssh path with tag after slash';
  var remotePath = 'ssh:///git@github.com:someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : '/git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'ssh path with hash';
  var remotePath = 'ssh://git@github.com:someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global ssh path with hash';
  var remotePath = 'ssh:///git@github.com:someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : '/git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'ssh path with hash after slash';
  var remotePath = 'ssh://git@github.com:someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global ssh path with hash after slash';
  var remotePath = 'ssh:///git@github.com:someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : '/git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.close( 'ssh' );

  /* - */

  test.open( 'https' );

  test.case = 'simple https path';
  var remotePath = 'https://github.com/someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : './',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global https path';
  var remotePath = 'https:///github.com/someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : '/github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : './',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'https path with tag';
  var remotePath = 'https://github.com/someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global https path with tag';
  var remotePath = 'https:///github.com/someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : '/github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'https path with tag after slash';
  var remotePath = 'https://github.com/someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global https path with tag after slash';
  var remotePath = 'https:///github.com/someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'https path with hash';
  var remotePath = 'https://github.com/someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global https path with hash';
  var remotePath = 'https:///github.com/someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : '/github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'https path with hash after slash';
  var remotePath = 'https://github.com/someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global https path with hash after slash';
  var remotePath = 'https:///github.com/someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.close( 'https' );

  /* - */

  test.open( 'git+ssh' );

  test.case = 'simple git+ssh path';
  var remotePath = 'git+ssh://git@github.com:someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+ssh path';
  var remotePath = 'git+ssh:///git@github.com:someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : '/git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+ssh path with tag';
  var remotePath = 'git+ssh://git@github.com:someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+ssh path with tag';
  var remotePath = 'git+ssh:///git@github.com:someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : '/git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+ssh path with tag after slash';
  var remotePath = 'git+ssh://git@github.com:someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+ssh path with tag after slash';
  var remotePath = 'git+ssh:///git@github.com:someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : '/git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+ssh path with hash';
  var remotePath = 'git+ssh://git@github.com:someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+ssh path with hash';
  var remotePath = 'git+ssh:///git@github.com:someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : '/git@github.com:someorg/somerepo.git',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+ssh path with hash after slash';
  var remotePath = 'git+ssh://git@github.com:someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+ssh path with hash after slash';
  var remotePath = 'git+ssh:///git@github.com:someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : '/git@github.com:someorg/somerepo.git/',
    'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    'remoteVcsLongerPath' : 'ssh://git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'ssh' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.close( 'git+ssh' );

  /* - */

  test.open( 'git+https' );

  test.case = 'simple git+https path';
  var remotePath = 'git+https://github.com/someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+https path';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : '/github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+https path with tag';
  var remotePath = 'git+https://github.com/someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+https path with tag';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : '/github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+https path with tag after slash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+https path with tag after slash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+https path with hash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+https path with hash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : '/github.com/someorg/somerepo.git',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+https path with hash after slash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+https path with hash after slash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.close( 'git+https' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.git.path.parse() );

  test.case = 'extra arguments';
  var remotePath = 'https://github.com/user/repo.git';
  test.shouldThrowErrorSync( () => _.git.path.parse( remotePath, remotePath ) );

  test.case = 'wrong type of options map';
  var remotePath = 'https://github.com/user/repo.git';
  test.shouldThrowErrorSync( () => _.git.path.parse([ remotePath ]) );

  test.case = 'remote path has hash and tag';
  var remotePath = 'git+https:///github.com/user/repo.git/#b6968a12!master';
  test.shouldThrowErrorSync( () => _.git.path.parse( remotePath ) );

  test.case = 'unknown option in options map';
  var o =
  {
    remotePath : 'https://github.com/user/repo.git',
    unknown : 1,
  };
  test.shouldThrowErrorSync( () => _.git.path.parse( o ) );

  test.case = 'o.full and o.atomic are setled to 1';
  var o =
  {
    remotePath : 'https://github.com/user/repo.git',
    full : 1,
    atomic : 1,
  };
  test.shouldThrowErrorSync( () => _.git.path.parse( o ) );
}

//

function parseFullLocalProtocols( test )
{
  test.open( 'hd' );

  test.case = 'simple hd path with query';
  var remotePath = 'hd://Tools?out=out/wTools.out.will'
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global hd path with query';
  var remotePath = 'hd:///Tools?out=out/wTools.out.will'
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : '/Tools',
    'remoteVcsPath' : '/Tools',
    'remoteVcsLongerPath' : '/Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'hd path with tag and query';
  var remotePath = 'hd://Tools?out=out/wTools.out.will!new'
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'hd path with query and tag after slash';
  var remotePath = 'hd://Tools?out=out/wTools.out.will/!new'
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will/',
    'localVcsPath' : 'out/wTools.out.will/',
    'protocols' : [ 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'hd path with query and hash';
  var remotePath = 'hd://Tools?out=out/wTools.out.will#b6968a12'
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'hash' : 'b6968a12',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'hd' ],
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'hd path with query and hash after slash';
  var remotePath = 'hd://Tools?out=out/wTools.out.will/#b6968a12'
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'hash' : 'b6968a12',
    'query' : 'out=out/wTools.out.will/',
    'localVcsPath' : 'out/wTools.out.will/',
    'protocols' : [ 'hd' ],
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.close( 'hd' );

  /* - */


  test.open( 'git+hd' );

  test.case = 'simple git+hd path with query';
  var remotePath = 'git+hd://Tools?out=out/wTools.out.will'
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'git', 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+hd path with query';
  var remotePath = 'git+hd:///Tools?out=out/wTools.out.will'
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : '/Tools',
    'remoteVcsPath' : '/Tools',
    'remoteVcsLongerPath' : '/Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'git', 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+hd path with tag and query';
  var remotePath = 'git+hd://Tools?out=out/wTools.out.will!new'
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'git', 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+hd path with query and tag after slash';
  var remotePath = 'git+hd://Tools?out=out/wTools.out.will/!new'
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will/',
    'localVcsPath' : 'out/wTools.out.will/',
    'protocols' : [ 'git', 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+hd path with query and hash';
  var remotePath = 'git+hd://Tools?out=out/wTools.out.will#b6968a12'
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'hash' : 'b6968a12',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'git', 'hd' ],
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+hd path with query and hash after slash';
  var remotePath = 'git+hd://Tools?out=out/wTools.out.will/#b6968a12'
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    'remoteVcsPath' : 'Tools',
    'remoteVcsLongerPath' : 'Tools',
    'hash' : 'b6968a12',
    'query' : 'out=out/wTools.out.will/',
    'localVcsPath' : 'out/wTools.out.will/',
    'protocols' : [ 'git', 'hd' ],
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.close( 'git+hd' );
}

//

function parseAtomicRemoteProtocols( test )
{
  test.open( 'empty protocol - git or ssh syntax' );

  test.case = 'simple git path';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with tag';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with tag after slash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with hash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with hash after slash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'empty protocol - git or ssh syntax' );

  /* - */

  test.open( 'git' );

  test.case = 'simple git path';
  var o = { remotePath : 'git://git@github.com:someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path';
  var o = { remotePath : 'git:///git@github.com:someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with tag';
  var o = { remotePath : 'git://git@github.com:someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path with tag';
  var o = { remotePath : 'git:///git@github.com:someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with tag after slash';
  var o = { remotePath : 'git://git@github.com:someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path with tag after slash';
  var o = { remotePath : 'git:///git@github.com:someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with hash';
  var o = { remotePath : 'git://git@github.com:someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path with hash';
  var o = { remotePath : 'git:///git@github.com:someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with hash after slash';
  var o = { remotePath : 'git://git@github.com:someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path with hash after slash';
  var o = { remotePath : 'git:///git@github.com:someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'git' );

  /* - */

  test.open( 'ssh' );

  test.case = 'simple ssh path';
  var o = { remotePath : 'ssh://git@github.com:someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global ssh path';
  var o = { remotePath : 'ssh:///git@github.com:someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with tag';
  var o = { remotePath : 'ssh://git@github.com:someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path with tag';
  var o = { remotePath : 'ssh:///git@github.com:someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with tag after slash';
  var o = { remotePath : 'ssh://git@github.com:someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global ssh path with tag after slash';
  var o = { remotePath : 'ssh:///git@github.com:someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with hash';
  var o = { remotePath : 'ssh://git@github.com:someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global ssh path with hash';
  var o = { remotePath : 'ssh:///git@github.com:someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with hash after slash';
  var o = { remotePath : 'ssh://git@github.com:someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global ssh path with hash after slash';
  var o = { remotePath : 'ssh:///git@github.com:someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'ssh' );

  /* - */

  test.open( 'https' );

  test.case = 'simple https path';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'https path with tag';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with tag';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'https path with tag after slash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with tag after slash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'https path with hash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with hash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'https path with hash after slash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with hash after slash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'https' );

  /* - */

  test.open( 'git+ssh' );

  test.case = 'simple git+ssh path';
  var o = { remotePath : 'git+ssh://git@github.com:someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+ssh path';
  var o = { remotePath : 'git+ssh:///git@github.com:someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with tag';
  var o = { remotePath : 'git+ssh://git@github.com:someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+ssh path with tag';
  var o = { remotePath : 'git+ssh:///git@github.com:someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with tag after slash';
  var o = { remotePath : 'git+ssh://git@github.com:someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+ssh path with tag after slash';
  var o = { remotePath : 'git+ssh:///git@github.com:someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with hash';
  var o = { remotePath : 'git+ssh://git@github.com:someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+ssh path with hash';
  var o = { remotePath : 'git+ssh:///git@github.com:someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with hash after slash';
  var o = { remotePath : 'git+ssh://git@github.com:someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+ssh path with hash after slash';
  var o = { remotePath : 'git+ssh:///git@github.com:someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'git+ssh' );

  /* - */

  test.open( 'git+https' );

  test.case = 'simple git+https path';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+https path with tag';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with tag';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+https path with tag after slash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with tag after slash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+https path with hash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with hash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+https path with hash after slash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with hash after slash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'git+https' );
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

    parseFullRemoteProtocols,
    parseFullLocalProtocols,
    parseAtomicRemoteProtocols,

  },

};

//

let Self = new wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
