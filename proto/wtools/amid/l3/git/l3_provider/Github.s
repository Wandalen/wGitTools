( function _Github_s_()
{

'use strict';

let Github;
const _ = _global_.wTools;
const Parent = _.repo;
_.repo.provider = _.repo.provider || Object.create( null );

// --
// implement
// --

function prsGetAct( o )
{
  _.map.assertHasAll( o, prsGetAct.defaults );
  _.assert( _.objectIs( o.remotePath ) );
  let ready = _.take( null );
  ready
  .then( () =>
  {
    if( !Github )
    Github = require( 'octonode' );
    let client = o.token ? Github.client( o.token ) : Github.client();
    _.debugger = 1;
    debugger;
    let r = client.repoAsync( `${o.remotePath.user}/${o.remotePath.repo}` );
    return r;
    // if( o.sync )
    // return client.repo( `${o.remotePath.user}/${o.remotePath.repo}` );
    // else
    // return client.repoAsync( `${o.remotePath.user}/${o.remotePath.repo}` );
  })
  .then( ( repo ) =>
  {
    debugger;
    if( o.sync )
    return repo.prs();
    else
    return repo.prsAsync();
  })
  .then( ( response ) =>
  {
    debugger;
    o.result = response[ 0 ].map( ( original ) =>
    {
      let r = Object.create( null );
      r.original = original;
      r.description = Object.create( null );
      r.description.head = original.title;
      r.description.body = original.body;
      r.to = Object.create( null );
      r.to.tag = original.base.ref;
      r.to.hash = original.base.sha;
      r.user = Object.create( null );
      r.user.name = original.head.user.login;
      r.id = original.number;
      return r;
    });
    return o;
  });
  return ready;
}

prsGetAct.defaults =
{
  ... Parent.prsGetAct.defaults,
}

// --
// declare
// --

const Self =
{
  name : 'github',
  names : [ 'github', 'github.com' ],
  prsGetAct,
}

_.repo.providerAmend({ src : Self });

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
