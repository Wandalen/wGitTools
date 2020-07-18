( function _Base_s_( ) {

'use strict';

/* GitTools */

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../../wtools/Tools.s' );

  _.include( 'wCopyable' );
  _.include( 'wProcess' );
  _.include( 'wFiles' );

  module[ 'exports' ] = _global_.wTools;
}

})();
