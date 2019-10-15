( function _IncludeMid_s_( ) {

'use strict';

/**
 * Collection of tools to use git programmatically.
  @module Tools/mid/GitTools
*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../Tools.s' );

  require( './IncludeBase.s' );

  require( './l1/Helper.s' );
  require( './l3/Hooker.s' );

  _.include( 'wFiles' );
}

})();
