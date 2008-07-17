<cfcomponent displayname="ConversationState" extends="target.StateMachine" output="false">
	<cfset instance = structNew() />
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="conversation" type="target.test.Conversation" required="true" />		
		<cfset super.init(arguments.conversation, 'needingAttention', 'MyState') />
		<cfreturn this />
	</cffunction>
		
	<cffunction name="configure" access="private" returntype="void" output="false">
		<cfscript>
			var tmp = '';
						
			addState('needingAttention');	
			addState('read');
			addState('closed');
			addState('awaitingResponse');
			addState('junk');

			addEvent('newMessage').addTransitions('read,closed,awaitingResponse', 'needingAttention');
			//dump(getTransitionTable(), true);
			addEvent('view').addTransitions('needingAttention,read', 'read');
			addEvent('reply').addTransitions('read,closed', 'awaitingResponse');
			addEvent('close').addTransitions('read,awaitingResponse', 'closed', 'getCanClose').addTransitions('read,awaitingResponse', 'read', 'alwaysTrue');
			addEvent('junk').addTransitions('read,closed,awaitingResponse', 'junk');
			addEvent('unjunk').addTransitions('junk', 'closed');
		</cfscript>
	</cffunction>
	
	<!--- Observer Events --->
	
	<cffunction name="readEnteringAction" access="public" returntype="void" output="false">
		<cfset getOriginalObject().setReadEnter(true) />
	</cffunction>

	<cffunction name="needingAttentionEnteringAction" access="public" returntype="void" output="false">
		<cfset getOriginalObject().needingAttentionEnter(true) />
	</cffunction>
	
	<cffunction name="needingAttentionAfterAction" access="public" returntype="void" output="false">
		<cfset getOriginalObject().needingAttentionAfter(true) />
	</cffunction>

</cfcomponent>