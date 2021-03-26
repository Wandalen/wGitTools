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

const _ = _global_.wTools;

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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
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
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : '/git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : '/git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : 'git@github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : '/git@github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : '/git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : 'git@github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'ssh',
    'longPath' : '/git@github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : '/git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git!new';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : '/git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : 'git@github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git/!new';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : '/git@github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git#b6968a12';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : '/git@github.com/someorg/somerepo.git',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : 'git@github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git/#b6968a12';
  var expected =
  {
    'protocol' : 'git+ssh',
    'longPath' : '/git@github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'ssh://git@github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
    // 'remoteVcsPath' : 'github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
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
  var remotePath = 'hd://Tools?out=out/wTools.out.will';
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    // 'remoteVcsPath' : 'Tools',
    // 'remoteVcsLongerPath' : 'Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global hd path with query';
  var remotePath = 'hd:///Tools?out=out/wTools.out.will';
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : '/Tools',
    // 'remoteVcsPath' : '/Tools',
    // 'remoteVcsLongerPath' : '/Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'hd path with tag and query';
  var remotePath = 'hd://Tools?out=out/wTools.out.will!new';
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    // 'remoteVcsPath' : 'Tools',
    // 'remoteVcsLongerPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'hd path with query and tag after slash';
  var remotePath = 'hd://Tools?out=out/wTools.out.will/!new';
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    // 'remoteVcsPath' : 'Tools',
    // 'remoteVcsLongerPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will/',
    'localVcsPath' : 'out/wTools.out.will/',
    'protocols' : [ 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'hd path with query and hash';
  var remotePath = 'hd://Tools?out=out/wTools.out.will#b6968a12';
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    // 'remoteVcsPath' : 'Tools',
    // 'remoteVcsLongerPath' : 'Tools',
    'hash' : 'b6968a12',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'hd' ],
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'hd path with query and hash after slash';
  var remotePath = 'hd://Tools?out=out/wTools.out.will/#b6968a12';
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    // 'remoteVcsPath' : 'Tools',
    // 'remoteVcsLongerPath' : 'Tools',
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
  var remotePath = 'git+hd://Tools?out=out/wTools.out.will';
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    // 'remoteVcsPath' : 'Tools',
    // 'remoteVcsLongerPath' : 'Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'git', 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+hd path with query';
  var remotePath = 'git+hd:///Tools?out=out/wTools.out.will';
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : '/Tools',
    // 'remoteVcsPath' : '/Tools',
    // 'remoteVcsLongerPath' : '/Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'git', 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+hd path with tag and query';
  var remotePath = 'git+hd://Tools?out=out/wTools.out.will!new';
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    // 'remoteVcsPath' : 'Tools',
    // 'remoteVcsLongerPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'git', 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+hd path with query and tag after slash';
  var remotePath = 'git+hd://Tools?out=out/wTools.out.will/!new';
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    // 'remoteVcsPath' : 'Tools',
    // 'remoteVcsLongerPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will/',
    'localVcsPath' : 'out/wTools.out.will/',
    'protocols' : [ 'git', 'hd' ],
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+hd path with query and hash';
  var remotePath = 'git+hd://Tools?out=out/wTools.out.will#b6968a12';
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    // 'remoteVcsPath' : 'Tools',
    // 'remoteVcsLongerPath' : 'Tools',
    'hash' : 'b6968a12',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
    'protocols' : [ 'git', 'hd' ],
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'git+hd path with query and hash after slash';
  var remotePath = 'git+hd://Tools?out=out/wTools.out.will/#b6968a12';
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    // 'remoteVcsPath' : 'Tools',
    // 'remoteVcsLongerPath' : 'Tools',
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

function parseFullPathsHaveLocalVcsPath( test )
{
  test.open( 'without protocol' );

  test.case = 'simple git path';
  var remotePath = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will';
  var expected =
  {
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple git path with tag';
  var remotePath = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will!new';
  var expected =
  {
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple git path with tag and slash';
  var remotePath = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/!new';
  var expected =
  {
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will/',
    'protocols' : [],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple git path with hash';
  var remotePath = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  var expected =
  {
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple git path with hash and slash';
  var remotePath = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  var expected =
  {
    'longPath' : 'git@github.com:someorg/somerepo.git/',
    // 'remoteVcsPath' : 'git@github.com:someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'git@github.com:someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will/',
    'protocols' : [],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.close( 'without protocol' );

  /* - */

  test.open( 'https' );

  test.case = 'simple https path';
  var remotePath = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple https path with tag';
  var remotePath = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple https path with tag and slash';
  var remotePath = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will/',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple https path with hash';
  var remotePath = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple https path with hash and slash';
  var remotePath = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will/',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global https path';
  var remotePath = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global https path with tag';
  var remotePath = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global https path with tag and slash';
  var remotePath = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will/',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global https path with hash';
  var remotePath = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global https path with hash and slash';
  var remotePath = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will/',
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

  test.open( 'git+https' );

  test.case = 'simple git+https path';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple git+https path with tag';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple git+https path with tag and slash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will/',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple git+https path with hash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'simple git+https path with hash and slash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : 'github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will/',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+https path';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'master',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+https path with tag';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+https path with tag and slash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will/',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : false
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+https path with hash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.case = 'global git+https path with hash and slash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  var expected =
  {
    'protocol' : 'git+https',
    'longPath' : '/github.com/someorg/somerepo.git/',
    // 'remoteVcsPath' : 'https://github.com/someorg/somerepo.git',
    // 'remoteVcsLongerPath' : 'https://github.com/someorg/somerepo.git',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will/',
    'protocols' : [ 'git', 'https' ],
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isFixated' : true
  };
  var got = _.git.path.parse( remotePath );
  test.identical( got, expected );

  test.close( 'git+https' );
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
    'isGlobal' : true,
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
    'isGlobal' : true,
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
    'isGlobal' : true,
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
    'isGlobal' : true,
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
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'git' );

  /* - */

  test.open( 'ssh' );

  test.case = 'simple ssh path';
  var o = { remotePath : 'ssh://git@github.com/someorg/somerepo.git', full : 0, atomic : 1 };
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
  var o = { remotePath : 'ssh:///git@github.com/someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with tag';
  var o = { remotePath : 'ssh://git@github.com/someorg/somerepo.git!new', full : 0, atomic : 1 };
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
  var o = { remotePath : 'ssh:///git@github.com/someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with tag after slash';
  var o = { remotePath : 'ssh://git@github.com/someorg/somerepo.git/!new', full : 0, atomic : 1 };
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
  var o = { remotePath : 'ssh:///git@github.com/someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with hash';
  var o = { remotePath : 'ssh://git@github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
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
  var o = { remotePath : 'ssh:///git@github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with hash after slash';
  var o = { remotePath : 'ssh://git@github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
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
  var o = { remotePath : 'ssh:///git@github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
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
    'isGlobal' : true,
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
    'isGlobal' : true,
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
    'isGlobal' : true,
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
    'isGlobal' : true,
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
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'https' );

  /* - */

  test.open( 'git+ssh' );

  test.case = 'simple git+ssh path';
  var o = { remotePath : 'git+ssh://git@github.com/someorg/somerepo.git', full : 0, atomic : 1 };
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
  var o = { remotePath : 'git+ssh:///git@github.com/someorg/somerepo.git', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'tag' : 'master',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with tag';
  var o = { remotePath : 'git+ssh://git@github.com/someorg/somerepo.git!new', full : 0, atomic : 1 };
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
  var o = { remotePath : 'git+ssh:///git@github.com/someorg/somerepo.git!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with tag after slash';
  var o = { remotePath : 'git+ssh://git@github.com/someorg/somerepo.git/!new', full : 0, atomic : 1 };
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
  var o = { remotePath : 'git+ssh:///git@github.com/someorg/somerepo.git/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'tag' : 'new',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with hash';
  var o = { remotePath : 'git+ssh://git@github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
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
  var o = { remotePath : 'git+ssh:///git@github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with hash after slash';
  var o = { remotePath : 'git+ssh://git@github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
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
  var o = { remotePath : 'git+ssh:///git@github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+ssh',
    'hash' : 'b6968a12',
    'localVcsPath' : './',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
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
    'isGlobal' : true,
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
    'isGlobal' : true,
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
    'isGlobal' : true,
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
    'isGlobal' : true,
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
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'git+https' );
}

//

function parseAtomicLocalProtocols( test )
{
  test.open( 'hd' );

  test.case = 'simple hd path with query';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global hd path with query';
  var o = { remotePath : 'hd:///Tools?out=out/wTools.out.will', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : '/Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'hd path with tag and query';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'hd path with query and tag after slash';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will/',
    'localVcsPath' : 'out/wTools.out.will/',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'hd path with query and hash';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    'hash' : 'b6968a12',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'hd path with query and hash after slash';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'hd',
    'longPath' : 'Tools',
    'hash' : 'b6968a12',
    'query' : 'out=out/wTools.out.will/',
    'localVcsPath' : 'out/wTools.out.will/',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'hd' );

  /* - */

  test.open( 'git+hd' );

  test.case = 'simple git+hd path with query';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+hd path with query';
  var o = { remotePath : 'git+hd:///Tools?out=out/wTools.out.will', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : '/Tools',
    'tag' : 'master',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+hd path with tag and query';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+hd path with query and tag after slash';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    'tag' : 'new',
    'query' : 'out=out/wTools.out.will/',
    'localVcsPath' : 'out/wTools.out.will/',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+hd path with query and hash';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    'hash' : 'b6968a12',
    'query' : 'out=out/wTools.out.will',
    'localVcsPath' : 'out/wTools.out.will',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+hd path with query and hash after slash';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+hd',
    'longPath' : 'Tools',
    'hash' : 'b6968a12',
    'query' : 'out=out/wTools.out.will/',
    'localVcsPath' : 'out/wTools.out.will/',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'git+hd' );
}

//

function parseAtomicPathsHaveLocalVcsPath( test )
{
  test.open( 'without protocol' );

  test.case = 'simple git path';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 1 };
  var expected =
  {
    'tag' : 'master',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple git path with tag';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will!new', full : 0, atomic : 1 };
  var expected =
  {
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple git path with tag and slash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/!new', full : 0, atomic : 1 };
  var expected =
  {
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will/',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple git path with hash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple git path with hash and slash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will/',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'without protocol' );

  /* - */

  test.open( 'https' );

  test.case = 'simple https path';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'master',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple https path with tag';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/out/somerepo.out.will!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple https path with tag and slash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will/',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple https path with hash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple https path with hash and slash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will/',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'master',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with tag';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with tag and slash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will/',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with hash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with hash and slash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'https',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will/',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'https' );

  /* - */

  test.open( 'git+https' );

  test.case = 'simple git+https path';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'master',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple git+https path with tag';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple git+https path with tag and slash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will/',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple git+https path with hash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'simple git+https path with hash and slash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will/',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'master',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with tag';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with tag and slash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'tag' : 'new',
    'localVcsPath' : 'out/somerepo.out.will/',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with hash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with hash and slash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12', full : 0, atomic : 1 };
  var expected =
  {
    'protocol' : 'git+https',
    'hash' : 'b6968a12',
    'localVcsPath' : 'out/somerepo.out.will/',
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
    'isGlobal' : true,
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'git+https' );
}

//

function parseObjects( test )
{
  test.case = 'simple hd path with query';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will', full : 0, atomic : 0, objects : 1 };
  var expected = {};
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  /* - */

  test.open( 'empty protocol - git or ssh syntax' );

  test.case = 'simple git path';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with tag';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with tag after slash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with hash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with hash after slash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with local vcs path';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with local vcs path';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
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
  var o = { remotePath : 'git://git@github.com:someorg/somerepo.git', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path';
  var o = { remotePath : 'git:///git@github.com:someorg/somerepo.git', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with tag';
  var o = { remotePath : 'git://git@github.com:someorg/somerepo.git!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path with tag';
  var o = { remotePath : 'git:///git@github.com:someorg/somerepo.git!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with tag after slash';
  var o = { remotePath : 'git://git@github.com:someorg/somerepo.git/!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path with tag after slash';
  var o = { remotePath : 'git:///git@github.com:someorg/somerepo.git/!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with hash';
  var o = { remotePath : 'git://git@github.com:someorg/somerepo.git#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path with hash';
  var o = { remotePath : 'git:///git@github.com:someorg/somerepo.git#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with hash after slash';
  var o = { remotePath : 'git://git@github.com:someorg/somerepo.git/#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path with hash after slash';
  var o = { remotePath : 'git:///git@github.com:someorg/somerepo.git/#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git path with local vcs path';
  var o = { remotePath : 'git://git@github.com:someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path with local vcs path';
  var o = { remotePath : 'git:///git@github.com:someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
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
  var o = { remotePath : 'ssh://git@github.com/someorg/somerepo.git', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global ssh path';
  var o = { remotePath : 'ssh:///git@github.com/someorg/somerepo.git', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with tag';
  var o = { remotePath : 'ssh://git@github.com/someorg/somerepo.git!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git path with tag';
  var o = { remotePath : 'ssh:///git@github.com/someorg/somerepo.git!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with tag after slash';
  var o = { remotePath : 'ssh://git@github.com/someorg/somerepo.git/!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global ssh path with tag after slash';
  var o = { remotePath : 'ssh:///git@github.com/someorg/somerepo.git/!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with hash';
  var o = { remotePath : 'ssh://git@github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global ssh path with hash';
  var o = { remotePath : 'ssh:///git@github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with hash after slash';
  var o = { remotePath : 'ssh://git@github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global ssh path with hash after slash';
  var o = { remotePath : 'ssh:///git@github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'ssh path with local vcs path';
  var o = { remotePath : 'ssh://git@github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global ssh path with local vcs path';
  var o = { remotePath : 'ssh:///git@github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
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
  var o = { remotePath : 'https://github.com/someorg/somerepo.git', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'https path with tag';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with tag';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'https path with tag after slash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with tag after slash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'https path with hash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with hash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'https path with hash after slash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with hash after slash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'https path with local vcs path';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global https path with local vcs path';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
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
  var o = { remotePath : 'git+ssh://git@github.com/someorg/somerepo.git', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+ssh path';
  var o = { remotePath : 'git+ssh:///git@github.com/someorg/somerepo.git', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with tag';
  var o = { remotePath : 'git+ssh://git@github.com/someorg/somerepo.git!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+ssh path with tag';
  var o = { remotePath : 'git+ssh:///git@github.com/someorg/somerepo.git!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with tag after slash';
  var o = { remotePath : 'git+ssh://git@github.com/someorg/somerepo.git/!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+ssh path with tag after slash';
  var o = { remotePath : 'git+ssh:///git@github.com/someorg/somerepo.git/!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with hash';
  var o = { remotePath : 'git+ssh://git@github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+ssh path with hash';
  var o = { remotePath : 'git+ssh:///git@github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with hash after slash';
  var o = { remotePath : 'git+ssh://git@github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+ssh path with hash after slash';
  var o = { remotePath : 'git+ssh:///git@github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+ssh path with local vcs path';
  var o = { remotePath : 'git+ssh://git@github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+ssh path with local vcs path';
  var o = { remotePath : 'git+ssh:///git@github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
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
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+https path with tag';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with tag';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+https path with tag after slash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with tag after slash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/!new', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+https path with hash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with hash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+https path with hash after slash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with hash after slash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/#b6968a12', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'git+https path with local vcs path';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.case = 'global git+https path with local vcs path';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 0, objects : 1 };
  var expected =
  {
    'service' : 'github.com',
    'user' : 'someorg',
    'repo' : 'somerepo',
  };
  var got = _.git.path.parse( o );
  test.identical( got, expected );

  test.close( 'git+https' );
}

//

function strWithSimpleProtocols( test )
{
  test.open( 'empty protocol - git or ssh syntax, full' );

  test.case = 'simple git path';
  var remotePath = 'git@github.com:someorg/somerepo.git';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with tag';
  var remotePath = 'git@github.com:someorg/somerepo.git!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with tag after slash';
  var remotePath = 'git@github.com:someorg/somerepo.git/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with hash';
  var remotePath = 'git@github.com:someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with hash after slash';
  var remotePath = 'git@github.com:someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.close( 'empty protocol - git or ssh syntax, full' );

  /* - */

  test.open( 'empty protocol - git or ssh syntax, atomic' );

  test.case = 'simple git path';
  var remotePath = 'git@github.com:someorg/somerepo.git';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with tag';
  var remotePath = 'git@github.com:someorg/somerepo.git!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with tag after slash';
  var remotePath = 'git@github.com:someorg/somerepo.git/!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git!new';
  test.identical( got, expected );

  test.case = 'git path with hash';
  var remotePath = 'git@github.com:someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with hash after slash';
  var remotePath = 'git@github.com:someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git#b6968a12';
  test.identical( got, expected );

  test.close( 'empty protocol - git or ssh syntax, atomic' );

  /* - */

  test.open( 'git, full' );

  test.case = 'simple git path';
  var remotePath = 'git://git@github.com:someorg/somerepo.git';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with tag';
  var remotePath = 'git://git@github.com:someorg/somerepo.git!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with tag after slash';
  var remotePath = 'git://git@github.com:someorg/somerepo.git/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with hash';
  var remotePath = 'git://git@github.com:someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with hash after slash';
  var remotePath = 'git://git@github.com:someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git path';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git path with tag';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git path with tag after slash';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git:///git@github.com:someorg/somerepo.git/!new';
  test.identical( got, expected );

  test.case = 'global git path with hash';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git path with hash after slash';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git:///git@github.com:someorg/somerepo.git/#b6968a12';
  test.identical( got, expected );

  test.close( 'git, full' );

  /* - */

  test.open( 'git, atomic' );

  test.case = 'simple git path';
  var remotePath = 'git://git@github.com:someorg/somerepo.git';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with tag';
  var remotePath = 'git://git@github.com:someorg/somerepo.git!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with tag after slash';
  var remotePath = 'git://git@github.com:someorg/somerepo.git/!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git://git@github.com:someorg/somerepo.git!new';
  test.identical( got, expected );

  test.case = 'git path with hash';
  var remotePath = 'git://git@github.com:someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git path with hash after slash';
  var remotePath = 'git://git@github.com:someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git://git@github.com:someorg/somerepo.git#b6968a12';
  test.identical( got, expected );

  test.case = 'global git path';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git path with tag';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git path with tag after slash';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git/!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git:///git@github.com:someorg/somerepo.git!new';
  test.identical( got, expected );

  test.case = 'global git path with hash';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git path with hash after slash';
  var remotePath = 'git:///git@github.com:someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git:///git@github.com:someorg/somerepo.git#b6968a12';
  test.identical( got, expected );

  test.close( 'git, atomic' );

  /* - */

  test.open( 'ssh, full' );

  test.case = 'simple ssh path';
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'ssh path with tag';
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'ssh path with tag after slash';
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'ssh://git@github.com/someorg/somerepo.git/!new';
  test.identical( got, expected );

  test.case = 'ssh path with hash';
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'ssh path with hash after slash';
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'ssh://git@github.com/someorg/somerepo.git/#b6968a12';
  test.identical( got, expected );

  test.case = 'global ssh path';
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global ssh path with tag';
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global ssh path with tag after slash';
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'ssh:///git@github.com/someorg/somerepo.git/!new';
  test.identical( got, expected );

  test.case = 'global ssh path with hash';
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global ssh path with hash after slash';
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'ssh:///git@github.com/someorg/somerepo.git/#b6968a12';
  test.identical( got, expected );

  test.close( 'ssh, full' );

  /* - */

  test.open( 'ssh, atomic' );

  test.case = 'simple ssh path';
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'ssh path with tag';
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'ssh path with tag after slash';
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'ssh://git@github.com/someorg/somerepo.git!new';
  test.identical( got, expected );

  test.case = 'ssh path with hash';
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'ssh path with hash after slash';
  var remotePath = 'ssh://git@github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'ssh://git@github.com/someorg/somerepo.git#b6968a12';
  test.identical( got, expected );

  test.case = 'global ssh path';
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global ssh path with tag';
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global ssh path with tag after slash';
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'ssh:///git@github.com/someorg/somerepo.git!new';
  test.identical( got, expected );

  test.case = 'global ssh path with hash';
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global ssh path with hash after slash';
  var remotePath = 'ssh:///git@github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'ssh:///git@github.com/someorg/somerepo.git#b6968a12';
  test.identical( got, expected );

  test.close( 'ssh, atomic' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.git.path.str() );

  test.case = 'extra arguments';
  var parsed = _.git.path.parse( 'git@github.com:someorg/somerepo.git/!new' )
  test.shouldThrowErrorSync( () => _.git.path.str( parsed, parsed ) );

  test.case = 'map has only objects';
  var remotePath = 'git@github.com:someorg/somerepo.git/!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.shouldThrowErrorSync( () => _.git.path.str( parsed, parsed ) );
}

//

function strWithComplexProtocols( test )
{
  test.open( 'git+https, full' );

  test.case = 'simple git+https path';
  var remotePath = 'git+https://github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+https path with tag';
  var remotePath = 'git+https://github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+https path with tag after slash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+https path with hash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+https path with hash after slash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+https path';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+https path with tag';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+https path with tag after slash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+https path with hash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git path with hash after slash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.close( 'git+https, full' );

  /* - */

  test.open( 'git+https, atomic' );

  test.case = 'simple git+https path';
  var remotePath = 'git+https://github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+https path with tag';
  var remotePath = 'git+https://github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+https path with tag after slash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git!new';
  test.identical( got, expected );

  test.case = 'git+https path with hash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+https path with hash after slash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git#b6968a12';
  test.identical( got, expected );

  test.case = 'global git+httsp path';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+httsp path with tag';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+httsp path with tag after slash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git!new';
  test.identical( got, expected );

  test.case = 'global git+httsp path with hash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+httsp path with hash after slash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git#b6968a12';
  test.identical( got, expected );

  test.close( 'git+https, atomic' );

  /* - */

  test.open( 'git+ssh, full' );

  test.case = 'simple git+ssh path';
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+ssh path with tag';
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+ssh path with tag after slash';
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+ssh://git@github.com/someorg/somerepo.git/!new';
  test.identical( got, expected );

  test.case = 'git+ssh path with hash';
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+ssh path with hash after slash';
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+ssh://git@github.com/someorg/somerepo.git/#b6968a12';
  test.identical( got, expected );

  test.case = 'global git+httsp path';
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+httsp path with tag';
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+httsp path with tag after slash';
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+ssh:///git@github.com/someorg/somerepo.git/!new';
  test.identical( got, expected );

  test.case = 'global git+httsp path with hash';
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+httsp path with hash after slash';
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+ssh:///git@github.com/someorg/somerepo.git/#b6968a12';
  test.identical( got, expected );

  test.close( 'git+ssh, full' );

  /* - */

  test.open( 'git+ssh, atomic' );

  test.case = 'simple git+ssh path';
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+ssh path with tag';
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+ssh path with tag after slash';
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git+ssh://git@github.com/someorg/somerepo.git!new';
  test.identical( got, expected );

  test.case = 'git+ssh path with hash';
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'git+ssh path with hash after slash';
  var remotePath = 'git+ssh://git@github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git+ssh://git@github.com/someorg/somerepo.git#b6968a12';
  test.identical( got, expected );

  test.case = 'global git+httsp path';
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+httsp path with tag';
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+httsp path with tag after slash';
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git/!new';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git+ssh:///git@github.com/someorg/somerepo.git!new';
  test.identical( got, expected );

  test.case = 'global git+httsp path with hash';
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = remotePath;
  test.identical( got, expected );

  test.case = 'global git+httsp path with hash after slash';
  var remotePath = 'git+ssh:///git@github.com/someorg/somerepo.git/#b6968a12';
  var parsed = _.git.path.parse({ remotePath, full : 0, atomic : 1 });
  var got = _.git.path.str( parsed );
  var expected = 'git+ssh:///git@github.com/someorg/somerepo.git#b6968a12';
  test.identical( got, expected );

  test.close( 'git+ssh, atomic' );

  /* - */

  test.open( 'hd, full' );

  test.case = 'simple hd path with query';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'global hd path with query';
  var o = { remotePath : 'hd:///Tools?out=out/wTools.out.will', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'hd path with tag and query';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will!new', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'hd path with query and tag after slash';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will/!new', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'hd path with query and hash';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will#b6968a12', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'hd path with query and hash after slash';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will/#b6968a12', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.close( 'hd, full' );

  /* - */

  test.open( 'git+hd, full' );

  test.case = 'simple git+hd path with query';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'global git+hd path with query';
  var o = { remotePath : 'git+hd:///Tools?out=out/wTools.out.will', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'git+hd path with tag and query';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will!new', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'git+hd path with query and tag after slash';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will/!new', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'git+hd path with query and hash';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will#b6968a12', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'git+hd path with query and hash after slash';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will/#b6968a12', full : 1, atomic : 0 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.close( 'git+hd, full' );

  /* - */

  test.open( 'hd, atomic' );

  test.case = 'simple hd path with query';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'global hd path with query';
  var o = { remotePath : 'hd:///Tools?out=out/wTools.out.will', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'hd path with tag and query';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'hd path with query and tag after slash';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will/!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'hd path with query and hash';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'hd path with query and hash after slash';
  var o = { remotePath : 'hd://Tools?out=out/wTools.out.will/#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.close( 'hd, atomic' );

  /* - */

  test.open( 'git+hd, atomic' );

  test.case = 'simple git+hd path with query';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'global git+hd path with query';
  var o = { remotePath : 'git+hd:///Tools?out=out/wTools.out.will', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'git+hd path with tag and query';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'git+hd path with query and tag after slash';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will/!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'git+hd path with query and hash';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.case = 'git+hd path with query and hash after slash';
  var o = { remotePath : 'git+hd://Tools?out=out/wTools.out.will/#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = o.remotePath;
  test.identical( got, expected );

  test.close( 'git+hd, atomic' );
}

//

function strPathsHaveLocalVcsPath( test )
{
  test.open( 'without protocol, full' );

  test.case = 'simple git path';
  var remotePath = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will';
  test.identical( got, expected );

  test.case = 'simple git path with tag';
  var remotePath = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will!new';
  test.identical( got, expected );

  test.case = 'simple git path with tag and slash';
  var remotePath = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/!new';
  test.identical( got, expected );

  test.case = 'simple git path with hash';
  var remotePath = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  test.identical( got, expected );

  test.case = 'simple git path with hash and slash';
  var remotePath = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  test.identical( got, expected );

  test.close( 'without protocol, full' );

  /* - */

  test.open( 'without protocol, atomic' );

  test.case = 'simple git path';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will';
  test.identical( got, expected );

  test.case = 'simple git path with tag';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will!new';
  test.identical( got, expected );

  test.case = 'simple git path with tag and slash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/!new';
  test.identical( got, expected );

  test.case = 'simple git path with hash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  test.identical( got, expected );

  test.case = 'simple git path with hash and slash';
  var o = { remotePath : 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git@github.com:someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  test.identical( got, expected );

  test.close( 'without protocol, atomic' );

  /* - */

  test.open( 'https, full' );

  test.case = 'simple https path';
  var remotePath = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will';
  test.identical( got, expected );

  test.case = 'simple https path with tag';
  var remotePath = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  test.identical( got, expected );

  test.case = 'simple https path with tag and slash';
  var remotePath = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  test.identical( got, expected );

  test.case = 'simple https path with hash';
  var remotePath = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  test.identical( got, expected );

  test.case = 'simple https path with hash and slash';
  var remotePath = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  test.identical( got, expected );

  test.case = 'global https path';
  var remotePath = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will';
  test.identical( got, expected );

  test.case = 'global https path with tag';
  var remotePath = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  test.identical( got, expected );

  test.case = 'global https path with tag and slash';
  var remotePath = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  test.identical( got, expected );

  test.case = 'global https path with hash';
  var remotePath = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  test.identical( got, expected );

  test.case = 'global https path with hash and slash';
  var remotePath = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  test.identical( got, expected );

  test.close( 'https, full' );

  /* - */

  test.open( 'https, atomic' );

  test.case = 'simple https path';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will';
  test.identical( got, expected );

  test.case = 'simple https path with tag';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/out/somerepo.out.will!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  test.identical( got, expected );

  test.case = 'simple https path with tag and slash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  test.identical( got, expected );

  test.case = 'simple https path with hash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  test.identical( got, expected );

  test.case = 'simple https path with hash and slash';
  var o = { remotePath : 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  test.identical( got, expected );

  test.case = 'global https path';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will';
  test.identical( got, expected );

  test.case = 'global https path with tag';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  test.identical( got, expected );

  test.case = 'global https path with tag and slash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  test.identical( got, expected );

  test.case = 'global https path with hash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  test.identical( got, expected );

  test.case = 'global https path with hash and slash';
  var o = { remotePath : 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  test.identical( got, expected );

  test.close( 'https, atomic' );

  /* - */

  test.open( 'git+https, full' );

  test.case = 'simple git+https path';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will';
  test.identical( got, expected );

  test.case = 'simple git+https path with tag';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  test.identical( got, expected );

  test.case = 'simple git+https path with tag and slash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  test.identical( got, expected );

  test.case = 'simple git+https path with hash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  test.identical( got, expected );

  test.case = 'simple git+https path with hash and slash';
  var remotePath = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  test.identical( got, expected );

  test.case = 'global git+https path';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will';
  test.identical( got, expected );

  test.case = 'global git+https path with tag';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  test.identical( got, expected );

  test.case = 'global git+https path with tag and slash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  test.identical( got, expected );

  test.case = 'global git+https path with hash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  test.identical( got, expected );

  test.case = 'global git+https path with hash and slash';
  var remotePath = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  var parsed = _.git.path.parse( remotePath );
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  test.identical( got, expected );

  test.close( 'git+https, full' );

  /* - */

  test.open( 'git+https, atomic' );

  test.case = 'simple git+https path';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will';
  test.identical( got, expected );

  test.case = 'simple git+https path with tag';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  test.identical( got, expected );

  test.case = 'simple git+https path with tag and slash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  test.identical( got, expected );

  test.case = 'simple git+https path with hash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  test.identical( got, expected );

  test.case = 'simple git+https path with hash and slash';
  var o = { remotePath : 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git+https://github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  test.identical( got, expected );

  test.case = 'global git+https path';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will';
  test.identical( got, expected );

  test.case = 'global git+https path with tag';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will!new';
  test.identical( got, expected );

  test.case = 'global git+https path with tag and slash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/!new';
  test.identical( got, expected );

  test.case = 'global git+https path with hash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will#b6968a12';
  test.identical( got, expected );

  test.case = 'global git+https path with hash and slash';
  var o = { remotePath : 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12', full : 0, atomic : 1 };
  var parsed = _.git.path.parse( o );
  var got = _.git.path.str( parsed );
  var expected = 'git+https:///github.com/someorg/somerepo.git/out/somerepo.out.will/#b6968a12';
  test.identical( got, expected );

  test.close( 'git+https, atomic' );
}

//

function normalize( test )
{
  test.open( 'without protocol' );

  test.case = 'path without protocol';
  var srcPath = 'git@github.com:someorg/somerepo.git';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git' );

  test.case = 'path without protocol with tag';
  var srcPath = 'git@github.com:someorg/somerepo.git!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git!new' );

  test.case = 'path without protocol with tag after slash';
  var srcPath = 'git@github.com:someorg/somerepo.git/!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git/!new' );

  test.case = 'path without protocol with hash';
  var srcPath = 'git@github.com:someorg/somerepo.git#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git#b6968a12' );

  test.case = 'path without protocol with hash after slash';
  var srcPath = 'git@github.com:someorg/somerepo.git/#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git/#b6968a12' );

  test.close( 'without protocol' );

  /* - */

  test.open( 'git' );

  test.case = 'git path';
  var srcPath = 'git://git@github.com:someorg/somerepo.git';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git' );

  test.case = 'git path with tag';
  var srcPath = 'git://git@github.com:someorg/somerepo.git!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git!new' );

  test.case = 'git path with tag after slash';
  var srcPath = 'git://git@github.com:someorg/somerepo.git/!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git/!new' );

  test.case = 'git path with hash';
  var srcPath = 'git://git@github.com:someorg/somerepo.git#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git#b6968a12' );

  test.case = 'git path with hash after slash';
  var srcPath = 'git://git@github.com:someorg/somerepo.git/#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git/#b6968a12' );

  test.case = 'global git path';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git' );

  test.case = 'global git path with tag';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git!new' );

  test.case = 'global git path with tag after slash';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git/!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git/!new' );

  test.case = 'global git path with hash';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git#b6968a12' );

  test.case = 'global git path with hash after slash';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git/#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git/#b6968a12' );

  test.close( 'git' );

  /* - */

  test.open( 'https' );

  test.case = 'https path';
  var srcPath = 'https://github.com/someorg/somerepo.git';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git' );

  test.case = 'https path with tag';
  var srcPath = 'https://github.com/someorg/somerepo.git!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git!new' );

  test.case = 'https path with tag after slash';
  var srcPath = 'https://github.com/someorg/somerepo.git/!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git/!new' );

  test.case = 'https path with hash';
  var srcPath = 'https://github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'https path with hash after slash';
  var srcPath = 'https://github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git/#b6968a12' );

  test.case = 'global https path';
  var srcPath = 'https:///github.com/someorg/somerepo.git';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git' );

  test.case = 'global https path with tag';
  var srcPath = 'https:///github.com/someorg/somerepo.git!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git!new' );

  test.case = 'global https path with tag after slash';
  var srcPath = 'https:///github.com/someorg/somerepo.git/!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git/!new' );

  test.case = 'global https path with hash';
  var srcPath = 'https:///github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'global https path with hash after slash';
  var srcPath = 'https:///github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git/#b6968a12' );

  test.close( 'https' );

  /* - */

  test.open( 'git+https' );

  test.case = 'git+https path';
  var srcPath = 'git+https://github.com/someorg/somerepo.git';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git' );

  test.case = 'git+https path with tag';
  var srcPath = 'git+https://github.com/someorg/somerepo.git!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git!new' );

  test.case = 'git+https path with tag after slash';
  var srcPath = 'git+https://github.com/someorg/somerepo.git/!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git/!new' );

  test.case = 'git+https path with hash';
  var srcPath = 'git+https://github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'git+https path with hash after slash';
  var srcPath = 'git+https://github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git/#b6968a12' );

  test.case = 'global git+https path';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git' );

  test.case = 'global git+https path with tag';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git!new' );

  test.case = 'global git+https path with tag after slash';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git/!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git/!new' );

  test.case = 'global git+https path with hash';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'global git+https path with hash after slash';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git/#b6968a12' );

  test.close( 'git+https' );

  /* - */

  test.open( 'git+hd' );

  test.case = 'git+hd path';
  var srcPath = 'git+hd://Tools?out=out/wTools.out.will';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will' );

  test.case = 'git+hd path with tag';
  var srcPath = 'git+hd://Tools?out=out/wTools.out.will!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will!new' );

  test.case = 'git+hd path with tag after slash';
  var srcPath = 'git+hd://Tools?out=out/wTools.out.will/!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will/!new' );

  test.case = 'git+hd path with hash';
  var srcPath = 'git+hd://Tools?out=out/wTools.out.will#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will#b6968a12' );

  test.case = 'git+hd path with hash after slash';
  var srcPath = 'git+hd://Tools?out=out/wTools.out.will/#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will/#b6968a12' );

  test.case = 'global git+hd path';
  var srcPath = 'git+hd:///Tools?out=out/wTools.out.will';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will' );

  test.case = 'global git+hd path with tag';
  var srcPath = 'git+hd:///Tools?out=out/wTools.out.will!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will!new' );

  test.case = 'global git+hd path with tag after slash';
  var srcPath = 'git+hd:///Tools?out=out/wTools.out.will/!new';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will/!new' );

  test.case = 'global git+hd path with hash';
  var srcPath = 'git+hd:///Tools?out=out/wTools.out.will#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will#b6968a12' );

  test.case = 'global git+hd path with hash after slash';
  var srcPath = 'git+hd:///Tools?out=out/wTools.out.will/#b6968a12';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will/#b6968a12' );

  test.close( 'git+hd' );

  /* - */

  test.case = 'https path with double slashes and dots';
  var srcPath = 'https://github.com//someorg/shoudBeSkiped/../somerepo.git//.';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com//someorg/somerepo.git/.' );

  test.case = 'global https path with double slashes and dots';
  var srcPath = 'https:///github.com//someorg/shoudBeSkiped/../somerepo.git//.';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+https:///github.com//someorg/somerepo.git/.' );

  test.case = 'local hd path with double slashes and dots';
  var srcPath = 'hd:///../wModuleForTesting1/out/./wModuleForTesting1.out.will!dev1';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///../wModuleForTesting1/out/wModuleForTesting1.out.will!dev1' );

  test.case = 'local hd path with double slashes and dots';
  var srcPath = 'hd://../wModuleForTesting1/out/./wModuleForTesting1.out.will!dev1';
  var got = _.git.path.normalize( srcPath );
  test.identical( got, 'git+hd:///../wModuleForTesting1/out/wModuleForTesting1.out.will!dev1' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.git.path.normalize() );

  test.case = 'extra arguments';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git';
  test.shouldThrowErrorSync( () => _.git.path.normalize( srcPath, srcPath ) );

  test.case = 'wrong type of path';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git';
  test.shouldThrowErrorSync( () => _.git.path.normalize({ srcPath }) );

  test.case = 'path have not longPath';
  var srcPath = 'git+https://';
  test.shouldThrowErrorSync( () => _.git.path.normalize( srcPath ) );
}

//

function nativize( test )
{
  test.open( 'without protocol' );

  test.case = 'path without protocol';
  var srcPath = 'git@github.com:someorg/somerepo.git';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git' );

  test.case = 'path without protocol with tag';
  var srcPath = 'git@github.com:someorg/somerepo.git!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git!new' );

  test.case = 'path without protocol with tag after slash';
  var srcPath = 'git@github.com:someorg/somerepo.git/!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git/!new' );

  test.case = 'path without protocol with hash';
  var srcPath = 'git@github.com:someorg/somerepo.git#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git#b6968a12' );

  test.case = 'path without protocol with hash after slash';
  var srcPath = 'git@github.com:someorg/somerepo.git/#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git/#b6968a12' );

  test.close( 'without protocol' );

  /* - */

  test.open( 'git' );

  test.case = 'git path';
  var srcPath = 'git://git@github.com:someorg/somerepo.git';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git' );

  test.case = 'git path with tag';
  var srcPath = 'git://git@github.com:someorg/somerepo.git!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git!new' );

  test.case = 'git path with tag after slash';
  var srcPath = 'git://git@github.com:someorg/somerepo.git/!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git/!new' );

  test.case = 'git path with hash';
  var srcPath = 'git://git@github.com:someorg/somerepo.git#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git#b6968a12' );

  test.case = 'git path with hash after slash';
  var srcPath = 'git://git@github.com:someorg/somerepo.git/#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git/#b6968a12' );

  test.case = 'global git path';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git' );

  test.case = 'global git path with tag';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git!new' );

  test.case = 'global git path with tag after slash';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git/!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git/!new' );

  test.case = 'global git path with hash';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git#b6968a12' );

  test.case = 'global git path with hash after slash';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git/#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git/#b6968a12' );

  test.close( 'git' );

  /* - */

  test.open( 'https' );

  test.case = 'https path';
  var srcPath = 'https://github.com/someorg/somerepo.git';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git' );

  test.case = 'https path with tag';
  var srcPath = 'https://github.com/someorg/somerepo.git!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git!new' );

  test.case = 'https path with tag after slash';
  var srcPath = 'https://github.com/someorg/somerepo.git/!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git/!new' );

  test.case = 'https path with hash';
  var srcPath = 'https://github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'https path with hash after slash';
  var srcPath = 'https://github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git/#b6968a12' );

  test.case = 'global https path';
  var srcPath = 'https:///github.com/someorg/somerepo.git';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git' );

  test.case = 'global https path with tag';
  var srcPath = 'https:///github.com/someorg/somerepo.git!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git!new' );

  test.case = 'global https path with tag after slash';
  var srcPath = 'https:///github.com/someorg/somerepo.git/!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git/!new' );

  test.case = 'global https path with hash';
  var srcPath = 'https:///github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'global https path with hash after slash';
  var srcPath = 'https:///github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git/#b6968a12' );

  test.close( 'https' );

  /* - */

  test.open( 'git+https' );

  test.case = 'git+https path';
  var srcPath = 'git+https://github.com/someorg/somerepo.git';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git' );

  test.case = 'git+https path with tag';
  var srcPath = 'git+https://github.com/someorg/somerepo.git!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git!new' );

  test.case = 'git+https path with tag after slash';
  var srcPath = 'git+https://github.com/someorg/somerepo.git/!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git/!new' );

  test.case = 'git+https path with hash';
  var srcPath = 'git+https://github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'git+https path with hash after slash';
  var srcPath = 'git+https://github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git/#b6968a12' );

  test.case = 'global git+https path';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git' );

  test.case = 'global git+https path with tag';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git!new' );

  test.case = 'global git+https path with tag after slash';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git/!new';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git/!new' );

  test.case = 'global git+https path with hash';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'global git+https path with hash after slash';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git/#b6968a12' );

  test.close( 'git+https' );

  /* - */

  test.open( 'git+hd' );

  test.case = 'git+hd path';
  var srcPath = 'git+hd://Tools?out=out/wTools.out.will';
  var got = _.git.path.nativize( srcPath );
  var exp =
  process.platform === 'win32' ? 'Tools?out=out\\wTools.out.will' : 'Tools?out=out/wTools.out.will';
  test.identical( got, exp );

  test.case = 'git+hd path with tag';
  var srcPath = 'git+hd://Tools?out=out/wTools.out.will!new';
  var got = _.git.path.nativize( srcPath );
  var exp =
  process.platform === 'win32' ? 'Tools?out=out\\wTools.out.will!new' : 'Tools?out=out/wTools.out.will!new';
  test.identical( got, exp );

  test.case = 'git+hd path with tag after slash';
  var srcPath = 'git+hd://Tools?out=out/wTools.out.will/!new';
  var got = _.git.path.nativize( srcPath );
  var exp =
  process.platform === 'win32' ? 'Tools?out=out\\wTools.out.will\\!new' : 'Tools?out=out/wTools.out.will/!new';
  test.identical( got, exp );

  test.case = 'git+hd path with hash';
  var srcPath = 'git+hd://Tools?out=out/wTools.out.will#b6968a12';
  var got = _.git.path.nativize( srcPath );
  var exp =
  process.platform === 'win32' ? 'Tools?out=out\\wTools.out.will#b6968a12' : 'Tools?out=out/wTools.out.will#b6968a12';
  test.identical( got, exp );

  test.case = 'git+hd path with hash after slash';
  var srcPath = 'git+hd://Tools?out=out/wTools.out.will/#b6968a12';
  var got = _.git.path.nativize( srcPath );
  var exp =
  process.platform === 'win32' ? 'Tools?out=out\\wTools.out.will\\#b6968a12' : 'Tools?out=out/wTools.out.will/#b6968a12';
  test.identical( got, exp );

  test.case = 'global git+hd path';
  var srcPath = 'git+hd:///Tools?out=out/wTools.out.will';
  var got = _.git.path.nativize( srcPath );
  var exp =
  process.platform === 'win32' ? '\\Tools?out=out\\wTools.out.will' : '/Tools?out=out/wTools.out.will';
  test.identical( got, exp );

  test.case = 'global git+hd path with tag';
  var srcPath = 'git+hd:///Tools?out=out/wTools.out.will!new';
  var got = _.git.path.nativize( srcPath );
  var exp =
  process.platform === 'win32' ? '\\Tools?out=out\\wTools.out.will!new' : '/Tools?out=out/wTools.out.will!new';
  test.identical( got, exp );

  test.case = 'global git+hd path with tag after slash';
  var srcPath = 'git+hd:///Tools?out=out/wTools.out.will/!new';
  var got = _.git.path.nativize( srcPath );
  var exp =
  process.platform === 'win32' ? '\\Tools?out=out\\wTools.out.will\\!new' : '/Tools?out=out/wTools.out.will/!new';
  test.identical( got, exp );

  test.case = 'global git+hd path with hash';
  var srcPath = 'git+hd:///Tools?out=out/wTools.out.will#b6968a12';
  var got = _.git.path.nativize( srcPath );
  var exp =
  process.platform === 'win32' ? '\\Tools?out=out\\wTools.out.will#b6968a12' : '/Tools?out=out/wTools.out.will#b6968a12';
  test.identical( got, exp );

  test.case = 'global git+hd path with hash after slash';
  var srcPath = 'git+hd:///Tools?out=out/wTools.out.will/#b6968a12';
  var got = _.git.path.nativize( srcPath );
  var exp =
  process.platform === 'win32' ? '\\Tools?out=out\\wTools.out.will\\#b6968a12' : '/Tools?out=out/wTools.out.will/#b6968a12';
  test.identical( got, exp );

  test.close( 'git+hd' );

  /* - */

  test.case = 'https path with double slashes and dots';
  var srcPath = 'https://github.com//someorg/shoudBeSkiped/../somerepo.git//.';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com//someorg/somerepo.git/.' );

  test.case = 'global https path with double slashes and dots';
  var srcPath = 'https:///github.com//someorg/shoudBeSkiped/../somerepo.git//.';
  var got = _.git.path.nativize( srcPath );
  test.identical( got, 'https://github.com//someorg/somerepo.git/.' );

  test.case = 'local hd path with double slashes and dots';
  var srcPath = 'hd://../wModuleForTesting1/out/./wModuleForTesting1.out.will!dev1';
  var got = _.git.path.nativize( srcPath );
  var exp = '../wModuleForTesting1/out/wModuleForTesting1.out.will!dev1'
  if( process.platform === 'win32' )
  exp = '..\\wModuleForTesting1\\out\\wModuleForTesting1.out.will!dev1';
  test.identical( got, exp );

  test.case = 'global hd path with double slashes and dots';
  var srcPath = 'hd:///../wModuleForTesting1/out/./wModuleForTesting1.out.will!dev1';
  var got = _.git.path.nativize( srcPath );
  var exp = '/../wModuleForTesting1/out/wModuleForTesting1.out.will!dev1'
  if( process.platform === 'win32' )
  exp = '\\..\\wModuleForTesting1\\out\\wModuleForTesting1.out.will!dev1';
  test.identical( got, exp );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.git.path.nativize() );

  test.case = 'extra arguments';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git';
  test.shouldThrowErrorSync( () => _.git.path.nativize( srcPath, srcPath ) );

  test.case = 'wrong type of path';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git';
  test.shouldThrowErrorSync( () => _.git.path.nativize({ srcPath }) );

  test.case = 'wrong protocols';
  var srcPath = 'ssh+https:///github.com/someorg/somerepo.git';
  test.shouldThrowErrorSync( () => _.git.path.nativize({ srcPath }) );

  test.case = 'path have not longPath';
  var srcPath = 'git+https://';
  test.shouldThrowErrorSync( () => _.git.path.nativize( srcPath ) );
}

//

function refine( test )
{
  test.open( 'without protocol' );

  test.case = 'path without protocol';
  var srcPath = 'git@github.com:someorg/somerepo.git';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git' );

  test.case = 'path without protocol with tag';
  var srcPath = 'git@github.com:someorg/somerepo.git!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git!new' );

  test.case = 'path without protocol with tag after slash';
  var srcPath = 'git@github.com:someorg/somerepo.git/!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git/!new' );

  test.case = 'path without protocol with hash';
  var srcPath = 'git@github.com:someorg/somerepo.git#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git#b6968a12' );

  test.case = 'path without protocol with hash after slash';
  var srcPath = 'git@github.com:someorg/somerepo.git/#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git@github.com:someorg/somerepo.git/#b6968a12' );

  test.close( 'without protocol' );

  /* - */

  test.open( 'git' );

  test.case = 'git path';
  var srcPath = 'git://git@github.com:someorg/somerepo.git';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git://git@github.com:someorg/somerepo.git' );

  test.case = 'git path with tag';
  var srcPath = 'git://git@github.com:someorg/somerepo.git!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git://git@github.com:someorg/somerepo.git!new' );

  test.case = 'git path with tag after slash';
  var srcPath = 'git://git@github.com:someorg/somerepo.git/!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git://git@github.com:someorg/somerepo.git/!new' );

  test.case = 'git path with hash';
  var srcPath = 'git://git@github.com:someorg/somerepo.git#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git://git@github.com:someorg/somerepo.git#b6968a12' );

  test.case = 'git path with hash after slash';
  var srcPath = 'git://git@github.com:someorg/somerepo.git/#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git://git@github.com:someorg/somerepo.git/#b6968a12' );

  test.case = 'global git path';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git' );

  test.case = 'global git path with tag';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git!new' );

  test.case = 'global git path with tag after slash';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git/!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git/!new' );

  test.case = 'global git path with hash';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git#b6968a12' );

  test.case = 'global git path with hash after slash';
  var srcPath = 'git:///git@github.com:someorg/somerepo.git/#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git:///git@github.com:someorg/somerepo.git/#b6968a12' );

  test.close( 'git' );

  /* - */

  test.open( 'https' );

  test.case = 'https path';
  var srcPath = 'https://github.com/someorg/somerepo.git';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git' );

  test.case = 'https path with tag';
  var srcPath = 'https://github.com/someorg/somerepo.git!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git!new' );

  test.case = 'https path with tag after slash';
  var srcPath = 'https://github.com/someorg/somerepo.git/!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git/!new' );

  test.case = 'https path with hash';
  var srcPath = 'https://github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'https path with hash after slash';
  var srcPath = 'https://github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https://github.com/someorg/somerepo.git/#b6968a12' );

  test.case = 'global https path';
  var srcPath = 'https:///github.com/someorg/somerepo.git';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https:///github.com/someorg/somerepo.git' );

  test.case = 'global https path with tag';
  var srcPath = 'https:///github.com/someorg/somerepo.git!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https:///github.com/someorg/somerepo.git!new' );

  test.case = 'global https path with tag after slash';
  var srcPath = 'https:///github.com/someorg/somerepo.git/!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https:///github.com/someorg/somerepo.git/!new' );

  test.case = 'global https path with hash';
  var srcPath = 'https:///github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https:///github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'global https path with hash after slash';
  var srcPath = 'https:///github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https:///github.com/someorg/somerepo.git/#b6968a12' );

  test.close( 'https' );

  /* - */

  test.open( 'git+https' );

  test.case = 'git+https path';
  var srcPath = 'git+https://github.com/someorg/somerepo.git';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+https://github.com/someorg/somerepo.git' );

  test.case = 'git+https path with tag';
  var srcPath = 'git+https://github.com/someorg/somerepo.git!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+https://github.com/someorg/somerepo.git!new' );

  test.case = 'git+https path with tag after slash';
  var srcPath = 'git+https://github.com/someorg/somerepo.git/!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+https://github.com/someorg/somerepo.git/!new' );

  test.case = 'git+https path with hash';
  var srcPath = 'git+https://github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+https://github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'git+https path with hash after slash';
  var srcPath = 'git+https://github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+https://github.com/someorg/somerepo.git/#b6968a12' );

  test.case = 'global git+https path';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git' );

  test.case = 'global git+https path with tag';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git!new' );

  test.case = 'global git+https path with tag after slash';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git/!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git/!new' );

  test.case = 'global git+https path with hash';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git#b6968a12' );

  test.case = 'global git+https path with hash after slash';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git/#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+https:///github.com/someorg/somerepo.git/#b6968a12' );

  test.close( 'git+https' );

  /* - */

  test.open( 'git+hd' );

  test.case = 'git+hd path';
  var srcPath = 'git+hd://Tools?out=out\\wTools.out.will';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+hd://Tools?out=out/wTools.out.will' );

  test.case = 'git+hd path with tag';
  var srcPath = 'git+hd://Tools?out=out\\wTools.out.will!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+hd://Tools?out=out/wTools.out.will!new' );

  test.case = 'git+hd path with tag after slash';
  var srcPath = 'git+hd://Tools?out=out\\wTools.out.will\\!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+hd://Tools?out=out/wTools.out.will/!new' );

  test.case = 'git+hd path with hash';
  var srcPath = 'git+hd://Tools?out=out\\wTools.out.will#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+hd://Tools?out=out/wTools.out.will#b6968a12' );

  test.case = 'git+hd path with hash after slash';
  var srcPath = 'git+hd://Tools?out=out\\wTools.out.will\\#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+hd://Tools?out=out/wTools.out.will/#b6968a12' );

  test.case = 'global git+hd path';
  var srcPath = 'git+hd:///Tools?out=out\\wTools.out.will';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will' );

  test.case = 'global git+hd path with tag';
  var srcPath = 'git+hd:///Tools?out=out\\wTools.out.will!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will!new' );

  test.case = 'global git+hd path with tag after slash';
  var srcPath = 'git+hd:///Tools?out=out\\wTools.out.will\\!new';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will/!new' );

  test.case = 'global git+hd path with hash';
  var srcPath = 'git+hd:///Tools?out=out\\wTools.out.will#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will#b6968a12' );

  test.case = 'global git+hd path with hash after slash';
  var srcPath = 'git+hd:///Tools?out=out\\wTools.out.will\\#b6968a12';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'git+hd:///Tools?out=out/wTools.out.will/#b6968a12' );

  test.close( 'git+hd' );

  /* - */

  test.case = 'https path with double slashes and dots';
  var srcPath = 'https://github.com//someorg/shoudBeKeeped/../somerepo.git//.';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https://github.com//someorg/shoudBeKeeped/../somerepo.git/.' );

  test.case = 'global https path with double slashes and dots';
  var srcPath = 'https:///github.com//someorg/shoudBeKeeped/../somerepo.git//.';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'https:///github.com//someorg/shoudBeKeeped/../somerepo.git/.' );

  test.case = 'local hd path with double slashes and dots';
  var srcPath = 'hd://..\\wModuleForTesting1\\out\\.\\wModuleForTesting1.out.will!dev1';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'hd://../wModuleForTesting1/out/./wModuleForTesting1.out.will!dev1' );

  test.case = 'global hd path with double slashes and dots';
  var srcPath = 'hd:///..\\wModuleForTesting1\\out\\.\\wModuleForTesting1.out.will!dev1';
  var got = _.git.path.refine( srcPath );
  test.identical( got, 'hd:///../wModuleForTesting1/out/./wModuleForTesting1.out.will!dev1' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.git.path.refine() );

  test.case = 'extra arguments';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git';
  test.shouldThrowErrorSync( () => _.git.path.refine( srcPath, srcPath ) );

  test.case = 'wrong type of path';
  var srcPath = 'git+https:///github.com/someorg/somerepo.git';
  test.shouldThrowErrorSync( () => _.git.path.refine({ srcPath }) );
}

// --
// declare
// --

const Proto =
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
    parseFullPathsHaveLocalVcsPath,
    parseAtomicRemoteProtocols,
    parseAtomicLocalProtocols,
    parseAtomicPathsHaveLocalVcsPath,
    parseObjects,

    //

    strWithSimpleProtocols,
    strWithComplexProtocols,
    strPathsHaveLocalVcsPath,

    normalize,
    nativize,
    refine,

  },

};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
