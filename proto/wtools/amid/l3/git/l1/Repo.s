( function _Repo_s_()
{

'use strict';

const _ = _global_.wTools;
const Self = _.repo = _.repo || Object.create( null );
_.repo.provider = _.repo.provider || Object.create( null );

// --
//
// --

function providerForPath( o )
{
  _.routine.options( providerForPath, o );
  if( _.strIs( o.remotePath ) )
  o.remotePath = _.git.path.parse({ remotePath : o.remotePath, full : 0, atomic : 0, objects : 1 });
  let provider = _.repo.provider[ o.remotePath.service ];
  if( !provider )
  throw _.err( `No repo provider for service::${o.remotePath.service}` );
  return provider;
}

providerForPath.defaults =
{
  remotePath : null,
  throwing : 0,
}

//

function providerAmend( o )
{
  _.routine.options( providerAmend, o );
  _.assert( _.mapIs( o.src ) );
  _.assert( _.strIs( o.src.name ) || _.strsAreAll( o.src.names ) );

  if( !o.src.name )
  o.src.name = o.src.names[ 0 ];
  if( !o.src.names )
  o.src.names = [ o.src.name ];

  _.assert( _.strIs( o.src.name ) );
  _.assert( _.strsAreAll( o.src.names ) );

  let was;
  o.src.names.forEach( ( name ) =>
  {
    _.assert( _.repo.provider[ name ] === was || _.repo.provider[ name ] === undefined );
    was = was || _.repo.provider[ name ];
  });

  o.src.names.forEach( ( name ) =>
  {
    let dst = _.repo.provider[ name ];
    if( !dst )
    dst = _.repo.provider[ name ] = Object.create( null );
    let name2 = dst.name || o.src.name;
    _.mapExtend( dst, o.src );
    dst.name = name2;
  });

}

providerAmend.defaults =
{
  src : null,
}

//

let prsGetAct = Object.create( null );

prsGetAct.defaults =
{
  token : null,
  remotePath : null,
  sync : 1,
  withOpened : 1,
  withClosed : 0,
}

//

function prsGet( o )
{
  let ready = _.take( null );

  if( _.strIs( o ) )
  o = { remotePath : o }
  o = _.routineOptions( prsGet, o );
  o.logger = _.logger.from( o.logger );

  // let parsed = _.git.path.parse({ remotePath : o.remotePath, full : 0, atomic : 0, objects : 1 });

  if( _.strIs( o.remotePath ) )
  o.remotePath = _.git.path.parse({ remotePath : o.remotePath, full : 0, atomic : 0, objects : 1 });

  ready
  .then( () =>
  {
    // if( parsed.service === 'github.com' )
    // return prsOnGithub();
    let provider = _.repo.providerForPath({ remotePath : o.remotePath, throwing : o.throwing });
    if( provider && !_.routineIs( provider.prsGetAct ) )
    {
      if( o.throwing )
      throw _.err( `Repo provider ${provider.name} does not support routine prsGetAct` );
      return null;
    }
    return provider.prsGetAct( o );
  })
  .finally( ( err, op ) =>
  {
    if( !err && !op.result && o.throwing )
    err = _.err( 'Failed' );
    if( err )
    {
      if( o.throwing )
      throw _.err( err, '\nFailed to get list of pull requests' );
      _.errAttend( err );
      return null;
    }
    return o;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  // function prsOnGithub()
  // {
  //   let ready = _.take( null );
  //   ready
  //   .then( () =>
  //   {
  //     let github = require( 'octonode' );
  //     let client = o.token ? github.client( o.token ) : github.client();
  //     let repo = client.repo( `${parsed.user}/${parsed.repo}` );
  //     return repo.prsAsync();
  //   })
  //   .then( ( result ) =>
  //   {
  //     return result[ 0 ];
  //   });
  //   return ready;
  // }

}

prsGet.defaults =
{
  logger : 0,
  throwing : 1,
  ... prsGetAct.defaults,
}

//

function prOpen( o )
{
  let ready = _.take( null );
  let ready2 = new _.Consequence();

  if( _.strIs( o ) )
  o = { remotePath : o }
  o = _.routineOptions( prOpen, o );
  o.logger = _.logger.from( o.logger );

  if( !o.token && o.throwing )
  throw _.errBrief( 'Cannot autorize user without user token.' )

  // let parsed = this.objectsParse( o.remotePath );
  let parsed = _.git.path.parse({ remotePath : o.remotePath, full : 0, atomic : 0, objects : 1 });

  ready.then( () =>
  {
    if( parsed.service === 'github.com' )
    return prOpenOnGithub();
    if( o.throwing )
    throw _.err( 'Unknown service' );
    return null;
  })
  .finally( ( err, pr ) =>
  {
    if( err )
    {
      if( o.throwing )
      throw _.err( err, '\nFailed to open pull request' );
      _.errAttend( err );
      return null;
    }
    return pr;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  /* qqq : for Dmytro : move out to github provider */
  function prOpenOnGithub()
  {
    let ready = _.take( null );
    ready
    .then( () =>
    {
      let github = require( 'octonode' );
      let client = github.client( o.token );
      let repo = client.repo( `${parsed.user}/${parsed.repo}` );
      let o2 =
      {
        title : o.title,
        body : o.body,
        head : o.srcBranch,
        base : o.dstBranch,
      };
      repo.pr( o2, onRequest );

      /* */

      return ready2
      .then( ( args ) =>
      {
        if( args[ 0 ] )
        throw _.err( `Error code : ${ args[ 0 ].statusCode }. ${ args[ 0 ].message }` ); /* Dmytro : the structure of HTTP error is : message, statusCode, headers, body */
        if( o.logger && o.logger.verbosity >= 3 )
        o.logger.log( args[ 1 ] );
        else if( o.logger && o.logger.verbosity >= 1 )
        o.logger.log( `Succefully created pull request "${ o.title }" in ${ o.remotePath }.` )

        return args[ 1 ];
      });
    });
    return ready;
  }

  /* qqq : for Dmytro : ?? */
  function onRequest( err, body, headers )
  {
    return _.time.begin( 0, () => ready2.take([ err, body ]) );
  }

}

prOpen.defaults =
{
  throwing : 1,
  sync : 1,
  logger : 2,
  token : null,
  remotePath : null,
  title : null, /* qqq : for Dmytro : rename to descriptionHead */
  body : null, /* qqq : for Dmytro : rename to descriptionBody */
  srcBranch : null, /* qqq : for Dmytro : should get current by default */
  dstBranch : null, /* qqq : for Dmytro : should get current by default */
}

//

function vcsFor( o )
{
  if( !_.mapIs( o ) )
  o = { filePath : o }

  _.assert( arguments.length === 1 );
  _.routineOptions( vcsFor, o );

  if( _.arrayIs( o.filePath ) && o.filePath.length === 0 )
  return null;

  if( !o.filePath )
  return null;

  _.assert( _.strIs( o.filePath ) );
  _.assert( _.uri.isGlobal( o.filePath ) );

  let parsed = _.uri.parseFull( o.filePath );

  if( _.git && _.longHasAny( parsed.protocols, _.git.protocols ) )
  return _.git;
  if( _.npm && _.longHasAny( parsed.protocols, _.npm.protocols ) )
  return _.npm;

  return null;
}

vcsFor.defaults =
{
  filePath : null,
}

// --
// declare
// --

let Extension =
{

  providerForPath,
  providerAmend,

  prsGetAct,
  prsGet, /* qqq : for Dmytro : cover */
  // prOpenAct, /* qqq : for Dmytro : add */
  prOpen,

  vcsFor

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
