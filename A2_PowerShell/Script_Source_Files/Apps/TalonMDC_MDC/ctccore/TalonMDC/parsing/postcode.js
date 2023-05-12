/*
Helper functions to be included with other scripts.
*/


/*Closing code*/

if ( ! keepParsing )
{
	results.StopParsing();
	//This.DebugTrace( "Signaled stop parsing" );
}

AddParsedItemsToMessage();
//This.DebugTrace( "Script complete" );


function AddParsedItemsToMessage()
{
	var parsedCount = parsedItems.size();
	if ( parsedCount > 0 )
	{
		for( var i=0; i < parsedCount; i++ )
		{
			var xml = parsedItems.get(i).toJXML();			
			message.AddParsedXML( xml );
		}
	}
	
	//This.DebugTrace( "Added " + parsedCount + " parsed item(s) to message." );
}




