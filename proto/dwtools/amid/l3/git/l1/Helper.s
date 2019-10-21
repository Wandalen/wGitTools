( function _Helper_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../IncludeBase.s' );

  var Ini = require( 'ini' );

}

let _ = wTools;
let Self = _.git = _.git || Object.create( null );

// --
// inter
// --

function configRead( filePath )
{
  let fileProvider = _.fileProvider;
  let path = fileProvider.path;

  // debugger;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( filePath ) );

  let read = fileProvider.fileRead( path.join( filePath, '.git/config' ) );
  let config = Ini.parse( read );

  return config;
}

//

function objectsParse( remotePath )
{
  let result = Object.create( null );
  let gitHubRegexp = /\:\/\/\/github\.com\/(\w+)\/(\w+)\.git/;

  remotePath = this.remotePathNormalize( remotePath );
  let match = remotePath.match( gitHubRegexp );

  if( match )
  {
    result.service = 'github.com';
    result.user = match[ 1 ];
    result.repo = match[ 2 ];
  }

  return result;
}

//

/**
 * @typedef {Object} RemotePathComponents
 * @property {String} protocol
 * @property {String} hash
 * @property {String} longPath
 * @property {String} localVcsPath
 * @property {String} remoteVcsPath
 * @property {String} longerRemoteVcsPath
 * @memberof module:Tools/mid/GitTools.
 */

function pathParse( remotePath )
{
  let path = _.uri;
  let result = Object.create( null );

  if( _.mapIs( remotePath ) )
  return remotePath;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( remotePath ) );
  _.assert( path.isGlobal( remotePath ) )

  /* */

  // debugger;
  let parsed1 = path.parseConsecutive( remotePath );
  parsed1.hash = parsed1.hash || 'master';
  _.mapExtend( result, parsed1 );

  let p = pathIsolateGlobalAndLocal();
  result.localVcsPath = p[ 1 ];

  /* */

  let parsed2 = _.mapExtend( null, parsed1 );
  parsed2.hash = null;
  parsed2.protocols = parsed2.protocol ? parsed2.protocol.split( '+' ) : [];
  delete parsed2.protocol;

  // let isHardDrive = !_.arrayHasAny( parsed2.protocols, [ 'http', 'https', 'ssh' ] );
  let isHardDrive = _.arrayHasAny( parsed2.protocols, [ 'hd' ] );
  let isRelative = path.isRelative( parsed2.longPath );

  if( parsed2.protocols.length > 0 && parsed2.protocols[ 0 ].toLowerCase() === 'git' )
  {
    parsed2.protocols.splice( 0,1 );
  }

  if( parsed2.protocols.length > 0 && parsed2.protocols[ 0 ].toLowerCase() === 'hd' )
  {
    parsed2.protocols.splice( 0,1 );
  }

  parsed2.longPath = p[ 0 ];
  if( !isHardDrive )
  parsed2.longPath = _.strRemoveBegin( parsed2.longPath, '/' );
  parsed2.longPath = _.strRemoveEnd( parsed2.longPath, '/' );
  delete parsed2.query;

  result.remoteVcsPath = path.str( parsed2 );

  if( isHardDrive )
  result.remoteVcsPath = _.fileProvider.path.nativize( result.remoteVcsPath );

  /* */

  let parsed3 = _.mapExtend( null, parsed1 );
  parsed3.longPath = parsed2.longPath;

  parsed3.protocols = parsed2.protocols.slice();
  parsed3.protocol = null;
  parsed3.hash = null;
  delete parsed3.query;
  result.longerRemoteVcsPath = path.str( parsed3 );

  if( isHardDrive )
  result.longerRemoteVcsPath = _.fileProvider.path.nativize( result.longerRemoteVcsPath );

  result.isFixated = _.git.pathIsFixated( result );

  /* */

  // debugger;
  _.assert( !_.boolLike( result.hash ) );
  return result

/*

  remotePath : 'git+https:///github.com/Wandalen/wTools.git/out/wTools#master'
  protocol : 'git+https',
  hash : 'master',
  longPath : '/github.com/Wandalen/wTools.git/out/wTools',
  localVcsPath : 'out/wTools',
  remoteVcsPath : 'github.com/Wandalen/wTools.git',
  longerRemoteVcsPath : 'https://github.com/Wandalen/wTools.git'

*/

  /* */

  function pathIsolateGlobalAndLocal()
  {
    let splits = _.strIsolateLeftOrAll( parsed1.longPath, '.git/' );
    if( parsed1.query )
    {
      let query = _.strStructureParse({ src : parsed1.query, keyValDelimeter : '=', entryDelimeter : '&' });
      if( query.out )
      splits[ 2 ] = path.join( splits[ 2 ], query.out );
    }
    let globalPath = splits[ 0 ] + ( splits[ 1 ] || '' );
    let localPath = splits[ 2 ] === '' ? './' : splits[ 2 ];
    return [ globalPath, localPath ];
  }

/*
  function pathIsolateGlobalAndLocal( remotePath )
  {
    let parsed = path.parseConsecutive( remotePath );
    let splits = _.strIsolateLeftOrAll( parsed.longPath, '.git/' );
    parsed.longPath = splits[ 0 ] + ( splits[ 1 ] || '' );
    let globalPath = path.str( parsed );
    return [ globalPath, splits[ 2 ] ];
  }

*/

}

//

function pathIsFixated( filePath )
{
  let parsed = _.git.pathParse( filePath );

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
 * @memberof module:Tools/mid/GitTools.
 */

function pathFixate( o )
{
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }
  _.routineOptions( pathFixate, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let parsed = _.git.pathParse( o.remotePath );
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

  remotePath = remotePath.replace( /^(\w+):\/\//, 'git+$1://' );
  remotePath = remotePath.replace( /:\/\/\b/, ':///' );

  return remotePath;
}

//

function remotePathNativize( remotePath )
{

  debugger;

  remotePath = remotePath.replace( /^git\+(\w+):\/\//, '$1://' );
  remotePath = remotePath.replace( /:\/\/\/\b/, '://' );

  return remotePath;
}

//

function remotePathFromLocal( o )
{
  if( _.strIs( arguments[ 0 ] ) )
  o = { localPath : arguments[ 0 ] }
  o = _.routineOptions( remotePathFromLocal, o );
  let config = _.git.configRead( o.localPath );
  let remotePath = config[ 'remote "origin"' ].url;

  if( remotePath )
  remotePath = this.remotePathNormalize( remotePath );

  return remotePath;
}

remotePathFromLocal.defaults =
{
  localPath : null,
}

//

function localPathFromInside( o )
{
  let localProvider = _.fileProvider;
  let path = localProvider.path;

  if( _.strIs( arguments[ 0 ] ) )
  o = { insidePath : o }

  _.routineOptions( localPathFromInside, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let paths = path.traceToRoot( o.insidePath );

  for( var i = paths.length - 1; i >= 0; i-- )
  if( _.git.isRepository({ localPath : paths[ i ] }) )
  return paths[ i ];

  return null;
}

var defaults = localPathFromInside.defaults = Object.create( null );
defaults.insidePath = null;

//

function insideRepository( o )
{
  return !!this.localPathFromInside( o );
}

var defaults = insideRepository.defaults = Object.create( null );
defaults.insidePath = null;

//

function versionLocalChange( o )
{
  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( versionLocalChange, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let localVersion = _.git.versionLocalRetrive({ localPath : o.localPath, verbosity : o.verbosity });

  if( !localVersion )
  return false;

  if( localVersion === o.version )
  return true;

  let shell = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    sync : 1,
    deasync : 0,
    outputCollecting : 1,
    currentPath : o.localPath
  });

  let result = shell( 'git status' );
  let localChanges = _.strHas( result.output, 'Changes to be committed' );

  if( localChanges )
  shell( 'git stash' )

  shell( 'git checkout ' + o.version );

  if( localChanges )
  shell( 'git pop' )

  return true;
}

var defaults = versionLocalChange.defaults = Object.create( null );
defaults.localPath = null;
defaults.version = null
defaults.verbosity = 0;

//

/**
 * @summary Returns hash of latest commit from git repository located at `o.localPath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Path to git repository on hard drive.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function versionLocalRetrive
 * @memberof module:Tools/mid/GitTools.
 */

function versionLocalRetrive( o )
{
  let localProvider = _.fileProvider;
  let path = localProvider.path;

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( versionLocalRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.localPath ), 'Expects local path' );

  if( !_.git.isDownloaded( o ) )
  return '';

  let gitPath = path.join( o.localPath, '.git' );

  if( !localProvider.fileExists( gitPath ) )
  return '';

  let currentVersion = localProvider.fileRead( path.join( gitPath, 'HEAD' ) );
  let r = /^ref: refs\/heads\/(.+)\s*$/;

  let found = r.exec( currentVersion );
  if( found )
  currentVersion = found[ 1 ];

  return currentVersion.trim() || null;
}

var defaults = versionLocalRetrive.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;

//

/**
 * @summary Returns hash of latest commit from git repository using its remote path `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path to git repository.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function versionRemoteLatestRetrive
 * @memberof module:Tools/mid/GitTools.
 */

function versionRemoteLatestRetrive( o )
{
  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routineOptions( versionRemoteLatestRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let parsed = _.git.pathParse( o.remotePath );
  let shell = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    sync : 1,
    deasync : 0,
    outputCollecting : 1,
  });

  let got = shell( 'git ls-remote ' + parsed.longerRemoteVcsPath );
  let latestVersion = /([0-9a-f]+)\s+HEAD/.exec( got.output );
  if( !latestVersion || !latestVersion[ 1 ] )
  return null;

  latestVersion = latestVersion[ 1 ];

  return latestVersion;
}

var defaults = versionRemoteLatestRetrive.defaults = Object.create( null );
defaults.remotePath = null;
defaults.verbosity = 0;

//

/**
 * @summary Returns commit hash from remote path `o.remotePath`.
 * @description Returns hash of latest commit if no hash specified in remote path.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function versionRemoteCurrentRetrive
 * @memberof module:Tools/mid/GitTools.
 */

function versionRemoteCurrentRetrive( o )
{
  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routineOptions( versionRemoteCurrentRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let parsed = _.git.pathParse( o.remotePath );
  if( parsed.isFixated )
  return parsed.hash;

  return _.git.versionRemoteLatestRetrive( o );
}

var defaults = versionRemoteCurrentRetrive.defaults = Object.create( null );
defaults.remotePath = null;
defaults.verbosity = 0;

//

/**
 * @summary Returns true if local copy of repository `o.localPath` is up to date with remote repository `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to repository.
 * @param {String} o.remotePath Remote path to repository.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function isUpToDate
 * @memberof module:Tools/mid/GitTools.
 */

function isUpToDate( o )
{
  let localProvider = _.fileProvider;
  let path = localProvider.path;

  _.routineOptions( isUpToDate, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let srcCurrentPath;
  let parsed = _.git.pathParse( o.remotePath );
  let ready = _.Consequence().take( null );

  let shell = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    ready : ready,
    currentPath : o.localPath,
  });

  let shellAll = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    ready : ready,
    currentPath : o.localPath,
    throwingExitCode : 0,
    outputCollecting : 1,
  });

  if( !localProvider.fileExists( o.localPath ) )
  return false;

  let gitConfigExists = localProvider.fileExists( path.join( o.localPath, '.git' ) );

  if( !gitConfigExists )
  return false;

  if( gitConfigExists )
  ready
  // .give( () => GitConfig( localProvider.path.nativize( o.localPath ), ready.tolerantCallback() ) )
  .then( () => _.git.configRead( o.localPath ) )
  .ifNoErrorThen( function( arg )
  {

    // debugger;

    if( !arg[ 'remote "origin"' ] || !arg[ 'remote "origin"' ] || !_.strIs( arg[ 'remote "origin"' ].url ) )
    return false;

    srcCurrentPath = arg[ 'remote "origin"' ].url;

    if( !_.strEnds( srcCurrentPath, parsed.remoteVcsPath ) )
    return false;

    return true;
  });

  shell( 'git fetch origin' );

  ready.finally( ( err, arg ) =>
  {
    if( err )
    throw _.err( err );
    return null;
  });

  shellAll
  ([
    // 'git diff origin/master --quiet --exit-code',
    // 'git diff --quiet --exit-code',
    // 'git branch -v',
    'git status',
  ]);

  ready
  .ifNoErrorThen( function( arg )
  {
    _.assert( arg.length === 1 );

    let result = false;
    let detachedRegexp = /HEAD detached at (\w+)/;
    let detachedParsed = detachedRegexp.exec( arg[ 0 ].output );
    let versionLocal = _.git.versionLocalRetrive({ localPath : o.localPath, verbosity : o.verbosity });

    if( detachedParsed )
    {
      result = _.strBegins( parsed.hash, detachedParsed[ 1 ] );
    }
    else if( _.strBegins( parsed.hash, versionLocal ) )
    {
      result = !_.strHasAny( arg[ 0 ].output, [ 'Your branch is behind', 'have diverged' ] );
    }

    if( o.verbosity >= 1 )
    logger.log( o.remotePath, result ? 'is up to date' : 'is not up to date' );

    return result;
  })

  ready
  .finally( function( err, arg )
  {
    if( err )
    throw _.err( err );
    return arg;
  });

  return ready.split();
}

var defaults = isUpToDate.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.verbosity = 0;

//

/**
 * @summary Returns true if path `o.localPath` contains a git repository.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function isDownloaded
 * @memberof module:Tools/mid/GitTools.
 */

function isDownloaded( o )
{
  let localProvider = _.fileProvider;

  _.routineOptions( isDownloaded, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !localProvider.isDir( o.localPath  ) )
  return false;
  if( !localProvider.dirIsEmpty( o.localPath ) )
  return true;

  return false;
}

var defaults = isDownloaded.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;

//

function isRepository( o )
{
  let localProvider = _.fileProvider;
  let path = localProvider.path;

  _.routineOptions( isRepository, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( localProvider.fileExists( path.join( o.localPath, '.git/config' ) ) )
  return true;

  return false;
}

var defaults = isRepository.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;

//

/**
 * @summary Returns true if path `o.localPath` contains a git repository that was cloned from remote `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {String} o.remotePath Remote path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function isDownloadedFromRemote
 * @memberof module:Tools/mid/GitTools.
 */

function isDownloadedFromRemote( o )
{
  let localProvider = _.fileProvider;
  let path = localProvider.path;

  _.routineOptions( isDownloadedFromRemote, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( _.strDefined( o.remotePath ) );

  let result = Object.create( null );
  result.downloaded = true;
  result.downloadedFromRemote = false;

  if( !localProvider.fileExists( o.localPath ) )
  {
    result.downloaded = false;
    return result;
  }

  let gitConfigExists = localProvider.fileExists( path.join( o.localPath, '.git/config' ) );

  if( !gitConfigExists )
  {
    result.downloaded = false;
    return result;
  }

  let config = _.git.configRead( o.localPath );
  let remoteVcsPath = _.git.pathParse( o.remotePath ).remoteVcsPath;
  let originVcsPath = config[ 'remote "origin"' ].url;

  _.sure( _.strDefined( remoteVcsPath ) );
  _.sure( _.strDefined( originVcsPath ) );

  result.remoteVcsPath = remoteVcsPath;
  result.originVcsPath = originVcsPath;
  result.downloadedFromRemote = originVcsPath === remoteVcsPath;

  return result;
}

var defaults = isDownloadedFromRemote.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.verbosity = 0;

//

function versionsRemoteRetrive( o )
{
  _.routineOptions( versionsRemoteRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.localPath ) );

  let ready = _.process.start
  ({
    execPath : 'git',
    mode : 'spawn',
    currentPath : o.localPath,
    args :
    [
      'branch',
      '-r',
      '--no-abbrev',
      '--format=%(refname:lstrip=3)'
    ],
    inputMirroring : 0,
    outputPiping : 0,
    outputCollecting : 1,
  })

  ready.finally( ( err, got ) =>
  {
    if( err )
    throw _.err( 'Can\'t retrive remote versions. Reason:', err );

    let result = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });
    return result.slice( 1 );
  })

  return ready;
}

var defaults = versionsRemoteRetrive.defaults = Object.create( null );
defaults.localPath = null;

//

function versionsPull( o )
{
  _.routineOptions( versionsPull, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  return _.git.versionsRemoteRetrive({ localPath : o.localPath })
  .then( ( versions ) =>
  {
    _.assert( _.arrayIs( versions ) && versions.length );

    let ready = new _.Consequence().take( null );
    let start = _.process.starter
    ({
      mode : 'shell',
      currentPath : o.localPath,
      ready : ready
    });
    _.each( versions, ( version ) => start( `git checkout ${version} && git pull` ) );

    return ready;
  })
}

var defaults = versionsPull.defaults = Object.create( null );
defaults.localPath = null;

//

function hasLocalChanges_pre( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( routine, o );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( args.length === 1 );

  _.each( routine.uncommittedGroup, ( k ) =>
  {
    if( o[ k ] === null )
    o[ k ] = o.uncommitted;
  })

  _.each( routine.unpushedGroup, ( k ) =>
  {
    if( o[ k ] === null )
    o[ k ] = o.unpushed;
  })

  return o;
}

//

function hasLocalChanges_body( o )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  let shell = _.process.starter
  ({
    currentPath : o.localPath,
    mode : 'spawn',
    sync : o.sync,
    deasync : 0,
    throwingExitCode : 1,
    outputCollecting : 1,
    verbosity : o.verbosity - 1,
  });

  let ready = _.Consequence.Try( () => shell( 'git status --ignored -u --porcelain -b' ) )

  .then( ( got ) =>
  {
    let output = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });

    /*
    check for any changes, except new commits/tags/branches
    */

    let uncommittedFastCheck = o.uncommittedUntracked && o.uncommittedAdded &&
                               o.uncommittedChanged && o.uncommittedDeleted &&
                               o.uncommittedRenamed && o.uncommittedCopied;

    if( uncommittedFastCheck )
    {
      if( output.length > 1 )
      return true;
    }
    else
    {
      if( o.uncommittedUntracked )
      if( _.strHas( got.output, /^\? .*/gm ) )
      return true;

      if( o.uncommittedAdded )
      if( _.strHas( got.output, /^A .*/gm ) )
      return true;

      if( o.uncommittedChanged )
      if( _.strHas( got.output, /^M .*/gm ) )
      return true;

      if( o.uncommittedDeleted )
      if( _.strHas( got.output, /^D .*/gm ) )
      return true;

      if( o.uncommittedRenamed )
      if( _.strHas( got.output, /^R .*/gm ) )
      return true;

      if( o.uncommittedCopied )
      if( _.strHas( got.output, /^C .*/gm ) )
      return true;

      if( o.uncommittedIgnored )
      if( _.strHas( got.output, /^!! .*/gm ) )
      return true;
    }

    /*
    check for unpushed commits/tags/branches
    */

    if( o.unpushedCommits )
    if( _.strHas( output[ 0 ], /\[ahead.*\]/ ) )
    return true;

    return false;
  })

  if( o.unpushedTags )
  ready.then( ( result ) =>
  {
    if( result )
    return true;
    return checkTags();
  })

  if( o.unpushedBranches )
  ready.then( ( result ) =>
  {
    if( result )
    return true;
    return checkBranches();
  })

  ready.finally( ( err, got ) =>
  {
    if( err )
    throw _.err( err, '\nFailed to check if repository has local changes' );
    return got;
  })

  if( o.sync )
  return ready.syncMaybe();

  return ready;

  /* - */

  function checkTags()
  {
    let ready = _.Consequence.Try( () => shell( 'git push --tags --dry-run' ) );
    ready.then( ( got ) =>
    {
      if( _.strHas( got.output, '[new tag]' ) )
      return true;
      return false;
    })
    return ready;
  }

  /* - */

  function checkBranches()
  {
    let ready = _.Consequence.Try( () => shell( 'git push --all --dry-run' ) );
    ready.then( ( got ) =>
    {
      if( _.strHas( got.output, '[new branch]' ) )
      return true;
      return false;
    })
    return ready;
  }
}

var defaults = hasLocalChanges_body.defaults = Object.create( null );

defaults.localPath = null;
defaults.sync = 1;
defaults.verbosity = 0;

defaults.uncommitted = 1;
defaults.uncommittedUntracked = null;
defaults.uncommittedAdded = null;
defaults.uncommittedChanged = null;
defaults.uncommittedDeleted = null;
defaults.uncommittedRenamed = null;
defaults.uncommittedCopied = null;
defaults.uncommittedIgnored = 0;

defaults.unpushed = 1;
defaults.unpushedCommits = null;
defaults.unpushedTags = 0;
defaults.unpushedBranches = 0;

hasLocalChanges_body.uncommittedGroup =
[
  'uncommittedUntracked',
  'uncommittedAdded',
  'uncommittedChanged',
  'uncommittedDeleted',
  'uncommittedRenamed',
  'uncommittedCopied',
  'uncommittedIgnored'
]

hasLocalChanges_body.unpushedGroup =
[
  'unpushedCommits',
  'unpushedTags',
  'unpushedBranches',
]

let hasLocalChanges = _.routineFromPreAndBody( hasLocalChanges_pre, hasLocalChanges_body );

//
//
// function hasLocalChangesComplex( o )
// {
//   let provider = _.fileProvider;
//   let path = provider.path;
//
//   if( !_.mapIs( o ) )
//   o = { localPath : o }
//
//   _.routineOptions( hasLocalChangesComplex, o );
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( _.strDefined( o.localPath ) );
//
//   let ready = _.Consequence.Try( () =>
//   {
//     if( !provider.fileExists( path.join( o.localPath, '.git' ) ) )
//     throw _.err( 'Found no GIT repository at:', o.localPath );
//
//     let commands =
//     [
//       'git diff HEAD --quiet',
//       'git rev-list origin..HEAD --count',
//       'git status -sz'
//     ]
//
//     return _.process.start
//     ({
//       execPath : commands,
//       currentPath : o.localPath,
//       mode : 'spawn',
//       sync : 0,
//       deasync : 0,
//       throwingExitCode : 0,
//       outputCollecting : 1,
//       verbosity : o.verbosity - 1,
//     });
//   })
//
//   ready.then( ( got ) =>
//   {
//     if( got[ 0 ].exitCode === 1 /* diff */ )
//     return true;
//     if( _.numberFrom( got[ 1 ].output ) /* commits ahead */ )
//     return true;
//     if( _.strHas( got[ 2 ].output, '?' ) /* untracked files */ )
//     return true;
//
//     if( got[ 1 ].exitCode )
//     throw _.err( infoGet( got[ 1 ] ) );
//     if( got[ 2 ].exitCode )
//     throw _.err( infoGet( got[ 2 ] ) );
//
//     return false;
//
//     // let localChanges = _.strHasAny( got.output, [ 'Changes to be committed', 'Changes not staged for commit' ] );
//     // if( !localChanges )
//     // localChanges = !_.strHasAny( got.output, [ 'nothing to commit', 'working tree clean' ] )
//     // let localCommits = _.strHasAny( got.output, [ 'branch is ahead', 'have diverged' ] );
//     // return localChanges || localCommits;
//   })
//
//   ready.catch( ( err ) =>
//   {
//     throw _.err( err, '\nFailed to check if repository has local changes' );
//   })
//
//   if( o.sync )
//   return ready.deasync();
//
//   return ready;
//
//   /* */
//
//   function infoGet( o )
//   {
//     let result = '';
//     result += 'Process returned exit code' + o.exitCode + '\n';
//     result += 'Launched as ' + _.strQuote( o.fullExecPath ) + '\n';
//     result += 'Launched at ' + _.strQuote( o.currentPath ) + '\n';
//     result += '\n -> Output' + '\n' + ' -  ' + _.strIndentation( stderrOutput, ' -  ' ) + '\n -< Output';
//     return result;
//   }
// }
//
// var defaults = hasLocalChangesComplex.defaults = Object.create( null );
// defaults.localPath = null;
// defaults.verbosity = 0;
// defaults.sync = 1;

//

function hasRemoteChanges( o )
{
  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( hasRemoteChanges, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );

  let shell =  _.process.starter
  ({
    currentPath : o.localPath,
    mode : 'shell',
    sync : o.sync,
    deasync : 0,
    throwingExitCode : 1,
    outputCollecting : 1,
    stdio : [ 'pipe', 'pipe', 'ignore' ],
    verbosity : 2,
  });

  let remotes;
  let ready = _.Consequence.Try( () =>
  {
    if( o.commits || o.branches || o.tags )
    return shell( 'git ls-remote' );
    return false;
  })

  .then( ( arg ) =>
  {
    if( !arg )
    return false;
    remotes = parseRefs( arg.output );
    remotes = remotes.slice( 1 );
    return check();
  })
  .catch( ( err ) =>
  {
    if( err )
    throw _.err( err, '\nFailed to check if remote repository has changes' );
  })

  if( o.sync )
  return ready.syncMaybe();

  return ready;

  /* - */

  function parseRefs( src )
  {
    let result = _.strSplitNonPreserving({ src : src, delimeter : '\n' });
    return result.map( ( src ) => _.strSplitNonPreserving({ src : src, delimeter : /\s+/ }) );
  }

  //

  function check()
  {
    let ready = _.Consequence.Try( () => shell( 'git show-ref --heads --tags' ) )
    .then( ( got ) =>
    {
      for( var r = 0; r < remotes.length ; r++ )
      {
        let hash = remotes[ r ][ 0 ];
        let ref = remotes[ r ][ 1 ];

        if( o.branches )
        if( _.strBegins( ref, 'refs/heads' ) )
        if( !_.strHas( got.output, ref ) )
        return true;

        if( o.tags )
        if( _.strBegins( ref, 'refs/tags' ) )
        if( !_.strHas( got.output, ref ) )
        return true;

        if( o.commits )
        {
          let result = shell
          ({
            execPath : `git branch --contains ${hash} --quiet --format=%(refname)`,
            stdio : 'pipe',
            throwingExitCode : 0,
            sync : 1
          });
          if( !_.strHas( result.output, ref ) )
          return true;
        }
      }

      return false;
    })

    return ready;
  }
}

var defaults = hasRemoteChanges.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;
defaults.commits = 1;
defaults.branches = 1;
defaults.tags = 0;
defaults.sync = 1;

//

function hasChanges( o )
{
  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( hasChanges, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );

  let ready = _.Consequence.Try( () =>
  {
    if( o.local )
    return this.hasLocalChanges( _.mapOnly( o, this.hasLocalChanges.defaults ) );
    return false;
  })
  .then( ( result ) =>
  {
    if( !result && o.remote )
    return this.hasRemoteChanges( _.mapOnly( o, this.hasRemoteChanges.defaults ) );
    return result;
  })

  if( o.sync )
  return ready.syncMaybe();

  return ready;
}

var defaults = hasChanges.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;
defaults.sync = 1;
defaults.remote = 1;
defaults.uncommitted = 1;
defaults.unpushed = 1;
defaults.local = 1;

//

function prsGet( o )
{
  let ready = new _.Consequence().take( null );

  if( _.strIs( o ) )
  o = { remotePath : o }
  o = _.routineOptions( prsGet, o );

  let parsed = this.objectsParse( o.remotePath );

  ready
  .then( () =>
  {
    if( parsed.service === 'github.com' )
    return prsOnGitgub();
    debugger;
    if( o.throwing )
    throw _.err( 'Unknown service' );
    return null;
  })
  .finally( ( err, prs ) =>
  {
    if( !err && !prs && o.throwing )
    err = _.err( 'Failed' );
    if( err )
    if( !o.throwing )
    {
      _.errAttend( err );
      return null;
    }
    else
    {
      throw _.err( err, '\nFailed to get list of pull requests' );
    }
    return prs;
  });

  if( o.sync )
  return ready.deasync();

  return ready;

  /* */

  function prsOnGitgub()
  {
    let ready = new _.Consequence().take( null );
    ready
    .then( () =>
    {
      var github = require( 'octonode' );
      var client = github.client();
      let repo = client.repo( `${parsed.user}/${parsed.repo}` );
      return repo.prsAsync();
    })
    .then( ( result ) =>
    {
      return result[ 0 ];
    });
    return ready;
  }

}

prsGet.defaults =
{
  remotePath : null,
  throwing : 1,
  sync : 1,
}

//

function infoStatus( o )
{

  o = _.routineOptions( infoStatus, arguments );

  o.info = null;
  o.hasLocalChanges = null;
  o.hasRemoteChanges = null;
  o.isRepository = null;

  if( !o.localPath && o.insidePath )
  o.localPath = _.git.localPathFromInside( o.insidePath );

  if( !o.localPath )
  return o;

  o.isRepository = true;

  if( !o.remotePath )
  o.remotePath = _.git.remotePathFromLocal( o.localPath );

  o.prs = _.git.prsGet({ remotePath : o.remotePath, throwing : 0, sync : 1 }) || [];

  debugger;
  if( o.checkingLocalChanges )
  o.hasLocalChanges = _.git.hasLocalChanges
  ({
    localPath : o.localPath,
    uncommitted : o.checkingUncommittedLocalChanges,
    unpushed : o.checkingUnpushedLocalChanges,
  });

  // if( o.checkingRemoteChanges )
  // o.hasRemoteChanges = _.git.hasRemoteChanges( o.localPath ); // xxx

  if( !o.prs.length && !o.hasLocalChanges && !o.hasRemoteChanges )
  return o;

  _.process.start
  ({
    execPath : 'git status',
    outputPiping : 0,
    inputMirroring : 0,
    currentPath : o.localPath,
    outputCollecting : 1,
    outputGraying : 1,
    mode : 'spawn',
    deasync : 1,
    sync : 0,
  })
  .then( ( op ) =>
  {
    o.info = '';
    if( o.prs && o.prs.length )
    o.info += `Has ${o.prs.length} opened pull requests\n`;
    o.info += op.output + '\n';
    return op;
  })
  .catchBrief();

  return o;
}

infoStatus.defaults =
{
  insidePath : null,
  localPath : null,
  remotePath : null,
  checkingLocalChanges : 1,
  checkingUncommittedLocalChanges : 1,
  checkingUnpushedLocalChanges : 1,
  checkingRemoteChanges : 1,
  checkingPrs : 1,
}

//

function hookRegister( o )
{
  let provider = _.fileProvider;
  let path = provider.path;

  _.assert( arguments.length === 1 );
  _.routineOptions( hookRegister, o );

  if( o.repoPath === null )
  o.repoPath = path.current();

  _.assert( _.strDefined( o.repoPath ) );

  try
  {
    check();
    hookLauncherMake();
    register();
    return true;
  }
  catch( err )
  {
    if( o.throwing )
    throw err;
    return null;
  }

  /* */

  function check()
  {
    if( !provider.fileExists( o.filePath ) )
    throw _.err( 'Source handler path doesn\'t exit:', o.filePath )

    if( !provider.fileExists( path.join( o.repoPath, '.git' ) ) )
    throw _.err( 'No git repository found at:', o.filePath );

    if( !_.arrayHas( KnownHooks, o.hookName ) )
    throw _.err( 'Unknown git hook:', o.hookName );

    let handlerNamePattern = new RegExp( `^${o.hookName}\\..*` );
    if( !handlerNamePattern.test( o.handlerName ) )
    throw _.err( 'Handler name:', o.handlerName, 'should match the pattern ', handlerNamePattern.toString() )

    if( !o.rewriting )
    if( provider.fileExists( path.join( o.repoPath, '.git/hooks', o.handlerName ) ) )
    throw _.err( 'Handler:', o.handlerName, 'for git hook:', o.hookName, 'is already registered. Enable option {-o.rewriting-} to rewrite existing handler.' );

    if( o.handlerName === o.hookName || o.handlerName === o.hookName + '.was' )
    throw _.err( 'Rewriting of original git hook script', o.handlerName, 'is not allowed.' );

  }

  /* */

  function hookLauncherMake()
  {
    let specialComment = 'This script is generated by utility willbe';

    let originalHandlerPath = path.join( o.repoPath, '.git/hooks', o.hookName );

    if( provider.fileExists( originalHandlerPath ) )
    {
      let read = provider.fileRead( originalHandlerPath );

      if( _.strHas( read, specialComment ) )
      return true

      let originalHandlerPathDst = originalHandlerPath + '.was';
      if( provider.fileExists( originalHandlerPathDst ) )
      throw _.err( 'Can\'t rename original git hook file:',originalHandlerPath, '. Path :', originalHandlerPathDst, 'already exists.'  );
      provider.fileRename( originalHandlerPathDst, originalHandlerPath );
    }

    _.assert( !provider.fileExists( originalHandlerPath ) );

    let hookLauncher = hookLauncherCode();

    provider.fileWrite( originalHandlerPath, hookLauncher );

    /* */

    function hookLauncherCode()
    {
      return `#!/bin/bash

      #${specialComment}
      #Based on
      #https://github.com/henrik/dotfiles/blob/master/git_template/hooks/pre-commit

      hook_dir=$(dirname $0)
      hook_name=$(basename $0)

      if [[ -d $hook_dir ]]; then
        stdin=$(cat /dev/stdin)

        if stat -t $hook_dir/$hook_name.* >/dev/null 2>&1; then
          for hook in $hook_dir/$hook_name.*; do
            echo "Running $hook hook"
            echo "$stdin" | $hook "$@"

            exit_code=$?

            if [ $exit_code != 0 ]; then
              exit $exit_code
            fi
          done
        fi
      fi

      exit 0
    `
    }
  }

  /* */

  function register()
  {
    let handlerPath = path.join( o.repoPath, '.git/hooks', o.handlerName );
    let sourceCode = provider.fileRead( o.filePath );
    provider.fileWrite( handlerPath, sourceCode );
  }
}

hookRegister.defaults =
{
  repoPath : null,
  filePath : null,
  handlerName : null,
  hookName : null,
  throwing : 1,
  rewriting : 0
}

//

function hookUnregister( o )
{
  let provider = _.fileProvider;
  let path = provider.path;

  _.assert( arguments.length === 1 );
  _.routineOptions( hookUnregister, o );

  if( o.repoPath === null )
  o.repoPath = path.current();

  _.assert( _.strDefined( o.repoPath ) );

  try
  {
    if( _.arrayHas( KnownHooks, o.handlerName ) )
    if( !o.force )
    throw _.err( 'Removal of original git hook handler is not allowed. Please enable option {-o.force-} to delete it.' )

    let handlerPath = path.join( o.repoPath, '.git/hooks', o.handlerName );

    if( !provider.fileExists( handlerPath ) )
    throw _.err( 'Git hook handler:', handlerPath, 'doesn\'t exist.' )

    provider.fileDelete
    ({
      filePath : handlerPath,
      sync : 1,
      throwing : 1
    });

    return true;
  }
  catch( err )
  {
    if( o.throwing )
    throw err;
    return null;
  }
}

hookUnregister.defaults =
{
  repoPath : null,
  handlerName : null,
  force : 0,
  throwing : 1
}

//

function hookPreservingHardLinksRegister( repoPath )
{
  let provider = _.fileProvider;
  let path = provider.path;

  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( repoPath ) );

  let toolsPath = path.resolve( __dirname, '../../../../Tools.s' );
  _.sure( provider.fileExists( toolsPath ) );
  toolsPath = path.nativize( toolsPath );

  let sourceCode = '#!/usr/bin/env node\n' +  restoreHardLinksCode();
  let tempPath = _.process.tempOpen({ sourceCode : sourceCode });
  try
  {
    _.git.hookRegister
    ({
      repoPath : repoPath,
      filePath : tempPath,
      handlerName : 'post-merge.restoreHardLinks',
      hookName : 'post-merge',
      throwing : 1,
      rewriting : 0
    })
  }
  catch( err )
  {
    throw err;
  }
  finally
  {
    _.process.tempClose({ filePath : tempPath });
  }

  return true;

  /* */

  function restoreHardLinksCode()
  {
    let sourceCode =
    `try
    {
      try
      {
        var _ = require( "${ _.strEscape( toolsPath) }" );
      }
      catch( err )
      {
        var _ = require( 'wTools' );
      }
      _.include( 'wFilesArchive' );
    }
    catch( err )
    {
      console.log( err, 'Git post pull hook fails to preserve hardlinks due missing dependency.' );
      return;
    }

    let provider = _.FileFilter.Archive();
    provider.archive.basePath = _.path.join( __dirname, '../..' );
    provider.archive.fileMapAutosaving = 0;
    provider.archive.filesUpdate();
    provider.archive.filesLinkSame({ consideringFileName : 0 });
    provider.finit();
    provider.archive.finit();
    `
    return sourceCode;
  }
}

//

function hookPreservingHardLinksUnregister( repoPath )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( repoPath ) );

  return _.git.hookUnregister
  ({
    repoPath : repoPath,
    handlerName : 'post-merge.restoreHardLinks',
    force : 0,
    throwing : 1
  })
}

// --
// relations
// --

var KnownHooks =
[
  "applypatch-msg",
  "pre-applypatch",
  "post-applypatch",
  "pre-commit",
  "prepare-commit-msg",
  "commit-msg",
  "post-commit",
  "pre-rebase",
  "post-checkout",
  "post-merge",
  "pre-push",
  "pre-receive",
  "update",
  "post-receive",
  "post-update",
  "pre-auto-gc",
  "post-rewrite",
]

// --
// declare
// --

let Extend =
{

  configRead,

  objectsParse,
  pathParse,
  pathIsFixated,
  pathFixate,
  remotePathNormalize,
  remotePathNativize,

  remotePathFromLocal,
  insideRepository,
  localPathFromInside,

  versionLocalChange,
  versionLocalRetrive,
  versionRemoteLatestRetrive,
  versionRemoteCurrentRetrive,

  isUpToDate,
  isDownloaded,
  isRepository,
  isDownloadedFromRemote,

  versionsRemoteRetrive,
  versionsPull,
  hasLocalChanges,
  hasRemoteChanges,
  hasChanges,

  prsGet,
  infoStatus,

  //

  hookRegister,
  hookUnregister,

  hookPreservingHardLinksRegister,
  hookPreservingHardLinksUnregister,

}

_.mapExtend( Self, Extend );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;

})();
