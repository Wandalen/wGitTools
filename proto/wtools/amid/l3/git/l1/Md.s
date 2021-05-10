( function _Md_s_()
{

'use strict';

const _ = _global_.wTools;
const Self = _.md = _.md || Object.create( null );

/* xxx : move out */

// --
// implementation
// --

function parse_head( routine, args )
{
  let o = args[ 0 ];
  if( _.str.is( o ) )
  o = { src : args[ 0 ] }

  _.assert( args.length === 1 );
  _.assert( arguments.length === 2 );

  o = _.routine.options( routine, o );

  return o;
}

function parse_body( o )
{
  o.sectionArray = o.sectionArray || [];
  o.sectionMap = o.sectionMap || Object.create( null );

  let section = sectionOpen();
  section.lineInterval[ 0 ] = 0;
  section.charInterval[ 0 ] = 0;
  let firstLine = _.str.lines.get( 0 ).val;
  let fromIndex = 0;
  if( lineIsSecationHead( firstLine ) )
  {
    sectionHead( section, firstLine );
    fromIndex += 1;
  }

  let op = _.str.lines.each( o.src, [ fromIndex, Infinity ], ( line, lineIndex, charInterval ) =>
  {
    lineAnalyze( ... arguments )
  });

  sectionClose( section, op );

  return o;

  /* */

  function lineAnalyze( line, it )
  {

    if( lineIsSecationHead( line ) )
    {
      sectionClose( section, lineIndex );
      section = sectionOpen();
      sectionHead( section, it.line );
    }

  }

  /* */

  function lineIsSecationHead( line )
  {
    if( _.strBegins( line.trimStart(), o.headToken ) )
    return true;
    return false;
  }

  /* */

  function sectionOpen()
  {
    let section = Object.create( null );
    o.sectionArray.push( section );
    section.head = null;
    section.rawHead = null;
    section.level = 0;
    section.lineInterval = [];
    section.charInterval = [];
    section.body = '';
    return section;
  }

  /* */

  function sectionClose( section, it )
  {
    section.lineInterval[ 1 ] = it.lineIndex - 1;
    section.charInterval[ 1 ] = it.charInterval[ 1 ];
  }

  /* */

  function sectionHead( section, line )
  {
    line = line.trimStart();
    let level = 0;
    while( line[ 0 ] === o.headToken )
    {
      level += 1;
      line = line.slice( 1 );
    }
    section.level = level;
    section.head = line.trim();
    o.sectionMap[ section.head ] = o.sectionMap[ section.head ] || [];
    o.sectionMap[ section.head ].push( section );
  }

  /* */

  function sectionAdopt( section, it )
  {
    section.text += line;
  }

  /* */

}

parse_body.defaults =
{
  headToken : '#',
  src : null,
}

let parse = _.routine.unite( parse_head, parse_body );

// --
// declaretion
// --

let Extension =
{

  parse,

}

_.props.extend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
