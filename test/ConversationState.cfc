<cfcomponent displayname="ConversationState" extends="shade.StateMachine" output="false">
	<cfset instance = structNew() />
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="conversation" type="shade.test.Conversation" required="true" />		
		<cfset super.init(arguments.conversation, 'needingAttention', 'MyState') />
		<cfreturn this />
	</cffunction>
		
	<cffunction name="configureState" access="private" returntype="void" output="false">
		<cfscript>
			addState('needingAttention');	
			addState('read');
			addState('closed');
			addState('awaitingResponse');
			addState('filed');
			addState('junk');

			addEvent('newMessage').addTransitions('read,closed,awaitingResponse', 'needingAttention');
			addEvent('view').addTransitions('needingAttention,read', 'read');
			addEvent('reply').addTransitions('read,closed', 'awaitingResponse');
			addEvent('close').addTransitions('read,awaitingResponse', 'closed', 'getCanClose').addTransitions('read,awaitingResponse', 'read', 'alwaysTrue');
			addEvent('junk').addTransitions('read,closed,awaitingResponse', 'junk');
			addEvent('unjunk').addTransitions('junk', 'closed');
			addEvent('file').addTransitions('read,closed,awaitingResponse', 'filed');
		</cfscript>
	</cffunction>
	
	<!--- State Observer Events --->
	
	<cffunction name="beforeReadAction" access="public" returntype="void" output="false">
		<cfset getOriginalObject().setReadEnter(true) />
	</cffunction>

	<cffunction name="beforeFiledAction" access="public" returntype="boolean" output="false">
		<!--- Let's assume this event checked for the existence of a folder and failed  --->
		<cfreturn false />
	</cffunction>
	
	<cffunction name="exitReadAction" access="public" returntype="void" output="false">
		<cfset getOriginalObject().setReadExit(true) />
	</cffunction>
	
	<cffunction name="afterReadAction" access="public" returntype="void" output="false">
		<cfset getOriginalObject().setReadAfterFirstAction(true) />
		<cfset getOriginalObject().setReadAfterSecondAction(true) />
	</cffunction>

	<cffunction name="beforeNeedingAttentionAction" access="public" returntype="void" output="false">
		<cfset getOriginalObject().setNeedingAttentionEnter(true) />
	</cffunction>
	
	<cffunction name="afterNeedingAttentionAction" access="public" returntype="void" output="false">
		<cfset getOriginalObject().setNeedingAttentionAfter(true) />
	</cffunction>

	<cffunction name="afterClosedAction" access="public" returntype="void" output="false">
		<cfset getOriginalObject().setClosedAfter(true) />
	</cffunction>

</cfcomponent>