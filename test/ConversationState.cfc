<cfcomponent displayname="ConversationState" extends="target.StateMachine" output="false">
	<cfset instance = structNew() />
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="conversation" type="target.test.Conversation" required="true" />		
		<cfset super.init(arguments.conversation, 'needsAttention', 'MyState') />
		<cfreturn this />
	</cffunction>
		
	<cffunction name="configure" access="private" returntype="void" output="false">
		<cfscript>
			var tmp = '';
			var o = 
			
			
			addState('needsAttention').setEnterCallback('needsAttentionEnter(true)').setAfterCallback('needsAttentionAfter(true)');			
			addState('read'); //.setEnterCallback('markRead');
			addState('closed');
			addState('awaitingResponse');
			addState('junk');

			addEvent('newMessage').addTransitions('read,closed,awaitingResponse', 'needsAttention');
			//dump(getTransitionTable(), true);
			addEvent('view').addTransitions('needsAttention,read', 'read');
			addEvent('reply').addTransitions('read,closed', 'awaitingResponse');
			addEvent('close').addTransitions('read,awaitingResponse', 'closed', 'getCanClose').addTransitions('read,awaitingResponse', 'read', 'alwaysTrue');
			addEvent('junk').addTransitions('read,closed,awaitingResponse', 'junk');
			addEvent('unjunk').addTransitions('junk', 'closed');
		</cfscript>
	</cffunction>
	
	<cffunction name="createStateObserver" access="private" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset var state = createObject("component", "target.State").init(arguments.name) />
		<cfset instance.states[arguments.name] = state />
		<cfreturn state />
	</cffunction>
	
	
	<cffunction name="readEnteringAction" access="public" returntype="void" output="false">
    <cfargument name="obj" type="target.StateMachine" required="true" />
		<cfset obj.setReadEnter(true) />
	</cffunction>
	
	<!---
	<cffunction name="actionOnEnteredState" access="public" returntype="void" output="false">
    <cfargument name="obj" type="target.StateMachine" required="true" />
	</cffunction>
	
	<cffunction name="actionOnExitingState" access="public" returntype="void" output="false">
    <cfargument name="obj" type="target.StateMachine" required="true" />
	</cffunction> 
	--->

</cfcomponent>