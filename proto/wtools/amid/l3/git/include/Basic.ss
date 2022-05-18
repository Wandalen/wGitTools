( function _Base_s_()
{

'use strict';

/* GitTools */

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../../node_modules/Tools' );

  _.include( 'wCopyable' );
  _.include( 'wIntrospectorExtra' );
  _.include( 'wProcess' );
  _.include( 'wFilesBasic' );
  _.include( 'wRemote' );
  _.include( 'wRepoBasic' );
  _.include( 'wGitPath' );
  _.include( 'wUnit' );

  module[ 'exports' ] = _global_.wTools;
}

})();
