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
  test.identical( src.length, 14 );
  var got = _.md.parse( src );
  test.true( got.sectionArray[ 0 ] === got.sectionMap.h1[ 0 ] );
  test.true( got.sectionArray[ 1 ] === got.sectionMap.h2[ 0 ] );
  test.true( got.sectionArray[ 2 ] === got.sectionMap.h3[ 0 ] );
  delete got.sectionMap.h1;
  delete got.sectionMap.h2;
  delete got.sectionMap.h3;
  var exp =
  {
    src,
    "headToken" : `#`,
    "withText" : true,
    "sectionArray" :
    [
      {
        'head' :
        {
          'text' : 'h1',
          'raw' : 'h1',
          'charInterval' : [ 0, 3 ],
          'lineIndex' : 0
        },
        'body' :
        {
          'text' : '',
          'lineInterval' : [ 1, 0 ],
          'charInterval' : [ 4, 3 ],
        },
        "level" : 1,
        "lineInterval" : [ 0, 0 ],
        "charInterval" : [ 0, 3 ],
        "text" : '#h1\n',
      },
      {
        'head' :
        {
          'text' : 'h2',
          'raw' : 'h2',
          'charInterval' : [ 4, 8 ],
          'lineIndex' : 1
        },
        'body' :
        {
          'text' : '',
          'lineInterval' : [ 2, 1 ],
          'charInterval' : [ 9, 8 ]
        },
        "level" : 2,
        "lineInterval" : [ 1, 1 ],
        "charInterval" : [ 4, 8 ],
        "text" : '##h2\n',
      },
      {
        'head' :
        {
          'text' : 'h3',
          'raw' : 'h3',
          'charInterval' : [ 9, 13 ],
          'lineIndex' : 2,
        },
        'body' :
        {
          'text' : '',
          'lineInterval' : [ 3, 2 ],
          'charInterval' : [ 14, 13 ]
        },
        "level" : 3,
        "lineInterval" : [ 2, 2 ],
        "charInterval" : [ 9, 13 ],
        "text" : '###h3',
      }
    ],
    sectionMap : {},
  }
  test.identical( got, exp );
  console.log( _.entity.exportJs( got ) );

  /* */

  test.case = 'irregular heads with body';
  var src =
`# h1\t
cc
dd
## h2\u0020
ee
ff
`
  test.identical( src.length, 25 );
  var got = _.md.parse( src );
  test.true( got.sectionArray[ 0 ] === got.sectionMap.h1[ 0 ] );
  test.true( got.sectionArray[ 1 ] === got.sectionMap.h2[ 0 ] );
  delete got.sectionMap.h1;
  delete got.sectionMap.h2;
  var exp =
  {
    src,
    "headToken" : `#`,
    "withText" : true,
    "sectionArray" :
    [
      {
        "head" :
        {
          "text" : `h1`,
          "raw" : ` h1\t`,
          "charInterval" : [ 0, 5 ],
          "lineIndex" : 0
        },
        "body" :
        {
          "text" : `cc\ndd\n`,
          "lineInterval" : [ 1, 2 ],
          "charInterval" : [ 6, 11 ]
        },
        "level" : 1,
        "lineInterval" : [ 0, 2 ],
        "charInterval" : [ 0, 11 ],
        "text" : '# h1\t\ncc\ndd\n',
      },
      {
        "head" :
        {
          "text" : `h2`,
          "raw" : ` h2 `,
          "charInterval" : [ 12, 18 ],
          "lineIndex" : 3
        },
        "body" :
        {
          "text" : `ee\nff\n`,
          "lineInterval" : [ 4, 6 ],
          "charInterval" : [ 19, 24 ]
        },
        "level" : 2,
        "lineInterval" : [ 3, 6 ],
        "charInterval" : [ 12, 24 ],
        "text" : '## h2\u0020\nee\nff\n',
      }
    ],
    "sectionMap" : {},
  }
  test.identical( got, exp );
  console.log( _.entity.exportJs( got ) );

  /* */

  test.case = 'empty section without head';
  var src =
`
#h1
cc
`
  test.identical( src.length, 8 );
  var got = _.md.parse( src );
  test.true( got.sectionArray[ 1 ] === got.sectionMap.h1[ 0 ] );
  delete got.sectionMap.h1;
  var exp =
  {
    src,
    "headToken" : `#`,
    "withText" : true,
    "sectionArray" :
    [
      {
        "head" : { "text" : null, "raw" : null },
        "body" :
        {
          "text" : `\n`,
          "lineInterval" : [ 0, 0 ],
          "charInterval" : [ 0, 0 ]
        },
        "level" : 0,
        "lineInterval" : [ 0, 0 ],
        "charInterval" : [ 0, 0 ],
        "text" : '\n',
      },
      {
        "head" :
        {
          "text" : `h1`,
          "raw" : `h1`,
          "charInterval" : [ 1, 4 ],
          "lineIndex" : 1
        },
        "body" :
        {
          "text" : `cc\n`,
          "lineInterval" : [ 2, 3 ],
          "charInterval" : [ 5, 7 ]
        },
        "level" : 1,
        "lineInterval" : [ 1, 3 ],
        "charInterval" : [ 1, 7 ],
        "text" : '#h1\ncc\n',
      }
    ],
    "sectionMap" : {}
  }
  test.identical( got, exp );
  console.log( _.entity.exportJs( got ) );

  /* */

  test.case = 'single-line non-empty section without head';
  var src =
`aa
bb
#h1
cc
`
  test.identical( src.length, 13 );
  var got = _.md.parse( src );
  test.true( got.sectionArray[ 1 ] === got.sectionMap.h1[ 0 ] );
  delete got.sectionMap.h1;
  var exp =
  {
    src,
    "headToken" : `#`,
    "withText" : true,
    "sectionArray" :
    [
      {
        "head" : { "text" : null, "raw" : null },
        "body" :
        {
          "text" : `aa\nbb\n`,
          "lineInterval" : [ 0, 1 ],
          "charInterval" : [ 0, 5 ]
        },
        "level" : 0,
        "lineInterval" : [ 0, 1 ],
        "charInterval" : [ 0, 5 ],
        "text" : `aa\nbb\n`,
      },
      {
        "head" :
        {
          "text" : `h1`,
          "raw" : `h1`,
          "charInterval" : [ 6, 9 ],
          "lineIndex" : 2
        },
        "body" :
        {
          "text" : `cc\n`,
          "lineInterval" : [ 3, 4 ],
          "charInterval" : [ 10, 12 ]
        },
        "level" : 1,
        "lineInterval" : [ 2, 4 ],
        "charInterval" : [ 6, 12 ],
        "text" : `#h1\ncc\n`,
      }
    ],
    "sectionMap" : {}
  }
  test.identical( got, exp );
  console.log( _.entity.exportJs( got ) );

  /* */

  test.case = 'multi-line non-empty section without head';
  var src =
`
aa
bb
#h1
cc
`
  test.identical( src.length, 14 );
  var got = _.md.parse( src );
  test.true( got.sectionArray[ 1 ] === got.sectionMap.h1[ 0 ] );
  delete got.sectionMap.h1;
  var exp =
  {
    src,
    "headToken" : `#`,
    "withText" : true,
    "sectionArray" :
    [
      {
        "head" : { "text" : null, "raw" : null },
        "body" :
        {
          "text" : `\naa\nbb\n`,
          "lineInterval" : [ 0, 2 ],
          "charInterval" : [ 0, 6 ]
        },
        "level" : 0,
        "lineInterval" : [ 0, 2 ],
        "charInterval" : [ 0, 6 ],
        "text" : `\naa\nbb\n`,
      },
      {
        "head" :
        {
          "text" : `h1`,
          "raw" : `h1`,
          "charInterval" : [ 7, 10 ],
          "lineIndex" : 3
        },
        "body" :
        {
          "text" : `cc\n`,
          "lineInterval" : [ 4, 5 ],
          "charInterval" : [ 11, 13 ]
        },
        "level" : 1,
        "lineInterval" : [ 3, 5 ],
        "charInterval" : [ 7, 13 ],
        "text" : `#h1\ncc\n`,
      }
    ],
    "sectionMap" : {},
  }
  test.identical( got, exp );
  console.log( _.entity.exportJs( got ) );

  /* */

}

//

function textSectionReplace( test )
{

  /* */

  test.case = 'first';
  var src =
`#h1
cc
dd
##h2
ee
ff
`
  test.identical( src.length, 21 );
  var exp =
  {
    'dst' : `###hh
xx
yy
##h2
ee
ff
`,
    'name' : 'h1',
    'section' : `###hh
xx
yy
`,
    'replaced' : true
  }
  var got = _.md.textSectionReplace( src, 'h1', '###hh\nxx\nyy' );
  test.identical( got, exp );
  var got = _.md.textSectionReplace( src, 'h1', '###hh\nxx\nyy\n' );
  test.identical( got, exp );

  /* */

  test.case = 'last';
  var src =
`#h1
cc
dd
##h2
ee
ff
`
  test.identical( src.length, 21 );
  var exp =
  {
    'dst' : `#h1
cc
dd
###hh
xx
yy
`,
    'name' : 'h2',
    'section' : `###hh
xx
yy
`,
    'replaced' : true
  }
  var got = _.md.textSectionReplace( src, 'h2', '###hh\nxx\nyy' );
  test.identical( got, exp );
  var got = _.md.textSectionReplace( src, 'h2', '###hh\nxx\nyy\n' );
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

    textSectionReplace,

  },

};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
