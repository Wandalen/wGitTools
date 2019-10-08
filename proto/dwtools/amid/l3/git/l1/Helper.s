( function _Helper_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../IncludeBase.s' );

}

let _ = wTools;
let Self = _.git = _.git || Object.create( null );

// --
// inter
// --

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

function hasLocalChanges( o )
{
  let provider = _.fileProvider;
  let path = provider.path;

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( hasLocalChanges, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );

  let ready = _.Consequence.Try( () =>
  {
    return _.process.start
    ({
      execPath : 'git status -u --porcelain -b',
      currentPath : o.localPath,
      mode : 'spawn',
      sync : o.sync,
      deasync : 0,
      throwingExitCode : 1,
      outputCollecting : 1,
      outputPiping :1,
      verbosity : 1,
    });
  })

  ready.finally( ( err, got ) =>
  {
    if( err )
    throw _.err( err, '\nFailed to check if repository has local changes' );

    let output = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });

    if( output.length > 1 ) // check for any changes, except new commits
    return true;

    if( _.strHas( output[ 0 ], /\[ahead.*\]/ ) )// check for unpushed commits
    return true;

    return false;
  })

  if( o.sync )
  return ready.syncMaybe();

  return ready;
}

var defaults = hasLocalChanges.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;
defaults.sync = 1;

//

function hasLocalChangesComplex( o )
{
  let provider = _.fileProvider;
  let path = provider.path;

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( hasLocalChangesComplex, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );

  let ready = _.Consequence.Try( () =>
  {
    if( !provider.fileExists( path.join( o.localPath, '.git' ) ) )
    throw _.err( 'Found no GIT repository at:', o.localPath );

    let commands =
    [
      'git diff HEAD --quiet',
      'git rev-list origin..HEAD --count',
      'git status -sz'
    ]

    return _.process.start
    ({
      execPath : commands,
      currentPath : o.localPath,
      mode : 'spawn',
      sync : 0,
      deasync : 0,
      throwingExitCode : 0,
      outputCollecting : 1,
      verbosity : o.verbosity - 1,
    });
  })

  ready.then( ( got ) =>
  {
    if( got[ 0 ].exitCode === 1 /* diff */ )
    return true;
    if( _.numberFrom( got[ 1 ].output ) /* commits ahead */ )
    return true;
    if( _.strHas( got[ 2 ].output, '?' ) /* untracked files */ )
    return true;

    if( got[ 1 ].exitCode )
    throw _.err( infoGet( got[ 1 ] ) );
    if( got[ 2 ].exitCode )
    throw _.err( infoGet( got[ 2 ] ) );

    return false;

    // let localChanges = _.strHasAny( got.output, [ 'Changes to be committed', 'Changes not staged for commit' ] );
    // if( !localChanges )
    // localChanges = !_.strHasAny( got.output, [ 'nothing to commit', 'working tree clean' ] )
    // let localCommits = _.strHasAny( got.output, [ 'branch is ahead', 'have diverged' ] );
    // return localChanges || localCommits;
  })

  ready.catch( ( err ) =>
  {
    throw _.err( err, '\nFailed to check if repository has local changes' );
  })

  if( o.sync )
  return ready.deasync();

  return ready;

  /* */

  function infoGet( o )
  {
    let result = '';
    result += 'Process returned exit code' + o.exitCode + '\n';
    result += 'Launched as ' + _.strQuote( o.fullExecPath ) + '\n';
    result += 'Launched at ' + _.strQuote( o.currentPath ) + '\n';
    result += '\n -> Output' + '\n' + ' -  ' + _.strIndentation( stderrOutput, ' -  ' ) + '\n -< Output';
    return result;
  }
}

var defaults = hasLocalChangesComplex.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;
defaults.sync = 1;

//

function hookRegister( o )
{
  let self  = this;
  let provider = _.fileProvider;
  let path = provider.path;

  _.assert( arguments.length === 1 );
  _.routineOptions( hookRegister, o );

  if( o.repoPath === null )
  o.repoPath = path.current();

  _.assert( _.strDefined( o.repoPath ) );

  var specialComment = 'This script is generated by utility willbe';

  try
  {
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

  function register()
  {
    if( !provider.fileExists( o.filePath ) )
    throw _.err( 'Source handler path doesn\'t exit:', o.filePath )

    if( !_.arrayHas( KnownHooks, o.hookName ) )
    throw _.err( 'Unknown git hook:', o.hookName );

    let handlerNamePattern = new RegExp( `${o.hookName}.*` );

    if( !handlerNamePattern.test( o.handlerName ) )
    throw _.err( 'Handler name:', o.handlerName, 'should match the pattern ', handlerNamePattern.toString() )

    if( o.handlerName === o.hookName || o.handlerName === o.hookName + '.was' )
    throw _.err( 'Rewriting of original git hook script', o.handlerName, 'is not allowed.' );

    let handlerPath = path.join( o.repoPath, '.git/hooks', o.handlerName );

    if( !o.rewriting )
    if( provider.fileExists( handlerPath ) )
    if( !provider.filesAreSame( o.filePath, handlerPath ) )
    throw _.err( 'Handler:', o.handlerName, 'for git hook:', o.hookName, 'is already registered. Enable option {-o.rewriting-} to rewrite existing handler.' );

    let sourceCode = provider.fileRead( o.filePath );
    provider.fileWrite( handlerPath, sourceCode );

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

    let hookLauncher = hookLauncherMake();

    provider.fileWrite( originalHandlerPath, hookLauncher );
  }

  /*  */

  function hookLauncherMake()
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
  let self  = this;
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
  versionsRemoteRetrive,
  versionsPull,
  hasLocalChanges,
  hasLocalChangesComplex,

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
