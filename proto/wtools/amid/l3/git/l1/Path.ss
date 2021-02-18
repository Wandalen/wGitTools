( function _Path_ss_()
{

'use strict';

let _ = _global_.wTools;
let Parent = _.uri.path;
let Self = _.git.path = _.git.path || Object.create( Parent );

// --
//
// --

function parse_head( routine, args )
{
  let o = args[ 0 ];

  _.assert( args.length === 1, 'Expects single options map {-o-}' );

  if( _.strIs( o ) )
  o = { remotePath : o };

  _.routineOptions( parse, o );
  _.assert( _.strIs( o.remotePath ) || _.mapIs( o.remotePath ), 'Expects file path {-o.remotePath-}' );
  _.assert
  (
    ( !o.full || !o.atomic )
    || ( !o.full && !o.atomic ),
    'Expects only full parsing with {-o.full-} or atomic parsing with {-o.atomic-} but not both'
  );

  return o;
}

//

function parse_body( o )
{
  if( _.mapIs( o.remotePath ) )
  return o.remotePath;


  let result = pathParse( o.remotePath, o.full );
  let objects = objectsParse( result.longPath, result.protocol );

  result = _.mapExtend( result, objects );

  if( o.full )
  return result;
  else if( o.atomic )
  return pathAtomicMake( result );
  else if( o.objects )
  return objects;
  else
  throw _.err( 'Routine should return some parsed path, but options set to return nothing' )

  /* */

  function pathParse( remotePath, full )
  {
    let result = Object.create( null );

    let parsed1 = _.uri.parseConsecutive( remotePath );
    _.mapExtend( result, parsed1 );

    if( !result.tag && !result.hash )
    result.tag = 'master';

    _.assert( !result.tag || !result.hash, 'Remote path:', _.strQuote( remotePath ), 'should contain only hash or tag, but not both.' )

    let isolated = pathIsolateGlobalAndLocal( parsed1 );
    result.localVcsPath = isolated.localPath;

    if( !full )
    return result;

    /* remoteVcsPath */

    let parsed2 = Object.create( null );
    result.protocols = parsed2.protocols = parsed1.protocol ? parsed1.protocol.split( '+' ) : [];

    // let isHardDrive = _.longHasAny( result.protocols, [ 'hd' ] );
    //
    // parsed2.longPath = isolated.globalPath;
    // if( !isHardDrive )
    // parsed2.longPath = _.strRemoveBegin( parsed2.longPath, '/' );
    // parsed2.longPath = _.strRemoveEnd( parsed2.longPath, '/' );
    //
    // let protocols = _.longSlice( parsed2.protocols );
    // parsed2.protocols = _.arrayRemovedArrayOnce( protocols, [ 'git', 'hd' ] );
    // result.remoteVcsPath = _.uri.str( parsed2 );
    //
    // if( isHardDrive )
    // result.remoteVcsPath = _.fileProvider.path.nativize( result.remoteVcsPath );
    //
    // /* remoteVcsLongerPath */
    //
    // let parsed3 = Object.create( null );
    // parsed3.longPath = parsed2.longPath;
    // parsed3.protocols = protocols;
    // result.remoteVcsLongerPath = _.uri.str( parsed3 );
    //
    // if( isHardDrive )
    // result.remoteVcsLongerPath = _.fileProvider.path.nativize( result.remoteVcsLongerPath );

    /* */

    result.isFixated = _.git.path.isFixated( result );

    _.assert( !_.boolLike( result.hash ) );

    return result;
  }

  /* */

  function pathIsolateGlobalAndLocal( parsedPath )
  {
    let splits = _.strIsolateLeftOrAll( parsedPath.longPath, '.git/' );
    if( parsedPath.query )
    {
      let query = _.strStructureParse
      ({
        src : parsedPath.query,
        keyValDelimeter : '=',
        entryDelimeter : '&'
      });
      if( query.out )
      splits[ 2 ] = _.uri.join( splits[ 2 ], query.out );
    }
    let globalPath = splits[ 0 ] + ( splits[ 1 ] || '' );
    let localPath = splits[ 2 ] || './';
    return { globalPath, localPath };
  }

  /* */

  function objectsParse( remotePath, protocol )
  {
    let objects = Object.create( null );
    let objectsRegexp;
    if( protocol && ( _.strHas( protocol, 'http' ) || _.strHas( protocol, 'ssh' ) ) )
    objectsRegexp = /([a-zA-Z0-9-_]+\.[a-zA-Z0-9-_]+)\/([a-zA-Z0-9-_.]+)\/([a-zA-Z0-9-_.]+)/;
    else if( protocol === undefined || _.strHas( protocol, 'git' ) )
    objectsRegexp = /([a-zA-Z0-9-_.]+\.[a-zA-Z0-9-_.]+):([a-zA-Z0-9-_.]+)\/([a-zA-Z0-9-_.]+)/
    else
    return objects;

    let match = remotePath.match( objectsRegexp );
    if( match )
    {
      objects.service = match[ 1 ];
      objects.user = match[ 2 ];
      objects.repo = _.strRemoveEnd( match[ 3 ], '.git' );
    }

    return objects;
  }

  /* */

  function pathAtomicMake( parsedPath )
  {
    if( parsedPath.protocol && _.strHas( parsedPath.protocol, 'hd' ) )
    return parsedPath;

    const butMap = { longPath : null };
    if( _.strBegins( parsedPath.longPath, '/' ) )
    parsedPath.isGlobal = true;
    return _.mapBut_( parsedPath, butMap );
  }
}

parse_body.defaults =
{
  remotePath : null,
  full : 1,
  atomic : 0,
  objects : 1,
};

//

let parse = _.routineUnite( parse_head, parse_body );

//

function str( srcPath )
{
  _.assert( arguments.length === 1, 'Expects single argument {-srcPath-}' );

  if( _.strIs( srcPath ) )
  return srcPath;

  _.assert( _.mapIs( srcPath ), 'Expects map with parsed path to construct string' );

  let result = '';
  let isParsedAtomic = srcPath.isFixated === undefined && srcPath.protocols === undefined;

  if( isParsedAtomic && srcPath.localVcsPath === undefined )
  throw _.err( 'Cannot create path from objects. Not enough information about protocols' );

  if( srcPath.protocol )
  result += srcPath.protocol + '://';
  if( srcPath.longPath )
  result += srcPath.longPath;

  if( isParsedAtomic )
  {
    if( srcPath.protocol && srcPath.protocol !== 'git' && !_.strHas( srcPath.protocol, 'ssh' ) )
    {
      if( srcPath.service )
      result += srcPath.isGlobal ? '/' + srcPath.service : srcPath.service;
      if( srcPath.user )
      result = _.uri.join( result, srcPath.user );
    }
    else
    {
      let prefix = srcPath.isGlobal ? '/' : ''
      let postfix = ( srcPath.protocol && _.strHas( srcPath.protocol, 'ssh' ) ) ? '/' : ':'
      if( srcPath.service )
      result += `${ prefix }git@${ srcPath.service }${ postfix }`;
      if( srcPath.user )
      result += srcPath.user;
    }

    if( srcPath.repo )
    result = _.uri.join( result, `${ srcPath.repo }.git` );
  }

  if( srcPath.query )
  result += _.uri.queryToken + srcPath.query;
  if( srcPath.tag )
  result += srcPath.tag === 'master' ? '' : _.uri.tagToken + srcPath.tag;
  if( srcPath.hash )
  result += _.uri.hashToken + srcPath.hash;

  return result;
}

//

function normalize( srcPath )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( srcPath ), 'Expects string path {-srcPath-}' );

  let parsed = _.git.path.parse( srcPath );

  _.assert( !!parsed.longPath );

  if( parsed.protocol )
  {
    let match = parsed.protocol.match( /(\w+)$/ );
    let postfix = match[ 0 ] === 'git' ? `` : `+${ match[ 0 ] }`;
    parsed.protocol = `git` + postfix;
  }
  else
  {
    parsed.protocol = 'git';
  }

  parsed.longPath = _.uri.join( _.path.rootToken, parsed.longPath );
  parsed.longPath = _.uri.normalize( parsed.longPath );
  return _.git.path.str( parsed );
}

// //
//
// function remotePathNormalize( remotePath )
// {
//   if( remotePath === null )
//   return remotePath;
//
//   remotePath = remotePath.replace( /^(\w+):\/\//, 'git+$1://' );
//   remotePath = remotePath.replace( /:\/\/\b/, ':///' );
//
//   return remotePath;
// }

//

function nativize( srcPath )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( srcPath ), 'Expects string path {-srcPath-}' );

  let parsed = _.git.path.parse( srcPath );

  _.assert( !!parsed.longPath );

  if( parsed.protocol )
  parsed.protocol = parsed.protocol.replace( /^git\+(\w+)/, '$1' );
  if( !parsed.protocol || parsed.protocol === 'git' )
  parsed.protocol = '';
  if( _.longHas( _.fileProvider.protocols, parsed.protocol ) )
  parsed.protocol = '';
  // parsed.protocol = 'git';

  parsed.longPath = _.uri.normalize( parsed.longPath );

  if( _.longHasAny( parsed.protocols, _.fileProvider.protocols ) )
  {
    parsed.longPath = _.uri.nativize( parsed.longPath );
    if( parsed.query )
    parsed.query = _.uri.nativize( parsed.query );
  }
  else
  {
    parsed.longPath = _.strRemoveBegin( parsed.longPath, '/' );
  }

  return _.git.path.str( parsed );
}

// //
//
// function remotePathNativize( remotePath )
// {
//   if( remotePath === null )
//   return remotePath;
//
//   remotePath = remotePath.replace( /^git\+(\w+):\/\//, '$1://' );
//   remotePath = remotePath.replace( /:\/\/\/\b/, '://' );
//
//   return remotePath;
// }

//

function refine( srcPath )
{
  _.assert( arguments.length === 1, 'Expects single path {-srcPath-}' );
  _.assert( _.strIs( srcPath ), 'Expects string path {-srcPath-}' );

  let parsed = _.git.path.parse( srcPath );
  parsed.longPath = _.path.refine( parsed.longPath );
  return _.git.path.str( parsed );
}

//

function isFixated( filePath )
{
  let parsed = _.git.path.parse({ remotePath : filePath, full : 0, atomic : 1 });

  if( !parsed.hash )
  return false;

  if( parsed.hash.length < 7 )
  return false;

  if( !/[0-9a-f]+/.test( parsed.hash ) )
  return false;

  return true;
}

//

/**
 * @summary Changes hash in provided path `o.remotePath` to hash of latest commit available.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function pathFixate
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function fixate( o )
{
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }
  _.routineOptions( fixate, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let parsed = _.git.path.parse({ remotePath : o.remotePath });
  let latestVersion = _.git.versionRemoteLatestRetrive
  ({
    remotePath : o.remotePath,
    verbosity : o.verbosity,
  });

  let result = path.str
  ({
    protocol : parsed.protocol,
    longPath : parsed.longPath,
    hash : latestVersion,
  });

  return result;
}

var defaults = fixate.defaults = Object.create( null );
defaults.remotePath = null;
defaults.verbosity = 0;

// --
// declare
// --

let Extension =
{

  parse,

  str,

  normalize,
  nativize,
  refine,

  isFixated,
  fixate,

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
