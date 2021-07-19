( function _Base_s_()
{

'use strict';

/* GitTools */

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../../node_modules/Tools' );

  _.include( 'wCopyable' );
  _.include( 'wProcess' );
  _.include( 'wFilesBasic' );

  module[ 'exports' ] = _global_.wTools;
}

})();
