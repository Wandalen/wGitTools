( function _Path_ss_()
{

'use strict';

let _ = _global_.wTools;
let Parent = _.uri.path;
let Self = _.git.path = _.git.path || Object.create( Parent );

// --
//
// --

function parse( o )
{
  if( _.strIs( o ) )
  o = { filePath : o };

  _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
  _.routineOptions( parse, o );

  if( _.mapIs( o.filePath ) )
  return o.filePath;

  _.assert( _.strIs( o.filePath ), 'Expects file path {-o.filePath-}' );

  let result = pathParse( o.filePath );
  if( o.full )
  return result;
  return pathAtomicMake( result );

  /* */

  function objectsParse( remotePath )
  {
    let result = Object.create( null );
    let gitHubRegexp = /\:\/\/\/github\.com\/([a-zA-Z0-9-_.]+)\/([a-zA-Z0-9-_.]+)/;
    // let gitHubRegexp = /\:\/\/\/github\.com\/(\w+)\/(\w+)(\.git)?/;
    /* Dmytro : this regexp does not search dashes, maybe needs additional symbols */

    remotePath = this.remotePathNormalize( remotePath );
    let match = remotePath.match( gitHubRegexp );

    if( match )
    {
      result.service = 'github.com';
      result.user = match[ 1 ];
      result.repo = _.strRemoveEnd( match[ 2 ], '.git' );
    }

    return result;
  }

  /* */

  function pathParse( remotePath )
  {
    let result = Object.create( null );

    let parsed1 = _.uri.parseConsecutive( remotePath );
    _.mapExtend( result, parsed1 );

    if( !result.tag && !result.hash )
    result.tag = 'master';

    _.assert( !result.tag || !result.hash, 'Remote path:', _.strQuote( remotePath ), 'should contain only hash or tag, but not both.' )

    let isolated = pathIsolateGlobalAndLocal( parsed1 );
    result.localVcsPath = isolated.localPath;

    /* remoteVcsPath */

    let parsed2 = Object.create( null );
    result.protocols = parsed2.protocols = parsed1.protocol ? parsed1.protocol.split( '+' ) : [];

    let isHardDrive = _.longHasAny( result.protocols, [ 'hd' ] );

    parsed2.longPath = isolated.globalPath;
    if( !isHardDrive )
    parsed2.longPath = _.strRemoveBegin( parsed2.longPath, '/' );
    parsed2.longPath = _.strRemoveEnd( parsed2.longPath, '/' );

    let protocols = _.longSlice( parsed2.protocols );
    parsed2.protocols = _.arrayRemovedArrayOnce( protocols, [ 'git', 'hd' ] );
    result.remoteVcsPath = _.uri.str( parsed2 );

    if( isHardDrive )
    result.remoteVcsPath = _.fileProvider.path.nativize( result.remoteVcsPath );

    /* remoteVcsLongerPath */

    let parsed3 = Object.create( null );
    parsed3.longPath = parsed2.longPath;
    parsed3.protocols = protocols;
    result.remoteVcsLongerPath = _.uri.str( parsed3 );

    if( isHardDrive )
    result.remoteVcsLongerPath = _.fileProvider.path.nativize( result.remoteVcsLongerPath );

    /* */

    result.isFixated = _.git.path.pathIsFixated( result );

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

  function pathAtomicMake( src )
  {
    return src;
  }
}

parse.defaults =
{
  filePath : null,
  full : 1,
  atomic : 0,
};

//

function pathIsFixated( filePath )
{
  let parsed = _.git.path.parse({ filePath });

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

function pathFixate( o )
{
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }
  _.routineOptions( pathFixate, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let parsed = _.git.path.parse({ filePath : o.remotePath });
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

var defaults = pathFixate.defaults = Object.create( null );
defaults.remotePath = null;
defaults.verbosity = 0;

//

function remotePathNormalize( remotePath )
{
  if( remotePath === null )
  return remotePath;

  remotePath = remotePath.replace( /^(\w+):\/\//, 'git+$1://' );
  remotePath = remotePath.replace( /:\/\/\b/, ':///' );

  return remotePath;
}

//

function remotePathNativize( remotePath )
{
  if( remotePath === null )
  return remotePath;

  remotePath = remotePath.replace( /^git\+(\w+):\/\//, '$1://' );
  remotePath = remotePath.replace( /:\/\/\/\b/, '://' );

  return remotePath;
}

// --
// declare
// --

let Extension =
{
  // path

  parse,

  pathIsFixated,
  pathFixate,

  remotePathNormalize,
  remotePathNativize,

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
