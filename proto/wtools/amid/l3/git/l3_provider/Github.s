( function _Github_s_()
{

'use strict';

let Github, Octokit;
const _ = _global_.wTools;
const Parent = _.repo;
_.repo.provider = _.repo.provider || Object.create( null );

// --
// implement
// --

function _open( o )
{
  _.map.assertHasAll( o, _open.defaults );
  _.assert( _.object.isBasic( o.remotePath ) );
  let ready = _.take( null );
  ready
  .then( () =>
  {
    if( !Octokit )
    Octokit = require( '@octokit/rest' ).Octokit;
    const octokit = new Octokit
    ({
      auth : o.token,
    });
    return octokit;
  })
  return ready;
}

_open.defaults =
{
  token : null,
}

//

function _responseNormalize()
{
  _.assert( 0, 'not implemented' );
}
_responseNormalize.defaults =
{
  requestCommand : null,
  options : null,
  fallingBack : 1,
  response : null,
  result : null,
}

//

function repositoryInitAct( o )
{
  const self = this;
  _.map.assertHasAll( o, repositoryInitAct.defaults );
  _.assert( _.aux.is( o.remotePath ) );

  return this._open( o )
  .then( ( octokit ) =>
  {
    return octokit.rest.repos.createForAuthenticatedUser
    ({
      name : o.remotePath.repo,
      description : o.description || '',
    });
  })
  .finally( ( err, arg ) =>
  {
    if( err )
    throw _.err( `Error code : ${ err.statusCode }. ${ err.message }` );
    return arg;
  });
}

repositoryInitAct.defaults =
{
  token : null,
  remotePath : null,
  description : null,
};

//

function repositoryDeleteAct( o )
{
  const self = this;
  _.map.assertHasAll( o, repositoryDeleteAct.defaults );
  _.assert( _.aux.is( o.remotePath ) );

  return this._open( o )
  .then( ( octokit ) =>
  {
    return octokit.rest.repos.delete
    ({
      owner : o.remotePath.user,
      repo : o.remotePath.repo,
    });
  });
}

repositoryDeleteAct.defaults =
{
  token : null,
  remotePath : null,
};

//

function repositoryIssuesGetAct( o )
{
  const self = this;
  _.map.assertHasAll( o, repositoryIssuesGetAct.defaults );
  _.assert( _.aux.is( o.remotePath ) );
  _.assert( _.long.leftIndex( [ 'open', 'closed', 'all' ], o.state ) !== -1 );

  o.token = null;

  return this._open( o )
  .then( ( octokit ) =>
  {
    let page = 1;
    let result = [];
    let issuesArray = [];
    do
    {
      issuesArray = issuesGetSync( octokit, page ).data;
      _.arrayAppendArray( result, issuesArray );
      page += 1;
    }
    while( issuesArray.length > 0 )

    result = result.filter( ( e ) => !e.pull_request );
    return result;
  });

  /* */

  function issuesGetSync( octokit, page )
  {
    let con = _.take( null );
    con.then( () =>
    {
      return octokit.rest.issues.listForRepo
      ({
        owner : o.remotePath.user,
        repo : o.remotePath.repo,
        state : o.state,
        per_page : 50,
        page,
      });
      return null;
    });
    con.deasync();
    return con.sync();
  }
}

repositoryIssuesGetAct.defaults =
{
  remotePath : null,
  state : null,
};

//

function repositoryIssuesCreateAct( o )
{
  const self = this;
  _.assert( _.aux.is( o.remotePath ) );
  _.assert( _.str.defined( o.token ) );
  _.assert( o.issues );

  o.issues = _.array.as( o.issues );

  return this._open( o )
  .then( ( octokit ) =>
  {
    let ready = _.take( null );
    for( let i = 0 ; i < o.issues.length ; i++ )
    ready.then( () => issueCreate( octokit, o.issues[ i ].title, o.issues[ i ].body || null ) );
    return ready;
  });

  /* */

  function issueCreate( octokit, title, body )
  {
    return octokit.rest.issues.create
    ({
      owner : o.remotePath.user,
      repo : o.remotePath.repo,
      title,
      body,
    });
  }
}

repositoryIssuesCreateAct.defaults =
{
  token : null,
  remotePath : null,
  issues : null,
};


//

function pullListAct( o )
{
  let self = this;
  let ready = _.take( null );
  _.map.assertHasAll( o, pullListAct.defaults );
  _.assert( _.object.isBasic( o.remotePath ) );

  return self._open( o )
  .then( ( octokit ) =>
  {
    return octokit.rest.pulls.list
    ({
      owner : o.remotePath.user,
      repo : o.remotePath.repo,
    })
  })
  .then( ( response ) =>
  {
    o.result = self._pullListResponseNormalize
    ({
      requestCommand : 'octokit.rest.pulls.list',
      options : o,
      response,
    })
    return o;
  });
}

pullListAct.defaults =
{
  ... Parent.pullListAct.defaults,
}

//

function _pullListResponseNormalize( o )
{
  let result = o.result = o.result || Object.create( null );
  let response = o.response;
  result.total = response.data.total_count;
  result.original = response;
  result.type = 'repo.pull.collection';
  result.elements = response.data.map( ( original ) =>
  {
    let r = Object.create( null );
    r.original = original;
    r.type = 'repo.pull';
    r.description = Object.create( null );
    r.description.head = original.title;
    r.description.body = original.body;
    r.to = Object.create( null );
    r.to.tag = original.base.ref;
    r.to.hash = original.base.sha;
    r.from = Object.create( null );
    r.from.name = original.head.user.login;
    r.id = original.number;
    return r;
  });
  return result;
}

_pullListResponseNormalize.defaults =
{
  ... _responseNormalize.defaults,
  requestCommand : 'octokit.rest.pulls.list',
}

//

function pullOpenAct( o )
{
  const self = this;
  _.map.assertHasAll( o, pullOpenAct.defaults );
  _.assert( _.aux.is( o.remotePath ) );

  return this._open( o )
  .then( ( octokit ) =>
  {
    return octokit.rest.pulls.create
    ({
      owner : o.remotePath.user,
      repo : o.remotePath.repo,
      title : o.descriptionHead || '',
      body : o.descriptionBody || '',
      head : o.srcBranch,
      base : o.dstBranch,
    });
  })
  .finally( ( err, arg ) =>
  {
    if( err )
    {
      _.errAttend( err );
      throw _.err( `Error code : ${ err.status }. ${ err.message }` );
    }

    if( o.logger && o.logger.verbosity >= 3 )
    o.logger.log( arg );
    else if( o.logger && o.logger.verbosity >= 1 )
    o.logger.log( `Succefully created pull request "${ o.descriptionHead }" in ${ _.git.path.str( o.remotePath ) }.` );

    return arg;
  });
}

pullOpenAct.defaults =
{
  ... Parent.pullOpenAct.defaults,
};

/* aaa for Dmytro : should use parent defaults */ /* Dmytro : parent defaults is used */

//

function releaseMakeAct( o )
{
  _.map.assertHasAll( o, releaseMakeAct.defaults );
  _.assert( _.aux.is( o.remotePath ) );
  _.assert( _.str.defined( o.remotePath.tag ), 'Expects tag to publish.' );

  return this._open( o )
  .then( ( octokit ) =>
  {
    return octokit.rest.repos.createRelease
    ({
      owner : o.remotePath.user,
      repo : o.remotePath.repo,
      tag_name : o.remotePath.tag,
      name : o.name || '',
      body : o.descriptionBody || '',
      draft : o.draft || false,
      prerelease : o.prerelease || false,
    });
  })
  .finally( ( err, arg ) =>
  {
    if( err )
    {
      _.errAttend( err );
      throw _.err( `Error code : ${ err.status }. ${ err.message }` );
    }

    if( o.logger && o.logger.verbosity >= 3 )
    o.logger.log( arg );
    else if( o.logger && o.logger.verbosity >= 1 )
    o.logger.log( `Succefully created release "${ o.remotePath.tag }" in ${ _.git.path.str( o.remotePath ) }.` );

    return arg;
  });
}

releaseMakeAct.defaults =
{
  ... Parent.releaseMakeAct.defaults,
};

//

function releaseDeleteAct( o )
{
  _.map.assertHasAll( o, releaseDeleteAct.defaults );
  _.assert( _.aux.is( o.remotePath ) );
  _.assert( _.str.defined( o.remotePath.tag ), 'Expects tag to publish.' );

  let octokit = null;

  return this._open( o )
  .then( ( instance ) =>
  {
    octokit = instance;
    return octokit.rest.repos.getReleaseByTag
    ({
      owner : o.remotePath.user,
      repo : o.remotePath.repo,
      tag : o.remotePath.tag,
    });
  })
  .then( ( response ) =>
  {
    return octokit.rest.repos.deleteRelease
    ({
      owner : o.remotePath.user,
      repo : o.remotePath.repo,
      release_id : response.data.id,
    });
  })
  .finally( ( err, arg ) =>
  {
    if( err )
    {
      _.errAttend( err );
      throw _.err( `Error code : ${ err.status }. ${ err.message }` );
    }

    if( o.logger && o.logger.verbosity >= 3 )
    o.logger.log( arg );
    else if( o.logger && o.logger.verbosity >= 1 )
    o.logger.log( `Succefully deleted release "${ o.remotePath.tag }" in ${ _.git.path.str( o.remotePath ) }.` );

    return arg;
  });
}

releaseDeleteAct.defaults =
{
  ... Parent.releaseDeleteAct.defaults,
};

//

function programListAct( o )
{
  let self = this;
  let ready = _.take( null );
  _.map.assertHasAll( o, programListAct.defaults );
  _.assert( _.object.isBasic( o.remotePath ) );
  return this._open( o )
  .then( ( octokit ) =>
  {
    return octokit.rest.actions.listRepoWorkflows
    ({
      owner : o.remotePath.user,
      repo : o.remotePath.repo,
      per_page : 100,
    });
  })
  .then( ( response ) =>
  {
    o.result = self._programListResponseNormalize
    ({
      requestCommand : 'octokit.rest.actions.listRepoWorkflows',
      options : o,
      response,
    });
    return o;
  });
}

programListAct.defaults =
{
  ... Parent.pullListAct.defaults,
}

//

function _programListResponseNormalize( o )
{
  let result = o.result = o.result || Object.create( null );
  let response = o.response;
  result.total = response.data.total_count;
  result.original = response;
  result.type = 'repo.program.collection';
  result.elements = response.data.workflows.map( ( original ) =>
  {
    let r = Object.create( null );
    r.original = original;
    r.type = 'repo.program';
    r.name = original.name;
    r.id = original.id;
    r.state = original.state;
    r.fileRelativePath = original.path;
    r.fileGlobalPath = original.html_url;
    r.service = 'github';
    return r;
  });
  return result;
}

_programListResponseNormalize.defaults =
{
  ... _responseNormalize.defaults,
  requestCommand : 'octokit.rest.actions.listRepoWorkflows',
}

// --
// declare
// --

const _responseNormalizersMap =
{

  'octokit.rest.pulls.list' : pullListAct,
  'octokit.rest.actions.listRepoWorkflows' : _programListResponseNormalize,

}

//

const Self =
{

  name : 'github',
  names : [ 'github', 'github.com' ],
  _responseNormalizersMap,

  //

  _open,
  _responseNormalize,

  repositoryInitAct,
  repositoryDeleteAct,

  repositoryIssuesGetAct,
  repositoryIssuesCreateAct,

  pullListAct,
  _pullListResponseNormalize,

  pullOpenAct,

  releaseMakeAct,
  releaseDeleteAct,

  programListAct,
  _programListResponseNormalize,

}

_.repo.providerAmend({ src : Self });

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
