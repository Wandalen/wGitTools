( function _Mid_s_()
{

'use strict';

/* GitTools */

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../../node_modules/Tools' );

  require( './Basic.ss' );
  require( '../l1/Git.ss' );
  require( '../l1/Path.ss' );
  require( '../l1/Repo.s' );
  require( '../l3_provider/Github.s' );

  module[ 'exports' ] = _global_.wTools;
}

})();

