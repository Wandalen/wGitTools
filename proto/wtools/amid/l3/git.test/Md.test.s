( function _Md_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'Tools' );
  _.include( 'wTesting' );
  require( '../git/entry/GitTools.ss' );
}

const _ = _global_.wTools;

// --
// tests
// --

function parseBasic( test )
{

  /* */

  test.case = 'only heads';
  var src =
`#h1
##h2
###h3`
  var got = _.md.parse( src );
  var exp =
  {
    src,
  }
  test.identical( got, exp );

  /* */

}

// --
// declare
// --

const Proto =
{

  name : 'Tools.mid.Md',
  silencing : 1,

  context :
  {
  },

  tests :
  {

    parseBasic,

  },

};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
