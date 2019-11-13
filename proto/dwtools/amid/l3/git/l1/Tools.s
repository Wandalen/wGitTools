( function _Tools_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  require( '../IncludeBase.s' );
}

let _ = _global_.wTools;
let Self = _.git = _.git || Object.create( null );
let Ini = null;

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

  if( !Ini )
  Ini = require( 'ini' );

  let read = fileProvider.fileRead( path.join( filePath, '.git/config' ) );
  let config = Ini.parse( read );

  return config;
}

//

function objectsParse( remotePath )
{
  let result = Object.create( null );
  let gitHubRegexp = /\:\/\/\/github\.com\/(\w+)\/(\w+)(\.git)?/;

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

  // let isHardDrive = !_.longHasAny( parsed2.protocols, [ 'http', 'https', 'ssh' ] );
  let isHardDrive = _.longHasAny( parsed2.protocols, [ 'hd' ] );
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

//

function remotePathFromLocal( o )
{
  if( _.strIs( arguments[ 0 ] ) )
  o = { localPath : arguments[ 0 ] }
  o = _.routineOptions( remotePathFromLocal, o );
  let config = _.git.configRead( o.localPath );

  if( !config )
  {
    debugger;
    throw _.err( `No git repository at ${o.localPath}` );
  }

  if( !config[ 'remote "origin"' ] || !config[ 'remote "origin"' ].url )
  {
    debugger;
    return null;
  }

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

function insideRepository( o )
{
  return !!this.localPathFromInside( o );
}

var defaults = insideRepository.defaults = Object.create( null );
defaults.insidePath = null;

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

  let start = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    sync : 1,
    deasync : 0,
    outputCollecting : 1,
    currentPath : o.localPath
  });

  let result = start( 'git status' );
  let localChanges = _.strHas( result.output, 'Changes to be committed' );

  if( localChanges )
  start( 'git stash' )

  start( 'git checkout ' + o.version );

  if( localChanges )
  start( 'git pop' )

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

  if( !_.git.isRepository( o ) )
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
  let start = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    sync : 1,
    deasync : 0,
    outputCollecting : 1,
  });

  let got = start( 'git ls-remote ' + parsed.longerRemoteVcsPath );
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

  let start = _.process.starter
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

  start( 'git fetch origin' );

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
 * @function hasFiles
 * @memberof module:Tools/mid/GitTools.
 */

function hasFiles( o )
{
  let localProvider = _.fileProvider;

  _.routineOptions( hasFiles, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !localProvider.isDir( o.localPath  ) )
  return false;
  if( !localProvider.dirIsEmpty( o.localPath ) )
  return true;

  return false;
}

var defaults = hasFiles.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;

//

function isRepository( o )
{
  let path = _.uri;

  _.routineOptions( isRepository, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = _.Consequence.Try( () =>
  {
    if( o.localPath === null )
    return false;
    return _.fileProvider.fileExists( path.join( o.localPath, '.git/config' ) );
  })

  if( o.remotePath === null )
  return end();

  let remoteParsed = o.remotePath;

  ready.then( ( exists ) =>
  {
    if( !exists && o.localPath )
    return false;
    if( path.isGlobal( o.remotePath ) )
    remoteParsed = this.pathParse( o.remotePath ).remoteVcsPath;
    return remoteIsRepository( remoteParsed );
  })

  ready.then( ( isRepo ) =>
  {
    if( !isRepo || o.localPath === null )
    return isRepo;

    return localHasRightOrigin();
  })

  return end();

  /* */

  function remoteIsRepository()
  {
    let ready = _.Consequence.Try( () =>
    {
      return _.process.start
      ({
        execPath : 'git ls-remote ' + remoteParsed,
        throwingExitCode : 0,
        outputPiping : 0,
        stdio : 'ignore',
        sync : o.sync,
        deasync : 0,
        inputMirroring : 0,
        outputCollecting : 0
      });
    })
    ready.then( ( got ) =>
    {
      return got.exitCode === 0;
    });

    if( o.sync )
    return ready.syncMaybe();
    return ready;
  }

  /*  */

  function localHasRightOrigin()
  {
    let config = configRead( o.localPath );
    let originPath = config[ 'remote "origin"' ].url
    if( !path.isGlobal( originPath ) )
    originPath = path.normalize( originPath )
    return originPath === remoteParsed;
  }

  /*  */

  function end()
  {
    if( o.sync )
    return ready.syncMaybe();
    return ready;
  }
}

var defaults = isRepository.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.sync = 1;
defaults.verbosity = 0;

//

/**
 * @summary Returns true if path `o.localPath` contains a git repository that was cloned from remote `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {String} o.remotePath Remote path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function hasRemote
 * @memberof module:Tools/mid/GitTools.
 */

function hasRemote( o )
{
  let localProvider = _.fileProvider;
  let path = localProvider.path;

  _.routineOptions( hasRemote, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( _.strDefined( o.remotePath ) );

  let result = Object.create( null );
  result.downloaded = true;
  result.remoteIsValid = false;

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
  result.remoteIsValid = originVcsPath === remoteVcsPath;

  return result;
}

var defaults = hasRemote.defaults = Object.create( null );
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

/**
 * @summary Checks local repo for uncommitted, unpushed changes and conflicts.
 *
 * @description
 * Explanation for short format of 'git status': https://git-scm.com/docs/git-status#_short_format
 * Explanation for result of `uncommittedUnstaged`:
 * XY     Meaning
 * -------------------------------------------------
 * ММ     modified->staged->modified
 * MD     modified->staged->deleted
 * AM     added->staged->modified
 * AD     added->staged->deleted
 * RM     renamed->staged->modified
 * RD     renamed->staged->deleted
 * CM     copied->staged->modified
 * CD     copied->staged->deleted
 *
 * @param {Object} o Options map.
 * @param {String} o.localPath Path to local repo.
 * @param {Boolean} o.uncommitted=1 Checks for uncommitted changes. Enables all uncommitted* checks that are not disabled explicitly.
 * @param {Boolean} o.uncommittedUntracked=null Checks for untracked files
 * @param {Boolean} o.uncommittedAdded=null Checks for new files
 * @param {Boolean} o.uncommittedChanged=null Checks for modified files
 * @param {Boolean} o.uncommittedDeleted=null Checks for deleted files
 * @param {Boolean} o.uncommittedRenamed=null Checks for renamed files
 * @param {Boolean} o.uncommittedCopied=null Checks for copied files
 * @param {Boolean} o.uncommittedIgnored=0 Checks for new files that are ignored
 * @param {Boolean} o.uncommittedUnstaged=null Checks for unstaged changes
 * @param {Boolean} o.unpushed=1 Checks for unpsuhed changes. Enables all unpushed* checks that are not disabled explicitly.
 * @param {Boolean} o.unpushedCommits=null Checks for unpushed commit
 * @param {Boolean} o.unpushedTags=null Checks for unpushed tags
 * @param {Boolean} o.unpushedBranches=null Checks for unpushed branches
 * @param {Boolean} o.conflicts=1 Check for conflicts
 * @param {Boolean} o.detailing=0 Performs check of each enabled option if enabled, otherwise performs fast check.
 * @param {Boolean} o.explaining=0 Properties from result map will contain explanation if result of check is positive.
 * @function statusLocal
 * @memberof module:Tools/mid/GitTools.
 */

function statusLocal_pre( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( routine, o );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( args.length === 1 );

  if( o.uncommitted != null )
  _.each( routine.uncommittedGroup, ( k ) =>
  {
    if( o[ k ] === null )
    o[ k ] = o.uncommitted;
  })

  if( o.unpushed != null )
  _.each( routine.unpushedGroup, ( k ) =>
  {
    if( o[ k ] === null )
    o[ k ] = o.unpushed;
  })

  for( let k in o  )
  if( o[ k ] === null )
  o[ k ] = true;

  return o;
}

//

function statusLocal_body( o )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  let start = _.process.starter
  ({
    currentPath : o.localPath,
    mode : 'spawn',
    sync : 0,
    deasync : o.sync,
    throwingExitCode : 1,
    outputCollecting : 1,
    verbosity : o.verbosity - 1,
  });

  let result = resultPrepare();

  let optimizingCheck =  o.uncommittedUntracked && o.uncommittedAdded   &&
                         o.uncommittedChanged   && o.uncommittedDeleted &&
                         o.uncommittedRenamed   && o.uncommittedCopied  &&
                         !o.detailing;

  let ready = new _.Consequence().take( null );

  ready.then( uncommittedCheck );

  if( o.unpushedCommits )
  ready.then( unpushedCommitsCheck )

  if( o.unpushedTags )
  ready.then( checkTags )

  if( o.unpushedBranches )
  ready.then( checkBranches )

  ready.finally( end );

  if( o.sync )
  return ready.deasync();

  return ready;

  /* - */

  function end( err, got )
  {

    if( err )
    throw _.err( err, `\nFailed to check if repository ${_.color.strFormat( String( o.localPath ), 'path' )} has local changes` );

    statusMake();

    return result;
  }

  /* */

  function statusMake()
  {

    /*  */

    if( !optimizingCheck )
    {
      for( let i = 0; i < statusLocal_body.uncommittedGroup.length; i++ )
      {
        let k = statusLocal_body.uncommittedGroup[ i ];

        if( !_.strIs( result[ k ] ) )
        continue;

        if( result.uncommitted === null )
        result.uncommitted = [];

        if( !result[ k ] )
        continue;

        result.uncommitted.push( result[ k ] );
      }
      if( _.arrayIs( result.uncommitted ) )
      result.uncommitted = result.uncommitted.join( '\n' )
    }

    if( result.uncommitted )
    result.uncommitted = 'List of uncommited changes in files:\n' + '  ' + _.strIndentation( result.uncommitted, '  ' );

    /*  */

    for( let i = 0; i < statusLocal_body.unpushedGroup.length; i++ )
    {
      let k = statusLocal_body.unpushedGroup[ i ];

      if( !_.strIs( result[ k ] ) )
      continue;

      if( result.unpushed === null )
      result.unpushed = [];

      if( !result[ k ] )
      continue;

      if( k === 'unpushedCommits' )
      result.unpushed.push( 'List of branches with unpushed commits:' )
      else if( k === 'unpushedBranches' || k === 'unpushedTags' )
      _.arrayAppendOnce( result.unpushed, 'List of unpushed:' );

      result.unpushed.push( '  ' + _.strIndentation( result[ k ], '  ' ) );
    }
    if( _.arrayIs( result.unpushed ) )
    result.unpushed = result.unpushed.join( '\n' );

    /*  */

    result.status = result.uncommitted;

    if( _.strIs( result.unpushed ) )
    {
      if( !result.status )
      result.status = result.unpushed;
      else if( result.unpushed )
      result.status += '\n' + result.unpushed;
    }

    _.assert( _.strIs( result.status ) || result.status === null );

    /*  */

    if( optimizingCheck )
    {
      let uncommitted = !!result.uncommitted;

      _.each( statusLocal_body.uncommittedGroup, ( k ) =>
      {
        if( !o[ k ] )
        return;
        _.assert( result[ k ] === null )
        result[ k ] = uncommitted ? _.maybe : '';
      })

      if( uncommitted )
      {
        result.unpushed = _.maybe;
        _.each( statusLocal_body.unpushedGroup, ( k ) =>
        {
          if( !o[ k ] )
          return;
          _.assert( result[ k ] === null )
          result[ k ] = _.maybe;
        })
      }
    }

    for( let k in result )
    {
      if( _.strIs( result[ k ] ) )
      {
        if( !o.explaining )
        result[ k ] = !!result[ k ];
        else if( o.detailing && !result[ k ] )
        result[ k ] = false;
      }
    }
  }

  /* */

  function uncommittedCheck( got )
  {
    let gitStatusArgs = [ '-u', '--porcelain', '-b' ]
    if( o.uncommittedIgnored )
    gitStatusArgs.push( '--ignored' );

    return start({ execPath : 'git status', args : gitStatusArgs })
    .then( ( got ) =>
    {
      let output = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });

      /*
      check for any changes, except new commits/tags/branches
      */

      if( optimizingCheck )
      {
        return optimizedCheck( output );
      }
      else
      {
        return detailedCheck( output );
      }

    })
  }

  /* */

  function optimizedCheck( output )
  {
    result.uncommitted = '';

    if( output.length > 1 )
    result.uncommitted = output.join( '\n' );

    return result.uncommitted;
  }

  /* */

  function detailedCheck( output )
  {
    let outputStripped = output.join( '\n' );

    if( o.conflicts )
    if( uncommittedDetailedCheck( outputStripped, 'conflicts', /^D[DU]|A[AU]|U[DAU] .*/gm ) )
    return true;

    if( o.uncommittedUntracked )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedUntracked', /^\?{1,2} .*/gm ) )
    return true;

    if( o.uncommittedAdded )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedAdded', /^A .*/gm ) )
    return true;

    if( o.uncommittedChanged )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedChanged', /^M .*/gm ) )
    return true;

    if( o.uncommittedDeleted )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedDeleted', /^D .*/gm ) )
    return true;

    if( o.uncommittedRenamed )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedRenamed', /^R .*/gm ) )
    return true;

    if( o.uncommittedCopied )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedCopied', /^C .*/gm ) )
    return true;

    if( o.uncommittedIgnored )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedIgnored', /^!{1,2} .*/gm ) )
    return true;

    if( o.uncommittedUnstaged )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedUnstaged', /^[MARC][MD] .*/gm ) )
    return true;

    return false;
  }

  /* */

  function resultPrepare()
  {
    let result = Object.create( null );

    result.uncommitted = null;
    result.unpushed = null;

    _.each( statusLocal_body.uncommittedGroup, ( k ) => { result[ k ] = null } )
    _.each( statusLocal_body.unpushedGroup, ( k ) => { result[ k ] = null } )

    return result;
  }

  /* */

  function uncommittedDetailedCheck( output, check, regexp )
  {
    let match = output.match( regexp );

    result[ check ] = '';

    if( match )
    {
      match = _.strLinesStrip( match );
      result[ check ] = match.join( '\n' )
    }

    return result[ check ] && !o.detailing;
  }

  /* */

  function checkTags( got )
  {
    if( got && !o.detailing )
    return got;

    /* Nothing to check if there no tags*/

    let tagsDirPath = _.path.join( o.localPath, '.git/refs/tags' );
    let tags = _.fileProvider.dirRead({ filePath : tagsDirPath, throwing : 0 })
    if( !tags || !tags.length )
    {
      result.unpushedTags = '';
      return result.unpushedTags;
    }

    /* if origin is no defined include all tags to list, with "?" at right side */

    let config = configRead.call( this, o.localPath );
    if( !config[ 'remote "origin"' ] )
    {
      result.unpushedTags = '';

      if( tags && tags.length )
      {
        tags = tags.map( ( tag ) => `[new tag]   ${tag} -> ?` )
        result.unpushedTags += tags.join( '\n' )
      }

      return result.unpushedTags;
    }

    /* check tags */

    return start( 'git for-each-ref */tags/* --format=%(refname:short)' )
    .then( ( got ) =>
    {
      tags = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });
      _.assert( tags.length );
      return start
      ({
        execPath : 'git ls-remote --tags --refs',
        ready : null
      })
    })
    .then( ( got ) =>
    {
      debugger
      result.unpushedTags = '';
      let unpushedTags = [];
      _.each( tags, ( tag ) =>
      {
        if( !_.strHas( got.output, `refs/tags/${tag}` ) )
        unpushedTags.push( `[new tag]   ${tag} -> ${tag}` );
      })

      if( unpushedTags.length )
      result.unpushedTags += unpushedTags.join( '\n' );

      return result.unpushedTags;
    })
  }

  /* */

  function checkBranches( got )
  {
    if( got && !o.detailing )
    return got;

    let startOptions =
    {
      execPath : 'git branch',
      args :
      [
       '-vv',
       `--format={ "branch" : "%(refname:short)", "upstream" : "%(upstream)" }`
      ]
    };

    return start( startOptions )
    .then( ( got ) =>
    {
      let output = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });
      let branches = output.map( ( src ) => JSON.parse( src ) );
      let explanation = [];

      result.unpushedBranches = '';

      for( let i = 0; i < branches.length; i++ )
      {
        let record = branches[ i ];

        _.assert( _.strIs( record.upstream ) );

        if( record.upstream.length )
        continue;

        explanation.push( `[new branch]        ${record.branch} -> ?` );
      }

      if( explanation.length )
      result.unpushedBranches += explanation.join( '\n' );

      return result.unpushedBranches;
    })
  }

  /* - */

  function unpushedCommitsCheck( got )
  {
    if( got && !o.detailing )
    return got;

    return start( 'git branch -vv' )
    .then( ( got ) =>
    {

      let match = got.output.match( /^.*\[.*ahead .*\].*$/gm );
      result.unpushedCommits = '';
      if( match )
      {
        match = _.strLinesStrip( match );
        result.unpushedCommits = match.join( '\n' );
      }

      return result.unpushedCommits;
    })
  }
}

statusLocal_body.uncommittedGroup =
[
  'uncommittedUntracked',
  'uncommittedAdded',
  'uncommittedChanged',
  'uncommittedDeleted',
  'uncommittedRenamed',
  'uncommittedCopied',
  'uncommittedIgnored',
  'uncommittedUnstaged',
  'conflicts'
]

statusLocal_body.unpushedGroup =
[
  'unpushedCommits',
  'unpushedTags',
  'unpushedBranches',
]

var defaults = statusLocal_body.defaults = Object.create( null );

defaults.localPath = null;
defaults.sync = 1;
defaults.verbosity = 0;

defaults.uncommitted = null;
defaults.uncommittedUntracked = null;
defaults.uncommittedAdded = null;
defaults.uncommittedChanged = null;
defaults.uncommittedDeleted = null;
defaults.uncommittedRenamed = null;
defaults.uncommittedCopied = null;
defaults.uncommittedIgnored = 0;
defaults.uncommittedUnstaged = null;

defaults.unpushed = null;
defaults.unpushedCommits = null;
defaults.unpushedTags = null;
defaults.unpushedBranches = null;

defaults.conflicts = null;

defaults.detailing = 0;
defaults.explaining = 0;

let statusLocal = _.routineFromPreAndBody( statusLocal_pre, statusLocal_body );

//

/*
  additional check for branch
  git reflog --pretty=format:"%H, %D"
  if branch is not listed in `git branch` but exists in ouput of reflog, then branch was deleted
*/

function statusRemote_pre( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );

  for( let k in o  )
  if( o[ k ] === null )
  o[ k ] = true;

  return o;
}

//

function statusRemote_body( o )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = new _.Consequence();
  let start =  _.process.starter
  ({
    currentPath : o.localPath,
    mode : 'shell',
    sync : 0,
    deasync : o.sync,
    throwingExitCode : 0,
    outputCollecting : 1,
    outputPiping : 0,
    inputMirroring : 0,
    stdio : [ 'pipe', 'pipe', 'ignore' ],
    verbosity : o.verbosity - 1,
    ready : ready
  });

  let result =
  {
    remoteCommits : null,
    remoteBranches : null,
    remoteTags : null,
    status : null
  }

  if( !o.remoteCommits && !o.remoteBranches && !o.remoteTags )
  {
    ready.take( result );
    return end();
  }

  ready.take( null );

  let remotes,tags,heads,output;
  let status = [];

  start( 'git ls-remote' )
  ready.then( parse )
  start( 'git show-ref --heads --tags -d' )
  ready.then( ( got ) =>
  {
    output = got.output;
    return null;
  })

  if( o.remoteBranches )
  ready.then( branchesCheck )
  if( o.remoteCommits )
  ready.then( commitsCheck )
  if( o.remoteTags )
  ready.then( tagsCheck )

  ready.finally( ( err, got ) =>
  {
    if( err )
    throw _.err( err, '\nFailed to check if remote repository has changes' );
    statusMake();
    return result;
  })

  /*  */

  return end();

  /* - */

  function end()
  {
    if( o.sync )
    return ready.deasync();

    return ready;
  }

  /* */

  function parse( arg )
  {
    remotes = _.strSplitNonPreserving({ src : arg.output, delimeter : '\n' });
    remotes = remotes.map( ( src ) => _.strSplitNonPreserving({ src : src, delimeter : /\s+/ }) );
    remotes = remotes.slice( 1 );

    heads = remotes.filter( ( r ) => _.strBegins( r[ 1 ], 'refs/heads' ) );
    tags = remotes.filter( ( r ) => _.strBegins( r[ 1 ], 'refs/tags' ) );

    return null;
  }

  function branchesCheck( got )
  {
    result.remoteBranches = '';

    for( var h = 0; h < heads.length ; h++ )
    {
      let ref = heads[ h ][ 1 ];

      if( !_.strHas( output, ref ) )
      {
        if( result.remoteBranches )
        result.remoteBranches += '\n';
        result.remoteBranches += ref;
        _.arrayAppendOnce( status, 'List of unpulled remote branches:' )
        status.push( '  ' + ref );
      }
    }

    return result.remoteBranches
  }

  /*  */

  function commitsCheck( got )
  {
    result.remoteCommits = '';

    if( got && !o.detailing )
    {
      if( heads.length )
      result.remoteCommits = _.maybe;
      return got;
    }

    if( !heads.length )
    return result.remoteCommits;

    let con = new _.Consequence().take( null );

    _.each( heads, ( head ) =>
    {
      let hash = head[ 0 ];
      let ref = head[ 1 ];
      let execPath = `git branch --contains ${hash} --quiet --format=%(refname)`;

      if( !_.strHas( output, ref ) ) // skip if branch is not downloaded
      return;

      con.then( () =>
      {
        return start({ execPath, ready : null })
      })
      .then( ( got ) =>
      {
        if( !_.strHas( got.output, ref ) )
        {
          if( result.remoteCommits )
          result.remoteCommits += '\n';
          result.remoteCommits += ref;
          _.arrayAppendOnce( status, 'List of remote branches that have new commits:' )
          status.push( '  ' + ref );
        }
        return result.remoteCommits;
      })
    })

    return con;
  }

  /*  */

  function tagsCheck( got )
  {
    result.remoteTags = '';

    if( got && !o.detailing )
    {
      if( tags.length )
      result.remoteTags = _.maybe;
      return got;
    }

    for( var h = 0; h < tags.length ; h++ )
    {
      let tag = tags[ h ][ 1 ];

      if( !_.strHas( output, tag ) )
      {
        if( result.remoteTags )
        result.remoteTags += '\n';
        result.remoteTags += tag;
        _.arrayAppendOnce( status, 'List of unpulled remote tags:' )
        status.push( '  ' + tag );
      }
    }

    return result.remoteTags;
  }

  /*  */

  function statusMake()
  {
    result.status = status.join( '\n' );

    for( let k in result )
    if( _.strIs( result[ k ] ) )
    {
      if( !o.explaining )
      result[ k ] = !!result[ k ];
      else if( o.detailing && !result[ k ] )
      result[ k ] = false;
    }
  }

  /* */

}

var defaults = statusRemote_body.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;
defaults.remoteCommits = null;
defaults.remoteBranches = 0;
defaults.remoteTags = null;
defaults.detailing = 0;
defaults.explaining = 0;
defaults.sync = 1;

//

let statusRemote = _.routineFromPreAndBody( statusRemote_pre, statusRemote_body );

//

function status_pre( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );

  if( o.unpushed === null )
  o.unpushed = o.local;
  if( o.uncommitted === null )
  o.uncommitted = o.local;

  if( o.remoteCommits === null )
  o.remoteCommits = o.remote;
  if( o.remoteBranches === null )
  o.remoteBranches = o.remote;
  if( o.remoteTags === null )
  o.remoteTags = o.remote;

  return o;
}

//

function status_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  let localReady = null;
  let o2 = _.mapOnly( o, self.statusLocal.defaults );
  o2.sync = 0;
  localReady = self.statusLocal.call( this, o2 );

  let remoteReady = null;
  let o3 = _.mapOnly( o, self.statusRemote.defaults );
  o3.sync = 0;
  remoteReady = self.statusRemote.call( this, o3 );

  let ready = _.Consequence.AndKeep([ localReady, remoteReady ])
  .finally( ( err, arg ) =>
  {
    if( err )
    debugger;
    if( err )
    throw _.err( err );

    let result = _.mapExtend( null, arg[ 0 ] || {}, arg[ 1 ] || {} );

    if( arg[ 0 ] )
    {
      result.local = arg[ 0 ].status;
      if( arg[ 0 ].status !== null )
      result.status = arg[ 0 ].status;
    }


    if( arg[ 1 ] )
    {
      result.remote = arg[ 1 ].status;
      if( arg[ 1 ].status !== null )
      {
        if( !result.status )
        {
          result.status = arg[ 1 ].status;
          return result;
        }

        if( o.explaining && arg[ 1 ].status )
        result.status += '\n' + arg[ 1 ].status;
      }
    }


    return result;
  });

  if( o.sync )
  return ready.deasync();
  return ready;
}

_.routineExtend( status_body, statusLocal )
_.routineExtend( status_body, statusRemote )

var defaults = status_body.defaults;
defaults.localPath = null;
defaults.remote = 1;
defaults.local = 1;
defaults.detailing = 0;
defaults.explaining = 0;

let status = _.routineFromPreAndBody( status_pre, status_body );

//

/*
  qqq : extend and cover please
*/

function statusFull( o )
{
  let result = Object.create( null );

  o = _.routineOptions( statusFull, arguments );

  result.isRepository = null;
  if( o.prs )
  o.prs = [];

  if( !o.localPath && o.insidePath )
  o.localPath = _.git.localPathFromInside( o.insidePath );

  if( !o.localPath )
  return o;

  result.isRepository = true;

  _.assert( _.strIs( o.localPath ), 'Expects local path of inside path to deduce local path' );

  if( !o.remotePath )
  o.remotePath = _.git.remotePathFromLocal( o.localPath );

  let statusReady = new _.Consequence().take( null );
  if( o.remotePath )
  {
    let o2 = _.mapOnly( o, status.defaults );
    o2.sync = 0;
    statusReady = _.git.status( o2 )
  }

  let prsReady = new _.Consequence().take( null );
  if( o.prs )
  prsReady = _.git.prsGet({ remotePath : o.remotePath, throwing : 0, sync : 0 });

  let ready = _.Consequence.AndKeep([ statusReady, prsReady ])
  .finally( ( err, arg ) =>
  {
    if( err )
    throw _.err( err );
    let status = arg[ 0 ];
    let prs = arg[ 1 ];
    statusAdjust( status, prs );
    return result;
  });

  if( o.sync )
  return ready.deasync();
  return ready;

  /* */

  function statusAdjust( status, prs )
  {

    _.mapExtend( result, status );

    result.prs = prs;
    if( !result.prs )
    result.prs = o.prs ? _.maybe : null;

    if( prs && !prs.length && !result.result )
    {
      if( result.status === null )
      result.status = false;
      return result;
    }

    if( prs && prs.length )
    if( !o.explaining )
    {
      result.status = true;
    }
    else
    {
      let prsExplanation= `Has ${prs.length} opened pull requests`;

      if( !result.status )
      result.status = prsExplanation;
      else
      result.status += '\n' + prsExplanation;
    }

    return result;
  }

}

statusFull.defaults =
{
  insidePath : null,
  localPath : null,
  remotePath : null,
  local : 1,
  remote : 1,
  prs : 1,
  detailing : 1,
  explaining : 1,
  sync : 1,
}

_.mapSupplement( statusFull.defaults, status.defaults );


//

function hasLocalChanges()
{
  let self = this;
  let result = self.statusLocal.apply( this, arguments );

  _.assert( result.status !== undefined );

  if( _.boolIs( result.status ) )
  return result.status;
  if( _.strIs( result.status ) && result.length )
  return true;

  return false;
}

_.routineExtend( hasLocalChanges, statusLocal )

//

function hasRemoteChanges()
{
  let result = statusRemote.apply( this, arguments );

  _.assert( result.status !== undefined );

  if( _.boolIs( result.status ) )
  return result.status;
  if( _.strIs( result.status ) && result.length )
  return true;

  return false;
}

_.routineExtend( hasRemoteChanges, statusRemote )

//

function hasChanges()
{
  let result = status.apply( this, arguments );

  _.assert( result.status !== undefined );

  if( _.boolIs( result.status ) )
  return result.status;
  if( _.strDefined( result.status ) )
  return true;

  return false;
}

_.routineExtend( hasChanges, status )

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
    return prsOnGithub();
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

  function prsOnGithub()
  {
    let ready = new _.Consequence().take( null );
    ready
    .then( () =>
    {
      let github = require( 'octonode' );
      let client = github.client();
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

function repositoryInit( o )
{
  let self = this;
  let ready = new _.Consequence().take( null );

  o = _.routineOptions( repositoryInit, o );

  let nativeRemotePath = null;
  let parsed = null;
  let remoteExists = null;

  if( o.remotePath )
  {
    o.remotePath = self.remotePathNormalize( o.remotePath );
    nativeRemotePath = self.remotePathNativize( o.remotePath );
    parsed = self.objectsParse( o.remotePath );
    remoteExists = self.isRepository({ remotePath : o.remotePath, sync : 1 });
  }

  if( o.remote === null )
  o.remote = !!o.remotePath;
  if( o.local === null )
  o.local = !!o.localPath;

  let start = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    sync : 0,
    deasync : 0,
    outputCollecting : 1,
    mode : 'spawn',
    currentPath : o.localPath,
  });

  ready
  .then( () =>
  {
    if( !o.remote )
    return null;
    if( remoteExists )
    return null;
    return remoteInit();
  })
  .then( () =>
  {
    if( !o.local )
    return null;
    return localInit();
  })
  .finally( ( err, arg ) =>
  {
    if( err )
    if( !o.throwing )
    {
      _.errAttend( err );
      return null;
    }
    else
    {
      throw _.err( err, `\nFailed to init git repository remotePath:${_.color.strFormat( String( o.remotePath ), 'path' )}` );
    }
    return arg;
  });

  if( o.sync )
  return ready.deasync();

  return ready;

  /* */

  function repositoryInitOnGithub()
  {
    if( !o.token )
    {
      if( o.throwing )
      throw _.err( 'Requires an access token to create a repository on github.com' );
      return null;
    }
    let ready = new _.Consequence().take( null );
    ready
    .then( () =>
    {

      if( o.verbosity )
      logger.log( `Making remote repository ${_.color.strFormat( String( o.remotePath ), 'path' )}` );

      if( o.dry )
      return true;

      let github = require( 'octonode' );
      let client = github.client( o.token );
      let me = client.me();

      return me.repoAsync
      ({
        'name' : parsed.repo,
        'description' : o.description || '',
      });
    })
    .then( ( result ) =>
    {
      /* remoteExists = true; */
      return result[ 0 ] || null;
    });
    return ready;
  }

  /**/

  function remoteInit()
  {
    if( parsed.service === 'github.com' )
    return repositoryInitOnGithub();
    if( o.throwing )
    throw _.err( `Cant init remote repository, because not clear what service to use for ${_.color.strFormat( String( o.remotePath ), 'path' )}` );
    return null;
  }

  /**/

  function localInit()
  {
    _.assert( _.uri.is( o.localPath ) && !_.uri.isGlobal( o.localPath ), () => `Expects local path, but got ${_.color.strFormat( String( o.localPath ), 'path' )}` );

    o.localPath = _.path.canonize( o.localPath );

    if( _.fileProvider.fileExists( o.localPath ) && !_.fileProvider.isDir( o.localPath ) )
    throw _.err( `Cant clone repository to ${_.color.strFormat( String( o.localPath ), 'path' )}. It is occupied by non-directory.` );

    if( o.remotePath && remoteExists )
    {

      if( self.isRepository({ localPath : o.localPath }) )
      return localRepositoryRemoteAdd();
      else
      return localRepositoryClone();

    }
    else
    {

      if( self.isRepository({ localPath : o.localPath }) )
      return localRepositoryRemoteAdd();
      else
      return localRepositoryNew();

    }
  }

  /**/

  function localRepositoryNew()
  {
    if( o.verbosity )
    logger.log( `Making a new local repository at ${_.color.strFormat( String( o.localPath ), 'path' )}` );
    if( o.dry )
    return null;
    _.fileProvider.dirMake( o.localPath );
    start( `git init .` );
    return start( `git remote add origin ${nativeRemotePath}` );
  }

  /**/

  function localRepositoryRemoteAdd()
  {
    let wasRemotePath = _.git.remotePathFromLocal( o.localPath );
    if( wasRemotePath )
    {
      if( wasRemotePath !== o.remotePath )
      throw _.err( `Repository at ${o.localPath} already exists, but has different origin ${wasRemotePath}` );
      return null;
    }
    if( o.verbosity )
    logger.log( `Adding origin ${_.color.strFormat( String( o.remotePath ), 'path' )} to local repository ${_.color.strFormat( String( o.localPath ), 'path' )}` );
    if( o.dry )
    return null;
    // if( _.git.remotePathFromLocal( o.localPath ) )
    // start( `git remote rm origin` );
    return start( `git remote add origin ${nativeRemotePath}` );
  }

  /**/

  function localRepositoryClone()
  {

    if( o.verbosity )
    if( _.fileProvider.isDir( o.localPath ) )
    logger.log( `Directory ${_.color.strFormat( String( o.localPath ), 'path' )} will be moved` );

    if( o.verbosity )
    logger.log( `Cloning repository from ${_.color.strFormat( String( o.remotePath ), 'path' )} to ${_.color.strFormat( String( o.localPath ), 'path' )}` );

    if( o.dry )
    return null;

    let downloadPath = o.localPath;
    if( _.fileProvider.isDir( o.localPath ) )
    {
      downloadPath = _.path.join( o.localPath + '-' + _.idWithGuid() );
    }

    _.fileProvider.dirMake( downloadPath );

    let start = _.process.starter
    ({
      verbosity : o.verbosity - 1,
      sync : 0,
      deasync : 0,
      outputCollecting : 1,
      mode : 'spawn',
      currentPath : downloadPath,
    });

    return start( `git clone ${nativeRemotePath} .` )
    .finally( ( err, arg ) =>
    {
      if( err )
      {
        debugger;
        _.fileProvider.filesDelete( downloadPath );
        if( err )
        throw _.err( err );
      }
      try
      {
        let o2 =
        {
          dst : o.localPath,
          src : downloadPath,
          dstRewriting : 1,
          dstRewritingOnlyPreserving : 1,
          linking : 'hardLink',
        }
        _.fileProvider.filesReflect( o2 );
        debugger;
      }
      catch( err )
      {
        _.fileProvider.filesDelete( downloadPath );
        throw _.err( err, `\nCollision of local files with remote files at ${_.color.strFormat( String( o.localPath ), 'path' )}` );
      }
      _.fileProvider.filesDelete( downloadPath );
      return arg;
    });

  }

  /**/

}

repositoryInit.defaults =
{
  remotePath : null,
  localPath : null,
  remote : null,
  local : null,
  throwing : 1,
  sync : 1,
  verbosity : 0,
  dry : 0,
  description : null,
  token : null,
}

//

function repositoryDelete( o )
{
  let self = this;
  let ready = new _.Consequence().take( null );

  o = _.routineOptions( repositoryInit, o );

  let nativeRemotePath = null;
  let parsed = null;
  let remoteExists = null;

  if( o.remotePath )
  {
    o.remotePath = self.remotePathNormalize( o.remotePath );
    nativeRemotePath = self.remotePathNativize( o.remotePath );
    parsed = self.objectsParse( o.remotePath );
    remoteExists = self.isRepository({ remotePath : o.remotePath, sync : 1 });
  }

  if( !remoteExists )
  return false;

  ready
  .then( () =>
  {
    return remove();
  })
  .finally( ( err, arg ) =>
  {
    debugger;
    if( err )
    if( !o.throwing )
    {
      _.errAttend( err );
      return null;
    }
    else
    {
      throw _.err( err, `\nFailed to init git repository remotePath:${_.color.strFormat( String( o.remotePath ), 'path' )}` );
    }
    return arg;
  });

  if( o.sync )
  return ready.deasync();

  return ready;

  /* */

  function removeGithub()
  {
    if( !o.token )
    {
      if( o.throwing )
      throw _.err( 'Requires an access token to create a repository on github.com' );
      return null;
    }
    let ready = new _.Consequence().take( null );
    ready
    .then( () =>
    {

      if( o.verbosity )
      logger.log( `Removing remote repository ${_.color.strFormat( String( o.remotePath ), 'path' )}` );

      if( o.dry )
      return true;

      let github = require( 'octonode' );
      let client = github.client( o.token );
      let repo = client.repo( `${parsed.user}/${parsed.repo}` );
      return repo.destroyAsync();
    })
    .then( ( result ) =>
    {
      return result[ 0 ] || null;
    });
    return ready;
  }

  /**/

  function remove()
  {
    if( parsed.service === 'github.com' )
    return removeGithub();
    if( o.throwing )
    throw _.err( `Cant remove remote repository, because not clear what service to use for ${_.color.strFormat( String( o.remotePath ), 'path' )}` );
    return null;
  }

}

repositoryDelete.defaults =
{
  remotePath : null,
  throwing : 1,
  sync : 1,
  verbosity : 1,
  dry : 0,
  token : null,
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
    throw _.err( err );
    return null;
  }

  /* */

  function check()
  {

    if( !provider.fileExists( o.filePath ) )
    throw _.err( 'Source handler path doesn\'t exit:', o.filePath )

    if( !provider.fileExists( path.join( o.repoPath, '.git' ) ) )
    throw _.err( 'No git repository found at:', o.filePath );

    if( !_.longHas( KnownHooks, o.hookName ) )
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
    if( _.longHas( KnownHooks, o.handlerName ) )
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
    throw _.err( err );
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
    throw _.err( err );
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

//

function ignoreAdd( o )
{
  let provider = _.fileProvider;
  let path = provider.path;

  if( arguments.length === 2 )
  o = { insidePath : arguments[ 0 ], pathMap : arguments[ 1 ] }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routineOptions( ignoreAdd, o );

  if( !provider.isDir( o.insidePath ) )
  throw _.err( 'Provided {-o.insidePath-} is not a directory:', _.strQuote( o.insidePath ) );

  if( !this.insideRepository( o.insidePath ) )
  throw _.err( 'Provided {-o.insidePath-}:', _.strQuote( o.insidePath ), 'is not inside of a git repository.' );

  let gitignorePath = path.join( o.insidePath, '.gitignore' );
  let records = _.mapKeys( o.pathMap );

  let result = 0;

  if( !records.length )
  return result;

  let gitconfig = [];

  if( provider.fileExists( gitignorePath ) )
  {
    gitconfig = provider.fileRead( gitignorePath );
    gitconfig = _.strSplitNonPreserving({ src : gitconfig, delimeter : '\n' })
  }

  result = _.arrayAppendedArrayOnce( gitconfig, records );

  let data = gitconfig.join( '\n' );
  provider.fileWrite({ filePath : gitignorePath, data : data, writeMode : 'append' });

  return result;
}

var defaults = ignoreAdd.defaults = Object.create( null );
defaults.insidePath = null;
defaults.pathMap = null;

//

function ignoreRemove( o )
{
  let provider = _.fileProvider;
  let path = provider.path;

  if( arguments.length === 2 )
  o = { insidePath : arguments[ 0 ], pathMap : arguments[ 1 ] }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routineOptions( ignoreRemove, o );

  let gitignorePath = path.join( o.insidePath, '.gitignore' );

  if( !provider.fileExists( gitignorePath ) )
  throw _.err( 'Provided .gitignore file doesn`t exist at:', _.strQuote( gitignorePath ) );

  if( !this.isTerminal( o.insidePath ) )
  throw _.err( 'Provided .gitignore file:', _.strQuote( gitignorePath ),  'is not terminal' );

  let records = _.mapKeys( o.pathMap );

  if( !records.length )
  return false;

  let gitconfig = provider.fileRead( gitignorePath );
  gitconfig = _.strSplitNonPreserving({ src : gitconfig, delimeter : '\n' })

  let result = 0;

  if( !gitconfig.length )
  return result;

  result = _.arrayRemovedArrayOnce( gitconfig, records );

  let data = gitconfig.join( '\n' );
  provider.fileWrite({ filePath : gitignorePath, data : data, writeMode : 'rewrite' });

  return result;
}

_.routineExtend( ignoreRemove, ignoreAdd );

//

function ignoreRemoveAll( o )
{
  let provider = _.fileProvider;
  let path = provider.path;

  if( !_.objectIs( o ) )
  o = { insidePath : arguments[ 0 ] }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routineOptions( ignoreRemoveAll, o );

  let gitignorePath = path.join( o.insidePath, '.gitignore' );
  if( !provider.fileExists( gitignorePath ) )
  return false;
  provider.fileDelete( gitignorePath );
  return true;
}

var defaults = ignoreRemoveAll.defaults = Object.create( null );
defaults.insidePath = null;

// --
// relations
// --

var KnownHooks =
[
  'applypatch-msg',
  'pre-applypatch',
  'post-applypatch',
  'pre-commit',
  'prepare-commit-msg',
  'commit-msg',
  'post-commit',
  'pre-rebase',
  'post-checkout',
  'post-merge',
  'pre-push',
  'pre-receive',
  'update',
  'post-receive',
  'post-update',
  'pre-auto-gc',
  'post-rewrite',
]

// --
// declare
// --

let Extend =
{

  protocols : [ 'git' ],

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
  hasFiles,
  isRepository,
  hasRemote,

  versionsRemoteRetrive,
  versionsPull,

  statusLocal,
  statusRemote,
  status,
  statusFull,

  hasLocalChanges,
  hasRemoteChanges,
  hasChanges,

  prsGet,
  repositoryInit,
  repositoryDelete,

  //

  hookRegister,
  hookUnregister,

  hookPreservingHardLinksRegister,
  hookPreservingHardLinksUnregister,

  ignoreAdd,
  ignoreRemove,
  ignoreRemoveAll

}

_.mapExtend( Self, Extend );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;


})();
