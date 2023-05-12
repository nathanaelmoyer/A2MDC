/*
Parse PPO record
2/1/7

Registered Beans:
ptools - ParsingTools
xtools - XMLTOOLS
jxtools - JXMLTools
stools - SCRIPTTOOLS
message - TDMessage
results - ParseResults
query - TDQuery
content - String
STRUTIL - STRUTIL
Engine - TalonEngine
This - LEINMessageParser
*/


if (keepParsing) HandlePPOResponse();



/*
00227
A TEST 227 17 01/25/07 1621 CJDCTEST2.
MI3300254

LEIN PPO DATABASE RESPONSE
RE: 
PNO: 15928634 
FOR: HOFFMEYER/PPOTEST                       
OPR: HOFFMEYER      


NAM:TEST/BOBBY/BEE/                 DOB:07/07/1970
RAC:UNKNOWN  SEX:MALE  
      

PERSONAL PROTECTION ORDER SERVED.

PROHIBITED FROM PURCHASING A PISTOL OR 
OBTAINING A LICENSE TO CARRY A PISTOL CONCEALED.

INJUNCTIVE ORDER
"STALKING PERSONAL PROTECTION ORDER" ISSUED PURSUANT TO ACT 404, P.A.
1994.
DO NOT ARREST UNLESS A VIOLATION OF INJUNCTIVE ORDER HAS BEEN VERIFIED
CONTACT ORI FOR SPECIFIC CONTENT OF ORDER (MCL 600.2950a).

INJUNCTIVE ORDER EXP - 01/30/2007
PROTECTED PERSON:TEST/MARY/EMM/
OCA:PPOTEST1  DOW:01/25/2007
COURTORI:MI338895J-CT  CJIC TEST             
PICKUP: WILL NOT
REMARKS:TEST RECORD


CONDITIONS:
1  - This order is entered WITHOUT a hearing.
2  - A petition requesting an order to restrain conduct prohibited
under MCL
     750.311h and 450.311i has been filed under the authority of MCL
     600.2950a. 
3  - Petitioner requested an ex parte order which should be entered
without
     notice because irreparable injury, loss, or damage will result
from delay
     required to give notice or notice itself will precipitate adverse
action
     before an order can be issued. 
4  - Respondent committed the following acts of willful, unconsented
contact:
     (state reasons for issuance) MAKING FUNNY FACES AT COMPLAINTANT
5  - RESPONDENT is prohibited from stalking as defined under MCL
750.411h and
     MCL 750.411i which includes but is not limited to:
  5A - Following or appearing within sight of the petitioner. 
  5B - Appearing at workplace/residence of the petitioner. 
  5C - Approaching or confronting the petitioner in a public place or
on
       private property. 
  5D - Entering onto or remaining on property owned, leased, or
occupied by the
       petitioner. 
  5E - Sending mail/other communications to the petitioner. 
  5F - Contacting the petitioner by phone. 
  5G - Placing an object on or delivering an object to property owned,
leased,
       or occupied by the petitioner. 
  5H - Threatening to kill or physically injure the petitioner. 
  5I - Purchasing or possessing a firearm. 
  5J - Other: EATING ICE CREAM NEAR COMPLAINTANT
6  - Violation of this order subjects the respondent to immediate
arrest and to
     the civil and criminal contempt powers of the court.  If found
guilty,
     respondent shall be imprisoned for not more than 93 days and may
be fined
     not more than $500.00 
7  - This order is effective when signed, enforceable immediately, and
remains
     in effect until 01/30/2007.   This order is enforceable anywhere
in this
     state by any law enforcement agency when signed by a judge, and
upon
     service, may also be enforced by another state, an Indian tribe,
or a
     territory of the United States.  If respondent violates this order
in a
     jurisdiction other than this state, respondent is subject to
enforcement
     and penalties of the state, Indian tribe, or United States
territory
     under whose jurisdiction the violation occurred.
8  - The court shall file this order with MI3300254 who will enter it
into the
     LEIN.
9  - Respondent may file a motion to modify or terminate this order. 
For ex
     parte orders, the motion must be filed within 14 days after being
served
     with or receiving actual notice of the order.   Forms and
instructions
     are available from the clerk of court. 
10 - A motion to extend the order must be filled 3 days before the
expiration
     date in item 10 or else a new petition must be filed. 
11 - Other: BOWLING FOR CHEESY SOUP

ENTERED LEIN:01/25/2007  1615  HRS
SYSIDNO:15928634
    CONFIRM SPECIFIC CONTENT OF ORDER WITH MI3300254-DC  TECHNICAL
SERVICES 4


END LEIN PPO MESSAGE
*/
function HandlePPOResponse()
{
	var line = ptools.ExtractWholeLine(content, "PERSONAL PROTECTION ORDER SERVED", true );
	if ( line != null )
	{
		description = line;
		keepParsing = false;
	}
  
}










