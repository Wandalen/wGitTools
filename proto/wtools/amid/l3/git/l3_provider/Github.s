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
    // debugger;
    let repo = client.repo( `${o.remotePath.user}/${o.remotePath.repo}` );
    // debugger;
    return repo.prsAsync();
  })
  .then( ( result ) =>
  {
    o.result = result[ 0 ]
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
