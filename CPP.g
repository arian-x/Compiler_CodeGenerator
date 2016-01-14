grammar CPP;



@members{
	int temp=0;
	int label=0;
	List vals;
	
}





mainProgram 	: (statement)+  ;
		

// Variable Declaration
	
variableDeclaration  :  {String result;}
			type 			  {result="type " + $type.T + ", ";}
			var1=varDeclarator   	  {result= result + "variables= " + $var1.id ;}
			(',' var2=varDeclarator   {result= result + ", " +$var2.id;}
			)* ';'
			
			{System.out.println(result);}
			
			;

varDeclarator returns [String value,String id] :   ID init  	{$value=$ID.text + $init.value;
								$id=$ID.text;};

init returns [String value]	: '=' expression 	{$value=" = " + "t" + temp; }
				|			{$value= " [null] ";}
				;


type returns [String T]:  t1= 'char' 	{$T=$t1.text;}
			| t2= 'int'  	{$T=$t2.text;} 
			;
			
ass_st	: ID '=' ex=expression ';'         {
					    System.out.println($ID.text + '=' + "t" + temp);
					    };


expression  returns [String val]: {String value;}   
				v1=primary	  {
						   value=$v1.val;
						   $val=$v1.id;
						   
						   }
						   
	      			(op v2=primary    {
	      					   
	      					   value=value + $op.val + $v2.val;
	      					   $val=$val + $op.val + $v2.id;  
	      					   temp+=1;  
	      					   System.out.println("t" + temp + '=' + value); 	
	      					   value = "t" + temp;})* ;

	
// STATEMENTS

statement : if_st 
	|   ass_st 
	|   variableDeclaration
	|   iteration 
	|   switchSt
	;


/////////////// IF_st ///////////////////////

if_st :  'if' '(' condition ')'   	  {int Lelse = label +=1;
					  
					  System.out.println("if not " +$condition.val + " goto " + "L" + Lelse);
					  }
	   
	   '{' block '}'		  {int Lend = label +=1;
	   				  System.out.println("goto " + "L" + Lend);
	   				   
	   			          System.out.println("L"+Lelse+": ");
	   			          }
		
		
	    ('else' '{' block '}')? 	  {System.out.println("L"+Lend+": ");
	    				   }
	    ; 



block 	:	 statement*  ;

	
condOperator returns [String val]: co1= '<='	{$val=$co1.text;}	 
				| co2= '>='	{$val=$co2.text;}
				| co3= '>' 	{$val=$co3.text;}
				| co4= '<'	{$val=$co4.text;}
				| co5= '==' 	{$val=$co5.text;}
				| co6= '!='	{$val=$co6.text;} 
				;
	
op returns [String val]	:  op1='+' 	{$val=$op1.text;}
			 | op2='-' 	{$val=$op2.text;}	
			 | op3='/' 	{$val=$op3.text;}
			 | op4='*' 	{$val=$op4.text;}
			 ;	


condition returns [String val]: { String item;}
				ex1=expression 	   {item="t" + temp;}
						  
				condOperator    {item = item + $condOperator.val;}
				ex2=expression 	   {
						    item = item + "t" + temp;
						    $val=item;
						    }
				;
		

	
primary returns [String val,String id]:   ID  {
						temp +=1; $val="t"+temp; 
						$id=$ID.text;
						System.out.println("t" + temp +'=' + $ID.text);
						}
					
			  		| Number     {temp +=1; $val="t"+temp;
			  				       
			  			$id=$Number.text;
						System.out.println("t" + temp +'=' + $Number.text);
						}
					
			  | String     {temp +=1; $val="t"+temp;
			  		$id=$String.text; 
					System.out.println("t" + temp +'=' + $String.text);
					}
			  
			  ;
//////////////////// Iteration & SwitchSt

statement_list:   statement+ ;

forLoopVarAssignment	: ID '=' ex=expression        {
					    System.out.println($ID.text + '=' + "t" + temp);
					    };

iteration: 
	{  int Lstart = label +=1; System.out.println("L"+Lstart+": ");  }

	'while' '(' condition ')'  
	{
		int Lend = label +=1;
		System.out.println("if not " + $condition.val + " goto " + "L"+Lend);
	}

	'{' block '}'
	{
		System.out.println("goto " + "L"+ Lstart);
		System.out.println("L" + Lend + ":");
	}
		|  'for' '(' forLoopVarAssignment? 
			{
				int Lstart = label +=1; System.out.println("L"+Lstart+": ");
			} 
		';' condition? ';'
		{
			int Lend = label +=1; 
			System.out.println("if not "  + $condition.val + " goto " + "L"+ Lend); 
			int Lthen = label +=1;  
			System.out.println("goto " + "L"+ Lthen); 
			int Linc = label +=1;  
			System.out.println("L"+Linc+": ");
		} 
		 forLoopVarAssignment?
		 {
		 	System.out.println("goto " + "L"+ Lstart);        
		 	System.out.println("L"+Lthen+": ");
		 } 
		  ')' '{' block '}' 
		   {
		   System.out.println("goto " + "L"+ Linc);
		   System.out.println("L" + Lend + ":");
		   };


expValue returns [String val]: ID 
				{
				temp+=1;
				$val="t"+temp;
				System.out.println("t"+temp+ "=" + $ID.text);
				}
				| Number
				{
				temp+=1;
				$val="t"+temp;
				System.out.println("t"+temp+ "=" + $Number.text);
				};

‫‪

switchSt scope {int startLabel; int endLabel; String caseVal}:
		 {	
		    $switchSt::startLabel = label +=1; 
		  	System.out.println("L" + $switchSt::startLabel + ":");
		 }

		  'switch' '(' expValue ')' 
		 {
		   $switchSt::caseVal = $expValue.val; 
		   $switchSt::endLabel = label+=1;
		 }

		  '{' caseSt*  caseDefault?'}'
		 {
		  System.out.println("L" + $switchSt::endLabel + ":");
		 };

caseSt: 'case' caseLabels ':' 
		{ 
  		int Lnext = label+=1; 
 		System.out.println("if not " + $switchSt::caseVal + '=' + $caseLabels.val + " goto " + "L" + Lnext);
  		} 
statement_list jump? 
		{  
		Lnext = label; System.out.println("L" + Lnext + ':');
		}; 



caseLabels returns [String val]: v1=expValue (',' v2=expValue)* { $val = $v1.val; } ; 

caseDefault: 'default' ':' statement_list ;

jump : 'break'  ';' {
					System.out.println("goto " + "L" + $switchSt::endLabel );
					}
      | 'continue' ';' {
      				System.out.println("goto " + "L" +           $switchSt::startLabel );
      				} ;



///////////////////////
 	  
			  
// LEXER

BREAK         : 'break';
CHAR          : 'char';
ELSE          : 'else';
FLOAT         : 'float';
FOR           : 'for';
IF            : 'if';
INT           : 'int';
RETURN        : 'return';
VOID          : 'void';
WHILE         : 'while';

WS  :   ( ' '
        | '\t'
        | '\r'
        | '\n'
        ) {$channel=HIDDEN;}
    ;

	
// §3.10.7 The Null Literal

NullLiteral :   'null' ;
	

// §3.11 Separators

LPAREN          : '(';
RPAREN          : ')';
LBRACE          : '{';
RBRACE          : '}';
LBRACK          : '[';
RBRACK          : ']';
SEMI            : ';';
COMMA           : ',';
DOT             : '.';

// §3.12 Operators

ASSIGN          : '=';
GT              : '>';
LT              : '<';
EQUAL           : '==';
LE              : '<=';
GE              : '>=';
NOTEQUAL        : '!=';
INC             : '++';
DEC             : '--';
ADD             : '+';
SUB             : '-';
MUL             : '*';
DIV             : '/';


ID : ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')* ;
 
Number	:	//Num;
		'0'..'9'+ ;
		
String	:	//Str;
		'"' ~('\r' | '\n' | '"')* '"';
    	
//fragment
//Num  : '0'..'9'+ ;

//Str :	'"' ~('\r' | '\n' | '"')* '"';


 

